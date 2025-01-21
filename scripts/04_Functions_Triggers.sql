CREATE OR REPLACE FUNCTION public.fn_update_fecha_modificacion()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN
        	NEW.fecha_modificacion := extract('epoch' from timezone('UTC', CURRENT_TIMESTAMP))::bigint;
        RETURN NEW;
    END;
$function$
;

create trigger trg_fecha_modificacion before update on public.reserva for each row execute function fn_update_fecha_modificacion();


CREATE OR REPLACE FUNCTION public.get_availability_by_detalle_and_dates(p_detalleid int, p_fechainicio bigint, p_fechafin bigint)
 RETURNS TABLE(str_fecha varchar(20), dia_inicio bigint, dia_fin bigint, detalleid int, disponibles int, total bigint, disponible boolean)
 LANGUAGE plpgsql
AS $function$
	declare v_horainicio time := (to_timestamp(p_fechainicio) AT TIME ZONE 'UTC')::time;
	declare v_horafin time := (to_timestamp(p_fechafin)AT TIME ZONE 'UTC')::time;
	declare v_fechainicio date := (to_timestamp(p_fechainicio)AT TIME ZONE 'UTC')::date;
	declare v_fechafin date := (to_timestamp(p_fechafin)AT TIME ZONE 'UTC')::date;
BEGIN
    RETURN QUERY 
	WITH lst_dates AS 
		(SELECT generate_series(v_fechainicio, v_fechafin, '1 day'::interval)::date AS fecha)
	SELECT 	main.fecha::varchar(20) as str_fecha
			,extract('epoch' from (main.fecha + v_horainicio))::bigint AS dia_inicio
			,extract('epoch' from (main.fecha + v_horafin))::bigint AS dia_fin
			,pd.id as detalleid
			,pd.disponibles
			,count(re.id) as total
			,CASE WHEN pd.disponibles <= count(re.id) THEN false else true end as disponible
	FROM   producto_detalle pd
	JOIN   lst_dates main ON true
	LEFT JOIN reserva re ON pd.id = re.producto_detalle_id 
			AND (
					(main.fecha + v_horainicio BETWEEN (to_timestamp(re.fecha_inicio) AT TIME ZONE 'UTC') AND (to_timestamp(re.fecha_fin)AT TIME ZONE 'UTC'))
					OR
					(main.fecha + v_horafin BETWEEN (to_timestamp(re.fecha_inicio) AT TIME ZONE 'UTC') AND (to_timestamp(re.fecha_fin)AT TIME ZONE 'UTC'))
				)
	WHERE 	(pd.id = p_detalleid AND pd.es_eliminado = false)
	GROUP BY 1,2,3,4,5
	ORDER BY 1;
END;
$function$
;
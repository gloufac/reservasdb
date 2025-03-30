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
create trigger trg_fecha_modificacion before update on public.reserva_detalle for each row execute function fn_update_fecha_modificacion();
create trigger trg_producto_fecha_modificacion before update on public.producto for each row execute function fn_update_fecha_modificacion();

-- Obtener lista de hoteles con disponibilidad
CREATE OR REPLACE FUNCTION public.get_products_availability_by_dates(p_fechainicio bigint, p_fechafin bigint)
 RETURNS TABLE(id int, nombre varchar)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY 
	SELECT 	p.id as productoid, p.nombre as producto
	FROM 	producto p 
	INNER JOIN  producto_detalle pd ON p.id = pd.producto_id 
		JOIN  get_availability_by_detalle_and_dates(pd.id, p_fechainicio, p_fechafin) dispo ON dispo.disponible = true
	GROUP BY 1,2
	HAVING count(distinct pd.id) > 0
	ORDER BY 1;
END;
$function$
;


-- NUEVA VERSION: -- Obtener calendario de disponiblidad: version 2.0
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
			,CAST(pd.disponibles - coalesce(qt1.cantidad, 0) AS INT) as disponibles
			,coalesce(qt1.cantidad, 0) as total
			,CASE WHEN pd.disponibles <= coalesce(qt1.cantidad, 0) THEN false else true end as disponible
	FROM   producto_detalle pd
	JOIN   lst_dates main ON true
	LEFT JOIN (
				SELECT   rd.producto_detalle_id
						, extract('epoch' from (main.fecha + v_horainicio))::bigint AS fechaq_inicio
						, extract('epoch' from (main.fecha + v_horafin))::bigint as fechaq_fin
						, sum(rd.cantidad) as cantidad
				FROM   reserva_detalle rd
				JOIN   lst_dates main ON true
				INNER JOIN reserva re ON re.id = rd.reserva_id
				WHERE  (
							(extract('epoch' from (main.fecha + v_horainicio))::bigint BETWEEN EXTRACT(EPOCH FROM to_timestamp(re.fecha_inicio)AT TIME ZONE 'UTC')::BIGINT AND EXTRACT(EPOCH FROM to_timestamp(re.fecha_fin) AT TIME ZONE 'UTC')::BIGINT)
							OR
							(extract('epoch' from (main.fecha + v_horafin))::bigint BETWEEN EXTRACT(EPOCH FROM to_timestamp(re.fecha_inicio)AT TIME ZONE 'UTC')::BIGINT AND EXTRACT(EPOCH FROM to_timestamp(re.fecha_fin) AT TIME ZONE 'UTC')::bigint)
						)
				GROUP BY 1,2,3
			) qt1 ON qt1.producto_detalle_id = pd.id 
					AND qt1.fechaq_inicio = extract('epoch' from (main.fecha + v_horainicio))::bigint 
					AND qt1.fechaq_fin = extract('epoch' from (main.fecha + v_horafin))::bigint
	WHERE 	(pd.id = p_detalleid AND pd.es_eliminado = false)
	ORDER BY 1;
END;
$function$
;
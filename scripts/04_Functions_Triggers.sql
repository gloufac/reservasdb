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
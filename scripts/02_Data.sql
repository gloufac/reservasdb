-- =============================================================
-- ============= SPRINT 01 y 02 ================================
INSERT INTO rol(nombre_rol) VALUES('Administrador'); -- admon del sitio
INSERT INTO rol(nombre_rol) VALUES('Invitado'); -- no ha iniciado sesion
INSERT INTO rol(nombre_rol) VALUES('Cliente'); -- ha iniciado sesion y va a realizar las reservas

INSERT INTO public.capacidad (capacidad, http_get, http_post, http_update, http_delete) VALUES('Ver informacion', true, false, false, false);
INSERT INTO public.capacidad (capacidad, http_get, http_post, http_update, http_delete) VALUES('Ver y editar', true, true, true, false);
INSERT INTO public.capacidad (capacidad, http_get, http_post, http_update, http_delete) VALUES('Ver, editar, eliminar', true, true, true, true);
INSERT INTO public.capacidad (capacidad, http_get, http_post, http_update, http_delete) VALUES('Ver e insertar', true, true, false, false);
INSERT INTO public.capacidad (capacidad, http_get, http_post, http_update, http_delete) VALUES('Solo obtener', true, false, false, false);
INSERT INTO public.capacidad (capacidad, http_get, http_post, http_update, http_delete) VALUES('Solo insertar', false, true, false, false);
INSERT INTO public.capacidad (capacidad, http_get, http_post, http_update, http_delete) VALUES('Solo actualizar', false, false, true, false);
INSERT INTO public.capacidad (capacidad, http_get, http_post, http_update, http_delete) VALUES('Solo eliminar', false, false, false, true);

-- delete from permisos_api; ALTER SEQUENCE permisos_api_id_seq RESTART WITH 1;
INSERT INTO public.permisos_api ("mapping") VALUES('/api/**');
INSERT INTO public.permisos_api ("mapping") VALUES('/api/productos/**');
INSERT INTO public.permisos_api ("mapping") VALUES('/api/productos/random/**');
INSERT INTO public.permisos_api ("mapping") VALUES('/api/productos/{id}/images/**');
INSERT INTO public.permisos_api ("mapping") VALUES('/api/categorias/**');
INSERT INTO public.permisos_api ("mapping") VALUES('/api/access/**');
INSERT INTO public.permisos_api ("mapping") VALUES('/api/caracteristicas/**');
INSERT INTO public.permisos_api ("mapping") VALUES('/api/auth/login');
INSERT INTO public.permisos_api ("mapping") VALUES('/api/usuarios');
INSERT INTO public.permisos_api ("mapping") VALUES('/api/usuarios/{id}');
INSERT INTO public.permisos_api ("mapping") VALUES('/api/usuarios/**');
INSERT INTO public.permisos_api ("mapping") VALUES('/api/categorias');
INSERT INTO public.permisos_api ("mapping") VALUES('/api/usuarios/favoritos');
INSERT INTO public.permisos_api ("mapping") VALUES('/api/usuarios/favoritos/**');
INSERT INTO public.permisos_api ("mapping") VALUES('/api/usuarios/calificarproducto');
INSERT INTO public.permisos_api ("mapping") VALUES('/api/reservas/**');
INSERT INTO public.permisos_api ("mapping") VALUES('/api/moneda/**');
INSERT INTO public.permisos_api ("mapping") VALUES('/api/tipodetalle/**');
----INSERT INTO public.permisos_api ("mapping") VALUES('/api/productos/detalle'); -- post put


/************************************************************
 * -- PARA POST Y PUT ASEGURESE DE QUE CONTENGA EN EL HEADER Content-Type: application/json
 * -- cuando se asigna un permiso especifico, asegurese de que el administrador tambien lo tenga
 **************************************************************/

-- ------------------------------------------------------------------------------------------------
-- delete from rol_capacidad_api;
-- /api/productos/**
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(1, 1, 2); --ADMIN  1 Ver informacion
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(2, 1, 2); --INVITADO  1 Ver informacion
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(3, 1, 2); --CLIENTE 1 Ver informacion 

-- 3	/api/productos/random/**
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(1, 1, 3);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(2, 1, 3);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(3, 1, 3);

-- 5	/api/categorias/**
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(1, 1, 5);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(2, 1, 5);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(3, 1, 5);

-- 6	/api/access/**   TODO remover
/*INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(1, 1, 6);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(2, 1, 6);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(3, 1, 6);*/

-- 7	/api/caracteristicas/**
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(1, 1, 7);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(2, 1, 7);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(3, 1, 7);

-- 8	/api/auth/login post
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(1, 6, 8);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(2, 6, 8); -- login post
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(3, 6, 8); -- refrescar token

-- /api/usuarios/{id}
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(1, 1, 10);  -- usuario get by id
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(3, 1, 10);

-- admin todo
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(1, 3, 1);

-- crear usuario /api/usuarios
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(1, 6, 9); -- admin  crear usuario
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(2, 6, 9); -- invitado crear usuario

-- POST DELETE y GET para favoritos:: /api/usuarios/favoritos    /api/usuarios/favoritos/**
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(1, 6, 13); -- POST
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(3, 6, 13);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(1, 8, 13); -- DELETE
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(3, 8, 13);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(1, 1, 14);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(3, 1, 14);

-- POST calificar producto:: /api/usuarios/calificarproducto
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(1, 6, 15);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(3, 6, 15);

-- /api/reservas/**  POST  admin and customer
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(1, 1, 16);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(3, 1, 16);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(1, 6, 16);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(3, 6, 16);

-- 17	/api/moneda/**
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(1, 1, 17);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(2, 1, 17);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(3, 1, 17);

-- 18	/api/tipodetalle/**
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(1, 1, 18);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(2, 1, 18);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(3, 1, 18);

-- =============================================================
-- ============= SPRINT 03 =====================================
-- UPDATE caracteristica SET palabrasclave = nombre where palabrasclave  = '';

-- =============================================================
-- ============= SPRINT 04 =====================================
--- base_conversion = el dolar 2025-01-17
INSERT INTO public.moneda (moneda, base_conversion) VALUES('COP', 0.00023);
INSERT INTO public.moneda (moneda, base_conversion) VALUES('ARS', 0.00096);
INSERT INTO public.moneda (moneda, base_conversion) VALUES('MEX', 0.048);
INSERT INTO public.moneda (moneda, base_conversion) VALUES('UYU', 0.023);
INSERT INTO public.moneda (moneda, base_conversion) VALUES('PEN', 0.27);

INSERT INTO public.tipo_detalle(nombre) VALUES('Habitación');
INSERT INTO public.tipo_detalle(nombre) VALUES('Suite');
INSERT INTO public.tipo_detalle(nombre) VALUES('Estudio');
INSERT INTO public.tipo_detalle(nombre) VALUES('Apartamento');
INSERT INTO public.tipo_detalle(nombre) VALUES('Casa');

/*
 Habitación individual.
Habitación doble estándar (una cama doble)
Habitación doble estándar (dos camas separadas)
Habitación doble deluxe.
Estudio o apartamento.
Suite júnior.
Suite ejecutiva.
Suite presidencial.
 * */


-- =============================================================
-- Correccion de datos
INSERT INTO public.reserva
(codigo_reserva, usuario_id, tipo_identificacion, identificacion
	, producto_id, fecha_inicio, fecha_fin, moneda_id, utc_offset
	, precio_total, peticiones_especiales, precio_total_mostrado, fecha_creacion, fecha_modificacion)
SELECT 	min(ro.codigo_reserva), min(ro.usuario_id), min(ro.tipo_identificacion), min(ro.identificacion)
		,pd.producto_id, ro.fecha_inicio, ro.fecha_fin, min(ro.moneda_id), min(ro.utc_offset)
		, sum(ro.precio_total ), min(ro.peticiones_especiales), sum(ro.precio_total_mostrado)
		, min(ro.fecha_creacion), min(ro.fecha_modificacion)
FROM 	reserva_old ro 
INNER JOIN producto_detalle pd ON ro.producto_detalle_id = pd.id
GROUP BY pd.producto_id, ro.fecha_inicio, ro.fecha_fin
ORDER BY 1;

INSERT INTO public.reserva_detalle
(reserva_id, producto_detalle_id, cantidad_personas_adultas, cantidad_ninos, cantidad, precio)
SELECT re.id, ro.producto_detalle_id, ro.cantidad_personas_adultas, ro.cantidad_ninos, ro.cantidad_detalle, ro.precio_total
FROM  reserva re
INNER JOIN producto_detalle pro on pro.producto_id = re.producto_id
INNER JOIN reserva_old ro ON ro.producto_detalle_id = pro.id AND ro.usuario_id = re.usuario_id AND ro.fecha_inicio = re.fecha_inicio
order by ro.codigo_reserva;
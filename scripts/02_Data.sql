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
INSERT INTO public.permisos_api ("mapping") VALUES('/api/usuarios/favoritos'); -- 15
INSERT INTO public.permisos_api ("mapping") VALUES('/api/usuarios/favoritos/**'); -- 17
INSERT INTO public.permisos_api ("mapping") VALUES('/api/usuarios/calificarproducto'); -- 18


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
2 6 
-- 3	/api/productos/random/**
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(1, 1, 3);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(2, 1, 3);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(3, 1, 3);

-- 5	/api/categorias/**
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(1, 1, 5);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(2, 1, 5);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(3, 1, 5);

-- 6	/api/access/**
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(1, 1, 6);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(2, 1, 6);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(3, 1, 6);

-- 7	/api/caracteristicas/**
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(1, 1, 7);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(2, 1, 7);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(3, 1, 7);

-- 8	/api/auth/login post
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(1, 6, 8);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(2, 6, 8); -- login post
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(3, 6, 8); -- refrescar token -- TODO clase platzi 16

-- 11	/api/usuarios/{id}
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(1, 1, 11);  -- usuario get by id -- TODO aplicar seguridad solo para el usuario loqueado, no que obtenga info de otro usuario, clase 16 platzi
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(3, 1, 11); 

-- admin todo
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(1, 3, 1); 

-- crear usuario
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(1, 6, 10); -- admin  crear usuario
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(2, 6, 10); -- invitado crear usuario

-- POST DELETE y GET para favoritos
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(1, 6, 15); -- POST
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(3, 6, 15);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(1, 8, 15); -- DELETE
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(3, 8, 15);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(1, 1, 17);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(3, 1, 17);

-- POST calificar producto
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(1, 6, 18);
INSERT INTO rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) VALUES(3, 6, 18);


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

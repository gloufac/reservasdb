-- ==========================================================================================================================
-- ============= SPRINT 01 y 02 ================================

-- ---------------------- PRODUCTO --------------------------------------------------------
--drop table if exists producto;
create table producto (
	id serial4 NOT NULL,
	nombre varchar(255) default ''::character varying not null,
	descripcion text null,
	CONSTRAINT producto_pkey PRIMARY KEY (id)
);
ALTER TABLE producto ADD COLUMN categoria_id integer null;
ALTER TABLE producto ADD CONSTRAINT fk_categoria FOREIGN KEY(categoria_id) REFERENCES categoria(id);
-- ----------------------------------------------------------------------------------------

-- ---------------------- RECURSO IMAGEN --------------------------------------------------------
--drop table if exists recurso_imagen;
CREATE TABLE recurso_imagen (
	id serial4 NOT NULL,
	producto_id integer not null,
	es_imagen_principal boolean not null,
	nombre_imagen varchar(1024) NOT NULL,
	locacion_s3 varchar(512) NOT NULL,
	CONSTRAINT recursoimagen_pkey PRIMARY KEY (id)
);
CREATE INDEX pro_ix ON public.recurso_imagen USING btree (producto_id);
ALTER TABLE recurso_imagen ADD COLUMN eliminar_en_repositorio boolean default false;
ALTER TABLE recurso_imagen ADD CONSTRAINT fk_producto FOREIGN KEY(producto_id) REFERENCES producto(id);
-- ----------------------------------------------------------------------------------------

-- ---------------------- ATRIBUTOS PRODUCTO --------------------------------------------------------
-- drop table if exists categoria;
CREATE TABLE categoria (
	id serial4 NOT NULL,
	titulo varchar(100) default ''::character varying not null,
	descripcion text null,
	ruta_imagen varchar(512) NOT NULL default '',
	CONSTRAINT categoria_pkey PRIMARY KEY (id)
);

CREATE TABLE caracteristica (
	id serial4 NOT NULL,
	nombre varchar(100) default ''::character varying not null,
	ruta_imagen varchar(512) default ''::character varying not null,
	CONSTRAINT caracteristica_pkey PRIMARY KEY (id)
);

CREATE TABLE producto_caracteristica (
	producto_id integer not null,
	caracteristica_id integer not null,
	CONSTRAINT fk_producto FOREIGN KEY(producto_id) REFERENCES producto(id),
	CONSTRAINT fk_caracteristica FOREIGN KEY(caracteristica_id) REFERENCES caracteristica(id)
);
-- ----------------------------------------------------------------------------------------

-- ---------------------- PERMISOS USUARIOS --------------------------------------------------------
CREATE TABLE rol (
	id serial4 NOT NULL,
	nombre_rol varchar(100) default ''::character varying not null,
	CONSTRAINT rol_pkey PRIMARY KEY (id)
);

--DROP TABLE IF EXISTS capacidad;
CREATE TABLE capacidad (
	id serial4 NOT NULL,
	capacidad varchar(100) default ''::character varying not null,
	http_get boolean not null,
	http_post boolean not null,
	http_update boolean not null,
	http_delete boolean not null,
	CONSTRAINT capacidad_pkey PRIMARY KEY (id)
);

--drop table if exists permisos_api;
CREATE TABLE permisos_api(
	id serial4 NOT NULL,
	mapping varchar(100) default ''::character varying not null,
	CONSTRAINT permisos_api_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX permisos_api_ui ON permisos_api USING btree (mapping);

--drop table if exists rol_capacidad_api;
CREATE TABLE rol_capacidad_api(
	rol_id integer not null,
	capacidad_id integer not null,
	permisos_api_id integer not null,
	CONSTRAINT fk_rol FOREIGN KEY(rol_id) REFERENCES rol(id),
	CONSTRAINT fk_capacidad FOREIGN KEY(capacidad_id) REFERENCES capacidad(id),
	CONSTRAINT fk_permisos_api FOREIGN KEY(permisos_api_id) REFERENCES permisos_api(id)
);
CREATE UNIQUE INDEX rol_capacidad_api_ui ON rol_capacidad_api USING btree (rol_id, capacidad_id, permisos_api_id);


--drop table if exists usuario;
CREATE TABLE usuario (
	id serial4 NOT NULL,
	nombre varchar(100) default ''::character varying not null,
	apellido varchar(100) default ''::character varying not null,
	email varchar(100) default ''::character varying not null,
	password varchar(2000) not null,
	bloqueado boolean default false,
	deshabilitado boolean default false,
	CONSTRAINT usuario_pkey PRIMARY KEY (id)
);

--drop table if exists usuario_rol;
CREATE TABLE usuario_rol(
	usuario_id integer not null,
	rol_id integer not null,
	CONSTRAINT fk_usuario FOREIGN KEY(usuario_id) REFERENCES usuario(id),
	CONSTRAINT fk_rol FOREIGN KEY(rol_id) REFERENCES rol(id)
);

-- ----------------------------------------------------------------------------------------

-- ==========================================================================================================================
-- ============= SPRINT 03 =====================================
ALTER TABLE categoria add palabrasclave varchar(2000) not null default '';
ALTER TABLE caracteristica add palabrasclave varchar(2000) not null default '';
ALTER TABLE producto ADD COLUMN politica text null;
ALTER TABLE producto ADD COLUMN es_eliminado boolean default false;
ALTER TABLE categoria ADD COLUMN es_eliminado boolean default false;
ALTER TABLE usuario ADD COLUMN email_confirmado boolean default false; -- TODO: implementar BE FE
ALTER TABLE usuario ADD COLUMN es_eliminado boolean default false;
ALTER TABLE permisos_api ADD COLUMN api_orden int default 0; -- TODO revisar si se va a aplicar o no


CREATE TABLE producto_favorito (
	usuario_id integer not null,
	producto_id integer not null,
	CONSTRAINT fk_usuario FOREIGN KEY(usuario_id) REFERENCES usuario(id),
	CONSTRAINT fk_producto FOREIGN KEY(producto_id) REFERENCES producto(id)
);
CREATE UNIQUE INDEX producto_favorito_ui ON producto_favorito USING btree (usuario_id, producto_id);

-- DROP TABLE IF EXISTS producto_puntuacion;
CREATE TABLE producto_puntuacion(
	id serial4 NOT NULL,
	usuario_id integer not null,
	reserva_id int8 not null,
	producto_id integer not null,
	estrellas smallint not null,
	resena text null,
	fechapublicacion int8 not null default extract('epoch' from timezone('UTC', CURRENT_TIMESTAMP))::bigint,
	CONSTRAINT producto_puntuacion_pkey PRIMARY KEY (id),
	CONSTRAINT fk_usuario FOREIGN KEY(usuario_id) REFERENCES usuario(id),
	CONSTRAINT fk_producto FOREIGN KEY(producto_id) REFERENCES producto(id),
	CONSTRAINT fk_reserva FOREIGN KEY(reserva_id) REFERENCES reserva(id)
);
CREATE UNIQUE INDEX producto_puntuacion_ui ON producto_puntuacion USING btree (usuario_id, producto_id, reserva_id);


ALTER TABLE producto ADD COLUMN fecha_creacion int8 NOT NULL default extract('epoch' from timezone('UTC', CURRENT_TIMESTAMP))::bigint;
ALTER TABLE producto ADD COLUMN fecha_modificacion int8 null;

-- =============================================================
-- ============= SPRINT 04 =====================================
-- descripcion: pais, departamento, ciudad, direccion, codigo postal esa informacion que sea un texto
-- drop table if exists producto_direccion;
CREATE TABLE producto_direccion (
	id serial4 NOT NULL,
	producto_id int NOT NULL,
	latitud numeric(12,8) not null,
	longitud numeric(12,8) not null,
	descripcion varchar(800) not null,
	CONSTRAINT producto_direccion_pkey PRIMARY KEY (id),
	CONSTRAINT fk_producto FOREIGN KEY(producto_id) REFERENCES producto(id)
);

-- base_conversion: dolar, 1 moneda COP son 0.00023 USD 2025-01-17
CREATE TABLE moneda (
	id serial4 NOT NULL,
	moneda varchar(5) not null default '',
	base_conversion numeric(16,8) not null default 0,
	CONSTRAINT moneda_pkey PRIMARY KEY (id)
);

---- tipo_detalle: habitacion, suite ...
CREATE TABLE tipo_detalle(
	id serial4 NOT NULL,
	nombre varchar(80) default ''::character varying not null,
	CONSTRAINT tipo_detalle_pkey PRIMARY KEY (id)
);

-- habitacion 1505, capacidad 5 personas,
-- habitacion 1201, capacidad 2 personas,
-- habitacion 2105, capacidad 5 personas,  
CREATE TABLE producto_detalle (
	id serial4 NOT NULL,
	producto_id int NOT NULL, -- hotel
	tipo_detalle_id int not null, -- habitacion
	nombre varchar(80) default ''::character varying not null,
	cantidad_personas int not null,
	descripcion varchar(1000) default ''::character varying not null,
	CONSTRAINT producto_detalle_pkey PRIMARY KEY (id),
	CONSTRAINT fk_producto FOREIGN KEY(producto_id) REFERENCES producto(id),
	CONSTRAINT fk_tipo_detalle FOREIGN KEY(tipo_detalle_id) REFERENCES tipo_detalle(id)
);
ALTER TABLE producto_detalle ADD COLUMN disponibles int not null default 0; -- cantidad de habitaciones de la misma disponibles
ALTER TABLE producto_detalle ADD COLUMN moneda_id int not null;
ALTER TABLE producto_detalle ADD COLUMN precio numeric(16,3) not null default 0;
ALTER TABLE producto_detalle ADD CONSTRAINT fk_moneda FOREIGN KEY(moneda_id) REFERENCES moneda(id);

-- caracteristicas de una habitacion ejemplo
CREATE TABLE producto_detalle_caracteristica (
	producto_detalle_id integer not null,
	caracteristica_id integer not null,
	CONSTRAINT fk_producto_detalle FOREIGN KEY(producto_detalle_id) REFERENCES producto_detalle(id),
	CONSTRAINT fk_caracteristica FOREIGN KEY(caracteristica_id) REFERENCES caracteristica(id)
);
CREATE UNIQUE INDEX producto_detalle_caracteristica_ui ON producto_detalle_caracteristica USING btree (producto_detalle_id, caracteristica_id);


-- DISPONIBILIDAD --- solo por la reserva, se asume que la habitacion está siempre disponible, no se maneja indisponibilidad
-- DROP TABLE IF EXISTS reserva;
CREATE TABLE reserva (
	id bigserial NOT NULL,
	codigo_reserva varchar (50) not null,
	usuario_id integer not null,
	tipo_identificacion varchar(5) not null,
	identificacion varchar(15) not null,
	producto_id int NOT NULL,
	fecha_inicio int8 NOT NULL,
	fecha_fin int8 NOT NULL,
	moneda_id int not null,
	utc_offset varchar(15) not null default '',
	precio_total numeric(16,3) not null,
	peticiones_especiales text null,
	precio_total_mostrado numeric(16,3) not null default 0,
	fecha_creacion int8 NOT NULL default extract('epoch' from timezone('UTC', CURRENT_TIMESTAMP))::bigint,
	fecha_modificacion int8 null,
	CONSTRAINT reserva_pkey PRIMARY KEY (id),
	CONSTRAINT fk_usuario FOREIGN KEY(usuario_id) REFERENCES usuario(id),
	CONSTRAINT fk_producto FOREIGN KEY(producto_id) REFERENCES producto(id),
	CONSTRAINT fk_moneda FOREIGN KEY(moneda_id) REFERENCES moneda(id)
);
CREATE INDEX reserva_cr_ix ON public.reserva USING btree (codigo_reserva);
---CREATE UNIQUE INDEX reserva_ui ON reserva USING btree (usuario_id, producto_id, fecha_inicio);


ALTER TABLE producto_detalle ADD COLUMN es_eliminado boolean default false not null;
ALTER TABLE producto_direccion ADD COLUMN contacto_telefono varchar(30) default '' not null;
ALTER TABLE producto_direccion ADD COLUMN contacto_email varchar(80) default '' not null;

-- DROP TABLE IF EXISTS reserva_detalle;
CREATE TABLE reserva_detalle (
	id bigserial NOT NULL,
	reserva_id BIGINT NOT NULL,
	producto_detalle_id int NOT NULL,
	cantidad_personas_adultas int not null,
	cantidad_ninos int not null,
	cantidad int not null,
	precio numeric(16,3) not null,
	fecha_creacion int8 NOT NULL default extract('epoch' from timezone('UTC', CURRENT_TIMESTAMP))::bigint,
	fecha_modificacion int8 null,
	CONSTRAINT reserva_detalle_pkey PRIMARY KEY (id),
	CONSTRAINT fk_reserva FOREIGN KEY(reserva_id) REFERENCES reserva(id),
	CONSTRAINT fk_producto_detalle FOREIGN KEY(producto_detalle_id) REFERENCES producto_detalle(id)
);

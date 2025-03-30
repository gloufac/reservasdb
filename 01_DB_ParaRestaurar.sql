-- Started on 2025-03-29 22:20:36

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;
COMMENT ON SCHEMA public IS 'standard public schema';

CREATE FUNCTION public.fn_update_fecha_modificacion() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        	NEW.fecha_modificacion := extract('epoch' from timezone('UTC', CURRENT_TIMESTAMP))::bigint;
        RETURN NEW;
    END;
$$;


ALTER FUNCTION public.fn_update_fecha_modificacion() OWNER TO postgres;

CREATE FUNCTION public.get_availability_by_detalle_and_dates(p_detalleid integer, p_fechainicio bigint, p_fechafin bigint) RETURNS TABLE(str_fecha character varying, dia_inicio bigint, dia_fin bigint, detalleid integer, disponibles integer, total bigint, disponible boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.get_availability_by_detalle_and_dates(p_detalleid integer, p_fechainicio bigint, p_fechafin bigint) OWNER TO postgres;


CREATE FUNCTION public.get_products_availability_by_dates(p_fechainicio bigint, p_fechafin bigint) RETURNS TABLE(id integer, nombre character varying)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.get_products_availability_by_dates(p_fechainicio bigint, p_fechafin bigint) OWNER TO postgres;

SET default_tablespace = '';
SET default_table_access_method = heap;

CREATE TABLE public.capacidad (
    id integer NOT NULL,
    capacidad character varying(100) DEFAULT ''::character varying NOT NULL,
    http_get boolean NOT NULL,
    http_post boolean NOT NULL,
    http_update boolean NOT NULL,
    http_delete boolean NOT NULL
);


ALTER TABLE public.capacidad OWNER TO postgres;

CREATE SEQUENCE public.capacidad_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.capacidad_id_seq OWNER TO postgres;

ALTER SEQUENCE public.capacidad_id_seq OWNED BY public.capacidad.id;


CREATE TABLE public.caracteristica (
    id integer NOT NULL,
    nombre character varying(100) DEFAULT ''::character varying NOT NULL,
    ruta_imagen character varying(512),
    palabrasclave character varying(2000) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.caracteristica OWNER TO postgres;


CREATE SEQUENCE public.caracteristica_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.caracteristica_id_seq OWNER TO postgres;


ALTER SEQUENCE public.caracteristica_id_seq OWNED BY public.caracteristica.id;


CREATE TABLE public.categoria (
    id integer NOT NULL,
    titulo character varying(100) DEFAULT ''::character varying NOT NULL,
    descripcion text,
    ruta_imagen character varying(512),
    palabrasclave character varying(2000) DEFAULT ''::character varying NOT NULL,
    es_eliminado boolean DEFAULT false
);


ALTER TABLE public.categoria OWNER TO postgres;


CREATE SEQUENCE public.categoria_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categoria_id_seq OWNER TO postgres;


ALTER SEQUENCE public.categoria_id_seq OWNED BY public.categoria.id;


CREATE TABLE public.moneda (
    id integer NOT NULL,
    moneda character varying(5) DEFAULT ''::character varying NOT NULL,
    base_conversion numeric(16,8) DEFAULT 0 NOT NULL
);


ALTER TABLE public.moneda OWNER TO postgres;

CREATE SEQUENCE public.moneda_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.moneda_id_seq OWNER TO postgres;


ALTER SEQUENCE public.moneda_id_seq OWNED BY public.moneda.id;


CREATE TABLE public.permisos_api (
    id integer NOT NULL,
    mapping character varying(100) DEFAULT ''::character varying NOT NULL,
    api_orden integer DEFAULT 0
);


ALTER TABLE public.permisos_api OWNER TO postgres;


CREATE SEQUENCE public.permisos_api_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.permisos_api_id_seq OWNER TO postgres;


ALTER SEQUENCE public.permisos_api_id_seq OWNED BY public.permisos_api.id;


CREATE TABLE public.producto (
    id integer NOT NULL,
    nombre character varying(255) DEFAULT ''::character varying NOT NULL,
    descripcion character varying(255),
    categoria_id integer,
    politica text,
    es_eliminado boolean DEFAULT false,
    fecha_creacion bigint DEFAULT (date_part('epoch'::text, timezone('UTC'::text, CURRENT_TIMESTAMP)))::bigint NOT NULL,
    fecha_modificacion bigint
);


ALTER TABLE public.producto OWNER TO postgres;


CREATE TABLE public.producto_caracteristica (
    producto_id integer NOT NULL,
    caracteristica_id integer NOT NULL
);


ALTER TABLE public.producto_caracteristica OWNER TO postgres;


CREATE TABLE public.producto_detalle (
    id integer NOT NULL,
    producto_id integer NOT NULL,
    tipo_detalle_id integer NOT NULL,
    nombre character varying(80) DEFAULT ''::character varying NOT NULL,
    cantidad_personas integer NOT NULL,
    descripcion character varying(1000) DEFAULT ''::character varying NOT NULL,
    disponibles integer NOT NULL,
    moneda_id integer NOT NULL,
    precio numeric(16,3) DEFAULT 0 NOT NULL,
    es_eliminado boolean DEFAULT false NOT NULL
);


ALTER TABLE public.producto_detalle OWNER TO postgres;

CREATE TABLE public.producto_detalle_caracteristica (
    producto_detalle_id integer NOT NULL,
    caracteristica_id integer NOT NULL
);


ALTER TABLE public.producto_detalle_caracteristica OWNER TO postgres;

CREATE SEQUENCE public.producto_detalle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.producto_detalle_id_seq OWNER TO postgres;


ALTER SEQUENCE public.producto_detalle_id_seq OWNED BY public.producto_detalle.id;



CREATE TABLE public.producto_direccion (
    id integer NOT NULL,
    producto_id integer NOT NULL,
    latitud numeric(12,8) NOT NULL,
    longitud numeric(12,8) NOT NULL,
    descripcion character varying(800) NOT NULL,
    contacto_telefono character varying(30) DEFAULT ''::character varying NOT NULL,
    contacto_email character varying(80) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.producto_direccion OWNER TO postgres;


CREATE SEQUENCE public.producto_direccion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.producto_direccion_id_seq OWNER TO postgres;



ALTER SEQUENCE public.producto_direccion_id_seq OWNED BY public.producto_direccion.id;


CREATE TABLE public.producto_favorito (
    usuario_id integer NOT NULL,
    producto_id integer NOT NULL
);


ALTER TABLE public.producto_favorito OWNER TO postgres;


CREATE SEQUENCE public.producto_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.producto_id_seq OWNER TO postgres;



ALTER SEQUENCE public.producto_id_seq OWNED BY public.producto.id;



CREATE TABLE public.producto_puntuacion (
    id integer NOT NULL,
    usuario_id integer NOT NULL,
    reserva_id bigint NOT NULL,
    producto_id integer NOT NULL,
    estrellas smallint NOT NULL,
    resena text,
    fechapublicacion bigint DEFAULT (date_part('epoch'::text, timezone('UTC'::text, CURRENT_TIMESTAMP)))::bigint NOT NULL
);


ALTER TABLE public.producto_puntuacion OWNER TO postgres;


CREATE SEQUENCE public.producto_puntuacion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.producto_puntuacion_id_seq OWNER TO postgres;


ALTER SEQUENCE public.producto_puntuacion_id_seq OWNED BY public.producto_puntuacion.id;



CREATE TABLE public.recurso_imagen (
    id integer NOT NULL,
    producto_id integer NOT NULL,
    es_imagen_principal boolean NOT NULL,
    nombre_imagen character varying(1024) NOT NULL,
    locacion_s3 character varying(512) NOT NULL,
    eliminar_en_repositorio boolean DEFAULT false
);


ALTER TABLE public.recurso_imagen OWNER TO postgres;


CREATE SEQUENCE public.recurso_imagen_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.recurso_imagen_id_seq OWNER TO postgres;


ALTER SEQUENCE public.recurso_imagen_id_seq OWNED BY public.recurso_imagen.id;




CREATE TABLE public.reserva (
    id bigint NOT NULL,
    codigo_reserva character varying(50) NOT NULL,
    usuario_id integer NOT NULL,
    tipo_identificacion character varying(5) NOT NULL,
    identificacion character varying(15) NOT NULL,
    producto_id integer NOT NULL,
    fecha_inicio bigint NOT NULL,
    fecha_fin bigint NOT NULL,
    moneda_id integer NOT NULL,
    utc_offset character varying(15) DEFAULT ''::character varying NOT NULL,
    precio_total numeric(16,3) NOT NULL,
    peticiones_especiales text,
    precio_total_mostrado numeric(16,3) DEFAULT 0 NOT NULL,
    fecha_creacion bigint DEFAULT (date_part('epoch'::text, timezone('UTC'::text, CURRENT_TIMESTAMP)))::bigint NOT NULL,
    fecha_modificacion bigint
);


ALTER TABLE public.reserva OWNER TO postgres;


CREATE TABLE public.reserva_detalle (
    id bigint NOT NULL,
    reserva_id bigint NOT NULL,
    producto_detalle_id integer NOT NULL,
    cantidad_personas_adultas integer NOT NULL,
    cantidad_ninos integer NOT NULL,
    cantidad integer NOT NULL,
    precio numeric(16,3) NOT NULL,
    fecha_creacion bigint DEFAULT (date_part('epoch'::text, timezone('UTC'::text, CURRENT_TIMESTAMP)))::bigint NOT NULL,
    fecha_modificacion bigint
);


ALTER TABLE public.reserva_detalle OWNER TO postgres;



CREATE SEQUENCE public.reserva_detalle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reserva_detalle_id_seq OWNER TO postgres;


ALTER SEQUENCE public.reserva_detalle_id_seq OWNED BY public.reserva_detalle.id;


CREATE SEQUENCE public.reserva_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reserva_id_seq1 OWNER TO postgres;

ALTER SEQUENCE public.reserva_id_seq1 OWNED BY public.reserva.id;


CREATE TABLE public.rol (
    id integer NOT NULL,
    nombre_rol character varying(100) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.rol OWNER TO postgres;


CREATE TABLE public.rol_capacidad_api (
    rol_id integer NOT NULL,
    capacidad_id integer NOT NULL,
    permisos_api_id integer NOT NULL
);


ALTER TABLE public.rol_capacidad_api OWNER TO postgres;



CREATE SEQUENCE public.rol_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rol_id_seq OWNER TO postgres;



ALTER SEQUENCE public.rol_id_seq OWNED BY public.rol.id;



CREATE TABLE public.tipo_detalle (
    id integer NOT NULL,
    nombre character varying(80) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.tipo_detalle OWNER TO postgres;


CREATE SEQUENCE public.tipo_detalle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tipo_detalle_id_seq OWNER TO postgres;



ALTER SEQUENCE public.tipo_detalle_id_seq OWNED BY public.tipo_detalle.id;


CREATE TABLE public.usuario (
    id integer NOT NULL,
    nombre character varying(100) DEFAULT ''::character varying NOT NULL,
    apellido character varying(100) DEFAULT ''::character varying NOT NULL,
    email character varying(100) DEFAULT ''::character varying NOT NULL,
    password character varying(2000) NOT NULL,
    bloqueado boolean DEFAULT false,
    deshabilitado boolean DEFAULT false,
    es_eliminado boolean DEFAULT false,
    email_confirmado boolean DEFAULT false
);


ALTER TABLE public.usuario OWNER TO postgres;


CREATE SEQUENCE public.usuario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuario_id_seq OWNER TO postgres;


ALTER SEQUENCE public.usuario_id_seq OWNED BY public.usuario.id;


CREATE TABLE public.usuario_rol (
    usuario_id integer NOT NULL,
    rol_id integer NOT NULL
);


ALTER TABLE public.usuario_rol OWNER TO postgres;


CREATE VIEW public.vw_permisos_api AS
 SELECT row_number() OVER (ORDER BY rol.id, asi.mapping) AS row_id,
    rol.nombre_rol,
    asi.mapping,
    ca.http_get,
    ca.http_post,
    ca.http_update,
    ca.http_delete
   FROM (((public.rol_capacidad_api rcs
     JOIN public.permisos_api asi ON ((rcs.permisos_api_id = asi.id)))
     JOIN public.capacidad ca ON ((ca.id = rcs.capacidad_id)))
     JOIN public.rol ON ((rol.id = rcs.rol_id)))
  ORDER BY (length((asi.mapping)::text)) DESC, asi.mapping, ca.http_get, ca.http_post, ca.http_update, ca.http_delete;


ALTER TABLE public.vw_permisos_api OWNER TO postgres;


CREATE VIEW public.vw_producto_puntuacion AS
 SELECT pr.id AS producto_id,
    round(avg(COALESCE((pp.estrellas)::integer, 0)), 2) AS promedio,
    count(pp.id) AS total
   FROM (public.producto pr
     LEFT JOIN public.producto_puntuacion pp ON ((pp.producto_id = pr.id)))
  GROUP BY pr.id;


ALTER TABLE public.vw_producto_puntuacion OWNER TO postgres;


ALTER TABLE ONLY public.capacidad ALTER COLUMN id SET DEFAULT nextval('public.capacidad_id_seq'::regclass);
ALTER TABLE ONLY public.caracteristica ALTER COLUMN id SET DEFAULT nextval('public.caracteristica_id_seq'::regclass);
ALTER TABLE ONLY public.categoria ALTER COLUMN id SET DEFAULT nextval('public.categoria_id_seq'::regclass);
ALTER TABLE ONLY public.moneda ALTER COLUMN id SET DEFAULT nextval('public.moneda_id_seq'::regclass);
ALTER TABLE ONLY public.permisos_api ALTER COLUMN id SET DEFAULT nextval('public.permisos_api_id_seq'::regclass);
ALTER TABLE ONLY public.producto ALTER COLUMN id SET DEFAULT nextval('public.producto_id_seq'::regclass);
ALTER TABLE ONLY public.producto_detalle ALTER COLUMN id SET DEFAULT nextval('public.producto_detalle_id_seq'::regclass);
ALTER TABLE ONLY public.producto_direccion ALTER COLUMN id SET DEFAULT nextval('public.producto_direccion_id_seq'::regclass);
ALTER TABLE ONLY public.producto_puntuacion ALTER COLUMN id SET DEFAULT nextval('public.producto_puntuacion_id_seq'::regclass);
ALTER TABLE ONLY public.recurso_imagen ALTER COLUMN id SET DEFAULT nextval('public.recurso_imagen_id_seq'::regclass);
ALTER TABLE ONLY public.reserva ALTER COLUMN id SET DEFAULT nextval('public.reserva_id_seq1'::regclass);
ALTER TABLE ONLY public.reserva_detalle ALTER COLUMN id SET DEFAULT nextval('public.reserva_detalle_id_seq'::regclass);
ALTER TABLE ONLY public.rol ALTER COLUMN id SET DEFAULT nextval('public.rol_id_seq'::regclass);
ALTER TABLE ONLY public.tipo_detalle ALTER COLUMN id SET DEFAULT nextval('public.tipo_detalle_id_seq'::regclass);
ALTER TABLE ONLY public.usuario ALTER COLUMN id SET DEFAULT nextval('public.usuario_id_seq'::regclass);



COPY public.capacidad (id, capacidad, http_get, http_post, http_update, http_delete) FROM stdin;
1	Ver informacion	t	f	f	f
2	Ver y editar	t	t	t	f
3	Ver, editar, eliminar	t	t	t	t
4	Ver e insertar	t	t	f	f
6	Solo insertar	f	t	f	f
7	Solo actualizar	f	f	t	f
8	Solo eliminar	f	f	f	t
\.


--
-- TOC entry 3071 (class 0 OID 611349)
-- Dependencies: 209
-- Data for Name: caracteristica; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.caracteristica (id, nombre, ruta_imagen, palabrasclave) FROM stdin;
11	Ventilación	admon/20250114081559225_9b0712878a145414.svg	Ventilador / Ventilación / Ventilacion
4	Bar	admon/20250106193334657_03db195c844a38a4.svg	Bar / Coctel / servicios de licorería / Cóctel
17	Parqueadero	admon/20250114083455534_aead8933c7529128.svg	Parqueadero / Parquear
18	Restaurante	admon/20250114083543256_8b193866ea489f97.svg	Restaurante / Plaza de comida / Comida
14	Permitido fumar	admon/20250114083054115_74f6063c656234bc.svg	Permitido Fumar / Fumar / Fumador / Fumadores
15	Champaña	admon/20250114083326906_68cd9f0772b479bb.svg	Champaña / Vino / licores
16	Ducha privada	admon/20250114083416028_d795f1ca84a709b0.svg	Ducha Privada / baño privado
7	Mascotas	admon/20250111004010193_701dcaca42b3bef2.svg	Mascota / Mascotas / Gatos / Perros / permite mascotas
5	Wi-Fi	admon/20250110185002360_f085d2368b2908c2.svg	Wi-Fi / WiFi / Wi Fi
20	Vista al mar	admon/20250114165456521_274fe9e986c63f9f.svg	Vista al mar / vista mar
9	Serv. de habitación	admon/20250111004101760_6f5ac9ad4049f729.svg	Servicios de habitación / conserje / servicio habitación
8	Permite niños	admon/20250111004033559_0c52525fcb3010c3.svg	Niños / Niñas / Bebés / Bebé / Niño / Niña / se permiten niños
1	Avión	admon/20250106165532938_1eedf1b2ab33f66e.svg	Avión / Avion / Vuelo
2	Cama	admon/20250106171217077_9641b3f552e268e7.svg	Cama
3	Piscina	admon/20250110183223585_76eb7ddb8c46d828.svg	Piscina
6	Vestido	admon/20250110232450276_61330fc5450240c8.svg	Vestido
10	Vista montaña	admon/20250111004117565_b728c48f4c8b047e.svg	Vista montaña
13	Spa	admon/20250114083012645_8266661201222cc4.svg	Spa
19	Desayuno	admon/20250114083607940_a70373819ac5973d.svg	Desayuno
12	Televisión	admon/20250114082912223_84d76d4d1425443e.svg	Television / TV / Televisión
\.


--
-- TOC entry 3069 (class 0 OID 611337)
-- Dependencies: 207
-- Data for Name: categoria; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categoria (id, titulo, descripcion, ruta_imagen, palabrasclave, es_eliminado) FROM stdin;
8	test 2	sfasdfsa	admon/20250328205753499_68cd9f0772b479bb.svg	sadsadsad	t
10	sdsadas	sadsadasd	admon/20250328210428668_b728c48f4c8b047e.svg	sadsadsa	t
13	21fdsfsdfsr	sfsadfs	admon/20250328210633122_8b193866ea489f97.svg	fasd	t
12	3435fsdfs	sdfsdfsdf	admon/20250328210555048_d64a211f46fec0cc.svg	sdfsdfsdfsd	t
11	sd345gsdfsd	fsdfsdf	admon/20250328210520452_77247ebc0aa01c4c.svg	sdfsdf	t
9	test 3	adfasdasd	admon/20250328205959599_6f5ac9ad4049f729.svg	aasdsadasd	t
7	Categoria test	test	admon/20250328205717242_9641b3f552e268e7.svg	test	t
14	werwrsfdsa miau	sadfsadfadsf	admon/20250328210744064_6f5ac9ad4049f729.svg	sadfasdfsad	t
15	Categoria 15	Test delete	admon/20250328212951778_25cb68b81fdd37b2.jpg	delete	t
5	Alquiler de ropa	Alquiler de ropa, vestidos, esmoquin	admon/20250114084357639_2c0a9f5516f395be.svg	ropa / vestido / vestidos / trajes / esmoquin / smoking	f
6	Transporte	Servicio de transporte. Alquiler carro.	admon/20250110000214801_c42e58f88d7d8f2a.jpg	Transporte / Servicios de conduccion / conducción / Carro / Ban	f
4	Hostal	Hostales con habitaciones, cocina compartida o baño compartido.	admon/20250114084057329_ff174e0cd1ed0f5a.png	Hostal / Compartido	f
3	Hotel	Hospedaje en hotel ó alquiler de casa ó alquiler de cabaña	admon/20250106201213799_fbd780753966d09e.jpg	Hotel / Habitación / Habitacion / Cabaña / Casa	f
16	sdfsdf	sdfsdfsd	admon/20250328232152147_c786170083f68068.jpg	fsdfsdf	t
\.


--
-- TOC entry 3089 (class 0 OID 612005)
-- Dependencies: 228
-- Data for Name: moneda; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.moneda (id, moneda, base_conversion) FROM stdin;
1	COP	0.00023000
2	ARS	0.00096000
3	MEX	0.04800000
4	UYU	0.02300000
5	PEN	0.27000000
\.


--
-- TOC entry 3081 (class 0 OID 611650)
-- Dependencies: 219
-- Data for Name: permisos_api; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permisos_api (id, mapping, api_orden) FROM stdin;
1	/api/**	0
2	/api/productos/**	0
3	/api/productos/random/**	0
4	/api/productos/{id}/images/**	0
5	/api/categorias/**	0
6	/api/access/**	0
7	/api/caracteristicas/**	0
8	/api/auth/login	0
9	/api/usuarios	0
10	/api/usuarios/{id}	0
11	/api/usuarios/**	0
12	/api/categorias	0
13	/api/usuarios/favoritos	0
14	/api/usuarios/favoritos/**	0
15	/api/usuarios/calificarproducto	0
16	/api/reservas/**	0
17	/api/moneda/**	0
18	/api/tipodetalle/**	0
\.


--
-- TOC entry 3065 (class 0 OID 611127)
-- Dependencies: 203
-- Data for Name: producto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.producto (id, nombre, descripcion, categoria_id, politica, es_eliminado, fecha_creacion, fecha_modificacion) FROM stdin;
47	Hotel Lago Azul	Hotel con habitaciones, suites, penthouse.	3	Hora llegada: 3pm	f	1741184142	1741633616
1	Hotel Sunset 5	Calle falsa # 15-35, Las Flores, Cartagena, Colombia	3	**Hora de llegada**\nLa hora de llegada es a las 3pm.	f	1741184142	1742173972
38	Sin Caracteristicas	Sin caracteristicas.\nNi producto detalle.	4	No borrar	f	1741184142	1743207660
48	test web	tetst web	5		t	1741184142	1743207693
45	Producto 2025-01-09-1	test from postman UPDATE	15		t	1741184142	1743222061
30	Hostal Descanso Viajeros	Habitación compartida, una cama un televisor.\nBaño compartido.	4		f	1741184142	1743293782
44	Ropa elegante	test from postman 6	5		f	1741184142	1743302550
51	Alquiler autos Transporte YA	Alquile vehículos para sus viajes a un precio cómodo.	6	**Pago del 50%**\nSe debe efectuar este pago por adelantado.	f	1743302882	\N
46	ALQ - Ropa de lujo	ropa para cenas	5		f	1741184142	1741186036
26	Alquiler vestido elegante	Vestido para fiestas	5		f	1741184142	1741186036
27	Hostal las margaritas	Habitacion sencilla\nCon cocina compartida\nSin piscina	4		f	1741184142	1741186036
42	Producto test	test from postman 1-2	4		f	1741184142	1741186036
32	Un solo sofa cama	Sofa cama con televisor	4		f	1741184142	1741186036
34	Lujo de muebles	Adquiera estos muebles de lujo	4		f	1741184142	1741186036
37	Cabaña	Lujosa cabaña en el mar con comida.\nCon la mayoria de las comodidades	3		f	1741184142	1741186036
2	Plaza Huizhou	En Crowne Plaza Huizhou, an IHG Hotel\r\nCon solo piscina sin bar	3		f	1741184142	1741186036
31	Habitacion sencilla	Habitacion una cama un televisor	3		f	1741184142	1741186036
33	Habitacion cama sencilla	Habitacion con cama sencilla, ventilador, desayuno incluido.\nVista al mar lo mejor	3		f	1741184142	1741186036
29	Hotel Reserve Cartagena	Cuenta con habitaciones de lujo con piscina y bar, y otros servicios más.\nComodidad y descanso.	3	**Ingreso hotel**\nLorem ipsum dolor sit amet consectetur adipiscing, elit conubia pretium libero rutrum bibendum sagittis, varius nec nunc cum volutpat eu, scelerisque mi nibh turpis eget. Accumsan sociosqu habitasse ultrices at leo montes ad taciti iaculis torquent, faucibus nunc morbi libero ornare scelerisque tortor felis porta nisi nec, nullam facilisi imperdiet eros natoque aenean conubia a lobortis. Faucibus suspendisse laoreet quis montes ultrices venenatis integer, posuere mi lectus bibendum fermentum maecenas, fringilla massa porta taciti sed turpis. Sagittis arcu fringilla luctus semper ad accumsan lobortis turpis pretium pulvinar, pellentesque vestibulum dis porta vitae leo montes nostra class, est conubia habitasse nascetur aenean placerat primis massa fusce.\n\n**Hora parqueadero**\nDiam tempor cubilia vivamus convallis neque ac vel faucibus habitasse duis nulla platea, mauris elementum nascetur volutpat augue nostra dapibus interdum tristique per. Aliquam est litora maecenas elementum cras cum luctus aenean suscipit, sed conubia rhoncus felis mattis enim himenaeos pulvinar turpis ridiculus, interdum semper massa mus per pretium dis risus. Suspendisse penatibus facilisi in cras faucibus phasellus bibendum class ac, convallis mus pharetra luctus ante id proin sapien aptent, per felis nibh aenean a varius fames malesuada. Eleifend in consequat et risus commodo rutrum molestie aliquet aliquam, eget enim nisl congue justo lectus vehicula praesent orci bibendum, metus urna ac montes aenean magna sociis at.\n\n**Hotel Reserve**\nLe agradecemos...	f	1741184142	1743281475
50	Hotel Descanso Sunset	Hotel descanso	3	**Ingreso**\n5pm	f	1743198293	1743293722
49	Hotel Montain View	Hotel para familias	3	**Horario de ingreso**\n3:00 pm a 10:00 pm COT (Colombia Time)\n\n**Hora de salida**\n11:00 am COT (Colombia Time)\n\n**Precauciones**\nUsted será contactado por el número de contacto y el email que aparecen en la información del producto. Si llega a ser contactado por otro teléfono o email, no somos responsables de que usted brinde información a detalle de contacto no autorizada.\n\n**Bienvenido**\nLo esperamos pronto.	f	1743137750	1743270974
40	Hotel Reserve San Andrés	5 imagenes. Muchas caracteristicas.\n2	3	**Ingreso hotel**\nLorem ipsum dolor sit amet consectetur adipiscing, elit conubia pretium libero rutrum bibendum sagittis, varius nec nunc cum volutpat eu, scelerisque mi nibh turpis eget. Accumsan sociosqu habitasse ultrices at leo montes ad taciti iaculis torquent, faucibus nunc morbi libero ornare scelerisque tortor felis porta nisi nec, nullam facilisi imperdiet eros natoque aenean conubia a lobortis. Faucibus suspendisse laoreet quis montes ultrices venenatis integer, posuere mi lectus bibendum fermentum maecenas, fringilla massa porta taciti sed turpis. Sagittis arcu fringilla luctus semper ad accumsan lobortis turpis pretium pulvinar, pellentesque vestibulum dis porta vitae leo montes nostra class, est conubia habitasse nascetur aenean placerat primis massa fusce.\n\n**Parqueadero**\nDiam tempor cubilia vivamus convallis neque ac vel faucibus habitasse duis nulla platea, mauris elementum nascetur volutpat augue nostra dapibus interdum tristique per. Aliquam est litora maecenas elementum cras cum luctus aenean suscipit, sed conubia rhoncus felis mattis enim himenaeos pulvinar turpis ridiculus, interdum semper massa mus per pretium dis risus. Suspendisse penatibus facilisi in cras faucibus phasellus bibendum class ac, convallis mus pharetra luctus ante id proin sapien aptent, per felis nibh aenean a varius fames malesuada. Eleifend in consequat et risus commodo rutrum molestie aliquet aliquam, eget enim nisl congue justo lectus vehicula praesent orci bibendum, metus urna ac montes aenean magna sociis at.\n\n**Uso de zonas comunes**\nDiam tempor cubilia vivamus convallis neque ac vel faucibus habitasse duis nulla platea, mauris elementum nascetur volutpat augue nostra dapibus interdum tristique per. Aliquam est litora maecenas elementum cras cum luctus aenean suscipit, sed conubia rhoncus felis mattis enim himenaeos pulvinar turpis ridiculus, interdum semper massa mus per pretium dis risus.	f	1741184142	1741192226
\.


--
-- TOC entry 3072 (class 0 OID 611361)
-- Dependencies: 210
-- Data for Name: producto_caracteristica; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.producto_caracteristica (producto_id, caracteristica_id) FROM stdin;
49	18
49	3
49	10
49	13
49	19
29	4
29	17
29	18
29	7
42	3
42	1
29	5
29	9
29	8
29	3
50	11
30	2
30	12
44	6
46	6
51	11
47	17
47	1
26	6
47	2
27	16
27	2
27	19
45	1
45	2
37	4
37	14
37	7
37	8
37	5
37	2
37	3
37	10
2	3
2	5
2	6
31	2
31	12
33	2
33	11
33	19
40	11
40	17
40	16
40	5
40	9
40	3
2	17
2	18
2	2
1	11
1	17
1	16
1	2
1	3
\.


--
-- TOC entry 3087 (class 0 OID 611964)
-- Dependencies: 226
-- Data for Name: producto_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.producto_detalle (id, producto_id, tipo_detalle_id, nombre, cantidad_personas, descripcion, disponibles, moneda_id, precio, es_eliminado) FROM stdin;
9	27	1	retetsdfds	3		5	1	580000.000	f
2	47	3	Estudio	1	Precio por noche y por persona	3	1	350000.000	f
8	47	1	Habitación sencilla	1	Precio por noche por persona	2	1	400000.000	f
1	47	1	Habitación doble	2	Habitación para 2 personas. Puede incluir cuna para bebés.	3	1	500000.000	f
10	1	1	Habitación doble	2	Precio por persona y por noche	2	1	450000.000	f
11	1	1	Habitación sencilla	2	Precio por noche y por persona.	5	1	450000.000	f
12	49	1	Suite Principal	5	Suite de lujo precio por persona y por noche.	2	1	1000000.000	f
13	49	1	Habitación con cama doble	2	Precio por persona y por noche	5	1	301000.000	f
14	45	1	Habitacsd	5	sddsklfmsdlk	5	1	555.000	t
6	29	1	Suite de Lujo	2	precio por noche y por persona	5	1	1600000.000	f
3	29	1	Habitación sencilla	2	Habitación para 2 personas. Puede incluir cuna para bebés.	3	1	300000.000	f
7	29	1	Habitacion doble	3	precio por una noche y por persona	2	1	500000.000	f
15	50	1	Double Room	2	Precio por persona y por nooche	5	1	121500.000	f
\.


--
-- TOC entry 3090 (class 0 OID 612031)
-- Dependencies: 229
-- Data for Name: producto_detalle_caracteristica; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.producto_detalle_caracteristica (producto_detalle_id, caracteristica_id) FROM stdin;
14	18
13	17
13	16
13	5
13	9
13	19
13	12
12	11
12	4
12	15
12	16
12	8
12	5
12	20
12	19
12	12
6	11
6	17
6	14
6	15
6	16
6	8
6	5
6	9
6	19
6	12
7	16
7	8
7	19
7	12
3	11
3	8
3	2
3	19
3	12
15	18
15	19
\.


--
-- TOC entry 3092 (class 0 OID 612092)
-- Dependencies: 231
-- Data for Name: producto_direccion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.producto_direccion (id, producto_id, latitud, longitud, descripcion, contacto_telefono, contacto_email) FROM stdin;
11	47	5.55173800	-72.86747800	Hotel Lago Azul	3123121212	lagoazul@test.test
17	45	15.00000000	15.00000000	calle falsa	3101231213	test@test.com
21	38	-13.01077900	-38.50622477	Calle falsa	3191231213	test@test.com
27	49	11.24878278	-74.21252439	Calle 154 Oeste 5	3101231213	montaintest@test.com
28	29	10.34552765	-75.48011141	Calle 74 variante mamonal	3101231212	test@test.com
29	50	-13.01141869	-38.49159257	calle falsa	3101231213	test@test.com
30	30	10.36520705	-75.54193249	En el oceano	3151231213	test@test.com
31	44	4.84421969	-75.65787020	Calle 154	31512312123	test@test.com
32	46	4.81736602	-75.67950364	Calle	3101212123	test@test.com
33	51	4.82728559	-75.69151986	Calle	3121231212	test@test.com
\.


--
-- TOC entry 3083 (class 0 OID 611799)
-- Dependencies: 221
-- Data for Name: producto_favorito; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.producto_favorito (usuario_id, producto_id) FROM stdin;
7	30
1	29
1	47
1	40
10	29
10	49
1	49
19	49
19	1
17	49
\.


--
-- TOC entry 3100 (class 0 OID 612457)
-- Dependencies: 239
-- Data for Name: producto_puntuacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.producto_puntuacion (id, usuario_id, reserva_id, producto_id, estrellas, resena, fechapublicacion) FROM stdin;
1	10	15	47	4	Hotel Lago Azul 4 stars	1742483399
3	1	40	29	3	Le dí 3 estrellas	1743271863
5	1	20	47	4	Personal my bien super atendidos muy buen servicio	1743280747
4	1	41	29	5	Me gustó la atencion al cliente	1743280385
2	1	17	47	4	Muy bueno el hotel, para familias es super	1742491008
\.


--
-- TOC entry 3067 (class 0 OID 611313)
-- Dependencies: 205
-- Data for Name: recurso_imagen; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recurso_imagen (id, producto_id, es_imagen_principal, nombre_imagen, locacion_s3, eliminar_en_repositorio) FROM stdin;
86	34	t	pexels-pixabay-276724.jpg	image/20250214123934490_6e27d145a8cf644d.jpg	f
87	34	t	pexels-pixabay-259962.jpg	image/20250214123950072_78ccc0d928864445.jpg	f
88	34	t	pexels-fotoaibe-1669799.jpg	image/20250214124006721_7c76ed62a673ff28.jpg	f
89	1	t	pexels-fotoaibe-1743229.jpg	image/20250214124135105_91d0681159af66eb.jpg	f
90	1	f	pexels-fotoaibe-1743231.jpg	image/20250214124135106_f24f3ab889deb6b5.jpg	f
91	40	f	pexels-pixabay-210265.jpg	image/20250214124422747_fba0c0e7810ce6ec.jpg	f
92	40	f	pexels-asadphoto-3293192.jpg	image/20250214124422751_f9f218118a9af10d.jpg	f
93	40	t	pexels-curtis-adams-1694007-11018287.jpg	image/20250214124422750_25b0c2dc31dfce7a.jpg	f
94	40	f	pexels-pixabay-275484.jpg	image/20250214124422759_854785204c832911.jpg	f
95	40	f	pexels-pixabay-259962.jpg	image/20250214124422747_78ccc0d928864445.jpg	f
96	29	f	pexels-thorsten-technoman-109353-338504.jpg	image/20250214124736548_0acac70dc4743554.jpg	f
97	29	f	pexels-pixabay-261102.jpg	image/20250214124736548_fb61a1470aa564fd.jpg	f
99	37	f	pexels-pixabay-221457.jpg	image/20250214125354476_f7e65708a56ecbe8.jpg	f
100	37	f	pexels-andreaedavis-10658143.jpg	image/20250214125354477_468de55c1ceeefc1.jpg	f
101	37	t	pexels-leorossatti-2598638.jpg	image/20250214125354477_fb5d371c27b269a5.jpg	f
102	37	f	pexels-pixabay-261101.jpg	image/20250214125354476_949d69f277629057.jpg	f
104	48	t	pexels-alexander-f-ungerer-157458816-21701838.jpg	image/20250214210818018_c786170083f68068.jpg	f
105	30	t	alsace-1410460_960_720.jpg	image/20250305090708636_f0b4738f4e087b0d.jpg	f
106	30	f	pexels-pixabay-210265.jpg	image/20250305090708637_fba0c0e7810ce6ec.jpg	f
108	49	f	pexels-leorossatti-2598638.jpg	image/20250327235549982_fb5d371c27b269a5.jpg	f
109	49	f	pexels-pixabay-261101.jpg	image/20250327235549982_949d69f277629057.jpg	f
42	31	t	pexels-pixabay-276724.jpg	image/20241227161924392_77fec43c7708e43a.jpg	f
43	2	t	pexels-curtis-adams-1694007-11018287.jpg	image/20241227162122550_3ffa2e2f52ea55f0.jpg	f
46	33	f	pexels-alexander-f-ungerer-157458816-21701838.jpg	image/20241228201640130_188eb5eb257219b6.jpg	f
47	33	t	pexels-asadphoto-3293192.jpg	image/20241228201640146_ef3089c797008221.jpg	f
126	47	f	pexels-leorossatti-2598638.jpg	image/20250328002457833_fb5d371c27b269a5.jpg	f
127	47	f	pexels-asadphoto-3293192.jpg	image/20250328002457833_f9f218118a9af10d.jpg	f
128	47	t	pexels-pixabay-221457.jpg	image/20250328002457833_f7e65708a56ecbe8.jpg	f
129	50	t	alsace-1410460_960_720.jpg	image/20250328164453345_f0b4738f4e087b0d.jpg	f
130	45	t	pexels-israwmx-29226498.jpg	image/20250328213119999_25cb68b81fdd37b2.jpg	f
131	49	t	pexels-athena-1586795.jpg	image/20250329160524574_ba486677a0b7ccfc.jpg	f
132	49	f	pexels-conojeghuo-127673.jpg	image/20250329160524574_65270a960805a8c0.jpg	f
133	49	t	pexels-pixabay-237272.jpg	image/20250329160541079_187329da46ad8cb2.jpg	f
63	38	f	pexels-pixabay-210265.jpg	image/20241228214146621_2cf71fcae4ce59fc.jpg	f
64	38	f	pexels-pixabay-275484.jpg	image/20241228214146624_bd0b1731aaef844b.jpg	f
65	38	t	pexels-pixabay-259962.jpg	image/20241228214146619_d77063b6fde4871b.jpg	f
134	49	t	pexels-quark-studio-1159039-2506988.jpg	image/20250329161403513_d2d3816ccd77ce5f.jpg	f
135	29	t	pexels-pixabay-53464.jpg	image/20250329164124246_7be001d894c77430.jpg	f
136	44	t	pexels-hngstrm-1233648.jpg	image/20250329214229737_093b3dddb853412e.jpg	f
137	46	t	pexels-lawrencesuzara-1566435.jpg	image/20250329214350556_11510b9948273fef.jpg	f
138	51	t	pexels-amorie-sam-468180864-28380943.jpg	image/20250329214801877_e3e684b61ac6bb78.jpg	f
139	51	f	pexels-harem-1617688755-29229531.jpg	image/20250329214801877_a9c7cc6f7aefb172.jpg	f
140	51	f	pexels-introspectivedsgn-27639778.jpg	image/20250329214801877_be1d355f2b0b1ff6.jpg	f
81	26	t	pexels-asphotograpy-291759.jpg	image/20250214123520068_e2a3e72566dfca39.jpg	f
84	27	t	pexels-santa-cruz-photographer-28180134-6935301.jpg	image/20250214123706171_230e4589f2ce96ac.jpg	f
85	32	t	pexels-pixabay-275484.jpg	image/20250214123754311_854785204c832911.jpg	f
\.


--
-- TOC entry 3096 (class 0 OID 612232)
-- Dependencies: 235
-- Data for Name: reserva; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reserva (id, codigo_reserva, usuario_id, tipo_identificacion, identificacion, producto_id, fecha_inicio, fecha_fin, moneda_id, utc_offset, precio_total, peticiones_especiales, precio_total_mostrado, fecha_creacion, fecha_modificacion) FROM stdin;
12	202501208D6E931CAC	10	CC	123456	47	1737403200	1737478800	1	-05:00	500000.000		0.000	1737344757	1741401079
13	20250128281D1CB5A6	13	CC	123456	47	1738094400	1738774800	1	-05:00	5000001.000		0.000	1737428586	1741401079
14	20250128632AE70B25	12	CC	123456	47	1738094400	1738342800	1	-05:00	5000001.000		0.000	1737428627	1741401079
15	20250131689161A617	10	CC	123456	47	1738353600	1738602000	1	-05:00	5000001.000		0.000	1737428121	1741401079
16	202503145975781D0C	7	CC	101456578	47	1741982400	1742317200	1	-05:00	500000.000	bla bla bla	0.000	1741396395	1741401079
17	202503153BB1069AB7	1	CC	3453534	47	1742068800	1742144400	1	-05:00	1750000.000		1750000.000	1742013856	\N
18	20250321108820D4DE	7	CC	101456578	47	1742587200	1742662800	1	-05:00	1000000.000	bla bla bla	13000.000	1741399359	1741401079
19	202503256911937EF6	7	CC	101456578	47	1742932800	1743008400	2	-05:00	359375.000	Precio en moneda ARS	15000.000	1741399988	1741401079
20	202503280AF6256D0D	1	CC	101456578	47	1743174000	1743249600	2	+00:00	718750.000	Precio en moneda ARS	30000.000	1741407093	\N
21	202504014BB7FBB986	1	CC	101456578	47	1743519600	1743595200	2	+00:00	359375.000	Precio en moneda ARS	15000.000	1742087019	\N
22	20250405F216BA7C32	1	CC	101456578	47	1743865200	1743940800	2	+00:00	359375.000	Precio en moneda ARS	15000.000	1742088227	\N
23	20250406A95160CE41	1	CC	101456578	47	1743951600	1744027200	2	+00:00	359375.000	Precio en moneda ARS	15000.000	1742088867	\N
24	2025040701F0EBB20D	1	CC	101456578	47	1744038000	1744113600	2	+00:00	359375.000	Precio en moneda ARS	15000.000	1742089226	\N
32	2025041255654DA83B	1	CC	58964225	29	1744488000	1744736400	1	-05:00	13377391.304	Special request en general	15000.000	1742270715	\N
33	202504193A5F58423D	1	CC	58964225	29	1745092800	1745254800	1	-05:00	13377391.304	Special request en general	15000.000	1742271111	\N
34	202504232867EFB8B7	1	CC	58964225	29	1745438400	1745514000	1	-05:00	13377391.304	Special request en general	15000.000	1742272241	\N
35	202504267521BD3876	1	CC	58964225	29	1745697600	1745773200	1	-05:00	13377391.304	Special request en general	15000.000	1742274847	\N
37	202504294FB64F44F8	1	CC	58964225	29	1745956800	1746032400	1	-05:00	13377391.304	Special request en general	15000.000	1742275167	\N
38	20250429B8826A80AE	1	CC	58964225	29	1745956800	1746032400	1	-05:00	13377391.304	Special request en general	15000.000	1742275521	\N
39	202505011424C90824	1	CC	58964225	29	1746129600	1746205200	1	-05:00	13377391.304	Special request en general	15000.000	1742277623	\N
40	2025031929E754BD5B	1	CE	488SFDF45	29	1742414400	1742490000	1	-05:00	3130434.783	Producto 29 - 1 Habitacion doble para 1 persona(s) y 1niño(s)  -COP $ 3.130.434,78	0.000	1742355956	\N
41	20250319DFEC268523	1	CC	104sdsad4as8d	29	1742414400	1742490000	1	-05:00	25043478.261	2 Habitacion doble para 6 persona(s)	0.000	1742358354	\N
42	202503191C0051E99E	1	CC	sdfasdasd	1	1742414400	1742490000	1	-05:00	1800000.000	2 Habitación sencilla para 2 persona(s) -COP $ 900.000,00	0.000	1742359189	\N
43	202503195E4B31DD88	1	CC	SDSDFSFSDFDS	1	1742414400	1742490000	1	-05:00	450000.000	1 Habitación sencilla para 1 persona(s) COP $ 450.000,00	0.000	1742361764	\N
44	202504120CDB6B186F	10	CC	emmmacammero	29	1744488000	1744563600	1	-05:00	26713043.478	Special request en general	6678260.870	1742691163	\N
47	20250412CF4243BF68	10	CC	emmmacammero	29	1744488000	1744563600	1	-05:00	4173.913	Special request en general	6678260.870	1742700718	\N
48	2025041205E33C0456	10	CC	emmmacammero	29	1744488000	1744563600	1	-05:00	4173913.043	Special request en general	6678260.870	1742700745	\N
49	202503236BD6B79A4A	1	CC	1026546898	29	1742760000	1742835600	1	-05:00	4173.913	1 Habitación sencilla para 1 persona(s)\nCosto detalle 1:\nCOP $ 4.173,91	0.000	1742702170	\N
50	202504019487B75A6C	1	CC	123456789	49	1743537600	1743786000	1	-05:00	15709000.000	Precio: $ 25.515.000,00\nLlegamos antes de las 3pm, para guardar las maletas	0.000	1743282939	\N
51	20250401E4BEE0E467	19	CE	CE451158748	49	1743537600	1743786000	1	-05:00	5869500.000	3 Habitación con cama doble para 6 persona(s) y 1niño(s)	0.000	1743283788	\N
52	2025040535808589B7	19	CC	CC545454848	49	1743883200	1744131600	1	-05:00	4000000.000	2 suites cada una para 1 persona, total noches 3.\nTotal precio pagina 6.000.000,00	0.000	1743284646	\N
53	2025040545381D5157	19	CC	c1c54s51fs54	49	1743883200	1744131600	1	-05:00	602000.000	1 Habitación con cama doble para 2 persona(s)\nCosto detalle 1:\nCOP $ 1.806.000,00\n3 noches	0.000	1743284755	\N
54	20250330778ABE73CA	19	CE	sdfsdfsdfsd	49	1743364800	1743440400	1	-05:00	1000000.000	Test 1 suite 1 persona 1 noche	0.000	1743286132	\N
55	20250330FEE86714C1	19	CC	123456789	49	1743364800	1743440400	1	-05:00	301000.000	No se selecciono cedula	0.000	1743286565	\N
56	20250330377CAD6397	19	CC	123456789	49	1743364800	1743440400	1	-05:00	4816000.000	4 Habitación con cama doble para 4 persona(s)	0.000	1743286704	\N
57	2025040789A96C3177	1	CC	usuarioadmin	49	1744056000	1744131600	1	-05:00	1204000.000	✅ 2 Habitación con cama doble para 2 persona(s)\nCosto detalle 1:\nCOP $ 602.000,00	0.000	1743286960	\N
58	20250414BF351ABFFD	18	CC	usuariojonas	49	1744660800	1744736400	1	-05:00	1204000.000	2 habitaciones cada una de una persona.\nTotal calc: 602000	0.000	1743289961	\N
59	2025041161FDB0FBFC	18	CC	usuariojonas	49	1744401600	1744477200	1	-05:00	903000.000	2 habitaciones por persona y por nino. total mostrado 903.000.	0.000	1743291027	\N
60	20250421C2275D655C	19	CC	usuariodana	49	1745265600	1745514000	1	-05:00	2257500.000	3 habitaciones cada una con 2 personas y cada una con 1 nino. $6.772.500,00	0.000	1743291944	\N
61	20250414A663FACA71	19	CC	usuariodana	50	1744660800	1744909200	1	-05:00	1458000.000	2 habs, 2 personas x hab, 3 noches.	0.000	1743293911	\N
62	20250505E43D270CCE	19	CC	usuariodana	49	1746475200	1746723600	1	-05:00	6772500.000	3 habs, 2 adultos 1 nino, 3 noches	0.000	1743294199	\N
63	202505196642884ED4	19	CC	usuariodanna	50	1747684800	1747933200	1	-05:00	2187000.000	3 habs X 2 personas cada una, y 3 noches.\nTotal: $ 2.187.000,00	0.000	1743294580	\N
64	20250407CC76A264A4	19	CC	usauriodana	49	1744056000	1744304400	1	-05:00	903000.000	Prueba	0.000	1743295044	\N
65	20250330C2A4D92E83	17	CE	CE46555514545	29	1743364800	1743440400	1	-05:00	600000.000	Llego a las 11 am para dejar las maletas.	0.000	1743303565	\N
\.


--
-- TOC entry 3098 (class 0 OID 612265)
-- Dependencies: 237
-- Data for Name: reserva_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reserva_detalle (id, reserva_id, producto_detalle_id, cantidad_personas_adultas, cantidad_ninos, cantidad, precio, fecha_creacion, fecha_modificacion) FROM stdin;
1	12	1	2	0	0	500000.000	1742178399	\N
2	13	2	2	0	0	5000001.000	1742178399	\N
3	14	2	2	0	0	5000001.000	1742178399	\N
4	15	2	2	0	0	5000001.000	1742178399	\N
5	16	1	2	0	1	500000.000	1742178399	\N
6	17	8	1	0	1	400000.000	1742178399	\N
7	17	2	1	0	1	350000.000	1742178399	\N
8	17	1	2	0	1	1000000.000	1742178399	\N
9	18	1	2	0	1	1000000.000	1742178399	\N
10	19	1	2	2	1	359375.000	1742178399	\N
11	20	1	2	2	1	359375.000	1742178399	\N
12	21	1	2	2	1	359375.000	1742178399	\N
13	22	1	2	2	1	359375.000	1742178399	\N
14	23	1	2	2	1	359375.000	1742178399	\N
15	24	1	2	2	1	359375.000	1742178399	\N
17	32	3	2	1	2	20869.565	1742270738	\N
18	32	6	2	0	1	13356521.739	1742270765	\N
19	33	3	2	1	2	20869.565	1742271113	\N
20	33	6	2	0	1	13356521.739	1742271116	\N
21	34	3	2	1	2	20869.565	1742272244	\N
22	34	6	2	0	1	13356521.739	1742272246	\N
23	35	3	2	1	2	20869.565	1742274847	\N
24	35	6	2	0	1	13356521.739	1742274847	\N
25	37	3	2	1	2	20869.565	1742275167	\N
26	37	6	2	0	1	13356521.739	1742275167	\N
27	39	3	2	1	2	20869.565	1742277623	\N
28	39	6	2	0	1	13356521.739	1742277623	\N
29	40	7	1	1	1	3130434.783	1742355956	\N
30	41	7	6	0	2	25043478.261	1742358354	\N
31	42	11	2	0	2	1800000.000	1742359189	\N
32	43	11	1	0	1	450000.000	1742361764	\N
33	44	6	1	0	4	26713043.478	1742691163	\N
36	47	3	1	0	1	4173.913	1742700718	\N
37	48	7	1	0	2	4173913.043	1742700745	\N
38	49	3	1	0	1	4173.913	1742702170	\N
39	50	12	6	1	2	13000000.000	1743282939	\N
40	50	13	4	1	2	2709000.000	1743282939	\N
41	51	13	6	1	3	5869500.000	1743283788	\N
42	52	12	2	0	2	4000000.000	1743284646	\N
43	53	13	2	0	1	602000.000	1743284755	\N
44	54	12	1	0	1	1000000.000	1743286132	\N
45	55	13	1	0	1	301000.000	1743286565	\N
46	56	13	4	0	4	4816000.000	1743286704	\N
47	57	13	2	0	2	1204000.000	1743286960	\N
48	58	13	2	0	2	1204000.000	1743289962	\N
49	59	13	1	1	2	903000.000	1743291027	\N
50	60	13	2	1	3	2257500.000	1743291944	\N
51	61	15	2	0	2	1458000.000	1743293913	\N
52	62	13	2	1	3	6772500.000	1743294199	\N
53	63	15	2	0	3	2187000.000	1743294580	\N
54	64	13	1	0	1	903000.000	1743295044	\N
55	65	3	1	0	2	600000.000	1743303565	\N
\.



--
-- TOC entry 3074 (class 0 OID 611401)
-- Dependencies: 212
-- Data for Name: rol; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rol (id, nombre_rol) FROM stdin;
1	Administrador
2	Invitado
3	Cliente
\.


--
-- TOC entry 3082 (class 0 OID 611726)
-- Dependencies: 220
-- Data for Name: rol_capacidad_api; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rol_capacidad_api (rol_id, capacidad_id, permisos_api_id) FROM stdin;
1	1	2
2	1	2
3	1	2
1	1	3
2	1	3
3	1	3
1	1	5
2	1	5
3	1	5
1	1	6
2	1	6
3	1	6
1	1	7
2	1	7
3	1	7
1	6	8
2	6	8
3	6	8
1	1	10
3	1	10
1	3	1
1	6	9
2	6	9
1	6	13
3	6	13
1	8	13
3	8	13
1	1	14
3	1	14
1	6	15
3	6	15
1	1	16
3	1	16
1	6	16
3	6	16
1	1	17
2	1	17
3	1	17
1	1	18
2	1	18
3	1	18
\.


--
-- TOC entry 3085 (class 0 OID 611955)
-- Dependencies: 224
-- Data for Name: tipo_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tipo_detalle (id, nombre) FROM stdin;
1	Habitación
2	Suite
3	Estudio
4	Apartamento
5	Casa
\.


--
-- TOC entry 3076 (class 0 OID 611577)
-- Dependencies: 214
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario (id, nombre, apellido, email, password, bloqueado, deshabilitado, es_eliminado, email_confirmado) FROM stdin;
1	Gloria	Lopez	lpez.gloria2@gmail.com	$2y$14$AGOj0TvuAH5gpyRoxNpnku4Dr/2KxpjLpjcZLUJwEyZlAhLAvI69y	f	f	f	f
2	Invitado	No logueado	test@test.com	$2y$14$ZbD4nrq3f5rDy5SA4zQeDOa2HNuB4J4rVmhSgQsuhesAbmPKojTC.	f	f	f	f
11	Jazmin	Sanders	lpez.gloria2+008@gmail.com	$2a$10$RjPLXWwdyAtZ9NgttsX0xeHt5YPO.tMg9u86Pz5tEB9MYP4kj0XIi	f	f	f	f
12	Daei	Tols	lpez.gloria2+009@gmail.com	$2a$10$7pI7r9sMmqSsDotFlWd6NeKV17gaigiUarBUPDLl9g9lHIQ.icwpu	f	f	f	f
7	Lyana	Stark S.	lpez.gloria2+004@gmail.com	$2a$10$IE4AUK5HOlF7GqbjKmeE6ODSpeUbpbxEzvlZyuLHMxUc.fmqQ2g/a	f	f	f	f
13	Miax	Thompson	lpez.gloria2+010@gmail.com	$2a$10$qDYySkDvWzhQfO0AeCwjb.RaESLMWnt51G0OsbAmI6KjuiZ01YyN2	f	f	f	f
9	Corben	Dalas	lpez.gloria2+006@gmail.com	$2a$10$0pt/ra/wgTCKKnfNfrCVzOs7mdX2BrqUsWIg/jZdS7blQojJIs7sO	f	f	f	f
10	Emma	Camero	lpez.gloria2+007@gmail.com	$2a$10$2Bnwgzkub302PTldcERSOuXCXID7.TvhER.5aZX9qDKpJiyTAZFf6	f	f	f	f
17	Mariana	Perez	lpez.gloria2+022@gmail.com	$2a$10$dPdSGKxlhTxZWSUWFt6T8.K8C/crW3nQ8KwoAtbefNMCzzw6VqMKq	f	f	f	f
18	Jonas	Lohen	lpez.gloria2+023@gmail.com	$2a$10$0TcS3SGstQ.FrmuuWk/U1uAcvVm//FS1PGtFcJSBgcGwI/tEeeDZG	f	f	f	f
14	User guest 1	update	lpez.gloria2+021@gmail.com	$2a$10$3Fn/20YgKMokANzVBsXp3uI.m/Y58gbhxxek/iYEUSuGJ5w9RnHu.	f	f	t	f
8	User guest	creando	lpez.gloria2+005@gmail.com	$2a$10$uo3gIIEXDQTw6xR/gAdaRui9yKCvkziIyQ6jYFtCNpUspU6t2ee6a	f	f	t	f
19	Danna	Fohler	lpez.gloria2+024@gmail.com	$2a$10$OMfZy4.jhcEWAB07TD2C1OkKO9qq7zaWSthbc7Z2OPzMJWFBSQ/7G	f	f	f	f
20	Elliot	Sanders	lpez.gloria2+025@gmail.com	$2a$10$4SU2w.VXHyifbpBqaXOF0.rVCWdsWNQ8rxUGAsGrdEt2gzLHV3sd2	f	f	f	f
\.


--
-- TOC entry 3077 (class 0 OID 611591)
-- Dependencies: 215
-- Data for Name: usuario_rol; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario_rol (usuario_id, rol_id) FROM stdin;
1	1
2	2
8	3
11	3
12	3
7	1
9	3
13	3
14	3
10	3
17	3
18	3
19	3
20	1
\.


--
-- TOC entry 3123 (class 0 OID 0)
-- Dependencies: 216
-- Name: capacidad_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.capacidad_id_seq', 8, true);


--
-- TOC entry 3124 (class 0 OID 0)
-- Dependencies: 208
-- Name: caracteristica_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.caracteristica_id_seq', 20, true);


--
-- TOC entry 3125 (class 0 OID 0)
-- Dependencies: 206
-- Name: categoria_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categoria_id_seq', 16, true);


--
-- TOC entry 3126 (class 0 OID 0)
-- Dependencies: 227
-- Name: moneda_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.moneda_id_seq', 5, true);


--
-- TOC entry 3127 (class 0 OID 0)
-- Dependencies: 218
-- Name: permisos_api_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permisos_api_id_seq', 18, true);


--
-- TOC entry 3128 (class 0 OID 0)
-- Dependencies: 225
-- Name: producto_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.producto_detalle_id_seq', 15, true);


--
-- TOC entry 3129 (class 0 OID 0)
-- Dependencies: 230
-- Name: producto_direccion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.producto_direccion_id_seq', 33, true);


--
-- TOC entry 3130 (class 0 OID 0)
-- Dependencies: 202
-- Name: producto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.producto_id_seq', 51, true);


--
-- TOC entry 3131 (class 0 OID 0)
-- Dependencies: 238
-- Name: producto_puntuacion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.producto_puntuacion_id_seq', 5, true);


--
-- TOC entry 3132 (class 0 OID 0)
-- Dependencies: 204
-- Name: recurso_imagen_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recurso_imagen_id_seq', 140, true);


--
-- TOC entry 3133 (class 0 OID 0)
-- Dependencies: 236
-- Name: reserva_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reserva_detalle_id_seq', 55, true);


--
-- TOC entry 3135 (class 0 OID 0)
-- Dependencies: 234
-- Name: reserva_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reserva_id_seq1', 65, true);


--
-- TOC entry 3136 (class 0 OID 0)
-- Dependencies: 211
-- Name: rol_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rol_id_seq', 3, true);


--
-- TOC entry 3137 (class 0 OID 0)
-- Dependencies: 223
-- Name: tipo_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipo_detalle_id_seq', 5, true);


--
-- TOC entry 3138 (class 0 OID 0)
-- Dependencies: 213
-- Name: usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuario_id_seq', 20, true);


--
-- TOC entry 2886 (class 2606 OID 611612)
-- Name: capacidad capacidad_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.capacidad
    ADD CONSTRAINT capacidad_pkey PRIMARY KEY (id);


--
-- TOC entry 2880 (class 2606 OID 611358)
-- Name: caracteristica caracteristica_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caracteristica
    ADD CONSTRAINT caracteristica_pkey PRIMARY KEY (id);


--
-- TOC entry 2878 (class 2606 OID 611346)
-- Name: categoria categoria_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (id);


--
-- TOC entry 2897 (class 2606 OID 612012)
-- Name: moneda moneda_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moneda
    ADD CONSTRAINT moneda_pkey PRIMARY KEY (id);


--
-- TOC entry 2888 (class 2606 OID 611656)
-- Name: permisos_api permisos_api_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permisos_api
    ADD CONSTRAINT permisos_api_pkey PRIMARY KEY (id);


--
-- TOC entry 2895 (class 2606 OID 611974)
-- Name: producto_detalle producto_detalle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto_detalle
    ADD CONSTRAINT producto_detalle_pkey PRIMARY KEY (id);


--
-- TOC entry 2899 (class 2606 OID 612100)
-- Name: producto_direccion producto_direccion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto_direccion
    ADD CONSTRAINT producto_direccion_pkey PRIMARY KEY (id);


--
-- TOC entry 2873 (class 2606 OID 611136)
-- Name: producto producto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_pkey PRIMARY KEY (id);


--
-- TOC entry 2906 (class 2606 OID 612466)
-- Name: producto_puntuacion producto_puntuacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto_puntuacion
    ADD CONSTRAINT producto_puntuacion_pkey PRIMARY KEY (id);


--
-- TOC entry 2876 (class 2606 OID 611321)
-- Name: recurso_imagen recursoimagen_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recurso_imagen
    ADD CONSTRAINT recursoimagen_pkey PRIMARY KEY (id);


--
-- TOC entry 2904 (class 2606 OID 612271)
-- Name: reserva_detalle reserva_detalle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reserva_detalle
    ADD CONSTRAINT reserva_detalle_pkey PRIMARY KEY (id);


--
-- TOC entry 2902 (class 2606 OID 612243)
-- Name: reserva reserva_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reserva
    ADD CONSTRAINT reserva_pkey PRIMARY KEY (id);


--
-- TOC entry 2882 (class 2606 OID 611407)
-- Name: rol rol_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol
    ADD CONSTRAINT rol_pkey PRIMARY KEY (id);


--
-- TOC entry 2893 (class 2606 OID 611961)
-- Name: tipo_detalle tipo_detalle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_detalle
    ADD CONSTRAINT tipo_detalle_pkey PRIMARY KEY (id);


--
-- TOC entry 2884 (class 2606 OID 611590)
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id);


--
-- TOC entry 2889 (class 1259 OID 611720)
-- Name: permisos_api_ui; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX permisos_api_ui ON public.permisos_api USING btree (mapping);


--
-- TOC entry 2874 (class 1259 OID 611322)
-- Name: pro_ix; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pro_ix ON public.recurso_imagen USING btree (producto_id);


--
-- TOC entry 2891 (class 1259 OID 611812)
-- Name: producto_favorito_ui; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX producto_favorito_ui ON public.producto_favorito USING btree (usuario_id, producto_id);


--
-- TOC entry 2907 (class 1259 OID 612482)
-- Name: producto_puntuacion_ui; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX producto_puntuacion_ui ON public.producto_puntuacion USING btree (usuario_id, producto_id, reserva_id);


--
-- TOC entry 2900 (class 1259 OID 612260)
-- Name: reserva_cr_ix; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX reserva_cr_ix ON public.reserva USING btree (codigo_reserva);


--
-- TOC entry 2890 (class 1259 OID 611744)
-- Name: rol_capacidad_api_ui; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX rol_capacidad_api_ui ON public.rol_capacidad_api USING btree (rol_id, capacidad_id, permisos_api_id);


--
-- TOC entry 2934 (class 2620 OID 612262)
-- Name: reserva trg_fecha_modificacion; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_fecha_modificacion BEFORE UPDATE ON public.reserva FOR EACH ROW EXECUTE FUNCTION public.fn_update_fecha_modificacion();


--
-- TOC entry 2935 (class 2620 OID 612282)
-- Name: reserva_detalle trg_fecha_modificacion; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_fecha_modificacion BEFORE UPDATE ON public.reserva_detalle FOR EACH ROW EXECUTE FUNCTION public.fn_update_fecha_modificacion();


--
-- TOC entry 2933 (class 2620 OID 612158)
-- Name: producto trg_producto_fecha_modificacion; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_producto_fecha_modificacion BEFORE UPDATE ON public.producto FOR EACH ROW EXECUTE FUNCTION public.fn_update_fecha_modificacion();


--
-- TOC entry 2915 (class 2606 OID 611734)
-- Name: rol_capacidad_api fk_capacidad; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol_capacidad_api
    ADD CONSTRAINT fk_capacidad FOREIGN KEY (capacidad_id) REFERENCES public.capacidad(id);


--
-- TOC entry 2911 (class 2606 OID 611369)
-- Name: producto_caracteristica fk_caracteristica; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto_caracteristica
    ADD CONSTRAINT fk_caracteristica FOREIGN KEY (caracteristica_id) REFERENCES public.caracteristica(id);


--
-- TOC entry 2923 (class 2606 OID 612039)
-- Name: producto_detalle_caracteristica fk_caracteristica; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto_detalle_caracteristica
    ADD CONSTRAINT fk_caracteristica FOREIGN KEY (caracteristica_id) REFERENCES public.caracteristica(id);


ALTER TABLE ONLY public.producto
    ADD CONSTRAINT fk_categoria FOREIGN KEY (categoria_id) REFERENCES public.categoria(id);

ALTER TABLE ONLY public.producto_detalle
    ADD CONSTRAINT fk_moneda FOREIGN KEY (moneda_id) REFERENCES public.moneda(id);


ALTER TABLE ONLY public.reserva
    ADD CONSTRAINT fk_moneda FOREIGN KEY (moneda_id) REFERENCES public.moneda(id);


ALTER TABLE ONLY public.rol_capacidad_api
    ADD CONSTRAINT fk_permisos_api FOREIGN KEY (permisos_api_id) REFERENCES public.permisos_api(id);


ALTER TABLE ONLY public.producto_caracteristica
    ADD CONSTRAINT fk_producto FOREIGN KEY (producto_id) REFERENCES public.producto(id);

ALTER TABLE ONLY public.recurso_imagen
    ADD CONSTRAINT fk_producto FOREIGN KEY (producto_id) REFERENCES public.producto(id);

ALTER TABLE ONLY public.producto_favorito
    ADD CONSTRAINT fk_producto FOREIGN KEY (producto_id) REFERENCES public.producto(id);


ALTER TABLE ONLY public.producto_detalle
    ADD CONSTRAINT fk_producto FOREIGN KEY (producto_id) REFERENCES public.producto(id);

ALTER TABLE ONLY public.producto_direccion
    ADD CONSTRAINT fk_producto FOREIGN KEY (producto_id) REFERENCES public.producto(id);

ALTER TABLE ONLY public.reserva
    ADD CONSTRAINT fk_producto FOREIGN KEY (producto_id) REFERENCES public.producto(id);

ALTER TABLE ONLY public.producto_puntuacion
    ADD CONSTRAINT fk_producto FOREIGN KEY (producto_id) REFERENCES public.producto(id);

ALTER TABLE ONLY public.producto_detalle_caracteristica
    ADD CONSTRAINT fk_producto_detalle FOREIGN KEY (producto_detalle_id) REFERENCES public.producto_detalle(id);

ALTER TABLE ONLY public.reserva_detalle
    ADD CONSTRAINT fk_producto_detalle FOREIGN KEY (producto_detalle_id) REFERENCES public.producto_detalle(id);


ALTER TABLE ONLY public.reserva_detalle
    ADD CONSTRAINT fk_reserva FOREIGN KEY (reserva_id) REFERENCES public.reserva(id);

ALTER TABLE ONLY public.producto_puntuacion
    ADD CONSTRAINT fk_reserva FOREIGN KEY (reserva_id) REFERENCES public.reserva(id);

ALTER TABLE ONLY public.usuario_rol
    ADD CONSTRAINT fk_rol FOREIGN KEY (rol_id) REFERENCES public.rol(id);

ALTER TABLE ONLY public.rol_capacidad_api
    ADD CONSTRAINT fk_rol FOREIGN KEY (rol_id) REFERENCES public.rol(id);


ALTER TABLE ONLY public.producto_detalle
    ADD CONSTRAINT fk_tipo_detalle FOREIGN KEY (tipo_detalle_id) REFERENCES public.tipo_detalle(id);

ALTER TABLE ONLY public.usuario_rol
    ADD CONSTRAINT fk_usuario FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);

ALTER TABLE ONLY public.producto_favorito
    ADD CONSTRAINT fk_usuario FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


ALTER TABLE ONLY public.reserva
    ADD CONSTRAINT fk_usuario FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


ALTER TABLE ONLY public.producto_puntuacion
    ADD CONSTRAINT fk_usuario FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


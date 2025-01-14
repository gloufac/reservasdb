--
-- PostgreSQL database dump
--

-- Dumped from database version 12.10
-- Dumped by pg_dump version 12.10

-- Started on 2025-01-13 19:28:19

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

--
-- TOC entry 3 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 2974 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 214 (class 1259 OID 611519)
-- Name: app_sitio; Type: TABLE; Schema: public; Owner: rdsadmin
--

CREATE TABLE public.app_sitio (
    id integer NOT NULL,
    ruta character varying(100) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.app_sitio OWNER TO rdsadmin;

--
-- TOC entry 213 (class 1259 OID 611517)
-- Name: app_sitio_id_seq; Type: SEQUENCE; Schema: public; Owner: rdsadmin
--

CREATE SEQUENCE public.app_sitio_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.app_sitio_id_seq OWNER TO rdsadmin;

--
-- TOC entry 2975 (class 0 OID 0)
-- Dependencies: 213
-- Name: app_sitio_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rdsadmin
--

ALTER SEQUENCE public.app_sitio_id_seq OWNED BY public.app_sitio.id;


--
-- TOC entry 220 (class 1259 OID 611606)
-- Name: capacidad; Type: TABLE; Schema: public; Owner: rdsadmin
--

CREATE TABLE public.capacidad (
    id integer NOT NULL,
    capacidad character varying(100) DEFAULT ''::character varying NOT NULL,
    http_get boolean NOT NULL,
    http_post boolean NOT NULL,
    http_update boolean NOT NULL,
    http_delete boolean NOT NULL
);


ALTER TABLE public.capacidad OWNER TO rdsadmin;

--
-- TOC entry 219 (class 1259 OID 611604)
-- Name: capacidad_id_seq; Type: SEQUENCE; Schema: public; Owner: rdsadmin
--

CREATE SEQUENCE public.capacidad_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.capacidad_id_seq OWNER TO rdsadmin;

--
-- TOC entry 2976 (class 0 OID 0)
-- Dependencies: 219
-- Name: capacidad_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rdsadmin
--

ALTER SEQUENCE public.capacidad_id_seq OWNED BY public.capacidad.id;


--
-- TOC entry 209 (class 1259 OID 611349)
-- Name: caracteristica; Type: TABLE; Schema: public; Owner: rdsadmin
--

CREATE TABLE public.caracteristica (
    id integer NOT NULL,
    nombre character varying(100) DEFAULT ''::character varying NOT NULL,
    ruta_imagen character varying(512)
);


ALTER TABLE public.caracteristica OWNER TO rdsadmin;

--
-- TOC entry 208 (class 1259 OID 611347)
-- Name: caracteristica_id_seq; Type: SEQUENCE; Schema: public; Owner: rdsadmin
--

CREATE SEQUENCE public.caracteristica_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.caracteristica_id_seq OWNER TO rdsadmin;

--
-- TOC entry 2977 (class 0 OID 0)
-- Dependencies: 208
-- Name: caracteristica_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rdsadmin
--

ALTER SEQUENCE public.caracteristica_id_seq OWNED BY public.caracteristica.id;


--
-- TOC entry 207 (class 1259 OID 611337)
-- Name: categoria; Type: TABLE; Schema: public; Owner: rdsadmin
--

CREATE TABLE public.categoria (
    id integer NOT NULL,
    titulo character varying(100) DEFAULT ''::character varying NOT NULL,
    descripcion text,
    ruta_imagen character varying(512)
);


ALTER TABLE public.categoria OWNER TO rdsadmin;

--
-- TOC entry 206 (class 1259 OID 611335)
-- Name: categoria_id_seq; Type: SEQUENCE; Schema: public; Owner: rdsadmin
--

CREATE SEQUENCE public.categoria_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categoria_id_seq OWNER TO rdsadmin;

--
-- TOC entry 2978 (class 0 OID 0)
-- Dependencies: 206
-- Name: categoria_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rdsadmin
--

ALTER SEQUENCE public.categoria_id_seq OWNED BY public.categoria.id;


--
-- TOC entry 222 (class 1259 OID 611650)
-- Name: permisos_api; Type: TABLE; Schema: public; Owner: rdsadmin
--

CREATE TABLE public.permisos_api (
    id integer NOT NULL,
    mapping character varying(100) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.permisos_api OWNER TO rdsadmin;

--
-- TOC entry 221 (class 1259 OID 611648)
-- Name: permisos_api_id_seq; Type: SEQUENCE; Schema: public; Owner: rdsadmin
--

CREATE SEQUENCE public.permisos_api_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.permisos_api_id_seq OWNER TO rdsadmin;

--
-- TOC entry 2979 (class 0 OID 0)
-- Dependencies: 221
-- Name: permisos_api_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rdsadmin
--

ALTER SEQUENCE public.permisos_api_id_seq OWNED BY public.permisos_api.id;


--
-- TOC entry 203 (class 1259 OID 611127)
-- Name: producto; Type: TABLE; Schema: public; Owner: rdsadmin
--

CREATE TABLE public.producto (
    id integer NOT NULL,
    nombre character varying(255) DEFAULT ''::character varying NOT NULL,
    descripcion character varying(255),
    categoria_id integer
);


ALTER TABLE public.producto OWNER TO rdsadmin;

--
-- TOC entry 210 (class 1259 OID 611361)
-- Name: producto_caracteristica; Type: TABLE; Schema: public; Owner: rdsadmin
--

CREATE TABLE public.producto_caracteristica (
    producto_id integer NOT NULL,
    caracteristica_id integer NOT NULL
);


ALTER TABLE public.producto_caracteristica OWNER TO rdsadmin;

--
-- TOC entry 202 (class 1259 OID 611125)
-- Name: producto_id_seq; Type: SEQUENCE; Schema: public; Owner: rdsadmin
--

CREATE SEQUENCE public.producto_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.producto_id_seq OWNER TO rdsadmin;

--
-- TOC entry 2980 (class 0 OID 0)
-- Dependencies: 202
-- Name: producto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rdsadmin
--

ALTER SEQUENCE public.producto_id_seq OWNED BY public.producto.id;


--
-- TOC entry 205 (class 1259 OID 611313)
-- Name: recurso_imagen; Type: TABLE; Schema: public; Owner: rdsadmin
--

CREATE TABLE public.recurso_imagen (
    id integer NOT NULL,
    producto_id integer NOT NULL,
    es_imagen_principal boolean NOT NULL,
    nombre_imagen character varying(1024) NOT NULL,
    locacion_s3 character varying(512) NOT NULL,
    eliminar_en_repositorio boolean DEFAULT false
);


ALTER TABLE public.recurso_imagen OWNER TO rdsadmin;

--
-- TOC entry 204 (class 1259 OID 611311)
-- Name: recurso_imagen_id_seq; Type: SEQUENCE; Schema: public; Owner: rdsadmin
--

CREATE SEQUENCE public.recurso_imagen_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.recurso_imagen_id_seq OWNER TO rdsadmin;

--
-- TOC entry 2981 (class 0 OID 0)
-- Dependencies: 204
-- Name: recurso_imagen_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rdsadmin
--

ALTER SEQUENCE public.recurso_imagen_id_seq OWNED BY public.recurso_imagen.id;


--
-- TOC entry 212 (class 1259 OID 611401)
-- Name: rol; Type: TABLE; Schema: public; Owner: rdsadmin
--

CREATE TABLE public.rol (
    id integer NOT NULL,
    nombre_rol character varying(100) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.rol OWNER TO rdsadmin;

--
-- TOC entry 224 (class 1259 OID 611726)
-- Name: rol_capacidad_api; Type: TABLE; Schema: public; Owner: rdsadmin
--

CREATE TABLE public.rol_capacidad_api (
    rol_id integer NOT NULL,
    capacidad_id integer NOT NULL,
    permisos_api_id integer NOT NULL
);


ALTER TABLE public.rol_capacidad_api OWNER TO rdsadmin;

--
-- TOC entry 215 (class 1259 OID 611526)
-- Name: rol_capacidad_sitio; Type: TABLE; Schema: public; Owner: rdsadmin
--

CREATE TABLE public.rol_capacidad_sitio (
    rol_id integer NOT NULL,
    capacidad_id integer NOT NULL,
    app_sitio_id integer NOT NULL,
    descripcion character varying(500)
);


ALTER TABLE public.rol_capacidad_sitio OWNER TO rdsadmin;

--
-- TOC entry 211 (class 1259 OID 611399)
-- Name: rol_id_seq; Type: SEQUENCE; Schema: public; Owner: rdsadmin
--

CREATE SEQUENCE public.rol_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rol_id_seq OWNER TO rdsadmin;

--
-- TOC entry 2982 (class 0 OID 0)
-- Dependencies: 211
-- Name: rol_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rdsadmin
--

ALTER SEQUENCE public.rol_id_seq OWNED BY public.rol.id;


--
-- TOC entry 217 (class 1259 OID 611577)
-- Name: usuario; Type: TABLE; Schema: public; Owner: rdsadmin
--

CREATE TABLE public.usuario (
    id integer NOT NULL,
    nombre character varying(100) DEFAULT ''::character varying NOT NULL,
    apellido character varying(100) DEFAULT ''::character varying NOT NULL,
    email character varying(100) DEFAULT ''::character varying NOT NULL,
    password character varying(2000) NOT NULL,
    bloqueado boolean DEFAULT false,
    deshabilitado boolean DEFAULT false
);


ALTER TABLE public.usuario OWNER TO rdsadmin;

--
-- TOC entry 216 (class 1259 OID 611575)
-- Name: usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: rdsadmin
--

CREATE SEQUENCE public.usuario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuario_id_seq OWNER TO rdsadmin;

--
-- TOC entry 2983 (class 0 OID 0)
-- Dependencies: 216
-- Name: usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rdsadmin
--

ALTER SEQUENCE public.usuario_id_seq OWNED BY public.usuario.id;


--
-- TOC entry 218 (class 1259 OID 611591)
-- Name: usuario_rol; Type: TABLE; Schema: public; Owner: rdsadmin
--

CREATE TABLE public.usuario_rol (
    usuario_id integer NOT NULL,
    rol_id integer NOT NULL
);


ALTER TABLE public.usuario_rol OWNER TO rdsadmin;

--
-- TOC entry 225 (class 1259 OID 611760)
-- Name: vw_permisos_api; Type: VIEW; Schema: public; Owner: rdsadmin
--

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


ALTER TABLE public.vw_permisos_api OWNER TO rdsadmin;

--
-- TOC entry 223 (class 1259 OID 611696)
-- Name: vw_permisos_appsitio; Type: VIEW; Schema: public; Owner: rdsadmin
--

CREATE VIEW public.vw_permisos_appsitio AS
 SELECT row_number() OVER (ORDER BY rol.id, asi.ruta) AS row_id,
    rol.nombre_rol,
    asi.ruta,
    ca.http_get,
    ca.http_post,
    ca.http_update,
    ca.http_delete
   FROM (((public.rol_capacidad_sitio rcs
     JOIN public.app_sitio asi ON ((rcs.app_sitio_id = asi.id)))
     JOIN public.capacidad ca ON ((ca.id = rcs.capacidad_id)))
     JOIN public.rol ON ((rol.id = rcs.rol_id)));


ALTER TABLE public.vw_permisos_appsitio OWNER TO rdsadmin;

--
-- TOC entry 2775 (class 2604 OID 611522)
-- Name: app_sitio id; Type: DEFAULT; Schema: public; Owner: rdsadmin
--

ALTER TABLE ONLY public.app_sitio ALTER COLUMN id SET DEFAULT nextval('public.app_sitio_id_seq'::regclass);


--
-- TOC entry 2783 (class 2604 OID 611609)
-- Name: capacidad id; Type: DEFAULT; Schema: public; Owner: rdsadmin
--

ALTER TABLE ONLY public.capacidad ALTER COLUMN id SET DEFAULT nextval('public.capacidad_id_seq'::regclass);


--
-- TOC entry 2771 (class 2604 OID 611352)
-- Name: caracteristica id; Type: DEFAULT; Schema: public; Owner: rdsadmin
--

ALTER TABLE ONLY public.caracteristica ALTER COLUMN id SET DEFAULT nextval('public.caracteristica_id_seq'::regclass);


--
-- TOC entry 2769 (class 2604 OID 611340)
-- Name: categoria id; Type: DEFAULT; Schema: public; Owner: rdsadmin
--

ALTER TABLE ONLY public.categoria ALTER COLUMN id SET DEFAULT nextval('public.categoria_id_seq'::regclass);


--
-- TOC entry 2785 (class 2604 OID 611653)
-- Name: permisos_api id; Type: DEFAULT; Schema: public; Owner: rdsadmin
--

ALTER TABLE ONLY public.permisos_api ALTER COLUMN id SET DEFAULT nextval('public.permisos_api_id_seq'::regclass);


--
-- TOC entry 2765 (class 2604 OID 611130)
-- Name: producto id; Type: DEFAULT; Schema: public; Owner: rdsadmin
--

ALTER TABLE ONLY public.producto ALTER COLUMN id SET DEFAULT nextval('public.producto_id_seq'::regclass);


--
-- TOC entry 2767 (class 2604 OID 611316)
-- Name: recurso_imagen id; Type: DEFAULT; Schema: public; Owner: rdsadmin
--

ALTER TABLE ONLY public.recurso_imagen ALTER COLUMN id SET DEFAULT nextval('public.recurso_imagen_id_seq'::regclass);


--
-- TOC entry 2773 (class 2604 OID 611404)
-- Name: rol id; Type: DEFAULT; Schema: public; Owner: rdsadmin
--

ALTER TABLE ONLY public.rol ALTER COLUMN id SET DEFAULT nextval('public.rol_id_seq'::regclass);


--
-- TOC entry 2777 (class 2604 OID 611580)
-- Name: usuario id; Type: DEFAULT; Schema: public; Owner: rdsadmin
--

ALTER TABLE ONLY public.usuario ALTER COLUMN id SET DEFAULT nextval('public.usuario_id_seq'::regclass);


--
-- TOC entry 2959 (class 0 OID 611519)
-- Dependencies: 214
-- Data for Name: app_sitio; Type: TABLE DATA; Schema: public; Owner: rdsadmin
--

COPY public.app_sitio (id, ruta) FROM stdin;
1	*all*
2	home
3	panel_admin
4	index_admin
5	index_product
6	add_product
7	edit_product
8	index_feature
9	add_feature
10	edit_feature
11	index_category
12	add_category
13	edit_category
\.


--
-- TOC entry 2965 (class 0 OID 611606)
-- Dependencies: 220
-- Data for Name: capacidad; Type: TABLE DATA; Schema: public; Owner: rdsadmin
--

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
-- TOC entry 2954 (class 0 OID 611349)
-- Dependencies: 209
-- Data for Name: caracteristica; Type: TABLE DATA; Schema: public; Owner: rdsadmin
--

COPY public.caracteristica (id, nombre, ruta_imagen) FROM stdin;
1	Avion 1	admon/20250106165532938_1eedf1b2ab33f66e.svg
2	Cama	admon/20250106171217077_9641b3f552e268e7.svg
3	Piscina	admon/20250110183223585_76eb7ddb8c46d828.svg
4	Bar	admon/20250106193334657_03db195c844a38a4.svg
5	Wi Fi	admon/20250110185002360_f085d2368b2908c2.svg
6	Vestido	admon/20250110232450276_61330fc5450240c8.svg
7	Mascotas	admon/20250111004010193_701dcaca42b3bef2.svg
8	Con Niños	admon/20250111004033559_0c52525fcb3010c3.svg
9	Servicios	admon/20250111004101760_6f5ac9ad4049f729.svg
10	Vista montaña	admon/20250111004117565_b728c48f4c8b047e.svg
\.


--
-- TOC entry 2952 (class 0 OID 611337)
-- Dependencies: 207
-- Data for Name: categoria; Type: TABLE DATA; Schema: public; Owner: rdsadmin
--

COPY public.categoria (id, titulo, descripcion, ruta_imagen) FROM stdin;
3	Hotel	Sección hoteles	admon/20250106201213799_fbd780753966d09e.jpg
4	Hostal	Hostales	
5	Alquiler de ropa	Alquiler de vestidos de baño	
6	Servicios de conduccion	Servicio de transporte 3	admon/20250110000214801_c42e58f88d7d8f2a.jpg
\.


--
-- TOC entry 2967 (class 0 OID 611650)
-- Dependencies: 222
-- Data for Name: permisos_api; Type: TABLE DATA; Schema: public; Owner: rdsadmin
--

COPY public.permisos_api (id, mapping) FROM stdin;
2	/api/productos/**
3	/api/productos/random/**
4	/api/productos/{id}/images/**
5	/api/categorias/**
1	/api/**
6	/api/access/**
7	/api/caracteristicas/**
10	/api/usuarios
11	/api/usuarios/{id}
12	/api/usuarios/**
14	/api/categorias
8	/api/auth/**
\.


--
-- TOC entry 2948 (class 0 OID 611127)
-- Dependencies: 203
-- Data for Name: producto; Type: TABLE DATA; Schema: public; Owner: rdsadmin
--

COPY public.producto (id, nombre, descripcion, categoria_id) FROM stdin;
30	Habitacion compartida	Habitacion una cama un televisor	4
45	Producto 2025-01-09-1	test from postman UPDATE	4
27	Hostal las margaritas	Habitacion sencilla\nCon cocina compartida	4
29	Hotel Hilton	Una habitacion de lujo	3
46	ALQ - Ropa de lujo	ropa para cenas	5
26	Alquiler vestido elegante	Vestido para fiestas	5
37	Producto 88	Lujosa cabaña en el mar con comida	3
42	Producto test	test from postman 1-2	4
1	Habitacion Doble Cama	Habitacion doble cama con	3
2	Habitación Estándar - Cama extragrande	En Crowne Plaza Huizhou, an IHG Hotel	3
31	Habitacion sencilla	Habitacion una cama un televisor	3
33	Habitacion cama sencilla	Habitacion con cama sencilla, ventilador, desayuno incluido.\nVista al mar lo mejor	3
38	Producto 48	sadsadsa	3
40	Habitacion 5imgs	5 imagenes	3
32	Un solo sofa cama	Sofa cama con televisor	4
34	Lujo de muebles	Adquiera estos muebles de lujo	4
44	Producto 5	test from postman 6	5
\.


--
-- TOC entry 2955 (class 0 OID 611361)
-- Dependencies: 210
-- Data for Name: producto_caracteristica; Type: TABLE DATA; Schema: public; Owner: rdsadmin
--

COPY public.producto_caracteristica (producto_id, caracteristica_id) FROM stdin;
42	3
42	1
45	1
45	2
26	6
37	2
37	3
37	4
37	5
37	7
37	8
37	10
\.


--
-- TOC entry 2950 (class 0 OID 611313)
-- Dependencies: 205
-- Data for Name: recurso_imagen; Type: TABLE DATA; Schema: public; Owner: rdsadmin
--

COPY public.recurso_imagen (id, producto_id, es_imagen_principal, nombre_imagen, locacion_s3, eliminar_en_repositorio) FROM stdin;
33	23	t	pexels-pixabay-59821.jpg	image/20241226115501371_96d90f7b9b9b9031.jpg	f
36	26	t	pexels-frans-van-heerden-201846-802112.jpg	image/20241226214814273_dde6fc5143e471e6.jpg	f
37	27	t	pexels-frans-van-heerden-201846-802112.jpg	image/20241226214835848_dde6fc5143e471e6.jpg	f
39	29	t	pexels-doug-1770706.jpg	image/20241226215400719_e3e4cf776af5ba43.jpg	f
40	30	t	pexels-pixabay-210265.jpg	image/20241227161243809_2cf71fcae4ce59fc.jpg	f
41	32	t	pexels-pixabay-275484.jpg	image/20241227161559341_bd0b1731aaef844b.jpg	f
42	31	t	pexels-pixabay-276724.jpg	image/20241227161924392_77fec43c7708e43a.jpg	f
43	2	t	pexels-curtis-adams-1694007-11018287.jpg	image/20241227162122550_3ffa2e2f52ea55f0.jpg	f
44	1	f	pexels-fotoaibe-1743229.jpg	image/20241228184550143_c2e572a2bf5c440d.jpg	f
45	1	t	pexels-fotoaibe-1743231.jpg	image/20241228184736999_6809b38e576be821.jpg	f
46	33	f	pexels-alexander-f-ungerer-157458816-21701838.jpg	image/20241228201640130_188eb5eb257219b6.jpg	f
47	33	t	pexels-asadphoto-3293192.jpg	image/20241228201640146_ef3089c797008221.jpg	f
48	34	f	pexels-pixabay-276724.jpg	image/20241228212535657_77fec43c7708e43a.jpg	f
49	34	t	pexels-fotoaibe-1669799.jpg	image/20241228212535663_33939eacf0c2adc1.jpg	f
50	34	f	pexels-pixabay-259962.jpg	image/20241228212535668_d77063b6fde4871b.jpg	f
51	35	t	pexels-fotoaibe-1669799.jpg	image/20241228213422788_33939eacf0c2adc1.jpg	f
52	35	f	pexels-pixabay-259962.jpg	image/20241228213422792_d77063b6fde4871b.jpg	f
53	35	f	pexels-pixabay-210265.jpg	image/20241228213422797_2cf71fcae4ce59fc.jpg	f
54	35	f	pexels-pixabay-275484.jpg	image/20241228213422797_bd0b1731aaef844b.jpg	f
55	36	f	pexels-pixabay-276724.jpg	image/20241228213908322_77fec43c7708e43a.jpg	f
56	36	t	pexels-fotoaibe-1669799.jpg	image/20241228213908327_33939eacf0c2adc1.jpg	f
57	36	f	pexels-pixabay-275484.jpg	image/20241228213908336_bd0b1731aaef844b.jpg	f
58	36	f	pexels-asadphoto-3293192.jpg	image/20241228213908349_ef3089c797008221.jpg	f
59	37	f	pexels-pixabay-210265.jpg	image/20241228214027703_2cf71fcae4ce59fc.jpg	f
60	37	f	pexels-alexander-f-ungerer-157458816-21701838.jpg	image/20241228214027690_188eb5eb257219b6.jpg	f
61	37	f	pexels-pixabay-275484.jpg	image/20241228214027716_bd0b1731aaef844b.jpg	f
62	37	t	pexels-asadphoto-3293192.jpg	image/20241228214027729_ef3089c797008221.jpg	f
63	38	f	pexels-pixabay-210265.jpg	image/20241228214146621_2cf71fcae4ce59fc.jpg	f
64	38	f	pexels-pixabay-275484.jpg	image/20241228214146624_bd0b1731aaef844b.jpg	f
65	38	t	pexels-pixabay-259962.jpg	image/20241228214146619_d77063b6fde4871b.jpg	f
67	12	t	pexels-fotoaibe-1743231.jpg	image/20241229162607789_6809b38e576be821.jpg	f
68	40	f	pexels-curtis-adams-1694007-11018287.jpg	image/20241229174242606_3ffa2e2f52ea55f0.jpg	f
69	40	f	pexels-pixabay-259962.jpg	image/20241229174242606_d77063b6fde4871b.jpg	f
70	40	f	pexels-pixabay-275484.jpg	image/20241229174242609_bd0b1731aaef844b.jpg	f
71	40	f	pexels-asadphoto-3293192.jpg	image/20241229174242610_ef3089c797008221.jpg	f
72	40	t	pexels-pixabay-210265.jpg	image/20241229174242607_2cf71fcae4ce59fc.jpg	f
74	44	t	pexels-magali-guimaraes-3411930-5829775.jpg	image/20250109192929589_841f131a9447511a.jpg	f
75	46	t	pexels-israwmx-29226498.jpg	image/20250109220038920_1614c5589e592116.jpg	f
\.


--
-- TOC entry 2957 (class 0 OID 611401)
-- Dependencies: 212
-- Data for Name: rol; Type: TABLE DATA; Schema: public; Owner: rdsadmin
--

COPY public.rol (id, nombre_rol) FROM stdin;
1	Administrador
2	Invitado
3	Cliente
\.


--
-- TOC entry 2968 (class 0 OID 611726)
-- Dependencies: 224
-- Data for Name: rol_capacidad_api; Type: TABLE DATA; Schema: public; Owner: rdsadmin
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
1	1	11
2	1	11
3	1	11
1	3	1
1	6	10
2	6	10
3	6	10
\.


--
-- TOC entry 2960 (class 0 OID 611526)
-- Dependencies: 215
-- Data for Name: rol_capacidad_sitio; Type: TABLE DATA; Schema: public; Owner: rdsadmin
--

COPY public.rol_capacidad_sitio (rol_id, capacidad_id, app_sitio_id, descripcion) FROM stdin;
1	3	1	Acceso a todas las funcionalidades del sitio
2	1	2	Navegación para ver información de los productos
3	4	2	Home
\.


--
-- TOC entry 2962 (class 0 OID 611577)
-- Dependencies: 217
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: rdsadmin
--

COPY public.usuario (id, nombre, apellido, email, password, bloqueado, deshabilitado) FROM stdin;
1	Gloria	Lopez	lpez.gloria2@gmail.com	$2y$14$AGOj0TvuAH5gpyRoxNpnku4Dr/2KxpjLpjcZLUJwEyZlAhLAvI69y	f	f
2	Invitado	No logueado	test@test.com	$2y$14$ZbD4nrq3f5rDy5SA4zQeDOa2HNuB4J4rVmhSgQsuhesAbmPKojTC.	f	f
4	Cleotilde	Galarza	lpez.gloria2+001@gmail.com	12345678910	f	f
8	User guest	creando	lpez.gloria2+005@gmail.com	$2a$10$uo3gIIEXDQTw6xR/gAdaRui9yKCvkziIyQ6jYFtCNpUspU6t2ee6a	f	f
10	Emma	Camero	lpez.gloria2+007@gmail.com	$2a$10$Q7okAzGJUrzlF91fPrg.vuOuQPQ3fN44tWcaLaTG/4tHox.nRjRKO	f	f
11	Jazmin	Sanders	lpez.gloria2+008@gmail.com	$2a$10$RjPLXWwdyAtZ9NgttsX0xeHt5YPO.tMg9u86Pz5tEB9MYP4kj0XIi	f	f
12	Daei	Tols	lpez.gloria2+009@gmail.com	$2a$10$7pI7r9sMmqSsDotFlWd6NeKV17gaigiUarBUPDLl9g9lHIQ.icwpu	f	f
7	Lyana	Stark S.	lpez.gloria2+004@gmail.com	$2a$10$IE4AUK5HOlF7GqbjKmeE6ODSpeUbpbxEzvlZyuLHMxUc.fmqQ2g/a	f	f
13	Miax	Thompson	lpez.gloria2+010@gmail.com	$2a$10$qDYySkDvWzhQfO0AeCwjb.RaESLMWnt51G0OsbAmI6KjuiZ01YyN2	f	f
9	Corben	Dalas	lpez.gloria2+006@gmail.com	$2a$10$0pt/ra/wgTCKKnfNfrCVzOs7mdX2BrqUsWIg/jZdS7blQojJIs7sO	f	f
\.


--
-- TOC entry 2963 (class 0 OID 611591)
-- Dependencies: 218
-- Data for Name: usuario_rol; Type: TABLE DATA; Schema: public; Owner: rdsadmin
--

COPY public.usuario_rol (usuario_id, rol_id) FROM stdin;
1	1
2	2
4	2
8	3
10	3
11	3
12	3
7	1
9	3
13	3
\.


--
-- TOC entry 2984 (class 0 OID 0)
-- Dependencies: 213
-- Name: app_sitio_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rdsadmin
--

SELECT pg_catalog.setval('public.app_sitio_id_seq', 13, true);


--
-- TOC entry 2985 (class 0 OID 0)
-- Dependencies: 219
-- Name: capacidad_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rdsadmin
--

SELECT pg_catalog.setval('public.capacidad_id_seq', 8, true);


--
-- TOC entry 2986 (class 0 OID 0)
-- Dependencies: 208
-- Name: caracteristica_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rdsadmin
--

SELECT pg_catalog.setval('public.caracteristica_id_seq', 10, true);


--
-- TOC entry 2987 (class 0 OID 0)
-- Dependencies: 206
-- Name: categoria_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rdsadmin
--

SELECT pg_catalog.setval('public.categoria_id_seq', 6, true);


--
-- TOC entry 2988 (class 0 OID 0)
-- Dependencies: 221
-- Name: permisos_api_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rdsadmin
--

SELECT pg_catalog.setval('public.permisos_api_id_seq', 14, true);


--
-- TOC entry 2989 (class 0 OID 0)
-- Dependencies: 202
-- Name: producto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rdsadmin
--

SELECT pg_catalog.setval('public.producto_id_seq', 46, true);


--
-- TOC entry 2990 (class 0 OID 0)
-- Dependencies: 204
-- Name: recurso_imagen_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rdsadmin
--

SELECT pg_catalog.setval('public.recurso_imagen_id_seq', 75, true);


--
-- TOC entry 2991 (class 0 OID 0)
-- Dependencies: 211
-- Name: rol_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rdsadmin
--

SELECT pg_catalog.setval('public.rol_id_seq', 3, true);


--
-- TOC entry 2992 (class 0 OID 0)
-- Dependencies: 216
-- Name: usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rdsadmin
--

SELECT pg_catalog.setval('public.usuario_id_seq', 13, true);


--
-- TOC entry 2799 (class 2606 OID 611525)
-- Name: app_sitio app_sitio_pkey; Type: CONSTRAINT; Schema: public; Owner: rdsadmin
--

ALTER TABLE ONLY public.app_sitio
    ADD CONSTRAINT app_sitio_pkey PRIMARY KEY (id);


--
-- TOC entry 2804 (class 2606 OID 611612)
-- Name: capacidad capacidad_pkey; Type: CONSTRAINT; Schema: public; Owner: rdsadmin
--

ALTER TABLE ONLY public.capacidad
    ADD CONSTRAINT capacidad_pkey PRIMARY KEY (id);


--
-- TOC entry 2795 (class 2606 OID 611358)
-- Name: caracteristica caracteristica_pkey; Type: CONSTRAINT; Schema: public; Owner: rdsadmin
--

ALTER TABLE ONLY public.caracteristica
    ADD CONSTRAINT caracteristica_pkey PRIMARY KEY (id);


--
-- TOC entry 2793 (class 2606 OID 611346)
-- Name: categoria categoria_pkey; Type: CONSTRAINT; Schema: public; Owner: rdsadmin
--

ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (id);


--
-- TOC entry 2806 (class 2606 OID 611656)
-- Name: permisos_api permisos_api_pkey; Type: CONSTRAINT; Schema: public; Owner: rdsadmin
--

ALTER TABLE ONLY public.permisos_api
    ADD CONSTRAINT permisos_api_pkey PRIMARY KEY (id);


--
-- TOC entry 2788 (class 2606 OID 611136)
-- Name: producto producto_pkey; Type: CONSTRAINT; Schema: public; Owner: rdsadmin
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_pkey PRIMARY KEY (id);


--
-- TOC entry 2791 (class 2606 OID 611321)
-- Name: recurso_imagen recursoimagen_pkey; Type: CONSTRAINT; Schema: public; Owner: rdsadmin
--

ALTER TABLE ONLY public.recurso_imagen
    ADD CONSTRAINT recursoimagen_pkey PRIMARY KEY (id);


--
-- TOC entry 2797 (class 2606 OID 611407)
-- Name: rol rol_pkey; Type: CONSTRAINT; Schema: public; Owner: rdsadmin
--

ALTER TABLE ONLY public.rol
    ADD CONSTRAINT rol_pkey PRIMARY KEY (id);


--
-- TOC entry 2802 (class 2606 OID 611590)
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: rdsadmin
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id);


--
-- TOC entry 2807 (class 1259 OID 611720)
-- Name: permisos_api_ui; Type: INDEX; Schema: public; Owner: rdsadmin
--

CREATE UNIQUE INDEX permisos_api_ui ON public.permisos_api USING btree (mapping);


--
-- TOC entry 2789 (class 1259 OID 611322)
-- Name: pro_ix; Type: INDEX; Schema: public; Owner: rdsadmin
--

CREATE INDEX pro_ix ON public.recurso_imagen USING btree (producto_id);


--
-- TOC entry 2808 (class 1259 OID 611744)
-- Name: rol_capacidad_api_ui; Type: INDEX; Schema: public; Owner: rdsadmin
--

CREATE UNIQUE INDEX rol_capacidad_api_ui ON public.rol_capacidad_api USING btree (rol_id, capacidad_id, permisos_api_id);


--
-- TOC entry 2800 (class 1259 OID 611547)
-- Name: rol_capacidad_sitio_ui; Type: INDEX; Schema: public; Owner: rdsadmin
--

CREATE UNIQUE INDEX rol_capacidad_sitio_ui ON public.rol_capacidad_sitio USING btree (rol_id, capacidad_id, app_sitio_id);


--
-- TOC entry 2813 (class 2606 OID 611542)
-- Name: rol_capacidad_sitio fk_app_sitio; Type: FK CONSTRAINT; Schema: public; Owner: rdsadmin
--

ALTER TABLE ONLY public.rol_capacidad_sitio
    ADD CONSTRAINT fk_app_sitio FOREIGN KEY (app_sitio_id) REFERENCES public.app_sitio(id);


--
-- TOC entry 2811 (class 2606 OID 611613)
-- Name: rol_capacidad_sitio fk_capacidad; Type: FK CONSTRAINT; Schema: public; Owner: rdsadmin
--

ALTER TABLE ONLY public.rol_capacidad_sitio
    ADD CONSTRAINT fk_capacidad FOREIGN KEY (capacidad_id) REFERENCES public.capacidad(id);


--
-- TOC entry 2817 (class 2606 OID 611734)
-- Name: rol_capacidad_api fk_capacidad; Type: FK CONSTRAINT; Schema: public; Owner: rdsadmin
--

ALTER TABLE ONLY public.rol_capacidad_api
    ADD CONSTRAINT fk_capacidad FOREIGN KEY (capacidad_id) REFERENCES public.capacidad(id);


--
-- TOC entry 2810 (class 2606 OID 611369)
-- Name: producto_caracteristica fk_caracteristica; Type: FK CONSTRAINT; Schema: public; Owner: rdsadmin
--

ALTER TABLE ONLY public.producto_caracteristica
    ADD CONSTRAINT fk_caracteristica FOREIGN KEY (caracteristica_id) REFERENCES public.caracteristica(id);


--
-- TOC entry 2818 (class 2606 OID 611739)
-- Name: rol_capacidad_api fk_permisos_api; Type: FK CONSTRAINT; Schema: public; Owner: rdsadmin
--

ALTER TABLE ONLY public.rol_capacidad_api
    ADD CONSTRAINT fk_permisos_api FOREIGN KEY (permisos_api_id) REFERENCES public.permisos_api(id);


--
-- TOC entry 2809 (class 2606 OID 611364)
-- Name: producto_caracteristica fk_producto; Type: FK CONSTRAINT; Schema: public; Owner: rdsadmin
--

ALTER TABLE ONLY public.producto_caracteristica
    ADD CONSTRAINT fk_producto FOREIGN KEY (producto_id) REFERENCES public.producto(id);


--
-- TOC entry 2812 (class 2606 OID 611532)
-- Name: rol_capacidad_sitio fk_rol; Type: FK CONSTRAINT; Schema: public; Owner: rdsadmin
--

ALTER TABLE ONLY public.rol_capacidad_sitio
    ADD CONSTRAINT fk_rol FOREIGN KEY (rol_id) REFERENCES public.rol(id);


--
-- TOC entry 2815 (class 2606 OID 611599)
-- Name: usuario_rol fk_rol; Type: FK CONSTRAINT; Schema: public; Owner: rdsadmin
--

ALTER TABLE ONLY public.usuario_rol
    ADD CONSTRAINT fk_rol FOREIGN KEY (rol_id) REFERENCES public.rol(id);


--
-- TOC entry 2816 (class 2606 OID 611729)
-- Name: rol_capacidad_api fk_rol; Type: FK CONSTRAINT; Schema: public; Owner: rdsadmin
--

ALTER TABLE ONLY public.rol_capacidad_api
    ADD CONSTRAINT fk_rol FOREIGN KEY (rol_id) REFERENCES public.rol(id);


--
-- TOC entry 2814 (class 2606 OID 611594)
-- Name: usuario_rol fk_usuario; Type: FK CONSTRAINT; Schema: public; Owner: rdsadmin
--

ALTER TABLE ONLY public.usuario_rol
    ADD CONSTRAINT fk_usuario FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


-- Completed on 2025-01-13 19:28:20

--
-- PostgreSQL database dump complete
--


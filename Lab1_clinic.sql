--
-- PostgreSQL database dump
--

\restrict nP7zehKSLqO5UwMpHHPSWIwRocNFxDC3JcNCo8kpOIwrMS1JaxFKOPiKehSl5mU

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

-- Started on 2025-11-13 21:01:36

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5 (class 2615 OID 16505)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 4822 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 16602)
-- Name: doctor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctor (
    doctor_id integer NOT NULL,
    "Full_name" character varying(255) NOT NULL,
    "Email" character varying(255) NOT NULL,
    "Specialization" character varying(255) NOT NULL
);


ALTER TABLE public.doctor OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16601)
-- Name: doctor_doctor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doctor_doctor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.doctor_doctor_id_seq OWNER TO postgres;

--
-- TOC entry 4824 (class 0 OID 0)
-- Dependencies: 219
-- Name: doctor_doctor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctor_doctor_id_seq OWNED BY public.doctor.doctor_id;


--
-- TOC entry 218 (class 1259 OID 16591)
-- Name: patient; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patient (
    patient_id integer NOT NULL,
    "Full_name" character varying(255) NOT NULL,
    "Date_of_birth" date NOT NULL,
    "Email" character varying(255) NOT NULL,
    "Gender" character varying(20) NOT NULL
);


ALTER TABLE public.patient OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16590)
-- Name: patient_patient_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patient_patient_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patient_patient_id_seq OWNER TO postgres;

--
-- TOC entry 4825 (class 0 OID 0)
-- Dependencies: 217
-- Name: patient_patient_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.patient_patient_id_seq OWNED BY public.patient.patient_id;


--
-- TOC entry 222 (class 1259 OID 16613)
-- Name: visit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.visit (
    visit_id integer NOT NULL,
    patient_id integer NOT NULL,
    doctor_id integer NOT NULL,
    date date NOT NULL,
    diagnosis character varying(255) NOT NULL
);


ALTER TABLE public.visit OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16612)
-- Name: visit_visit_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.visit_visit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.visit_visit_id_seq OWNER TO postgres;

--
-- TOC entry 4826 (class 0 OID 0)
-- Dependencies: 221
-- Name: visit_visit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.visit_visit_id_seq OWNED BY public.visit.visit_id;


--
-- TOC entry 4652 (class 2604 OID 16605)
-- Name: doctor doctor_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor ALTER COLUMN doctor_id SET DEFAULT nextval('public.doctor_doctor_id_seq'::regclass);


--
-- TOC entry 4651 (class 2604 OID 16594)
-- Name: patient patient_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient ALTER COLUMN patient_id SET DEFAULT nextval('public.patient_patient_id_seq'::regclass);


--
-- TOC entry 4653 (class 2604 OID 16616)
-- Name: visit visit_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visit ALTER COLUMN visit_id SET DEFAULT nextval('public.visit_visit_id_seq'::regclass);


--
-- TOC entry 4814 (class 0 OID 16602)
-- Dependencies: 220
-- Data for Name: doctor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.doctor (doctor_id, "Full_name", "Email", "Specialization") FROM stdin;
1	Alla	alla@gmail.com	dermatologist
2	Mila	mila@gmail.com	cardiologist
3	Taya	taya@gmail.com	neurologist
\.


--
-- TOC entry 4812 (class 0 OID 16591)
-- Dependencies: 218
-- Data for Name: patient; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patient (patient_id, "Full_name", "Date_of_birth", "Email", "Gender") FROM stdin;
1	Amina	2003-03-13	amina@gmail.com	female
2	Lola	2004-04-28	lola@gmail.com	female
3	Lisa	2003-10-30	lisa@gmail.com	female
\.


--
-- TOC entry 4816 (class 0 OID 16613)
-- Dependencies: 222
-- Data for Name: visit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.visit (visit_id, patient_id, doctor_id, date, diagnosis) FROM stdin;
3	3	3	2025-06-04	ploho ochen
5	1	3	2024-11-18	boli v serce
1	1	1	2024-04-02	pogana shkira ruk
2	2	2	2025-05-12	boli v serce
4	2	1	2025-09-09	shkira oblicha
\.


--
-- TOC entry 4827 (class 0 OID 0)
-- Dependencies: 219
-- Name: doctor_doctor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctor_doctor_id_seq', 1, false);


--
-- TOC entry 4828 (class 0 OID 0)
-- Dependencies: 217
-- Name: patient_patient_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patient_patient_id_seq', 1, false);


--
-- TOC entry 4829 (class 0 OID 0)
-- Dependencies: 221
-- Name: visit_visit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.visit_visit_id_seq', 1, false);


--
-- TOC entry 4655 (class 2606 OID 16600)
-- Name: patient Email; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient
    ADD CONSTRAINT "Email" UNIQUE ("Email");


--
-- TOC entry 4659 (class 2606 OID 16611)
-- Name: doctor Email ; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT "Email " UNIQUE ("Email");


--
-- TOC entry 4661 (class 2606 OID 16609)
-- Name: doctor doctor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT doctor_pkey PRIMARY KEY (doctor_id);


--
-- TOC entry 4657 (class 2606 OID 16598)
-- Name: patient patient_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient
    ADD CONSTRAINT patient_pkey PRIMARY KEY (patient_id);


--
-- TOC entry 4663 (class 2606 OID 16618)
-- Name: visit visit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visit
    ADD CONSTRAINT visit_pkey PRIMARY KEY (visit_id);


--
-- TOC entry 4664 (class 2606 OID 16624)
-- Name: visit doctor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visit
    ADD CONSTRAINT doctor_id FOREIGN KEY (doctor_id) REFERENCES public.doctor(doctor_id) NOT VALID;


--
-- TOC entry 4665 (class 2606 OID 16619)
-- Name: visit patient_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visit
    ADD CONSTRAINT patient_id FOREIGN KEY (patient_id) REFERENCES public.patient(patient_id) NOT VALID;


--
-- TOC entry 4823 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


-- Completed on 2025-11-13 21:01:37

--
-- PostgreSQL database dump complete
--

\unrestrict nP7zehKSLqO5UwMpHHPSWIwRocNFxDC3JcNCo8kpOIwrMS1JaxFKOPiKehSl5mU


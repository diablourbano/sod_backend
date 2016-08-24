--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: countries; Type: TABLE; Schema: public; Owner: diablo; Tablespace: 
--

CREATE TABLE countries (
    id integer NOT NULL,
    name text NOT NULL,
    code integer NOT NULL,
    code_name text
);


ALTER TABLE countries OWNER TO diablo;

--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: diablo
--

CREATE SEQUENCE countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE countries_id_seq OWNER TO diablo;

--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: diablo
--

ALTER SEQUENCE countries_id_seq OWNED BY countries.id;


--
-- Name: incidents; Type: TABLE; Schema: public; Owner: diablo; Tablespace: 
--

CREATE TABLE incidents (
    id integer NOT NULL,
    country_id integer,
    date date,
    kills integer,
    injuries integer
);


ALTER TABLE incidents OWNER TO diablo;

--
-- Name: incidents_id_seq; Type: SEQUENCE; Schema: public; Owner: diablo
--

CREATE SEQUENCE incidents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE incidents_id_seq OWNER TO diablo;

--
-- Name: incidents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: diablo
--

ALTER SEQUENCE incidents_id_seq OWNED BY incidents.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: diablo; Tablespace: 
--

CREATE TABLE schema_migrations (
    filename text NOT NULL
);


ALTER TABLE schema_migrations OWNER TO diablo;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: diablo
--

ALTER TABLE ONLY countries ALTER COLUMN id SET DEFAULT nextval('countries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: diablo
--

ALTER TABLE ONLY incidents ALTER COLUMN id SET DEFAULT nextval('incidents_id_seq'::regclass);


--
-- Name: countries_pkey; Type: CONSTRAINT; Schema: public; Owner: diablo; Tablespace: 
--

ALTER TABLE ONLY countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: incidents_pkey; Type: CONSTRAINT; Schema: public; Owner: diablo; Tablespace: 
--

ALTER TABLE ONLY incidents
    ADD CONSTRAINT incidents_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: diablo; Tablespace: 
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (filename);


--
-- Name: incidents_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: diablo
--

ALTER TABLE ONLY incidents
    ADD CONSTRAINT incidents_country_id_fkey FOREIGN KEY (country_id) REFERENCES countries(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--


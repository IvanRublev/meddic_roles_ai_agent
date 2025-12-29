--
-- PostgreSQL database dump
--


-- Dumped from database version 15.15
-- Dumped by pg_dump version 18.1

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
-- Name: meddic_roles_ai_agent; Type: DATABASE; Schema: -; Owner: {{POSTGRES_USER}}
--



ALTER DATABASE meddic_roles_ai_agent OWNER TO {{POSTGRES_USER}};

\connect meddic_roles_ai_agent

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: companies; Type: TABLE; Schema: public; Owner: {{POSTGRES_USER}}
--

CREATE TABLE public.companies (
    id integer NOT NULL,
    crm_id bigint NOT NULL,
    company_name text,
    industry text,
    number_of_employees integer,
    annual_revenue text,
    year_founded integer,
    country text,
    inserted_at timestamp without time zone NOT NULL
);


ALTER TABLE public.companies OWNER TO {{POSTGRES_USER}};

--
-- Name: TABLE companies; Type: COMMENT; Schema: public; Owner: {{POSTGRES_USER}}
--

COMMENT ON TABLE public.companies IS 'Add only table. When the object is updated on CRM side insert a new record with the same crm_id.';


--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: {{POSTGRES_USER}}
--

ALTER TABLE public.companies ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: contacts; Type: TABLE; Schema: public; Owner: {{POSTGRES_USER}}
--

CREATE TABLE public.contacts (
    id integer NOT NULL,
    company_id integer NOT NULL,
    crm_id bigint NOT NULL,
    first_name text,
    last_name text,
    employment_seniority text,
    employment_role text,
    employment_sub_role text,
    work_experience text,
    work_experience_md5 text,
    inserted_at timestamp without time zone NOT NULL,
    classification_attempts integer NOT NULL,
    soft_deleted boolean NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.contacts OWNER TO {{POSTGRES_USER}};

--
-- Name: TABLE contacts; Type: COMMENT; Schema: public; Owner: {{POSTGRES_USER}}
--

COMMENT ON TABLE public.contacts IS 'Add only table. When the object is updated on CRM side insert a new record with the same crm_id.';


--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: {{POSTGRES_USER}}
--

ALTER TABLE public.contacts ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: get_contacts_for_enrichment_executions; Type: TABLE; Schema: public; Owner: {{POSTGRES_USER}}
--

CREATE TABLE public.get_contacts_for_enrichment_executions (
    id integer NOT NULL,
    execution_id integer NOT NULL,
    batch_size integer,
    contacts jsonb
);


ALTER TABLE public.get_contacts_for_enrichment_executions OWNER TO {{POSTGRES_USER}};

--
-- Name: get_contacts_for_enrichment_executions_id_seq; Type: SEQUENCE; Schema: public; Owner: {{POSTGRES_USER}}
--

ALTER TABLE public.get_contacts_for_enrichment_executions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.get_contacts_for_enrichment_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: llm_prices; Type: TABLE; Schema: public; Owner: {{POSTGRES_USER}}
--

CREATE TABLE public.llm_prices (
    id integer NOT NULL,
    llm_prices jsonb,
    inserted_at timestamp without time zone NOT NULL
);


ALTER TABLE public.llm_prices OWNER TO {{POSTGRES_USER}};

--
-- Name: llm_prices_id_seq; Type: SEQUENCE; Schema: public; Owner: {{POSTGRES_USER}}
--

ALTER TABLE public.llm_prices ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.llm_prices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: meddic_roles; Type: TABLE; Schema: public; Owner: {{POSTGRES_USER}}
--

CREATE TABLE public.meddic_roles (
    id integer NOT NULL,
    contact_id integer NOT NULL,
    company_id integer NOT NULL,
    llm_prompt text,
    llm_tokens_in integer,
    llm_tokens_out integer,
    llm_tokens_cached integer,
    llm_cost_usd numeric,
    llm_duration_sec integer,
    llm_output_schema jsonb,
    output jsonb,
    execution_id integer NOT NULL,
    inserted_at timestamp without time zone NOT NULL
);


ALTER TABLE public.meddic_roles OWNER TO {{POSTGRES_USER}};

--
-- Name: meddic_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: {{POSTGRES_USER}}
--

ALTER TABLE public.meddic_roles ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.meddic_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: organisational_hypothesises; Type: TABLE; Schema: public; Owner: {{POSTGRES_USER}}
--

CREATE TABLE public.organisational_hypothesises (
    id integer NOT NULL,
    company_id integer NOT NULL,
    llm_prompt text,
    llm_tokens_in integer,
    llm_tokens_out integer,
    llm_tokens_cached integer,
    llm_cost_usd numeric,
    llm_duration_sec integer,
    organizational_hypothesis text,
    execution_id integer NOT NULL,
    inserted_at timestamp without time zone NOT NULL
);


ALTER TABLE public.organisational_hypothesises OWNER TO {{POSTGRES_USER}};

--
-- Name: organisational_hypothesises_id_seq; Type: SEQUENCE; Schema: public; Owner: {{POSTGRES_USER}}
--

ALTER TABLE public.organisational_hypothesises ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.organisational_hypothesises_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: outbound_crm_updates; Type: TABLE; Schema: public; Owner: {{POSTGRES_USER}}
--

CREATE TABLE public.outbound_crm_updates (
    id integer NOT NULL,
    contact_id integer NOT NULL,
    llm_total_tokens_in integer,
    llm_total_tokens_out integer,
    llm_total_tokens_cached integer,
    llm_total_cost_usd numeric,
    llm_total_duration_sec integer,
    workflow_item_total_duration_sec integer,
    role text,
    confidence_score integer,
    rationale text,
    contact_fields jsonb,
    execution_id integer NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    uploaded_at timestamp without time zone,
    upload_attempts integer NOT NULL,
    last_status_code integer,
    last_error jsonb
);


ALTER TABLE public.outbound_crm_updates OWNER TO {{POSTGRES_USER}};

--
-- Name: TABLE outbound_crm_updates; Type: COMMENT; Schema: public; Owner: {{POSTGRES_USER}}
--

COMMENT ON TABLE public.outbound_crm_updates IS 'Can have duplicate records for same contact_id';


--
-- Name: outbound_crm_updates_id_seq; Type: SEQUENCE; Schema: public; Owner: {{POSTGRES_USER}}
--

ALTER TABLE public.outbound_crm_updates ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.outbound_crm_updates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: rationales; Type: TABLE; Schema: public; Owner: {{POSTGRES_USER}}
--

CREATE TABLE public.rationales (
    id integer NOT NULL,
    meddic_role_id integer NOT NULL,
    llm_prompt text,
    llm_tokens_in integer,
    llm_tokens_out integer,
    llm_tokens_cached integer,
    llm_cost_usd numeric,
    llm_duration_sec integer,
    rationale text,
    execution_id integer NOT NULL,
    inserted_at timestamp without time zone NOT NULL
);


ALTER TABLE public.rationales OWNER TO {{POSTGRES_USER}};

--
-- Name: rationales_id_seq; Type: SEQUENCE; Schema: public; Owner: {{POSTGRES_USER}}
--

ALTER TABLE public.rationales ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.rationales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: {{POSTGRES_USER}}
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: contacts contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: {{POSTGRES_USER}}
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: get_contacts_for_enrichment_executions get_contacts_for_enrichment_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: {{POSTGRES_USER}}
--

ALTER TABLE ONLY public.get_contacts_for_enrichment_executions
    ADD CONSTRAINT get_contacts_for_enrichment_executions_pkey PRIMARY KEY (id);


--
-- Name: llm_prices llm_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: {{POSTGRES_USER}}
--

ALTER TABLE ONLY public.llm_prices
    ADD CONSTRAINT llm_prices_pkey PRIMARY KEY (id);


--
-- Name: meddic_roles meddic_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: {{POSTGRES_USER}}
--

ALTER TABLE ONLY public.meddic_roles
    ADD CONSTRAINT meddic_roles_pkey PRIMARY KEY (id);


--
-- Name: organisational_hypothesises organisational_hypothesises_pkey; Type: CONSTRAINT; Schema: public; Owner: {{POSTGRES_USER}}
--

ALTER TABLE ONLY public.organisational_hypothesises
    ADD CONSTRAINT organisational_hypothesises_pkey PRIMARY KEY (id);


--
-- Name: outbound_crm_updates outbound_crm_updates_pkey; Type: CONSTRAINT; Schema: public; Owner: {{POSTGRES_USER}}
--

ALTER TABLE ONLY public.outbound_crm_updates
    ADD CONSTRAINT outbound_crm_updates_pkey PRIMARY KEY (id);


--
-- Name: rationales rationales_pkey; Type: CONSTRAINT; Schema: public; Owner: {{POSTGRES_USER}}
--

ALTER TABLE ONLY public.rationales
    ADD CONSTRAINT rationales_pkey PRIMARY KEY (id);


--
-- Name: companies_crm_id_idx; Type: INDEX; Schema: public; Owner: {{POSTGRES_USER}}
--

CREATE INDEX companies_crm_id_idx ON public.companies USING btree (crm_id);


--
-- Name: contacts_crm_id_idx; Type: INDEX; Schema: public; Owner: {{POSTGRES_USER}}
--

CREATE INDEX contacts_crm_id_idx ON public.contacts USING btree (crm_id);


--
-- Name: contacts_crm_soft_deleted_idx; Type: INDEX; Schema: public; Owner: {{POSTGRES_USER}}
--

CREATE INDEX contacts_crm_soft_deleted_idx ON public.contacts USING btree (soft_deleted);


--
-- Name: get_contacts_for_enrichment_executions_execution_id_idx; Type: INDEX; Schema: public; Owner: {{POSTGRES_USER}}
--

CREATE INDEX get_contacts_for_enrichment_executions_execution_id_idx ON public.get_contacts_for_enrichment_executions USING btree (execution_id);


--
-- Name: llm_prices_inserted_at_idx; Type: INDEX; Schema: public; Owner: {{POSTGRES_USER}}
--

CREATE INDEX llm_prices_inserted_at_idx ON public.llm_prices USING btree (inserted_at);


--
-- Name: meddic_roles_company_id_contact_id_idx; Type: INDEX; Schema: public; Owner: {{POSTGRES_USER}}
--

CREATE UNIQUE INDEX meddic_roles_company_id_contact_id_idx ON public.meddic_roles USING btree (company_id, contact_id);


--
-- Name: organisational_hypothesises_company_id_idx; Type: INDEX; Schema: public; Owner: {{POSTGRES_USER}}
--

CREATE UNIQUE INDEX organisational_hypothesises_company_id_idx ON public.organisational_hypothesises USING btree (company_id);


--
-- Name: outbound_crm_updates_contact_id; Type: INDEX; Schema: public; Owner: {{POSTGRES_USER}}
--

CREATE UNIQUE INDEX outbound_crm_updates_contact_id ON public.outbound_crm_updates USING btree (contact_id);


--
-- Name: outbound_crm_updates_uploaded_at_idx; Type: INDEX; Schema: public; Owner: {{POSTGRES_USER}}
--

CREATE INDEX outbound_crm_updates_uploaded_at_idx ON public.outbound_crm_updates USING btree (uploaded_at);


--
-- Name: rationales_meddic_role_idx; Type: INDEX; Schema: public; Owner: {{POSTGRES_USER}}
--

CREATE UNIQUE INDEX rationales_meddic_role_idx ON public.rationales USING btree (meddic_role_id);


--
-- Name: contacts contacts_company_fkey; Type: FK CONSTRAINT; Schema: public; Owner: {{POSTGRES_USER}}
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_company_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: meddic_roles meddic_roles_company_fkey; Type: FK CONSTRAINT; Schema: public; Owner: {{POSTGRES_USER}}
--

ALTER TABLE ONLY public.meddic_roles
    ADD CONSTRAINT meddic_roles_company_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: meddic_roles meddic_roles_contact_fkey; Type: FK CONSTRAINT; Schema: public; Owner: {{POSTGRES_USER}}
--

ALTER TABLE ONLY public.meddic_roles
    ADD CONSTRAINT meddic_roles_contact_fkey FOREIGN KEY (contact_id) REFERENCES public.contacts(id) ON DELETE CASCADE;


--
-- Name: organisational_hypothesises organisational_hypothesises_company_fkey; Type: FK CONSTRAINT; Schema: public; Owner: {{POSTGRES_USER}}
--

ALTER TABLE ONLY public.organisational_hypothesises
    ADD CONSTRAINT organisational_hypothesises_company_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: outbound_crm_updates outbound_crm_updates_contact_fkey; Type: FK CONSTRAINT; Schema: public; Owner: {{POSTGRES_USER}}
--

ALTER TABLE ONLY public.outbound_crm_updates
    ADD CONSTRAINT outbound_crm_updates_contact_fkey FOREIGN KEY (contact_id) REFERENCES public.contacts(id) ON DELETE CASCADE;


--
-- Name: rationales rationales_meddic_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: {{POSTGRES_USER}}
--

ALTER TABLE ONLY public.rationales
    ADD CONSTRAINT rationales_meddic_role_fkey FOREIGN KEY (meddic_role_id) REFERENCES public.meddic_roles(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--



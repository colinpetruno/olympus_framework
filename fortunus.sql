--
-- PostgreSQL database dump
--

-- Dumped from database version 12.4
-- Dumped by pg_dump version 12.4

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
-- Name: billing_charges; Type: TABLE; Schema: public; Owner: colinpetruno
--

CREATE TABLE public.billing_charges (
    id bigint NOT NULL,
    billing_source_id bigint NOT NULL,
    billing_payment_intent_id bigint NOT NULL,
    amount integer NOT NULL,
    refund_amount integer NOT NULL,
    captured boolean DEFAULT false NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    currency character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    failure_code character varying,
    failure_reason character varying,
    billing_invoice_id integer NOT NULL
);


ALTER TABLE public.billing_charges OWNER TO colinpetruno;

--
-- Name: billing_charges_id_seq; Type: SEQUENCE; Schema: public; Owner: colinpetruno
--

CREATE SEQUENCE public.billing_charges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.billing_charges_id_seq OWNER TO colinpetruno;

--
-- Name: billing_charges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: colinpetruno
--

ALTER SEQUENCE public.billing_charges_id_seq OWNED BY public.billing_charges.id;


--
-- Name: billing_customers; Type: TABLE; Schema: public; Owner: colinpetruno
--

CREATE TABLE public.billing_customers (
    id bigint NOT NULL,
    external_id character varying NOT NULL,
    provider integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    customerable_type character varying,
    customerable_id bigint
);


ALTER TABLE public.billing_customers OWNER TO colinpetruno;

--
-- Name: billing_customers_id_seq; Type: SEQUENCE; Schema: public; Owner: colinpetruno
--

CREATE SEQUENCE public.billing_customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.billing_customers_id_seq OWNER TO colinpetruno;

--
-- Name: billing_customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: colinpetruno
--

ALTER SEQUENCE public.billing_customers_id_seq OWNED BY public.billing_customers.id;


--
-- Name: billing_details; Type: TABLE; Schema: public; Owner: colinpetruno
--

CREATE TABLE public.billing_details (
    id bigint NOT NULL,
    tax_number character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    entity_type integer DEFAULT 0 NOT NULL,
    entity_name character varying NOT NULL,
    detailable_type character varying NOT NULL,
    detailable_id bigint NOT NULL,
    account_default boolean DEFAULT false NOT NULL
);


ALTER TABLE public.billing_details OWNER TO colinpetruno;

--
-- Name: billing_details_id_seq; Type: SEQUENCE; Schema: public; Owner: colinpetruno
--

CREATE SEQUENCE public.billing_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.billing_details_id_seq OWNER TO colinpetruno;

--
-- Name: billing_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: colinpetruno
--

ALTER SEQUENCE public.billing_details_id_seq OWNED BY public.billing_details.id;


--
-- Name: billing_downgrades; Type: TABLE; Schema: public; Owner: colinpetruno
--

CREATE TABLE public.billing_downgrades (
    id bigint NOT NULL,
    profile_id bigint NOT NULL,
    billing_subscription_id bigint NOT NULL,
    downgraded_at timestamp without time zone NOT NULL,
    reason text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    deleted_at timestamp without time zone
);


ALTER TABLE public.billing_downgrades OWNER TO colinpetruno;

--
-- Name: billing_downgrades_id_seq; Type: SEQUENCE; Schema: public; Owner: colinpetruno
--

CREATE SEQUENCE public.billing_downgrades_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.billing_downgrades_id_seq OWNER TO colinpetruno;

--
-- Name: billing_downgrades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: colinpetruno
--

ALTER SEQUENCE public.billing_downgrades_id_seq OWNED BY public.billing_downgrades.id;


--
-- Name: billing_external_ids; Type: TABLE; Schema: public; Owner: colinpetruno
--

CREATE TABLE public.billing_external_ids (
    id bigint NOT NULL,
    external_id character varying NOT NULL,
    objectable_type character varying,
    objectable_id bigint
);


ALTER TABLE public.billing_external_ids OWNER TO colinpetruno;

--
-- Name: billing_external_ids_id_seq; Type: SEQUENCE; Schema: public; Owner: colinpetruno
--

CREATE SEQUENCE public.billing_external_ids_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.billing_external_ids_id_seq OWNER TO colinpetruno;

--
-- Name: billing_external_ids_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: colinpetruno
--

ALTER SEQUENCE public.billing_external_ids_id_seq OWNED BY public.billing_external_ids.id;


--
-- Name: billing_features; Type: TABLE; Schema: public; Owner: colinpetruno
--

CREATE TABLE public.billing_features (
    id bigint NOT NULL,
    feature_name character varying NOT NULL,
    feature_key character varying NOT NULL,
    default_type integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    measuring_type integer DEFAULT 0 NOT NULL,
    quantity integer DEFAULT 0 NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    unlimited boolean DEFAULT false NOT NULL
);


ALTER TABLE public.billing_features OWNER TO colinpetruno;

--
-- Name: billing_features_id_seq; Type: SEQUENCE; Schema: public; Owner: colinpetruno
--

CREATE SEQUENCE public.billing_features_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.billing_features_id_seq OWNER TO colinpetruno;

--
-- Name: billing_features_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: colinpetruno
--

ALTER SEQUENCE public.billing_features_id_seq OWNED BY public.billing_features.id;


--
-- Name: billing_invoices; Type: TABLE; Schema: public; Owner: colinpetruno
--

CREATE TABLE public.billing_invoices (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    currency_code character varying NOT NULL,
    subtotal integer NOT NULL,
    tax integer DEFAULT 0 NOT NULL,
    total integer NOT NULL,
    amount_due integer NOT NULL,
    amount_paid integer DEFAULT 0 NOT NULL,
    amount_remaining integer NOT NULL,
    invoiceable_type character varying NOT NULL,
    invoiceable_id bigint NOT NULL,
    number character varying
);


ALTER TABLE public.billing_invoices OWNER TO colinpetruno;

--
-- Name: billing_invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: colinpetruno
--

CREATE SEQUENCE public.billing_invoices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.billing_invoices_id_seq OWNER TO colinpetruno;

--
-- Name: billing_invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: colinpetruno
--

ALTER SEQUENCE public.billing_invoices_id_seq OWNED BY public.billing_invoices.id;


--
-- Name: billing_payment_intents; Type: TABLE; Schema: public; Owner: colinpetruno
--

CREATE TABLE public.billing_payment_intents (
    id bigint NOT NULL,
    payable_id integer NOT NULL,
    payable_type character varying NOT NULL,
    started_at timestamp without time zone NOT NULL,
    profile_id integer,
    uuid character varying NOT NULL,
    terms_accepted_on timestamp without time zone,
    external_id character varying,
    billing_source_id integer,
    chargeable_type character varying,
    chargeable_id bigint,
    status integer DEFAULT 0 NOT NULL,
    targetable_type character varying NOT NULL,
    targetable_id bigint NOT NULL,
    billable_type character varying NOT NULL,
    billable_id bigint NOT NULL,
    billing_invoice_id integer
);


ALTER TABLE public.billing_payment_intents OWNER TO colinpetruno;

--
-- Name: billing_payment_intents_id_seq; Type: SEQUENCE; Schema: public; Owner: colinpetruno
--

CREATE SEQUENCE public.billing_payment_intents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.billing_payment_intents_id_seq OWNER TO colinpetruno;

--
-- Name: billing_payment_intents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: colinpetruno
--

ALTER SEQUENCE public.billing_payment_intents_id_seq OWNED BY public.billing_payment_intents.id;


--
-- Name: billing_prices; Type: TABLE; Schema: public; Owner: colinpetruno
--

CREATE TABLE public.billing_prices (
    id bigint NOT NULL,
    "interval" character varying NOT NULL,
    amount integer NOT NULL,
    currency character varying NOT NULL,
    billing_product_id integer NOT NULL,
    active boolean DEFAULT true,
    deleted_at timestamp without time zone
);


ALTER TABLE public.billing_prices OWNER TO colinpetruno;

--
-- Name: billing_prices_id_seq; Type: SEQUENCE; Schema: public; Owner: colinpetruno
--

CREATE SEQUENCE public.billing_prices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.billing_prices_id_seq OWNER TO colinpetruno;

--
-- Name: billing_prices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: colinpetruno
--

ALTER SEQUENCE public.billing_prices_id_seq OWNED BY public.billing_prices.id;


--
-- Name: billing_product_features; Type: TABLE; Schema: public; Owner: colinpetruno
--

CREATE TABLE public.billing_product_features (
    id bigint NOT NULL,
    billing_product_id bigint NOT NULL,
    billing_feature_id bigint NOT NULL,
    measuring_type integer DEFAULT 0 NOT NULL,
    quantity integer NOT NULL,
    enabled integer DEFAULT 0 NOT NULL,
    unlimited boolean DEFAULT false NOT NULL
);


ALTER TABLE public.billing_product_features OWNER TO colinpetruno;

--
-- Name: billing_product_features_id_seq; Type: SEQUENCE; Schema: public; Owner: colinpetruno
--

CREATE SEQUENCE public.billing_product_features_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.billing_product_features_id_seq OWNER TO colinpetruno;

--
-- Name: billing_product_features_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: colinpetruno
--

ALTER SEQUENCE public.billing_product_features_id_seq OWNED BY public.billing_product_features.id;


--
-- Name: billing_products; Type: TABLE; Schema: public; Owner: colinpetruno
--

CREATE TABLE public.billing_products (
    id bigint NOT NULL,
    visible boolean DEFAULT false NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    name character varying NOT NULL,
    description character varying,
    subscription_default boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone
);


ALTER TABLE public.billing_products OWNER TO colinpetruno;

--
-- Name: billing_products_id_seq; Type: SEQUENCE; Schema: public; Owner: colinpetruno
--

CREATE SEQUENCE public.billing_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.billing_products_id_seq OWNER TO colinpetruno;

--
-- Name: billing_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: colinpetruno
--

ALTER SEQUENCE public.billing_products_id_seq OWNED BY public.billing_products.id;


--
-- Name: billing_sources; Type: TABLE; Schema: public; Owner: colinpetruno
--

CREATE TABLE public.billing_sources (
    id bigint NOT NULL,
    created_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    source_type integer DEFAULT 0 NOT NULL,
    deleted_at timestamp without time zone,
    "default" boolean DEFAULT false NOT NULL,
    exp_year integer,
    exp_month integer,
    brand character varying,
    last_four character varying,
    sourceable_type character varying,
    sourceable_id bigint,
    billing_detail_id integer NOT NULL
);


ALTER TABLE public.billing_sources OWNER TO colinpetruno;

--
-- Name: billing_sources_id_seq; Type: SEQUENCE; Schema: public; Owner: colinpetruno
--

CREATE SEQUENCE public.billing_sources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.billing_sources_id_seq OWNER TO colinpetruno;

--
-- Name: billing_sources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: colinpetruno
--

ALTER SEQUENCE public.billing_sources_id_seq OWNED BY public.billing_sources.id;


--
-- Name: billing_subscriptions; Type: TABLE; Schema: public; Owner: colinpetruno
--

CREATE TABLE public.billing_subscriptions (
    id bigint NOT NULL,
    active boolean NOT NULL,
    subscribeable_type character varying NOT NULL,
    subscribeable_id bigint NOT NULL,
    last_paid_date integer,
    paid_until_date integer,
    cancelled_at timestamp without time zone,
    ownerable_type character varying NOT NULL,
    ownerable_id bigint NOT NULL
);


ALTER TABLE public.billing_subscriptions OWNER TO colinpetruno;

--
-- Name: billing_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: colinpetruno
--

CREATE SEQUENCE public.billing_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.billing_subscriptions_id_seq OWNER TO colinpetruno;

--
-- Name: billing_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: colinpetruno
--

ALTER SEQUENCE public.billing_subscriptions_id_seq OWNED BY public.billing_subscriptions.id;


--
-- Name: billing_vat_rates; Type: TABLE; Schema: public; Owner: colinpetruno
--

CREATE TABLE public.billing_vat_rates (
    id bigint NOT NULL,
    display_name character varying NOT NULL,
    jurisdiction character varying NOT NULL,
    active boolean DEFAULT true NOT NULL,
    inclusive_type integer DEFAULT 0 NOT NULL,
    percentage integer DEFAULT 0 NOT NULL,
    default_rate boolean DEFAULT false NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.billing_vat_rates OWNER TO colinpetruno;

--
-- Name: billing_vat_rates_id_seq; Type: SEQUENCE; Schema: public; Owner: colinpetruno
--

CREATE SEQUENCE public.billing_vat_rates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.billing_vat_rates_id_seq OWNER TO colinpetruno;

--
-- Name: billing_vat_rates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: colinpetruno
--

ALTER SEQUENCE public.billing_vat_rates_id_seq OWNED BY public.billing_vat_rates.id;


--
-- Name: billing_webhooks; Type: TABLE; Schema: public; Owner: colinpetruno
--

CREATE TABLE public.billing_webhooks (
    id bigint NOT NULL,
    provider integer DEFAULT 0 NOT NULL,
    processed_at timestamp without time zone,
    process_status integer,
    process_result text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    payload text NOT NULL
);


ALTER TABLE public.billing_webhooks OWNER TO colinpetruno;

--
-- Name: billing_webhooks_id_seq; Type: SEQUENCE; Schema: public; Owner: colinpetruno
--

CREATE SEQUENCE public.billing_webhooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.billing_webhooks_id_seq OWNER TO colinpetruno;

--
-- Name: billing_webhooks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: colinpetruno
--

ALTER SEQUENCE public.billing_webhooks_id_seq OWNED BY public.billing_webhooks.id;


--
-- Name: billing_charges id; Type: DEFAULT; Schema: public; Owner: colinpetruno
--

ALTER TABLE ONLY public.billing_charges ALTER COLUMN id SET DEFAULT nextval('public.billing_charges_id_seq'::regclass);


--
-- Name: billing_customers id; Type: DEFAULT; Schema: public; Owner: colinpetruno
--

ALTER TABLE ONLY public.billing_customers ALTER COLUMN id SET DEFAULT nextval('public.billing_customers_id_seq'::regclass);


--
-- Name: billing_details id; Type: DEFAULT; Schema: public; Owner: colinpetruno
--

ALTER TABLE ONLY public.billing_details ALTER COLUMN id SET DEFAULT nextval('public.billing_details_id_seq'::regclass);


--
-- Name: billing_downgrades id; Type: DEFAULT; Schema: public; Owner: colinpetruno
--

ALTER TABLE ONLY public.billing_downgrades ALTER COLUMN id SET DEFAULT nextval('public.billing_downgrades_id_seq'::regclass);


--
-- Name: billing_external_ids id; Type: DEFAULT; Schema: public; Owner: colinpetruno
--

ALTER TABLE ONLY public.billing_external_ids ALTER COLUMN id SET DEFAULT nextval('public.billing_external_ids_id_seq'::regclass);


--
-- Name: billing_features id; Type: DEFAULT; Schema: public; Owner: colinpetruno
--

ALTER TABLE ONLY public.billing_features ALTER COLUMN id SET DEFAULT nextval('public.billing_features_id_seq'::regclass);


--
-- Name: billing_invoices id; Type: DEFAULT; Schema: public; Owner: colinpetruno
--

ALTER TABLE ONLY public.billing_invoices ALTER COLUMN id SET DEFAULT nextval('public.billing_invoices_id_seq'::regclass);


--
-- Name: billing_payment_intents id; Type: DEFAULT; Schema: public; Owner: colinpetruno
--

ALTER TABLE ONLY public.billing_payment_intents ALTER COLUMN id SET DEFAULT nextval('public.billing_payment_intents_id_seq'::regclass);


--
-- Name: billing_prices id; Type: DEFAULT; Schema: public; Owner: colinpetruno
--

ALTER TABLE ONLY public.billing_prices ALTER COLUMN id SET DEFAULT nextval('public.billing_prices_id_seq'::regclass);


--
-- Name: billing_product_features id; Type: DEFAULT; Schema: public; Owner: colinpetruno
--

ALTER TABLE ONLY public.billing_product_features ALTER COLUMN id SET DEFAULT nextval('public.billing_product_features_id_seq'::regclass);


--
-- Name: billing_products id; Type: DEFAULT; Schema: public; Owner: colinpetruno
--

ALTER TABLE ONLY public.billing_products ALTER COLUMN id SET DEFAULT nextval('public.billing_products_id_seq'::regclass);


--
-- Name: billing_sources id; Type: DEFAULT; Schema: public; Owner: colinpetruno
--

ALTER TABLE ONLY public.billing_sources ALTER COLUMN id SET DEFAULT nextval('public.billing_sources_id_seq'::regclass);


--
-- Name: billing_subscriptions id; Type: DEFAULT; Schema: public; Owner: colinpetruno
--

ALTER TABLE ONLY public.billing_subscriptions ALTER COLUMN id SET DEFAULT nextval('public.billing_subscriptions_id_seq'::regclass);


--
-- Name: billing_vat_rates id; Type: DEFAULT; Schema: public; Owner: colinpetruno
--

ALTER TABLE ONLY public.billing_vat_rates ALTER COLUMN id SET DEFAULT nextval('public.billing_vat_rates_id_seq'::regclass);


--
-- Name: billing_webhooks id; Type: DEFAULT; Schema: public; Owner: colinpetruno
--

ALTER TABLE ONLY public.billing_webhooks ALTER COLUMN id SET DEFAULT nextval('public.billing_webhooks_id_seq'::regclass);


--
-- Name: billing_charges billing_charges_pkey; Type: CONSTRAINT; Schema: public; Owner: colinpetruno
--

ALTER TABLE ONLY public.billing_charges
    ADD CONSTRAINT billing_charges_pkey PRIMARY KEY (id);


--
-- Name: billing_customers billing_customers_pkey; Type: CONSTRAINT; Schema: public; Owner: colinpetruno
--

ALTER TABLE ONLY public.billing_customers
    ADD CONSTRAINT billing_customers_pkey PRIMARY KEY (id);


--
-- Name: billing_details billing_details_pkey; Type: CONSTRAINT; Schema: public; Owner: colinpetruno
--

ALTER TABLE ONLY public.billing_details
    ADD CONSTRAINT billing_details_pkey PRIMARY KEY (id);


--
-- Name: billing_downgrades billing_downgrades_pkey; Type: CONSTRAINT; Schema: public; Owner: colinpetruno
--

ALTER TABLE ONLY public.billing_downgrades
    ADD CONSTRAINT billing_downgrades_pkey PRIMARY KEY (id);


--
-- Name: billing_external_ids billing_external_ids_pkey; Type: CONSTRAINT; Schema: public; Owner: colinpetruno
--

ALTER TABLE ONLY public.billing_external_ids
    ADD CONSTRAINT billing_external_ids_pkey PRIMARY KEY (id);


--
-- Name: billing_features billing_features_pkey; Type: CONSTRAINT; Schema: public; Owner: colinpetruno
--

ALTER TABLE ONLY public.billing_features
    ADD CONSTRAINT billing_features_pkey PRIMARY KEY (id);


--
-- Name: billing_invoices billing_invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: colinpetruno
--

ALTER TABLE ONLY public.billing_invoices
    ADD CONSTRAINT billing_invoices_pkey PRIMARY KEY (id);


--
-- Name: billing_payment_intents billing_payment_intents_pkey; Type: CONSTRAINT; Schema: public; Owner: colinpetruno
--

ALTER TABLE ONLY public.billing_payment_intents
    ADD CONSTRAINT billing_payment_intents_pkey PRIMARY KEY (id);


--
-- Name: billing_prices billing_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: colinpetruno
--

ALTER TABLE ONLY public.billing_prices
    ADD CONSTRAINT billing_prices_pkey PRIMARY KEY (id);


--
-- Name: billing_product_features billing_product_features_pkey; Type: CONSTRAINT; Schema: public; Owner: colinpetruno
--

ALTER TABLE ONLY public.billing_product_features
    ADD CONSTRAINT billing_product_features_pkey PRIMARY KEY (id);


--
-- Name: billing_products billing_products_pkey; Type: CONSTRAINT; Schema: public; Owner: colinpetruno
--

ALTER TABLE ONLY public.billing_products
    ADD CONSTRAINT billing_products_pkey PRIMARY KEY (id);


--
-- Name: billing_sources billing_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: colinpetruno
--

ALTER TABLE ONLY public.billing_sources
    ADD CONSTRAINT billing_sources_pkey PRIMARY KEY (id);


--
-- Name: billing_subscriptions billing_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: colinpetruno
--

ALTER TABLE ONLY public.billing_subscriptions
    ADD CONSTRAINT billing_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: billing_vat_rates billing_vat_rates_pkey; Type: CONSTRAINT; Schema: public; Owner: colinpetruno
--

ALTER TABLE ONLY public.billing_vat_rates
    ADD CONSTRAINT billing_vat_rates_pkey PRIMARY KEY (id);


--
-- Name: billing_webhooks billing_webhooks_pkey; Type: CONSTRAINT; Schema: public; Owner: colinpetruno
--

ALTER TABLE ONLY public.billing_webhooks
    ADD CONSTRAINT billing_webhooks_pkey PRIMARY KEY (id);


--
-- Name: bc_customerable_id_and_type_idx; Type: INDEX; Schema: public; Owner: colinpetruno
--

CREATE INDEX bc_customerable_id_and_type_idx ON public.billing_customers USING btree (customerable_type, customerable_id);


--
-- Name: bpi_chargable_idx; Type: INDEX; Schema: public; Owner: colinpetruno
--

CREATE INDEX bpi_chargable_idx ON public.billing_payment_intents USING btree (chargeable_type, chargeable_id);


--
-- Name: bpi_targetable_idx; Type: INDEX; Schema: public; Owner: colinpetruno
--

CREATE INDEX bpi_targetable_idx ON public.billing_payment_intents USING btree (targetable_type, targetable_id);


--
-- Name: index_billing_charges_on_billing_payment_intent_id; Type: INDEX; Schema: public; Owner: colinpetruno
--

CREATE INDEX index_billing_charges_on_billing_payment_intent_id ON public.billing_charges USING btree (billing_payment_intent_id);


--
-- Name: index_billing_charges_on_billing_source_id; Type: INDEX; Schema: public; Owner: colinpetruno
--

CREATE INDEX index_billing_charges_on_billing_source_id ON public.billing_charges USING btree (billing_source_id);


--
-- Name: index_billing_details_on_detailable_type_and_detailable_id; Type: INDEX; Schema: public; Owner: colinpetruno
--

CREATE INDEX index_billing_details_on_detailable_type_and_detailable_id ON public.billing_details USING btree (detailable_type, detailable_id);


--
-- Name: index_billing_downgrades_on_billing_subscription_id; Type: INDEX; Schema: public; Owner: colinpetruno
--

CREATE INDEX index_billing_downgrades_on_billing_subscription_id ON public.billing_downgrades USING btree (billing_subscription_id);


--
-- Name: index_billing_downgrades_on_profile_id; Type: INDEX; Schema: public; Owner: colinpetruno
--

CREATE INDEX index_billing_downgrades_on_profile_id ON public.billing_downgrades USING btree (profile_id);


--
-- Name: index_billing_external_ids_on_objectable_type_and_objectable_id; Type: INDEX; Schema: public; Owner: colinpetruno
--

CREATE INDEX index_billing_external_ids_on_objectable_type_and_objectable_id ON public.billing_external_ids USING btree (objectable_type, objectable_id);


--
-- Name: index_billing_invoices_on_invoiceable_type_and_invoiceable_id; Type: INDEX; Schema: public; Owner: colinpetruno
--

CREATE INDEX index_billing_invoices_on_invoiceable_type_and_invoiceable_id ON public.billing_invoices USING btree (invoiceable_type, invoiceable_id);


--
-- Name: index_billing_invoices_on_number; Type: INDEX; Schema: public; Owner: colinpetruno
--

CREATE UNIQUE INDEX index_billing_invoices_on_number ON public.billing_invoices USING btree (number);


--
-- Name: index_billing_payment_intents_on_billable_type_and_billable_id; Type: INDEX; Schema: public; Owner: colinpetruno
--

CREATE INDEX index_billing_payment_intents_on_billable_type_and_billable_id ON public.billing_payment_intents USING btree (billable_type, billable_id);


--
-- Name: index_billing_product_features_on_billing_feature_id; Type: INDEX; Schema: public; Owner: colinpetruno
--

CREATE INDEX index_billing_product_features_on_billing_feature_id ON public.billing_product_features USING btree (billing_feature_id);


--
-- Name: index_billing_product_features_on_billing_product_id; Type: INDEX; Schema: public; Owner: colinpetruno
--

CREATE INDEX index_billing_product_features_on_billing_product_id ON public.billing_product_features USING btree (billing_product_id);


--
-- Name: index_billing_sources_on_sourceable_type_and_sourceable_id; Type: INDEX; Schema: public; Owner: colinpetruno
--

CREATE INDEX index_billing_sources_on_sourceable_type_and_sourceable_id ON public.billing_sources USING btree (sourceable_type, sourceable_id);


--
-- Name: index_billing_subscriptions_on_ownerable_type_and_ownerable_id; Type: INDEX; Schema: public; Owner: colinpetruno
--

CREATE INDEX index_billing_subscriptions_on_ownerable_type_and_ownerable_id ON public.billing_subscriptions USING btree (ownerable_type, ownerable_id);


--
-- Name: index_subscribeable; Type: INDEX; Schema: public; Owner: colinpetruno
--

CREATE INDEX index_subscribeable ON public.billing_subscriptions USING btree (subscribeable_type, subscribeable_id);


--
-- PostgreSQL database dump complete
--


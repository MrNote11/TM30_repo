--
-- PostgreSQL database dump
--

-- Dumped from database version 10.21
-- Dumped by pg_dump version 10.21

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
-- Name: billing; Type: SCHEMA; Schema: -; Owner: payarena
--

CREATE SCHEMA billing;


ALTER SCHEMA billing OWNER TO payarena;

--
-- Name: shipping; Type: SCHEMA; Schema: -; Owner: payarena
--

CREATE SCHEMA shipping;


ALTER SCHEMA shipping OWNER TO payarena;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: base_user; Type: TABLE; Schema: billing; Owner: payarena
--

CREATE TABLE billing.base_user (
    dtype character varying(31) NOT NULL,
    id bigint NOT NULL,
    created timestamp without time zone,
    email character varying(255),
    modified timestamp without time zone,
    name character varying(255),
    password character varying(255),
    status integer,
    uuid character varying(255),
    company_settings_id bigint
);


ALTER TABLE billing.base_user OWNER TO payarena;

--
-- Name: base_user_approved_payment_types; Type: TABLE; Schema: billing; Owner: payarena
--

CREATE TABLE billing.base_user_approved_payment_types (
    company_id bigint NOT NULL,
    approved_payment_types_id bigint NOT NULL
);


ALTER TABLE billing.base_user_approved_payment_types OWNER TO payarena;

--
-- Name: base_user_customers; Type: TABLE; Schema: billing; Owner: payarena
--

CREATE TABLE billing.base_user_customers (
    company_id bigint NOT NULL,
    customers_id bigint NOT NULL
);


ALTER TABLE billing.base_user_customers OWNER TO payarena;

--
-- Name: base_user_phone; Type: TABLE; Schema: billing; Owner: payarena
--

CREATE TABLE billing.base_user_phone (
    base_user_id bigint NOT NULL,
    phone character varying(255)
);


ALTER TABLE billing.base_user_phone OWNER TO payarena;

--
-- Name: base_user_roles; Type: TABLE; Schema: billing; Owner: payarena
--

CREATE TABLE billing.base_user_roles (
    base_user_id bigint NOT NULL,
    roles character varying(255)
);


ALTER TABLE billing.base_user_roles OWNER TO payarena;

--
-- Name: company_address; Type: TABLE; Schema: billing; Owner: payarena
--

CREATE TABLE billing.company_address (
    company_id bigint NOT NULL,
    address character varying(255)
);


ALTER TABLE billing.company_address OWNER TO payarena;

--
-- Name: company_settings; Type: TABLE; Schema: billing; Owner: payarena
--

CREATE TABLE billing.company_settings (
    id bigint NOT NULL
);


ALTER TABLE billing.company_settings OWNER TO payarena;

--
-- Name: company_settings_billing_details; Type: TABLE; Schema: billing; Owner: payarena
--

CREATE TABLE billing.company_settings_billing_details (
    company_settings_id bigint NOT NULL,
    secret_key character varying(255),
    uid character varying(255),
    billing_details_label character varying(255) NOT NULL
);


ALTER TABLE billing.company_settings_billing_details OWNER TO payarena;

--
-- Name: customer; Type: TABLE; Schema: billing; Owner: payarena
--

CREATE TABLE billing.customer (
    id bigint NOT NULL,
    active boolean,
    created character varying(255),
    email character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    modified character varying(255),
    password character varying(255),
    phone_number character varying(255),
    uuid character varying(255),
    company_id bigint,
    payment_types_id bigint
);


ALTER TABLE billing.customer OWNER TO payarena;

--
-- Name: customer_payment_details; Type: TABLE; Schema: billing; Owner: payarena
--

CREATE TABLE billing.customer_payment_details (
    id bigint NOT NULL
);


ALTER TABLE billing.customer_payment_details OWNER TO payarena;

--
-- Name: customer_payment_details_payment_info; Type: TABLE; Schema: billing; Owner: payarena
--

CREATE TABLE billing.customer_payment_details_payment_info (
    customer_payment_details_id bigint NOT NULL,
    secret_key character varying(255),
    uid character varying(255),
    payment_info_key character varying(255) NOT NULL
);


ALTER TABLE billing.customer_payment_details_payment_info OWNER TO payarena;

--
-- Name: hibernate_sequence; Type: SEQUENCE; Schema: billing; Owner: payarena
--

CREATE SEQUENCE billing.hibernate_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE billing.hibernate_sequence OWNER TO payarena;

--
-- Name: payment_provider; Type: TABLE; Schema: billing; Owner: payarena
--

CREATE TABLE billing.payment_provider (
    dtype character varying(31) NOT NULL,
    id bigint NOT NULL,
    base_url character varying(255),
    name character varying(255),
    pid character varying(255)
);


ALTER TABLE billing.payment_provider OWNER TO payarena;

--
-- Name: payment_type; Type: TABLE; Schema: billing; Owner: payarena
--

CREATE TABLE billing.payment_type (
    id bigint NOT NULL,
    name character varying(255),
    provider_id bigint
);


ALTER TABLE billing.payment_type OWNER TO payarena;

--
-- Name: payment_type_adopted_companies; Type: TABLE; Schema: billing; Owner: payarena
--

CREATE TABLE billing.payment_type_adopted_companies (
    payment_type_id bigint NOT NULL,
    adopted_companies_id bigint NOT NULL
);


ALTER TABLE billing.payment_type_adopted_companies OWNER TO payarena;

--
-- Name: provider_payment_type_fk; Type: TABLE; Schema: billing; Owner: payarena
--

CREATE TABLE billing.provider_payment_type_fk (
    payment_provider_id bigint NOT NULL,
    payment_types_id bigint NOT NULL,
    payment_types_key character varying(255) NOT NULL
);


ALTER TABLE billing.provider_payment_type_fk OWNER TO payarena;

--
-- Name: transaction; Type: TABLE; Schema: billing; Owner: payarena
--

CREATE TABLE billing.transaction (
    id bigint NOT NULL,
    account character varying(255),
    amount double precision,
    created character varying(255),
    modified date,
    narration character varying(255),
    payment_type character varying(255),
    reference character varying(255),
    return_url character varying(255),
    status character varying(255),
    status_message character varying(255),
    transaction_id character varying(255),
    customer_id bigint
);


ALTER TABLE billing.transaction OWNER TO payarena;

--
-- Name: wallet; Type: TABLE; Schema: billing; Owner: payarena
--

CREATE TABLE billing.wallet (
    id bigint NOT NULL,
    account_number character varying(255),
    amount double precision,
    status integer
);


ALTER TABLE billing.wallet OWNER TO payarena;

--
-- Name: account_address; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.account_address (
    id bigint NOT NULL,
    type character varying(10) NOT NULL,
    name character varying(500) NOT NULL,
    mobile_number character varying(17) NOT NULL,
    locality character varying(500),
    landmark character varying(500),
    country character varying(100) NOT NULL,
    state character varying(100) NOT NULL,
    city character varying(100) NOT NULL,
    town character varying(100),
    postal_code character varying(50),
    longitude double precision,
    latitude double precision,
    is_primary boolean NOT NULL,
    updated_on timestamp with time zone NOT NULL,
    customer_id bigint NOT NULL,
    town_id character varying(100)
);


ALTER TABLE public.account_address OWNER TO payarena;

--
-- Name: account_address_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.account_address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_address_id_seq OWNER TO payarena;

--
-- Name: account_address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.account_address_id_seq OWNED BY public.account_address.id;


--
-- Name: account_profile; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.account_profile (
    id bigint NOT NULL,
    phone_number character varying(20),
    profile_picture character varying(100),
    created_on timestamp with time zone NOT NULL,
    updated_on timestamp with time zone NOT NULL,
    user_id integer NOT NULL,
    code_expiration_date timestamp with time zone,
    verification_code character varying(100),
    verified boolean NOT NULL,
    pay_auth text,
    has_wallet boolean NOT NULL,
    pay_token text,
    wallet_pin text,
    recent_viewed_products text
);


ALTER TABLE public.account_profile OWNER TO payarena;

--
-- Name: account_profile_following; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.account_profile_following (
    id bigint NOT NULL,
    profile_id bigint NOT NULL,
    store_id bigint NOT NULL
);


ALTER TABLE public.account_profile_following OWNER TO payarena;

--
-- Name: account_profile_following_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.account_profile_following_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_profile_following_id_seq OWNER TO payarena;

--
-- Name: account_profile_following_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.account_profile_following_id_seq OWNED BY public.account_profile_following.id;


--
-- Name: account_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.account_profile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_profile_id_seq OWNER TO payarena;

--
-- Name: account_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.account_profile_id_seq OWNED BY public.account_profile.id;


--
-- Name: account_usercard; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.account_usercard (
    id bigint NOT NULL,
    bank character varying(50),
    card_from character varying(50),
    card_type character varying(50),
    bin character varying(300),
    last4 character varying(50),
    exp_month character varying(2),
    exp_year character varying(4),
    signature character varying(200),
    authorization_code character varying(200),
    payload text,
    "default" boolean,
    profile_id bigint NOT NULL
);


ALTER TABLE public.account_usercard OWNER TO payarena;

--
-- Name: account_usercard_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.account_usercard_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_usercard_id_seq OWNER TO payarena;

--
-- Name: account_usercard_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.account_usercard_id_seq OWNED BY public.account_usercard.id;


--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO payarena;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.auth_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO payarena;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.auth_group_permissions (
    id bigint NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO payarena;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO payarena;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO payarena;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.auth_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO payarena;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO payarena;

--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.auth_user_groups (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO payarena;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_groups_id_seq OWNER TO payarena;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.auth_user_groups_id_seq OWNED BY public.auth_user_groups.id;


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.auth_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_id_seq OWNER TO payarena;

--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.auth_user_id_seq OWNED BY public.auth_user.id;


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.auth_user_user_permissions (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO payarena;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_user_permissions_id_seq OWNER TO payarena;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.auth_user_user_permissions_id_seq OWNED BY public.auth_user_user_permissions.id;


--
-- Name: authtoken_token; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.authtoken_token (
    key character varying(40) NOT NULL,
    created timestamp with time zone NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.authtoken_token OWNER TO payarena;

--
-- Name: base_user; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.base_user (
    status smallint,
    commission_type_id bigint,
    date_modified timestamp(6) without time zone,
    id bigint NOT NULL,
    registration_date timestamp(6) without time zone,
    wallet_id bigint,
    dtype character varying(31) NOT NULL,
    api_key character varying(255),
    email character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    phone character varying(255),
    role character varying(255),
    settlement_type character varying(255),
    user_id character varying(255) NOT NULL,
    CONSTRAINT base_user_role_check CHECK (((role)::text = ANY ((ARRAY['ADMIN'::character varying, 'USER'::character varying, 'CLIENT'::character varying])::text[]))),
    CONSTRAINT base_user_settlement_type_check CHECK (((settlement_type)::text = ANY ((ARRAY['PREPAID'::character varying, 'POSTPAID'::character varying])::text[]))),
    CONSTRAINT base_user_status_check CHECK (((status >= 0) AND (status <= 2)))
);


ALTER TABLE public.base_user OWNER TO payarena;

--
-- Name: base_user_approved_shippers; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.base_user_approved_shippers (
    approved_shippers_id bigint NOT NULL,
    approved_shippers_key bigint NOT NULL,
    client_id bigint NOT NULL
);


ALTER TABLE public.base_user_approved_shippers OWNER TO payarena;

--
-- Name: base_user_roles; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.base_user_roles (
    base_user_id bigint NOT NULL,
    roles character varying(255)
);


ALTER TABLE public.base_user_roles OWNER TO payarena;

--
-- Name: base_user_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.base_user_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.base_user_seq OWNER TO payarena;

--
-- Name: base_user_shipments; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.base_user_shipments (
    client_id bigint NOT NULL,
    shipments_id bigint NOT NULL
);


ALTER TABLE public.base_user_shipments OWNER TO payarena;

--
-- Name: city; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.city (
    id bigint NOT NULL,
    code character varying(255),
    name character varying(255)
);


ALTER TABLE public.city OWNER TO payarena;

--
-- Name: city_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.city_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.city_seq OWNER TO payarena;

--
-- Name: city_towns; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.city_towns (
    city_id bigint NOT NULL,
    name character varying(255),
    town_id character varying(255)
);


ALTER TABLE public.city_towns OWNER TO payarena;

--
-- Name: client_commission; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.client_commission (
    commission double precision,
    client_id bigint,
    id bigint NOT NULL,
    commission_id character varying(255),
    CONSTRAINT client_commission_commission_id_check CHECK (((commission_id)::text = ANY ((ARRAY['FLAT'::character varying, 'PERCENTAGE'::character varying])::text[])))
);


ALTER TABLE public.client_commission OWNER TO payarena;

--
-- Name: client_commission_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.client_commission_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.client_commission_seq OWNER TO payarena;

--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO payarena;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.django_admin_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_admin_log_id_seq OWNER TO payarena;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO payarena;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.django_content_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO payarena;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.django_migrations (
    id bigint NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO payarena;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_migrations_id_seq OWNER TO payarena;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO payarena;

--
-- Name: ecommerce_brand; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.ecommerce_brand (
    id bigint NOT NULL,
    name character varying(200) NOT NULL,
    image character varying(100),
    created_on timestamp with time zone NOT NULL,
    updated_on timestamp with time zone NOT NULL
);


ALTER TABLE public.ecommerce_brand OWNER TO payarena;

--
-- Name: ecommerce_brand_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.ecommerce_brand_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ecommerce_brand_id_seq OWNER TO payarena;

--
-- Name: ecommerce_brand_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.ecommerce_brand_id_seq OWNED BY public.ecommerce_brand.id;


--
-- Name: ecommerce_cart; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.ecommerce_cart (
    id bigint NOT NULL,
    cart_uid character varying(100),
    status character varying(20) NOT NULL,
    created_on timestamp with time zone NOT NULL,
    updated_on timestamp with time zone NOT NULL,
    user_id integer
);


ALTER TABLE public.ecommerce_cart OWNER TO payarena;

--
-- Name: ecommerce_cart_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.ecommerce_cart_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ecommerce_cart_id_seq OWNER TO payarena;

--
-- Name: ecommerce_cart_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.ecommerce_cart_id_seq OWNED BY public.ecommerce_cart.id;


--
-- Name: ecommerce_cartproduct; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.ecommerce_cartproduct (
    id bigint NOT NULL,
    price numeric(20,2) NOT NULL,
    quantity integer NOT NULL,
    discount numeric(20,2) NOT NULL,
    created_on timestamp with time zone NOT NULL,
    updated_on timestamp with time zone NOT NULL,
    cart_id bigint NOT NULL,
    product_detail_id bigint NOT NULL,
    company_id character varying(200),
    delivery_fee numeric(50,2),
    shipper_name character varying(200)
);


ALTER TABLE public.ecommerce_cartproduct OWNER TO payarena;

--
-- Name: ecommerce_cartproduct_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.ecommerce_cartproduct_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ecommerce_cartproduct_id_seq OWNER TO payarena;

--
-- Name: ecommerce_cartproduct_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.ecommerce_cartproduct_id_seq OWNED BY public.ecommerce_cartproduct.id;


--
-- Name: ecommerce_dailydeal; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.ecommerce_dailydeal (
    id bigint NOT NULL,
    created_on timestamp with time zone NOT NULL,
    updated_on timestamp with time zone NOT NULL,
    product_id bigint NOT NULL
);


ALTER TABLE public.ecommerce_dailydeal OWNER TO payarena;

--
-- Name: ecommerce_dailydeal_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.ecommerce_dailydeal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ecommerce_dailydeal_id_seq OWNER TO payarena;

--
-- Name: ecommerce_dailydeal_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.ecommerce_dailydeal_id_seq OWNED BY public.ecommerce_dailydeal.id;


--
-- Name: ecommerce_image; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.ecommerce_image (
    id bigint NOT NULL,
    image character varying(100) NOT NULL,
    created_on timestamp with time zone NOT NULL
);


ALTER TABLE public.ecommerce_image OWNER TO payarena;

--
-- Name: ecommerce_image_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.ecommerce_image_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ecommerce_image_id_seq OWNER TO payarena;

--
-- Name: ecommerce_image_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.ecommerce_image_id_seq OWNED BY public.ecommerce_image.id;


--
-- Name: ecommerce_order; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.ecommerce_order (
    id bigint NOT NULL,
    payment_status character varying(200) NOT NULL,
    created_on timestamp with time zone NOT NULL,
    updates_on timestamp with time zone NOT NULL,
    address_id bigint,
    cart_id bigint,
    customer_id bigint
);


ALTER TABLE public.ecommerce_order OWNER TO payarena;

--
-- Name: ecommerce_order_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.ecommerce_order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ecommerce_order_id_seq OWNER TO payarena;

--
-- Name: ecommerce_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.ecommerce_order_id_seq OWNED BY public.ecommerce_order.id;


--
-- Name: ecommerce_orderentry; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.ecommerce_orderentry (
    id bigint NOT NULL,
    item_total numeric(20,2) NOT NULL,
    management_fee numeric(20,2) NOT NULL,
    delivery_fee numeric(20,2) NOT NULL,
    total numeric(20,2) NOT NULL,
    status character varying(50) NOT NULL,
    notified_for character varying(200),
    order_no character varying(100),
    tracking_id character varying(100),
    shipper_settled boolean,
    shipper_settled_date timestamp with time zone,
    merchant_settled boolean,
    merchant_settled_date timestamp with time zone,
    created_on timestamp with time zone NOT NULL,
    updated_on timestamp with time zone NOT NULL,
    cart_id bigint,
    order_id bigint,
    seller_id bigint NOT NULL
);


ALTER TABLE public.ecommerce_orderentry OWNER TO payarena;

--
-- Name: ecommerce_orderentry_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.ecommerce_orderentry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ecommerce_orderentry_id_seq OWNER TO payarena;

--
-- Name: ecommerce_orderentry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.ecommerce_orderentry_id_seq OWNED BY public.ecommerce_orderentry.id;


--
-- Name: ecommerce_orderproduct; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.ecommerce_orderproduct (
    id bigint NOT NULL,
    price numeric(50,2) NOT NULL,
    quantity integer NOT NULL,
    discount numeric(50,2) NOT NULL,
    total numeric(50,2) NOT NULL,
    status character varying(50) NOT NULL,
    delivery_date date,
    created_on timestamp with time zone NOT NULL,
    updated_on timestamp with time zone NOT NULL,
    cancelled_on timestamp with time zone,
    packed_on timestamp with time zone,
    shipped_on timestamp with time zone,
    delivered_on timestamp with time zone,
    returned_on timestamp with time zone,
    payment_on timestamp with time zone,
    refunded_on timestamp with time zone,
    request_for_return boolean NOT NULL,
    cancelled_by_id integer,
    order_id bigint NOT NULL,
    product_detail_id bigint,
    sub_total numeric(50,2) NOT NULL,
    company_id character varying(200),
    delivery_fee numeric(50,2),
    payment_method character varying(200),
    shipper_name character varying(200),
    tracking_id character varying(200),
    waybill_no character varying(200),
    booked boolean NOT NULL
);


ALTER TABLE public.ecommerce_orderproduct OWNER TO payarena;

--
-- Name: ecommerce_orderproduct_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.ecommerce_orderproduct_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ecommerce_orderproduct_id_seq OWNER TO payarena;

--
-- Name: ecommerce_orderproduct_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.ecommerce_orderproduct_id_seq OWNED BY public.ecommerce_orderproduct.id;


--
-- Name: ecommerce_product; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.ecommerce_product (
    id bigint NOT NULL,
    name character varying(200) NOT NULL,
    tags text,
    status character varying(10) NOT NULL,
    is_featured boolean NOT NULL,
    view_count bigint NOT NULL,
    sale_count integer NOT NULL,
    created_on timestamp with time zone NOT NULL,
    updated_on timestamp with time zone NOT NULL,
    category_id bigint,
    store_id bigint,
    sub_category_id bigint,
    published_on timestamp with time zone,
    image_id bigint,
    product_type_id bigint,
    brand_id bigint,
    description text,
    decline_reason character varying(200),
    approved_by_id integer,
    checked_by_id integer,
    last_viewed_date timestamp with time zone,
    slug character varying(500),
    choice boolean NOT NULL,
    discount_end_time timestamp with time zone,
    free_shipping boolean NOT NULL,
    CONSTRAINT ecommerce_product_view_count_check CHECK ((view_count >= 0))
);


ALTER TABLE public.ecommerce_product OWNER TO payarena;

--
-- Name: ecommerce_product_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.ecommerce_product_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ecommerce_product_id_seq OWNER TO payarena;

--
-- Name: ecommerce_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.ecommerce_product_id_seq OWNED BY public.ecommerce_product.id;


--
-- Name: ecommerce_productcategory; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.ecommerce_productcategory (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    image character varying(100) NOT NULL,
    created_on timestamp with time zone NOT NULL,
    updated_on timestamp with time zone NOT NULL,
    parent_id bigint,
    slug character varying(500)
);


ALTER TABLE public.ecommerce_productcategory OWNER TO payarena;

--
-- Name: ecommerce_productcategory_brands; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.ecommerce_productcategory_brands (
    id bigint NOT NULL,
    productcategory_id bigint NOT NULL,
    brand_id bigint NOT NULL
);


ALTER TABLE public.ecommerce_productcategory_brands OWNER TO payarena;

--
-- Name: ecommerce_productcategory_brands_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.ecommerce_productcategory_brands_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ecommerce_productcategory_brands_id_seq OWNER TO payarena;

--
-- Name: ecommerce_productcategory_brands_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.ecommerce_productcategory_brands_id_seq OWNED BY public.ecommerce_productcategory_brands.id;


--
-- Name: ecommerce_productcategory_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.ecommerce_productcategory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ecommerce_productcategory_id_seq OWNER TO payarena;

--
-- Name: ecommerce_productcategory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.ecommerce_productcategory_id_seq OWNED BY public.ecommerce_productcategory.id;


--
-- Name: ecommerce_productdetail; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.ecommerce_productdetail (
    id bigint NOT NULL,
    sku character varying(100),
    size character varying(100),
    color character varying(100) NOT NULL,
    weight double precision NOT NULL,
    length double precision NOT NULL,
    width double precision NOT NULL,
    height double precision NOT NULL,
    stock integer NOT NULL,
    price numeric(20,2) NOT NULL,
    discount numeric(20,2) NOT NULL,
    low_stock_threshold integer NOT NULL,
    shipping_days integer NOT NULL,
    out_of_stock_date timestamp with time zone,
    created_on timestamp with time zone NOT NULL,
    updated_on timestamp with time zone NOT NULL,
    product_id bigint NOT NULL
);


ALTER TABLE public.ecommerce_productdetail OWNER TO payarena;

--
-- Name: ecommerce_productdetail_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.ecommerce_productdetail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ecommerce_productdetail_id_seq OWNER TO payarena;

--
-- Name: ecommerce_productdetail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.ecommerce_productdetail_id_seq OWNED BY public.ecommerce_productdetail.id;


--
-- Name: ecommerce_productimage; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.ecommerce_productimage (
    id bigint NOT NULL,
    created_on timestamp with time zone NOT NULL,
    updated_on timestamp with time zone NOT NULL,
    product_detail_id bigint NOT NULL,
    image_id bigint
);


ALTER TABLE public.ecommerce_productimage OWNER TO payarena;

--
-- Name: ecommerce_productimage_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.ecommerce_productimage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ecommerce_productimage_id_seq OWNER TO payarena;

--
-- Name: ecommerce_productimage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.ecommerce_productimage_id_seq OWNED BY public.ecommerce_productimage.id;


--
-- Name: ecommerce_productreview; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.ecommerce_productreview (
    id bigint NOT NULL,
    rating integer NOT NULL,
    headline character varying(250) NOT NULL,
    review text NOT NULL,
    created_on timestamp with time zone NOT NULL,
    product_id bigint NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.ecommerce_productreview OWNER TO payarena;

--
-- Name: ecommerce_productreview_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.ecommerce_productreview_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ecommerce_productreview_id_seq OWNER TO payarena;

--
-- Name: ecommerce_productreview_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.ecommerce_productreview_id_seq OWNED BY public.ecommerce_productreview.id;


--
-- Name: ecommerce_producttype; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.ecommerce_producttype (
    id bigint NOT NULL,
    name character varying(200) NOT NULL,
    image character varying(100),
    percentage_commission numeric(50,2),
    fixed_commission numeric(50,2),
    commission_applicable boolean NOT NULL,
    category_id bigint NOT NULL,
    slug character varying(500)
);


ALTER TABLE public.ecommerce_producttype OWNER TO payarena;

--
-- Name: ecommerce_producttype_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.ecommerce_producttype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ecommerce_producttype_id_seq OWNER TO payarena;

--
-- Name: ecommerce_producttype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.ecommerce_producttype_id_seq OWNED BY public.ecommerce_producttype.id;


--
-- Name: ecommerce_productwishlist; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.ecommerce_productwishlist (
    id bigint NOT NULL,
    created_on timestamp with time zone NOT NULL,
    product_id bigint NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.ecommerce_productwishlist OWNER TO payarena;

--
-- Name: ecommerce_productwishlist_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.ecommerce_productwishlist_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ecommerce_productwishlist_id_seq OWNER TO payarena;

--
-- Name: ecommerce_productwishlist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.ecommerce_productwishlist_id_seq OWNED BY public.ecommerce_productwishlist.id;


--
-- Name: ecommerce_promo; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.ecommerce_promo (
    id bigint NOT NULL,
    title character varying(100) NOT NULL,
    amount_discount numeric(50,2),
    discount_type character varying(50) NOT NULL,
    promo_type character varying(50) NOT NULL,
    details text,
    banner_image character varying(100),
    status character varying(50) NOT NULL,
    created_on timestamp with time zone NOT NULL,
    updated_on timestamp with time zone NOT NULL,
    "position" character varying(300),
    fixed_price numeric(50,2),
    percentage_discount numeric(50,2),
    slug character varying(500)
);


ALTER TABLE public.ecommerce_promo OWNER TO payarena;

--
-- Name: ecommerce_promo_category; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.ecommerce_promo_category (
    id bigint NOT NULL,
    promo_id bigint NOT NULL,
    productcategory_id bigint NOT NULL
);


ALTER TABLE public.ecommerce_promo_category OWNER TO payarena;

--
-- Name: ecommerce_promo_category_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.ecommerce_promo_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ecommerce_promo_category_id_seq OWNER TO payarena;

--
-- Name: ecommerce_promo_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.ecommerce_promo_category_id_seq OWNED BY public.ecommerce_promo_category.id;


--
-- Name: ecommerce_promo_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.ecommerce_promo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ecommerce_promo_id_seq OWNER TO payarena;

--
-- Name: ecommerce_promo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.ecommerce_promo_id_seq OWNED BY public.ecommerce_promo.id;


--
-- Name: ecommerce_promo_merchant; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.ecommerce_promo_merchant (
    id bigint NOT NULL,
    promo_id bigint NOT NULL,
    seller_id bigint NOT NULL
);


ALTER TABLE public.ecommerce_promo_merchant OWNER TO payarena;

--
-- Name: ecommerce_promo_merchant_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.ecommerce_promo_merchant_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ecommerce_promo_merchant_id_seq OWNER TO payarena;

--
-- Name: ecommerce_promo_merchant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.ecommerce_promo_merchant_id_seq OWNED BY public.ecommerce_promo_merchant.id;


--
-- Name: ecommerce_promo_product; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.ecommerce_promo_product (
    id bigint NOT NULL,
    promo_id bigint NOT NULL,
    product_id bigint NOT NULL
);


ALTER TABLE public.ecommerce_promo_product OWNER TO payarena;

--
-- Name: ecommerce_promo_product_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.ecommerce_promo_product_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ecommerce_promo_product_id_seq OWNER TO payarena;

--
-- Name: ecommerce_promo_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.ecommerce_promo_product_id_seq OWNED BY public.ecommerce_promo_product.id;


--
-- Name: ecommerce_promo_product_type; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.ecommerce_promo_product_type (
    id bigint NOT NULL,
    promo_id bigint NOT NULL,
    producttype_id bigint NOT NULL
);


ALTER TABLE public.ecommerce_promo_product_type OWNER TO payarena;

--
-- Name: ecommerce_promo_product_type_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.ecommerce_promo_product_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ecommerce_promo_product_type_id_seq OWNER TO payarena;

--
-- Name: ecommerce_promo_product_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.ecommerce_promo_product_type_id_seq OWNED BY public.ecommerce_promo_product_type.id;


--
-- Name: ecommerce_promo_sub_category; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.ecommerce_promo_sub_category (
    id bigint NOT NULL,
    promo_id bigint NOT NULL,
    productcategory_id bigint NOT NULL
);


ALTER TABLE public.ecommerce_promo_sub_category OWNER TO payarena;

--
-- Name: ecommerce_promo_sub_category_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.ecommerce_promo_sub_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ecommerce_promo_sub_category_id_seq OWNER TO payarena;

--
-- Name: ecommerce_promo_sub_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.ecommerce_promo_sub_category_id_seq OWNED BY public.ecommerce_promo_sub_category.id;


--
-- Name: ecommerce_returnedproduct; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.ecommerce_returnedproduct (
    id bigint NOT NULL,
    status character varying(50),
    payment_status character varying(50),
    comment text,
    created_on timestamp with time zone NOT NULL,
    updated_on timestamp with time zone NOT NULL,
    product_id bigint NOT NULL,
    reason_id bigint,
    returned_by_id integer,
    updated_by_id integer
);


ALTER TABLE public.ecommerce_returnedproduct OWNER TO payarena;

--
-- Name: ecommerce_returnedproduct_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.ecommerce_returnedproduct_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ecommerce_returnedproduct_id_seq OWNER TO payarena;

--
-- Name: ecommerce_returnedproduct_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.ecommerce_returnedproduct_id_seq OWNED BY public.ecommerce_returnedproduct.id;


--
-- Name: ecommerce_returnproductimage; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.ecommerce_returnproductimage (
    id bigint NOT NULL,
    is_primary boolean NOT NULL,
    return_product_id bigint NOT NULL,
    image character varying(100)
);


ALTER TABLE public.ecommerce_returnproductimage OWNER TO payarena;

--
-- Name: ecommerce_returnproductimage_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.ecommerce_returnproductimage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ecommerce_returnproductimage_id_seq OWNER TO payarena;

--
-- Name: ecommerce_returnproductimage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.ecommerce_returnproductimage_id_seq OWNED BY public.ecommerce_returnproductimage.id;


--
-- Name: ecommerce_returnreason; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.ecommerce_returnreason (
    id bigint NOT NULL,
    reason character varying(200) NOT NULL
);


ALTER TABLE public.ecommerce_returnreason OWNER TO payarena;

--
-- Name: ecommerce_returnreason_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.ecommerce_returnreason_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ecommerce_returnreason_id_seq OWNER TO payarena;

--
-- Name: ecommerce_returnreason_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.ecommerce_returnreason_id_seq OWNED BY public.ecommerce_returnreason.id;


--
-- Name: ecommerce_shipper; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.ecommerce_shipper (
    id bigint NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(200) NOT NULL,
    slug character varying(20) NOT NULL,
    vat_fee numeric(10,2) NOT NULL,
    is_active boolean NOT NULL,
    created_on timestamp with time zone NOT NULL,
    updated_on timestamp with time zone NOT NULL
);


ALTER TABLE public.ecommerce_shipper OWNER TO payarena;

--
-- Name: ecommerce_shipper_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.ecommerce_shipper_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ecommerce_shipper_id_seq OWNER TO payarena;

--
-- Name: ecommerce_shipper_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.ecommerce_shipper_id_seq OWNED BY public.ecommerce_shipper.id;


--
-- Name: generic_custom_shipper_endpoints; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.generic_custom_shipper_endpoints (
    endpoints_key smallint NOT NULL,
    label smallint,
    generic_custom_shipper_id bigint NOT NULL,
    url text,
    CONSTRAINT generic_custom_shipper_endpoints_endpoints_key_check CHECK (((endpoints_key >= 0) AND (endpoints_key <= 3))),
    CONSTRAINT generic_custom_shipper_endpoints_label_check CHECK (((label >= 0) AND (label <= 3)))
);


ALTER TABLE public.generic_custom_shipper_endpoints OWNER TO payarena;

--
-- Name: merchant_bankaccount; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.merchant_bankaccount (
    id bigint NOT NULL,
    bank_name character varying(100),
    account_name character varying(100),
    account_number character varying(100),
    seller_id bigint,
    bank_code character varying(100)
);


ALTER TABLE public.merchant_bankaccount OWNER TO payarena;

--
-- Name: merchant_bankaccount_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.merchant_bankaccount_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.merchant_bankaccount_id_seq OWNER TO payarena;

--
-- Name: merchant_bankaccount_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.merchant_bankaccount_id_seq OWNED BY public.merchant_bankaccount.id;


--
-- Name: merchant_bulkuploadfile; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.merchant_bulkuploadfile (
    id bigint NOT NULL,
    file character varying(100) NOT NULL,
    used boolean NOT NULL,
    errors text,
    optimized_file character varying(100)
);


ALTER TABLE public.merchant_bulkuploadfile OWNER TO payarena;

--
-- Name: merchant_bulkuploadfile_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.merchant_bulkuploadfile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.merchant_bulkuploadfile_id_seq OWNER TO payarena;

--
-- Name: merchant_bulkuploadfile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.merchant_bulkuploadfile_id_seq OWNED BY public.merchant_bulkuploadfile.id;


--
-- Name: merchant_director; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.merchant_director (
    id bigint NOT NULL,
    name character varying(100),
    phone_number character varying(100),
    address character varying(100)
);


ALTER TABLE public.merchant_director OWNER TO payarena;

--
-- Name: merchant_director_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.merchant_director_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.merchant_director_id_seq OWNER TO payarena;

--
-- Name: merchant_director_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.merchant_director_id_seq OWNED BY public.merchant_director.id;


--
-- Name: merchant_merchantbanner; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.merchant_merchantbanner (
    id bigint NOT NULL,
    banner_image character varying(100) NOT NULL,
    is_active boolean NOT NULL,
    created_on timestamp with time zone NOT NULL,
    updated_on timestamp with time zone NOT NULL,
    seller_id bigint NOT NULL
);


ALTER TABLE public.merchant_merchantbanner OWNER TO payarena;

--
-- Name: merchant_merchantbanner_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.merchant_merchantbanner_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.merchant_merchantbanner_id_seq OWNER TO payarena;

--
-- Name: merchant_merchantbanner_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.merchant_merchantbanner_id_seq OWNED BY public.merchant_merchantbanner.id;


--
-- Name: merchant_seller; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.merchant_seller (
    id bigint NOT NULL,
    phone_number character varying(20),
    address character varying(100),
    profile_picture character varying(100),
    status character varying(20),
    created_on timestamp with time zone NOT NULL,
    updated_on timestamp with time zone NOT NULL,
    user_id integer NOT NULL,
    city character varying(100),
    state character varying(100),
    town character varying(100),
    latitude double precision,
    longitude double precision,
    biller_code character varying(200),
    feel character varying(200),
    fep_type character varying(50) NOT NULL,
    merchant_id character varying(100),
    town_id character varying(100),
    approved_by_id integer,
    checked_by_id integer
);


ALTER TABLE public.merchant_seller OWNER TO payarena;

--
-- Name: merchant_seller_follower; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.merchant_seller_follower (
    id bigint NOT NULL,
    seller_id bigint NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.merchant_seller_follower OWNER TO payarena;

--
-- Name: merchant_seller_follower_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.merchant_seller_follower_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.merchant_seller_follower_id_seq OWNER TO payarena;

--
-- Name: merchant_seller_follower_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.merchant_seller_follower_id_seq OWNED BY public.merchant_seller_follower.id;


--
-- Name: merchant_seller_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.merchant_seller_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.merchant_seller_id_seq OWNER TO payarena;

--
-- Name: merchant_seller_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.merchant_seller_id_seq OWNED BY public.merchant_seller.id;


--
-- Name: merchant_sellerdetail; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.merchant_sellerdetail (
    id bigint NOT NULL,
    company_name character varying(100),
    business_address character varying(100),
    business_state character varying(100),
    business_city character varying(100),
    business_drop_off_address character varying(100),
    business_type character varying(100),
    market_size integer,
    number_of_outlets integer,
    maximum_price_range numeric(10,2),
    id_card character varying(100),
    id_card_verified boolean NOT NULL,
    cac_number character varying(15),
    cac_verified boolean NOT NULL,
    verified boolean NOT NULL,
    created_on date NOT NULL,
    updated_on date NOT NULL,
    seller_id bigint NOT NULL,
    director_id bigint,
    company_type character varying(100),
    company_tin_number character varying(50),
    tin_verified boolean NOT NULL,
    CONSTRAINT merchant_sellerdetail_market_size_check CHECK ((market_size >= 0)),
    CONSTRAINT merchant_sellerdetail_number_of_outlets_check CHECK ((number_of_outlets >= 0))
);


ALTER TABLE public.merchant_sellerdetail OWNER TO payarena;

--
-- Name: merchant_sellerdetail_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.merchant_sellerdetail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.merchant_sellerdetail_id_seq OWNER TO payarena;

--
-- Name: merchant_sellerdetail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.merchant_sellerdetail_id_seq OWNED BY public.merchant_sellerdetail.id;


--
-- Name: merchant_sellerfile; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.merchant_sellerfile (
    id bigint NOT NULL,
    file character varying(100) NOT NULL,
    created_on timestamp with time zone NOT NULL,
    updated_on timestamp with time zone NOT NULL,
    seller_id bigint NOT NULL
);


ALTER TABLE public.merchant_sellerfile OWNER TO payarena;

--
-- Name: merchant_sellerfile_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.merchant_sellerfile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.merchant_sellerfile_id_seq OWNER TO payarena;

--
-- Name: merchant_sellerfile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.merchant_sellerfile_id_seq OWNED BY public.merchant_sellerfile.id;


--
-- Name: order_detail; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.order_detail (
    instant_delivery integer,
    order_id bigint NOT NULL,
    shipment_id bigint,
    description text,
    customer_code character varying(255),
    delivery_address character varying(255),
    delivery_locality character varying(255),
    delivery_requested_time character varying(255),
    delivery_station_id character varying(255),
    destination_state character varying(255),
    order_no character varying(255),
    payment_mode character varying(255),
    pickup_address character varying(255),
    pickup_locality character varying(255),
    pickup_requested_date character varying(255),
    pickup_requested_time character varying(255),
    pickup_state character varying(255),
    pickup_station_id character varying(255),
    pickup_type character varying(255),
    receiver_name character varying(255),
    receiver_phone character varying(255),
    receiver_town_id character varying(255),
    recipient_email character varying(255),
    sender_email character varying(255),
    sender_name character varying(255),
    sender_phone character varying(255),
    sender_town_id character varying(255),
    service_id character varying(255),
    system_reference character varying(255),
    vehicle_id character varying(255),
    weight character varying(255)
);


ALTER TABLE public.order_detail OWNER TO payarena;

--
-- Name: order_detail_items; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.order_detail_items (
    order_detail_order_id bigint NOT NULL,
    amount character varying(255),
    color character varying(255),
    delivery_city character varying(255),
    delivery_contact_name character varying(255),
    delivery_contact_number character varying(255),
    delivery_google_place_address character varying(255),
    delivery_landmark character varying(255),
    delivery_state character varying(255),
    description character varying(255),
    id character varying(255),
    item_type character varying(255),
    name character varying(255),
    pick_up_contact_name character varying(255),
    pick_up_contact_number character varying(255),
    pick_up_google_place_address character varying(255),
    pick_up_landmark character varying(255),
    pick_up_latitude character varying(255),
    pick_up_longitude character varying(255),
    pickup_city character varying(255),
    pickup_state character varying(255),
    quantity character varying(255),
    shipment_type character varying(255),
    size character varying(255),
    weight character varying(255),
    weight_range character varying(255)
);


ALTER TABLE public.order_detail_items OWNER TO payarena;

--
-- Name: order_detail_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.order_detail_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.order_detail_seq OWNER TO payarena;

--
-- Name: shipment; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.shipment (
    cost double precision NOT NULL,
    client_id bigint,
    created_date timestamp(6) without time zone,
    id bigint NOT NULL,
    shipper_id bigint,
    message text,
    tracking_no character varying,
    shipper_assigned_reference character varying(255),
    shipper_assigned_tracking_no character varying(255),
    status character varying(255),
    CONSTRAINT shipment_status_check CHECK (((status)::text = ANY ((ARRAY['SUCCESSFUL'::character varying, 'FAILED'::character varying])::text[])))
);


ALTER TABLE public.shipment OWNER TO payarena;

--
-- Name: shipment_order_details; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.shipment_order_details (
    order_details_order_id bigint NOT NULL,
    shipment_id bigint NOT NULL
);


ALTER TABLE public.shipment_order_details OWNER TO payarena;

--
-- Name: shipment_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.shipment_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shipment_seq OWNER TO payarena;

--
-- Name: shipper; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.shipper (
    type smallint,
    id bigint NOT NULL,
    dtype character varying(31) NOT NULL,
    password text,
    api_key character varying(255),
    auth_type character varying(255),
    biller_code character varying(255),
    email character varying(255),
    factory_id character varying(255),
    name character varying(255),
    shipper_id character varying(255) NOT NULL,
    status character varying(255),
    CONSTRAINT shipper_auth_type_check CHECK (((auth_type)::text = ANY ((ARRAY['BEARER_TOKEN'::character varying, 'API_KEY'::character varying])::text[]))),
    CONSTRAINT shipper_status_check CHECK (((status)::text = ANY ((ARRAY['ACTIVE'::character varying, 'INACTIVE'::character varying, 'INOPERATIVE'::character varying])::text[]))),
    CONSTRAINT shipper_type_check CHECK (((type >= 0) AND (type <= 2)))
);


ALTER TABLE public.shipper OWNER TO payarena;

--
-- Name: shipper_apis; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.shipper_apis (
    shipper_id bigint NOT NULL,
    endpoint text,
    label text,
    method character varying(255),
    request_body text,
    require_params boolean NOT NULL,
    api_labels character varying(255) NOT NULL
);


ALTER TABLE public.shipper_apis OWNER TO payarena;

--
-- Name: shipper_clients; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.shipper_clients (
    approved_shippers_id bigint NOT NULL,
    clients_id bigint NOT NULL
);


ALTER TABLE public.shipper_clients OWNER TO payarena;

--
-- Name: shipper_modes_of_transportation; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.shipper_modes_of_transportation (
    shipper_id bigint NOT NULL,
    modes_of_transportation character varying(255)
);


ALTER TABLE public.shipper_modes_of_transportation OWNER TO payarena;

--
-- Name: shipper_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.shipper_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shipper_seq OWNER TO payarena;

--
-- Name: state; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.state (
    id bigint NOT NULL,
    state_id bigint,
    state_name character varying(255)
);


ALTER TABLE public.state OWNER TO payarena;

--
-- Name: state_cities; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.state_cities (
    cities_id bigint NOT NULL,
    state_id bigint NOT NULL
);


ALTER TABLE public.state_cities OWNER TO payarena;

--
-- Name: state_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.state_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.state_seq OWNER TO payarena;

--
-- Name: state_stations; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.state_stations (
    state_id bigint NOT NULL,
    code character varying(255),
    id character varying(255),
    name character varying(255),
    state character varying(255)
);


ALTER TABLE public.state_stations OWNER TO payarena;

--
-- Name: store_store; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.store_store (
    id bigint NOT NULL,
    name character varying(100),
    logo character varying(100) NOT NULL,
    description text NOT NULL,
    is_active boolean NOT NULL,
    created_on timestamp with time zone NOT NULL,
    updated_on timestamp with time zone NOT NULL,
    seller_id bigint NOT NULL,
    on_sale boolean NOT NULL,
    slug character varying(500)
);


ALTER TABLE public.store_store OWNER TO payarena;

--
-- Name: store_store_categories; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.store_store_categories (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    productcategory_id bigint NOT NULL
);


ALTER TABLE public.store_store_categories OWNER TO payarena;

--
-- Name: store_store_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.store_store_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.store_store_categories_id_seq OWNER TO payarena;

--
-- Name: store_store_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.store_store_categories_id_seq OWNED BY public.store_store_categories.id;


--
-- Name: store_store_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.store_store_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.store_store_id_seq OWNER TO payarena;

--
-- Name: store_store_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.store_store_id_seq OWNED BY public.store_store.id;


--
-- Name: superadmin_adminuser; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.superadmin_adminuser (
    id bigint NOT NULL,
    created_on timestamp with time zone NOT NULL,
    update_on timestamp with time zone NOT NULL,
    role_id bigint,
    user_id integer NOT NULL
);


ALTER TABLE public.superadmin_adminuser OWNER TO payarena;

--
-- Name: superadmin_adminuser_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.superadmin_adminuser_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.superadmin_adminuser_id_seq OWNER TO payarena;

--
-- Name: superadmin_adminuser_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.superadmin_adminuser_id_seq OWNED BY public.superadmin_adminuser.id;


--
-- Name: superadmin_role; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.superadmin_role (
    id bigint NOT NULL,
    created_on timestamp with time zone NOT NULL,
    updated_on timestamp with time zone NOT NULL,
    admin_type character varying(100) NOT NULL
);


ALTER TABLE public.superadmin_role OWNER TO payarena;

--
-- Name: superadmin_role_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.superadmin_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.superadmin_role_id_seq OWNER TO payarena;

--
-- Name: superadmin_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.superadmin_role_id_seq OWNED BY public.superadmin_role.id;


--
-- Name: transaction_merchanttransaction; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.transaction_merchanttransaction (
    id bigint NOT NULL,
    shipper character varying(200) NOT NULL,
    amount numeric(10,2) NOT NULL,
    delivery_fee numeric(10,2) NOT NULL,
    total numeric(10,2) NOT NULL,
    created_on timestamp with time zone NOT NULL,
    updated_on timestamp with time zone NOT NULL,
    merchant_id bigint,
    order_id bigint,
    transaction_id bigint
);


ALTER TABLE public.transaction_merchanttransaction OWNER TO payarena;

--
-- Name: transaction_merchanttransaction_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.transaction_merchanttransaction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transaction_merchanttransaction_id_seq OWNER TO payarena;

--
-- Name: transaction_merchanttransaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.transaction_merchanttransaction_id_seq OWNED BY public.transaction_merchanttransaction.id;


--
-- Name: transaction_transaction; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.transaction_transaction (
    id bigint NOT NULL,
    payment_method character varying(100) NOT NULL,
    amount numeric(10,2) NOT NULL,
    status character varying(100) NOT NULL,
    transaction_reference character varying(200),
    transaction_detail text,
    order_id bigint NOT NULL,
    created_on timestamp with time zone NOT NULL,
    updated_on timestamp with time zone NOT NULL,
    source character varying(100)
);


ALTER TABLE public.transaction_transaction OWNER TO payarena;

--
-- Name: transaction_transaction_id_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.transaction_transaction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transaction_transaction_id_seq OWNER TO payarena;

--
-- Name: transaction_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: payarena
--

ALTER SEQUENCE public.transaction_transaction_id_seq OWNED BY public.transaction_transaction.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.users (
    dtype character varying(31) NOT NULL,
    id bigint NOT NULL,
    date_modified timestamp without time zone,
    email character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    phone character varying(255) NOT NULL,
    registration_date timestamp without time zone,
    status integer,
    user_id character varying(255) NOT NULL,
    settlement_type character varying(255),
    wallet_id bigint
);


ALTER TABLE public.users OWNER TO payarena;

--
-- Name: wallet; Type: TABLE; Schema: public; Owner: payarena
--

CREATE TABLE public.wallet (
    balance double precision NOT NULL,
    settlement_balance double precision NOT NULL,
    client_id bigint,
    id bigint NOT NULL
);


ALTER TABLE public.wallet OWNER TO payarena;

--
-- Name: wallet_seq; Type: SEQUENCE; Schema: public; Owner: payarena
--

CREATE SEQUENCE public.wallet_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wallet_seq OWNER TO payarena;

--
-- Name: base_user; Type: TABLE; Schema: shipping; Owner: payarena
--

CREATE TABLE shipping.base_user (
    dtype character varying(31) NOT NULL,
    id bigint NOT NULL,
    date_modified timestamp(6) without time zone,
    email character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    phone character varying(255),
    registration_date timestamp(6) without time zone,
    role character varying(255),
    status smallint,
    user_id character varying(255) NOT NULL,
    api_key character varying(255),
    settlement_type character varying(255),
    commission_type_id bigint,
    wallet_id bigint,
    CONSTRAINT base_user_role_check CHECK (((role)::text = ANY ((ARRAY['ADMIN'::character varying, 'USER'::character varying, 'CLIENT'::character varying])::text[]))),
    CONSTRAINT base_user_settlement_type_check CHECK (((settlement_type)::text = ANY ((ARRAY['PREPAID'::character varying, 'POSTPAID'::character varying])::text[]))),
    CONSTRAINT base_user_status_check CHECK (((status >= 0) AND (status <= 2)))
);


ALTER TABLE shipping.base_user OWNER TO payarena;

--
-- Name: base_user_approved_shippers; Type: TABLE; Schema: shipping; Owner: payarena
--

CREATE TABLE shipping.base_user_approved_shippers (
    client_id bigint NOT NULL,
    approved_shippers_id bigint NOT NULL,
    approved_shippers_key bigint NOT NULL
);


ALTER TABLE shipping.base_user_approved_shippers OWNER TO payarena;

--
-- Name: base_user_roles; Type: TABLE; Schema: shipping; Owner: payarena
--

CREATE TABLE shipping.base_user_roles (
    base_user_id bigint NOT NULL,
    roles character varying(255)
);


ALTER TABLE shipping.base_user_roles OWNER TO payarena;

--
-- Name: base_user_seq; Type: SEQUENCE; Schema: shipping; Owner: payarena
--

CREATE SEQUENCE shipping.base_user_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shipping.base_user_seq OWNER TO payarena;

--
-- Name: base_user_shipments; Type: TABLE; Schema: shipping; Owner: payarena
--

CREATE TABLE shipping.base_user_shipments (
    client_id bigint NOT NULL,
    shipments_id bigint NOT NULL
);


ALTER TABLE shipping.base_user_shipments OWNER TO payarena;

--
-- Name: city; Type: TABLE; Schema: shipping; Owner: payarena
--

CREATE TABLE shipping.city (
    id bigint NOT NULL,
    code character varying(255),
    name character varying(255),
    state_id bigint
);


ALTER TABLE shipping.city OWNER TO payarena;

--
-- Name: city_seq; Type: SEQUENCE; Schema: shipping; Owner: payarena
--

CREATE SEQUENCE shipping.city_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shipping.city_seq OWNER TO payarena;

--
-- Name: city_towns; Type: TABLE; Schema: shipping; Owner: payarena
--

CREATE TABLE shipping.city_towns (
    city_id bigint NOT NULL,
    name character varying(255),
    town_id character varying(255)
);


ALTER TABLE shipping.city_towns OWNER TO payarena;

--
-- Name: client_commission; Type: TABLE; Schema: shipping; Owner: payarena
--

CREATE TABLE shipping.client_commission (
    id bigint NOT NULL,
    commission double precision,
    commission_id character varying(255),
    client_id bigint
);


ALTER TABLE shipping.client_commission OWNER TO payarena;

--
-- Name: client_commission_seq; Type: SEQUENCE; Schema: shipping; Owner: payarena
--

CREATE SEQUENCE shipping.client_commission_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shipping.client_commission_seq OWNER TO payarena;

--
-- Name: generic_custom_shipper_endpoints; Type: TABLE; Schema: shipping; Owner: payarena
--

CREATE TABLE shipping.generic_custom_shipper_endpoints (
    generic_custom_shipper_id bigint NOT NULL,
    label smallint,
    url text,
    endpoints_key smallint NOT NULL,
    CONSTRAINT generic_custom_shipper_endpoints_endpoints_key_check CHECK (((endpoints_key >= 0) AND (endpoints_key <= 3))),
    CONSTRAINT generic_custom_shipper_endpoints_label_check CHECK (((label >= 0) AND (label <= 3)))
);


ALTER TABLE shipping.generic_custom_shipper_endpoints OWNER TO payarena;

--
-- Name: hibernate_sequence; Type: SEQUENCE; Schema: shipping; Owner: payarena
--

CREATE SEQUENCE shipping.hibernate_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shipping.hibernate_sequence OWNER TO payarena;

--
-- Name: order_detail; Type: TABLE; Schema: shipping; Owner: payarena
--

CREATE TABLE shipping.order_detail (
    id bigint NOT NULL,
    description text,
    order_id bigint,
    order_no character varying(255),
    order_ref character varying(255),
    shipment_id bigint NOT NULL,
    customer_code character varying(255),
    delivery_address character varying(255),
    delivery_locality character varying(255),
    delivery_requested_time character varying(255),
    delivery_station_id character varying(255),
    destination_state character varying(255),
    instant_delivery integer,
    payment_mode character varying(255),
    pickup_address character varying(255),
    pickup_locality character varying(255),
    pickup_requested_date character varying(255),
    pickup_requested_time character varying(255),
    pickup_state character varying(255),
    pickup_station_id character varying(255),
    pickup_type character varying(255),
    receiver_name character varying(255),
    receiver_phone character varying(255),
    receiver_town_id character varying(255),
    recipient_email character varying(255),
    sender_email character varying(255),
    sender_name character varying(255),
    sender_phone character varying(255),
    sender_town_id character varying(255),
    service_id character varying(255),
    system_reference character varying(255),
    vehicle_id character varying(255),
    weight character varying(255)
);


ALTER TABLE shipping.order_detail OWNER TO payarena;

--
-- Name: order_detail_items; Type: TABLE; Schema: shipping; Owner: payarena
--

CREATE TABLE shipping.order_detail_items (
    order_detail_order_id bigint NOT NULL,
    amount character varying(255),
    color character varying(255),
    delivery_city character varying(255),
    delivery_contact_name character varying(255),
    delivery_contact_number character varying(255),
    delivery_google_place_address character varying(255),
    delivery_landmark character varying(255),
    delivery_state character varying(255),
    description character varying(255),
    id character varying(255),
    item_type character varying(255),
    name character varying(255),
    pick_up_contact_name character varying(255),
    pick_up_contact_number character varying(255),
    pick_up_google_place_address character varying(255),
    pick_up_landmark character varying(255),
    pick_up_latitude character varying(255),
    pick_up_longitude character varying(255),
    pickup_city character varying(255),
    pickup_state character varying(255),
    quantity character varying(255),
    shipment_type character varying(255),
    size character varying(255),
    weight character varying(255),
    weight_range character varying(255)
);


ALTER TABLE shipping.order_detail_items OWNER TO payarena;

--
-- Name: order_detail_seq; Type: SEQUENCE; Schema: shipping; Owner: payarena
--

CREATE SEQUENCE shipping.order_detail_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shipping.order_detail_seq OWNER TO payarena;

--
-- Name: shipment; Type: TABLE; Schema: shipping; Owner: payarena
--

CREATE TABLE shipping.shipment (
    id bigint NOT NULL,
    cost character varying(255),
    created_date timestamp without time zone,
    message text,
    shipment_status character varying(255),
    tracking_no character varying,
    client_id bigint,
    order_detail_id bigint,
    shipper_shipment bigint,
    shipper_assigned_reference character varying(255),
    shipper_assigned_tracking_no character varying(255),
    status character varying(255),
    shipper_id bigint,
    CONSTRAINT shipment_status_check CHECK (((status)::text = ANY ((ARRAY['SUCCESSFUL'::character varying, 'FAILED'::character varying])::text[])))
);


ALTER TABLE shipping.shipment OWNER TO payarena;

--
-- Name: shipment_order_details; Type: TABLE; Schema: shipping; Owner: payarena
--

CREATE TABLE shipping.shipment_order_details (
    shipment_id bigint NOT NULL,
    order_details_order_id bigint NOT NULL
);


ALTER TABLE shipping.shipment_order_details OWNER TO payarena;

--
-- Name: shipment_seq; Type: SEQUENCE; Schema: shipping; Owner: payarena
--

CREATE SEQUENCE shipping.shipment_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shipping.shipment_seq OWNER TO payarena;

--
-- Name: shipper; Type: TABLE; Schema: shipping; Owner: payarena
--

CREATE TABLE shipping.shipper (
    dtype character varying(31) NOT NULL,
    id bigint NOT NULL,
    access_token text,
    api_type boolean,
    base_url character varying(255),
    biller_code character varying(255),
    customer_code character varying,
    customer_id bigint,
    email character varying(255),
    name character varying(255),
    password text,
    phone character varying(255),
    shipper_id character varying(255) NOT NULL,
    status character varying(255),
    token_auth_payload_type character varying(255),
    token_constant boolean,
    username character varying(255),
    factory_id character varying(255),
    type smallint,
    api_key character varying(255),
    auth_type character varying(255),
    CONSTRAINT shipper_auth_type_check CHECK (((auth_type)::text = ANY ((ARRAY['BEARER_TOKEN'::character varying, 'API_KEY'::character varying])::text[]))),
    CONSTRAINT shipper_type_check CHECK (((type >= 0) AND (type <= 2)))
);


ALTER TABLE shipping.shipper OWNER TO payarena;

--
-- Name: shipper_apis; Type: TABLE; Schema: shipping; Owner: payarena
--

CREATE TABLE shipping.shipper_apis (
    shipper_id bigint NOT NULL,
    endpoint text,
    label text,
    method character varying(255),
    request_body text,
    require_params boolean NOT NULL,
    api_labels character varying(255) NOT NULL
);


ALTER TABLE shipping.shipper_apis OWNER TO payarena;

--
-- Name: shipper_clients; Type: TABLE; Schema: shipping; Owner: payarena
--

CREATE TABLE shipping.shipper_clients (
    approved_shippers_id bigint NOT NULL,
    clients_id bigint NOT NULL
);


ALTER TABLE shipping.shipper_clients OWNER TO payarena;

--
-- Name: shipper_modes_of_transportation; Type: TABLE; Schema: shipping; Owner: payarena
--

CREATE TABLE shipping.shipper_modes_of_transportation (
    shipper_id bigint NOT NULL,
    modes_of_transportation character varying(255)
);


ALTER TABLE shipping.shipper_modes_of_transportation OWNER TO payarena;

--
-- Name: shipper_seq; Type: SEQUENCE; Schema: shipping; Owner: payarena
--

CREATE SEQUENCE shipping.shipper_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shipping.shipper_seq OWNER TO payarena;

--
-- Name: state; Type: TABLE; Schema: shipping; Owner: payarena
--

CREATE TABLE shipping.state (
    id bigint NOT NULL,
    state_id bigint,
    state_name character varying(255)
);


ALTER TABLE shipping.state OWNER TO payarena;

--
-- Name: state_cities; Type: TABLE; Schema: shipping; Owner: payarena
--

CREATE TABLE shipping.state_cities (
    state_id bigint NOT NULL,
    cities_id bigint NOT NULL
);


ALTER TABLE shipping.state_cities OWNER TO payarena;

--
-- Name: state_seq; Type: SEQUENCE; Schema: shipping; Owner: payarena
--

CREATE SEQUENCE shipping.state_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shipping.state_seq OWNER TO payarena;

--
-- Name: state_stations; Type: TABLE; Schema: shipping; Owner: payarena
--

CREATE TABLE shipping.state_stations (
    state_id bigint NOT NULL,
    code character varying(255),
    id character varying(255),
    name character varying(255),
    state character varying(255)
);


ALTER TABLE shipping.state_stations OWNER TO payarena;

--
-- Name: users; Type: TABLE; Schema: shipping; Owner: payarena
--

CREATE TABLE shipping.users (
    dtype character varying(31) NOT NULL,
    id bigint NOT NULL,
    date_modified timestamp without time zone,
    email character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    phone character varying(255) NOT NULL,
    registration_date timestamp without time zone,
    status integer,
    user_id character varying(255) NOT NULL,
    settlement_type character varying(255),
    wallet_id bigint
);


ALTER TABLE shipping.users OWNER TO payarena;

--
-- Name: wallet; Type: TABLE; Schema: shipping; Owner: payarena
--

CREATE TABLE shipping.wallet (
    id bigint NOT NULL,
    balance double precision NOT NULL,
    client_id bigint
);


ALTER TABLE shipping.wallet OWNER TO payarena;

--
-- Name: wallet_seq; Type: SEQUENCE; Schema: shipping; Owner: payarena
--

CREATE SEQUENCE shipping.wallet_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shipping.wallet_seq OWNER TO payarena;

--
-- Name: account_address id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.account_address ALTER COLUMN id SET DEFAULT nextval('public.account_address_id_seq'::regclass);


--
-- Name: account_profile id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.account_profile ALTER COLUMN id SET DEFAULT nextval('public.account_profile_id_seq'::regclass);


--
-- Name: account_profile_following id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.account_profile_following ALTER COLUMN id SET DEFAULT nextval('public.account_profile_following_id_seq'::regclass);


--
-- Name: account_usercard id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.account_usercard ALTER COLUMN id SET DEFAULT nextval('public.account_usercard_id_seq'::regclass);


--
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- Name: auth_user id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.auth_user ALTER COLUMN id SET DEFAULT nextval('public.auth_user_id_seq'::regclass);


--
-- Name: auth_user_groups id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.auth_user_groups ALTER COLUMN id SET DEFAULT nextval('public.auth_user_groups_id_seq'::regclass);


--
-- Name: auth_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_user_user_permissions_id_seq'::regclass);


--
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- Name: ecommerce_brand id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_brand ALTER COLUMN id SET DEFAULT nextval('public.ecommerce_brand_id_seq'::regclass);


--
-- Name: ecommerce_cart id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_cart ALTER COLUMN id SET DEFAULT nextval('public.ecommerce_cart_id_seq'::regclass);


--
-- Name: ecommerce_cartproduct id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_cartproduct ALTER COLUMN id SET DEFAULT nextval('public.ecommerce_cartproduct_id_seq'::regclass);


--
-- Name: ecommerce_dailydeal id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_dailydeal ALTER COLUMN id SET DEFAULT nextval('public.ecommerce_dailydeal_id_seq'::regclass);


--
-- Name: ecommerce_image id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_image ALTER COLUMN id SET DEFAULT nextval('public.ecommerce_image_id_seq'::regclass);


--
-- Name: ecommerce_order id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_order ALTER COLUMN id SET DEFAULT nextval('public.ecommerce_order_id_seq'::regclass);


--
-- Name: ecommerce_orderentry id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_orderentry ALTER COLUMN id SET DEFAULT nextval('public.ecommerce_orderentry_id_seq'::regclass);


--
-- Name: ecommerce_orderproduct id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_orderproduct ALTER COLUMN id SET DEFAULT nextval('public.ecommerce_orderproduct_id_seq'::regclass);


--
-- Name: ecommerce_product id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_product ALTER COLUMN id SET DEFAULT nextval('public.ecommerce_product_id_seq'::regclass);


--
-- Name: ecommerce_productcategory id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_productcategory ALTER COLUMN id SET DEFAULT nextval('public.ecommerce_productcategory_id_seq'::regclass);


--
-- Name: ecommerce_productcategory_brands id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_productcategory_brands ALTER COLUMN id SET DEFAULT nextval('public.ecommerce_productcategory_brands_id_seq'::regclass);


--
-- Name: ecommerce_productdetail id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_productdetail ALTER COLUMN id SET DEFAULT nextval('public.ecommerce_productdetail_id_seq'::regclass);


--
-- Name: ecommerce_productimage id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_productimage ALTER COLUMN id SET DEFAULT nextval('public.ecommerce_productimage_id_seq'::regclass);


--
-- Name: ecommerce_productreview id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_productreview ALTER COLUMN id SET DEFAULT nextval('public.ecommerce_productreview_id_seq'::regclass);


--
-- Name: ecommerce_producttype id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_producttype ALTER COLUMN id SET DEFAULT nextval('public.ecommerce_producttype_id_seq'::regclass);


--
-- Name: ecommerce_productwishlist id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_productwishlist ALTER COLUMN id SET DEFAULT nextval('public.ecommerce_productwishlist_id_seq'::regclass);


--
-- Name: ecommerce_promo id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_promo ALTER COLUMN id SET DEFAULT nextval('public.ecommerce_promo_id_seq'::regclass);


--
-- Name: ecommerce_promo_category id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_promo_category ALTER COLUMN id SET DEFAULT nextval('public.ecommerce_promo_category_id_seq'::regclass);


--
-- Name: ecommerce_promo_merchant id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_promo_merchant ALTER COLUMN id SET DEFAULT nextval('public.ecommerce_promo_merchant_id_seq'::regclass);


--
-- Name: ecommerce_promo_product id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_promo_product ALTER COLUMN id SET DEFAULT nextval('public.ecommerce_promo_product_id_seq'::regclass);


--
-- Name: ecommerce_promo_product_type id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_promo_product_type ALTER COLUMN id SET DEFAULT nextval('public.ecommerce_promo_product_type_id_seq'::regclass);


--
-- Name: ecommerce_promo_sub_category id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_promo_sub_category ALTER COLUMN id SET DEFAULT nextval('public.ecommerce_promo_sub_category_id_seq'::regclass);


--
-- Name: ecommerce_returnedproduct id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_returnedproduct ALTER COLUMN id SET DEFAULT nextval('public.ecommerce_returnedproduct_id_seq'::regclass);


--
-- Name: ecommerce_returnproductimage id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_returnproductimage ALTER COLUMN id SET DEFAULT nextval('public.ecommerce_returnproductimage_id_seq'::regclass);


--
-- Name: ecommerce_returnreason id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_returnreason ALTER COLUMN id SET DEFAULT nextval('public.ecommerce_returnreason_id_seq'::regclass);


--
-- Name: ecommerce_shipper id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_shipper ALTER COLUMN id SET DEFAULT nextval('public.ecommerce_shipper_id_seq'::regclass);


--
-- Name: merchant_bankaccount id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.merchant_bankaccount ALTER COLUMN id SET DEFAULT nextval('public.merchant_bankaccount_id_seq'::regclass);


--
-- Name: merchant_bulkuploadfile id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.merchant_bulkuploadfile ALTER COLUMN id SET DEFAULT nextval('public.merchant_bulkuploadfile_id_seq'::regclass);


--
-- Name: merchant_director id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.merchant_director ALTER COLUMN id SET DEFAULT nextval('public.merchant_director_id_seq'::regclass);


--
-- Name: merchant_merchantbanner id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.merchant_merchantbanner ALTER COLUMN id SET DEFAULT nextval('public.merchant_merchantbanner_id_seq'::regclass);


--
-- Name: merchant_seller id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.merchant_seller ALTER COLUMN id SET DEFAULT nextval('public.merchant_seller_id_seq'::regclass);


--
-- Name: merchant_seller_follower id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.merchant_seller_follower ALTER COLUMN id SET DEFAULT nextval('public.merchant_seller_follower_id_seq'::regclass);


--
-- Name: merchant_sellerdetail id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.merchant_sellerdetail ALTER COLUMN id SET DEFAULT nextval('public.merchant_sellerdetail_id_seq'::regclass);


--
-- Name: merchant_sellerfile id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.merchant_sellerfile ALTER COLUMN id SET DEFAULT nextval('public.merchant_sellerfile_id_seq'::regclass);


--
-- Name: store_store id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.store_store ALTER COLUMN id SET DEFAULT nextval('public.store_store_id_seq'::regclass);


--
-- Name: store_store_categories id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.store_store_categories ALTER COLUMN id SET DEFAULT nextval('public.store_store_categories_id_seq'::regclass);


--
-- Name: superadmin_adminuser id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.superadmin_adminuser ALTER COLUMN id SET DEFAULT nextval('public.superadmin_adminuser_id_seq'::regclass);


--
-- Name: superadmin_role id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.superadmin_role ALTER COLUMN id SET DEFAULT nextval('public.superadmin_role_id_seq'::regclass);


--
-- Name: transaction_merchanttransaction id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.transaction_merchanttransaction ALTER COLUMN id SET DEFAULT nextval('public.transaction_merchanttransaction_id_seq'::regclass);


--
-- Name: transaction_transaction id; Type: DEFAULT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.transaction_transaction ALTER COLUMN id SET DEFAULT nextval('public.transaction_transaction_id_seq'::regclass);


--
-- Data for Name: base_user; Type: TABLE DATA; Schema: billing; Owner: payarena
--

COPY billing.base_user (dtype, id, created, email, modified, name, password, status, uuid, company_settings_id) FROM stdin;
Company	8	\N	client@payarena.com	\N	PayArena Mall	$2a$10$DEYkZds4pTaTEFNt1FyjCOZSjcG0zNWUnE6W79.Kuu/YKbZMmbxBO	0	7c872215-ff71-4805-9b3d-3bf91a93f0b8	9
\.


--
-- Data for Name: base_user_approved_payment_types; Type: TABLE DATA; Schema: billing; Owner: payarena
--

COPY billing.base_user_approved_payment_types (company_id, approved_payment_types_id) FROM stdin;
8	7
8	6
8	5
\.


--
-- Data for Name: base_user_customers; Type: TABLE DATA; Schema: billing; Owner: payarena
--

COPY billing.base_user_customers (company_id, customers_id) FROM stdin;
8	11
8	15
8	22
8	30
8	37
8	40
\.


--
-- Data for Name: base_user_phone; Type: TABLE DATA; Schema: billing; Owner: payarena
--

COPY billing.base_user_phone (base_user_id, phone) FROM stdin;
8	07023456711
8	08120456789
\.


--
-- Data for Name: base_user_roles; Type: TABLE DATA; Schema: billing; Owner: payarena
--

COPY billing.base_user_roles (base_user_id, roles) FROM stdin;
8	USER
\.


--
-- Data for Name: company_address; Type: TABLE DATA; Schema: billing; Owner: payarena
--

COPY billing.company_address (company_id, address) FROM stdin;
8	29A Berkeley Street, off King George Rd, Onikan, Lagos Island
\.


--
-- Data for Name: company_settings; Type: TABLE DATA; Schema: billing; Owner: payarena
--

COPY billing.company_settings (id) FROM stdin;
9
\.


--
-- Data for Name: company_settings_billing_details; Type: TABLE DATA; Schema: billing; Owner: payarena
--

COPY billing.company_settings_billing_details (company_settings_id, secret_key, uid, billing_details_label) FROM stdin;
9	82A60EE5FBB2B5309166A0ADF60B5FE1E445AB9A2EB35C0D	FAVE	Unified Payment
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: billing; Owner: payarena
--

COPY billing.customer (id, active, created, email, first_name, last_name, modified, password, phone_number, uuid, company_id, payment_types_id) FROM stdin;
40	f	\N	daniel@mailinator.com	Daniel	Adekoya	\N	123456Qq@	\N	f8e6b46f-762a-43d7-a523-89cdb42586cf	8	39
37	f	\N	oluseyi@tm30.net	Oluseyi	Jonah	\N	Test@1234	\N	427ab958-2f7e-47a7-8420-c1500c400fe8	8	44
30	f	\N	aba.angus45@gmail.com	Angus	Aba	\N	9Mobile@	\N	e91ed5f2-2f85-4ed7-8624-5a044d37f0d0	8	42
22	f	\N	adekoyadaniel53@gmail.com	Daniel	Adekoya	\N	Password1@	\N	f9868284-040a-4a08-91fb-e1111193d5e9	8	41
15	f	\N	mife0105@gmail.com	Tomiwa	Odugbesan	\N	@Tomiwa01	\N	898fc41d-80d8-4a4c-86ac-d81053540819	8	38
11	f	\N	slojararshavin@mailinato.com	Sunday	Olaofe	\N	Test12345!	\N	11ceca36-945e-400b-b4c8-cc4cb0c0d069	8	43
\.


--
-- Data for Name: customer_payment_details; Type: TABLE DATA; Schema: billing; Owner: payarena
--

COPY billing.customer_payment_details (id) FROM stdin;
10
14
16
20
21
23
27
28
29
31
32
33
34
35
36
38
39
41
42
43
44
\.


--
-- Data for Name: customer_payment_details_payment_info; Type: TABLE DATA; Schema: billing; Owner: payarena
--

COPY billing.customer_payment_details_payment_info (customer_payment_details_id, secret_key, uid, payment_info_key) FROM stdin;
\.


--
-- Data for Name: payment_provider; Type: TABLE DATA; Schema: billing; Owner: payarena
--

COPY billing.payment_provider (dtype, id, base_url, name, pid) FROM stdin;
UnifiedPayment	1	https://test.payarena.com:8088/	Unified Payment	2853f94a-f2cb-4bee-b37a-1c10bb9816bf
\.


--
-- Data for Name: payment_type; Type: TABLE DATA; Schema: billing; Owner: payarena
--

COPY billing.payment_type (id, name, provider_id) FROM stdin;
2	wallet	1
3	payattitude	1
4	card	1
5	wallet	1
6	payattitude	1
7	card	1
24	wallet	1
25	payattitude	1
26	card	1
\.


--
-- Data for Name: payment_type_adopted_companies; Type: TABLE DATA; Schema: billing; Owner: payarena
--

COPY billing.payment_type_adopted_companies (payment_type_id, adopted_companies_id) FROM stdin;
7	8
6	8
5	8
\.


--
-- Data for Name: provider_payment_type_fk; Type: TABLE DATA; Schema: billing; Owner: payarena
--

COPY billing.provider_payment_type_fk (payment_provider_id, payment_types_id, payment_types_key) FROM stdin;
1	24	wallet
1	25	payattitude
1	26	card
\.


--
-- Data for Name: transaction; Type: TABLE DATA; Schema: billing; Owner: payarena
--

COPY billing.transaction (id, account, amount, created, modified, narration, payment_type, reference, return_url, status, status_message, transaction_id, customer_id) FROM stdin;
12	\N	\N	\N	2023-03-27	\N	\N	42760	http://payarenamall.tm-dev.xyz/payment-verify	FAILED	PENDING	42760	11
13	\N	\N	\N	2023-03-27	\N	\N	42775	http://payarenamall.tm-dev.xyz/payment-verify	FAILED	PENDING	42775	11
17	\N	\N	\N	2023-03-28	\N	\N	42809	http://payarenamall.tm-dev.xyz/payment-verify	FAILED	PENDING	42809	15
18	\N	\N	\N	2023-03-28	\N	\N	42817	http://payarenamall.tm-dev.xyz/payment-verify	FAILED	PENDING	42817	11
19	\N	44964.2799999999988	\N	2023-03-28	Payment for OrderID: 101^WEBID42822	VISA	\N	http://payarenamall.tm-dev.xyz/payment-verify	FAILED	APPROVED	42822	11
\.


--
-- Data for Name: wallet; Type: TABLE DATA; Schema: billing; Owner: payarena
--

COPY billing.wallet (id, account_number, amount, status) FROM stdin;
\.


--
-- Data for Name: account_address; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.account_address (id, type, name, mobile_number, locality, landmark, country, state, city, town, postal_code, longitude, latitude, is_primary, updated_on, customer_id, town_id) FROM stdin;
80	home	HOme	+2347051673435	Nigeria	\N	Nigeria	LAGOS	LAGOS MAINLAND	AKOKA	102216	3.39363999999999999	6.5249113000000003	t	2023-01-26 23:07:40.290289+00	65	4176
77	home	Home	+2348090641563	Nigeria	\N	Nigeria	LAGOS	LAGOS MAINLAND	AKOKA	102216	3.39363999999999999	6.5249113000000003	f	2023-01-27 00:08:24.15016+00	34	4176
70	home	My Home	+2348090641563	Nigeria	\N	Nigeria	LAGOS	LAGOS MAINLAND	AKOKA	102216	3.39363999999999999	6.5249113000000003	t	2023-01-29 06:45:32.214357+00	34	4176
38	home	3 Idowu Taylor Street	+2349033207487	\N	3 Idowu Taylor Street	Nigeria	Lagos	Victoria Island	Eti Osa	0	0	0	t	2022-12-30 07:55:28.088537+00	49	\N
19	work	Makoko Road	08105700750	Nigeria	Makoko Road	Nigeria	Lagos	Lagos Island	Lagos	101211	12.3300000000000001	32.1099999999999994	t	2023-01-16 11:56:38.2763+00	31	45
40	home	24, Alhaja Zainab Street, Osaro Akute. Ogun state	+2348136812997	\N	24, Alhaja Zainab Street, Osaro Akute. Ogun state	Nigeria	Ogun	Ogun state	Akute	0	0	0	t	2022-12-30 10:28:54.14929+00	33	\N
21	home	71 Community Road, Lagos	08105700750	Lekki	Lekki	Nigeria	Lagos	Lagos Mainland	Akoka	0	12.3300000000000001	32.1099999999999994	f	2023-01-16 11:56:38.277187+00	31	45
44	home	Office	08117575388	\N	\N	Nigeria	Lagos	Ikate	\N	0	0	0	t	2022-12-30 12:34:09.970166+00	47	\N
30	home	29, Berkley street Off King George road Onikan	+2348136812997	\N	\N	Nigeria	Lagos	Onikan	King George	0	\N	\N	f	2022-12-20 11:26:57.789998+00	33	\N
45	home	Home	08117575388	\N	\N	Nigeria	Lagos	Ojodu	\N	0	0	0	t	2022-12-30 12:39:43.473495+00	47	\N
46	home	Sarah Jones Street Victoria Island Lagos	+2349033207487	\N	\N	United States	New York	New York	\N	0	0	0	t	2023-01-04 18:17:10.830682+00	49	\N
31	home	Default Address	+2348136812997	29, Berkley street Off King George road Onikan	Onikan	Nigeria	Lagos	LAGOS ISLAND	KAJOLA	0	\N	\N	t	2022-12-20 12:43:39.537925+00	33	2276
47	home	hope	+2349033207487	\N	\N	Nigeria	Lagos	Victoria Island	\N	0	0	0	t	2023-01-05 10:09:22.366374+00	49	\N
48	home	8 Makinde Street	+2349033207487	\N	\N	Nigeria	Oyo	Ibadan	\N	0	0	0	t	2023-01-05 11:45:43.749611+00	49	\N
50	home	29 Berkley Street off King George road Onikan Lagos	+2349033207487	\N	\N	Nigeria	Lagos	Lagos Island	\N	0	0	0	t	2023-01-06 08:35:29.109293+00	57	\N
4	home	Adedeji Home	08097715752	Kasali Hammed	Onikan	Nigeria	Lagos	Lagos Island	Lagos Island	101212	6.54837769999999963	3.38834139999999984	t	2022-12-02 08:32:30.781925+00	29	45
24	home	Home Address	+2347062395879	\N	\N	Nigeria	Lagos	Victoria Island	\N	0	\N	\N	t	2022-12-12 13:09:18.666014+00	42	\N
25	home	Home Address	+2347062395879	\N	\N	Nigeria	Lagos	Victoria Island	\N	0	\N	\N	t	2022-12-12 13:09:50.719683+00	42	\N
26	home	Home Address	+2347062395879	\N	\N	Nigeria	Lagos	Victoria Island	\N	0	\N	\N	t	2022-12-12 14:11:52.465146+00	42	\N
5	home	Home address	+2348136812997	Animashaun Close	Berger	Nigeria	Lagos	Lagos Mainland	AGODO	101102	123.219999999999999	12.1199999999999992	t	2022-12-14 11:32:51.797817+00	33	4166
51	home	24, Alhaja Zainab Street Osaro Akute Ogun state	+2349033207487	\N	\N	Nigeria	Ogun State	Agege	\N	0	0	0	t	2023-01-06 08:36:24.755692+00	57	\N
52	home	29 Berkley Street off King George road Onikan Lagos	+2349033207487	\N	\N	Nigeria	Lagos	Lagos Island	\N	0	0	0	t	2023-01-06 08:51:43.431537+00	57	\N
54	home	29 Berkley Street off King George road Onikan Lagos	+2349033207487	\N	\N	Nigeria	Lagos	Lagos Island	\N	0	0	0	t	2023-01-06 10:06:17.976142+00	49	\N
49	home	pppss	+2349033207487	\N	\N	Nigeria	Kano	Kano	\N	0	0	0	t	2023-01-05 11:55:52.637536+00	49	\N
55	home	29 Berkley Street off King George road Onikan Lagos	+2349033207487	\N	\N	Nigeria	Lagos	Lagos Island	\N	0	0	0	t	2023-01-06 10:07:16.434202+00	49	\N
56	home	24, Alhaja Zainab Street Osaro Akute Ogun state	+2349033207487	\N	\N	Nigeria	Ogun State	Agege	\N	0	0	0	t	2023-01-06 10:10:22.130985+00	49	\N
43	home	Home	+2348085820883	\N	\N	Nigeria	Lagos	Akoka	\N	0	0	0	t	2023-01-09 14:41:38.088728+00	53	\N
\.


--
-- Data for Name: account_profile; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.account_profile (id, phone_number, profile_picture, created_on, updated_on, user_id, code_expiration_date, verification_code, verified, pay_auth, has_wallet, pay_token, wallet_pin, recent_viewed_products) FROM stdin;
30	08080225536		2022-11-21 11:15:43.879639+00	2022-11-21 11:15:44.639131+00	34	\N	\N	t	gAAAAABje13gt5ZrPMQMzReu6t8U5TplHGbCo36hSgX3j6Zh5Iugsre8URXWSz0YuowjoRS7Gm-jbY1kcQD2d-Uk81w6Tn9tgZdsPkip3ALBcc9QWw2UjkCheDXzqy1kaubV96E3f3k-z7FsICD6rh9tNhHk2eZ9oQmeV_mJEEg2JAImOPHdzN-4MEJwywb7ngBQvcRyCIXOYLu9QrcmIle90A-yyODQVd0-_tY-ACBsMCi4cvJTms9ZfTg-E1MJ7Qd2BnR6f5U4kSr_OuIRZcWSrroeBsCUCr0-S8GI_kipnNGIsWuHRlV7JF48BqUVWoSE-agiJIYSO0ptxtg9_rhEXZWoADlWZoiV0dJ2oQSLbMKaDJaWWAg6GKTE6aU0BeP35WGZ2_5QIepzjTxFBbhlzxAcsm394EfxvyNgS05SurRq7WHxHY_JU0LMPAySN6ZnmDnE7uF6SX5CpcwUjERwUFLFvWV8DtOazyAdxRTqEpHjclkdD1NfIU9SCPrPmqxZMIIg8MIjjaSgPCGm_ukK1eKK7onLbr7Ij483jvnnlSikOy2Na7Bc0V1s8qBXQapQVAUrs1z-wmNLxgBOgo_efvFF4oQ4K9CTCbRaRJCtE3E1UQzOaXyw0o7JlbD9dMIbY6-OIJ7Gme5gwLjzPlvNG5As9eS6dgkoEywxs-tbVTH9hzzWaaWbNt-dDah6SAPQNCYVQHnEZikdd8hJ61CnlOwy9UJJQ8hQHuzdyPF_WYYJGqRLbgm58F7HGm69i4ZzUgYq-68Toc18H0YQ6__N7vfj5HcRqkRPai9u3xTxAzHX5Qda-bQ=	f	\N	\N	\N
26	+234090999		2022-11-18 14:02:27.910916+00	2022-11-18 14:02:27.912235+00	28	2022-11-18 14:17:27.912129+00	a2c008a4-6749-11ed-a55f-02001703a2cd	f	\N	f	\N	\N	\N
37	+2348029406858		2022-11-29 11:55:24.459813+00	2022-11-30 12:09:54.792646+00	45	2022-11-29 12:10:24.461088+00		t	gAAAAABjh0gSEF1dI_8s_ZutzxEPaIt68UdbuTUb9GbLUeLukboQzq1_9A_vOwCEp-ePcwwllItEiZcFMP2I0wVfL_CBmKV9GWKZw7ftRZ8LTje_VxaI2UuU3YnbM1xZEcY7oQYu9569bPl15X3BFPCI2RxR_4rWW7mbh6-cBK7wiNuhz8fUmuW9ZpgH7R87pXAKjJgq8odRDVtwI4Pqf_j_2iJcZbxVZw20aRcJiEhivg_n1ighNszRNj7BVmF5FwYmigc8PIL1-QG4L_kPvk1B_orjJ-8eqWQR7DY1ViKzVmH6sUxPt4KFJPcB7PcNmyFW3uMaf_M4M1r1DKS72PvOflcblLFPJx36WCCWxNV1QbFQ-WaaX7wbAloUo3jFCHWTYrPxBMun-IAHJFs0NfYObCwypkxvjX83V_KHn4UC4KyeRlulVOLuMRIApUsF6QMMO7SQj0GujXKMy0xnYCgZzUovEdFR_mEWukYxVQ_22eGnwX90hahi2kSdXLtau1pkBx-yfsk7Zr5HcQ1CyVc5fYK8go9LJk_NdI9ba_lE0uReAbqBrhxqDv-BNXEHS2XwZIsmsda3TM5w3NZFsGV_Yqk-V8qGi_VnEztOu11vJk2ghdbQgpjXlm8HDt4DyPU3-g2C938mORCL95rcQJmmjm9IlDTEKaXZGa9PivWU9Xn1qDEy4wCIp9igqZcqdGY5K7jmLwX9a9-cdl1xl8KOrBtWZuswHzKbLd2_a5Xoyya9zfTSTLHC4-btVhULiHeSfRBRT3TdkNMc1i_r_s30HcN5vH03cffmLJTPr56ij_8syy4O1qs=	t	gAAAAABjhffSRcljAbeJf8VDbQ6It_ffILpWXS_1tyys2dxpfsHHmGPKvPZeBLmZ2XKJi-ugoj2iSbVO2Mb-ztee3k0MY_Qdq--FKWoG0HR3C48kRswUwbCeMHrKN3-owO0QnqnfvSEo	\N	\N
25	+234090999		2022-11-18 14:02:13.184471+00	2022-11-18 14:05:02.427246+00	27	2022-11-18 14:17:13.185762+00		t	gAAAAABjd5EOqLyztiVKhjPSMwa9dkGTifFltikUyvruc0RAEI4YTj5NCe-Lv_dZf3Pm2ya1qk8Y1HWo2cFLqrQPW-FQDo6xHvzbz8npDKCifNo8bEDOUWYKX3GZcXE1YfILeCGYggQgFT4IRrK3Mg2nCKTogn7MzW4RrK75fkYH2wxOcymHCDIZjsm93nj-hALkWbc4ban-KvjywtW5kX1qPATY5s86-iFZbLn8VREL6PCzadNOi2Eqeb6IVe-Hl6ecLbFa_CZTTJfC7w47tYF3gEq6dknfQVo-Gxhktc2TUay_jl8aeqVGd9L3KB0ymc8pSsOcUlz2AapbB37nPuUyASBmEHPMYxi-mAehhe5LLlRL5lYcQncuCMTvEepfdvM8CUNBHPEVBfzm0aIG1b4WZL_dZaLX3Oz4lltZ8qxC_A4swNoTtQDZbfa1RK-JaOEWS48xnjEHbqBtH7KGRriXYZjn295KSZz9H-n3rsXrv1m7YBU1WJWDaK3nhVqiZnjyQZ6yR6uYb4bUTuvq8IqwlIrcFgxXuxMEE3Mokx_cjV5MWTOajHOcUbC8my5jzIoMgCjjjVcM9dL20yAAo4hoC_hhBzFP_ZdbysK_75f5szd_P-lFPqaEWDAy9MTMyOq8Yolee_S0uJwzfxUrzMJwbc_i3h3Y4KQm1X9n6p9_0SBqKwePom7UKjMxTz5a1nC7FGF0Fvw1ORTci-QzukyOUEdg8bbR1GW-cHqZEn928kaj0dkHqpgv-INTGVJA8vJ0Ax0loTHT92iS6nZw7inYPxYwGDqUfQ==	f	\N	\N	\N
32	+2347088888887		2022-11-23 09:44:32.699092+00	2022-11-23 09:47:00.474406+00	36	2022-11-23 09:59:32.700361+00		t	gAAAAABjfewU40QPFIvXT-IvjOgoIWTo_big05YjUuJBPfXvCOhGFX2vksqeUCdvPpNgtiki-bJMn6td9dXu0qxJ1xGLstVo8K2LQAlcHLnQCovbbs6p0hQ6Gls_Qf4f9SkNx8S6DAQMFtepfYJlqxguwmn8XrrEeFt3Fg-Ark6FPNX8VUI1FjmvmiqExIUZ7FYP3jF_h94TMu8lIXTepwy8UR_r2ZTJWrWo-p6IaSV2UReFg3PhMDxBETd2XhGuubqjspg9Xt_57M1XynBE6j9hPIazkLzzV7nJcAgUH89liHcPFfBG8KhmT84GeOWUE4Q8GYvZ2YhwdH0HSXFdgPTUIVF2uQ5xxuomM_w3T5xT04SkGGp5EbVNnQXSA7US9Vhj-UH1lcl5RXPRug89Gx65y9Ri4rWGa0NrL8dVKgArP_DthczWz2qhvyiJf3y8ucRg3ZzavFJNr6DoGDdk9nwwqyDyd5jJGKIG_QxB9I4I3Eeybz6thIx0DnwpurtXqvopxn4ZgCpL5ZS1_S__wRtPTGDTF-cRqpJlREyOyUeZPbqVC76MLv3hXiNb4ci_aMtP4pdbeciYnZMhSZBZ9PEsVnSQJfkrZBKPVifJakJw_YHASprSaI68UOLemeiB6jOQTMfFSbNq88ZRp8v8ryoojeJTit40cpHHlFscI4oXcie3DuzJOc-p4dNYQ5FwqDzTtjetGvCGCPJwL7ocDYXZFGyO0uQzV3JSCz09meCwHdKToCa32rHqrIvYhPYbi_JcBSuQnbZbR5xoZ36NxcaeebzECJeLIw==	f	\N	\N	\N
27	+2348057784792		2022-11-18 14:44:59.070464+00	2022-11-18 14:45:53.211765+00	30	2022-11-18 14:59:59.072017+00		t	\N	f	\N	\N	\N
28	+2348168300320		2022-11-20 17:40:33.945204+00	2022-11-20 17:40:33.946926+00	32	2022-11-20 17:55:33.946819+00	6f75f6f4-68fa-11ed-9fbc-02001703a2cd	f	\N	f	\N	\N	\N
35	+2349011111199		2022-11-29 10:36:28.765382+00	2022-11-29 10:37:11.382077+00	43	2022-11-29 10:51:28.767014+00		t	\N	f	\N	\N	\N
39	+2348057784797		2022-11-29 13:35:59.952478+00	2022-11-29 13:35:59.954133+00	47	2022-11-29 13:50:59.954008+00	c2cc1abc-6fea-11ed-8e65-02001703a2cd	f	\N	f	\N	\N	\N
40	+2347062395879		2022-11-29 15:50:35.964617+00	2022-11-30 08:52:03.780315+00	48	2022-11-29 16:12:30.948623+00		t	gAAAAABjhxmz0_oXlWJ2qkWsVKfJ1vY4YiSS044I4rNECp_JUMCRbYI8upnQHPmrq5Kr2QGkSicbaGna32bg-RtAia9f0NoDVQ==	f	\N	\N	\N
41	+2347062395879		2022-11-29 15:53:40.351036+00	2022-12-22 14:39:09.228652+00	49	2022-11-29 16:25:18.377126+00		t	gAAAAABjpGwNafMH3O8lPshAscx7RZJifOUhtYpIVkNa5b2SWjSto-n0WnJXgn2Oz2er1GEH373furIEH4RP8zhnx5Jx3CWHkQ==	f	\N	\N	\N
60	+2340999999999		2023-01-07 08:04:29.938438+00	2023-01-07 08:06:24.749778+00	75	2023-01-07 08:19:29.939993+00		t	gAAAAABjuSgAaVitkwkV9wCRU0OTXawO_ElJUmL6Jtp0PgquVg4-BhY5Q3drWYGgI5S-zVGrZ2HD8f5HSxzapxwcuBn_bO-iyGCCGZ7WIivTZq8w5NHHR0tcoDJ9PLKPMkEoed8oKlAls6awI0x_YaZ3ka1OKcY-NJIYqvK5259STo1N9aiW4ca31HgWOd2Aj7KIlQsAG0mjWwEkURSRPqWjHuPPwZefShVMdlUnfKbX37Pvc5-cYXgflR9B1Egdq6iDPINI89cHcvsogRwfLEcZPLO67UyScfZ_GryA2x8f-WFleb9pb100xha-HrMTed2v6-0hItqXvy_RQZ-ztw1dqrqITdE2mNw-2vys9P58Nxm22vmaP-RmA2LYTRg_0P__ToWeXLdGlU58qLfwuhUzNozeq-Op-Y2YMjBOLXcDp4kevfe5xnNluWvYsrRQIOr0ySWW8daO2RokAp5NMIDZCoZy_nK8V8e4cg-jJkMxbzDTzFGz_Iy4fN3kHnvc60j5txO-HRok3GF2rdqmw7kcI--BJ8MWUwYYqo1gLDEhmQnHWuWggoBfZEGpBcL1nqEq4GIyHtYVRHndc8vguc8J29GAES53M8AnJD3UyxZnkmfMEBnTD-h9joZx4-2kaJZX6hdWGvhMTK-Az5toDPC6DFGFDIcUX-k3Em4wx9k7LHohIWm6cyvvWOGxyDurmoTw5z9KDlQZD67mCRS5ntkZQFxyum7G9Jz7B3wC250lHWQx_s3vPTJrdjdO-BcwUHEAFHphGa4zHtq-TswdHP5-WMDVu9KLBw==	f	\N	\N	\N
62	+2348135237778		2023-01-18 10:57:32.428549+00	2023-01-18 13:52:38.064765+00	77	2023-01-18 11:12:32.430356+00		t	gAAAAABjx_mm5Efim_YZlaL4ATfuRl5tVzW-60-PCSbS_lZ7GAHGGwZia7OnpE0SV78g0V8WRGMtNyYjdynOxdDDotpQvLk9GQ==	f	\N	\N	\N
44	+2347087419901		2022-11-30 14:40:01.395525+00	2022-11-30 14:50:06.724435+00	52	2022-11-30 14:55:01.397522+00		t	gAAAAABjh2xcbh3s80c4i4ktJjGiu3FvrUwXLWVfIwXr7s-U2q2rH6QdN9GofF7Rs6g4pF2EkHHvK1A4xoIPxsQI9upsl0auTn0ChAeMFvLVx6wxCEfOCHNP7o37YSK28pkNMSh_SI9gP2zsx68sI31ivr9QE800h7cfrg8w2XaffCclTFTCB-CsEE3QAChIwPNzazXONySXXa2QmTNNJ93i7mNXhxHF4yV7QbjD0fhpxTRTh_WmM9DqHwpav8Q3woeqJptM2MdrJyOZDcvmagorxzQBrpqIjEXRoQFSFUMjPFPuVKZQhs9BlVGDzoy6gcrHWyRqPU8Yi_xNm3skPufm4cQ20-A7B2rdyuxTebFM02zZU9qX2xmrerYbSq6cdwe9AzVPyw1nOZBqvqZo8T0s6bBSPUTInpWhgnPq8g_ejNkKN1-wNFA3UdhPqfjUp17BZOipf8F4AIFZGBtE9U4XWibIbpNAAlpECO9ydY-lZY7a3-9qdbcwLCFtz5bC8CeiidetfmTEbgAcIJmXyr5nJh08XoG_niME7TvgfvAMsQeGS2IBut3ZT7TIC0bXgxDBBYStY5PvU_1YJHMoYFm9oAjLWkzo_kj2ERTu60AMXBFTUXDgkm99geNPO0QZyCStFSeePG7Cb3gR-L_XrlqoWvolBp8RYCGGqkywukVVjmCHvDnllkL1-nXxwPVDISKV_E0fg7pcCUAlGXhP7tKXRiOVbLrpXszDoFYGQ0HwPlAiIXfgbhhq4poYqheiJbo1Pm_Bp-7i5zK1do7Z9WLJA2Nhd6K3yQ==	t	gAAAAABjh21u7Wic-Tzvm4vUkLgCt1nIr7vVulMLMZ70S4JjZ2s2NZhH72CP8-_coNL9i21eLN1dEqI6lHImxnh7Gaio5caxSKDqP2Thl6dp1hhdJBhtW1RyskjDeST6psZK7IJhUizr	\N	\N
43	+2347087419908		2022-11-30 09:43:38.652801+00	2022-12-12 17:54:48.30329+00	51	2022-11-30 09:58:38.654356+00		t	gAAAAABjl2ro9VLCEjUsHTwMO8q2v2bMZgpfnyYXUCm4c10lZHcSoEqsufuI3g3x4mrB0cyC0E-uwdhTYexaZEtZ3QD4hXrZ2g==	f	\N	\N	\N
61	+2347087990595		2023-01-09 10:52:57.934721+00	2023-01-11 14:44:35.887617+00	76	2023-01-09 11:07:57.936039+00		t	gAAAAABju_PSIKZOytf71OTKIMB8Atl9ohIc34ix1eiHdqUNI_LzwP2cXl7D2Irfgww7UQaGP3lbXhlPzdnW1jCfFsPa8d3V33bvC3n7cTd9veBcLUG-ToQCGoYgmBpKlw1Ru2VI9fbNXQt5GAFcoTYlR9ZBffTtHOakD1tBgPt-xjy_9Zzm1cLVYB-LNJuto9Ytev0CUIaflW5-uwkk1bCsL5h8BTitaBjj7gkTOb8BrCkMsiKDwhBdboED23z7EYhWS-lxXbE3NGAlv59s1XDkwfGSdxrAAtLF7ySYkw69MjotM3vN-JNZFWm-dHZzxD4clmKbHIMTu-BalSyTz0Dh2enoBgsrbC1_on_ZDUpPW3qd6bu9Yi9l5Z1Vr8udNSD338KzOkBjrz8DZY7I-FV07w-WuW2CpiNnCmkwtdAY8JQJTUZC5FYEdFOgDJf_NJBoi6_USpVqRVNKSIx6gwBZbRhiPloecoYnCPZGy1Lxu1rRxtXFrUFtJHT7ZIIzuoeEnmfqBOS-nGtTJxkwPNuarIAfJTDd_HHi6KthCu4UsuJOovQGuJmF--Hx0t5KoOkWLXDntJBJrOuy4Vxfa2HgwnMcgU-FpoWpU81KSn57iCH4P3stwsmZIVM_pnHEimIRejvfbiwNpEUZPPq5Mvv8pQbArBnqwMhV9_qjKM8US0ozxQQdS3dpi3EjUq-RdotV1joXc8fYfXiCzxyUCGsxBOXzrqQuRdfKCbj78AQl5vUwnAD_HBcdEKs5K6h6yNDoLl2v13YlbaRcZibPoavbtFHofAGu-xyUb3Q-Jd7E6C4wQpEkOPlKJ69qPIgbJe17kXzlXvzj	f	\N	\N	None,51
63	+2348135237778		2023-01-18 12:25:23.347946+00	2023-01-18 12:25:23.349737+00	78	2023-01-18 12:40:23.349604+00	2e3d11b8-972b-11ed-8849-02001703a2cd	f	\N	f	\N	\N	\N
42	+2347062395879		2022-11-29 16:34:48.01415+00	2023-01-18 13:39:06.56775+00	50	2022-11-29 16:49:48.015638+00		t	gAAAAABjx_Z6sRkA9rrTYAGO7ax_45pZEpBMb0v3SclxX6wusxy97RonaRODh3bLs2EwCIADzc1mpkmFCZcLNvopnzzH-TCGXooE1ai53lkNIlmnNDhy3Y__F049DNqtNfpFOvG9i7bDHogwvQ3mYlDA1gXP7EGEFl4hJawYqXYDC1WaYpo1zfAX7Qa1mu2oownPskmVvfgtgWcu3nxDi9XuZcu3JmUQ9FrysgroInjVAWUgWCROgCeJ3ngCI7iAK-WEgN11WQB2u070ly9MgUqDXsqD2EBcHmYvVilNSQ4Pm2N3OTClB1VhmVgP813tpyaU24_74qKRnaaNs9hyFUOl4D50BGFHGvyfvoonPUmCZMA-DGXljHqL3rdkcYm3TukpTn1jSs1fupNZMHGbO41E__dR4fI3gfYuUqyT2yvpu1ZGXuNqg0v8o5tf_iiIRCUi3A-icpyrs1TK5YZKaki8jN5OtA2zbYHKK_rBVEVUexbHTkejWS9gV8_2FFumvXvcXklt2AbLE5Uai1xW4mAYRfckONCgdcRttKuaOwj7ORGHMn5vO_nIOyY-aRyj5_LyW74CEBA8sMnLXq3fHw3-cKOy4KZGjV5wEA1h0eCHsTOkdS1U8tswJZGhHP-nCjg-JjRbUwxP0fBaTnGuLgi31w1ZhkOa-xu2VeXRALnvx8nPYpXD9Bf42iFOf7OjAeC7TR3mi3w3S0IPLNzJt6kOzbT_6e_ZBqIFRS8VNJKMjvEjz37IPYeclAS-yfenBGOZWVQif-Jc0frfNHUC1AfOi3ji2oqf70HFfRRB5AI2WaV4tZIjTao=	f	gAAAAABjjbfKPfJ7u5LAdlWapX1ocCaI2Zx-iYT42HWbfRpzb1H0wOEkK7-f6u3-hL26vL_oHP4Wz6lt676vDqnXU8TSjsCBAYI6lylwHtIbSp99uJywjzEEaTw6qJwhWTWX3JRi6jkl	\N	\N
45	+2348163996466		2022-12-08 08:10:03.095917+00	2022-12-15 11:52:08.715706+00	60	2022-12-08 08:25:03.097371+00		t	gAAAAABjmwpoFXapwi-5U_sIcRhnHYFjp_crep-ONJvgjMYducO8dYRKA7tx3UWzgWluAur_AALdLMNmLsUVstQng83GsQJYtttTgb2ofugKJG8DK6woe2-wEUH5ulKPVSIMBAk7s_Q9zwbv4w_FNera8jeQSyK-wo72KLB-yEdiOCsAtJHGkxzrEXrdKszreYmEvwwPyNoAfLtYK3nIJfcbh-Y_gBrvZyntcrxRlQ5bsGLVQqHTNTbDUuzJHAZnik1aD4eYtFhxY0DIqP1caEP-yfTIUp5XeCtoqFyIt5k330O91LWz2eKtW-rT-CY1Ja9hOlAKvwjtwjrF3PuUfXu1ehGtw3Psves2tIgqnA7zj7-_zL52CNxLwPLipbguK5C1q5u1qzlixOMWU-fiLfFtJI6hZDncPLUtUhJWvVKmf3rz0sqyyFCROqIiN0Vi749jngpLeXUEAGsF4B57xvganixLJ45hzbNT8EFUySSbAFWeL-Ldv6J4Ol5Lz4v--YimJ0TzBSi1kILANAfducOt8MrK00I36rNImJ5IHsWhSo9SJFGn8d1g1b8he0AgjnNlIaLatagX6u0dxFmq4w9L-AG9jU19e9h2mdbUaPD64cBAmXq-WP6Z5Vhz3UhtwSxLEJftLx6fGfPu-rM4ZrBstdfx0dGfQoyp9O7x5OFkoTskT4yiY6qaMxsusEIuj13w0nlLDSfUkHRtT_M3Pt43RNRUWxeJSl20YOqTEDjcS8gP8VZx7KDQldnJvYBym0T4tLIHFmt9o2PvNlT6hA9qhXhWqjmktafzK7wmKYQLW54e1t4SaKc=	f	gAAAAABjkcHc2T0alSq7hdC4QLtIt5_Xg-OnCPyEA3NT_Xjs_jyI4KjMiMlZcM1mh2D7LvVrMXQAxH9N_oPkuDiB9-sdhHJF37rKJIMl8nfwDRcMMqSGxeWcoJMfvnBqrSSOiIP1p8Tr	\N	\N
55	+2346066666666		2022-12-31 08:16:29.179275+00	2022-12-31 08:39:42.77099+00	70	2022-12-31 08:31:29.180789+00		t	gAAAAABjr_VONnreXUb3aaCHWZjH3fcpzsAtif7p39l-61Sgxi7j4B0XO6Yq97KNYEJJnu0FMnCVl7ORqbfCBUGi2LWWEXBQfkl4VbPIWUV1_UBCWir4ehA6eOGSVRB-RzA4WDyh6CLvMFG-ad878QoVNtCiNayUUKEHiYZ7D86Q40LB6W7WPT1-25XcYudefS2SEwsreXDzNKKbuaI6Jf0BX_8cQzfv6w--QhmhN1hettHqD4jSQkG4ojn02YknsjoR3-B7LFkx_WuQxL-_1IOeHyNLwqNHYpfvRsUbzMRyE4WYIouLqT_FzjuUSiljj4FiQ3k0eU6x3ofW5ggymfMGVahv1ixRpBIfoXGJWZfnaSUVouGbPDNAzvMOuFNhSIUlsd9tVYZzZWohpVVkmAY8pyFiYDtjVKRNPea64dK24wi9_uI-uULMxOwguj4l_1Qto2vXvqEYolT85I0hogTEQZMPMSSnpnFHXh3BmVzUcqKYG1MeEPB4YGxTZUevXLWW5QYFgMAP34Nt7RRi6Cm0pZtDJLFttynf6hOCyp5Fpc-DqUNWPdUWbtor9_Y49OYad-QMBZNjvut4kyj1zBNHiFQayY7gbHJqJofmnc9NJn-kOCt3nbd6-yA-8_PO_jVkD2wtvfbZ-T2yhU6vG_wPwLAVhd4fmTdCn8IgbhukpttF7So6ib5KuGQRYLCAO1_31IEOFvvTbThop7_P5Km63Sn04eK7BWoZhOjunY7rIVBJLU0GU_JDzt-3bx7J1FegH4Dhrk8zdgylHdRzvlyQW4_y9JhJHw==	f	\N	\N	\N
64	+2348100285992		2023-01-18 12:47:08.153413+00	2023-01-19 08:43:10.524986+00	79	2023-01-18 13:02:08.154634+00		t	gAAAAABjyQKe4abWUuRuThiC_FNvYkLchUZs7Z30hd2M_cRCvld-TCuyDSmCustyh6RUkGLt00Lom6iPHPyNvZiJ3bsbbjtB5Q==	f	\N	\N	\N
33	+2348136812997		2022-11-23 09:53:57.363153+00	2023-06-15 21:29:28.642551+00	37	2022-11-23 10:08:57+00	\N	t	gAAAAABki4K2EEk2ettLu_jaNA8XuGVzHdNaIinmxUzEdrmy4mPRqDuphu0xv7eqOcxMLmrotM5PjmVvfZo-QhZ-p80gIyySk7pv_4t9JHtCQf_IM4PaIDbZRskKjz_Y_KozKsP6u3-I1Z1k7Ix8Zb3Focj-jSJXqEaFf_VHSVKyI4ZGWMcD_wGVfhcTCOd8BkEFbXxN4uCBfEUqRR7ATQ16iYH_8vzR6swp3cxHrZPIor25Q-DbtC32olU6Z0Bz_RYiueajirPZB5z8iduBVAWLF-wgcBFF0QyVNwS5mq8xIWynchsY6ihufC1HFT9qufjgjzt7JLR46fuyjaKu9qAK5pBrc6X--sF3_h-47-bVBbNazd-xKtLbpJp4MgNwssrstZfBeR32HTx1BQWRjJUSKj4MWYJNTK9oQs_TvliYPqNKpDb1EmJfEjx5AYFLC25sNeoAp13zt7JG9Ca35HmYBUj22alSoLbPZPXggV1kXQ4E9WwtT14lb9Rr3-l2rUJdRzxJxXCr0Y47sGbjuDMCJok0ip8AHRNciXx9uX6DLDzoBcTqFVD83tYylO69ULA06ZorUynBFErUpC_WfMurL0WSD1tQZP7QreZbo-v-tkiAXI0UApXHvazNQTgRRtRjZiK4ilcZpt494l9MpVgC4_GH3tbrXrKpitOfdaojtvkIcwWnWp63iGbqKNGpm-n0I7h5om_oOTVuZ1sHgfAGAHIneT6roJ21yvBk6zzwiJYFoHvPrKt10cQJEWpYAh7jj-kk3mU3N1KXNqlGm7fhYiJP44MqWg==	t	gAAAAABjffkOOv3_8IBmmj2xwg66rkn_hvhyigifEgQh5Nl065_I2tE3OQhGAX9Ozl2liDAI5-FPrx6PCXW-3tZbmLaiyiEvB_bAQzddi9VBFsPH9050GmrKojaePYp8cEXlnZBsrCET	gAAAAABjwIXzoVgh5ROCr9mQxWyhqnfnbu4i4711MdZgsMpacxR8_fj5S_xfccWYwC8tuCiFxwBPQ0YnLiu4v-G4f0DJNQ1sqw==	None,22,42,50,41,40
56	+2347087990595		2023-01-03 08:54:08.121379+00	2023-01-05 12:13:57.717013+00	71	2023-01-03 09:09:08.123215+00		t	gAAAAABjtr8FmIa2YvBrYlIolAJyLzznrhKfHpYKeZnWVhjKnd-ZFiiwNEciq1CTfzTSoSgpd9xMfpoYmhNOxGK-CPbowq7DXZnTxaZwOTdwThTvMPCwzhhLOdTvwTcBwA56z71bKLiVwvnzygaW-SkM-zu4hlB56tnWwW9I74DYv9hSHTaLJQrryed4sYVjLdfRdOfW211bmDoOoiTKFTa16acvcaaqFpquqGpNxcGWx5pX1keLUk35hKpNGwmaHvvoq0cYqNr6LT7T9azufq2iYLkwtxBMq1qqx2AdnpCwKIMgpB3BtAFwwBErdynvYAvhpRAZEIGo598z12rhXAfOyBEPFWDZH6ntYMJCK9BT2-PNiKWfFgIZwAOHEjYF0FOBXsoekY3w7xZwf7juFq-y-UAR0_cDkUFhqQEaImSqvsaqHSpHiAyIIsbQkQBObZfy5pdctPwb7SMgdf_6s1JkaW0eg0g8IgjNlTGRQBckEnAonF5PfUSY81LC3o7hDmkRemlJlU71xtULqddEAokP4KCMutts5rQ7atuygV5X3bBg-DbRd31Mk5_xwXsXqO4neVj4j9nlTrL4Y5lziopls6m7Yoit1DGTtHdaHbqNMFsZ8XqmWETUxCJa3VHt7yi9aKgSPvoLZBhPoiVF19pv521ltykhc7QZEn9UkhxwBXcdvczNclQ3JiDiXX9CzJknI7BcoWBuVheXghFb8wRtx5eXR0rvGHInEEv29_h-FsHLdAez2_Ubm5XQctSCEOjkXx8PPa_TDwP9rE8q8zCHXu7grtFblA==	f	\N	\N	\N
29	+2348168300320		2022-11-20 17:47:05.361313+00	2022-12-11 12:47:45.025077+00	33	2022-11-20 18:02:05.362876+00		t	gAAAAABjldFxjFtv63lQyQKy6R4QTNVpdCXopGoMgp56gJAtqnBvBhIMpSmTGjF6rU6Ex34xg1HSavWy77BTggEUCb6umZpnDJSsr5677RdC5G7r-1v0gFfhVxfLtfi5cJ1qkBqVyiH3Z84XxG-4Wp8rRx8vTNx9tY-v_7SZ8X4VI4gPHDAC1KX_2ptz46lG_7q4sUHSbofLRbNpvC4t7cSaM7UhZWNWpoOEMd9VyWbNWoFrgorOL0yIhkhfz2sAcwG_nU3Q4Bos3TrcsXoxQP2zTpmOqcqHyMbJ7aPOE4Cu6IF3kHZhNb2kv60AJYqQD_0wiT0KMEPoFmy7_PVyBUM93tVqJY5cMdjV9qRYmT4zwuYOf3RLoaz8d7pCBNHVizOGK8pKPh1Sd4Ox5N8_eQq763eODk7wviT81wzWUzgYRu4Fsag7_CT1gCpQq7ngCNJNIVxW5ikdVGUFcJEUJsxNrBFogW9fZ9MvFeCzNZ1SGX-faG01p2A-de8V4QliJu0m4v5Wl8eqIMt-1S120kY1yDavIiOyC7rJegK7d0Y2xOoxucEfpHlm2dhMLbm8lcSRY8Qi6lkMYP1sCVCihwbkBOljoG-tH-h7IE0G1SwoZVLVzvyYnHEFMX3PPC9Rg7lZBIWMoyN4REDC5TID9MREjg51ePwnx2wXinYAyqkh-yQLQ1i8C8YATmATCxOBcuT6TED-3Y_xL4tBNLWDldbOc5LnajVLoMdGdSopf19Yy5D-YyIWhFEbJhUU3BAyVH75Am27O7_po8VPUkcajO7wv9VVDd70bQpY0Kmg3r9VdPcHx5SZPsAHI9ENntc_RL8YCG7G0cYb	f	gAAAAABjiMTmzuNAg5HWXbCxBbI_FN-9o6XfmcL9pg9-877OU5PPQdsbie1wq5wbx8jZ8P2mg5QHadlDHLFgx7SRPDLyUJA5lxtulE9qTno18a00KW3H73QbOthFkMjcG_vJqBBELCnX	\N	\N
57	+2349033207487		2023-01-05 12:16:12.903414+00	2023-01-11 14:51:35.626113+00	72	2023-01-05 12:31:12.904895+00		t	gAAAAABjvsz3SXAZp2YDvjHRMKFcjZfJKfXdaqUCWTuHlhAntCnoI0YTQB4DgMHSFUqpQyAbsgKTw1pFTN08PfcUx_hE__gb5kePRKpYr8NDd8UtmzuPmpvnw85e7n7dTMHSdHMiAkpniPpCdR-kGlGcVaPgbYTOpKWRhj-KfRKmOX1YOHQ_2dK3X8dQKbAHv6-rpbQgfWdvBdQfl-LarAJnmsG2aTF0qPhi3vWJlQEhb1zMo-i086cK6lBIlOgZf40Yvz0XNX2WLzsDzsv2SaNc_9Ht8hTy9FI5aSfDQP_N0-m1B2zJFV6jpsUqNVJckuiH0kXUTPMsIrfie5OeQznAwzXQgHbK4AFGbbKs7xogCT-EB1G7WsZxaMUSZnyGuRJKdELeL48y4g4SkZqqiDPKJyCwLx1uc8Ae98tAxv2cFsvIs4Fa74em1Kx4LsMGagFaKDinBSb6cyHkAJ78SC2De2HNe8lapXqWAUzKp55yOxHC1gBnUNouJ0nmv5PxnCEsj6A3ENDTVF2rypHiVamx_fapUka9kmlEobts37WCXhlDxmOA0lR0fzTylc0EtLitCnzEMmODhbhJPauhCmbuo2inPSZcECdTvqCzDO547DqwcKOsVePNfM-EYdypWlWHjVkavI0FO0PMfGCuGcLtuG9o-RLQ6-1db28S6aSpuvmwGDO4LJ8U4T21RiLztmqO4ksKBH-ZDlnO_6tWkY6QdL0oTY9mwO6dkhgQhhhMEMPoGccFUlaWLM0OSSTQNpQWxtK7Fm4jxVe0QifEAmrW-Zcpx1TQ27nczcrp3Ozos3TcNdCl1Ro=	f	\N	\N	\N
47	08117575388		2022-12-29 08:51:55.692905+00	2022-12-30 14:57:01.072044+00	62	\N	\N	t	gAAAAABjruHHHY8fMfG0GzhJGhk-opZ7kOTpLhASmmb8AqwI6aVrdYwxcqAFBCNjkH8CXqeelLV4INOy7lURKJgyK3wW8QvFWlSfDF9dc8yUYaxWKEbRm1SPG0CQq3MdDH1BLrSgQyA2JmaUu3Q4X93i8JbHh5JuLV6E3cxez1qdnJU9bMabbaSRKG-WL89svg_g0h9fYXgpG9_6XSeh6IbXUNe74-xk8_xsEAGAH4Lqbw0iOnMZH_h6GJWaHKp6BSSZ1xIMDvgzenQAUi0TgsX7pzrzAfjeAx2U9yK7j54TXVqZNrbnTc7xZKA2Tr8fA_cLEohdRo7vQUmPA1mE09MS0KQQT3FmQ-iw8UJ1QfLjtxPEEeUZ3PndojnQuaNvrzp5XXm7bC-oXIwQlVsstpxWx7vHsLYbrcKQAI34nLgtrIcI1R6JkSevfljDGyAeWY2NwxBjwAMBTrB9WGOxoQUe5t2X4NF9O1Wo1pRSyqPfxOWjSSC05ZEXPUf5-XzMGVCR5-bRA4_K9KwG3PJX-lFnQuhty67kH8KxUrR02wGh8CbvX2777M5HtCr5fgtfvjlhiG11aLYfa8uvtaJrsFCGy0uPWTBR-48qOLw0EHWQL5bykFF0HQXFvYpxM2GlYsZ-88nvesyJ_WHvaIEK-jRUokd80BtrBPKlIhqsZrCnorubSDNQuhcFGn8rT4iYGUEtL-gaos3R0CUWaOMPJmWZHumXImj6TfeZTaXN8MYFe7IakL7qIM3SuUEZfV_4HRTaHZMP-_dIeVPWaqthajJvK7oVi6K4yUa5F93Dbo7RNjs_AUN4ero=	t	\N	\N	\N
46	+2348069547457		2022-12-22 14:45:28.294204+00	2022-12-22 14:47:38.944827+00	61	2022-12-22 15:01:43.000471+00		t	gAAAAABjpG4K8AWbpd3GbSLe_96lMTlDKpNM188ub9oreFrARccQ24yIvLDF5cZM17FowIE-vrzllsDSqhs9DKYWQbiulVHd2R2PzWd2uRmo_YTJUWJeh2My-c2c6PzvYjKxhOzuM-jYBDag7cV6Jn6-pPE78A7HTVnpm3CH-y2XNXGolVrgai4O_ADXqJpNRGu5mivAmkH2DJ7_OfBRE_xXIi8lAGL1sb_Z4N8-ABYD7f0ouDbpMFLVDsNbIt62qJE8b4UPKtN2ND5Qv7AvQ7UqIXmaJUMPfIZNr3nvXWQmh-I8yTeQpgemkQ7iQh3aIULlW05zxuKzD7W1sebvAiXTarrBs2kpPLlkbstqX1OHS-2pu7jQ6BZR1EiH_rVrdQmE6OfMmaSujuKiLJtKZLwnpiPuCYcrXqU0_mUsRnCpVT5vZaxduQbgKleLn2edvSztdOtlzV6vHdnKZ317CJa5PJ9aD83LAdTe3c0lHj6iw9Uir3njznITHnvBE8BELgnumr45nPcyqcYR6g2GFsbRNuaKkSVOp6NRlq3bMqxGZFW4FqivHxqUt2-pb6qlA8y7GPHgLvAE_L2P6kZ-RcpelwWLquwIoKdACdnX6lVs_DIcb7hlO9TMlkRqXEtJCmqyqFvINFAAD_BxNo1abJZGNtbbGUuOLa1gSjjsYbfZoav0lOrpYMo6xffP1C2g0Ix8e6PMwLfOmqqIlLluDaGKfJzRGqGktYBF9aL0RkcYUY_7gzWBuGMQXAKRyMnMKcsfU5usa04o7Ivs4M7lXjsG71N28PEC8Q4Gj3XJWjxF73ccHU_Lgy41W8tbQ98bIBe5_1cgvcSD	f	\N	\N	\N
51	+2348085820883		2022-12-29 16:50:09.653409+00	2022-12-29 16:50:09.655025+00	66	2022-12-29 17:05:09.654914+00	daf3e474-8798-11ed-9c5d-02001703a2cd	f	\N	f	\N	\N	\N
24	+2348057784796		2022-11-18 12:27:24.78482+00	2023-02-07 08:13:27.798273+00	26	2023-01-26 13:39:07.344309+00		t	gAAAAABj4ggnQ_xLZac-2KSLz_ks10XNgrFilkTloVA4uD5rMo_WBk1xwicJnLgyiZSq5DqfmCRwEkiJrgJL8ZfxIrSoNzwdR9sLQkN1PyJtxLkOs5NQ8mSQyOInY6QlSCNF6g-9qpBto0zDBSTa-BhyaCulM6uYIP34K9ERl4DhDijp0GTxFRd6hkEtPTscM7WZ82yDnxXEGsCnzQLrHiAHsR0_YRPGgukVMKe6kpu-Pf5ulV-KbflajpPk16JSo0p5-zp8sMHY-P6c5unpVPQ4hTCMLuxX1DQIRjFLS14bmW8_8OvR75p1TZUmeDM7SYuY4Lf3aLn_CLD0Ykb91gRBpkJ-D1HQsUBDXMZQQYWhmCkmauIwJTXlm8Q7ZbvZyc4Kz45bhRmmsyTSuokB4BJKOEeHNqzRIP8bkTQ6VZ5XlL43IWumLWgg41ae21kB3Zw5Jo8rJJZMU3T_gagBLktlHtGV8Q-q4IJK2kAVi9YSRWhrsW_mP1NNUVdf4cDhCmzamkm6jJaKcyrCKOsX0DcjpuxczT18cCV2dDo382UXNL2bfYQRCuOPfIPj7fEVXMu2VwMYFB9SclwPvfnrBTwUAFKASfENFV6uetQvWY_v1jNsM7u3ABlLg0rbmWaKCcryo_6Pw9q1ap3YE5yjImlfBVwfDfgh-ej1QtQCfIkaIqdtspxotbJWapXSLc3bwZlYKQa7ScvSiybnCFjT44JNmotCQN8ot_XFgemr-0GuAO8dg52MuPf9djAFM14Riv_jt-3wPE6GJfkj7lzfl08fQMAqzLQlYLG-WV-IVIHW8LLgMEPz9fY=	f			
48	07087990595		2022-12-29 13:46:25.37631+00	2023-10-11 16:30:35.706329+00	63	\N	\N	t	gAAAAABlJs2r81CRHC98rXGUjjee_WU4yBDY4fyCaBPJQcFI9g-AevaoIKQ3og5J7pOL4CI3MNf5ZiQUXUWL258tixZTonSB3HSx6Gw4RhB52i_6hgJbK-hltNjx-qVkty1cuwODZl7f1pP2GgRMLlH2k2VDuV0KGsgVLyWu7fX52Crr2qlcbEs9LAb0IbrHJB0NF3edV_OH1TbwsRYwARuGBBReGauPU9aWRe35jCzjNjaq-sffmr51QKYySm4CGytlWQV3sLWVoUba_-VzbiTKGAE7fi_zIUWFN2iMl4zG_6baONyLuvjC_SuG-6MVDWI_KjN6135SiP13be2ub1p4fXccu4FHMX5bu-Kr-8m_MGlH4Bt0J0ejifytnIFbyIZEmCJEh-n7vFP3fc_jDp0mA2X5cgK2lFBKDkcLr4saFADw3qlpNj89Mg8FReNSXGUdadv5bR-yHOKR3I_9Yqe1PVKfM6NsrD-dATQbcqJhz8N7O5xyBZzZTmKpwJTN7clLO_JO9KsCXOW4mWHndGjI368-IPhlajXU38L-ezQNc0xw4nP_JJCWu9MnFXuk9jOJrupgpgn1gday2qe27X5eJSmmkYBc-7Lh58jV4hKgwaOxFVzcHjH09x9Y0J9qBm4IRQ04_uMVbAVUR2Y1zMKaiGOzCjtu9D4Bq28pXOHPdoI0CNR6zxu69cqsGAB3lnvOTB1z6K6nhL62_4AfYPmZfrJ8Bu3xCimrtv5tdzQWg836mmQCPiFYMIUt1ym5SEo_SzfGK3gcz4EWa-JVutgJeXWAgcWm-i9KEoSfnGA1jcU66Sm0hJA=	t	\N	\N	\N
50	07032168415		2022-12-29 16:28:59.717779+00	2022-12-29 16:29:02.556888+00	65	\N	\N	t	gAAAAABjrcBM9oFBzMeSnjQLlR9cUKueg7ssYbnDPP85IYxn-ySbHxlfRrIk0twSTjbhrm1SjnkHsOArE4ZknrUW7NPWSX5SM2FO2DMWUG-Bkol0MUWmDcLbpiMRcAR7WhC54CdQG5-7zkHmMyEp-U48GoRSz4r7HlLjmxVKTtqiJ09KNp6Mj-O8UpaQ6oK4TRImOvInbaAbYlVsddZ-TQ7b9M3f609W73ZXp3tAT2gcnVyxwnA88i7W8jRVmcdzoK4lmOqHlDzD9APUzeimJPVlJzDdhOfqY7Fcx-UVgRcy3fY202jmiajpqAB6guEC605mruRYsbmZpSNuBNmfCFHLSHHqlslsavsL8eYex47p5xpUH6Xbph3nJHeg1aBQGcE3LFayM6aS30axs3lNu6C7qa1nsSel-RxTFQHHzRLn0n9NbC7un7dSiEHZ6ES5lk3EYLJw8RIysu9tKOyYtLxIAVnZ5CgfX1pjMHCPaNvbES_H0up2OugYv8CYYp6gxN-tbH-uwHLLXqDvo1aFZovHvKcEdv4PAhzrDtcyQ9xdssRHwhMcizSWucvGpWerwztbKvkLHYGgYh4uyo2Tm1OANJ5_AeEPzblCGNZHsl_VONCBpvaDzJAM72WBvuXLtasA8WL35eCLcXUvKiN1XYhM1bSYk2B80pEcyV5DyBcwG0daZAdUDYjzfP6mlVcOEqfEl6x8XUa1h3Ne1hBmRF5CHG-2vTmv8j6ZEZ01_MscVK5JpW25rVMOP-ONbcjmlzo5OXSnhB4CiDVJWmrj4QQyVg6zwOlOfs8n2_fygT88nJU0VwdzE_I=	t	\N	\N	\N
54	+2347077777773		2022-12-31 08:08:59.424851+00	2022-12-31 08:08:59.426539+00	69	2022-12-31 08:23:59.426417+00	61452fc0-88e2-11ed-923a-02001703a2cd	f	\N	f	\N	\N	\N
65	+2347051673435		2023-01-19 10:07:13.999177+00	2023-01-26 15:04:58.654835+00	80	2023-01-19 10:23:11.996761+00		t	gAAAAABj0paaN_HIHDDuAoJYf62yORXpJwAJVLRhtVXK-Jsy15cDDn21EklyZNBgRjrLKLrDB6F2sL28Tcp3xlG_NL27K9VTXm_N7vOMMMsVs09rqrLRQPjpmyX5kbBV8SQRUbiPNSwJuiyGGkYJ7i927qsLmVoEY0tHbavO2HlyNysHAgdRsddNlNOZ3g2-G705VcZBdsbt4TltmIeeTTwBcU2ll-JM72lMrfDeufIUbit4yXMvRDuZ4ygZl8dyqaMYl2PxmgRMSl1Hk_fkpN5x7JcKbg4D5UYUn_CJWxobE2tZ1NKc0V7fGT1kzR32kXko03eGgpssAMY4yyUylCumEECsWtxvxZ-Vo2T2hMrL-XXHQq7EhNWzRGXO1uaiH5KMV7aSsMoxompxsoBf0LIMsikwexapZ0fKzC3m9kca3QRZ8tjQhrefwiy4qv6Qi55MinUYhb600qUYT3FH3AgsCk4kNE7RnAC0zcI4od1nskBrWhYnjZiucunc7arDApE8qytKiH_31J7qpRgZFPwwSQqiQLn1nZ7Az9T1pSKsTMkNtLmKr5VXfqZ9FzEjOVYdg58JudbAZyYI1tnIgxkZ2LQ1D4veBvktyQZ8QtS_0Z2o6Vgva9GWE7PAoj8wtmu-ViKFS_7VuMa6l0GT9Tf__5qF_Nf-2YCF0KobjmoQEyiypq3wpYhXeD2DHVHk09M4QbSICjnk5pt-wCVte27879ZBvW-xa2neRFHtQ_jf9QfuFWnagbUFATfxtZ5rb5cPcInVl6GBuXk1Iv0BcaKPJ2_PPyK7MA2rBfFgTAxPWWqJ9byb8N9JgSJR4T7-fQELyDDDaC_r	f	\N	\N	None,20,34,32,22
53	+2348085820883		2022-12-30 12:20:40.5162+00	2023-09-26 12:16:56.372229+00	68	2022-12-30 12:35:40.517595+00		t	gAAAAABlEsu4naFbAEDvvYNBJjGjDFoqs_74F1P0rtJetmCCNXC8gw8AgAufiNKWrIO9L4Dp3ERK86HCQWBSfLNflj_D3vDkEg==	f	\N	\N	None,33,54,55
34	+2348090641563		2022-11-24 13:18:28.534285+00	2023-10-24 08:11:03.857992+00	38	2022-11-24 21:11:42+00	\N	t	gAAAAABlN3wXLOsV7_ksK4LImv857W6U7np8HI6xLqGDESqnOH_EY2kcfJdSisZBXU02FuwAusQGaPWefBhoUd-QGHEHNjTchCzqStmXoAJ8G9KMxTY7nq5lYt7N42wuM-cIvKQpLizIMGVcVTN7fLRTUv8EQka2s5tdSFAYlAesx0Ub0mw3qriVaJ5w_9s2IeLdYX8bh5bj5d1zdOBEX7ox-2I37opC-OcB5nWkVP0sXmsBf-nS1ouE1dt9HMe7_xFNSFj--UcyAYrEH55B2aHwIicbGL_TqRtf75H7j0Eoho3wuBC6kLTWFgfTbIj5tp_YTaVI56LNwgdLsBo0VoScdPDx3T6Dc3mJHj5pu7Lk1NwFRauXptEdrihB6ainFnc1QuC70-rYKknUeW3Pj_nohd9mR9uDjVMWXcR5NM6OPSl9HzYXKujMGWZJuZg6TDeUUcBgqbPwNrTD6zKCqV7c0kWU556-5_H5YgdUjwlDVQmEJQjsCQZI3G_tM7yaCQLK4xT4URKsvKEBrvCwlfV98CCThDNNBFx1Kv0gaqX2Ji8XK040hF1KmVt4Gvn-fDgVEKR1om6DmT797xa-iTb9cODE4Wyfpb2e7Nfm8-C4fza2M704CCnifTvFj4GUsPfvDtEdlshDmgjCocIwdtpCIuPF1_C5nrSjaVbSjzkV5YRBzJohFiI26CmJYopY2IDFEct7u_CP9areVS2VUPSlR2-v39IAQ1JNK20b83z7rCsiS459nL6Qpy1v6xeNLaGe_Admw-yolovUItwFUFqkSrifd92BWf6ci1JToVeei2mM3lrfwy0=	f	gAAAAABj5k41c3FxZmI3dAmyGABGCttYhOhg_Kgvf3lKdj6hFxZEETO4aBKTE9AV5gZ3zQxYU9uc5pM2RKU9EU0ljAVJHgfW5KiXQZINlt3NSg28PbFRVipW-vWDKGXh3fDlfslaTI6M		None,23,20,18,34,29,50,19,42,26,30,22,37,44,17,43,31,52,24,55,39,58,60,53,57,54,36
31	08105700750		2022-11-21 11:32:37.481665+00	2023-07-27 11:41:22.667568+00	35	\N	\N	t	gAAAAABkwlfiIdboJJhrGB4xzXfH8Sg78Sa79s3Sq_EY4e-swZ4-qtBf7iWBhUwBJlrwXCrQ7oZTUOiVyXXt9RtP-yChODGPlw==	t		gAAAAABj-KsNA8Ys3AGfXsM9AO7HwWPiY2uPRK0nhFFqIe0x_CwNFYR1UIJqN0Eq4ic3sA9HWephyhFLxqAuXGQwaS4gEDh0PQ==	,54,52,55,43,30,28,22,60,50
49	+2349033207487		2022-12-29 13:49:49.81804+00	2023-01-11 14:52:14.614396+00	64	2022-12-29 14:04:49.819695+00		t	gAAAAABjvs0ebwB6keTVfrOxvJpLdqMD9hQtzPsDGKMoHG73b_3molXIf0EGNbG1pX1FET0oQmA_O37qFeyMOwJ6SnKgPJctOcftvr6WUcm4kVuEg12ZUHP7gHfbCedqUCq3dIDUXF4V5dJ8AX80Jiw9qUCPeHhnULUepqhjGxFEJFkeFzcBWII3Bz3cYd0rt50ujyQ7sl2U-OmaARU8Z6ggCbX4n5VYRshECERm9nejQAzQ9TtkRIaiyT6tA6RUsIqG9A5rtSWWlpXaFtx472gBnPztfGnZDO5pywe5XUw2uZzSYNlGSNrPK1VqqxMlP2azcM3vQd8RWguKslQagUZoB4xaLffXqritCc5dazMPdxPzDpV3UYKrDci0kMGyCrcbUv_hjjuDHEFA_pmtr_-ZO73Z3HMXkp1SOx0d2Ygm-ZR4Y3Qq0k7xLrIF2o8Zh0krqM7Z-WLkshuzeiDv9-qMp5Muyuym3jFFB_znQSHr8cKimG3Qmxwc7Ve44AJdPAfZNj3-dkelvjmbsYrPkhDquG62r-NmOAgXLKmhUAE7batRLyRSHOYYNXEpwe9keYbRHsnR_hXQ8G6jruCpOeubzse135XoImpIPKQzXRYPOW3DG_6jiwLbKEBZYFd36OYpfAbv3lnCHWV31ia_fB24grL40m20L32SsMRTIveDmkIsMpVZqfDj0ZYwoSqD1Hr3StNvbiavKBcOOLhC-2IdBSeF6pjRzfWIpegU4Kgw6AyYfEzUlHjBBsPenxgDQxfOXzeAm5Xp4waliZ4hzB_-l0AULq9PMtFGD82L-p_u2HhzX3ql7s4=	f	\N	\N	\N
66	08064248317		2023-07-13 11:33:36.716686+00	2023-09-28 15:03:00.646772+00	81	\N	\N	t	gAAAAABlFZWkoe_aWVinmARpAdzxZ_X8cpSmGcNxtP8wWZ2GDZs8EsSniM_a5UaTbgqFn1JhU_CnfagRRKnJ4UftalXbAbDQxA==	f	\N	\N	\N
67	07032168415		2023-07-25 13:41:54.872943+00	2023-07-25 14:23:59.622839+00	82	\N	\N	t	gAAAAABkv9r_P_pNGeBJRV5ct-hSOfCclKlpBt7dK0YWsHhPO4vBtEXTAckOQv8qXrPnOjvd1lZW14loy525aDZ8bCx4pBQVWNhpMfVnPKLI_zoePEcRBY2IsDOSu16a-d0YgHmRxFwIJOuYR5ye1Gmr3nuq2E9PataswL4mzfybJHKp3kbUIAiYuF2_F6FOUgioDUvA4lu3D7541V5VWpDxSoq-1WYWuv6_bdMIE5Mj5k79FwMHQi80nC9PmyQO6sKNkJNml6PPta0A4vHtT4dZ7Ph5pmUlMbkoyRFjBOSAm9F56rNL0G6sZFbvdbdLk1ogppiVgX0yuK5sxSwSmLIgIbK5swua6tgnlAeACdq918QOu4yCXglLSEZUiSgH5rU_x6qQae2vpDJyc7aYzsmBgbfQMoufwHdJ97ThHXS1y7lle3B2NLJ1KOYZ-0_PH0RxUwMjlYPG1pVVB_sWbsnvDdUuk67lRm2M-TZAZb2K_nMFfTcYPI8BGzrvq_iVO2knw-giYGkQkYY_cEKR1oaZTaMUcSU4vM6Z4fjyBOWgm8-7aAEkmhXlzwKnMvjteMLNstFgQ94oHxThmjinCGqh6yh13NeNm4JPDuHvef3RSbs54PGNrnV50F39kSZfE8amzDs6zRGIUTJjTcgegCIcMBis1eBV1WxpnYhoZB5i_n59q_DJBYBwilquhyewSNvUKH8KLPmonfxzjp_poz5-rGd5175TdT536XWmmBCgUxJKtttxHlanwavpXkpTPCwisw68B6C8VC_dI9d3WcnAFxJdLfS59X_n_kwUmkpPIEPQfRS-49o=	f	\N	\N	\N
68	08090271939		2023-07-25 14:58:22.555466+00	2023-07-25 14:58:23.357519+00	83	\N	\N	t	gAAAAABkv-MPqHIfRjaiP1QgngSZsHwiWw80Ncq8RN1a1QY9k3dGtmTyjP4NrQRItcO9flx1qj1YVj9RH1IpbLo1Fhw78L0a26kpVleFQgdhY8W729GRitJcPjx2Zs45VkkMyAMAT0Ca6dyp3yWaOkvxwbkRBAVe14vJTLPkAbJahjZuockQnr0v_ZKJWEmzYGW90YvFt6S8PMontYESlmEabcX8uyn8IPZmiG5FCfxek4CMnV07etsMeWW5kbAxBD1rEBIw_nkPdFjRAXlKKRNGY-KMjZvx_horo3UrIetzEd8wkBZxnn3oMfNiLM29-1437OtsJf2UAmse9DrrMKIOBfiO0Dmpi2RnRZZFWU224-7UORCvc_Px3cLvKmpJuemHFizXyctu2RZEpoQtBRO13uR2ECwMm8ZZpN58wAZBxwVkGFPAh8gXUH9QjlNaEJLspZ9jk-gpBSNQpFfBlJPCRRyMe8NBHXkL8PHvAo1wCLEXugDAh7Anx3M9-DOE4_JlrA88jr5JYdLaig0xm8FK57XBGHChCEX_hAKuHp3Uzj-rK4F4hhAb8eWgUT5E3Z0eJ_9_KBOuJpvhkWlufPL0n2HT3okccGiCMPhxod3QbhXIhiKkGbqYdUMz-QDupq7mQZhekbhz1IQWDmqm0w83oSJQ5_P8N00I00rf8UKrllIe0aagIo-Dd2vQdftKZ8cMwg954PPvurWbcX18focGxtjANOci7dtepNWqJr6f_HjlgM7ed4nXAyVLkdtfP4vXUqj7CTcSPnePnJPHr60cdA3mDpw1rw==	f	\N	\N	\N
69	+2348100708287		2023-10-03 10:50:19.757333+00	2023-10-20 07:11:28.798147+00	84	2023-10-03 11:05:19.759236+00		t	gAAAAABlMiggvG-5pFFPBRyjb5bDylIDnVo4DY7nEYAHe6BdXzcikbJs8Cw98dLzCTaOYWlSht0gmYP8p652BPqy57CocPlZ5Q==	f	\N	\N	\N
58	+2347087990595		2023-01-06 08:15:05.99914+00	2023-01-08 08:49:52.939014+00	73	2023-01-06 08:30:06.000878+00		t	gAAAAABjuoOwhqs63yWOo9ophBE3OUDeOayd3szDpcV-IQYJT7xVWPrFq5Ju4QC1uFQ-ewQnx5TrSTt3CUaJ8I_vvd08keiuC71liIIvyrT2TPZeid0NikqnnxqQRVvbBv09WqkLnJ6BObnbtiEBEwyP_SAl4XWzY9N5S-cjq9io_C-3QUcuOIVpcGvKyWusmF3X_W19AqeAjS1y24t8n2oxaPbY9tT19GZxmFJgZH0O_SifvsAEAkqxJ-Qf_ILOi0CiSc_4hIgdlGVDbzPpak4oqMB93Y26ae4FBEV03ENj2VVuvAFd-9XuuisqOTya3_-kW6gs9fP5dLAGXykXW4ns1-7WDMGETIrSUBjCsaNeOZFDjT8DpSlMCnwEI5PVVvCY6OBVwph27khyvLYeqvKzjFUbl6VZWWaEW63A_YwIal5tz8-UZuhHEo4MlzjQTkp3d-vXQLRManZ23eKmjNexzK-1CjS507OIOBag_OlgAilUbcCIrDHUT36J20e9h_bhUH-w1SC6ZJnPy_Qkc3kK8eWYhT8u0BmV3MNLCGjpwbLHZMlkV6xZ1EBwaN8JLw6VBIVsi9dybKvPavj3faNYGI5lN3_KyjFQKv4DZ8c8KXgRNiyyVXP5rbgYNaEGoBC8-MnztepknWurXqtIN9Os1gsxoAwddfiVQsEFNNFyuSSmEWJmSZmwbC_8Jy1rYhtpMdZEaStnRApOnNa3oj2WCL3CFQGSaggKkK3fleIJRL7OLW6bAAuDzyAbtGNG_CLvUnokM9lb3fMmhoikYC-sS94wrgWF1j6up5Q278DCbdFLIKznHYc=	f	\N	\N	\N
59	+2348090641563		2023-01-06 09:52:53.459786+00	2023-01-06 09:56:28.107951+00	74	2023-01-06 10:07:53.461458+00		t	gAAAAABjt_BMkekNhN5AFyblIGzRfs-fHRJhwZ8yFzptPqkvvFHxiKOmCkzfAJXQR9Oz0JiPHQNhEvwcrv3ln6-jkKqvSBEf8_HhZWREGgBQHAJ_WyMgxrZU4GkUz1tEs3_PJ-iIO2hcFJFmhsBxCtiGjdXPf96cdYytZPSX5NrvpmaCDqdmM6L33hYRNJ_iO89GHB1L2-jDZo0A_vmwRqal5tQiU_AJ6soJ_NfWY791xl2zHUpxT4Q3wAQsLSn9rnDzPV0vS7HgCaE7krk23IPIMticmNYf51PTzd7DH7lcKpj-7zHu1CwxS0TdAELrImh8_jL2tURHdSE_vSRII3a0bFFOdXYMs7JCto2m5vHlkpLbXEWoxxZZEGsOdLQhnp6NjmoiJUK7ydUAmHfw6Yz_GGJiop05ZMPGPSF6epLeszNgZufIIk1NH7vO_dbdhMLFpkl433q7UV7sO-kYH7EMB1bKSUqwmgS3Z6BKnM_4D8P9Aoi2xlV_V3gbbLTHxIAqHL3Ikv1OFavHEUu86v4kWIdkAXd8T3Mu1NaJRILU2u1MK3ZKWy7URqY1_TcQ3fHjwNPa4_4VyZTyoEbMzLNRreBy8riVNsCKOSgKElwi6uENGt4JQ3Adsz-HfupDgc9gFoBjBESENg7W-qKzYxUgiZV0BJB0T-ibmKLPqrOXtCEkYwzMsPKHKaWDVdS7mljk4oYBvfEvEmSGPzOHwfo1DPEUFQ7Lfco46N86l9NLqB0nWvjJ-ikHj6AAFSidDfkNBqICS-_VjLSVyCMwN-ZLphYPGhDBK81TI92hy0nQOse5gDWR3qc=	f	\N	\N	\N
\.


--
-- Data for Name: account_profile_following; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.account_profile_following (id, profile_id, store_id) FROM stdin;
5	53	6
7	31	26
25	34	6
26	34	7
27	34	11
28	34	26
\.


--
-- Data for Name: account_usercard; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.account_usercard (id, bank, card_from, card_type, bin, last4, exp_month, exp_year, signature, authorization_code, payload, "default", profile_id) FROM stdin;
\.


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can view log entry	1	view_logentry
5	Can add permission	2	add_permission
6	Can change permission	2	change_permission
7	Can delete permission	2	delete_permission
8	Can view permission	2	view_permission
9	Can add group	3	add_group
10	Can change group	3	change_group
11	Can delete group	3	delete_group
12	Can view group	3	view_group
13	Can add user	4	add_user
14	Can change user	4	change_user
15	Can delete user	4	delete_user
16	Can view user	4	view_user
17	Can add content type	5	add_contenttype
18	Can change content type	5	change_contenttype
19	Can delete content type	5	delete_contenttype
20	Can view content type	5	view_contenttype
21	Can add session	6	add_session
22	Can change session	6	change_session
23	Can delete session	6	delete_session
24	Can view session	6	view_session
25	Can add forgot password otp	7	add_forgotpasswordotp
26	Can change forgot password otp	7	change_forgotpasswordotp
27	Can delete forgot password otp	7	delete_forgotpasswordotp
28	Can view forgot password otp	7	view_forgotpasswordotp
29	Can add profile	8	add_profile
30	Can change profile	8	change_profile
31	Can delete profile	8	delete_profile
32	Can view profile	8	view_profile
33	Can add user card	9	add_usercard
34	Can change user card	9	change_usercard
35	Can delete user card	9	delete_usercard
36	Can view user card	9	view_usercard
37	Can add seller	10	add_seller
38	Can change seller	10	change_seller
39	Can delete seller	10	delete_seller
40	Can view seller	10	view_seller
41	Can add seller verification	11	add_sellerverification
42	Can change seller verification	11	change_sellerverification
43	Can delete seller verification	11	delete_sellerverification
44	Can view seller verification	11	view_sellerverification
45	Can add seller file	12	add_sellerfile
46	Can change seller file	12	change_sellerfile
47	Can delete seller file	12	delete_sellerfile
48	Can view seller file	12	view_sellerfile
49	Can add store	13	add_store
50	Can change store	13	change_store
51	Can delete store	13	delete_store
52	Can view store	13	view_store
53	Can add country	14	add_country
54	Can change country	14	change_country
55	Can delete country	14	delete_country
56	Can view country	14	view_country
57	Can add state	15	add_state
58	Can change state	15	change_state
59	Can delete state	15	delete_state
60	Can view state	15	view_state
61	Can add city	16	add_city
62	Can change city	16	change_city
63	Can delete city	16	delete_city
64	Can view city	16	view_city
65	Can add brand	17	add_brand
66	Can change brand	17	change_brand
67	Can delete brand	17	delete_brand
68	Can view brand	17	view_brand
69	Can add cart	18	add_cart
70	Can change cart	18	change_cart
71	Can delete cart	18	delete_cart
72	Can view cart	18	view_cart
73	Can add cart bill	19	add_cartbill
74	Can change cart bill	19	change_cartbill
75	Can delete cart bill	19	delete_cartbill
76	Can view cart bill	19	view_cartbill
77	Can add cart product	20	add_cartproduct
78	Can change cart product	20	change_cartproduct
79	Can delete cart product	20	delete_cartproduct
80	Can view cart product	20	view_cartproduct
81	Can add product	21	add_product
82	Can change product	21	change_product
83	Can delete product	21	delete_product
84	Can view product	21	view_product
85	Can add product category	22	add_productcategory
86	Can change product category	22	change_productcategory
87	Can delete product category	22	delete_productcategory
88	Can view product category	22	view_productcategory
89	Can add product detail	23	add_productdetail
90	Can change product detail	23	change_productdetail
91	Can delete product detail	23	delete_productdetail
92	Can view product detail	23	view_productdetail
93	Can add shipper	24	add_shipper
94	Can change shipper	24	change_shipper
95	Can delete shipper	24	delete_shipper
96	Can view shipper	24	view_shipper
97	Can add promo	25	add_promo
98	Can change promo	25	change_promo
99	Can delete promo	25	delete_promo
100	Can view promo	25	view_promo
101	Can add product wishlist	26	add_productwishlist
102	Can change product wishlist	26	change_productwishlist
103	Can delete product wishlist	26	delete_productwishlist
104	Can view product wishlist	26	view_productwishlist
105	Can add product review	27	add_productreview
106	Can change product review	27	change_productreview
107	Can delete product review	27	delete_productreview
108	Can view product review	27	view_productreview
109	Can add product image	28	add_productimage
110	Can change product image	28	change_productimage
111	Can delete product image	28	delete_productimage
112	Can view product image	28	view_productimage
113	Can add Token	29	add_token
114	Can change Token	29	change_token
115	Can delete Token	29	delete_token
116	Can view Token	29	view_token
117	Can add token	30	add_tokenproxy
118	Can change token	30	change_tokenproxy
119	Can delete token	30	delete_tokenproxy
120	Can view token	30	view_tokenproxy
121	Can add product type	31	add_producttype
122	Can change product type	31	change_producttype
123	Can delete product type	31	delete_producttype
124	Can view product type	31	view_producttype
125	Can add image	32	add_image
126	Can change image	32	change_image
127	Can delete image	32	delete_image
128	Can view image	32	view_image
129	Can add address	33	add_address
130	Can change address	33	change_address
131	Can delete address	33	delete_address
132	Can view address	33	view_address
133	Can add order	34	add_order
134	Can change order	34	change_order
135	Can delete order	34	delete_order
136	Can view order	34	view_order
137	Can add order product	35	add_orderproduct
138	Can change order product	35	change_orderproduct
139	Can delete order product	35	delete_orderproduct
140	Can view order product	35	view_orderproduct
141	Can add bank account	36	add_bankaccount
142	Can change bank account	36	change_bankaccount
143	Can delete bank account	36	delete_bankaccount
144	Can view bank account	36	view_bankaccount
145	Can add seller detail	37	add_sellerdetail
146	Can change seller detail	37	change_sellerdetail
147	Can delete seller detail	37	delete_sellerdetail
148	Can view seller detail	37	view_sellerdetail
149	Can add director	38	add_director
150	Can change director	38	change_director
151	Can delete director	38	delete_director
152	Can view director	38	view_director
153	Can add return reason	39	add_returnreason
154	Can change return reason	39	change_returnreason
155	Can delete return reason	39	delete_returnreason
156	Can view return reason	39	view_returnreason
157	Can add returned product	40	add_returnedproduct
158	Can change returned product	40	change_returnedproduct
159	Can delete returned product	40	delete_returnedproduct
160	Can view returned product	40	view_returnedproduct
161	Can add return product image	41	add_returnproductimage
162	Can change return product image	41	change_returnproductimage
163	Can delete return product image	41	delete_returnproductimage
164	Can view return product image	41	view_returnproductimage
165	Can add order entry	42	add_orderentry
166	Can change order entry	42	change_orderentry
167	Can delete order entry	42	delete_orderentry
168	Can view order entry	42	view_orderentry
169	Can add transaction	43	add_transaction
170	Can change transaction	43	change_transaction
171	Can delete transaction	43	delete_transaction
172	Can view transaction	43	view_transaction
173	Can add role	44	add_role
174	Can change role	44	change_role
175	Can delete role	44	delete_role
176	Can view role	44	view_role
177	Can add admin user	45	add_adminuser
178	Can change admin user	45	change_adminuser
179	Can delete admin user	45	delete_adminuser
180	Can view admin user	45	view_adminuser
181	Can add merchant banner	46	add_merchantbanner
182	Can change merchant banner	46	change_merchantbanner
183	Can delete merchant banner	46	delete_merchantbanner
184	Can view merchant banner	46	view_merchantbanner
185	Can add merchant transaction	47	add_merchanttransaction
186	Can change merchant transaction	47	change_merchanttransaction
187	Can delete merchant transaction	47	delete_merchanttransaction
188	Can view merchant transaction	47	view_merchanttransaction
189	Can add daily deal	48	add_dailydeal
190	Can change daily deal	48	change_dailydeal
191	Can delete daily deal	48	delete_dailydeal
192	Can view daily deal	48	view_dailydeal
193	Can add bulk upload file	49	add_bulkuploadfile
194	Can change bulk upload file	49	change_bulkuploadfile
195	Can delete bulk upload file	49	delete_bulkuploadfile
196	Can view bulk upload file	49	view_bulkuploadfile
\.


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
30	pbkdf2_sha256$260000$OiacbU2xQttC0nTBBg2Zdz$uQs5IVeK76G1afkAUtuGyva4dvq6ZOkjmSzL+RYAJUE=	\N	f	definatelycrypticwisdom@gmail.com	George	Nwachukwu	definatelycrypticwisdom@gmail.com	f	t	2022-11-18 14:44:59.065986+00
32	pbkdf2_sha256$260000$mgSuzaOuuOEAHysgj4llOQ$mjVJ90TEz87Vryn2aRRKh1FXDWnClUigTJTFpH3vdOY=	\N	f	remibil920@klblogs.com	Adedeji	Agunbiade	remibil920@klblogs.com	f	t	2022-11-20 17:40:33.94091+00
33	pbkdf2_sha256$260000$8ffH7YvzlkU9ZhvoRWZHef$ZdMWCYmPA94fOPoAEqAruiyadwfP+7Nb/FYghjhY+Ko=	\N	f	agunbiade.adedeji94@gmail.com	Adedeji	Agunbiade	agunbiade.adedeji94@gmail.com	f	t	2022-11-20 17:47:05.356762+00
48	pbkdf2_sha256$260000$pzCumbLKYBgZlbcDE2XFJ6$0l8knUMwEC3zgszWPgVQWdi6ljL7RM/Rj8iKCtetChc=	\N	f	faith.akor@up-ng.com	Faith	Akor	faith.akor@up-ng.com	f	t	2022-11-29 15:50:35.959475+00
34	pbkdf2_sha256$260000$GlFmWVoc1ys1SnOzcfw3bH$1l99DpVjCTzns6pOGOm1KpblBmm1oel/1qUAzJKcyEo=	\N	f	tomiwat@mailinator.com	Tomiwa	Ogunlade	tomiwat@mailinator.com	f	t	2022-11-21 11:15:43.875111+00
35	pbkdf2_sha256$260000$opX2HVbO8YYRnDSnk9zNvP$i06vWf2dF06z3GuUfmANluhBIPTrdm1NaWnI2Nmx6zs=	\N	f	slojararshavin@mailinato.com	Sunday	Olaofe	slojararshavin@mailinato.com	f	t	2022-11-21 11:32:37.476703+00
49	pbkdf2_sha256$260000$RpfVHUJ92lUJlfRvkpfNYV$Q1g/O8YMxb6TP0DsQyERck+UpkogTfaYyDBkBldxNTA=	\N	f	odachi07@gmail.com	Faith	Akor	odachi07@gmail.com	f	t	2022-11-29 15:53:40.346686+00
36	pbkdf2_sha256$260000$2pcqWlUfpm6c1GD38fQP3J$Tbq2BdCgRtv9DSa9mlmlEuFqN+hIYV3SaR+VN3KCihA=	\N	f	tomi@mailinator.com	Tomi	Tom	tomi@mailinator.com	f	t	2022-11-23 09:44:32.694756+00
50	pbkdf2_sha256$260000$UIexq7ALcDAzVibXgJm91c$UoNKBgnE1v8M9L+vW4UrOHKKq6T/k1+p1yk2kZrEJ9U=	\N	f	eplatform@up-ng.com	Ecommerce	Platform	eplatform@up-ng.com	f	t	2022-11-29 16:34:48.009968+00
27	pbkdf2_sha256$260000$rS3FLS5EkAZAymVgxILCiw$oyqtX6bgcX1LMRSX1kI2rdm9IWkt5N2RS3pxgqDXfgc=	\N	f	eni@mailinator.com	eni	badi	eni@mailinator.com	f	t	2022-11-18 14:02:13.180033+00
28	pbkdf2_sha256$260000$M432TSjex74Enf7U0s2Tn7$Nzai7TqhYiLCUnApt6vp6IT3YhrXIYZQ12WcJvBhGsk=	\N	f	eni1@mailinator.com	eni	badi	eni1@mailinator.com	f	t	2022-11-18 14:02:27.907325+00
51	pbkdf2_sha256$260000$w1cayBSJLjN4NgIMgzQoZk$Jo965Pg1kaZZxZvjhbmeNgriaFYeU56vF6OL9fN9Mt0=	\N	f	oloruntobi.a@gmail.com	Toby	UP	oloruntobi.a@gmail.com	f	t	2022-11-30 09:43:38.648359+00
26	pbkdf2_sha256$260000$M70H6JKcJMvLFcDTpSYy5T$/D+z9TSejfVeX0REG7WvFNBjscfAqAxc92cSWi8R4V0=	\N	f	crypticwisdom84@gmail.com	Wisdom	Nwachukwu	crypticwisdom84@gmail.com	f	t	2022-11-18 12:27:24+00
52	pbkdf2_sha256$260000$DqWIyDvVRNG6NcINZQucEq$hsyIb+HWntpVsjfhE7Mx3AwNiHoFzb++7J8QI9FCnEg=	\N	f	ucgraps@yahoo.com	UcheChi	UP	ucgraps@yahoo.com	f	t	2022-11-30 14:40:01.3905+00
38	pbkdf2_sha256$260000$10IJSm5I6NsWGqsGRDZr3G$q0dspSLc9oRryA71SKVkaiyGUJyrYhFMSovJ23XakJc=	\N	f	adekoyadaniel53@gmail.com	Daniel	Adekoya	adekoyadaniel53@gmail.com	f	t	2022-11-24 13:18:28.529638+00
63	pbkdf2_sha256$260000$6vLyJSXIgMT5Wxez6gzqtf$vhHVc1/mQWxfybmQ1MFFboJMib5sJwq+u2VM4C+AO98=	\N	f	aba.angus45@gmail.com	Angus	Aba	aba.angus45@gmail.com	f	t	2022-12-29 13:46:25.372012+00
65	pbkdf2_sha256$260000$Uk6ieytHVndA9tgQVpWp80$IROIE8FGTLWZdiA6NovqNh9szBaRwY+jNi6Mi5JP6MI=	\N	f	juststayreel@gmail.com	Eugene	Aderorho	juststayreel@gmail.com	f	t	2022-12-29 16:28:59.713121+00
43	pbkdf2_sha256$260000$NbqAolaUk02uqNtCA2ihrO$1HQToj4QFk3x+YqD3nJtG5P9Khojn1a4qdwEuagB/BE=	\N	f	eniola@mailinator.com	Eniola	Bab	eniola@mailinator.com	f	t	2022-11-29 10:36:28.760382+00
54	pbkdf2_sha256$260000$chovhDbkFl7qrnMnfgIiEo$zVjQRwzv9C2ho/HU9K+Tbs4glH2YaWcHlqricC09+6w=	\N	f	sarahadekoya70@gmail.com	Daniel	Adekoya	sarahadekoya70@gmail.com	t	t	2022-12-02 13:26:47.991697+00
45	pbkdf2_sha256$260000$SekCMw5x6btXJjEpHsFPTm$DBLh5wetK0hyqTDZ+MOnaGznTehz9Pq0scReT0mJf+g=	\N	f	funky@mailinator.com	Funke	Obafemi	funky@mailinator.com	f	t	2022-11-29 11:55:24.455227+00
47	pbkdf2_sha256$260000$lk0AfWN7mrupa42FMvNEgK$wQsMPa8l2nrumVSM3HHiErQ6ogzrC1ssJgWT2bb4YRs=	\N	f	wisdom@tm30.net	George	Nwachukwu	wisdom@tm30.net	f	t	2022-11-29 13:35:59.948173+00
66	pbkdf2_sha256$260000$Ii7rZE7ZeBkrH9EflunorN$2q0OWynaO6eehkfE25ivUhTELhpsR0K2Pi8eyrek934=	\N	f	danielmiicro53@gmail.com	Daniel	Adekoya	danielmiicro53@gmail.com	f	t	2022-12-29 16:50:09.648692+00
69	pbkdf2_sha256$260000$0xYaK7bW0WT4PtI3ct3v9L$F4QaS/B65SP8yOWNQyuJvI+/zGGHcF1DA5nw6GDeJrw=	\N	f	fe1@mailinator.com	Feyi	Feyi	fe1@mailinator.com	f	t	2022-12-31 08:08:59.419835+00
53	pbkdf2_sha256$260000$oRVr3MaiWbMSpwX6bSH5sr$+Aqe516rLeN2tA5wU4pfFKLr2xlI2SFLRfqkMpzA6WQ=	\N	f	admin@UP.com	Daniel	Adekoya	admin@UP.com	t	t	2022-12-01 11:05:13+00
55	pbkdf2_sha256$260000$TkBTLOOg9pAj4lZizPVUcZ$EZtsXOW+I662DJCCfnSzxIKIWY6Enjz4O4chvGbjB5k=	\N	f	tomiwa@mailinator.com	Tomiwa	Tee	tomiwa@mailinator.com	t	t	2022-12-03 15:40:12.397058+00
56	pbkdf2_sha256$260000$9rKY6FJQ1mk4d442B5gkjz$3xsyhHJCpdE1tkQb8utkXbngaw5F8L3zfwCxa3MjW6Y=	\N	f	danielmicro53@gmail.com	Damilola	Adekoya	danielmicro53@gmail.com	t	t	2022-12-04 14:47:35.787548+00
57	pbkdf2_sha256$260000$ZOb1QvTeChJnkmCutnOdRC$UfLEeOKhw8u9ekVEzgfbmarXLJ2BsyaOZESbKP5bFw8=	\N	f	tee@mailinator.com	Tomiwa	Teee	tee@mailinator.com	t	t	2022-12-05 09:26:06.842122+00
58	pbkdf2_sha256$260000$ftZPqvlaSD1p0xOg2pZCtc$OXO+oAfqJ69va1RzNxXkbjVtoBL4djLWcBRqLlfNr2U=	\N	f	ecommerce@up-ng.com	Faith	Akor	ecommerce@up-ng.com	t	t	2022-12-07 15:20:47.598123+00
59	pbkdf2_sha256$260000$wjtDRAG1dqL2CKTtUTB91L$+D0DxlA6hxwfmMIs/9P3fVi4k5lu7Lhty9hCCPQJK7U=	\N	f	alice.afo-oko@up-ng.com	Alice	Afo-oko	alice.afo-oko@up-ng.com	t	t	2022-12-07 15:22:34.61539+00
60	pbkdf2_sha256$260000$rX7ru2dfv01XRdSfmLeJ20$Bc6Qgpzuu+QTmqorccGUSW0F1fs5uWotT9HF+ZK+bB0=	\N	f	anselmothniel@gmail.com	Othniel	Anselm	anselmothniel@gmail.com	f	t	2022-12-08 08:10:03.0912+00
61	pbkdf2_sha256$260000$323LHP24SYG616pJGkO7Sr$tdPh0Z4duyBKTdExCzK0BIVf8rB3JaOSTylH0tPIlkc=	\N	f	uchechukwu.chikezie@up-ng.com	uchechukwu	chikezie	uchechukwu.chikezie@up-ng.com	f	t	2022-12-22 14:45:28.28906+00
64	pbkdf2_sha256$260000$MZ1WM4zfx1rgwEdoLBjZBy$ft7jVi94lONPIbquUQ6fW0vjY/E3HzjEzjmzy2csdto=	\N	f	aba.angus02@gmail.com	Angus	Aba	aba.angus02@gmail.com	f	t	2022-12-29 13:49:49.812894+00
62	pbkdf2_sha256$260000$XMDVgarAIWEQqD1MeTo3Ug$buXw0trXtAejly49Eo9IRV6cCGF30Xa4M2O7o/YvDgg=	\N	f	johnagada1993@gmail.com	John	Agada	johnagada1993@gmail.com	f	t	2022-12-29 08:51:55.686978+00
68	pbkdf2_sha256$260000$pNjXFtsXeCQeguWXAq32RT$4GUw8y2734esMTrEBVcTWQeq61XdWphQxOzOMPbjPe4=	\N	f	daniel@tm30.dev	Damilola	Iyanu	daniel@tm30.dev	f	t	2022-12-30 12:20:40.511669+00
70	pbkdf2_sha256$260000$KBxzeChR6HAxYpmKqz980P$1Qscw3YmIjdAPmT0MAxl7bFhOlLkQdtpdXKeP9sArEM=	\N	f	feyz3008@gmail.com	Feyi	Feyi	feyz3008@gmail.com	f	t	2022-12-31 08:16:29.17473+00
71	pbkdf2_sha256$260000$4vJU8vMmnCE4CD6BXIc7Cb$ZtQICu+WYD8cz0OwbU2WfYm9AqedMhmTAmS5SvvCmow=	\N	f	angus.aba@up-ng.com	Angus	 aba	angus.aba@up-ng.com	f	t	2023-01-03 08:54:08.116314+00
1	pbkdf2_sha256$260000$kIIcN5xplwuzcNgO03EhQy$/KsIPM+LMoZwISHeV68hiZKO2D+pKiUw0s95koIi7VU=	2023-10-23 11:23:22.976945+00	t	admin				t	t	2022-10-06 09:43:50.856984+00
37	pbkdf2_sha256$260000$TRrbAISLvyXxmMpZC9dPsI$DfTIqvFvm6YzRhJU725yAffuHenRt75ulb00O5Zd7fM=	\N	f	mife0105@gmail.com	Tomiwa	Odugbesan	mife0105@gmail.com	f	t	2022-11-23 09:53:57.35859+00
72	pbkdf2_sha256$260000$twVDT6qPgM3olIJzF75DAk$xZLue05sEDexLuJS6+M1PmQ1Zmvk1bMPY/xNnvj3Clo=	\N	f	ochinokwu@gmail.com	Ochinokwu	Aba	ochinokwu@gmail.com	f	t	2023-01-05 12:16:12.898604+00
74	pbkdf2_sha256$260000$Jn3dTe4Rp9y1otOZ7Ydkht$vOnygQMY3xxNQgr4Ib4YP6qeOPE0zf7jP7MDj9j2yuw=	\N	f	daniel@mailinator.com	Daniel	Adekoya	daniel@mailinator.com	f	t	2023-01-06 09:52:53.455181+00
73	pbkdf2_sha256$260000$95DuObyIyyaYQ5JYGRJHIY$efDNR8QIZCPWyfJDVADkuCvPu+Icm2iiBCJJXmmJTA0=	\N	f	angus.aba01@gmail.com	Angus	Aba	angus.aba01@gmail.com	f	t	2023-01-06 08:15:05.993897+00
75	pbkdf2_sha256$260000$IPsry0qOh9HBXkwEV5LKyc$1RFpzFZTG2kBFxeJuqJV7EXAFaKCsBhDJJpqFQhFtrI=	\N	f	tomm@mailinator.com	Tomiwa	Teeee	tomm@mailinator.com	f	t	2023-01-07 08:04:29.934005+00
76	pbkdf2_sha256$260000$jHfWhU6kkVRMIrYtJJR33m$KlfmPtKvRhS9I+7k4EMQV/yUjYw/pZnlLT7ma8UabYQ=	\N	f	sylvester.ameh@up-ng.com	Sylvester	Ameh	sylvester.ameh@up-ng.com	f	t	2023-01-09 10:52:57.930346+00
77	pbkdf2_sha256$260000$3lDGfOI0aJqogtf6TuiLkz$RXS/VQYdvbvb9J3pW0VIbdYAH9Wnypo34aCkVntHEEs=	\N	f	estherene97@gmail.com	Esther	Abah 	estherene97@gmail.com	f	t	2023-01-18 10:57:32.423458+00
78	pbkdf2_sha256$260000$YFpnZkZ9G3mIOEzDx02qKD$BlSSbdAwJvxNUhczmW5dPrC961dZFxcUbGQGv06A4kM=	\N	f	estherene@gmail.com	Esther	Abah 	estherene@gmail.com	f	t	2023-01-18 12:25:23.342936+00
79	pbkdf2_sha256$260000$CeClzn5u6Z7FNhGIzeSo2L$PJ/UecI3bLT6ZMzDWTOTKnC4rQQ1Zvmx8OxKN48jkUk=	\N	f	peternwaby@gmail.com	Peter	nwabiankea	peternwaby@gmail.com	f	t	2023-01-18 12:47:08.149342+00
80	pbkdf2_sha256$260000$wSsLBD1TbSUkmpkF7OngDl$D66tALzaWzp1eQmYBKrjDSWenfWXcclEBo5CCgER6ek=	\N	f	olabanjiadeyemi96@gmail.com	Oluwatobi	Adeyemi	olabanjiadeyemi96@gmail.com	f	t	2023-01-19 10:07:13.9946+00
81	pbkdf2_sha256$260000$N0U86zzoSY2fqdBXn4rZyu$e9D5U9LCRKlLzgIY4YeeI9BsPThahRaNqI5yuEzRe88=	\N	f	oluseyi@tm30.net	Oluseyi	Jonah	oluseyi@tm30.net	f	t	2023-07-13 11:33:36.707435+00
82	pbkdf2_sha256$260000$ResQMHk84tMyRRQPg4ZjXw$0uELshpa1gCp4bpHO9WE4TNqEDKaX8V9jB6h2lR5swU=	\N	f	aderorhoeugene@gmail.com	Eugene	Aderorho	aderorhoeugene@gmail.com	f	t	2023-07-25 13:41:54.866993+00
83	pbkdf2_sha256$260000$eTB5GnrBRhiVBm5w1xplVS$m8m8NkJFMYXZ1s183Y1UCwzMEs9AQZOEmuTt7x8SyE8=	\N	f	aly_oko@yahoo.com	aly	Oki	aly_oko@yahoo.com	f	t	2023-07-25 14:58:22.550205+00
84	pbkdf2_sha256$260000$W5mflyVbeT4dWESrXcnUPh$hG4lQLK76z7U4vZGK7z5ILtnN84mlkfPWPD3ydGThjM=	\N	f	omodara.tobi@gmail.com	Oluwatobi	Omodara	omodara.tobi@gmail.com	f	t	2023-10-03 10:50:19.751608+00
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Data for Name: authtoken_token; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.authtoken_token (key, created, user_id) FROM stdin;
9207b352dff736e98981efdd762915a720bd64e1	2022-10-06 09:43:50.926684+00	1
fe54db15ccb4293cb73a4f1e760c58109af04a41	2022-11-18 12:27:24.783176+00	26
134565d509866c6b10511c138fc8d75dd3396fd9	2022-11-18 14:02:13.182709+00	27
a07c88c2721475f75cd03b638aca6bffda6f019c	2022-11-18 14:02:27.909438+00	28
c232821172089741652b5baaba3c4066d8921f36	2022-11-18 14:44:59.068532+00	30
3e737a2148bc6ef8dd3c1662089201359e6209d9	2022-11-20 17:40:33.943251+00	32
ef435faf39e8ed8383a5c3f017fc75fc0462f745	2022-11-20 17:47:05.359393+00	33
c7cf3bbf228b2fe026df4f4fa2110a7a1dd2a656	2022-11-21 11:15:43.877756+00	34
9c1354c4445871a50e5bfecf9cf0ec19b78f9459	2022-11-21 11:32:37.479658+00	35
a72b8c0ce96d5dc5a174ec5c1627a54863a5500f	2022-11-23 09:44:32.69733+00	36
c49a40ae761145a4bfb68aacd70399224acf11b5	2022-11-23 09:53:57.361403+00	37
5af029256368daf13447c4f115fd6dcea6d650d3	2022-11-24 13:18:28.532384+00	38
9fff7266278222bf6b8d6937a1440b317245c305	2022-11-29 10:36:28.763367+00	43
4f755d297e3a93f683865ef362e645994c5c1047	2022-11-29 11:55:24.457926+00	45
ea0dbcd467f9177aa75d756e4b573430cb38ca21	2022-11-29 13:35:59.950655+00	47
b9252733020d3e90ef56f8a061de0066336c92ca	2022-11-29 15:50:35.962534+00	48
7229fb4ac58a70d42faabd2079e7e1af9874b4a0	2022-11-29 15:53:40.349099+00	49
5eab62b3f0b4c110ceeb86b0f58bc8786a3dcb75	2022-11-29 16:34:48.012393+00	50
3288c3d5ae257d9fc2b2b8c0ccc9f019b460490e	2022-11-30 09:43:38.650958+00	51
e93bff7a84479dc84058b9e0c9aeee477d719233	2022-11-30 14:40:01.39319+00	52
777fb801dcf76fa97420d35fe12f9c8a5940a700	2022-12-01 11:05:13.244876+00	53
c7ae3c1c8c2753beb0200d4cc7336daf979ca753	2022-12-02 13:26:47.992876+00	54
573840d841128c6c1cbab8fd0e914e000dfdc71a	2022-12-03 15:40:12.398242+00	55
69e916ab4b947f6b3ef418fd92d2201ca995698e	2022-12-04 14:47:35.788987+00	56
d655bf453589ce469e8f3137be87b438384b694c	2022-12-05 09:26:06.843313+00	57
d5d1716022f0b92eaf34709408075dbf92372054	2022-12-07 15:20:47.599293+00	58
5ab98f6ba35cad801976a860e23f2ac898a9fde7	2022-12-07 15:22:34.61655+00	59
10433850a6f8faf51e858e346e15d52d6c243015	2022-12-08 08:10:03.093984+00	60
447e730a65429f9d7438185b147b8f80c43f9b87	2022-12-22 14:45:28.292022+00	61
33261b5d28528a3d67963cbd864999f675b0f7dd	2022-12-29 08:51:55.691006+00	62
b7992bb1c05c99d82a1ffc3a8fa4e1f2a96e5dfc	2022-12-29 13:46:25.374585+00	63
efc9f9972b1f9e19680e95af4c53687d23f61635	2022-12-29 13:49:49.815762+00	64
cb9a5e5b3d71d5a9150885b7784645e09a1d6d7e	2022-12-29 16:28:59.715862+00	65
111907aea5a41029ae21119d68907cd9d004d0aa	2022-12-29 16:50:09.651051+00	66
d6b82ebd00f945f17baeb4c98df2f60d3f17dcc6	2022-12-30 12:20:40.51432+00	68
ee31b1dd479f491379ec71bf5813af09c65967ec	2022-12-31 08:08:59.422638+00	69
47fa0240468a5e5731ac83de4f97bbd0565f0d8b	2022-12-31 08:16:29.177356+00	70
698d7a7f24327ddfd5f69cb857324aa18869496b	2023-01-03 08:54:08.119338+00	71
7fe8a9cee53b940880a0ee0ed0bf479a287c9bbd	2023-01-05 12:16:12.901019+00	72
35a8a007a6ff9fd2553e99243a593c507553f318	2023-01-06 08:15:05.997002+00	73
0e145548b304d3863fd0a30f3088edd946663c06	2023-01-06 09:52:53.457821+00	74
9538c36c870b6881f96b700623d95fff712b35bc	2023-01-07 08:04:29.936536+00	75
94652c5a08ca0149754ffe6378b82d27136fc3a7	2023-01-09 10:52:57.932968+00	76
1966a05d0ffe2e94a94e3ffa399d7392ad7ee9cc	2023-01-18 10:57:32.426331+00	77
df92c12ea2878e6e93d8b570db054b9ccb01591a	2023-01-18 12:25:23.345782+00	78
9c191766d92568e5803603f28da049fd7beea58b	2023-01-18 12:47:08.151684+00	79
a669d4e4e14b1c207c55a83c191840f41aa79e30	2023-01-19 10:07:13.997226+00	80
b5fe0793d3feebe5da45af32964d0518c7b2e636	2023-07-13 11:33:36.712054+00	81
08f62b5cf43d020c462261f097319885d0af40d6	2023-07-25 13:41:54.870469+00	82
5966a205b2bf0920d47a0a811333448494378b5d	2023-07-25 14:58:22.553087+00	83
eef3d3dd49c0f3958948861ac666bc3d8dd7bbea	2023-10-03 10:50:19.755025+00	84
\.


--
-- Data for Name: base_user; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.base_user (status, commission_type_id, date_modified, id, registration_date, wallet_id, dtype, api_key, email, name, password, phone, role, settlement_type, user_id) FROM stdin;
0	\N	\N	1	\N	\N	Client	qwertyuiopasdfghjklzxcvbnmqwertyu	info@tm30.com	TM30 Global	FileOpen@2022	08122010733	CLIENT	\N	da45694f-8de8-4eb9-a15b-9efb607c57d0
0	\N	\N	2	\N	\N	Client	nllpBYVgBAFevMmz1WwltYzbZbIXmxESXIkr7sktpwXJhWIUKulWrjaa2K4KzcwPvDvtRKkaZR2dmOPeD1anNzlmEW4e0cfaRRYqSvyaipNK2sCmGAjLvFaTwgGHN455	info@tm30.dev	Tm30	$2a$10$wf//EsQqwJLvbot0BspykeGVEbiW.GqYf3RPWvVebpFJksXoqSNb2	08025365740	CLIENT	\N	4070929b-b05f-42a3-979b-9a57e9eaf988
0	\N	\N	3	\N	\N	Client	OBvHqGz9CZ57HkpHA3yPIJbcBLhc64OlD570i1EOpY0tOtyyeuuxcr5IUiRNS88VQfbHqZGcPoSbjY1mUFIpMYLnIjcQGpiz6cd5gdJlmmifWP4NvY0vqNfhXuSfUpg8	info2@tm30.dev	Tm30	$2a$10$LPjfFdlIqHxUQp/iWayA5e2MTfUaYQ99yND69wGImy0wDWjcsqDdq	08025365740	CLIENT	\N	d5864c47-ed14-49ac-8bf6-a252cffb0a6c
\.


--
-- Data for Name: base_user_approved_shippers; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.base_user_approved_shippers (approved_shippers_id, approved_shippers_key, client_id) FROM stdin;
\.


--
-- Data for Name: base_user_roles; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.base_user_roles (base_user_id, roles) FROM stdin;
\.


--
-- Data for Name: base_user_shipments; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.base_user_shipments (client_id, shipments_id) FROM stdin;
\.


--
-- Data for Name: city; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.city (id, code, name) FROM stdin;
1	LAF	LAFIA
2	IKP	IKOT EKPENE
3	EKT	EKET
4	UYO	UYO
5	WRI	WARRI
6	ASB	ASABA
7	SAE	SAPELE
8	GUS	GUSAU
9	AKK	ABAKALIKI
10	JAL	JALINGO
11	CBQ	CALABAR
12	NSK	NSUKKA
13	ENU	ENUGU
14	OFA	OFA
15	ILR	ILORIN
16	DUT	DUTSE
17	AKR	AKURE
18	BNI	BENIN
19	ABK	ABEOKUTA
20	SAG	SAGAMU
21	IJB	IJEBU ODE
22	OTA	SANGO OTA
23	BAU	BAUCHI
24	OSG	OSHOGBO
25	IFE	ILE-IFE
26	ISL	LAGOS ISLAND
27	MLD	LAGOS MAINLAND
28	MIU	MAIDUGURI
29	KAS	KASTINA
30	OGB	OGBOMOSHO
31	IBA	IBADAN
32	OYO	OYO
33	SKO	SOKOTO
34	LKJ	LOKOJA
35	GOM	GOMBE
36	UHA	UMUAHIA
37	ABA	ABA
38	ORI	OWERRI
39	YOL	YOLA
40	BRK	BIRNIN KEBBI
41	DAM	DAMATURU
42	KAN	KANO
43	MNA	MINNA
44	SUL	SULEJA
45	JOS	JOS
46	KAD	KADUNA
47	ZRI	ZARIA
48	ADK	ADO EKITI
49	ABV	ABUJA
50	MDI	MAKURDI
51	PHC	PORT HARCOURT
52	BNY	BONNY
53	AWK	AWKA
54	NNI	NNEWI
55	ONA	ONITSHA
\.


--
-- Data for Name: city_towns; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.city_towns (city_id, name, town_id) FROM stdin;
1	NASSARAWA EGON	3929
1	GUDI	1524
1	GIZAWA	3924
1	GARAKU	1522
1	AGWASHI	3915
1	AGWATASHI	3916
1	AZARE	3919
1	KURGWUI	3926
1	GWANJE	1525
1	AWE	2239
1	DADDARE	3921
1	TUNGA	1532
1	NASSU	3930
1	ALUSHI	1516
1	LAFIA	3927
1	AGYARAGU	1514
1	MADA STATION	1528
1	ANGWAN ZARIA	3917
1	DOMA	1520
1	ANDAHA	1517
1	ASSAKIO	3918
1	MOROA	3928
1	WAMBA	1533
1	GIZA	1523
1	QUANPAN	3931
1	AZARA	1519
1	ASAKIO	1518
1	BASA	3920
1	RUKUBI	1531
1	FARIN RUWA	1521
1	AKWANGA	1515
1	GARAKU KOKONA	3922
1	KADARKO	2274
1	AGWADA	1513
1	JIRIYA	3925
1	KWANDERE	1527
1	OBI	2294
1	RINZE	1530
1	NASARAWA EGGON	297
1	OLA	1529
1	GIBA	3923
1	KEANA	1526
1	GWANTU	2257
2	IKOTE EPENE	3406
2	INI	1222
2	OBOT AKARA	214
2	ESSIEN UDIM	212
2	IKONO	213
3	EASTERN OBOLO	141
3	IKOT  ABASI	144
3	NSIT UBIUM	146
3	MKPAT  ENIN	145
3	ONNA	147
3	MKPATENIN	3079
3	IBENO	143
3	IKOT ABASI	3078
3	ESIT EKET	142
3	EKET	3077
4	Ewet Village	5073
4	ETNAN	519
4	IKOT EKWERE	5085
4	NSIT ATAI	523
4	OKBO	5098
4	ORON	526
4	ITU MBO USO	5090
4	Military Office Iba Oku	5091
4	IKA	521
4	OKOBO	525
4	UBOT AKARA	5103
4	UYO	5108
4	Akpan St.	5064
4	EKPARAKWA	5068
4	UTUNG UDE	5107
4	ETINAN	5072
4	Iboko	5080
4	UKPOM ABAK	5105
4	NDON EBOM	5092
4	OKITAH	5099
4	IBIAKU NTOKPO	5079
4	School Of Art and Science	5102
4	AFAHA NSIT	5063
4	IBESIKPO ASUTAN	2117
4	NDONUDUE	5093
4	OKU IBOKU	5101
4	IKOT ABIA	5081
4	EDIENE ABAK	5066
4	UDUNG UKO	527
4	OBOT IDEM	5096
4	IKOT OSURUA	5086
4	UKANAFUN	528
4	EDIENE ABAK	5067
4	Housing Estate Ewet	5075
4	NTUNG UDE	5095
4	IBAKA	5076
4	NKAN UDE	5094
4	URUAN	529
4	ODOT	5097
4	ETIM EKPO	518
4	IBESIKPO	5078
4	IBIONO IBOM	520
4	ITAM	5089
4	NSIT IBOM	524
4	MBO	522
4	URUEFONG ORUKO	530
4	URE UKO	5106
4	ESSIEN  UDIM	5071
4	Faha Oku Akpon	5074
4	IKOT EKPENE	5083
4	Uyo Market	5109
4	IKPE IKOT NKON	5088
4	ERIAM ABAK	5070
4	IKOT EBOM	5082
4	UBOT IDEM	5104
4	ENWANG	5069
4	IBENU	5077
4	ABAK	517
4	ITU	571
4	ORUK ANAM	2118
4	EASTERN OBOLO	5065
4	OKOITAH	5100
5	GBARAMATU	2128
5	OROGUN	5129
5	OTO-OWHE	2148
5	SAPELE	5131
5	OGULAHA	2138
5	OWHE	2151
5	AGBAHA OTOR	5111
5	OKWOKOKO	5126
5	OZORO	2153
5	BURUTU	2123
5	OLEH	2143
5	ABRAKA	531
5	OREROKPE	2146
5	EFFURUN-OTOR	2329
5	EKU	534
5	KWALE(AGIP PLANT)	2133
5	BOMADI	2122
5	ESCRAVOS	2125
5	JEDDO	2130
5	ABBI	2119
5	EKAKPAMRE	5116
5	KWALE(ABOH)	2132
5	EMEVOR	2124
5	AGBARHO-OTOR	532
5	OWHOLOGBO	2152
5	EKPAN	5117
5	OKPARA INLAND	536
5	EKEREMOR	2250
5	OJOBOLO	2140
5	OGUME/AMAI	2139
5	OTUJEUWEN	5130
5	NGALA	5122
5	AGBARHO	2120
5	UBEJI	5132
5	OKWAGBE	5125
5	IFIOKPORO	2129
5	PATANI	2154
5	OKWAGBE	5124
5	UGHELLI	538
5	OKPAI	2141
5	EVWRENI	2126
5	OKPARA WATERSIDE	2142
5	OSUBI	2147
5	UMUTU	2155
5	UGHOTON	539
5	KWALE(ASHAKA)	2134
5	ORE ROKPE	5128
5	AGBARAHOR	5112
5	EDJEBA	5114
5	EWEN	535
5	KWALE (ASHAKA)	5120
5	UGBOKODO	537
5	ABONYMA	5110
5	WARRI	5133
5	OFUAGBE	2136
5	OLOMU	2145
5	ALADJA	533
5	OTUJEVWEN	2150
5	N.N.P.C. DEPOT	5121
5	FORCADOS	2127
5	KWALE	2131
5	KWALE (AB(ABOH)	5119
5	OLOMORO	2144
5	EFFURUN	5115
5	ENERHEN	5118
5	OGIDEGBEN	5123
5	OTUJEREMI	2149
5	AGULABIRI	2121
5	OGIDIGBEN	2137
5	OBIARUKU	2135
5	OPORAZA	5127
5	AKO	5113
6	UKWU NZU	857
6	Alibuba Quarters	2754
6	EKWUOMA	91
6	ILLAH	95
6	ISELE UKU	2772
6	OVWIAN-UDU	2783
6	Ekpan(Tori)	2767
6	Umuonaje	2794
6	IDUMUJE UNOR	94
6	Borrow Pit	2762
6	ISSELE ASAGBA	845
6	OKPANAM	849
6	UBULU UKU	105
6	OGWASHI UKU	99
6	Warri Airport	2796
6	ADONTE	829
6	UKWU OBA	858
6	Okuamagba Layout	2780
6	EKUMA	840
6	OKO AMAKOM	100
6	OBOMKPA	98
6	Boji-Boji Agbor	2760
6	ISSELE ASABA	2774
6	ISHEAGU	844
6	UBULU OKITI	2787
6	AKWUKWO IGBO	90
6	ACHALA IBUSA	828
6	AKWU OHA	2752
6	ATUMA IGA	2757
6	ONICHA UKU	853
6	Cablepoint	2763
6	IBUSA	842
6	OKO OGBELE	2777
6	EWULU	841
6	AKUMAZI	832
6	Okpe Rd.	2779
6	Ayomanor Rd.	2758
6	UBIAJA	2786
6	Boli-Boji Owa	2761
6	UBULUBU	855
6	EGBUDU AKA	837
6	OLODU	852
6	Agimele Village	2750
6	AJUMA IGA	830
6	OTULU	2781
6	UKALA UKPUNOR	108
6	UGBOLU	107
6	Golf Course Rd.	2770
6	NBTC	2775
6	Catholic Mission Rd.	2764
6	OSSISSA	854
6	UMUTE	859
6	Umuagu	2791
6	IGBODO	561
6	Ojolu /Ghana	2776
6	ASHAMA	835
6	Owa-Alero Rd.	2784
6	ANWAI	834
6	AKWA-UKWU-IGBO	2751
6	G. R. A.	2769
6	UKALA	2790
6	ISSELE MKPITIME	96
6	UGBODU	856
6	ONICHA OLONA	103
6	Overhead Bridge Layout	2782
6	Ezenei	2768
6	OLO	851
6	IDUMUJEUNOR	2771
6	Atufe Rd.	2756
6	OBIOR	848
6	B.  D. P. A. Area	2759
6	Chickester Rd.	2766
6	EBU	836
6	EJEME ANIOGOR	838
6	UGBODO	2788
6	UBULU UNOR	106
6	OKWE	850
6	EJEME UNOR	839
6	Okpanam Asaba Rd.	2778
6	Central Core Area	2765
6	AKWUOHA	833
6	NSUKWA	847
6	Alders Town	2753
6	ONICHA UGBO	104
6	Upper Erejuwa	2795
6	Ugborikoko	2789
6	ASABA	2755
6	OKOOGBELE	102
6	Umueze	2792
6	Isieke	2773
6	OKO ANALA	101
6	ISSELEGWU	846
6	EMUHU	92
6	UMUNEDE	2793
6	IDUMU OGOR	843
6	Reclamation Rd.	2785
6	ISSELE UKU	97
6	AKALA	831
6	IDUMUJE UGBOKO	93
6	UTAGBA UNOR	860
7	OBIARUKU AMAI	4963
7	ABRAKA	4959
7	KOKORI	4962
7	YESSE	4968
7	ISIOKOLO	4961
7	OGHARA-EFE	475
7	OGORODE	4965
7	MOSOGAR	473
7	IBADA ELUME	472
7	OGHAREKI	4964
7	AGHALOKPE	471
7	EGBE OGUME	4960
7	OGHARA	474
7	JESSE TOWN	2064
7	OKPARA INLAND	4966
7	SAPELE	4967
8	MARU	1167
8	LUNGUN SARKIN MARAFA	3207
8	NNPC	2288
8	ANKA	1157
8	TSOHUWAR KASUWA	3219
8	GUASAU	3199
8	HAKIMI DAN HASSAN	3202
8	KOFAR KWATAR KWASHI	3204
8	TSAFE	1170
8	TUDUN WADA	3220
8	KAURA NAMODA	179
8	MIYENCHI	1168
8	FED.POLYTECHNIC	3197
8	BUBGUDU	3193
8	SHIYAR LIMANCHI	3214
8	BAKURA	1158
8	KOTROKASHI FED UNIVERSITY GUS	1164
8	MARADU	3210
8	ZURIMI	3222
8	BUKKUYU	1160
8	POST OFFICE	3212
8	GUSAU DEPOT	3201
8	JANYAU	3203
8	LUNGUN YAN NASSARAWA	3208
8	NNPC GUSAU DEPOT	3211
8	TALAFA MAFARA	3218
8	AROKA	3191
8	ZURMI	1171
8	BIRNIN MAGAJI	1159
8	SHIYAR SARKIN BAURA	3216
8	SHIYAR MAI JUBBU	3215
8	TALAT MAFARA	180
8	BUNGUDU	1161
8	GUMMI	1163
8	EMIRS PALACE	3196
8	BYE PASS	3195
8	SHIYAR WALI	3217
8	BIRWIN MAGAJI	3192
8	MAFARA	3209
8	BUKKUYUM	3194
8	KASUWA DANJI	178
8	KOTORKOSHI	3205
8	MARADUN	1165
8	GENERAL HOSPITAL	3198
8	SHIYAR DAN GALADIMA	3213
8	UNGUMAR DAWAKI	3221
8	SHINKAFI	1169
8	DANCHADI	1162
8	GUSAU	3200
8	LUNGUN GALADIMA	3206
8	MARAFA	1166
9	NGBO	758
9	OBEAGU	764
9	IGBAGU IZZI	750
9	AFIKPO	2641
9	NTEZI	762
9	NKWOEGU(BARRACK)	760
9	EZZA UMUOGHARU	745
9	IBOKO	749
9	EZZA PRESCO	744
9	RANCH	2679
9	OKWOR NGBO	770
9	SHARON	777
9	G.R.A	2650
9	IKWO	2651
9	Enugu-Ogoja Expr.	2649
9	ISU	2657
9	NWOFE	763
9	ABAKALIKI	2638
9	OKPOSI	2311
9	ONUEKE	771
9	IKWO/ FUNI	751
9	ISHIELU	2656
9	INYIMAGU	753
9	EZZAGU	746
9	ODUDU(RANCH)	766
9	UKAWU	781
9	ACHIEGU	734
9	AFIKPO-SOUTH	2643
9	UBURU	778
9	OZZIZZA AFIKPO	776
9	OKPOSI OHOZARA	2672
9	UWANA/POLY	782
9	YALA	2327
9	Enugu Exp Rd.	2648
9	ISU/ONITCHA	754
9	AFIKPO NORTH	735
9	AGUBIA	737
9	UGBODO	779
9	Nkaliki Rd	2663
9	EZILLO	743
9	OKPOSI OKWU	768
9	AFIKPO- NORTH	2642
9	SHARON NYSC	2680
9	EZZAMGBO	747
9	Mbukobe	2660
9	Kpiri-Kpiri	2659
9	OKOTO/EVENGAL CAMP.	767
9	OKPOMA	2308
9	IKWO(FUNI)	2652
9	ODUDU	765
9	Pressco Junction	2678
9	EDDA/OWUTU	2647
9	OHAOZARA	2670
9	Abakpa	2639
9	NKWO EGU	2664
9	EDDA	741
9	NDUFU ALIKE IKWO	757
9	OKPUITUMO	769
9	AFI BARACK	2640
9	AJAGBAODUDU	2644
9	Ntezi Aba	2665
9	OBIOZARA	2667
9	Ogbaga Rd	2669
9	UWANA AFIKPO	2683
9	IKWO/FUNI	2654
9	Udensi St	2681
9	EBUNWANA	740
9	IKWO/FUNI	2653
9	Ndiaguo	2661
9	OTAM NDIEZECHI	774
9	ONITCHA	2675
9	AKAEZE	2645
9	YAHE	2325
9	UWANA	2682
9	EFFUM	742
9	IKOM	2264
9	INYERE	752
9	IZIOGO	755
9	ONEKE	2673
9	ORIUZOR	773
9	New Layout	2662
9	NGUZU EDDA	759
9	ONUEBONYI	2676
9	NWAOFE	2666
9	UWANA POLY	2684
9	AMASIRI	739
9	AKPUOHA	738
9	OGOJA	2298
9	ONUNWEKE/MARIST BROTHERS	772
9	IYABA	2658
9	ONICHA	2674
9	UGWULANGWU	780
9	NOYO	761
9	OUEBONYI   	2677
9	AZOBODO	2646
9	ABAOMEGHE	733
9	IKWO/FUNI	2655
9	AGBA	736
9	OKOTO/EVENGAL CAMP	2671
9	EZZAMGBO 135	748
9	NDUBIA	756
9	OWUTU EDDA	775
10	CHANCHANGI	1345
10	GEMBU	1352
10	EMIRS PALACE/CENTRAL MARKET	3542
10	MILE SIX	1369
10	NASSARAWA JEKA DA FARI	3556
10	NUKKAI	1372
10	HOUSE OF ASSEMBLY	3545
10	NYSC CAMP	250
10	MAYO-LOPE	1368
10	SUNTAI	1378
10	MAGAMI	3551
10	YOKOKO	3566
10	PRESIDENTIAL LODGE	3558
10	PUPULE	1373
10	DONGA	1347
10	SARDAUNA	1376
10	TELA	1380
10	KOFAI A/NUNKAI A	3549
10	BAISSA	1341
10	BAISSA/KURMI	3538
10	SUKANNI	3560
10	JAURO YINU	1356
10	JEN	1357
10	BARUWA	1344
10	GASHAKA GUMTI	1350
10	SUNKANI	252
10	ABUJA/MAYO DASA	3536
10	YELWA A	3564
10	ARDO-KOLA	247
10	GIDIN DORUWA	1353
10	MONKI	1370
10	DORAWA	3541
10	TAKUM	1379
10	MAISAMARI	1366
10	BARADE WARD	3539
10	GASSOL	1351
10	MARARABA KUNINI	3553
10	KAKARA	1358
10	LANKAVIRI	1365
10	SABO GARI	1374
10	IWARE	1355
10	MAYO GWAI/A.J OWONNIYI ESTATE	3554
10	GIDAN DOROWA	3543
10	CHACHANGI	3540
10	JAM	3548
10	YORROW	253
10	BALI	1342
10	JALINGO	3547
10	WUKARI	1382
10	GASHAKA	1349
10	MUTUM BIYU	249
10	SABO GIDA TELLA	3559
10	GINDURUWA	3544
10	BAMBUR	1343
10	USSA	1381
10	KARIM LAMIDO	1359
10	KOFAI B/NUNKAI B/AWONIYI QTRS	3550
10	MARABA DONGA	1367
10	MAYO LOPE	3555
10	ZING	254
10	DAKA	1346
10	UNGUWAN GADI	3563
10	KPANTISAWA	1362
10	GARBA CHEDE	1348
10	KURMI	1364
10	IBI	1354
10	NGUROJE	1371
10	KASHIBILA DAM	1360
10	LAU	248
10	MAINA REWO	3552
10	KUNINI TOWN	1363
10	SIBRE	251
10	SABO GIDA TELA	1375
10	ATC	3537
10	NGUREJE	3557
10	SERTI	1377
10	TUDUN WADA	3562
10	YAKOKO	1383
10	KONA	1361
10	TELLA	3561
10	YELWA B	3565
11	UGEP YAKURR	3013
11	BEKWARRA	2960
11	Eta Agbor	2978
11	CALABAR SOUTH	2969
11	IYAHE	1020
11	MANFE	1022
11	IWURU	1019
11	BAKWARRA	2959
11	Ogja Rd	3004
11	IGOLI OGOJA	2981
11	OBUDU LGA	3000
11	KWAFALLS	1021
11	YAKURR LGA	3019
11	Ediba	2972
11	ETUNG	2979
11	UYANGA	1036
11	Stadium	3009
11	NANFE	2992
11	OKUKU	2313
11	CALABAR	2967
11	IKA-NORTH EAST	2983
11	OHONG OBUDU	1033
11	Udama Ubug	3011
11	Egerton Area II	2974
11	Bogobiri	2964
11	Comm. Sec. Sch.	2970
11	YAKURR	1037
11	BOKYI LGA	2966
11	OBAN	1027
11	UGEP LGA	3012
11	AKAMKPA	1005
11	NKO-UGEP	1026
11	NKPANI	2994
11	YAHE	2326
11	State Housing Estate	3010
11	BAKASSI	2958
11	OGOJA	2299
11	OHONG-OBUDU	3005
11	Okim Osabor Rd	3006
11	IGOLI  OGOJA	1015
11	MKPANI-UGEP	1025
11	OBALIKU LGA	2995
11	BEKWARA	1007
11	CREEK TOWN	1011
11	Main Market	2989
11	OKONDI	1034
11	OBUBURA	2998
11	Biko	2962
11	NKO UGEP	2993
11	Ukelle	3015
11	Egerton	2973
11	Scout Lane	3008
11	AKPABUYO	2956
11	Airport	2955
11	Ukamusha	3014
11	Bojor Archibong	2965
11	OBUBRA	1029
11	Obudu Rd	3002
11	Ekpo Abasi	2976
11	Mission Road	2990
11	OBANLIKU	2996
11	OBURU	3003
11	MBUBE-OGOJA	1023
11	Ikot Ansa	2985
11	UGEP	1035
11	YALA	2328
11	Abakpa	2954
11	ESUK MBA	1013
11	Ukwel	3016
11	Ikot Omin	2986
11	IKOM	2265
11	Local Govt. Councl	2988
11	Calabar Rd	2968
11	BIASE	1008
11	OBUDU RANCH	3001
11	BOJE	1009
11	BOKI	1010
11	IKANG	1016
11	ITIGIDI	1018
11	IKOT ENE AKPABUYO	1017
11	OBANLIKU LGA	2997
11	ABI	1004
11	ODUKPANI	1032
11	OKPOMA	2309
11	OBANLIKU L.G.A	1028
11	ETUNG LGA	1014
11	Ikorinim	2984
11	IGOLI-OGOJA	2982
11	ESIGHI	1012
11	AKWA IKOT EFFANGA	1006
11	Goldie	2980
11	Essien Town	2977
11	Uwanse	3017
11	MKPANI UGEP	2991
11	OBUDU	2999
11	WULA	3018
11	MFAMOSING	1024
11	AKPET	2957
11	OBUDU L.G.A	1030
11	Dan Archibon	2971
11	BESENI	2961
11	EKORI UGEP	2975
11	OBUDU RANGE	1031
11	Post Office Forestry	3007
11	YUSUFARI	3020
11	Bisiri	2963
11	KWA FALLS	2987
12	AJI	1686
12	IBAGWA-AKA	1692
12	OKPO	2307
12	ICHI	1694
12	LEJJA	1700
12	IHEAKPU AWKA	1697
12	OPI	1708
12	IHE ALUMONA	1695
12	ISI UZO	4467
12	OKPANDA	1705
12	OBUKPA	1703
12	NSUKKA	4468
12	IKEM	2263
12	OKPUJE	1706
12	EDEM -ANI	1689
12	UZO-UWANI	1715
12	EHA AMUFU	2249
12	OBOLLO-AFOR	1702
12	IBAGWA-ANI	1693
12	OGBEDE	1704
12	IHEAKA	1696
12	UNADU	1714
12	ORBA	1709
12	OVOKO	1710
12	MILIKE	1701
12	ENUGU- EZIKE	1691
12	UMUIDA	1712
12	DIOBE	1688
12	ADANI	1685
12	AKU	1687
12	EKWEGBWE	1690
12	UKEHE	1711
12	UMUITODO	1713
12	INYI ENUGU EZIKE	1698
12	ISI-UZO	1699
12	OKUTU	1707
13	AKPAKWUME	1084
13	AKWUKE	151
13	ALULU- NIKE	1086
13	AMAGUNZE	1088
13	AMMUGWU	3100
13	AKWNANAW	3091
13	AGBOGWUGWU	1081
13	CHINA TOWN	3104
13	AKPOGA NIKE	1085
13	AMOKPO NIKE	153
13	UGWUAJI	1121
13	MPU	3124
13	NKANU -EAST	162
13	GABON VILLAGE	3112
13	ABAKPA	3082
13	AGBANI  ROAD	3086
13	AMAOJI AGU NIKE	3094
13	COLLERY SNR. STAFF QUATERS	3105
13	UZO NWANI LGA	3157
13	ISHIAGU	1101
13	NENWE	160
13	AFFA	149
13	NACHA	3125
13	OJIAGU	1116
13	NKEREFI	1108
13	OBINAGU	3142
13	NINTH MILE(9TH MILE)	1106
13	OBE	1111
13	ODUMA	1112
13	NGURORE	3128
13	OGBOLI	3144
13	AGBANI  TOWN	3087
13	AMAKWU	1090
13	NIKE	3130
13	IMILIKI	3117
13	AMA GUNZE	3092
13	AWGU	1094
13	NKANU	3134
13	IKEM	564
13	NKALAGU	161
13	NKANU	3132
13	NKPOLOGWU-ENU	1109
13	MEROGUN WATERSI	3123
13	AKPUGO[NKANU]	3090
13	MBURUMBU	157
13	NKANU	3133
13	UDI ABIA	1118
13	ABOR	3084
13	UDI	164
13	NARA UNATEZE	1104
13	OGBETE LAYOUT	3143
13	UWAM	3156
13	IJI NIKE	1099
13	ITUKU	3121
13	ARMY BARRACKS	3103
13	EMENE	3108
13	AMIKE	3097
13	AMARA	3095
13	REPUBLIC LAYOUT	3147
13	ETTEH	3111
13	ENUGU CENTRAL	3110
13	AMECHI AWKNANAW	3096
13	ATTAKWU	1093
13	AMMACHALLA	3099
13	OJI RIVER	1115
13	UMMULUMGBE	3151
13	OPANDA	3145
13	UGWU OBA	1120
13	ANIOCHA	3102
13	AMAKOFIA	1089
13	AMUGWU	154
13	EKE OBINAGU	3106
13	AWHUM	1095
13	EKEREMUO	3107
13	IGBOEZE SOUTH	3114
13	OBINAGU(EZEAGU LGA)	163
13	AMECHI AWKANANAW	152
13	AMORJI-NIKE	1091
13	NSUDE    (NBL SALES OFFICE)	1110
13	AKPOF	3089
13	IGBOEZE SOUTH NORTH	3115
13	ANINRI	1092
13	MMAKU	159
13	ACHI	148
13	UDAH	3148
13	ITICHI	3120
13	INYI	1100
13	UMULUMGBE	1123
13	NEW HEAVEN	3127
13	UMUEZE EJEH	3152
13	NGWO	3129
13	NNSUDE    (NBL SALES OFFICE)	3140
13	NSUKKA	3141
13	IKPAMODO	3116
13	ABAKPA NIKE	3083
13	IHE	156
13	NNADO	3138
13	AMUFIE	3101
13	AMAECHI IDODO	1087
13	UGBO ODOGWU	3149
13	UMULOKPA	3153
13	OZALA	1117
13	UNN	3155
13	OZALLA	3146
13	UGWAWKA	3150
13	IBAGWA-NIKE	1098
13	NJODO NIKE	1107
13	OGHE	1114
13	9TH MILE CORNER	3080
13	AKAGBE-UGWU	1083
13	NNI	3139
13	INDEPENDENCE LAYOUT	3118
13	NINTH MILE	3131
13	ENUGU	3109
13	IDAW RIVER LAYOUT	3113
13	UMUNACHI- NIKE	1124
13	UGWOGO NIKE	1119
13	UGBAWKA	165
13	NACHI	1103
13	ABAKALIKI	3081
13	NKANU EAST	3135
13	NDIABOR	1105
13	OGBOLI- AWGU	1113
13	UMUABI	1122
13	MGBOWO	158
13	AGU-ABORHILL	1082
13	EKE	1097
13	AKOKWA-IDEATO	3088
13	NKPANI	3136
13	EGEDE	1096
13	UMUNACHI NIKE	3154
13	ISI UZO  LGA	3119
13	MBU	3122
13	NKPOKITI	3137
13	ADANI	3085
13	IVO (LGA)	1102
13	AKPUGO (NKANU)	150
13	AMMA GUNZE	3098
13	EHA AMUFU	556
13	EZEAGU	155
13	NEW HAVEN	3126
13	AMACHALLA	3093
14	OFFA	4469
15	ODO ERI	1270
15	KULENDE	3442
15	AL HIKMAH UNIVERSITY	3410
15	SONGA	3457
15	ESIE	1245
15	ILESA IBARUBA	3428
15	TAIWO	3459
15	EJINE	1243
15	ODOERE	1271
15	OKELELE	3451
15	OSI	2317
15	IPEE	3434
15	BODE SA'ADU	3413
15	KORO	1260
15	BODE SAADU	1239
15	SWACHI	1281
15	MAGAMA	3444
15	EJIBA	1242
15	ERUKU	1244
15	NIGER	3446
15	OBBO AYIEGUNLE	3448
15	PADA	1278
15	AIYETORO	3409
15	MOKWA	1265
15	OBBO ILE	1269
15	UITH	226
15	APATA YAKUBA	1236
15	EFFON AMURO	3417
15	UNILORIN MAIN CAMPUS	3460
15	KOSUBOSU	1261
15	ERINLE	219
15	ABDUL AZEEZ	3407
15	AJASEPO	218
15	OMUPO	3454
15	KOSUBOSUN	3441
15	STADIUM RD. GBALASA	3458
15	OFFA	1272
15	BABOKO	3412
15	PAKATA	3455
15	JEBBA DAM	3438
15	OBBO AIYEGUNLE	1268
15	OKO	2304
15	OLD YIDI	3452
15	OKUTA	1276
15	G.R.A	3421
15	IGBAJA	1252
15	OLOJE	3453
15	NEW BUSSA	1267
15	BALLAH	1238
15	EMIR'S PALACE	3418
15	NNPC PPMC	3447
15	LUBCON DEPOT	1264
15	CHIKANDA	3414
15	MURITALA ROAD	3445
15	EFO AMURO	1240
15	TSONGA	1282
15	NNPC DEPOT	2290
15	BABALOMA	3411
15	GBUGBU	1249
15	ILESHA BARUBA	1253
15	BACITA	1237
15	SABON LINE AMILEGBE	3456
15	PATEGI	1279
15	EYENKORIN	1246
15	GURE	1250
15	ADEWOLE ESTATE	3408
15	GBARARA	1247
15	GBASORO	1248
15	IDOFIAN	3424
15	OMU ARAN	1277
15	SHARE	225
15	ISANLU	3435
15	KAINJI	3439
15	OTTE	223
15	MAFA	3443
15	MOPA	1266
15	OKE OYI	221
15	OKEPAGE	1275
15	ISTANBUL	1256
15	KAINJI/NEW BUSSA	1259
15	EDIDI	3415
15	EDN	3416
15	LAFIAGI	1263
15	OKE ONIGBIN	1274
15	AFON	217
15	IDFIAN	3423
15	IDOFIAN (NNAFUFE & ARMTI)	1251
15	IGOSUN	3426
15	JANTU	3436
15	OKE ODE	1273
15	IJAGBO	3427
15	EGBE	1241
15	ESSIE	3420
15	SUNTI SUGAR COMPANY	1280
15	MALETE	220
15	SHAO	224
15	IDOFIAN (NCAN & ARMTI)	3425
15	GAMBARI	2252
15	KAIAMA	1258
15	GAA AKANBI	3422
15	YIKPATA	1284
15	ILOFA/ODO OWA	1254
15	KWARAPOLY	1262
15	JATTU	3437
15	ILORIN	3430
15	OGBOJI	3449
15	ERIN ILE	3419
15	OKE IGOSUN	3450
15	ISAPA	1255
15	JEBBA	1257
15	ORO	222
15	YASIKIRA	1283
16	GUMEL	1065
16	TAKUR QUATERS	3074
16	MAKWALLA	3067
16	DABANTU	3054
16	GURI	1066
16	GAZULMARI	3059
16	BIRNIWA	1060
16	JAHUN	140
16	KACHAKO	3062
16	DUTSE	1062
16	NEW G.R.A	3068
16	KOFAR GABAS	3065
16	POLICE HEADQUARTERS	3070
16	SULETANKARKAR	1078
16	GWARAM	2259
16	GWIWA	1067
16	MALAM MADORI	1074
16	BIRNIN KUDU	139
16	CENTRAL MARKET	3053
16	RINGIM	1076
16	GARKO	3058
16	AUYO	1059
16	KIRI-KASSAMMA	1071
16	BABURA	2241
16	MAJEMA	3066
16	GARKI	1064
16	KAFIN HAUSA	1069
16	RONI	1077
16	RINGIM TOWN	3071
16	KIRIKASAMA	3064
16	FAGOJI	3055
16	KALGO VILLAGE	3063
16	G.R.A	3056
16	INTERNET AREA	3061
16	MAIGATARI	1073
16	HADEJIA	1068
16	SABON GARIN ZAI	3072
16	BUJI	1061
16	GALDIMAWA	3057
16	GAGARAWA	1063
16	TAURA	1079
16	KAUGAMA	1070
16	POLICE BARRACKS	3069
16	YANKWASHI	1080
16	SABUWAR MARINJUWA	3073
16	 ANDAZA	3052
16	GOVERNMENT HOUSE	3060
16	MIGA	1075
16	KIYAWA	1072
17	OBAS PALACE	2724
17	OKE RUWA	2731
17	IJARE IRESE RD	2706
17	OGOTUN	2729
17	ORIN EKITI	2738
17	OGBUERURU-ORLU	2728
17	USI EKITI	2749
17	ODE AYE	812
17	AKURE	2687
17	OKE IGBO	820
17	OGBAGI AKOKO	817
17	IJU ODO	803
17	KAJOLA	2275
17	EDE GEDE AKOKO	2690
17	HIGH COURT	2697
17	IFAKI EKITI	2699
17	OYE EKITI	2742
17	AIYEDUN EKITI	2686
17	AROMOKO EKITI	2689
17	IGEDE EKITI	2702
17	ORE	825
17	IGBEKEBO	800
17	OGBAGI	2727
17	IJAN  EKITI	2703
17	OKITIPUPA	821
17	OWENA	89
17	ARIGIDI AKOKO	792
17	IGBOTAKO	802
17	OMIPARAGA	2736
17	ARAROMI OBU	790
17	OLUKARE'S PALACE	2735
17	ADO FURE	783
17	OYINMO	2744
17	ISE  AKOKO	2716
17	OFOSU	816
17	AKUNGBA AKOKO	788
17	IGBDE	2701
17	IDOGUN	798
17	OSINLE SIJUADE ESTATE	2739
17	IJU	86
17	IRUN	2715
17	SOBE	2748
17	NIPOST HEADQUARTERS	2722
17	IKARE AKOKO	805
17	SCHOOL OF AGRIC	2746
17	IBARAM	795
17	IKARAM	804
17	ILARA -MOKIN	2710
17	OWO	826
17	MAKINDE	2721
17	ILARA MOKIN	87
17	OKORUN	2734
17	ALAGBAKA	2688
17	OKEGBE	2733
17	ERUSU AKOKO	794
17	ILE OLUJI	806
17	FANINI ESTATE	2695
17	OBA ILE	2723
17	RAMOKO EKITI 	2745
17	IGBARA OKE	84
17	EPIMMI	2693
17	IFO OWO	2700
17	IKU	2709
17	IWOROKO 	2718
17	IPE	2714
17	OKA AKOKO	818
17	IDANRE	83
17	ODE IRELE	814
17	IGBOKODA	801
17	ILUTITUN	807
17	ONDO TOWN	2737
17	OKE ARO DANJUMA	2730
17	IPELE	809
17	IDO ANI	2698
17	IPE AKOKO	808
17	ISE  EKITI	2717
17	OYEMEKUN	2743
17	OKE AGBE	819
17	AJOWA AKOKO	786
17	IJARE	85
17	ARAROMI WATERSIDE	791
17	SUPARE AKOKO	827
17	AKOTOGBO	787
17	IFON	799
17	ILORO EKITI	2712
17	EDEGEDE AKOKO	2691
17	ITAOGBOLU	88
17	OMOTOSO	822
17	ISUA AKOKO	811
17	ADO AWAYE	2685
17	OWODE	2741
17	IJAPO ESTATE	2704
17	APONMU	789
17	ODIGBO	815
17	IJOMU	2708
17	AGADAGBA	784
17	EKAN OYINMO	2692
17	AJEBANDELE	785
17	IBULE	796
17	ODO OWA	2726
17	ILUPEJU EKITI	2713
17	BOLORUNDURO	793
17	ILODUN EKITI	2711
17	ODE EKITAN	813
17	OGBESE	2296
17	OTUTU EKITI	2740
17	IDOANI	797
17	IYAHE	2719
17	LISAGBEDE	2720
17	SHAGARI VILLAGE	2747
17	OKEARO	2732
17	ERUZU AKOKO	2694
17	ODEYARE OKOJA	2725
17	IRUN AKOKO	810
17	ONDO	823
17	ONIPARAGA	824
17	GBADARE ONDO BYE PASS	2696
18	UWALOR	2889
18	ABUDU	915
18	FUGAR	933
18	Ukpaja Quarters	2886
18	OGBESE	2297
18	AFUZE	916
18	WARAKE	972
18	OWA AGBOR	2880
18	OKUMODU	2875
18	Oyomon Quarters	2881
18	ABAVO	914
18	OBAYANTOR	948
18	Ikpoba	2865
18	OPOJI	959
18	APANA	922
18	UBIAJA	964
18	AGBEDE	917
18	EWATTO	2855
18	OGUA	952
18	OSSE	960
18	AKARA	2845
18	Evbotube	2854
18	OBAGIE	946
18	IGARRA	2862
18	IYAMHO	943
18	ISIOHOR	2866
18	Ekosodin Village	2852
18	OBARETIN	947
18	IBILLO	935
18	GELEGELE	934
18	EKIADOLOR	928
18	OKOMU	954
18	ANEGBETE	921
18	Uhumwuimwu	2885
18	Ekenhaun	2851
18	UTESI	971
18	Ewemade Village	2856
18	AUCHI	923
18	OKPEKPE	955
18	EWURU	2857
18	SABONGIDA- ORA	963
18	UROMI	969
18	IHOVBOR	940
18	IRUEKPEN	942
18	WEPA WANO	2892
18	AJAGBODUDU	920
18	EYAEN	932
18	UGBEGUN	966
18	EWOHIMI	930
18	OSSOSO	961
18	USELU	2887
18	Ebhuru Quarters II	2849
18	IVBIARO	2867
18	Egbemije	2850
18	Iwogban	2868
18	KOKO	2279
18	Oregbeni	2877
18	EWU	931
18	OGHADA	951
18	Ebhuru Quarters I	2848
18	OGAN	950
18	UVBE	2888
18	IGUOBAZUWA	939
18	Old Ilushi	2876
18	AKARAN	2846
18	OKPELLA	956
18	URHONIGBE	968
18	Uwelu	2890
18	USEN	970
18	OBEHIE	2870
18	OTUO	2879
18	AHOADA	2844
18	OWA-OYIBO	962
18	WARREKE	2891
18	OLUKU	958
18	AGENEBODE	919
18	OBEN	949
18	IYANOMO	944
18	EWURU  ESTATE AGBO	2858
18	AGBOR	918
18	IGIEDUMA	937
18	OKADA	953
18	UDO	965
18	IGIEBEN	2863
18	OGBA ZOO / OBA AKENZUA II	2871
18	G.R.A	2859
18	EKEWAN BARRACKS	927
18	Ohovbeokao	2874
18	IGBANKE	936
18	OSSEE	2878
18	Etete	2853
18	OLOGBO	957
18	UGO	967
18	IRRUA	941
18	IDOGBO	2861
18	NGUZU EDDA	2869
18	OGHEDE	2873
18	NIFOR	945
18	BENIN	2847
18	AGO  AMODU	2843
18	EKPOMA	929
18	OGWA	2301
18	Ugbowo	2884
18	Ugbekun	2883
18	EHOR	926
18	EBELLE	924
18	EGBA	925
18	Ogbelaka	2872
18	SOBE	2882
18	IGUEBEN	938
18	Ihogben	2864
19	IBEREKODO/AKOMOJE	2416
19	OBA-ERIN	655
19	AYETORO-EGBADO	51
19	MAKINDE	2444
19	IMALA	649
19	ADO-ODD	2401
19	ONIGBEDU	63
19	IBULE	2417
19	IGAN OKOTO	2421
19	IWOYE-KETU	652
19	ONIKOLOBO/GRA EXTENSION	2460
19	QUARRY	2465
19	IJEBU-MUSHIN	2425
19	ABEOKUTA	2397
19	TOTORO/OWU/IJEJA/ITORY	2467
19	IBAGWE	2412
19	SHAGAMU	2466
19	IJEBU-IGBO	2424
19	IASBO	2411
19	OLUWO	2459
19	IKOPA/IAWO-ONIGUNU-DOGO	2431
19	ILARA (YEWA)	2432
19	ILARO	592
19	OBAFE	656
19	OLODO KILA	2456
19	OCHECHE UMUODU	2451
19	AJEROMI	2406
19	OSIELE	2462
19	ODEDA	60
19	NEW NYANYA	2446
19	IJEBU-OGBERE	2427
19	IFO IBOGUN	2419
19	KOBAPE	653
19	OLORUNSOGO	2458
19	OKE OKO	2454
19	ADATAN	2398
19	IRO	651
19	OWIWI	659
19	KUGBO	2442
19	GRA	2410
19	IBORO	54
19	IGAN-ALADE	646
19	MODAKEKE	2445
19	OGUNMAKIN	2300
19	ILARA(YEWA)	648
19	ITOKO	2440
19	ARO	2407
19	OWODE-EGBA	65
19	OWODE	2463
19	JEMO	2441
19	ILEWO-ORILE	56
19	IMASHAI	57
19	IGBOGILA	562
19	AJEBO	645
19	MOWE	2287
19	OKE ILEWO	2453
19	IJEBU-ODE	2426
19	ASU	50
19	EWEKORO	557
19	AGBOMEJI	2402
19	IBARA	2413
19	ISAGA-ORILE	58
19	OWODE EGBA	2464
19	ADEBA	2399
19	OBA-ERIN(OBA)	2447
19	IGAN-OKOTO	647
19	IJEBU-EAST	2422
19	ISALE IGBEIN	2438
19	IJOGA-ORILE	55
19	ISHAGA ORILE	2439
19	LAFENWA	2443
19	IGAN ALADE	2420
19	OBAFEMI OWODE	2448
19	ORILE- ILUGUN	64
19	OLOMORE	2457
19	AIYETORO GBEDE	2405
19	OBANTOKO	2449
19	AWODE EGBA	2408
19	AYETORO EGBADO	2409
19	OKE-MOSAN	2455
19	ORILE-ILUGUN	2461
19	IDIABA	2418
19	MAWUKO	654
19	OBOSI	2450
19	AJURA	591
19	OLORUNSOGO(POWER PLANT)	657
19	OJOKODO/IDO AWE	2452
19	ONIHALE	658
19	IBESE	53
19	OLODO-KILA	61
19	IJEBU-ORU	2428
19	IBARA/GRA	2415
19	AGODI	2404
19	PAPALANTO	66
19	ADO ODO/OTA	2400
19	ITORI	2271
19	OWODE-IDIEMI	660
19	IBARA-ORILE	52
19	IMEKO	650
19	OLORUNDA	62
19	AGO OKO	2403
19	IJEBU-IFE	2423
19	OBAFEMI- OWODE	59
19	IJOGA ORILE	2429
19	IBARA ORILE	2414
20	IKENNE-REMO	2065
20	AKAKA-REMO	477
20	IJOKUN	4970
20	SOTUBO	489
20	LIKOSI-REMO	484
20	IPERU	2066
20	IJEBU-AIYEPE	4969
20	SOTUPO	4978
20	SIMAWA	4977
20	LIKOSI	4971
20	SABO	4975
20	ISHARA-REMO	483
20	ILARA-REMO	479
20	IPARA-REMO	481
20	OGERE REMO	4974
20	SAPADE	488
20	FLOWERGATE EXPRESSWAY	478
20	WAPCO	2067
20	AIYEPE-REMO	476
20	ILISHAN-REMO	480
20	ODE-REMO	486
20	ODEDA	4972
20	ODOGBOLU	487
20	IROLU-REMO	482
20	ODE-LEMO	485
20	OGBERE REMO	4973
20	SAGAMU	4976
21	ODOLEWU	3391
21	IMODIMOSAN	3376
21	MOLIPA	3389
21	IJEBU IFE	205
21	IJEBU ITELE	208
21	IWESI VILLAGE	3384
21	OGBERE	3393
21	IJEBU  IFE	3358
21	OKE- OWA AREA	3396
21	IJAGUN	1218
21	IJEBU-ALA	3362
21	IWADE AREA	3383
21	OSIMORE	3402
21	IDOMILA	3355
21	IBEFUN	3353
21	IJEBU-EAST	3363
21	IJEBU ODE	3360
21	OGERE REMO	3395
21	OKUN-OWA\t	3398
21	MOBALUFON	3388
21	IJEBU-ODE	3370
21	IMAGBON	211
21	IJEBU WATER SIDE	1220
21	ISASA POROGUN AREA	3379
21	ITELE	3382
21	AGO IWOYE	1217
21	ONIRUGBA AREA	3400
21	ORUU	3401
21	ATAN-IJEBU	3352
21	IJEBU IGBO	206
21	ISHONYI-IJEBU	3380
21	ODO-EPO	3390
21	OGBA/IMAWEJE	3392
21	ABIGI	1216
21	IMAWEJE	3374
21	J4/J5	3386
21	IJEBU-WATERSIDE	3372
21	ILESE	3373
21	IMODI-IJASI	3375
21	IDOWA	203
21	IJEBU-IMUSHIN	3366
21	IBIDO	3354
21	IKANGBA	1221
21	IJEBU-IGBO	3365
21	IJEBU-ITELE	3367
21	IJARI/OGBOGBO AREA	3357
21	IJEBU WATERSIDE	3361
21	IJEBU ALA	204
21	IWOPIN/WATERSIDE	3385
21	IJEBU-JESA	3368
21	ISONYIN-IJEBU	3381
21	IREWON	3378
21	IJEBU IMUSHIN	207
21	IJEBU OGBERE	209
21	AGORO	3351
21	OGERE	3394
21	OKUN-OWA	3397
21	OSOSA	3403
21	LATOGUN	3387
21	IDOMOWA	3356
21	OMU-IJEBU  	3399
21	IJEBU ORU	210
21	IJEBU EAST	1219
21	IJEBU MUSHIN	3359
21	IJEBU-MUSHIN	3369
21	IJEBU-ORU	3371
21	OWU-IKEJA	3404
21	IJEBU-IFE	3364
21	IMORU	3377
21	SABO	3405
22	AJILETE	4803
22	ILOJE	4819
22	KETERE	4825
22	IGBESA	4814
22	OBASANJO FARM	4828
22	IFO IBOGUN\t	4812
22	PILO	4840
22	AKILO QUARTERS	4804
22	OWODE-IDIROKO	4839
22	JOJU	4824
22	ADALEMO	4799
22	ARAROMI	4805
22	ABEBI/OKESUNA	4798
22	OLOTA PALACE/OTUN	4833
22	IJOKO OTA	4818
22	MEFUN RD / BABY O	4826
22	IJAMIDO	4816
22	ORUBA QTRS	4834
22	IPOKIA	4821
22	ATAN/OTA	4806
22	ITELE (AYETORO)	4822
22	OTA-IDIROKO RD/TOMORI	4835
22	OTTA	4836
22	TEMIDIRE	4844
22	OWODE ITORI	4838
22	IPAMESAN	4820
22	JIBOWU	4823
22	ADO-ODO OTA	4801
22	AFOBAJE ESTATE/AGBALA OBANIBAS	4802
22	IGBOGILA	4815
22	OKE ODAN ROAD 	4831
22	OLD IYANRU/IJANAGANG	4832
22	SANGO OTA	4841
22	TAMARK ENG /G.W HOTEL/OTA WATE	4843
22	SANGO OTTA	4842
22	ADO OTA/OTA	4800
22	IDI IROKO	4808
22	NEW IYANRU	4827
22	IFO\t\t	4813
22	IDI ROKO\t	4809
22	OBASANJO FARM	4829
22	OWODE IBESE	4837
22	IJANA QTRS/OKE OYINBO/MEFUN	4817
22	OJABI QUARTERS	4830
22	ERINKO	4807
22	IDIROKO RD / OJUORE	4810
23	WARJI	2840
23	SORO	906
23	KANGERE	893
23	KARI	894
23	TSANGAYA	130
23	YELWA	2842
23	DOGON JEJI	881
23	LIMAN KATAGUM	128
23	NAKA	2833
23	ZAKI	913
23	JAMA?ARE	2824
23	Abubakar Tafawa Balewa Univers	2812
23	ATBU PERMANENT SITE	869
23	DASS	879
23	UDOBO	909
23	SHIRA/YANA	2836
23	GWARAM	2258
23	KALAJANGA	2825
23	BULKACHUWA	873
23	LANZAI	2831
23	GOBIYA	888
23	BOTO	872
23	GAMAWA	885
23	Lushi	2832
23	NINGI	2834
23	TAPHIN	2838
23	DAMBAM	877
23	TAFAWA BALEWA	129
23	KIRFI	895
23	TURUM	908
23	ALKALERI	127
23	HANAFAFARI	2822
23	MAGARYA	896
23	Army Barracks	2814
23	BAYARA	2817
23	WAILO	910
23	GOLOLO	889
23	DISINA	880
23	TAPSHIN	907
23	BURSALI	876
23	G.R.A	2820
23	AZARE	870
23	NASARU	902
23	BUNUNU	874
23	Railway Station	2835
23	Y/DUGURI	2841
23	MISAU	898
23	Bacas	2815
23	DURUM	883
23	SHIRA	905
23	Abubakar Umar State Secretaria	2813
23	HAS	2823
23	DARAZO	878
23	ITAS-GADAU	891
23	KANGARE	2826
23	RISHI	903
23	GIADE	887
23	MURMUR	900
23	BAUCHI	2816
23	Kofar Wambai	2829
23	Tambarari Village	2837
23	GANJUWA	886
23	LERE	2281
23	TSANGWA	2839
23	MAKAWA	897
23	YANKARI	911
23	SAKWA	904
23	NABORDO	901
23	Gumi Hill	2821
23	Kofar Jahun	2828
23	JAMA’ARE	892
23	ZABI	131
23	BOGORO	871
23	FAGGO	884
23	MIYA	899
23	HANAFARI	890
23	DANGADA	2819
23	BUESALI	2818
23	YELWAN DUGURI	912
23	BURA	875
23	DUGURI	882
23	KATAGUM	2827
23	Kofar Wasa	2830
24	ILA ORAGUN	4719
24	IRAGBIJI	1819
24	ILOBU	459
24	ORANMIYAN SHRINE	4780
24	ISIDA	4738
24	IPAPO	4730
24	IRAGBERI	1818
24	ODIOLOWO	4750
24	KOLA BALOGUN	4743
24	OGOOLUWA	4759
24	ABA COKER	4673
24	ESA-OKE	4699
24	GBONGAN	2255
24	OKEYIDI	4775
24	EDE	1807
24	BOSA STR	4688
24	GENERAL HOSPITAL	4703
24	EGBEIDE	4692
24	SUSU	4796
24	ABIOLA AVE	4674
24	ERIN ILE	4695
24	ASOKO QUARTERS	4683
24	OKE OPO	4769
24	ISALE APATA	4736
24	IWOPIN	1823
24	OYAN	1826
24	IREE	1820
24	OKE OLA	4765
24	OSU	4785
24	MORE	4746
24	IDI SEKE	4708
24	IJOKA	4715
24	ILARE	4720
24	ONPETU PALACE	4778
24	FEDERA TECHNICAL COLLEGE	4702
24	OKE BAALE	462
24	IREPODUN	4734
24	OKE IRO	4764
24	OWODE	585
24	OGBADORE	4757
24	OKE OPE QUARTERS	4768
24	AIYETORO	4677
24	ODO AFIN	4751
24	ISALE OLA QUARTERS	4737
24	IRAYE STR	4731
24	IDOMINASI	4710
24	OKE ESE	4761
24	IBOKUN	4705
24	IDO-OSUN	4711
24	ILESHA	4724
24	IRE AKARI	4732
24	PALACE	4792
24	IJABE	1813
24	OWENA IJESA	4788
24	IREMO	4733
24	ERIN OKE	4696
24	OWENA IJESA	4789
24	OKE ONITI	4766
24	OKUKU	2314
24	OLD AKURE RD	4776
24	ODE OMU	461
24	ODOGO	4754
24	ILERIN QUARTERS	4721
24	RING RD	4793
24	OROMU QUARTERS	4782
24	ADE OWO	4676
24	AIYETORO ORUNGUN	4678
24	AYESO	4685
24	IGBON ILORO	4712
24	IWOYE	4742
24	ALEKUWODO	4681
24	IJEBU IJESHA	4713
24	OTA EFUN	4786
24	ALAPATA	4680
24	IKIRE	4717
24	ERIN IJESA	4694
24	IWARA	4740
24	OSHOGBO	4784
24	OMO WEST	4777
24	OYO STATE GRA	4791
24	FAGBEWESA	4701
24	IKIRUN	1814
24	LEVENTIS AGRIC FARM	4745
24	AKARABATA	4679
24	CARETAKER/OKE ALAPATA	4689
24	IKEJI ARAKEJI	4716
24	IWO	1822
24	OKEIYIN	4772
24	ADA	4675
24	ESUYARE QUARTERS	4700
24	OTAN AYEGBANJU	4787
24	IDIORO/THE APOSTOLIC GRAMMAR S	4709
24	BODE OSI	4687
24	IMESI ILE	4728
24	IGBAJO	1812
24	ARAROMI OKESA	4682
24	IROJO QUARTERS	4735
24	OREMERIN	4781
24	IFON OSUN	1811
24	ILE OGBO	1816
24	IMO QUARTERS	4729
24	OKEFIA	4771
24	OKE OTUBU QUARTERS	4770
24	IDO OSUN	1810
24	OTAN AYEGBAJU	1825
24	ILA ORANGUN	1815
24	OWENA IJESA	4790
24	ODUNDUN	4755
24	IBA	1809
24	BODE	4686
24	ESA OKE	4698
24	ILESA	4722
24	KUTA ILEGBO	4744
24	ILODE	4726
24	OBOKUN HIGH SCHOOL	4748
24	OKE ILA	1824
24	IRESI	1821
24	ODE AGBALA/ISALE AFFON	4749
24	STADIUM	4795
24	IJEDA	4714
24	OAU	4747
24	OPA	4779
24	OKEREWE	4774
24	ILESA LOCAL GOVERNMENT	4723
24	SOOKO	4794
24	EDE DIMEJI	4691
24	AYANSHOLA	4684
24	IDASA	4707
24	ERIN OSUN	4697
24	OKE D.O RD	4760
24	TEMIDIRE	4797
24	ODO ESE	4752
24	OKE INISA	4763
24	OGBON OGBEJE	4758
24	OKEOLA	4773
24	OGBADARE	4756
24	ILOKO IJESHA	4727
24	OKE OOYE	4767
24	INISHA	1817
24	OSADEP ZONAL OFFICE	4783
24	DADA ESTATE	4690
24	EJIGBO	1808
24	GOVERNMENT QUARTERS	4704
24	IWARAJA	4741
24	OKE ESO IGBAYE	4762
24	ITA OLOKAN	4739
24	ELEYELE	4693
24	OBAAGUN	460
24	ODO OJA	4753
25	OLODE	200
25	IYAN - FOWOROGI	1211
25	EDUNABAN	3334
25	IKIRE	566
25	IYAN-FOWOROGI	3345
25	IJEDA	3340
25	IYAN-FOWOROGI	3343
25	IPETUMODU	1209
25	ITA-ELEWA	1210
25	IKOYI	3341
25	GBONGAN	2254
25	IFEWARA	3337
25	MORO	1212
25	ODEOMU	199
25	WAASINMI	1214
25	ONIKOKO	202
25	PARAKIN	3350
25	LAGERE	3346
25	AKINLALU	1207
25	ILESA	3342
25	OMIFUNFUN	201
25	IJEBU IJESHA	3339
25	OKUU	3349
25	OKUU-OMONI	1213
25	COKER	197
25	AKIRIBOTU	3333
25	IFETEDO	1208
25	IFEWARA	3338
25	IYAN-FOWOROGI	3344
25	ODE OMU	3348
25	IFEWARE	198
25	YAKOOYO	1215
25	IBOKUN	3335
25	IFE	3336
25	ABA IYA-GANI	3332
25	ABA IYA GANI	1206
25	MODAKEKE	3347
26	MAYFAIR GARDEN	1324
26	FREE TRADE ZONE	234
26	SHAPATI	1338
26	AJAH	3468
26	DANGOTE REFINERY	3481
26	BADORE	3474
26	MAGBON	3509
26	LAKOWE	1318
26	EPE TOWN	1304
26	LA CA PAIGNE	1315
26	ADEBA TOWN	1289
26	LISA TOWN	1320
26	IBEJU AGBE	1309
26	AUGUSTINE UNIVERSITY	1295
26	LAFIAJI	3505
26	BROAD STREET	3477
26	AGARAWU	3467
26	DANGOTE EFINERY	231
26	EREPOTO	1307
26	OKEIRANLA	3518
26	IMOBIDO	236
26	LAGBADE	1317
26	ODORAGUSHI	1328
26	321	3463
26	LEKKI	3507
26	AWOYAYA	1296
26	SANGOTEDO	3525
26	ATLANTIC HALL	3472
26	APONGBO	3471
26	AGARAWU	3466
26	NAFORIJA	3514
26	APAKIN	230
26	MINNA	3512
26	TARKWA BAY	3530
26	322	3464
26	OGUNFAYO TOWN	1329
26	ODO SHIWOLA	1326
26	AKODO	227
26	IGBOOYE	3497
26	ONISHON	1331
26	ONIKAN	3521
26	ISALE EKO	3500
26	ITAMARUN	3502
26	FOLU	1308
26	TEMU VILAGE	3532
26	EPE	3488
26	ILAMIJA	1311
26	ITOKE	237
26	LADOL JETTY	3504
26	TARQUA BAY	3531
26	BOLORUNPELU TOWN	1299
26	CHEVRON	3479
26	OLOWOGBOWO	3520
26	ELESE KAN	1303
26	ABULE PANU	1288
26	CROWN ESTATE	3480
26	SANGO TEDO	3524
26	MAGBON ALADE	239
26	OFFIN	3516
26	MARINA	3510
26	VICTORIA ISLAND	3535
26	IBOWON	3493
26	VICTORIA GARDEN	3534
26	KAIYETORO	1314
26	ATLATIC HALL	1294
26	ISE	2270
26	SOIL CONSERVATION SPG	3527
26	POKA	1336
26	ITAFAJI	3501
26	SPG	3528
26	ORIMEDU	243
26	LADOL  JETTY	1316
26	TAQWA  BAY	3529
26	SOLU ADE	245
26	ONIRU	3522
26	AMEN ESTATE	229
26	ORUNMIJA	244
26	NOFORIJA	1325
26	IDUMAGBO	3494
26	ILARA	1312
26	ELEKO	233
26	LISA VILLAGE	3508
26	KAJOLA	2276
26	ELERANGBE	1302
26	OTUNLA	1335
26	TAKWA  BAY	1339
26	IGANDO OLOJA	3496
26	IKOYI	3498
26	ELETU	3487
26	ODOMOLA	1327
26	ATLAS  COVE	1293
26	SAGOPTEDO	1337
26	MALETE ALAFIA	1323
26	BROAD STREET	3478
26	EJIRIN	3485
26	MOKOPED	3513
26	MASSY	3511
26	OBALENDE	3515
26	EPUTU TOWN	1305
26	MUSEYO	241
26	ALASIA	3470
26	GBOSERE	3490
26	LEKKI TOWN	238
26	OSOROKO	1334
26	LAKOWE GOLF	1319
26	UNIAGRIC	3533
26	BOGIJE	1298
26	ABULE ADE	1286
26	ALATISHE	1292
26	IBEJU	3492
26	DOLPHIN ESTATE	3483
26	DOSUNMU	3484
26	ABULE FOLLY	1287
26	SERVTRUST	3526
26	DANGOTE REFINERY	3482
26	MAJODA	1322
26	EKO AKETE CITY	1300
26	MAGBON SEGUN	240
26	DEBOJO TOWN	232
26	LAGOS ISLAND	3506
26	HFC	3491
26	ONOSA	1332
26	EREDO	1306
26	OKE ARIN	3517
26	OKEGUN	1330
26	TIYE	246
26	ATLAS COVE	3473
26	EPE TEDO	3489
26	OKUNRAYE	242
26	ALASIA OKUN	228
26	ADENIJI ADELE	3465
26	AJIRAN	3469
26	ABIJO	1285
26	POJA	3523
26	AGRIC	1290
26	OKEPOPO	3519
26	TEMU	1340
26	IDUMOTA	3495
26	ELEMORO	1301
26	IGBONLA	1310
26	ELEKO BEACH 	3486
26	1004	3462
26	BALOGUN	3476
26	MAJEK TOWN	1321
26	ORIBANWA TOWN	1333
26	ILESAN	3499
26	AIYETEJU	1291
26	ILEGE	235
26	ITA MAUN	1313
26	BALOGUN	3475
26	BABA ADISA	1297
27	IPONRI	4271
27	EWEKORO	558
27	SANGISA	4347
27	JANKARA	4283
27	IJU	4258
27	TIGBO	350
27	EBUTE META WEST	4216
27	ASESE	305
27	KIRIKIRI	4290
27	GBAGADA	4230
27	AMUKOKO WEST	4192
27	IJAGEMO	4245
27	APAPA WEST	4200
27	OLODI APAPA	4322
27	AGO PALACE	4165
27	SITE C	4354
27	IDI-IROKO	4236
27	BADAGRY	308
27	ILUPEJU	4269
27	MAFOLUKU	4295
27	ISHERI OSHUN	4276
27	ANTHONY	4194
27	MAKOKO EXTENSION	4299
27	ABULE OKUTA	4160
27	OFADA	338
27	IGANDO	4241
27	IYAMOMO	4281
27	OLOWOIRA	4324
27	EJIGBO	4221
27	IJANIKIN	322
27	OREMEJI IFAKO	4332
27	AGUDA	4167
27	OJO	4311
27	IYANA OLOGBO	330
27	JOBBA	4285
27	MENDE	4302
27	IJORA OLOYE	4257
27	OLUTE	4326
27	MARYLAND	4300
27	IDIROKO	316
27	ISOLO	4278
27	ISHERI OSUN	4277
27	OWOROSOKI L AND K	4341
27	PALMGROOVE	4344
27	OJOKORO	4312
27	ALAKA	4182
27	APAPA NORTH	4198
27	IBASA	4232
27	SNAKE ISLAND	4355
27	UBOWO	4361
27	NARFORIJA	4305
27	APAPA SOUTH	4199
27	YABA/EBUTE META EAST	4363
27	FADEYI	4224
27	OYERO	348
27	ONIPANU	4329
27	KETU MILE 12	4288
27	AKOKA	4176
27	IJORA BADIA NORTH	4255
27	EGBIN	309
27	IYESI	331
27	ADENIRAN OGUNSANYA	4161
27	IKATE	4261
27	ISAGA TEDO	4272
27	ATUNRASE ESTATE GBAGADA	4203
27	IBESHE	314
27	CISARI IGANMU ORILE SOUTH	4211
27	YABA	4362
27	ANTHONY VILLAGE	4195
27	IGANMU	4242
27	AKUTE	4177
27	EGBE	4219
27	IJEDODO	4248
27	ALABA	4178
27	IKOSI	324
27	IJEBU-ALA	4247
27	IWORO	329
27	OKE ODAN	4316
27	OBANIKORO	4306
27	EJIRI	4223
27	OKOTA	4321
27	AKINTAN	4175
27	IBEFUN	313
27	ABORU	4157
27	ASCON	4202
27	ALAKUKO	4184
27	AGBARA AGEMOWO	299
27	ODOGUNYAN	337
27	PAPA AJAO	4345
27	ABULE EGBA	4158
27	AREPO	4201
27	AJEGUNLE BOUNDARY	4172
27	IJORA BADIA EAST	4254
27	ALIMOSHO	4186
27	OWOROSOKI	4340
27	AMUKOKO	4188
27	ITIRE	4279
27	IYANA ILOGBO	4282
27	IPOKIA	326
27	OKE ODO	4317
27	OWORONSHOKI	4339
27	ITELE(AYETORO)	327
27	AMUWO	4193
27	AGEGE	4164
27	OWODE EGBEDO	4338
27	AGOSASA	301
27	KETU	4287
27	BUNGALOW ESTATE	4208
27	OKE IRA	4315
27	EJIRIN	310
27	IJAKO	321
27	AJEROMI	4173
27	IBESE	4233
27	OTO	4337
27	IWAYA	4280
27	SHOMOLU PEDRO	4353
27	IPAJA	4270
27	C2 SARI IGANMU ORILE NORTH	4209
27	OKE-ODAN	341
27	ABULE OJA	4159
27	AKESAN	4174
27	BADAGRY TOWN	4204
27	IJU WATER WORKS	4260
27	IGBOBI	4243
27	SATELITE TOWN	4349
27	AJILETE(IDIROKO)	303
27	OKO OBA AGEGE	4320
27	OKE AFA JAKANDE	4314
27	FESTAC	4225
27	IGBESA	318
27	OWODE YEWA	347
27	ALAGBA	4179
27	OWODE	584
27	IFO	317
27	KIRIKIRI INDUSTRIAL	4291
27	MAKOKO	4298
27	FESTAC COMMUNITY IV	4229
27	AMUKOKO EAST	4190
27	CAPITO	4210
27	EJIGBO ORINLE OWO	4222
27	IJU ISAGA	4259
27	KIRIKIRI PHASE	4292
27	OLOTA	4323
27	IJESHATEDO	4251
27	BODE THOMAS	4207
27	ATAN	306
27	FESTAC COMMUNITY III	4228
27	APAPA	4196
27	ITOKIN	328
27	IJEGUN	4249
27	IJOKO	4252
27	LAFARGE	333
27	OTA	4336
27	IJORA	4253
27	ILAJE	4267
27	ILASAMAJA	4268
27	ISHERI OFIN	4274
27	IBAFO	312
27	SHOMOLU CENTRAL	4352
27	ABARENJI	4156
27	ILA OJA	4266
27	ONIKE	4328
27	AMUKOKO NORTH	4191
27	OKE-IRA	4319
27	PAIM GROVE	4343
27	OGIJO	339
27	SURULERE CENTRAL	4358
27	TINCAN ISLAND	4360
27	IKOTUN	4265
27	ISHERI OKE	4275
27	BARIGA	4206
27	ISHERI	4273
27	EBUTE	4215
27	MAGODO	4297
27	TOPO	351
27	IGAJUN	4240
27	MAGODO	4296
27	TEJUOSHO	4359
27	FESTAC COMMUNITY II	4227
27	JORA BADIA CENTRAL	4286
27	MOWE	574
27	OGUDU	4309
27	OLORUNSOGO	344
27	IKEJA OBA AKRAN	4263
27	AHMADIYA	4168
27	IJORA BADIA WEST	4256
27	OLUTE/NAVY TOWN	4327
27	EBUTE METTA	4217
27	IJEDE	323
27	LAWANSON	4293
27	KETU ORISIGUN	4289
27	OSHODI	4335
27	IJESHA	4250
27	AHMADU BANAGU	4169
27	OPEBI	4330
27	ERIKITI	311
27	IFAKO	4238
27	EGAN	4218
27	ALAGBADO	4180
27	IKEJA	4262
27	AGBOWA	300
27	BAKARE FARO	4205
27	OKE-OSAN	342
27	EGBEDA	4220
27	FESTAC COMMUNITY 1	4226
27	OJA-ODAN	340
27	OLOWORA	4325
27	COKER VILLAGE	4212
27	OGBA	4307
27	OKE OSA	4318
27	IMOTA	325
27	ILOGBO	569
27	IDI ORO	4235
27	OREGUN	4331
27	REDEMPTION CAMP  	4346
27	SANGO	4348
27	MUSHIN	4304
27	OGBA AGUDA	4308
27	AGODO	4166
27	IGBODU	319
27	KETU ITOKIN	332
27	MEIRAN	4301
27	AJAO ESTATE	4170
27	IGBOLOGUN VILLAGE	4244
27	MURTALA MUHAMMED AIRPORT	4303
27	AJIDO	302
27	IGBOGBO	320
27	AGBELEKALE	4163
27	GRA	4231
27	ITORI	570
27	OBELE	336
27	OWODE ITORI	346
27	ORILE IGANMU	4334
27	OJOTA	4313
27	OWODE EGBADO	345
27	AJEGUNLE	4171
27	SURULERE	4357
27	JIBOWU	4284
27	ORILE IGAMU	4333
27	APAPA CENTRAL	4197
27	AGBARA	4162
27	IDIMU	4237
27	SEME BORDER	349
27	IBOGUN IFO	315
27	IGBOGILA	563
27	ALAKIJA/OLD OJO	4183
27	AMUKOKO ALABA ORO	4189
27	DOPEMU	4214
27	OJA ODAN	4310
27	SUBERU OJE	4356
27	LUSUDA	4294
27	AJUWON	304
27	ATAN-OTA	307
27	ALAGBADO	4181
27	OKO AFO	343
27	ALAPERE KETU	4185
27	ALLEN	4187
27	IDI ARABA	4234
27	LISA VILLAGE	334
27	IFAKO AGEGE	4239
27	DOKPEMU	4213
27	MOSIMI	335
27	OYA ESTATE	4342
27	IJAYE	4246
27	IKORODU	4264
28	BAGA	1609
28	Kangeleri	4116
28	MAIDUGURI	4127
28	Maiduguri Flour mills	4128
28	Galdimary	4106
28	KEAYA KUSAR	4118
28	MADAGALI	2283
28	Birmajugwal	4093
28	KAGA	1615
28	Ajari	4088
28	MAFA/DIKWA	1617
28	BIU	2245
28	Zarawuyaku	4155
28	Kidari	4120
28	ASKIRA UBA	4089
28	Mbula Mel.	4135
28	MAMAMADURI	4133
28	KWAYA KUSAR	1616
28	BAMA	4090
28	Kasugula	4117
28	State low cost	4149
28	Dugja	4101
28	Coca Cola Factory	4096
28	KONDUGA	4121
28	BANKI	4091
28	Bulabulin	4095
28	KWAYAKUSA	4123
28	London ciki	4125
28	G.R.A Police Station	4104
28	SHANNI	4146
28	ASKIRA/UBA	1608
28	MAIGATARI	4130
28	Yerimari	4153
28	GEIDAM	4108
28	Abuja	4087
28	SHANI/HAWUL	1620
28	DAMBOA	4098
28	SHUWA	2320
28	Government House	4110
28	HAWUL	4112
28	Nursing Home	4141
28	MONGUNO	1619
28	DIKWA	4100
28	New G.R.A	4137
28	Elkanemi islamic Theology	4102
28	KHADDAMARI	4119
28	Post Office	4145
28	MAFA	4126
28	Shehu's Palace	4147
28	GONIRI	4109
28	Lamisula / mafoni	4124
28	Makintari	4131
28	Gwange	4111
28	GAMBORU NGALA	1612
28	MALAFATORI	4132
28	KADAKA	4114
28	BAYO	4092
28	Zannari	4154
28	Kaigamari	4115
28	Molai G. R. A.	4136
28	Police College	4142
28	GWOZA	1614
28	BAMA/BANKI	1610
28	GUBIO	1613
28	College of agric.	4097
28	GAJIGANA	4105
28	Stadium	4148
28	DAPCHI	4099
28	NNPC Depot	4140
28	WAKA BIUU	4152
28	Garwashina	4107
28	Pompamari Industrial	4144
28	KUKAWA	4122
28	MOBBAR	1618
28	NIPOST Head Quarters	4139
28	Tabra	4150
28	CHIBOK	1611
28	JAKUSCO	4113
28	NGALA	4138
28	FIKA	4103
28	Pompamari Housing Estate	4143
28	Tandari	4151
28	Bolori	4094
28	Mandara Abdu	4134
29	KAYAUKI	3880
29	FUSKAR YAMMA	3867
29	DUTSINMA	1508
29	KANTI	3875
29	KOFAR AREWA	3881
29	DADDARA	279
29	TUDUN IYA	3904
29	AJIWALE	3854
29	CHARANCHI	1507
29	KOFAR BARU	3882
29	SHARGALLE	295
29	BARSARI	3855
29	EMIRS PALACE	3864
29	UNGUWAR DAU	3908
29	DADARA	3857
29	GIDAN MUTUM DAYA	285
29	UNGWARUWAR MATOYA	3913
29	GARAMA	3868
29	KANKARA	572
29	DANDANGORO	3860
29	SABON LAYI	3898
29	MAGAMA	3889
29	MAKERA	3890
29	MALADOWA	3891
29	RAHAMAIMA	3896
29	AJIWA	1503
29	UNGWAR GANGAREN RAFIN KASA	3911
29	DUTSEN REME	3862
29	BABBAR RUGA	1504
29	DANKAMA	280
29	UNGUWAR TUKUR	3910
29	GRA	3871
29	JIKAMSHI	1510
29	UNGWAR MAGINA	3912
29	HOTORO	3872
29	POLICE BARRACKS	3895
29	SAFANA	3900
29	DAN DUTSE	3859
29	KAROFI	3876
29	SABONB FEGI	3899
29	UNGUWAR DAHIRU	3907
29	SANDAMU	294
29	JABIRI	3874
29	KATSINA	3879
29	FILIN KALLO	3865
29	UNGWARUWAR MUSA	3914
29	ZANGON DAURA	296
29	DANMUSA	281
29	BAURE	277
29	MMIATA	3892
29	LOW COST	3888
29	GRA	3870
29	KASTINA RACE COURSE	3878
29	MASHI	291
29	DUTSI	284
29	RIMI	1512
29	SHAGALLE	3901
29	NASSARAWA	3893
29	KAITA	286
29	LGA SECRETARIAT	3887
29	MATAZU	292
29	MALUMFASHI	2285
29	MANI	290
29	DANJA	555
29	DAURA	282
29	KURFI	288
29	DIDAN  MUTUMDAYA	3861
29	MAI-ADUA	1511
29	UNGUWAR TARNAWA	3909
29	SHAGARI QUARTERS	3902
29	BCJ	3856
29	TUNDUN WADA	3906
29	BINDAWA	278
29	KASTINA	3877
29	DUTSI MA	3863
29	KOFAR SAMRI LAYOUT	3884
29	MUSAWA	293
29	SABARI GARI	3897
29	SHINKAFI	3903
29	BATAGARAWA	1505
29	GARIN TANDU	3869
29	KANKIA	287
29	DUTSEN TSAFE	283
29	NAWGU	3894
29	TUDUN WADA	3905
29	BATSARI	1506
29	KOFON KARFE	3885
29	INGAWA	3873
29	KOFAR MARUSA	3883
29	KUSUGU HALL	3886
29	FUSKAR GABAS	3866
29	JIBIA	1509
29	KUSADA	289
29	DAMMARNA	3858
30	NITEL OFFICE/OLUODE LAYOUT	4478
30	AYEDAADE	4472
30	SAANU-AJE	4482
30	IYA-OJE	364
30	EGBEDA	2247
30	ABAA	1716
30	AJASE IPO	4470
30	APAKE AREA/OKELERIN	4471
30	SABO MOTOR PARK	4483
30	OGBOMOSHO	4479
30	TEWURE	4486
30	ARINKINKIN	1720
30	IGBOYI AREA/BAPTIST THEOLOGICA	4474
30	IRESA-APA	363
30	IGBOYI AREA/BAPTIST THEOLOGICA	4475
30	ELEGA	1722
30	ISEYIN	4476
30	ONIPAANU	4480
30	AJE-IKOSE	1719
30	ILUJU	1727
30	IRESA-ADU	362
30	IKOYI-ILE	1726
30	IWOFIN	1729
30	IGBOHO	1724
30	GAMBARI	2253
30	ODOOBA	1731
30	IKOYI	2267
30	GAA MASIFA	4473
30	OOLO	1732
30	AJASE	1718
30	IGBETI	1723
30	IGBON	1725
30	AROJE	1721
30	OUT	4481
30	STADIUM AREA/OYO NORTH	4485
30	KISHI	1730
30	IRESA	1728
30	OKO	582
30	AJAAWA	1717
30	LAUTECH	4477
30	UMUNEDE	4487
30	IKOSE	2266
30	SOUN PALACE OSUPA	4484
31	ELEYELE	3255
31	DUGBE	3252
31	ABA-OLOHAN	181
31	IRESA DU	3283
31	IKIRE	565
31	OMI-AIDO	194
31	ILERO	1193
31	ALAKO	1179
31	IDIAYUNRE	3271
31	SECRETARIAT/OLD OYO RD	3329
31	ABEBI/IDIKAN/OKESENI	3224
31	IFEWARA	3273
31	SANGO/MOKOLA	3328
31	IDERE	2260
31	IDI-ATA VILLAGE	3270
31	IFETEDO	3272
31	OLODO IWO RD	3312
31	IKOYI	568
31	GBENLA/OLD IFE RD	3259
31	MAYA	1196
31	OKE ADO/CHALLENGE/MOLETE	3308
31	APOMU	185
31	IDERE	2261
31	IGANGAN VILLAGE	3274
31	ILUGUN	3280
31	AKUFO VILLAGE	3234
31	APETE-AWAOTAN	1183
31	QUARRY-LAG/IBA EXP	3323
31	MONIYA	1197
31	IDI- AYUNRE	3269
31	IWO RD/BASORUN/AGODI GRA	3287
31	LAGUN VILLAGE	3294
31	RING ROAD	3325
31	IRELE	3282
31	BODIJA	3249
31	IKOSE	567
31	OBAN	3300
31	IJAYE VILLAGE	3276
31	ADAMASINGBA/EKOTEDO	3225
31	IJOKODO/ELEYELE	3277
31	QUARRY	594
31	CRIN	186
31	ORILE OWU	1203
31	OSENGERE	196
31	APATA GANGAN/OLD ONA	3241
31	ARULOGUN VILLAGE	3244
31	AYETE VILLAGE	3246
31	AGODI	3229
31	AMULOKO	1181
31	IDDO-ERUWA	1188
31	ANOWO VILLAGE/ALOMOMASIFALA	3239
31	IYANA OFFA	1194
31	AJODA-NEW TOWN	3232
31	PARAKOYI	3322
31	IDI APE	3267
31	APETE-AWOTAN	3242
31	OLOROGUN VILLAGE/AMOLAJE	3315
31	IRETAMEFA	3284
31	APANPA VILLAGE	3240
31	FELELE/OLORUN-SOGO	3257
31	IGANGAN	1190
31	AJIBODE/IITA	3231
31	OJOO	3306
31	ORANYAN/ELEKURO	3320
31	IDI AYUNRE	3268
31	iyanganku/okebola	3290
31	ELEYELE-OKO VILLAGE	3256
31	OLOGUNERU	1201
31	AKOBO/ODOGBO/ARMY BARRACKS	3233
31	AJODA	182
31	AREMO/ADEKILE	3243
31	IDERE VILLAGE	3266
31	AGBENI	3227
31	KUDET/ILETUNTUN	3292
31	YEMETU/OJE/OKE/AREMO	3331
31	AMOLOKO	3238
31	ODINJO/ACADEMY	3301
31	JERICHO/IDISHIN	3291
31	OLOHUNDA ABA	3313
31	ODUOKPANI	3303
31	SAKI	2318
31	IYANA-OFFA	3289
31	AKUFO	1178
31	LANLATE	1195
31	OMI ADIO	193
31	ERUNMU	188
31	OKOLO VILLAGE	3310
31	ISOKAN LOCALO GOVT	3285
31	OGBAKUBA	3304
31	NEW IFE ROAD	3299
31	AJANLA FARMS	1176
31	OKE ADO	3307
31	OLODO	192
31	ELEYELE-OKO	1186
31	AGO-ARE	1175
31	OLORUNDA ABA	1202
31	ABA NLA	1173
31	ADO AWAYE	3226
31	RING RD/OSOSADI	3324
31	TAPA	1205
31	TAPA VILLAGE	3330
31	AYO ALAAFIN	3248
31	ERUWA	1187
31	LAGOS TOLL GATE	3293
31	OGBOORO	1198
31	ODO ONA OGA TAYLOR	3302
31	GBELEKALE/OJA IGBO	3258
31	ABA EDUN	1172
31	AKINYELE	184
31	ALAKIA/MONATAN/PDC ESTATE	3236
31	IBADAN	3261
31	CHALLENGE	3250
31	ALAKO VILLAGE	3237
31	AKUNLEMU/AGBOYE	3235
31	ARULOGUN	1184
31	OLUYOIE/NEW ADEOYE/ORITA CHALL	3318
31	DELET	3251
31	IJAYE	1192
31	IDI-AYUNRE	189
31	MOKOLA	3295
31	NEW BODIJA/IKOLABA/AGODI	3298
31	OLORUNDA-ABA	3316
31	SAKI	2319
31	OGUNMAKIN	580
31	ABANLA	3223
31	AGUGU/OREMEJI	3230
31	OLOMI/ODO OBA	3314
31	OJEOWODE	1200
31	IGBOORA	1191
31	OLD BODIJA/U.C.H/MOKOLA	3311
31	IYAGANKU/OKEBOLA	3288
31	IDDO	3265
31	OLUYOLE	3319
31	EJIOKU	187
31	MOLETE	3296
31	AGOBWO/OROGUN/SAMONDA	3228
31	ORILE ILUGUN	195
31	AYEYE	3247
31	AKANRAN	183
31	ALOMAJA	1180
31	AYETE	1185
31	OGUNGBADE VILLAGE	3305
31	MORE PLANTATION	3297
31	OLUNLOYO/AKANRAN	3317
31	APANPA	1182
31	SAPETERI	1204
31	AKINGBILE	1177
31	IDI-ATA	1189
31	IGBETI  	3275
31	KILA	593
31	ORIN-OWU	3321
31	AGO-AMODU	1174
31	OGUNGBADE	1199
31	SABO/OKE ADO	3326
31	SALVATION ARMY/INALENDE	3327
31	EGBEDA	3254
31	IBEITO	3264
31	LAGUN	190
31	LALUPON	191
31	OKE BOLA	3309
31	DUGBE/LABAOWO/FOKO	3253
31	ITA-ELEWA	3286
31	IBADO	3263
31	IBADAN POLYTECHNIC/UNIVERSITY 	3262
31	ASEJIRE	3245
32	SEPENTERI	4874
32	ISELE BASOORUN/ADESHINA	4858
32	ELEJA	1829
32	JOBELE	1839
32	AKEETAN TITUN	4849
32	ILAKA/ARAODI	4856
32	SAKUTU/SABO	4873
32	AKUNLEMU/AGBOOYE	4850
32	ISOKUN	4861
32	ISAALE OYO/OGBEGBE	4857
32	SAKI	4872
32	ADO-AWAYE	1827
32	ILORA	1835
32	AHIPA/ISALE OYO	4848
32	IJAWAYA	1833
32	IPAPO	1836
32	OKOMU	4868
32	ARAROMI/MOBOLAJE	4852
32	OWODE	4869
32	OKAKA	1842
32	AWE	2240
32	OYO ALAAFIN	4870
32	OGBORO	1841
32	TEDE	1845
32	FASOLA	4854
32	OYO TOWN	4871
32	AGO  AMODU	4846
32	MOGBA/IYAJI	4865
32	OKE AAFIN	4866
32	KOSOBO	4864
32	AKINMORIN	1828
32	IGANNA	1831
32	IROKO	1837
32	IYALAMU/OKE OLOLA	4862
32	ISEYIN	463
32	YEGHE	4875
32	ELEGA	4853
32	KOMU	1840
32	IGBO-ORA	4855
32	IGBOJAYE	1832
32	KOSO	4863
32	OKEHO	1843
32	IWERE-ILE	1838
32	AARE OGO/ODOARO	4845
32	IJIHO	1834
32	FIDITI	1830
32	AGO  ARE	4847
32	OKE APO/AJAGBAA/GAA	4867
32	APAARA/BALOGUN	4851
32	OTU	1844
33	KWARE LGA	2081
33	RABAH	490
33	KASARAWA	4991
33	BARIKIN MARMATO	4981
33	BODINGA	2070
33	OLD MARKET	5005
33	MALUFASHI	5004
33	DANGE SHUNNI	2071
33	FEDERAL SECRETARIAT QUARTERS	4985
33	GIDAN IGWAI	4987
33	GADA	2073
33	GORONYO	2075
33	FARFARU	4984
33	MABERA GIDAN GWADABE	4997
33	MABERA TSOHON GIDA II	5001
33	GWADABAWA	2077
33	MABERA SHIYAR NASSARAWA	4999
33	UNGUWAN ROGO	5012
33	WURNO	494
33	ISA LGA	2079
33	SABON-BIRNI	2082
33	AMANAWA	2068
33	DOGON DAJI	2072
33	KEBBE	2080
33	SILAMI	5008
33	KEBBI	4992
33	TAMBUWAL	492
33	KWARE	4994
33	SOKOTO	5009
33	ALI AKILU	4979
33	TUSUN WADA	5011
33	ILELLA	4989
33	DENGE	4983
33	BINJI	2069
33	RIJIYAN DORAWA	5006
33	YABO	495
33	GIDANMADI	2074
33	BAGIDANE	4980
33	GUDU	2076
33	WAMAKKO	493
33	KALAMBINA GIDAN MANUMA	4990
33	TANGAZA	2084
33	DANGE	4982
33	HAJIYA HALIMA	4988
33	MALAM MADURI	5003
33	SOKOTO NORTH/SOUTH	5010
33	MABERA IDI	4998
33	TURETA	2085
33	MAGAJIN GARI	5002
33	SHAGARI	491
33	GAWO NAMA	4986
33	ILLELA	2078
33	MABERA GIDAN DAHALA	4996
33	RUNJIN SAMBO	5007
33	YAURI FLAT HOUSE	5013
33	MABERA TSOHON GIDA 1	5000
33	KET	4993
33	LOW COST GWIWA	4995
33	SILAME	2083
34	IBAJI	1543
34	OGORI	1554
34	JOBELE	3951
34	OBANGEDE	1553
34	IBAJI LKJ	3944
34	LOKOJA BYE PASS	3965
34	OGUGU	1555
34	AJAOKUTA	1536
34	AYETORO GBEDE	1540
34	KAJURU	3953
34	ADOGI	3932
34	ANYANGBA	3935
34	APAYAN	1539
34	ITAKPE	1546
34	KABBA TOWN HALL	3952
34	IYAMOYE	1548
34	OKEGWE	1556
34	ABEJUKOLO	1534
34	OKPO	2306
34	LOCAL GOVERNMENT SECRETARIAT	3963
34	IDAH	1544
34	KARD	3956
34	IHIMA	1545
34	MAY ADOWA	3967
34	ADOGO	1535
34	IYA_GBEDE	1547
34	IYA-GBEDE	3949
34	IYARA	1549
34	ALLOMA	1537
34	KOTONKARFE	1551
34	G.R.A	3942
34	ERINRIN-ADE	3941
34	KABBA	1550
34	KARA	3955
34	UGWU ALAO	1558
34	MANGOGO	3966
34	DUDUGURU	3939
34	ADUDU	3933
34	KOGI	3960
34	KAOJE	3954
34	AYANGBA	3936
34	LOKOJA	3964
34	IGBEKEBO	3947
34	KUMO	3962
34	OKEHI	2302
34	GENERAL HOSPITAL	3943
34	OKENE	1557
34	DEKINA	1541
34	EGUME	1542
34	ANYIGBA	1538
34	DIKINA	3938
34	SIR JAMES OLORUNTOBA WAY	3969
34	IYA EGBEDE	3948
34	EKIRIN ADE	3940
34	OBAJANA	1552
34	COLLEGE OF AGRIC	3937
35	DIFA	169
35	BAMABAM	1131
35	EMENEKE BUS STOP	3164
35	GEBUNU	3167
35	KALMAI	1139
35	SHONGOM	1151
35	BOH	1132
35	G.R.A	3166
35	BALANGA	1130
35	GELENGU	1137
35	TURE	1156
35	KUMO	3175
35	TUDUN WADA	3188
35	HERO GANA	3171
35	KUMBIYA KUMBIYA	3174
35	NATADA	3181
35	ASHAKA	1125
35	YIDEBA	3189
35	TUMU	1155
35	DEBA	3163
35	TULA	1154
35	AYABA	1127
35	BOJUDE	167
35	EMIR'S PALACE	3165
35	TAI	3186
35	TODI	1153
35	SHINGA	1150
35	BIU	2244
35	LADONGO	3177
35	GADAWO	172
35	KAMO	1140
35	POLICE C.I.D	3184
35	KASHERE	174
35	AWKA	3159
35	GADA UKU	171
35	GOMBE	3169
35	KURI	1143
35	MALLAM SIDI	1148
35	KALTUNGO	173
35	TANGLANG	176
35	GOMBE ABBA	1138
35	TONGO	177
35	PINDIGA	175
35	BILLIRI	166
35	JEKA DA FARI	3172
35	BURIA	1133
35	AWAK	1126
35	KOBUWA	3173
35	GELBUNU	3168
35	KWAMI	1145
35	MONGONO	3178
35	LAWANTI	1146
35	DADIN KOWA	168
35	MAIKAFO	1147
35	KWADAN	3176
35	BAGANJE	1128
35	BAGUNJE	3161
35	GARIN HASHIDU	1136
35	KUBUWA	1142
35	BANGANJE	3162
35	TUDUN HATSI	3187
35	PIDINGA	3183
35	DADIYA	1134
35	BABAM BAM	3160
35	KWADOM	1144
35	ZAMBUK	3190
35	TALLASE	1152
35	NAFADA	1149
35	PANTAMI	3182
35	BAJOGA	1129
35	GOVERNMENT HOUSE	3170
35	AKKO	3158
35	DUKKU	170
35	GADAM	1135
35	SHAMAKI	3185
35	KEMBU	1141
35	NASSARAWO	3180
35	MONUGA	3179
36	UMUOSU NSULU	590
36	EZINACHI OKIGWE	2107
36	MBALANO	5049
36	Amuzukwu	5046
36	OZUITEM	514
36	AZUIYI OLOKORO	507
36	OFEME	2112
36	OKIGWE	2114
36	World Bank	5061
36	OLOKORO	2115
36	ACHA	2100
36	UTURU	516
36	AJATA IBEKU	2103
36	UMUOKPARA	5058
36	ITEM	2109
36	Umuahia Urban III	5056
36	OHUHU	2113
36	OHAFIA	513
36	AHIAEKE	2102
36	BENDE	508
36	ugwunchara	5053
36	ONICHA LGA	5051
36	AFUGURI	2101
36	ISUOCHI	2108
36	UMUAHIA	5054
36	ABRIBA	5045
36	ISIUKWATO	5048
36	Umuahia Urban I	5055
36	AFARA	2232
36	Ossah	5052
36	UZOAKOLI	5060
36	IHECHIOWA	5047
36	ITUMBAUZO	2110
36	ABIRIBA	505
36	UMUOSU N.	5059
36	MBALANA	2111
36	EKEOBA	2106
36	NSULU	577
36	UMUOPARA	2116
36	AROCHUKWU	2105
36	IKWUANO	510
36	ALAYI	506
36	ARIAM	2104
36	IGBERE	509
36	ISIKWUATO	511
36	UMUDIKE	5057
36	MBUDO	5050
36	OBORO	512
36	UMUAKWU NSULU	515
37	EZIAMA  NVOSI	607
37	MBAWUSI	2359
37	UMUALA	634
37	ABALA VILLAGE	2333
37	EKE AKPARA	2348
37	MBUTU	23
37	UMU KALU	631
37	UMUODE	47
37	IHIE ORJI	21
37	UMUOTUTU	2396
37	Aba Central	2332
37	Asaokpuja	2346
37	OSISIOMA VILLAGE	33
37	OVOM 2	35
37	AGBARAGWU	2336
37	OBIGA VILLAGE	29
37	UKPAKIRI	37
37	OWERINTA	2386
37	ASANNETU	2344
37	OHURU VILLAGE	32
37	ITU NGWA	22
37	AMACHI NSULU	601
37	NDI-AKATA	2365
37	UMUIKAA	639
37	UNUAKWU NSULU	644
37	IHIEORJI	2355
37	UMU ADURU	38
37	AKWETTE VILLAGE	599
37	UKWA NDOKI	628
37	AMAORJI	14
37	AKABO-IKEDURU	2337
37	ABA	2330
37	UMU AHIALA	630
37	OKPUALA NGWA	620
37	ISIALA NGWA	2357
37	ONICHA NGWA	2382
37	UMUOSU NSULU	2324
37	EZIALA	2350
37	UMUEZE VILLAGE	2389
37	OBEHIE  VILLAGE	2375
37	UMUOLIOKE	2395
37	UKWA VILLAGE	629
37	MBUTU NGWA	609
37	NLAGU	613
37	AKIRIKA VILLAGE	598
37	ARO NDIZUOGU	2340
37	ARIARIA	2339
37	UMUGURU	638
37	OBETE	616
37	OHANKU VILLAGE	619
37	IDI AYUNRE	2353
37	EKE-ARO	2349
37	ASA UMUEKECHI	16
37	OWO ASA	36
37	UMUOJIMA	48
37	AMAVO VILLAGE	602
37	OWOAHIAFOR	2387
37	AMAVO	15
37	ASA UMUAKACHI	2342
37	NTIGHA VILLAGE	615
37	UMUCHIMA	637
37	NSULU	2293
37	OBINGWA VILLAGE	30
37	UMUODU	643
37	OSUSU	2384
37	Iheorji Layout	2354
37	UBAHA NSULU	627
37	OBUBA NVOSI VILLAGE	618
37	NGWAIHIEKWE	27
37	OWAZA	624
37	UMU AKPI	39
37	Umungasi	2390
37	ASANNENTU	18
37	UMUEZE	44
37	IMO RIVER	608
37	OBEHIE VILLAGE	28
37	OBIOMA NGWA	2376
37	OWERRINTA	625
37	EKE ARU VILLAGE	19
37	UMUWOMA	49
37	UMUAGU	632
37	Eziama layout	2351
37	OGWE VILLAGE	31
37	UMUARIAWA	2388
37	ABAYI ARIARIA	597
37	AMUZU	603
37	NEMBE TOWN	2370
37	NGWA IHIEKWE	2373
37	OBOHIA VILLAGE	617
37	EZIALA NSULU	606
37	OWOAHIOFOR	626
37	UMUANUNU	635
37	OHAMBELE	2379
37	OHUHU NSULU	2380
37	ASA OBEHI	2341
37	ISIALA NGWA VILLAGE	2358
37	NDI OLUMBE	2364
37	UMU ARIWA	40
37	 AGBARAGWU	2335
37	ALAOJI	600
37	UMUOJIMA  VILLAGE	2394
37	Ohabiam Layout	2378
37	OSAA VILLAGE	623
37	UMUADIENWA	43
37	OMOBA	621
37	UMUOBI NGWA	2393
37	ASAD UKWU	2343
37	UMUOBI N.	2392
37	NGURU IHIEKWE	2372
37	ASA OBEHIE	604
37	UMUNKO	640
37	UMUGO	45
37	NDIAKATA	25
37	AZUMIRI	605
37	ABALLA VILLAGE	596
37	MGBOKO	2361
37	NANKA-AWKA	2362
37	NDIOLUMBA	2369
37	NDIEGORO VILLAGE	26
37	ASANNETU	2345
37	ABA	2331
37	UMU NKWO	41
37	UMUOBA	642
37	NENU VILLAGE	612
37	NENU	2371
37	MGBOKO VILLAGE	24
37	NBAWSI	610
37	NDI AKATA	2363
37	Abaukwu	2334
37	AZUMIRI ADOKO	2347
37	EZIAMA NVOSI	2352
37	ONITSHA NGWA	622
37	UMUOBASI	46
37	NKPATI ENIN	2374
37	UMUBA VILLAGE	636
37	UMU OWUKE	42
37	UMUNKPEI	641
37	NDIEEGORO	2367
37	UMUAHALA	633
37	NTIGHA UZO	614
37	NDI OLUMBA	611
37	OSUSU AMAUKWA	34
37	ASA UMUNKA	17
37	NDIEGORO VILLAG	2368
37	OVOM AMASAA	2385
37	ONITSHA	2383
37	OBUBA	2377
37	OKPUALA N.	2381
37	IHIE	20
37	NDIEEGORO	2366
37	AKIRIKA	2338
37	UMUNKO VILLAGE	2391
38	UMUNDUGBA	451
38	UMUOWA ORLU	454
38	AKABOR	1763
38	OBODOUKWU IDEATO	4638
38	OPUOMA	438
38	OKWUDOR - ORLU	436
38	MBAISE OTHERS	4622
38	MBUTU OKOHIA	409
38	NEKEDE	1804
38	AMIRI	1775
38	UMUECHE	4659
38	UMUOWA NGOR	453
38	IHITTE NANSA	394
38	AFORORU-MBAISE	1759
38	EBENANO	380
38	INYISHI	4615
38	AWO OMAMA	4597
38	AAWARA	1753
38	ASAA	1779
38	LOCAL GOVERNMENT HEADQUARTERS	4619
38	WORKS LAYOUT	4672
38	OBIANGWU	420
38	LAGWA	403
38	IHITTE UBONA	395
38	EZIAMA NGOR-OKPOALA	388
38	NWORIEUBI	4635
38	AKOKWA	4578
38	OKWELLE	435
38	AMAKOHIA-IKEDURU	1767
38	MGBEE	410
38	ORIAGU-NSU MBANO	439
38	AMARURU	1772
38	UZI LAYOUT	4670
38	IDEATO SOUTH	4605
38	MBAISE	404
38	OHUBA	432
38	OGWA	581
38	MBIERI	408
38	OWERE EBIRI	443
38	AKATA	1765
38	MBAITOLU L.G H/Q	4623
38	UBAHU	4654
38	AZARSEGBELU	1789
38	AKAOKWA	1764
38	ARONDIZUOGU	1778
38	OKWUDOR ORLU	4645
38	ALADINMA NORTHERN EXTENSION	4580
38	UMUTANZE ORLU	456
38	ANMANFOR	1777
38	MBANO	406
38	ORSU	441
38	AGIRIGA	4577
38	AVTU	4595
38	ALADINMA ESTATE	4579
38	EJEMEKWURU	383
38	UMUDIOKA ORLU	447
38	CHOKONAEZE	1790
38	URUALLA	458
38	NDIKWAEKE	4631
38	UMUAKA NJABA	4658
38	EZINIHITTE MBAISE	390
38	INDUSTRIAL AREA	4614
38	UMUESHI	448
38	OGBUERURU	429
38	AKABO	1762
38	OLOKWU	437
38	UMUOZU MBANO	455
38	AMUZI- OBOWO	379
38	ENYIOGUGU-MBAISE	385
38	UGWU ORJI	4656
38	OKWUDOR ORLU	4646
38	OBILUBI	422
38	EHIME MBANO	4598
38	AMAIMO	4584
38	IZOMBE	1801
38	AWO-IDEMILI	1786
38	AGBALA	1760
38	ATTA	4594
38	NAZE	4629
38	AMAOKHIA-IKEDURU	4587
38	OBOWO	426
38	MGBIDI	411
38	MMAHU	1803
38	OKUKU	4644
38	ABOR-MBAISE	376
38	LOW COST	4620
38	OSU IHITTE UKWA	442
38	IMERIENWE	399
38	UZOAGBA	4671
38	AHIAZU MBAISE	378
38	ORIAGUM BANO NSU	4648
38	AMUZARI	4592
38	AWO-OMAMA	1787
38	EMEKUKU	4599
38	OBIBIEZENA	421
38	NEW OWERRI	4632
38	OBIBI-EZENA	4637
38	ARUGO LAYOUT	4593
38	MBAITOLI	405
38	IHIOMA	393
38	ABA-BRANCH	1754
38	IRETE	4616
38	NKEWERE	4634
38	AVUTU	1782
38	NNEMPI	418
38	AMIGBO	1774
38	DIKENAFAI	1791
38	EZIAMA IKEDURU	387
38	AGWA	1761
38	AZARA-OBIATO	1788
38	REV.MANN	4652
38	EZIOBODO	391
38	EHIME- MBANO	382
38	ABBA	2230
38	UMUHUOKABIA ORLU	450
38	AMARAKU	1771
38	AWA	1784
38	NGOR OKPALA	4633
38	AWO IDEMILI	4596
38	ENYIOGUGU MBAISE	4600
38	MECHANIC VILLAGE	4626
38	AMAOJI	4586
38	EZIAMA OBIATO	389
38	MGBIRICHI	412
38	ABAEZI	1756
38	ABACHIEKE	4573
38	EGBUOMA-OGUTA	1795
38	OBODOUKWU	424
38	OGBOMORO	4639
38	IYISHI	402
38	NNARAMBIA	417
38	OBINZE	423
38	ABAJA	1757
38	NKWOSI	416
38	ITU EZINIHITTE	401
38	AMAIGBO	4583
38	OGUATA ISLAND	4640
38	EGBEMA	1793
38	EMII	1798
38	IHIAGWA	392
38	UDOR ORLU	4655
38	AMAWOM	4589
38	UMUAGWO	445
38	UMUODU	4663
38	IHIT-OWERE	4607
38	IHO	396
38	GERMAN HILL	4602
38	OHI	431
38	AMAOPARA	4588
38	GENERAL HOSPITAL	4601
38	ABACHEKE	1755
38	UMUNA	4662
38	OKPORO	434
38	IDEATO NORTH	4604
38	AVU	1781
38	ABO  MBAISE	4574
38	UMUELEMAI	4660
38	ABO- ORLU	1758
38	ETITI	386
38	NKWERE	415
38	UMUGUMA	449
38	OBOSIMA	425
38	NWORIUBI	4636
38	AMAKOHIA-UB1	4585
38	IKEDURU L.G H/Q	4609
38	UMUOYINMA EMMANUEL COLLEGE LAY	4666
38	NGURU MBAISE	414
38	ETEKWURU	1799
38	IKENEGBU LAYOUT	4612
38	OWERRI	4650
38	ISU	4617
38	MGBALA AGWA	1802
38	EZIORSU	1800
38	OKPARA	4643
38	UMUOZO MBANO	4667
38	IHITE NANSA	4606
38	AMALIM	1769
38	EGBU	1794
38	ORLU	440
38	NGOR-OKPALA	413
38	EBENATO	381
38	OKOLOCHI	433
38	OGBAKU	428
38	OGUTA ISLAND	4641
38	UMUNDUGBA ORLU	452
38	ITU EZINIWHITE MBAISE	4618
38	URATTA	1806
38	IMO STATE UNIVERSITY	4613
38	MGIDI	4628
38	AMAUZARE-ISIALA MBANO	1773
38	IDEATO	4603
38	AMAKOHIA- URATTA	1766
38	EGWE-OGUTA	1796
38	IKENEGBU	4611
38	EMEABIAM	1797
38	EKWE	384
38	OMUOZO 	4647
38	AMAKOHIA-UBI	1768
38	ULAKWO,	444
38	IKENANZIZI	4610
38	IKENAZIZI	398
38	UMUSASA	4668
38	OFROLA	427
38	URUALLA IDEATO	4669
38	OWERRI EBIRI	4651
38	MBEKE	407
38	ISU NJABA	400
38	OMUMA	583
38	AGAWARA`	4576
38	UMUHUOKIABIA ORLU	4661
38	ORODO	4649
38	AMIKE ORLU	4590
38	ATTAH	1780
38	AMANDUGBA	1770
38	OKOWELLE	4642
38	ABO-ORLU	4575
38	UMUOKWARA	4664
38	IKEDURU	397
38	NAZE	4630
38	ULAKWO	4657
38	AMAIFEKE	4581
38	OROGWE	1805
38	UMUAKA	446
38	OGUTA	430
38	NWANGENE	419
38	AMAIFEKE	4582
38	UMUOWA (NGOR)	4665
38	UMUZIKE ORLU	457
38	EGBEADA	1792
38	AHIARA	377
38	AMUCHA	4591
38	AVUVU	1783
38	STATE HIGH COURT	4653
38	IHITTE UBOMA	4608
38	ANARA	1776
38	AWAKA	1785
39	NNPC DEPOT	2292
39	MUBI SOUTH	2210
39	Gwadabawa	5192
39	GAWANA	5187
39	SAVANNA	5212
39	MICHKA	5206
39	GUYUK	2197
39	MUBI NORTH	2209
39	SAVANAH	2213
39	Lukuwa	5202
39	Federal Housing	5185
39	Ijari	5193
39	GEREI	2195
39	SHELLENG	2214
39	YOLA	5220
39	BORRONG	2188
39	Majalisa	5203
39	Wuro Patuji	5218
39	NGURORE	2211
39	MARARABA MUBI	2206
39	SONG	2215
39	KWARHI	2203
39	HONG	2199
39	MICHIKA	2208
39	GYAWANA	2198
39	JABI	2200
39	JEBILAMBA	2202
39	FURORE	2191
39	LAMBA	2204
39	Damilo	5181
39	Demsawo	5182
39	SHUWA	2321
39	UBA	2217
39	JIMETA	5196
39	Wuro Jibirward	5217
39	NGWRORE-AFFCOT	5210
39	MAYOBELUWA	5205
39	GULAK	5191
39	School Of Arts	5213
39	LAMURDE	5200
39	FGGC	2190
39	DEMSA	2189
39	MUBI	5207
39	Shuware ward	5214
39	BORON	5180
39	Wuro Gude Ward	5216
39	GANYE	2192
39	GBORONG	2194
39	Industrial	5194
39	Jambutu	5195
39	GIREI	5190
39	Lamido Palace	5199
39	MAYO BELWA	5204
39	Nasarawa	5208
39	TONGO	5215
39	Old G.R.A.	5211
39	MAYO-BELWA	2207
39	JADA	2201
39	GERFI	5188
39	Kochifa Ward	5198
39	NGURORE AFCOTH	5209
39	GARKIDA	2193
39	MADAGALI	2284
39	Airfield	5178
39	NUMAN	2212
39	Luggere	5201
39	Dubeli	5183
39	DUTSE	5184
39	TOUNGO	2216
39	Yelwa Ward	5219
39	FOFORE	5186
39	MAIHA	2205
39	GEWANA	5189
39	Karewa	5197
39	GOMBI	2196
39	BELE	5179
40	JEGA	996
40	GWANDU	993
40	DAKIN GARI	2904
40	INGASKI	995
40	NEW MOTOR PARK	2930
40	AUGIE	984
40	ALIERO	981
40	YELWA YAURI	2946
40	BY PASS ROAD	2903
40	KANGIWA	998
40	YAURI	1002
40	NASSARAWA I	2928
40	DIRIN DAJI	990
40	MAIYAMA	1001
40	KAMBA	2919
40	EMIRS PALACE	2909
40	BULASA	986
40	MAGAJIN RAFI	2925
40	ARGUNGU	983
40	BIRNIN YAURI	2901
40	KOKANI NORTH	2921
40	NASSARAWA II	2929
40	ZURU FADA	2949
40	EMIRS PALACE	2910
40	HILUKA	2918
40	SURU	2941
40	ZURU CENTRAL	2947
40	BUNZA	987
40	RIMA QUARTERS	2937
40	ZURU JAKASSA WEST	2951
40	ANDARAI	982
40	KOKO BESSE	2923
40	TASHAR GARKUWA	2942
40	MARKET	2926
40	GESSE LOW COST	2915
40	SHANGA	2940
40	TWIN QUARTERS	2943
40	DANDI	989
40	UNGUWAR WALI	2944
40	ZURU ZANGO	2953
40	AREWA DANDI	2898
40	PRISON SERVICE	2935
40	LIBATA	2924
40	DOLE KAINA	2908
40	DG's QUATERS	2906
40	GALADIMA	2914
40	ZURU TUDUN WADA	2952
40	ZURU EMIRATE COUNCIL	2948
40	UNGUWAR ZURU	2945
40	ILLO	994
40	BAGUDO	985
40	BOMGOGOMO	2902
40	BIRNIN KEBI	2900
40	DANKO WASAGU	2905
40	FANA	992
40	ZURU	1003
40	ETUNG LGA	2911
40	KAOJE	2920
40	GAKAR JATAU	2913
40	FAKAI	991
40	BIRNIN KEBBI	2899
40	GULUMBE	2916
40	NGASKI	2932
40	SAURO	2939
40	ZURU JAKASSA EAST	2950
40	DAKINGARI	988
40	NEW PRISON QUATERS	2931
40	G.R.A	2912
40	GWANGE	2917
40	AMBURSA	2897
40	KOKANI SOUTH	2922
40	AGWARA	2235
40	KOKO	2280
40	RAFIN ATIKU	2936
40	DIRN DAJI	2907
40	NKASKI	2933
40	KALGO	997
40	SAKABA	2938
40	LOLO	1000
40	MEKERA GANDU	2927
40	POLICE AREA COMMAND	2934
40	KARD	999
41	FUNE	136
41	JAJIMAJI/KARASUWA	1052
41	MAISANDARI	3037
41	BABBAN-GIDA	1038
41	MACHINA	1054
41	SAPETERI	3041
41	FIKA	1045
41	BARA/GULANI	1041
41	GUJBA/BUNI YADI	1050
41	NENGERE	3039
41	POTISKUM	1057
41	NANGERE	1055
41	LEGISLATIVE QUARTERS	3036
41	YUNUSARI	1058
41	D.H PALACE	3024
41	JAKUSKO	1053
41	EMIRS PALACE	3026
41	GONIRI	3029
41	BUNI-YADI	1042
41	YUSUFARI	138
41	BINDIGARI	3023
41	NGURU	1056
41	DAPCHI	1044
41	GAIDAM	1046
41	KANAMA	3034
41	JAJI-MAJI	137
41	JAKUSCO	3033
41	LAMISULA	3035
41	STATE LOW COST HOUSING VILLAGE	3043
41	MAXIMUM SECURITY PRISON	3038
41	GULANI	1051
41	GENERAL HOSPITAL	3028
41	FEDERAL LOW COST	3027
41	BABBANGIDA/TARMUWA	1039
41	BANKALIO ESTATE	3022
41	BARA	1040
41	SPECIALIST HOSPITAL	3042
41	WOMEN TEACHER'S COLLEGE	3044
41	GEIDAM	1048
41	GRA	3030
41	NEW GENERAL HOSPITAL	3040
41	ABUJA GARAGE	3021
41	GUJBA	1049
41	GWANGE	3031
41	YUSUFFARI	3045
41	GASHUA	1047
41	IBRAHIM ABACHA ESTATE	3032
41	DAMAGUM	1043
41	DAMATURU	3025
42	SHANONO	1493
42	JANGOZA	1475
42	DANZANBUWA	3776
42	MINJIBIR	1485
42	YABO	3851
42	KANO STATE UNIVERSITY	3807
42	TARAUNI	1496
42	MALAMADORI	3822
42	PANISAU	1488
42	BADAWA	3765
42	BADUME	3766
42	KADEMI	3803
42	DOLE KAINA	3779
42	HOTORO	3799
42	LAHADIN  MAKALI	3820
42	RIMI GADO	3831
42	TUDUNWADA	1499
42	KATURJE	3808
42	FAGGE	1466
42	DAMBATA	3775
42	SABONGARI	3836
42	BAGAWAI	3767
42	KIRU	1479
42	CIROMAWA	1459
42	UGOGO	3845
42	UNGUWAR FULANI	3846
42	MINNA	3825
42	TSANGAWA	3843
42	DAKATA	3774
42	UNGOGO	1500
42	KURA	1482
42	MADOBI	1483
42	KANO MUNICIPAL	3806
42	KABO TOWN	3801
42	WUDU	3850
42	KAZARE	3810
42	GARFIDA	3786
42	SUMAILA	1494
42	KOFAR FADA	3812
42	AGURU	3763
42	KUNCI	1481
42	KARAYE	1477
42	SHAHUCHI	3839
42	MINICIPAL	3824
42	NO MAN'S ISLAND	3828
42	EMIRS PALACE	3781
42	KUMBOTSO	1480
42	ROGO	1492
42	BEBEJI	1455
42	GARINDO	3787
42	TIGA	3842
42	TSANYAWA	1498
42	HADEJIA ROAD	3796
42	GWARZO	1474
42	KOFAR NASSARAWA	3814
42	CHALAWA PHASE 1	3770
42	KWA	3817
42	TOFA	1497
42	GYADI GYADI	3793
42	DOGUWA	1465
42	FAGGE TAKUDU	3782
42	DARKI	3778
42	TAMBURAWA	3841
42	CORNER DANGORA	3773
42	TAKAI	1495
42	BAGAUDA	1453
42	DARA	3777
42	MAKODA	1484
42	RIMIN GADO	3832
42	KUNCHI	3815
42	OLD CITY	3829
42	WARAWA	3848
42	MICHAKA	3823
42	BICHI	1457
42	KANO	3805
42	GARKO	1468
42	GWARZA	3792
42	YADANKUNYA	3852
42	GORON DUTSE	3789
42	SHARADA	3840
42	DAWAKIN TOFA	1463
42	GANDU ALBASA	3784
42	GARUGAJA	3788
42	DALA	1460
42	BAGWAI	1454
42	BELA/YADAKUNYA	1456
42	GAYA	1470
42	RUMFA COLLEGE	3833
42	RIMINGADO	1491
42	GWALE	1473
42	BOMPAI	3768
42	KAZAURE	1478
42	TUDU WADA	3844
42	NASSARAWA	1487
42	RANGAZA	1489
42	JIGAWA	3800
42	KWANAR DISO/KOFAR NA'ISA	3819
42	WUDIL	1502
42	GARUN MALAM	1469
42	KWANA YAU DADDAWA	3818
42	CHALAWA PHASE 2	3771
42	DAWANAU	1464
42	SAMARI KATAF	3837
42	ARBASU	3764
42	WARAWAA	1501
42	GORON MARAM	3790
42	GANO	3785
42	HAUSAWA QTRS	3798
42	KURNA	3816
42	BABURA	2242
42	GABASAWA	1467
42	GYADI GYADI/KARKASARA	3794
42	HADEJIA TOWN	3797
42	DOLIUWA	3780
42	ZAKIRIA	3853
42	KILOMETER 26	3811
42	BUNKURE	1458
42	POLICE BARRACKS	3830
42	UNLIOLIO	3847
42	CHALAWA PHASE 3	3772
42	DANBATTA	1461
42	DAWAKIN KUDU	1462
42	SHAGARI QUARTERS	3838
42	KABUGA	3802
42	GEZAWA	1471
42	KIBIYA	276
42	GYADI-GYADI	3795
42	SABON GARI	3835
42	BRIGADE QUARTER	3769
42	WUDII COMPREHENSIVE HEALTH	3849
42	RANO	1490
42	FARIN GADA	3783
42	MUNICIPAL	1486
42	GOVERNMENT HOUSE	3791
42	ALBASU	1452
42	GUNDUWWA DISTRICT	1472
42	SABIN	3834
42	KANGIWA	3804
42	KABO	1476
42	KOFAR MATA	3813
42	NAIBAWA	3827
42	LOCAL GOVERNMENT SECRETARIAT	3821
42	AJINGI	1451
43	MAIKUNKELE	4397
43	AGALE	4364
43	DUTSEN KURA	4379
43	MAIRIGA	4398
43	NTIGHA	4410
43	KAFIKORO	4388
43	TUDUN FULANI	4421
43	KUTA	354
43	KATA EREGI	4391
43	SABON DAGA	4413
43	WUSHISHI	357
43	IBB HOSPITAL	4382
43	TUDUN-FULANI	1651
43	MAITUMBI DANA PHARM.	1639
43	KPAKUNGU	4393
43	GULU	1628
43	IYARUWA	4386
43	TUNGA-MAGAJIA	1652
43	TUNGAMAGAJIN	4423
43	DOKO	1625
43	GUSSORO	1629
43	CHANCHAGA/IBB HOS&FGC	4374
43	MAITUMBI	4400
43	KAMPALA	4390
43	ZUNGERU DAM/ POWER STATION	1653
43	POGO/NNPC	1645
43	BOSSO DUSTIN KURA	4373
43	NASKO	4406
43	PAIKO	1643
43	IBB HOSPITAL/CHANCHAGA	4383
43	KATEREGI	1636
43	KABOJI	1632
43	SHIRORO DAM	4417
43	MARIGA/BANGI	1640
43	BARO	4371
43	KAGARA	1633
43	KAMPALA/MAIZUBE WATERS	1634
43	KONTAGORA	1637
43	YAKILA	4427
43	EDATI	1626
43	EDIATI	4380
43	ADUNU	1621
43	BEJI	1624
43	BADA	4366
43	IBB HOSPITAL/ CHANCHAGA	1631
43	KATCHA	1635
43	KUCHITA NDAK POTUN	4394
43	KOIDA KURA	4392
43	BARKIN SALE	4370
43	IBB UNIVERSITY	4385
43	MAITUMBI GWADAI	4401
43	MASHEGU	1641
43	DANA PHARM	4376
43	RIJAU	1646
43	KUTIGI	1638
43	NASKO/AUNA	1642
43	GWADA	1630
43	BADEGI NCRI	4367
43	MAIYUMBI DANA PHARM	4402
43	BADEGGI/NCRI	1623
43	POGO/NNPC EPORT	4411
43	DARACHITA TAKWASA	4377
43	MAIZUBE WATERS	4403
43	SHONGO	4418
43	TAGWAI DAM/ FGC/SCIENTIFIC EQU	4419
43	AGAIE	1622
43	BIDA	352
43	GIDANKWANO	4381
43	TUNGAN ALADE	4424
43	MINNA	4404
43	IZOM	4387
43	DOKKO	4378
43	KAFINKORO	4389
43	WATER WORKS	4426
43	TUDUN FULANI	4420
43	MAITUMBE 	4399
43	NASKO	4407
43	LAPPAI IBB UNIV.	4396
43	BANGAYI EKPAT SUNARU	4369
43	GIDAN-KWANO/FUT/NECO	1627
43	SABON-DAGA/ MAIZUBE YOGHURT	1647
43	KAFFIN-KORO	353
43	TUNGA MAGAJIYA	4422
43	LAPAI/IBB UNIVERSITY	355
43	MNA	4405
43	AIRPORT KWANGALI	4365
43	NDENZUBA	4408
43	PANDOGARI	1644
43	TEGINA	356
43	TUNGAN CHANCHAGA	4425
43	BANGANJE	4368
43	SARINPAWA	4414
43	LAPAI	4395
43	IBB HOSPITAL/CHANCHAGA	4384
43	RIVER BASIN AUTHORITY	4412
43	SARKIN PAWA	4415
43	SARKIN-PAWA	1648
43	NINTH MILE	4409
43	COLLEGE OF EDUCATION	4375
43	SHIRORO	1649
43	SHANGO	4416
43	BOSSO	4372
43	ZUNGERU	358
43	TAGWAI DAM/ FGC/SCIENTIFIC EQUIP.	1650
44	BI-WATER	2087
44	GURARA	497
44	BIWATER	5032
44	ZUBA JUNCTION	5044
44	ABAJI	2086
44	YABA	2099
44	MAJE	2094
44	YABAA	5042
44	ROBOCHI	2095
44	IZOM	498
44	GIRI	2090
44	KUJE ROAD	2093
44	SULEJA	5039
44	ZUBA	5043
44	GAWU-BABANGIDA	496
44	GWAGWALADA	2091
44	LAMBATA	500
44	TUNGA-YAKUBU	503
44	SABON-WUSE	502
44	SULEJA	5038
44	TUNGA-MAJE	2098
44	DIKKO	2088
44	KWAMI	5036
44	DIKO	2089
44	GANU BANGIDA	5034
44	KADUNA ROAD	2092
44	GAURAKA	5035
44	YANGOJI	504
44	TUNGA MAJE	5040
44	KWALI	499
44	WUSE	5041
44	DEPOT	5033
44	SHEDA	2096
44	LAMBATA/GURARA	501
44	TAFA	2097
44	MADALA	5037
45	DADIN KOWA/KUFFANG	3587
45	LANZAI	3620
45	TUDUN WADA/SECRETARIAT/HWOLSHE	3645
45	POLICE COLLEGE KURU	266
45	FOBUR	257
45	GINDIRI	1396
45	FARIN GADA	3594
45	DORUWA	256
45	TUDU WADA	3644
45	RUKUBA BARRACK	3637
45	BEJIN-DOKO	3579
45	MARARABA JAMA'S	3628
45	TUNKUS	1423
45	ANGWARE	1386
45	LAKUSHI	1408
45	LAMINGA	3619
45	NARAGUTA	1415
45	K-VOM	260
45	GUMAU VILLAGE	1398
45	LERE	2282
45	WASE	1424
45	DEOMARK	3588
45	RAFIKI	267
45	RAYFIED/MAI ADIKO	3632
45	CHERRY HILL	3586
45	DUH	1391
45	JANTA	3610
45	RIKKOS/NASSARAWA	3635
45	GANAROP	1393
45	BINCHI	3580
45	KANKE	1403
45	UNIJOS/UNGWAN/KWARARAFA/KASUWA	3647
45	ALHERI/UTAN	3567
45	GANGARE/DILIMI	3597
45	HAWAN KIBO	1400
45	SABON LAYI/KWASHANGWA	3638
45	GWORI	1399
45	LAMINGO	262
45	MISTALI VILLAGE	3630
45	GIRING/DOGON KARFE	3600
45	ANGULDI	255
45	DOGON AGOGO/SABON PEGI	3590
45	GANAWURI	1394
45	PANKSHIN	1416
45	SATIZEN QUARY	270
45	NNPC DEPOT	2291
45	 ZABOLO	3650
45	DU	3592
45	BARKIN-LADI	1387
45	BAGUDU	3572
45	ZOLOGICAL GARDEN/HOUSE OF ASSE	3652
45	RIFIZA	3634
45	GARKAWA	1395
45	MANGU	1412
45	JAGINDI	3609
45	HEIPANG	258
45	DAKWAK	1388
45	KERANG	1404
45	LANGTANG NORTH	1409
45	KADARKO (WUSE)	3614
45	TORO	273
45	BARIKIN LADI	3576
45	GWAUTU	3603
45	TENTI	3642
45	ZOLOGICAL GARDEN/HOUSE OF ASSE	3653
45	GYEL	3604
45	UNGUWAR KWANO/KAMFARI	3646
45	KURA FALLS	1405
45	KWALLA	1407
45	KURGWI	1406
45	BARAKIN LADI	3573
45	FAJU	1392
45	BARNAWA	3577
45	DUCHI	1390
45	MUSHERE	1413
45	HOUSING ESTATE/LOCAL GOVERNMEN	3606
45	APATA/SEMINARY/KATAKO	3569
45	HOUSING ESTATE/LOCAL GOVERNMEN	3608
45	JEBBU BASSA	3611
45	NIPOST G.P.O/C.B.N	3631
45	RAYFIELD 	3633
45	SHEMDAM	3641
45	GUMAU	3601
45	MARAGUTA	3627
45	BISICHI	3581
45	MISTA-ALI	265
45	BADEGI	3570
45	LIBERTY DAM/BRITISH AMERICA	3623
45	MABUDI	1411
45	AMPANG WEST	1384
45	KABONG	3613
45	GANAROPP	3595
45	KWAL	3617
45	ANGLO JOS	3568
45	ZALLAKI	1426
45	JOS	3612
45	FADAU KERSHIN	3593
45	RIYOM	1419
45	ROCKHAVEN	3636
45	HASKE	3605
45	YELWA SHENDAM	1425
45	DONG	3591
45	PANYAM	1417
45	TILDEN FULANI	272
45	BADIKO	3571
45	KATAKO	3616
45	BARIKI LADI	3575
45	LANGTANG SOUTH	1410
45	SANGA	1421
45	GIDIN DORUWA	3599
45	GUT	3602
45	CHARANGI	3585
45	HOUSING ESTATE/LOCAL GOVERNMEN	3607
45	CHAFE	3584
45	VOM	274
45	SAMILAKA	3639
45	YEWA SHENDAM	3649
45	BUKURU	3583
45	SAMINAKA	1420
45	RUKUBA	269
45	GENGERE	3598
45	GUMAU JUNCTION	1397
45	DENGI	1389
45	 ZAWAN VILLAGE	3651
45	MARABAN JAMA’A	263
45	BOKKOS	3582
45	MANGUN	3626
45	MIANGO	264
45	RIZEK	268
45	SANGA LGA	3640
45	UNIJOS/UNGWAN/KWARARAFA/KASUWA	3648
45	SHENDAM	1422
45	SHERE HILLS	271
45	M.N.P.C. (DEPOT)	3624
45	AMPER	1385
45	LARANTO	3621
45	LERE LGA	3622
45	KADARKO	2273
45	KANAM(DENGI)	3615
45	KWANDE	3618
45	BASSA	554
45	JENGRE	1401
45	GWANTU	2256
45	MIKANG	3629
45	NAMU	1414
45	DOEMARK	3589
45	GANGARE	3596
45	KWALL	261
45	TOWNSHIP STADIUM	3643
45	KANAM	1402
45	BAU	3578
45	QUAN-PAN	1418
45	KURU	259
45	MADO VILLAGE	3625
45	BARDAWA	3574
46	BARDAWA	3660
46	ABKPA	3655
46	KACHIA	1440
46	HAYIN BANK	3680
46	B/GWARI	1428
46	KURMI MASHI	3710
46	GONI GARA	3677
46	KAURA    	3700
46	NO MAN'S LAND	3731
46	ZONKWA	3762
46	DALLET BARRACKS	3671
46	UNGWAR SHANU	3755
46	PAMBEGUA	3735
46	KWAGIRADA	3713
46	NAGARTA	3725
46	NNPC	3730
46	IDON	1436
46	MARABA RIDO	3720
46	ZANGO KATAF	3761
46	KUFANA	3708
46	KWOI	1446
46	KAKURI	3696
46	KOFAR GAYA	3705
46	K/MAGANI	1439
46	HANWA	3679
46	BARNAWA	3662
46	TUDUN WADA	3748
46	TUDUN NAPAWA	3746
46	KAJURU	3695
46	DOKA V/LAGE	3672
46	BADIKO	3659
46	RIGASA	3738
46	UDAWA	1449
46	KWANGILA	3714
46	KAKURI	3697
46	UNGWAR T.V	3757
46	JAJI	1437
46	TUDUN NUPAWA	3747
46	CHIKALI	3668
46	UNGWAR KANAWA	3754
46	PALACE	3734
46	UNGWAR DOSA	3752
46	NASSARAWA	3727
46	KETERI	3703
46	BARDIKO	3661
46	BURUKR	1429
46	AFAKA	1427
46	M/JOS	275
46	KM 36 OPEN HEAVEN	3704
46	SABON GARI	3741
46	JERE	1438
46	KADINT'L SCHOOL	3692
46	DANKANDE	1431
46	KURMI MASHI	3711
46	MARABA RIDO VILLAGE	3721
46	BIRNIN GWARI	3666
46	RIGACHIKUN	3737
46	UNGWAR GWARI	3753
46	KURMIN JIBRIN	3712
46	MANDO	3719
46	NDA	3728
46	KALAJANGA	3698
46	KAD INT?L AIRPORT	3691
46	MANCHOK	1447
46	AHMADU BELLO WAY	3657
46	BADIKO	3658
46	KUBACHA	3707
46	KAWO	3702
46	MANDO	3718
46	YELWA	3759
46	ZONKWUA	1450
46	IKARA LGA	3684
46	DOKA	1432
46	CHIKUN	1430
46	KASUWAN MAGANI	3699
46	ABAKPA	3654
46	IGABI	3682
46	GODO GIDO	1435
46	SARKIN PAWA	3743
46	GYALLESU	3678
46	S/PAWA	1448
46	TELEVISION	3744
46	UNGWARIMI	3758
46	GIDER WAYA	1434
46	DOKA VILLIAGE	1433
46	CHUKUN	3670
46	BARNAWA G.R.A	3663
46	TSUGUGI	3745
46	G.R.A	3674
46	MAKERA	3715
46	UNGUWAR KANAWA	3751
46	KADUNA	3693
46	NIGERIAN AIRFORCE BASE	3729
46	UNGWAR SUNDAY	3756
46	MARMARA	3722
46	ZAGON KATAF	3760
46	GIDANWAYA	3676
46	KOFAR JATAU	3706
46	UNGUWA MA'AZU	3749
46	MALALI	3716
46	RIGASA VILLAGE	3740
46	FADIA	3673
46	CHIYODA	3669
46	KAGONKO	1443
46	KAFANCHAN	1442
46	NYSC CAMP\t	3733
46	SABON TASHA	3742
46	BURUKU	3667
46	JUNCTION RD.	3688
46	KUJAMA	3709
46	JABA	3685
46	KUFENA	1445
46	KABALA WEST	3690
46	HAYIN DOGO	3681
46	KAGARKO	3694
46	KAGORO	1444
46	RAILWAY QUATERS	3736
46	AHMADU BELLO STADIUM	3656
46	RIGASA NORTH	3739
46	BARNAWA VILLAGE	3664
46	KAD AIRPORT	1441
46	UNGUWAN KANAWA	3750
46	GASKIYA CORPORATION	3675
46	IGABI LGA	3683
46	KAURE LGA	3701
46	NTI	3732
46	N.D.A	3724
46	NARAYI	3726
46	BARUKU	3665
46	MANCHOCK	3717
47	KAURU	2224
47	BAKORI	2218
47	GWARABE	5222
47	HUNKUYI	549
47	KAFUR	5223
47	WUSASA	5228
47	DANJA	2246
47	DAKACE	2220
47	DANDUME	2221
47	KANKARA	2277
47	SAMARU	5226
47	ZARIA	5230
47	BASAWA	2219
47	SAYE  VILLAGE	5227
47	SABONGARI	5225
47	SHIKA	550
47	MAKARFI	2225
47	PAMBEGUA	2226
47	SOBA	2229
47	DAKACHI	5221
47	FASKARI	2222
47	ZANGODAURA	5229
47	FUNTUA	595
47	SABUWA	2227
47	SAYE	2228
47	GIWA	548
47	IKARA	2223
47	MALUMFASHI	2286
48	IPOLE ILORO	2609
48	IKERE EKITI	2594
48	AZIKWE STADIUM	2570
48	AYETORO	699
48	IJERO EKITI	2592
48	IKOYI 2	2600
48	IJAN	710
48	ILAWE	717
48	EMURE	701
48	OMUO	727
48	ARAROMI	2567
48	OKE IRU	2623
48	IDO EKITI	2584
48	ORA	82
48	IKOGOSI	714
48	AYETORO EGBADO	2569
48	EFON ALAYE	2573
48	OYE	730
48	federal polytechnic	2578
48	IGBARA ODO EKITI	2587
48	ISE-EKITI	2611
48	MINE-CAMPU AREA	2616
48	OYE EKITI	2633
48	OSI	2316
48	OTUN-EKITI	2631
48	IKORO	716
48	ORIN-EKITI	2629
48	USI-EKITI	2636
48	EPE	702
48	AISEGBA	694
48	OKE IGBALA	2622
48	ILUDUN	718
48	AJOGBEJE QUATERS	2560
48	IDO	704
48	OTUN	729
48	HAVANA QUATERS	2581
48	idolofin	2586
48	isolo	2612
48	AGBADO EKITI	2558
48	IBALE IKOYI	2582
48	ODO ISE	2618
48	ILUDUN-EKITI	2606
48	OMUO EKITI	2626
48	MOSHUDI	2617
48	IGBARA ODO	706
48	ARAMOKO	695
48	IGBOLE	707
48	AWO	696
48	ILUMOBA	719
48	USI	732
48	IFAKI	81
48	GRA	2580
48	IYIN  EKITI	2614
48	FEHINTOLA ESTATE	2579
48	TEMIDIRE	731
48	IKOYI IKORO	2601
48	OKEMESI	726
48	IJAN EKITI	2591
48	IKERE	713
48	IGOGO	709
48	ILOKA	2603
48	ISE	2269
48	ISABA	2610
48	AYEDE	697
48	ADO EKITI	2557
48	ERUWA	2576
48	IFISIN	705
48	ONITCHA	2627
48	IBARAM AKOKO	2583
48	USIN	2637
48	IGEDE	708
48	IYEE	723
48	cocoa dev. unit area	2571
48	STADIUM	2635
48	IKOGOSO	2595
48	ODE	725
48	AGBADO	693
48	ODO ORO	2621
48	ITAPA	722
48	ARAROMI	2565
48	ITAJI	721
48	ODO OJA	2619
48	ANAYE	2563
48	AISEGBA EKITI	2559
48	amuniklo	2562
48	EFON	700
48	ODO OJA	2620
48	IKORO EKITI	2598
48	ASIN	2568
48	ERIO	703
48	IYIN	724
48	ARAROMI	2566
48	IJESA ISU	712
48	AYEGBAJU	698
48	IWOROKO	2613
48	omodowa	2625
48	OSIN-EKITI	2630
48	AYEE	80
48	IJERO	711
48	AMOYE GRAMMER SCHOOL	2561
48	IGEDE EKITI	2590
48	IKOLE GENERAL HOSPITAL	2597
48	falegan estate	2577
48	ilokun	2604
48	ORIN	728
48	ILOGBO	2268
48	IGBONNA	2588
48	IJOKA QUARTERS	2593
48	IKOLE	715
48	IKOLE EKITI	2596
48	ARAMOKO EKITI	2564
48	OKEOSUN	2624
48	ILOTIN	2605
48	ISAN	720
48	ONWARD	2628
48	ELEKOLE'S PALACE	2575
48	IKWO(FUNI)	2602
48	IMIKAN	2608
48	IKOYI 1	2599
48	KAJOLA QUARTERS	2615
48	ILUPEJU-EKITI	2607
48	OTUNJA	2632
48	EJIGBO	2574
48	EFFON  ALAYE	2572
48	ST. PETERS	2634
48	IDOGUN	2585
49	MASAKA	75
49	KURUDU	679
49	ADO	661
49	GOSHEN CITY	72
49	GWAGWA	670
49	KUGBO	678
49	WUSE ZONE 4	2552
49	LIFE CAMP	2518
49	NYANYA	2534
49	MODEL CITY	683
49	GAUBE KUJE	71
49	PANDA	689
49	ELEKO	2482
49	KARSHI	73
49	PYAKASA	690
49	ALAGUNTAN COMMUNITY	2472
49	KABUSA	2503
49	NYANYA	2535
49	ORITA MARUN	2538
49	GARKI AREA 1	2485
49	GADAGBUKE/NAKUSE	666
49	MARARABA	2525
49	ASOKORO	2474
49	ODOMALA	2536
49	UNIABUJA MAIN IDDO	692
49	INTERNATIONAL AIRPORT	2501
49	USHAFA	78
49	WUSE ZONE 1	2549
49	LUGBE	682
49	GARKI AREA 7	2490
49	KAGINI	674
49	JABI	2502
49	SAUKA	2541
49	IDDO(UNIABUJA)	2497
49	KUCHINGORO	2513
49	KUCHIKAU	74
49	NASARAWA	684
49	LOKOGOMA	681
49	DAKWA	70
49	NASSARAWA TOTO	2533
49	NASSARAWA TOT	2532
49	KUJE	2514
49	BASSA	2243
49	TOTO	2546
49	F.C.T.	2483
49	MARABA	2524
49	ROYAL GARDEN ESTATE	2539
49	GARKI AREA 11	2487
49	KAFE	2505
49	DEI-DEI	2480
49	KEFFI	573
49	NASARAWA TOTO	685
49	ASO ROCK	2473
49	GARKI AREA 8	2491
49	AUTA BALEFI	2476
49	BOLORI	2478
49	ONE MAN VILLAGE/KORODUMA	687
49	GARKI AREA 10	2486
49	IGBONLA EPE	2500
49	LOWER USMAN DAM	2519
49	GALADIMAWA	668
49	BWARI	68
49	CENTRAL BUSINESS DISTRICT	2479
49	UTAKO	2547
49	AKODO	2471
49	GWOSA	671
49	BERGER GARDEN ESTATE	2477
49	OROZO	688
49	MAITAMA	2522
49	WUSE ZONE 5	2553
49	ABUMET/KADO	2470
49	SEA SIDE ESTATE	2542
49	LOKO	680
49	NAKUSE	2530
49	OLORA PALACE AREA	2537
49	GITATA	669
49	NEW NYANYA	686
49	DUTSE ALHAJI	2481
49	KARSANA	676
49	WUSE	2548
49	GUDU	2493
49	CHITA	663
49	MABUSHI	2520
49	KARIMO	675
49	AUTABALEFI	67
49	KUBWA	2511
49	GARKI AREA 2	2488
49	PEGI KUJE	76
49	THREE ARMS ZONE	2545
49	ASOKORO	2475
49	KARU (NEW)	2507
49	CAPITAL SCIENCE KUJE	69
49	GARKI	2484
49	MARARBA	2526
49	WUSE ZONE II	2556
49	GALADIMA	667
49	MAITAMA	2521
49	SHINKAFI	2543
49	ABUGI	2468
49	MASHI	2527
49	WUSE ZONE 7	2555
49	SABON LUGBE	691
49	GWAGWALADA	2494
49	JAHI	672
49	KATAMPE	2510
49	GWARIMPA	2495
49	KARU	2506
49	kuchigoro	677
49	UKE	77
49	MOJODA	2528
49	IDU	2498
49	SULEJA	2544
49	WUSE ZONE 3	2551
49	ABUJA	2469
49	DAWAKI	665
49	KARU (OLD)	2508
49	JIKWOYI	673
49	NASSARAWA	2531
49	WUSE ZONE 2	2550
49	IBEJU LEKKI	2496
49	IDU YARD	2499
49	KURNA	2515
49	MAKERA	2523
49	USMAN DAM	79
49	GIDAN MANGORO	2492
49	WUSE ZONE 6	2554
49	LANGBASA	2517
49	SAUKA	2540
49	DAKWO	664
49	GARKI AREA 3	2489
49	KADO	2504
49	ALETA	662
49	KWA FALLS	2516
49	NAI AIRPORT 	2529
50	NNPC	2289
50	IHUGE 	4027
50	ITAOGOLU	4034
50	OBI	2295
50	BURUKU	1571
50	GOBIRAWA	4018
50	ITELE(AYETORO)	4036
50	Hudco Quarters	4022
50	KONSHISHA	1580
50	ZAKIBAM	4086
50	No. Cross	4058
50	45 NAF HOSP	1559
50	Army Barracks	4003
50	TSE AGBARAGBA	1601
50	YANDEV	4085
50	OWUKPA	1600
50	TALKAMAWA	4075
50	GETSO	4017
50	UKUM	4078
50	GWER WEST	4020
50	ADOKA	1564
50	GUMEL	4019
50	ITAS	4035
50	Ella Market	4007
50	OKPOGA	1596
50	ABWA	1562
50	NASME	1588
50	GUMA	1574
50	MKD TOLGATE	1586
50	Ahmadu Bello	3997
50	MKD AIR PORT	1585
50	Federal Low	4012
50	AMILE	4001
50	Eupi-New Layout	4010
50	NAKA	1587
50	OBARIKE-ITO	4061
50	Local Government Clinic	4045
50	Wadata	4083
50	AKANKPA	3999
50	GBAJIMBA	4015
50	OTUKPA	1598
50	USHONGO	4081
50	Rail Way Station	4070
50	LESSEL	1582
50	IKPAYONGO	4029
50	AGASHA	3996
50	Ministry Of Works	4053
50	ADO	3995
50	ZAKIBIAM	1607
50	OBAGAJI	1589
50	TARAKU	4076
50	ISU	4032
50	MBAAKON	4052
50	TSEKUCHA	4077
50	AUGIRI	4005
50	IGHU	1576
50	AGATU	1565
50	General Hospital	4016
50	Wurukum	4084
50	OGODUMU	1591
50	UGBA	1602
50	KATSINA ALA	4042
50	KASTINA-ALA	4041
50	APA	1569
50	NORTH BANK	4059
50	SHIYAR KALGAWA	4074
50	AKPAHER	1566
50	UPU. Rd	4080
50	Post Office	4069
50	Unijos Campus	4079
50	OJU	1595
50	ABINSE	1561
50	Eupi	4009
50	IGA	1575
50	Kokoroo	4043
50	MKAR	4054
50	KAIMA	4040
50	GBAJIMBA	4014
50	OJANTELE	1594
50	AKWAI	4000
50	72 BATTALION	1560
50	OHIMINI	1592
50	ALIADE	1567
50	IGUMALE	1577
50	AJEBO	3998
50	Federal Housing Area	4011
50	ISONYI	4031
50	JATO AKA	1578
50	OTURKPO   	4067
50	OYUKPO	4068
50	NNPC DEPOT	4057
50	OOL	4064
50	OTUKPO	1599
50	OROKAM	4065
50	Rice Mills	4071
50	UTONKON	4082
50	ASUKUNYA	4004
50	BUNKUBE	4006
50	KATSINA-ALA	1579
50	UGBOKOLO	1604
50	AYIN	1570
50	JESSE	4038
50	OTOBI	4066
50	Ogwonogba	4063
50	DAUDU	1572
50	OGBADIBO	1590
50	G.R.A	4013
50	New Market	4056
50	GBOKO	1573
50	MARADUN	4051
50	WANNUNE	1606
50	NORTH BANK	4060
50	IZOMBE	4037
50	LOGO	1583
50	APIR	4002
50	KWADE	4044
50	LUGA	1584
50	JOGA	4039
50	KORINYA	1581
50	MAKURDI	4047
50	OJAKPAMA	1593
50	MANI	4050
50	EMIRS PALACE	4008
50	ANKPA	1568
50	Ochido's Palace	4062
50	ONYAGEDE	1597
50	ADIKPO	1563
50	RURAL HEALTH CENTER	4072
50	UGBOJU	1603
50	Sabon Gari	4073
50	MAKUNKELE	4046
50	MKD AIRPORT	4055
50	VANDEIKYA	1605
50	High Level Ass. Vill.	4021
50	IDANRE	4024
50	UNIVERSITY OF AGRICULTURE	298
50	IHUGH	4028
50	ICHAMA	4023
51	AHIA WOKOMA	1868
51	OGU BOLO	4928
51	OKIRIKATOWN	4930
51	NEW LAYOUT	4919
51	TOMBIA	2322
51	AMUAJIE	1894
51	EREKU	1967
51	UBITE	2049
51	RUMUJI	469
51	DIOBU MILE 4	4896
51	NDELE	4916
51	KALAIBIAMA	1991
51	AKWA	1880
51	RUMUOKWUOTA	4950
51	DEKEN	1928
51	ELEM-AMA	1958
51	ODEKPE	4925
51	BANGHA	1905
51	DIOBU MILE 3	4895
51	RUMUODARA	4948
51	AKIKWO	1873
51	BERA	1908
51	EEKEN	1941
51	IFOKO	1976
51	BIARA	1910
51	EREMA	1968
51	EDUGBERI	1940
51	OGU	2024
51	AGBAOGA	1864
51	OCHOMA LAYOUT	4924
51	AKANI	1871
51	AMAJI	1886
51	ENGENI	1966
51	WAKAMA	2060
51	EGBEDA	2248
51	ONIKU	2031
51	IGWURUTA-ALI	1977
51	ASARI TORU	4890
51	KPOR	1994
51	ONNE	2032
51	USOKIM	2059
51	AGADA	1857
51	BETTER LAND	1909
51	ABARO	1849
51	FUCHE	1971
51	ISAKA	4909
51	DEMA	1929
51	EGBELEMA	1944
51	ENEKA	1965
51	OLD GRA	4933
51	ABALAMA	1847
51	OBUBURU	2018
51	EGBELU	1945
51	IKURU	1980
51	EGBPRMA	1948
51	MAGBUOBA	4913
51	UBETA	2047
51	UMUCHI	2053
51	OGBAKIRI	2021
51	TAI	4953
51	BAKANA	1904
51	AKWUKOBI	1881
51	UMECHEM	2052
51	AMININGBOKA	1892
51	ELIETA	1960
51	NEW-OL	2008
51	BOMU	1913
51	ABUA/ODUAL	4877
51	AGBANDELE	1863
51	DIOBU MILE 1	4893
51	IMERE	1983
51	SOGHO	2042
51	WILYAAKARA	2061
51	ASE-AZAGA	1901
51	EGBOLOM	1946
51	KONO	1993
51	EBUGUMA	1937
51	CHOBA	1922
51	RUMUIBEWKE	4943
51	AGAH	1858
51	AGBO/AKOGBOLOGBA	1865
51	DEEYOR	1926
51	AKINIMA	1874
51	TRANS AMADI	4955
51	IBEWA	1974
51	EKPE-MGBEDE	1953
51	BOUE	1915
51	SOKU	2043
51	ADANTA	1854
51	BARAKO	1906
51	OYIGBO	2036
51	OWAZZA	2035
51	UBARAMA	2046
51	ABULOMA	4878
51	ELEKAIHIA	4899
51	EDEOHA	1939
51	EAGLE ISLAND RUMUEME/OROAKWO	4898
51	MBUNTA	2001
51	BUAN	1916
51	ITU	2272
51	RUMUAPARALI/RUMUALOGU/O	4941
51	EGBONMA	1947
51	OBEAMA	4921
51	RUMUAPU	4942
51	RUMUOMASI	4951
51	EGITA-AKABUKA	1949
51	ASA	4889
51	AMOROTA	1893
51	OKWUZU	2027
51	KRAKRAMA	1995
51	KREIGANI	1996
51	APANI	1900
51	ESALA	1969
51	EKPEME	1952
51	ATABA	1902
51	ETCHE	1970
51	OGBA/EGBEMA	2020
51	AMAPA	1889
51	EDECHA	1938
51	AHOADA EAST	4881
51	DIOBU	4892
51	UMUDIOGA	2054
51	ALUU	464
51	TERE-KURU	2044
51	FOT/FLT/FZE/ONNE/PORT	4903
51	NGBERE	2009
51	BUGUMA	1917
51	ODAGA	2019
51	YEGHE	2062
51	AKUKUTORU	4885
51	CHIO	1920
51	AMALEM	1888
51	EKUCHE	1954
51	ABUA	1852
51	MGBO	2004
51	RUMUODOGO	470
51	AMA	1885
51	OGBEOGENE	2022
51	BAEN	1903
51	UPATABO	2058
51	UMUORIEKE	2057
51	RUMUIKPE	4944
51	ALIMINI	4886
51	KOLOKUMA	4912
51	OBUAMA	2017
51	IWOAMA	1989
51	GOKANA	1972
51	ICHOMA	1975
51	WOJI	4958
51	AKARAMIMI	1872
51	OMOGHO	4936
51	DEGEMA	1927
51	AKINIRI	1875
51	ISIOKPO	1987
51	TERE-UE	2045
51	OKPOSI	2312
51	EBERI	1934
51	IWOKIRI-AMA	1990
51	EKEREKANA	1950
51	EGAMINI	1943
51	OBIRIK	2014
51	BORI KORI	4891
51	OKIRIKA TOWN	4929
51	AGWARA	2236
51	IPO	4908
51	OMUOKO/OMUOKIRI	4938
51	ANGULAMA	1897
51	UBIMA	2048
51	AHI OGBAKIRI	1867
51	CHOKOCHO	1923
51	RUMUKRUESHI	4945
51	ANDONI	1896
51	OZUZU	2037
51	OBITE	2015
51	ABISSA	1850
51	EBOAHA	1936
51	OGBOGU	2023
51	ANYAMA	2237
51	DIBIRIGA	1931
51	MGBEDE	2003
51	AKABUKA	1870
51	AHOADA EAST/WEST	1869
51	NDOKI	4917
51	TRANSAMADI	4956
51	AGUYA	1866
51	EKUNCHARA	1955
51	OMAGWA	4935
51	RUMUAKPU	586
51	SAMA	2041
51	EBIRIBA	1935
51	IGBODO	2262
51	ILOMA	1982
51	EMOHUA	4902
51	OKOROBO-ILE	2026
51	AFAM/OYIGBO	4879
51	DIKIBOAMA	1932
51	AGANOFOR	1859
51	B-DERE	1907
51	OGBA	4926
51	ELE-OGU	1959
51	KHANA	1992
51	CHOKOTAA	1924
51	IKWERRE	4907
51	AGGA	4880
51	BUKUMA	1918
51	OLUM	2029
51	PORT HARCOURT RD	4940
51	UMUIGWE	2055
51	ELELENWO	4900
51	MOGHO	2006
51	OBO	2016
51	TOWN	4954
51	OMUOKO	4937
51	RUMULUEMENI	4947
51	OKEHI	2303
51	IMOGU	1984
51	OGBOGORO	4927
51	KDERA/OGONI	4911
51	OPOBO	2033
51	ANAKPA	1895
51	RUMUOSI	4952
51	ISIODU	1986
51	AKPUTA	1879
51	AGBAKOROMA	1861
51	DEME-UE	1930
51	D-LINE	4897
51	ISUA	1988
51	SAKPONWA	2040
51	DIOBU MILE 2	4894
51	AMAKU	1887
51	OMUMA	2315
51	MINIMA	2005
51	UMUEBULE	4957
51	ALAKAHIA	1883
51	NKORO	2012
51	UEGURE	2051
51	KUNUSHA	1998
51	OLAM-NKORO	2028
51	RUMUAKPU	587
51	UMUOGA	2056
51	AMARAKE	1890
51	IBAA	1973
51	IGWA LAYOUT	4906
51	IWOFE	4910
51	OLD TOWNSHIP	4934
51	IKPO	1978
51	AKPABU	1877
51	OKIRIKA	2025
51	ALINSO-OKENU	1884
51	EMUOHA	1964
51	IKWATA	1981
51	OBIGBO	4922
51	RUMUKWURUSI	4946
51	AKPARA	1878
51	NGOLOLO	2011
51	RUMUEKINI	467
51	GARRISON	4904
51	QUEENS TOWN	2038
51	ACHARA	1853
51	AGBADAMA	1860
51	ELOK	1961
51	MBIAMA	1999
51	EMELOGO	1962
51	IKPOKIRI	1979
51	NGO	2010
51	AMATAMUNO	1891
51	EKPE- AGGAH	1951
51	CHIWOKINWERE	1921
51	EFEBIRI	1942
51	MBUAMA	2000
51	MBIAMA RD	4914
51	OBAGI	4920
51	OPUM	2034
51	UDOHA	2050
51	OPOBO NKORO	4939
51	AHODA WEST	4882
51	AFAM	1856
51	OKRIKA	4932
51	AFARA	2231
51	AKPAJO	4884
51	NEW GRA	4918
51	ELELEWO	4901
51	NCHIA	4915
51	OKOGBE	4931
51	MEMBE	2002
51	BORI	1914
51	KULA	1997
51	NDONI	2007
51	ALO-MINI	4887
51	AKOH	1876
51	BODO	1912
51	BUNDELE	1919
51	ELELE	1956
51	ELELE ALIMINI	1957
51	NONWA	2013
51	DIMAMA	1933
51	IRIEBE	1985
51	ABADA	1846
51	IGWURUTA	466
51	AMADI FLAT	4888
51	ALA-AHOADA	1882
51	OMOKU	2030
51	ABONNEMA	1851
51	BILLA	1911
51	RUMUEKPE	468
51	RUMUOKORO	4949
51	ABARIKPO	1848
51	ANWUNIGBOKOR	1898
51	IGBO-ETCHIE	4905
51	DANKIRI	1925
51	ELEME	465
51	OBIGBO	4923
51	ZAAKPON	2063
51	ABONEMA/AKUKUTORU	4876
51	ANYU	1899
51	AGBALU	1862
51	EMEZI	1963
51	SAGAMA	2039
51	ADIAI-OBIOFU	1855
51	AKINIMA AHOADA WEST	4883
51	UMUNACHI	2323
52	DBN CONSTRUCTION SITE	2894
52	NLNG RESIDENTIAL AREA	980
52	BOUYGUES CONSTRUCTION SITE	975
52	BONNY	2893
52	NLNG CONSTRUCTION SITE	979
52	JULLIUS  BIGGER	978
52	PETERSIDE COMMUNITY	135
52	FINIMA	977
52	JULLIUS BIGGER	2896
52	BOROKIRI TOWN	132
52	JULIUS BERGER	2895
52	DBN  CONSTRUCTION SITE	976
52	OLOMA COMMUNITY	134
52	GREENS TOWN	133
52	ALCON CONSTRUCTION SITE	974
52	ABALAMABIA	973
53	NTEJE	578
53	UMUDIOKA	124
53	OFEMMILI	866
53	ENUGU-UKWU	2803
53	AKPONMU	2798
53	IGBARIAM	559
53	MBAUKWU	117
53	ENUGWU-AGIDI	862
53	EBENEBE	112
53	UMUAWULU	123
53	AMANSEA	861
53	EZINATO	113
53	URUM	126
53	ISIAGU	115
53	AGULU	2233
53	NTOKOR	2809
53	ABBA	551
53	UGBENU	868
53	NANDO	575
53	AWKA	2800
53	AMANUKE	111
53	NISE	121
53	UKWULU	122
53	NAWGU	119
53	UGBENE	867
53	IFITEDUNU	2805
53	ABAGANA	109
53	Izuocha Layout	2807
53	MGBAKWU	118
53	NIMO	120
53	ENUGWU-UKWU	863
53	UKPO	2811
53	Asu Tech Area	2799
53	IFITE-DUNU	114
53	AWKUZU	552
53	Industrial Layout	2806
53	UMUNNACHI	125
53	ISUANIOCHA	116
53	Obunagu Vill	2810
53	Cemestry Area	2801
53	NAWFIA	864
53	ENUGU-AGIDI	2802
53	MBAUKWU (AKWA)	2808
53	NIBO	865
53	High Court	2804
53	ACHALLA	110
53	AGULU UZIGBO	2797
54	AKWA-UKWU	1660
54	AKPO	4431
54	NENI	1672
54	AMCHI	4434
54	UMUCHU	1681
54	NDIOKPALA-EZE	4443
54	OZUBULU	4458
54	ORAUKWU	4454
54	ULA	4461
54	IKENJA OKIJA	4438
54	ADAZI- NNUKWU	1655
54	AGULU	2234
54	UKPOR	1679
54	ICHIDA	1668
54	OGBOJI	4451
54	URUAGU	4466
54	ADAZI-ANI	1656
54	ULI	1680
54	AGUATA	1657
54	AWKA-ETITI	4435
54	ACHI	4428
54	ORAIFITE	1677
54	NNEOKWA	4448
54	OJOTO	1675
54	OJOTO OFIA	4452
54	OTOLO	360
54	OWENREZUKALA	4457
54	NNENWE	4447
54	EKWULOBIA	1665
54	ISUOFIA	4440
54	OZUBLU	361
54	AMAOKPALA	4433
54	UFUMA	4459
54	AMORKA	1663
54	IHEBOMSI	1670
54	NNOBI	1674
54	UMAKULU	4462
54	OSUMEYI	4456
54	EKWULUMMIRI	1666
54	UMUZE	4465
54	IDEANI	4436
54	OKOFIA	359
54	AKUKU OBA	4432
54	AMICHI	1662
54	IGBO-UKWU	4437
54	AWKA-ETIT	1664
54	NANKA	4441
54	OFUMA	4450
54	OKO	2305
54	UKE	4460
54	UGA	1678
54	NKPOLOGWU	1673
54	OKIJA	1676
54	OREARI	4455
54	ADAZI-ENU	4429
54	UMUDIM	4463
54	AJALLI	1658
54	NDIONWU	4444
54	NGBOLOKWU	4445
54	UNUBI	1683
54	IGBOUKWU	1669
54	ALOR	1661
54	UMUEZE	4464
54	NDIKELIONWU	4442
54	IHIALA	1671
54	ADAZI-NUKWU	4430
54	UTU	1684
54	EZIOWELLE	1667
54	ISULO	4439
54	AKOR	1659
54	OKOFIA  OTOLO	4453
54	UMUNZE	1682
54	NKPOLOGU	4446
54	ACHINA	1654
54	NNEWI	4449
55	OWASHI NKU	4555
55	Awka Rd	4505
55	EZINIFITE	4509
55	OGBUNIKE	1746
55	ABBA	4491
55	OTUOCHA	372
55	UMUOBA OTUOCHA	4567
55	UMUNAYA VILLAGE	4565
55	NKPOR MARKET	4526
55	UMUOJI	375
55	Ose I	4552
55	AAWARA	4488
55	ASAA	4502
55	OHITA	4543
55	NKWERRE	4529
55	Onyeabo St	4549
55	OSHITA	4554
55	ONICHA UGBO	4546
55	Amafor	4498
55	UMULERI	373
55	Odume Layout I	4538
55	Obompa	4532
55	UBULU 	4558
55	NRI	4531
55	UMUOBA AWAM	1752
55	NANKA AWKA	4520
55	Uper Iweka	4570
55	OSAMALE	4551
55	AWKA	4504
55	OBEAGWEG 1	1742
55	OBOSI	4533
55	NANDO	576
55	OGBARU	4540
55	IDU MUJE	4513
55	MPUTU	1739
55	AMICHI	4500
55	ORAMA -ETITI	1749
55	Agulu  A	4493
55	MDI 	4517
55	GRA III	4512
55	NNENWE	4530
55	OGWU EPELE	1747
55	ONICHA OLONA	4545
55	UMUNYA	374
55	AKILI OGIDI	1733
55	ANYAMELUM	1737
55	NKWELLE EZUNAKA	370
55	OSOMALLA	1750
55	Iweka Rd	4515
55	IYIOWA ODEKPE	369
55	Odume Layout II	4539
55	NGURU	4522
55	AWADA OBOSI	368
55	Akuzor Rd	4495
55	Akuzor Village	4496
55	OGIDI	4541
55	AWKUZU	553
55	NADO	4519
55	AKPAKA	1735
55	GRA I	4510
55	OCHECHE UMUODU	4534
55	Uruowulu Village	4571
55	NKPOR-AGU	4527
55	OMOR	1748
55	AKILI OZIZA	1734
55	IFITE -OGWARI	1738
55	IGBARIAM	560
55	Ose II	4553
55	AKATA-ORU	4494
55	EJIOKU	4507
55	Odoakpu	4537
55	AMAWBIA	4499
55	NGWO	4523
55	Oguta Rd	4542
55	EKWU OHA	4508
55	ODAKPU	4535
55	IFITE-UKPO	4514
55	OBEAGWEG 2	1743
55	ASABA	4503
55	ONITSHA	4548
55	UKPOR AKPU	4560
55	UMUIKWU ANAM	4563
55	ODEKPE	4536
55	OGBAKUBA	1745
55	ONICSA UKU	4547
55	Zik A	4572
55	NKWELE-OGIDIKA	4528
55	ATANI	367
55	NZAM	1740
55	UMUNAKWO	1751
55	ABACHA	4489
55	NTEJE	579
55	UMUNAYA EXPRESS	4564
55	Umuota	4568
55	Niger Bridge Head Rd	4524
55	ANAWBIO	4501
55	Ububa	4557
55	NSUGBE	371
55	Umusiome Ibo	4569
55	ABAJA	4490
55	ABATETE	365
55	New Market Rd	4521
55	MMIATA	4518
55	UMUNACHI	589
55	UKPULU	4561
55	OCHUCHE	1744
55	OROMA ETITI	4550
55	AMAESE	4497
55	Omagba Lyt Phase I & II	4544
55	AGULERI	366
55	UMUNNACHI	4566
55	OBA	1741
55	Aforadike	4492
55	ANAKU	1736
55	NKPOR	4525
55	UMUEZE ANAM	4562
55	Ejikemi Qtrs	4506
55	GRA II	4511
55	Three Three I	4556
55	UBULU	4559
\.


--
-- Data for Name: client_commission; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.client_commission (commission, client_id, id, commission_id) FROM stdin;
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
1	2022-10-10 08:55:34.472581+00	1	Nike	1	[{"added": {}}]	17	1
2	2022-10-10 08:55:47.586394+00	2	Addidas	1	[{"added": {}}]	17	1
3	2022-10-10 09:13:19.211234+00	3	Gucci	1	[{"added": {}}]	17	1
4	2022-10-10 09:25:56.822225+00	1	Fashion	1	[{"added": {}}]	22	1
5	2022-10-10 09:26:24.128782+00	2	Men's Wear	1	[{"added": {}}]	22	1
6	2022-10-10 09:26:56.37632+00	1	Jacket	1	[{"added": {}}]	31	1
7	2022-10-10 09:35:08.872902+00	4	Samsung	1	[{"added": {}}]	17	1
8	2022-10-10 09:35:19.540957+00	5	LG	1	[{"added": {}}]	17	1
9	2022-10-10 09:35:36.371422+00	6	Sony	1	[{"added": {}}]	17	1
10	2022-10-10 09:36:29.403505+00	3	Electronics	1	[{"added": {}}]	22	1
11	2022-10-10 09:38:52.434344+00	4	Televison	1	[{"added": {}}]	22	1
12	2022-10-10 09:43:20.795892+00	1	Nigerial	1	[{"added": {}}]	14	1
13	2022-10-10 09:43:28.628747+00	1	Nigeria	2	[{"changed": {"fields": ["Name"]}}]	14	1
14	2022-10-10 09:45:13.562305+00	1	Lagos - Nigeria	1	[{"added": {}}]	15	1
15	2022-10-10 09:46:36.623614+00	2	Wisdom	1	[{"added": {}}]	4	1
16	2022-10-10 09:47:45.859237+00	1	Wisdom-+2348057784796: pending	1	[{"added": {}}]	10	1
17	2022-10-10 09:48:53.919077+00	2	admin-+2348077665554: active	1	[{"added": {}}]	10	1
18	2022-10-10 09:49:58.54018+00	2	admin-+2348077665554: active	2	[{"added": {"name": "seller verification", "object": "admin-+2348077665554: active: True"}}, {"added": {"name": "seller file", "object": "admin-+2348077665554: active: seller-files/WhatsApp_Image_2022-07-24_at_4.55.24_PM.jpeg"}}]	10	1
19	2022-10-11 10:26:15.391127+00	2	admin-+2348077665554: active	2	[{"changed": {"fields": ["Address"]}}]	10	1
20	2022-10-11 10:42:03.605815+00	1	crypticwisdom	2	[{"added": {"name": "address", "object": "home wisdom None"}}]	8	1
21	2022-10-11 10:53:03.746538+00	2	bima	2	[]	8	1
22	2022-10-11 10:53:54.522445+00	2	bima	2	[]	8	1
23	2022-10-11 11:03:07.965542+00	2	bima	2	[{"added": {"name": "address", "object": "home my home None"}}]	8	1
24	2022-10-11 11:04:14.001111+00	2	bima	2	[]	8	1
25	2022-10-11 11:05:14.312862+00	4	bima	2	[{"changed": {"fields": ["First name", "Last name"]}}]	4	1
26	2022-10-12 21:25:37.307649+00	1	1: Wisdom-+2348057784796: pending - First Store	1	[{"added": {}}]	13	1
27	2022-10-12 21:26:19.525326+00	1	Nike Jacket	1	[{"added": {}}, {"added": {"name": "product detail", "object": "1: Nike Jacket"}}]	21	1
28	2022-10-12 21:28:06.235812+00	1	Nike winglet	2	[{"changed": {"fields": ["Name", "Sub category", "View count"]}}]	21	1
29	2022-10-12 21:29:51.041337+00	2	Air Retro 10	1	[{"added": {}}, {"added": {"name": "product detail", "object": "2: Air Retro 10"}}]	21	1
30	2022-10-12 21:43:02.932493+00	3	arm less jacket	1	[{"added": {}}, {"added": {"name": "product detail", "object": "3: arm less jacket"}}]	21	1
31	2022-10-12 21:43:41.750212+00	3	arm less jacket	2	[{"changed": {"fields": ["Published on"]}}]	21	1
32	2022-10-14 12:50:15.884081+00	1	Image	1	[{"added": {}}]	32	1
33	2022-10-14 12:50:24.338287+00	3	arm less jacket	2	[{"changed": {"fields": ["Image"]}}]	21	1
34	2022-10-14 12:50:49.645768+00	2	Air Retro 10	2	[{"changed": {"fields": ["Image"]}}]	21	1
35	2022-10-14 12:51:43.132471+00	1	Nike winglet	2	[{"changed": {"fields": ["Image"]}}]	21	1
36	2022-10-14 12:56:22.797289+00	3	arm less jacket	2	[{"changed": {"fields": ["Is featured"]}}]	21	1
37	2022-10-14 12:56:46.984313+00	3	arm less jacket	2	[{"changed": {"fields": ["Status"]}}]	21	1
38	2022-10-14 12:56:57.500404+00	2	Air Retro 10	2	[{"changed": {"fields": ["Is featured"]}}]	21	1
39	2022-10-14 12:59:09.077799+00	1	Image	3		32	1
40	2022-10-14 13:00:03.389671+00	2	Image	1	[{"added": {}}]	32	1
41	2022-10-14 13:00:11.113312+00	3	arm less jacket	2	[{"changed": {"fields": ["Image"]}}]	21	1
42	2022-10-14 13:00:25.069979+00	2	Air Retro 10	2	[{"changed": {"fields": ["Image"]}}]	21	1
43	2022-10-14 13:00:31.364388+00	1	Nike winglet	2	[{"changed": {"fields": ["Image"]}}]	21	1
44	2022-10-25 09:39:29.132255+00	6	crypticwisdom84@gmail.com	2	[{"changed": {"fields": ["Verified"]}}]	8	1
45	2022-11-08 11:57:01.484976+00	7	Vans	1	[{"added": {}}]	17	1
46	2022-11-08 11:57:43.064645+00	8	Glossier	1	[{"added": {}}]	17	1
47	2022-11-08 11:58:19.117533+00	9	Chanel	1	[{"added": {}}]	17	1
48	2022-11-08 11:58:51.240226+00	10	Nvidia	1	[{"added": {}}]	17	1
49	2022-11-08 11:59:33.208871+00	11	Playstation	1	[{"added": {}}]	17	1
50	2022-11-08 12:00:38.043618+00	3	Gucci	2	[{"changed": {"fields": ["Image"]}}]	17	1
51	2022-11-08 12:01:11.19532+00	1	Nike	2	[{"changed": {"fields": ["Image"]}}]	17	1
52	2022-11-08 12:09:29.194865+00	3	adedeji-+2348000000000: active	1	[{"added": {}}, {"added": {"name": "seller verification", "object": "adedeji-+2348000000000: active: True"}}, {"added": {"name": "seller file", "object": "adedeji-+2348000000000: active: seller-files/WhatsApp_Image_2022-07-24_at_4.55.24_PM_6A6qEBw.jpeg"}}]	10	1
53	2022-11-08 12:16:44.694412+00	2	Laptop	1	[{"added": {}}]	31	1
54	2022-11-08 12:21:14.035276+00	2	2: adedeji-+2348000000000: active - Adedeji	1	[{"added": {}}]	13	1
55	2022-11-08 12:23:26.26955+00	3	T-shirt	1	[{"added": {}}]	31	1
56	2022-11-08 12:36:04.133381+00	4	jk jacket	1	[{"added": {}}, {"added": {"name": "product detail", "object": "4: jk jacket"}}]	21	1
57	2022-11-08 12:40:41.066471+00	5	Tee Fet	1	[{"added": {}}, {"added": {"name": "product detail", "object": "5: Tee Fet"}}, {"added": {"name": "product review", "object": "adedeji Tee Fet"}}]	21	1
58	2022-11-08 12:43:16.363138+00	6	Cway Bottle Water	1	[{"added": {}}]	21	1
59	2022-11-08 12:43:46.401301+00	3	Image	1	[{"added": {}}]	32	1
60	2022-11-08 12:46:50.914977+00	4	bima-+2348000000001: active	1	[{"added": {}}, {"added": {"name": "seller verification", "object": "bima-+2348000000001: active: True"}}, {"added": {"name": "seller file", "object": "bima-+2348000000001: active: seller-files/WhatsApp_Image_2022-07-24_at_4.55.24_PM_XMZmuTa.jpeg"}}]	10	1
61	2022-11-08 12:49:39.501295+00	12	C-way	1	[{"added": {}}]	17	1
62	2022-11-08 12:50:58.212775+00	5	drink	1	[{"added": {}}]	22	1
63	2022-11-08 12:51:42.339435+00	5	drink	2	[{"changed": {"fields": ["Parent"]}}]	22	1
64	2022-11-08 12:56:06.92504+00	6	Cway Bottle Water	2	[{"changed": {"fields": ["Image", "Category", "Sub category", "Product type", "View count", "Sale count"]}}, {"added": {"name": "product detail", "object": "6: Cway Bottle Water"}}]	21	1
65	2022-11-08 13:03:29.012356+00	6	Cway Bottle Water	2	[]	21	1
66	2022-11-08 13:10:34.374494+00	4	Android	1	[{"added": {}}]	31	1
67	2022-11-08 13:14:58.459229+00	7	Tecno Camon 16 Pro	1	[{"added": {}}, {"added": {"name": "product detail", "object": "7: Tecno Camon 16 Pro"}}]	21	1
68	2022-11-08 13:15:21.323741+00	13	Tecno	1	[{"added": {}}]	17	1
69	2022-11-08 13:17:30.956725+00	4	Image	1	[{"added": {}}]	32	1
70	2022-11-08 13:17:57.652273+00	7	Tecno Camon 16 Pro	2	[{"changed": {"name": "product detail", "object": "7: Tecno Camon 16 Pro", "fields": ["Brand"]}}]	21	1
71	2022-11-08 13:27:33.497985+00	6	Cway Bottle Water	2	[{"changed": {"fields": ["Is featured"]}}]	21	1
72	2022-11-09 16:06:59.733446+00	3	3: bima-+2348000000001: active - Bima	1	[{"added": {}}]	13	1
73	2022-11-09 16:10:50.413709+00	8	Jack a	1	[{"added": {}}, {"added": {"name": "product detail", "object": "8: Jack a"}}]	21	1
74	2022-11-09 16:49:47.887125+00	9	Jocket	1	[{"added": {}}, {"added": {"name": "product detail", "object": "9: Jocket"}}]	21	1
75	2022-11-09 16:52:12.643685+00	10	Machine Shirt	1	[{"added": {}}, {"added": {"name": "product detail", "object": "10: Machine Shirt"}}]	21	1
76	2022-11-09 16:54:51.594998+00	1	merchant.Seller.None - active	1	[{"added": {}}]	25	1
77	2022-11-09 17:23:22.155803+00	10	Machine Shirt	2	[{"changed": {"fields": ["Published on"]}}]	21	1
78	2022-11-09 17:30:12.447998+00	7	Tecno Camon 16 Pro	2	[{"changed": {"fields": ["Brand"]}}]	21	1
79	2022-11-09 17:30:56.902011+00	2	2: adedeji-+2348000000000: active - Adedeji	2	[{"changed": {"fields": ["Is active"]}}]	13	1
80	2022-11-11 08:31:48.021099+00	11	Tecno Camon 17 Pro	1	[{"added": {}}, {"added": {"name": "product detail", "object": "11: Tecno Camon 17 Pro"}}]	21	1
81	2022-11-14 16:24:22.268912+00	8	crypticwisdom84@gmail.com	3		4	1
82	2022-11-14 16:30:30.173087+00	13	crypticwisdom84@gmail.com	3		4	1
83	2022-11-14 16:30:58.905167+00	14	crypticwisdom84@gmail.com	3		4	1
84	2022-11-15 08:48:25.889691+00	15	crypticwisdom84@gmail.com	3		4	1
85	2022-11-15 08:53:41.52254+00	17	crypticwisdom84@gmail.com	3		4	1
86	2022-11-15 09:22:47.84082+00	16	crypticwisdom84@gmail.com	2	[{"changed": {"fields": ["Verified"]}}]	8	1
87	2022-11-15 09:35:40.9785+00	18	crypticwisdom84@gmail.com	3		4	1
88	2022-11-15 10:17:33.089571+00	20	crypticwisdom84@gmail.com	3		4	1
89	2022-11-15 10:29:35.717806+00	21	crypticwisdom84@gmail.com	3		4	1
90	2022-11-15 10:33:40.280911+00	22	crypticwisdom84@gmail.com	3		4	1
91	2022-11-15 10:48:48.222755+00	21	crypticwisdom84@gmail.com	2	[{"changed": {"fields": ["Verified", "Verification code"]}}]	8	1
92	2022-11-15 12:08:14.63908+00	12	vanny	1	[{"added": {}}, {"added": {"name": "product detail", "object": "12: vanny"}}]	21	1
93	2022-11-15 12:10:43.707012+00	13	vans cool	1	[{"added": {}}, {"added": {"name": "product detail", "object": "13: vans cool"}}]	21	1
94	2022-11-15 12:17:42.626112+00	14	canvas	1	[{"added": {}}, {"added": {"name": "product detail", "object": "14: canvas"}}]	21	1
95	2022-11-15 12:18:29.937152+00	1	Nike winglet	2	[{"changed": {"fields": ["Is featured"]}}]	21	1
96	2022-11-16 14:02:55.379687+00	23	crypticwisdom84@gmail.com	2	[{"changed": {"fields": ["Email address"]}}]	4	1
97	2022-11-16 14:03:37.645131+00	23	crypticwisdom84@gmail.com	2	[{"changed": {"fields": ["Email address"]}}]	4	1
98	2022-11-17 13:07:09.812983+00	15	jacket	1	[{"added": {}}, {"added": {"name": "product detail", "object": "15: jacket"}}]	21	1
99	2022-11-17 13:19:08.191975+00	2	merchant.Seller.None - active	1	[{"added": {}}]	25	1
100	2022-11-17 13:23:14.809004+00	3	merchant.Seller.None - active	1	[{"added": {}}]	25	1
101	2022-11-18 12:26:54.31431+00	23	crypticwisdom84@gmail.com	3		4	1
102	2022-11-18 12:29:44.135323+00	7	adedeji	3		4	1
103	2022-11-18 12:39:27.326895+00	4	bima	3		4	1
104	2022-11-18 12:39:27.328871+00	3	crypticwisdom	3		4	1
105	2022-11-18 12:39:27.329982+00	16	enib@mailinator.com	3		4	1
106	2022-11-18 12:39:27.331043+00	12	enii@mailinator.com	3		4	1
107	2022-11-18 12:39:27.332125+00	11	eni@mailinator.com	3		4	1
108	2022-11-18 12:39:27.333209+00	6	slojar	3		4	1
109	2022-11-18 12:39:27.33431+00	10	tee@mailinator.com	3		4	1
110	2022-11-18 12:39:27.335288+00	9	temi@mailinator.com	3		4	1
111	2022-11-18 12:39:27.336266+00	25	tope@mailinator.com	3		4	1
112	2022-11-18 12:39:27.337318+00	24	wisd@mailinator.com	3		4	1
113	2022-11-18 12:39:27.338321+00	2	Wisdom	3		4	1
114	2022-11-18 12:39:27.339313+00	5	wisdom1	3		4	1
115	2022-11-18 12:39:27.340251+00	19	wis@mailinator.com	3		4	1
116	2022-11-18 12:49:38.534265+00	26	crypticwisdom84@gmail.com	2	[]	4	1
117	2022-11-18 14:36:31.892168+00	16	Product1	1	[{"added": {}}, {"added": {"name": "product detail", "object": "16: Product1"}}]	21	1
118	2022-11-18 14:38:28.02228+00	17	Laptop	1	[{"added": {}}, {"added": {"name": "product detail", "object": "17: Laptop"}}]	21	1
119	2022-11-22 15:49:10.076145+00	6	crypticwisdom84@gmail.com-234 9021345678: active	2	[{"changed": {"fields": ["Status"]}}]	10	1
120	2022-11-22 15:52:16.86861+00	5	5: crypticwisdom84@gmail.com-234 9021345678: active - Tommy	2	[{"changed": {"fields": ["Logo", "Description", "Categories", "Is active"]}}]	13	1
121	2022-11-23 12:05:36.231843+00	2	eni@mailinator.com-+2348077665554: active	2	[{"changed": {"fields": ["User"]}}]	10	1
122	2022-11-23 12:17:32.327465+00	7	eni@mailinator.com-08105700750: active	1	[{"added": {}}, {"added": {"name": "seller detail", "object": "eni@mailinator.com-08105700750: active: True"}}, {"added": {"name": "seller file", "object": "eni@mailinator.com-08105700750: active: seller-files/wallet_api.json"}}]	10	1
123	2022-11-23 12:18:33.763629+00	7	eni1@mailinator.com-08105700750: active	2	[{"changed": {"fields": ["User"]}}]	10	1
124	2022-11-23 12:19:40.362986+00	6	6: eni1@mailinator.com-08105700750: active - Eni Wealth	1	[{"added": {}}]	13	1
125	2022-11-23 13:22:07.142976+00	18	Suit	1	[{"added": {}}, {"added": {"name": "product detail", "object": "18: Suit"}}, {"added": {"name": "product review", "object": "crypticwisdom84@gmail.com Suit"}}]	21	1
126	2022-11-23 13:36:23.146494+00	6	Gadgets	1	[{"added": {}}]	22	1
127	2022-11-23 13:37:07.242401+00	5	Gadgets	1	[{"added": {}}]	31	1
128	2022-11-23 13:37:16.490865+00	5	Gadgets	2	[{"changed": {"fields": ["Fixed commission"]}}]	31	1
129	2022-11-25 12:07:06.061602+00	3	other Address Name Nigeria	1	[{"added": {}}]	33	1
130	2022-11-25 12:07:54.225664+00	1	1: 73c0b580-3242-45d0-92e3-e6a42d1ef50f-tomiwat@mailinator.com-open	2	[{"changed": {"fields": ["User"]}}, {"added": {"name": "cart product", "object": "49: 1: 73c0b580-3242-45d0-92e3-e6a42d1ef50f-tomiwat@mailinator.com-open 17: Laptop"}}]	18	1
131	2022-11-25 12:10:28.697198+00	1	ID: 1, tomiwat@mailinator.com - 1	1	[{"added": {}}, {"added": {"name": "order product", "object": "1: ID: 1, tomiwat@mailinator.com - 1 17: Laptop"}}]	34	1
132	2022-11-25 12:13:41.320913+00	1	ID: 1, tomiwat@mailinator.com - 1 - success	1	[{"added": {}}]	43	1
133	2022-11-25 12:42:20.278118+00	14	14: 4f4ea65f-99cb-471b-b536-0118a4da18b2-adekoyadaniel53@gmail.com-open	2	[{"changed": {"fields": ["User"]}}, {"added": {"name": "cart product", "object": "50: 14: 4f4ea65f-99cb-471b-b536-0118a4da18b2-adekoyadaniel53@gmail.com-open 20: Samsung Z Fold"}}]	18	1
134	2022-11-25 12:42:34.438395+00	3	other Address Name Nigeria	2	[{"changed": {"fields": ["Customer"]}}]	33	1
259	2022-12-08 08:26:59.402911+00	3	Electronics	2	[{"changed": {"fields": ["Image"]}}]	22	1
261	2022-12-08 08:35:57.972958+00	71	Image	1	[{"added": {}}]	32	1
135	2022-11-25 12:44:14.289486+00	2	ID: 2, adekoyadaniel53@gmail.com - 14	1	[{"added": {}}, {"added": {"name": "order product", "object": "2: ID: 2, adekoyadaniel53@gmail.com - 14 20: Samsung Z Fold"}}]	34	1
136	2022-11-25 12:44:49.754045+00	2	ID: 2, adekoyadaniel53@gmail.com - 14 - success	1	[{"added": {}}]	43	1
137	2022-11-25 12:50:57.92346+00	1	adekoyadaniel53@gmail.com TF Military Drone	1	[{"added": {}}]	26	1
138	2022-11-25 13:52:09.131873+00	26	crypticwisdom84@gmail.com	2	[{"changed": {"fields": ["Email address"]}}]	4	1
139	2022-11-25 13:59:50.254743+00	2	ID: 2, adekoyadaniel53@gmail.com - 14	2	[{"changed": {"name": "order product", "object": "2: ID: 2, adekoyadaniel53@gmail.com - 14 20: Samsung Z Fold", "fields": ["Total", "Shipper name", "Company id", "Tracking id", "Waybill no", "Payment method", "Delivery fee"]}}]	34	1
140	2022-11-25 14:51:11.864948+00	1	ID: 2, adekoyadaniel53@gmail.com - 14 - pending	2	[{"changed": {"fields": ["Order", "Payment method", "Amount", "Status"]}}]	43	1
141	2022-11-25 14:56:37.747827+00	3	ID: 2, adekoyadaniel53@gmail.com - 14 - pending	1	[{"added": {}}]	43	1
142	2022-11-25 14:56:50.785283+00	1	ID: 2, adekoyadaniel53@gmail.com - 14 - pending	3		43	1
143	2022-11-25 14:57:03.819331+00	3	ID: 2, adekoyadaniel53@gmail.com - 14 - pending	2	[{"changed": {"fields": ["Transaction reference"]}}]	43	1
144	2022-11-25 14:58:52.732381+00	3	ID: 2, adekoyadaniel53@gmail.com - 14 - pending	3		43	1
145	2022-11-25 15:00:25.838951+00	13	13: 2ed45465-9e86-47d0-b792-5a54135d4cd7-adekoyadaniel53@gmail.com-open	2	[{"changed": {"fields": ["User"]}}, {"added": {"name": "cart product", "object": "51: 13: 2ed45465-9e86-47d0-b792-5a54135d4cd7-adekoyadaniel53@gmail.com-open 22: iPhone 13 "}}]	18	1
146	2022-11-25 15:01:57.876289+00	3	ID: 3, adekoyadaniel53@gmail.com - 13	1	[{"added": {}}, {"added": {"name": "order product", "object": "3: ID: 3, adekoyadaniel53@gmail.com - 13 22: iPhone 13 "}}]	34	1
147	2022-11-25 15:04:38.228419+00	4	ID: 3, adekoyadaniel53@gmail.com - 13 - pending	1	[{"added": {}}]	43	1
148	2022-11-25 15:05:18.888781+00	2	ID: 2, adekoyadaniel53@gmail.com - 14 - pending	2	[{"changed": {"fields": ["Status"]}}]	43	1
149	2022-11-25 15:05:26.969158+00	4	ID: 3, adekoyadaniel53@gmail.com - 13 - pending	3		43	1
150	2022-11-25 15:11:47.430097+00	2	ID: 2, adekoyadaniel53@gmail.com - 14 - failed	2	[{"changed": {"fields": ["Status"]}}]	43	1
151	2022-11-25 15:13:16.277702+00	2	ID: 2, adekoyadaniel53@gmail.com - 14 - success	2	[{"changed": {"fields": ["Status"]}}]	43	1
152	2022-11-26 12:31:11.330699+00	7	adekoyadaniel53@gmail.com-08105700750: active	2	[{"changed": {"fields": ["User"]}}]	10	1
153	2022-11-27 11:00:47.545348+00	4	home Adedeji Home Kasali Hammed	1	[{"added": {}}]	33	1
154	2022-11-28 12:05:31.084257+00	16	16: Product1	2	[{"changed": {"fields": ["Stock"]}}]	23	1
155	2022-11-28 12:06:22.688637+00	17	17: Laptop	2	[]	23	1
156	2022-11-29 11:52:46.006451+00	44	funky@mailinator.com	3		4	1
157	2022-11-29 13:34:38.091915+00	46	wisdom@tm30.net	3		4	1
158	2022-11-29 13:58:53.830726+00	8	wisdom@tm30.net-08057784797: active	1	[{"added": {}}, {"added": {"name": "seller detail", "object": "wisdom@tm30.net-08057784797: active: True"}}, {"added": {"name": "seller file", "object": "wisdom@tm30.net-08057784797: active: seller-files/Screenshot_from_2022-11-26_21-07-59.png"}}]	10	1
159	2022-11-29 14:02:28.464652+00	7	7: wisdom@tm30.net-08057784797: active - Prime	1	[{"added": {}}]	13	1
160	2022-11-29 14:10:47.840764+00	5	Image	1	[{"added": {}}]	32	1
161	2022-11-29 14:11:36.919253+00	6	Juice	1	[{"added": {}}]	31	1
162	2022-11-29 14:11:52.415127+00	14	Chi	1	[{"added": {}}]	17	1
163	2022-11-29 14:16:02.258797+00	20	Samsung Z Fold	2	[{"changed": {"fields": ["Description"]}}]	21	1
164	2022-11-29 14:28:37.159419+00	23	Chivita Active	1	[{"added": {}}]	21	1
165	2022-11-29 15:23:57.197395+00	16	Product1	2	[{"changed": {"fields": ["Description"]}}]	21	1
166	2022-11-29 15:50:36.517193+00	23	Chivita Active	2	[{"changed": {"fields": ["Image"]}}]	21	1
167	2022-11-29 15:51:18.243548+00	23	Chivita Active	2	[{"changed": {"fields": ["Image"]}}]	21	1
168	2022-11-30 10:27:31.620725+00	34	adekoyadaniel53@gmail.com	2	[{"changed": {"name": "address", "object": "home 71 Community Road, Lagos None", "fields": ["Is primary"]}}, {"changed": {"name": "address", "object": "home 71 Community Road, Lagos None", "fields": ["Is primary"]}}, {"changed": {"name": "address", "object": "home 71 Community Road, Lagos None", "fields": ["Is primary"]}}, {"changed": {"name": "address", "object": "home 71 Community Road, Lagos None", "fields": ["Is primary"]}}, {"changed": {"name": "address", "object": "home 71 Community Road, Lagos None", "fields": ["Is primary"]}}, {"changed": {"name": "address", "object": "home 71 Community Road, Lagos None", "fields": ["Is primary"]}}, {"changed": {"name": "address", "object": "home 71 Community Road, Lagos None", "fields": ["Is primary"]}}, {"changed": {"name": "address", "object": "home 31 emily akinola None", "fields": ["Is primary"]}}, {"changed": {"name": "address", "object": "home 71 Community Road, Lagos None", "fields": ["Is primary"]}}, {"changed": {"name": "address", "object": "home 71 Community Road, Lagos None", "fields": ["Is primary"]}}, {"changed": {"name": "address", "object": "home 71 Community Road, Lagos None", "fields": ["Is primary"]}}, {"changed": {"name": "address", "object": "home 71 Community Road, Lagos None", "fields": ["Is primary"]}}, {"changed": {"name": "address", "object": "home 71 Community Road, Lagos None", "fields": ["Is primary"]}}]	8	1
169	2022-11-30 11:31:47.898216+00	7	Grocery	1	[{"added": {}}]	22	1
170	2022-11-30 11:32:08.228888+00	5	Drinks	2	[{"changed": {"fields": ["Name", "Parent"]}}]	22	1
171	2022-11-30 12:14:02.894263+00	8	Gaming	1	[{"added": {}}]	22	1
172	2022-11-30 12:14:22.196865+00	9	Home and Office Equipment	1	[{"added": {}}]	22	1
173	2022-11-30 12:14:36.306529+00	10	Sport & Fitness	1	[{"added": {}}]	22	1
174	2022-11-30 12:15:02.938232+00	11	Vehicle & Automotives	1	[{"added": {}}]	22	1
175	2022-11-30 12:15:09.543777+00	12	Livestock	1	[{"added": {}}]	22	1
176	2022-11-30 12:15:48.19522+00	13	Books & Stationaries	1	[{"added": {}}]	22	1
177	2022-11-30 12:16:32.140942+00	14	Plastic & Paper Products	1	[{"added": {}}]	22	1
178	2022-11-30 12:16:57.756322+00	15	Books	1	[{"added": {}}]	22	1
179	2022-11-30 12:17:17.256093+00	16	Religious Articles	1	[{"added": {}}]	22	1
180	2022-11-30 12:17:41.681123+00	17	Console	1	[{"added": {}}]	22	1
181	2022-11-30 12:17:50.865825+00	18	Game Accessories	1	[{"added": {}}]	22	1
182	2022-11-30 12:18:02.275883+00	19	Cameras	1	[{"added": {}}]	22	1
183	2022-11-30 12:18:36.691246+00	20	Home Theatres & Audio Systems	1	[{"added": {}}]	22	1
184	2022-11-30 12:19:02.592591+00	21	Cooking Ingredients	1	[{"added": {}}]	22	1
185	2022-11-30 12:19:43.872419+00	22	Home Furnitures	1	[{"added": {}}]	22	1
186	2022-11-30 12:19:57.803481+00	23	Large Appliances	1	[{"added": {}}]	22	1
187	2022-11-30 12:20:11.781095+00	24	Medium Appliances	1	[{"added": {}}]	22	1
260	2022-12-08 08:35:38.30795+00	2	Image	3		32	1
262	2022-12-08 08:36:04.357734+00	23	Benz	2	[{"changed": {"fields": ["Name", "Image"]}}]	21	1
188	2022-11-30 14:50:08.766478+00	2	agunbiade.adedeji94@gmail.com-+2348077665554: active	2	[{"changed": {"fields": ["User"]}}, {"added": {"name": "seller detail", "object": "agunbiade.adedeji94@gmail.com-+2348077665554: active: True"}}]	10	1
189	2022-12-01 01:18:58.40324+00	8	8: agunbiade.adedeji94@gmail.com-+2348077665554: active - Eni Wealth Store	1	[{"added": {}}]	13	1
190	2022-12-01 09:03:03.783001+00	19	work Cable Africa  Network TV(CanTV) Nigeria	1	[{"added": {}}]	33	1
191	2022-12-01 11:04:03.912415+00	1	reviewer	1	[{"added": {}}]	44	1
192	2022-12-01 11:04:08.12974+00	2	authorizer	1	[{"added": {}}]	44	1
193	2022-12-01 11:04:15.985813+00	3	admin	1	[{"added": {}}]	44	1
194	2022-12-01 11:04:21.010911+00	4	super_admin	1	[{"added": {}}]	44	1
195	2022-12-01 11:05:13.24577+00	53	admin@UP.com	1	[{"added": {}}]	4	1
196	2022-12-01 11:05:30.725718+00	53	admin@UP.com	2	[{"changed": {"fields": ["First name", "Last name", "Email address", "Staff status"]}}]	4	1
197	2022-12-01 11:05:53.457684+00	1	admin@UP.com: super_admin	1	[{"added": {}}]	45	1
198	2022-12-01 12:50:23.320153+00	25	Car	1	[{"added": {}}]	22	1
199	2022-12-01 12:53:21.044448+00	26	Big Cars	1	[{"added": {}}]	22	1
200	2022-12-01 13:02:47.92397+00	15	Benz	1	[{"added": {}}]	17	1
201	2022-12-01 13:05:20.418402+00	16	Others	1	[{"added": {}}]	17	1
202	2022-12-01 13:06:01.42574+00	7	Car	1	[{"added": {}}]	31	1
203	2022-12-01 13:07:12.239352+00	25	Car	3		22	1
204	2022-12-01 13:07:36.955085+00	27	Small Car	1	[{"added": {}}]	22	1
205	2022-12-01 13:08:03.089084+00	28	Medium Car	1	[{"added": {}}]	22	1
206	2022-12-01 15:19:30.662736+00	1	crypticwisdom84@gmail.com 2: ID: 2, adekoyadaniel53@gmail.com - None 20: Samsung Z Fold None	1	[{"added": {}}]	40	1
207	2022-12-01 15:52:22.840011+00	2	2: ID: 2, adekoyadaniel53@gmail.com - None 20: Samsung Z Fold	2	[{"changed": {"fields": ["Delivery date"]}}]	35	1
208	2022-12-01 15:53:37.685219+00	2	2: ID: 2, adekoyadaniel53@gmail.com - None 20: Samsung Z Fold	2	[]	35	1
209	2022-12-01 17:36:04.400657+00	17	Laptop	2	[{"changed": {"fields": ["Store", "Description"]}}]	21	1
210	2022-12-01 20:50:38.8809+00	20	20: Samsung Z Fold	2	[{"changed": {"fields": ["Stock"]}}]	23	1
211	2022-12-01 20:57:48.907612+00	20	20: Samsung Z Fold	2	[{"changed": {"fields": ["Stock"]}}]	23	1
212	2022-12-01 21:14:01.751851+00	20	20: Samsung Z Fold	2	[{"changed": {"fields": ["Stock"]}}]	23	1
213	2022-12-01 21:14:31.07371+00	20	20: Samsung Z Fold	2	[{"changed": {"fields": ["Stock"]}}]	23	1
214	2022-12-01 23:06:30.466089+00	20	20: Samsung Z Fold	2	[{"changed": {"fields": ["Stock"]}}]	23	1
215	2022-12-01 23:24:21.386737+00	20	20: Samsung Z Fold	2	[{"changed": {"fields": ["Stock"]}}]	23	1
216	2022-12-02 00:51:08.914254+00	20	20: Samsung Z Fold	2	[{"changed": {"fields": ["Stock"]}}]	23	1
217	2022-12-02 06:13:19.841042+00	6	crypticwisdom84@gmail.com-2349021345678: active	2	[{"changed": {"fields": ["Phone number"]}}]	10	1
218	2022-12-02 08:31:44.730374+00	8	wisdom@tm30.net-08057784797: active	2	[{"changed": {"fields": ["Town id"]}}]	10	1
219	2022-12-02 08:31:53.639748+00	7	adekoyadaniel53@gmail.com-08105700750: active	2	[{"changed": {"fields": ["Town id"]}}]	10	1
220	2022-12-02 08:32:02.906981+00	6	crypticwisdom84@gmail.com-2349021345678: active	2	[{"changed": {"fields": ["Town id"]}}]	10	1
221	2022-12-02 08:32:12.271406+00	2	agunbiade.adedeji94@gmail.com-+2348077665554: active	2	[{"changed": {"fields": ["Town id"]}}]	10	1
222	2022-12-02 08:32:30.784019+00	4	home Adedeji Home Kasali Hammed	2	[{"changed": {"fields": ["Town id"]}}]	33	1
223	2022-12-02 08:32:41.362073+00	3	other Address Name Nigeria	2	[{"changed": {"fields": ["Town id"]}}]	33	1
224	2022-12-02 09:49:06.566935+00	8	wisdom@tm30.net-08057784797: active	2	[{"changed": {"fields": ["Merchant id"]}}]	10	1
225	2022-12-02 09:49:17.596635+00	7	adekoyadaniel53@gmail.com-08105700750: active	2	[{"changed": {"fields": ["Merchant id"]}}]	10	1
226	2022-12-02 09:49:28.017362+00	6	crypticwisdom84@gmail.com-2349021345678: active	2	[{"changed": {"fields": ["Merchant id"]}}]	10	1
227	2022-12-02 09:49:42.279287+00	2	agunbiade.adedeji94@gmail.com-+2348077665554: active	2	[{"changed": {"fields": ["Merchant id"]}}]	10	1
228	2022-12-03 07:10:42.016889+00	1	admin@UP.com: super_admin	2	[{"changed": {"fields": ["Role"]}}]	45	1
229	2022-12-03 18:31:20.88963+00	26	Benz	2	[{"changed": {"fields": ["Status"]}}]	21	1
230	2022-12-04 17:03:17.342659+00	21	21: TF Military Drone	2	[{"changed": {"fields": ["Stock"]}}]	23	1
231	2022-12-04 20:16:53.180364+00	22	iPhone 13	2	[{"changed": {"fields": ["Name", "Description", "Status"]}}]	21	1
232	2022-12-04 20:17:13.467648+00	26	Benz	2	[{"changed": {"fields": ["Status"]}}]	21	1
233	2022-12-04 20:17:35.407773+00	25	LG tv Bonanza	2	[{"changed": {"fields": ["Description", "Status"]}}]	21	1
234	2022-12-04 20:18:39.55304+00	24	LG tv New	2	[{"changed": {"fields": ["Description", "Status"]}}]	21	1
235	2022-12-04 20:20:36.93927+00	26	Benz	2	[{"changed": {"fields": ["Status"]}}]	21	1
236	2022-12-04 20:28:01.634289+00	26	Benz	2	[{"changed": {"fields": ["Status"]}}]	21	1
237	2022-12-04 20:28:13.422214+00	25	LG tv Bonanza	2	[{"changed": {"fields": ["Status"]}}]	21	1
238	2022-12-04 20:28:39.347042+00	24	LG tv New	2	[{"changed": {"fields": ["Status"]}}]	21	1
239	2022-12-04 20:29:03.601691+00	22	iPhone 13	2	[{"changed": {"fields": ["Status"]}}]	21	1
240	2022-12-05 08:47:45.421839+00	26	Benz	2	[{"changed": {"fields": ["Status"]}}]	21	1
241	2022-12-05 08:48:16.222134+00	25	LG tv Bonanza	2	[{"changed": {"fields": ["Status"]}}]	21	1
242	2022-12-05 11:21:26.700808+00	26	Benz	2	[{"changed": {"fields": ["Status"]}}]	21	1
243	2022-12-05 11:26:08.251464+00	21	TF Military Drone	2	[{"changed": {"fields": ["Description", "Status"]}}]	21	1
244	2022-12-05 11:27:14.516796+00	21	TF Military Drone	2	[]	21	1
245	2022-12-05 11:27:40.617196+00	21	TF Military Drone	2	[]	21	1
246	2022-12-05 11:27:46.002278+00	21	TF Military Drone	2	[]	21	1
247	2022-12-05 23:39:39.785815+00	21	TF Military Drone	2	[{"changed": {"fields": ["Status"]}}]	21	1
248	2022-12-05 23:53:28.685465+00	21	TF Military Drone	2	[{"changed": {"fields": ["Decline reason"]}}]	21	1
249	2022-12-05 23:54:33.60341+00	25	LG tv Bonanza	2	[{"changed": {"fields": ["Decline reason"]}}]	21	1
250	2022-12-06 11:49:06.957817+00	24	LG tv New	2	[{"changed": {"fields": ["Status"]}}]	21	1
251	2022-12-07 08:25:56.320264+00	26	Benz	2	[{"changed": {"fields": ["Status"]}}]	21	1
252	2022-12-07 08:29:24.808696+00	26	Benz	2	[{"changed": {"fields": ["Status"]}}]	21	1
253	2022-12-07 08:37:20.767599+00	66	Image	1	[{"added": {}}]	32	1
254	2022-12-07 08:53:06.598153+00	29	Kitchen utensils	1	[{"added": {}}]	22	1
255	2022-12-07 08:56:47.315179+00	8	Cup	1	[{"added": {}}]	31	1
256	2022-12-07 16:03:21.521327+00	11	Vehicle & Automotives	2	[{"changed": {"fields": ["Image"]}}]	22	1
257	2022-12-08 08:14:19.185045+00	30	Women's wear	1	[{"added": {}}]	22	1
258	2022-12-08 08:18:47.506184+00	1	Fashion	2	[{"changed": {"fields": ["Image"]}}]	22	1
263	2022-12-08 08:39:35.086773+00	72	Image	1	[{"added": {}}]	32	1
264	2022-12-08 08:39:46.314017+00	23	Benz	2	[{"changed": {"fields": ["Image"]}}]	21	1
265	2022-12-08 08:41:39.742287+00	4	Image	2	[{"changed": {"fields": ["Image"]}}]	32	1
266	2022-12-08 08:41:43.853652+00	17	Laptop	2	[]	21	1
267	2022-12-08 08:47:21.812744+00	73	Image	1	[{"added": {}}]	32	1
268	2022-12-08 08:47:58.194965+00	20	Sneakers	2	[{"changed": {"fields": ["Name", "Image", "Category", "Sub category"]}}]	21	1
269	2022-12-08 08:50:13.013682+00	74	Image	1	[{"added": {}}]	32	1
270	2022-12-08 08:51:53.129846+00	22	Macbook	2	[{"changed": {"fields": ["Name", "Description", "Image", "Tags"]}}]	21	1
271	2022-12-08 08:57:30.761149+00	75	Image	1	[{"added": {}}]	32	1
272	2022-12-08 08:59:32.328029+00	9	Dresses	1	[{"added": {}}]	31	1
273	2022-12-08 09:00:25.127144+00	76	Image	1	[{"added": {}}]	32	1
274	2022-12-08 09:02:33.40061+00	28	Red dress	1	[{"added": {}}, {"added": {"name": "product detail", "object": "30: Red dress"}}]	21	1
275	2022-12-08 09:12:23.674915+00	77	Image	1	[{"added": {}}]	32	1
276	2022-12-08 09:12:44.564134+00	16	Leather shoes	2	[{"changed": {"fields": ["Name", "Description", "Image"]}}, {"changed": {"name": "product detail", "object": "16: Leather shoes", "fields": ["Price"]}}]	21	1
277	2022-12-08 09:15:15.035099+00	78	Image	1	[{"added": {}}]	32	1
278	2022-12-08 09:16:25.904215+00	18	Suit	2	[{"changed": {"fields": ["Description", "Image", "Brand"]}}, {"changed": {"name": "product detail", "object": "18: Suit", "fields": ["Stock"]}}]	21	1
279	2022-12-08 09:21:47.340252+00	13	Books & Stationaries	2	[{"changed": {"fields": ["Image"]}}]	22	1
280	2022-12-08 09:23:50.72627+00	11	Vehicle & Automotives	2	[{"changed": {"fields": ["Image"]}}]	22	1
281	2022-12-08 09:37:47.79658+00	79	Image	1	[{"added": {}}]	32	1
282	2022-12-08 09:39:12.922784+00	10	Others	1	[{"added": {}}]	31	1
283	2022-12-08 09:40:40.721891+00	80	Image	1	[{"added": {}}]	32	1
284	2022-12-08 09:43:28.266667+00	29	Note Pad	1	[{"added": {}}, {"added": {"name": "product detail", "object": "31: Note Pad"}}]	21	1
285	2022-12-08 09:44:22.996814+00	20	Sneakers	2	[{"changed": {"name": "product detail", "object": "20: Sneakers", "fields": ["Stock"]}}]	21	1
286	2022-12-08 09:55:47.68106+00	29	Note Pad	2	[{"changed": {"fields": ["Status"]}}]	21	1
287	2022-12-08 09:56:05.287026+00	28	Red dress	2	[{"changed": {"fields": ["Status"]}}]	21	1
288	2022-12-08 09:56:29.646672+00	26	Benz	2	[{"changed": {"fields": ["Status"]}}]	21	1
289	2022-12-08 09:57:00.651166+00	22	Macbook	2	[{"changed": {"fields": ["Status"]}}]	21	1
290	2022-12-08 09:58:10.687074+00	29	Note Pad	2	[{"changed": {"fields": ["Status"]}}]	21	1
291	2022-12-08 09:58:25.289383+00	28	Red dress	2	[{"changed": {"fields": ["Status"]}}]	21	1
292	2022-12-08 09:58:50.476572+00	26	Benz	2	[{"changed": {"fields": ["Status"]}}]	21	1
293	2022-12-08 09:59:26.824075+00	22	Macbook	2	[{"changed": {"fields": ["Status"]}}]	21	1
294	2022-12-08 10:03:15.933845+00	29	Note Pad	2	[{"changed": {"fields": ["View count", "Sale count", "Published on"]}}, {"changed": {"name": "product detail", "object": "31: Note Pad", "fields": ["Out of stock date"]}}]	21	1
295	2022-12-08 10:06:33.38701+00	3	Electronics	2	[{"changed": {"fields": ["Image"]}}]	22	1
296	2022-12-08 10:10:53.097618+00	30	Cabbage	2	[{"changed": {"fields": ["Status"]}}]	21	1
297	2022-12-08 10:12:45.989247+00	28	Red dress	2	[{"changed": {"fields": ["Sale count", "Published on"]}}]	21	1
298	2022-12-08 10:13:32.834601+00	28	Red dress	2	[{"changed": {"name": "product detail", "object": "30: Red dress", "fields": ["Weight", "Length", "Width"]}}]	21	1
299	2022-12-08 10:15:44.289826+00	28	Red dress	2	[{"changed": {"name": "product detail", "object": "30: Red dress", "fields": ["Stock"]}}]	21	1
300	2022-12-08 10:17:57.220951+00	28	Red dress	2	[]	21	1
301	2022-12-08 10:24:15.471534+00	84	Image	1	[{"added": {}}]	32	1
302	2022-12-08 10:25:39.766055+00	3	Electronics	2	[{"changed": {"fields": ["Image"]}}]	22	1
303	2022-12-08 10:27:28.473388+00	11	Vehicle & Automotives	2	[{"changed": {"fields": ["Image"]}}]	22	1
304	2022-12-08 10:32:13.603888+00	10	Sport & Fitness	2	[{"changed": {"fields": ["Image"]}}]	22	1
305	2022-12-09 09:34:21.08224+00	31	Iphone 14	2	[{"changed": {"fields": ["Status"]}}]	21	1
306	2022-12-09 10:31:22.160396+00	34	adekoyadaniel53@gmail.com	2	[{"changed": {"fields": ["Billing verified"]}}]	8	1
307	2022-12-09 10:32:59.524038+00	34	adekoyadaniel53@gmail.com	2	[{"changed": {"fields": ["Billing id"]}}]	8	1
308	2022-12-13 09:48:48.849749+00	94	Image	1	[{"added": {}}]	32	1
309	2022-12-13 09:51:40.644755+00	33	Brown shoe	1	[{"added": {}}, {"added": {"name": "product detail", "object": "37: Brown shoe"}}]	21	1
310	2022-12-13 09:54:25.30237+00	95	Image	1	[{"added": {}}]	32	1
311	2022-12-13 09:55:42.671421+00	34	Hat	1	[{"added": {}}, {"added": {"name": "product detail", "object": "38: Hat"}}]	21	1
312	2022-12-13 09:57:32.779881+00	32	Hat	2	[{"changed": {"fields": ["Status"]}}, {"changed": {"name": "product detail", "object": "34: Hat", "fields": ["Price"]}}, {"changed": {"name": "product detail", "object": "35: Hat", "fields": ["Price"]}}, {"changed": {"name": "product detail", "object": "36: Hat", "fields": ["Price"]}}]	21	1
313	2022-12-13 09:58:13.128726+00	32	Hat	2	[{"changed": {"fields": ["Published on"]}}]	21	1
314	2022-12-13 10:02:19.248051+00	96	Image	1	[{"added": {}}]	32	1
315	2022-12-13 10:04:09.06926+00	35	Office bag	1	[{"added": {}}, {"added": {"name": "product detail", "object": "39: Office bag"}}]	21	1
316	2022-12-13 10:04:54.56193+00	35	Office bag	2	[{"changed": {"name": "product detail", "object": "39: Office bag", "fields": ["Discount"]}}]	21	1
317	2022-12-13 10:05:41.28738+00	97	Image	1	[{"added": {}}]	32	1
318	2022-12-13 10:07:01.875768+00	36	Office bag	1	[{"added": {}}, {"added": {"name": "product detail", "object": "40: Office bag"}}]	21	1
319	2022-12-13 10:08:58.052925+00	16	Leather shoes	2	[{"changed": {"name": "product detail", "object": "16: Leather shoes", "fields": ["Stock", "Discount", "Low stock threshold"]}}]	21	1
320	2022-12-13 10:09:41.298009+00	18	Suit	2	[{"changed": {"name": "product detail", "object": "18: Suit", "fields": ["Discount"]}}]	21	1
321	2022-12-13 10:11:27.607741+00	98	Image	1	[{"added": {}}]	32	1
322	2022-12-13 10:12:47.964745+00	37	Bag	1	[{"added": {}}, {"added": {"name": "product detail", "object": "41: Bag"}}]	21	1
323	2022-12-13 10:14:14.008582+00	99	Image	1	[{"added": {}}]	32	1
324	2022-12-13 10:16:09.29141+00	38	Bicycle	1	[{"added": {}}, {"added": {"name": "product detail", "object": "42: Bicycle"}}]	21	1
325	2022-12-13 10:21:36.978207+00	100	Image	1	[{"added": {}}]	32	1
326	2022-12-13 10:22:38.399892+00	39	Helmet	1	[{"added": {}}, {"added": {"name": "product detail", "object": "43: Helmet"}}]	21	1
327	2022-12-13 10:27:33.378771+00	7	Drinks and Wines	2	[{"changed": {"fields": ["Name", "Parent"]}}]	22	1
328	2022-12-13 10:27:53.563114+00	31	Grocery	1	[{"added": {}}]	22	1
329	2022-12-13 10:28:30.458977+00	11	Wine	1	[{"added": {}}]	31	1
330	2022-12-13 10:29:24.632253+00	101	Image	1	[{"added": {}}]	32	1
331	2022-12-13 10:30:35.68574+00	40	White wine	1	[{"added": {}}, {"added": {"name": "product detail", "object": "44: White wine"}}]	21	1
332	2022-12-13 10:31:13.789903+00	102	Image	1	[{"added": {}}]	32	1
333	2022-12-13 10:32:14.361449+00	41	Wine	1	[{"added": {}}, {"added": {"name": "product detail", "object": "45: Wine"}}]	21	1
334	2022-12-13 10:34:11.183348+00	103	Image	1	[{"added": {}}]	32	1
335	2022-12-13 10:35:32.462626+00	42	Lemonade	1	[{"added": {}}, {"added": {"name": "product detail", "object": "46: Lemonade"}}]	21	1
336	2022-12-13 10:38:20.394306+00	31	Grocery	2	[{"changed": {"fields": ["Image"]}}]	22	1
337	2022-12-13 10:39:30.045148+00	31	Grocery	2	[{"changed": {"fields": ["Image"]}}]	22	1
338	2022-12-14 11:32:51.7992+00	33	mife0105@gmail.com	2	[{"changed": {"name": "address", "object": "home Home address Animashaun Close", "fields": ["Locality", "Landmark", "City", "Town", "Town id", "Postal code", "Longitude", "Latitude"]}}]	8	1
339	2022-12-19 09:20:56.771485+00	42	Lemonade	2	[{"changed": {"fields": ["Published on"]}}]	21	1
340	2022-12-19 09:21:09.922155+00	42	Lemonade	2	[]	21	1
341	2022-12-19 09:21:42.876798+00	42	Lemonade	2	[{"changed": {"fields": ["Published on"]}}]	21	1
342	2022-12-19 09:22:34.62171+00	42	Lemonade	2	[]	21	1
343	2022-12-19 09:23:27.177585+00	42	Lemonade	2	[{"changed": {"fields": ["Status"]}}]	21	1
344	2022-12-19 09:23:37.421852+00	42	Lemonade	2	[{"changed": {"fields": ["Status"]}}]	21	1
345	2022-12-19 09:27:26.804141+00	42	Lemonade	2	[]	21	1
346	2022-12-20 11:24:06.941656+00	29	home 31 emiliy akinola None	2	[{"changed": {"fields": ["Town id"]}}]	33	1
347	2022-12-20 11:24:44.770238+00	29	home 31 emiliy akinola None	2	[{"changed": {"fields": ["Longitude", "Latitude"]}}]	33	1
348	2022-12-20 11:26:57.792101+00	33	mife0105@gmail.com	2	[{"changed": {"name": "address", "object": "home 29, Berkley street Off King George road Onikan None", "fields": ["Is primary"]}}, {"changed": {"name": "address", "object": "home 29, Berkley street Off King George road Onikan None", "fields": ["Is primary"]}}]	8	1
349	2022-12-20 11:39:53.419262+00	28	home 29, Berkley street Off King George road Onikan None	2	[{"changed": {"fields": ["Town id"]}}]	33	1
350	2022-12-20 11:56:06.590437+00	8	wisdom@tm30.net-08057784797: pending	2	[{"changed": {"fields": ["Status"]}}]	10	1
351	2022-12-20 12:10:28.307457+00	2	George - Sterling bank - Nwachukwu Wisdom	2	[{"changed": {"fields": ["Seller"]}}]	36	1
352	2022-12-20 12:17:23.725327+00	36	Office bag	2	[{"changed": {"name": "product detail", "object": "40: Office bag", "fields": ["Weight", "Length", "Width", "Height"]}}]	21	1
353	2022-12-20 12:17:41.573417+00	35	Office bag	2	[{"changed": {"name": "product detail", "object": "39: Office bag", "fields": ["Weight", "Length", "Width", "Height"]}}]	21	1
354	2022-12-20 12:39:14.713172+00	31	home 29, Berkley street Off King George road Onikan None	2	[{"changed": {"fields": ["City", "Town id"]}}]	33	1
355	2022-12-20 12:40:24.518463+00	31	home Default Address 29, Berkley street Off King George road Onikan	2	[{"changed": {"fields": ["Name", "Locality", "Landmark"]}}]	33	1
356	2022-12-20 12:43:39.539122+00	31	home Default Address 29, Berkley street Off King George road Onikan	2	[{"changed": {"fields": ["City", "Town", "Town id"]}}]	33	1
357	2022-12-20 12:45:11.029989+00	8	wisdom@tm30.net-08057784797: pending	2	[{"changed": {"fields": ["State"]}}]	10	1
358	2022-12-20 12:45:59.777838+00	8	wisdom@tm30.net-08057784797: active	2	[{"changed": {"fields": ["Status"]}}]	10	1
359	2022-12-20 13:48:09.527537+00	2	George - Sterling bank - Nwachukwu Wisdom	2	[{"changed": {"fields": ["Bank code"]}}]	36	1
360	2022-12-30 12:16:36.971711+00	52	daniel@tm30.dev	3		8	1
361	2022-12-30 12:20:24.529899+00	67	daniel@tm30.dev	3		4	1
362	2022-12-30 18:06:56.925973+00	68	ID: 37, None - None - pending	3		43	1
363	2022-12-30 18:06:56.928324+00	67	ID: 36, None - None - pending	3		43	1
364	2022-12-30 18:19:53.229734+00	11	mife0105@gmail.com-234 8136812997: pending	2	[{"changed": {"fields": ["Status"]}}]	10	1
365	2022-12-30 18:28:00.956095+00	8	wisdom@tm30.net-08057784797: pending	2	[{"changed": {"fields": ["Status"]}}]	10	1
366	2022-12-30 18:35:24.285929+00	8	wisdom@tm30.net-08057784797: pending	2	[{"changed": {"fields": ["Status"]}}]	10	1
367	2022-12-30 18:41:08.915868+00	6	crypticwisdom84@gmail.com-2349021345678: pending	2	[{"changed": {"fields": ["Status"]}}]	10	1
368	2022-12-30 18:57:57.748051+00	8	wisdom@tm30.net-08057784797: pending	2	[{"changed": {"fields": ["Status"]}}]	10	1
369	2022-12-31 09:03:02.52482+00	24	LG tv New	2	[{"added": {"name": "product detail", "object": "48: LG tv New"}}]	21	1
370	2023-01-05 12:20:39.325802+00	3	merchant.Seller.None - active	2	[{"changed": {"fields": ["Product"]}}]	25	1
371	2023-01-05 12:28:34.715141+00	3	merchant.Seller.None - active	2	[]	25	1
372	2023-01-05 12:41:02.88506+00	2	merchant.Seller.None - active	3		25	1
373	2023-01-05 12:41:02.88742+00	1	merchant.Seller.None - active	3		25	1
374	2023-01-05 12:41:17.910863+00	3	merchant.Seller.None - active	2	[]	25	1
375	2023-01-06 12:48:26.754702+00	46	46: Lemonade	2	[{"changed": {"fields": ["Stock"]}}]	23	1
376	2023-01-16 11:56:38.27939+00	31	slojararshavin@mailinato.com	2	[{"changed": {"name": "address", "object": "work Makoko Road Nigeria", "fields": ["Town id"]}}, {"changed": {"name": "address", "object": "home 71 Community Road, Lagos Lekki", "fields": ["Locality", "Landmark", "City", "Town", "Town id", "Longitude", "Latitude", "Is primary"]}}]	8	1
377	2023-01-16 12:28:44.514398+00	1	Item does not match description	1	[{"added": {}}]	39	1
378	2023-01-16 12:28:52.74418+00	2	I received a damaged item	1	[{"added": {}}]	39	1
379	2023-01-16 12:29:09.212114+00	3	Item is not functioning (Gadgets)	1	[{"added": {}}]	39	1
380	2023-01-16 12:29:17.824696+00	4	Item is different from my order	1	[{"added": {}}]	39	1
381	2023-01-16 12:29:29.195776+00	5	Others	1	[{"added": {}}]	39	1
382	2023-01-20 09:46:04.340506+00	51	Jeans for Women	3		21	1
383	2023-01-20 09:47:50.883989+00	46	Daniel	3		21	1
384	2023-01-21 12:18:47.84222+00	6	crypticwisdom84@gmail.com-2349021345678: pending	2	[{"changed": {"fields": ["Status"]}}]	10	1
385	2023-01-25 11:45:40.601481+00	5	merchant.Seller.None - active	2	[{"changed": {"fields": ["Promo type"]}}]	25	1
386	2023-01-25 12:18:40.044546+00	11	Wine	2	[{"changed": {"fields": ["Category"]}}]	31	1
387	2023-01-25 12:19:41.865467+00	10	Others	2	[{"changed": {"fields": ["Category"]}}]	31	1
388	2023-01-25 12:19:50.879078+00	9	Dresses	2	[{"changed": {"fields": ["Category"]}}]	31	1
389	2023-01-25 12:20:27.794459+00	8	Cup	2	[{"changed": {"fields": ["Category"]}}]	31	1
390	2023-01-25 12:20:44.30855+00	7	Car	2	[{"changed": {"fields": ["Category"]}}]	31	1
391	2023-01-25 12:21:22.413606+00	7	Drinks and Wines	2	[{"changed": {"fields": ["Parent"]}}]	22	1
392	2023-01-25 12:21:43.18406+00	6	Juice	2	[]	31	1
393	2023-01-25 12:21:58.248654+00	5	Gadgets	2	[]	31	1
394	2023-01-25 12:23:08.892576+00	36	Phone & Mobile	1	[{"added": {}}]	22	1
395	2023-01-25 12:23:27.644797+00	37	Android Phones	1	[{"added": {}}]	22	1
396	2023-01-25 12:23:44.52564+00	38	iPhone	1	[{"added": {}}]	22	1
397	2023-01-25 12:24:23.436649+00	4	Android	2	[{"changed": {"fields": ["Category"]}}]	31	1
398	2023-01-25 12:24:39.15705+00	3	T-shirt	2	[{"changed": {"fields": ["Category"]}}]	31	1
399	2023-01-25 12:25:32.551288+00	2	Laptop	2	[{"changed": {"fields": ["Category"]}}]	31	1
400	2023-01-25 12:25:41.157041+00	1	Jacket	2	[]	31	1
401	2023-01-26 13:11:01.771513+00	24	crypticwisdom84@gmail.com	2	[{"changed": {"fields": ["Verified", "Code expiration date"]}}]	8	1
402	2023-01-26 13:20:11.920552+00	24	crypticwisdom84@gmail.com	2	[{"changed": {"fields": ["Verified"]}}]	8	1
403	2023-01-26 13:23:07.160416+00	24	crypticwisdom84@gmail.com	2	[{"changed": {"fields": ["Code expiration date"]}}]	8	1
404	2023-01-27 11:59:25.57148+00	53	53: ID: 77, slojararshavin@mailinato.com - 496 48: LG tv New	2	[{"changed": {"fields": ["Status"]}}]	35	1
405	2023-01-27 11:59:41.834453+00	46	46: ID: 74, adekoyadaniel53@gmail.com - 489 23: Benz	2	[{"changed": {"fields": ["Status"]}}]	35	1
406	2023-01-27 11:59:50.429418+00	44	44: ID: 73, slojararshavin@mailinato.com - 493 20: Sneakers	2	[{"changed": {"fields": ["Status"]}}]	35	1
407	2023-01-27 11:59:58.646835+00	43	43: ID: 73, slojararshavin@mailinato.com - 493 23: Benz	2	[{"changed": {"fields": ["Status"]}}]	35	1
408	2023-02-04 07:21:31.515044+00	40	Fam	3		22	1
409	2023-02-04 07:21:31.517812+00	39	Fame	3		22	1
410	2023-02-04 07:21:31.518972+00	35	Daniel	3		22	1
411	2023-02-04 07:21:31.520084+00	34	Daniel Adekoya	3		22	1
412	2023-02-04 07:21:31.521132+00	33	Code	3		22	1
413	2023-02-04 07:21:31.52224+00	32	wowowow	3		22	1
414	2023-02-04 07:22:53.997948+00	9	merchant.Seller.None - active	3		25	1
415	2023-02-07 08:05:58.032497+00	6	crypticwisdom84@gmail.com-2349021345678: active	2	[{"changed": {"fields": ["Status"]}}]	10	1
416	2023-02-09 21:55:36.078526+00	59	hp	3		21	1
417	2023-02-09 21:55:36.080714+00	58	Hp	3		21	1
418	2023-02-10 10:03:46.34912+00	61	Hp Laptop	3		21	1
419	2023-02-10 20:45:16.445244+00	62	Hp lpa	3		21	1
420	2023-02-13 12:52:34.414328+00	18	merchant.Seller.None - active	3		25	1
421	2023-02-13 12:52:34.416544+00	17	merchant.Seller.None - active	3		25	1
422	2023-02-13 12:52:34.417767+00	16	merchant.Seller.None - active	3		25	1
423	2023-02-13 12:52:34.418896+00	15	merchant.Seller.None - active	3		25	1
424	2023-02-13 12:52:34.420272+00	14	merchant.Seller.None - active	3		25	1
425	2023-02-13 12:52:34.42138+00	13	merchant.Seller.None - active	3		25	1
426	2023-02-13 12:52:34.42246+00	12	merchant.Seller.None - active	3		25	1
427	2023-02-13 12:52:34.423544+00	11	merchant.Seller.None - active	3		25	1
428	2023-02-13 12:52:34.424542+00	10	merchant.Seller.None - active	3		25	1
429	2023-02-13 12:52:34.425543+00	8	merchant.Seller.None - active	3		25	1
430	2023-02-13 12:52:34.426603+00	7	merchant.Seller.None - active	3		25	1
431	2023-02-13 12:52:34.42763+00	6	merchant.Seller.None - active	3		25	1
432	2023-02-13 12:52:34.428635+00	5	merchant.Seller.None - active	3		25	1
433	2023-02-13 12:52:34.429632+00	4	merchant.Seller.None - active	3		25	1
434	2023-02-13 12:52:34.430657+00	3	merchant.Seller.None - active	3		25	1
435	2023-02-13 12:54:41.860609+00	19	merchant.Seller.None - active	2	[{"changed": {"fields": ["Position"]}}]	25	1
436	2023-02-13 12:55:46.238547+00	19	merchant.Seller.None - active	2	[{"changed": {"fields": ["Position"]}}]	25	1
437	2023-03-06 16:04:55.455275+00	49	ID: 49, aba.angus02@gmail.com - 360	2	[{"changed": {"name": "order product", "object": "10: ID: 49, aba.angus02@gmail.com - 360 16: Leather shoes", "fields": ["Price", "Discount", "Total", "Shipper name"]}}, {"deleted": {"name": "order product", "object": "None: ID: 49, aba.angus02@gmail.com - 360 18: Suit"}}]	34	1
438	2023-03-06 16:05:19.281029+00	82	ID: 49, aba.angus02@gmail.com - 360 - success	2	[{"changed": {"fields": ["Amount"]}}]	43	1
439	2023-03-06 16:05:25.481395+00	13	ID: 13 - MerchantID: 7 - OrderID: 95	1	[{"added": {}}]	47	1
440	2023-03-06 16:05:42.288713+00	12	ID: 12 - MerchantID: 7 - OrderID: 95	3		47	1
441	2023-03-06 16:14:33.920484+00	13	ID: 13 - MerchantID: 7 - OrderID: 95	2	[]	47	1
442	2023-07-27 11:01:59.689783+00	1	ID 1: - Jean	1	[{"added": {}}]	48	1
443	2023-07-27 11:02:06.566362+00	2	ID 2: - Benz	1	[{"added": {}}]	48	1
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	permission
3	auth	group
4	auth	user
5	contenttypes	contenttype
6	sessions	session
7	account	forgotpasswordotp
8	account	profile
9	account	usercard
10	merchant	seller
11	merchant	sellerverification
12	merchant	sellerfile
13	store	store
14	location	country
15	location	state
16	location	city
17	ecommerce	brand
18	ecommerce	cart
19	ecommerce	cartbill
20	ecommerce	cartproduct
21	ecommerce	product
22	ecommerce	productcategory
23	ecommerce	productdetail
24	ecommerce	shipper
25	ecommerce	promo
26	ecommerce	productwishlist
27	ecommerce	productreview
28	ecommerce	productimage
29	authtoken	token
30	authtoken	tokenproxy
31	ecommerce	producttype
32	ecommerce	image
33	account	address
34	ecommerce	order
35	ecommerce	orderproduct
36	merchant	bankaccount
37	merchant	sellerdetail
38	merchant	director
39	ecommerce	returnreason
40	ecommerce	returnedproduct
41	ecommerce	returnproductimage
42	ecommerce	orderentry
43	transaction	transaction
44	superadmin	role
45	superadmin	adminuser
46	merchant	merchantbanner
47	transaction	merchanttransaction
48	ecommerce	dailydeal
49	merchant	bulkuploadfile
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	location	0001_initial	2022-10-06 09:43:28.766748+00
2	contenttypes	0001_initial	2022-10-06 09:43:28.774337+00
3	auth	0001_initial	2022-10-06 09:43:28.827988+00
4	account	0001_initial	2022-10-06 09:43:28.872771+00
5	admin	0001_initial	2022-10-06 09:43:28.894499+00
6	admin	0002_logentry_remove_auto_add	2022-10-06 09:43:28.90379+00
7	admin	0003_logentry_add_action_flag_choices	2022-10-06 09:43:28.91409+00
8	contenttypes	0002_remove_content_type_name	2022-10-06 09:43:28.958601+00
9	auth	0002_alter_permission_name_max_length	2022-10-06 09:43:28.971049+00
10	auth	0003_alter_user_email_max_length	2022-10-06 09:43:28.980757+00
11	auth	0004_alter_user_username_opts	2022-10-06 09:43:28.990125+00
12	auth	0005_alter_user_last_login_null	2022-10-06 09:43:29.000875+00
13	auth	0006_require_contenttypes_0002	2022-10-06 09:43:29.002547+00
14	auth	0007_alter_validators_add_error_messages	2022-10-06 09:43:29.01166+00
15	auth	0008_alter_user_username_max_length	2022-10-06 09:43:29.023678+00
16	auth	0009_alter_user_last_name_max_length	2022-10-06 09:43:29.033131+00
17	auth	0010_alter_group_name_max_length	2022-10-06 09:43:29.046441+00
18	auth	0011_update_proxy_permissions	2022-10-06 09:43:29.059916+00
19	auth	0012_alter_user_first_name_max_length	2022-10-06 09:43:29.069038+00
20	authtoken	0001_initial	2022-10-06 09:43:29.08769+00
21	authtoken	0002_auto_20160226_1747	2022-10-06 09:43:29.122922+00
22	authtoken	0003_tokenproxy	2022-10-06 09:43:29.125739+00
23	merchant	0001_initial	2022-10-06 09:43:29.189005+00
24	ecommerce	0001_initial	2022-10-06 09:43:29.42144+00
25	store	0001_initial	2022-10-06 09:43:29.463809+00
26	ecommerce	0002_initial	2022-10-06 09:43:29.695746+00
27	sessions	0001_initial	2022-10-06 09:43:29.707105+00
28	account	0002_alter_forgotpasswordotp_expire_time	2022-10-10 08:59:39.854365+00
29	ecommerce	0003_producttype	2022-10-10 08:59:39.917941+00
30	ecommerce	0004_image_remove_product_slug_product_published_on_and_more	2022-10-10 08:59:39.988011+00
31	account	0003_remove_profile_city_remove_profile_country_and_more	2022-10-11 10:24:37.066183+00
32	account	0004_alter_profile_updated_on	2022-10-11 13:01:56.808697+00
33	ecommerce	0005_product_product_type	2022-10-12 13:39:12.343389+00
34	account	0005_profile_code_expiration_date_and_more	2022-10-19 11:31:30.370823+00
35	account	0006_alter_profile_verification_code	2022-10-19 11:31:30.387525+00
36	merchant	0002_remove_seller_city_remove_seller_country_and_more	2022-10-19 11:31:30.494285+00
37	location	0002_remove_state_country_delete_city_delete_country_and_more	2022-10-19 11:31:30.5089+00
38	merchant	0003_seller_city_seller_state_seller_town	2022-10-19 11:31:30.568246+00
39	ecommerce	0006_order_remove_cartbill_shipper_cartbill_shipper_name_and_more	2022-10-22 18:31:06.16618+00
40	ecommerce	0007_alter_orderproduct_price	2022-10-22 18:31:06.18747+00
41	ecommerce	0008_alter_orderproduct_status	2022-10-22 18:31:06.209006+00
42	merchant	0004_seller_latitude_seller_longitude	2022-10-22 18:31:06.249863+00
43	ecommerce	0009_remove_productimage_image	2022-11-08 13:46:36.914953+00
44	ecommerce	0010_productimage_image	2022-11-08 13:46:36.955197+00
45	ecommerce	0011_remove_productdetail_brand_product_brand	2022-11-08 13:46:37.032963+00
46	ecommerce	0012_returnreason_orderproduct_sub_total	2022-11-08 13:46:37.066194+00
47	merchant	0005_bankaccount_sellerdetail_delete_sellerverification	2022-11-08 13:46:37.151738+00
48	merchant	0006_director_sellerdetail_director	2022-11-08 13:46:37.195787+00
49	merchant	0007_sellerdetail_product_category	2022-11-08 13:46:37.24221+00
50	merchant	0008_remove_sellerdetail_business_name_and_more	2022-11-08 13:46:37.299142+00
51	merchant	0009_sellerdetail_company_type	2022-11-08 13:46:37.316655+00
52	merchant	0010_sellerdetail_company_tin_number_and_more	2022-11-08 13:46:37.355706+00
53	merchant	0011_alter_sellerdetail_business_type_and_more	2022-11-08 13:46:37.385905+00
54	ecommerce	0013_returnreason_slug	2022-11-15 07:46:00.970959+00
55	ecommerce	0014_returnedproduct_returnproductimage_and_more	2022-11-15 07:46:01.084346+00
56	ecommerce	0015_alter_returnreason_slug	2022-11-15 07:46:01.090252+00
57	ecommerce	0016_returnproductimage_image	2022-11-15 07:46:01.10031+00
58	ecommerce	0017_remove_order_shipper_name_cartproduct_company_id_and_more	2022-11-15 22:32:07.612522+00
59	ecommerce	0018_orderproduct_waybill_no	2022-11-16 14:45:19.222835+00
60	account	0007_remove_profile_wallet_id_profile_pay_auth	2022-11-18 11:12:09.640834+00
61	account	0008_profile_has_wallet	2022-11-18 11:12:09.667385+00
62	account	0009_profile_pay_token	2022-11-18 11:12:09.688534+00
63	ecommerce	0019_delete_cartbill	2022-11-18 16:00:42.776055+00
64	transaction	0001_initial	2022-11-18 16:00:42.824986+00
65	transaction	0002_transaction_created_on_transaction_updated_on	2022-11-22 16:15:15.274913+00
66	ecommerce	0020_alter_product_status_alter_productcategory_image	2022-11-25 13:43:22.486464+00
67	ecommerce	0021_alter_productcategory_image	2022-11-25 13:43:22.527771+00
68	superadmin	0001_initial	2022-11-27 10:35:30.482763+00
69	superadmin	0002_remove_role_can_create_remove_role_can_update_and_more	2022-11-27 10:35:30.496524+00
70	superadmin	0003_role_admin_type	2022-11-27 10:35:30.504316+00
71	ecommerce	0020_alter_returnproductimage_image	2022-11-28 12:26:28.351488+00
72	ecommerce	0021_alter_returnedproduct_reason	2022-11-28 12:26:28.399903+00
73	ecommerce	0022_merge_20221126_2005	2022-11-28 12:26:28.402528+00
74	account	0010_profile_wallet_pin	2022-11-28 23:17:05.749528+00
75	ecommerce	0023_remove_productdetail_description_product_description	2022-11-28 23:17:05.788166+00
76	merchant	0012_merchantbanner	2022-11-28 23:17:05.838831+00
77	merchant	0013_seller_umap_uid	2022-11-29 02:08:56.936446+00
78	merchant	0014_remove_seller_umap_uid	2022-11-30 15:10:02.310143+00
79	merchant	0015_bankaccount_bank_code_seller_biller_code_seller_feel_and_more	2022-11-30 15:10:02.458849+00
80	merchant	0016_seller_merchant_id	2022-11-30 15:10:02.487696+00
81	account	0011_profile_billing_id_profile_billing_verified	2022-12-01 20:23:44.835483+00
82	account	0012_address_town_id	2022-12-02 08:09:35.506379+00
83	ecommerce	0024_order_receiver_town_id_order_sender_town_id	2022-12-02 08:09:35.53882+00
84	ecommerce	0025_remove_order_receiver_town_id_and_more	2022-12-02 08:09:35.570964+00
85	merchant	0017_seller_town_id	2022-12-02 08:09:35.599046+00
86	ecommerce	0026_product_decline_reason_alter_product_status	2022-12-05 16:14:19.622587+00
87	ecommerce	0027_product_approved_by_product_checked_by_and_more	2022-12-07 09:05:15.480051+00
88	merchant	0018_seller_approved_by_seller_checked_by	2022-12-07 09:05:15.571545+00
89	store	0002_store_on_sale	2022-12-07 11:29:46.32197+00
90	account	0013_remove_profile_billing_id_and_more	2022-12-09 10:56:09.639339+00
91	transaction	0003_alter_transaction_payment_method	2022-12-13 11:25:10.628055+00
92	account	0014_remove_address_num	2022-12-15 17:13:08.778822+00
93	account	0015_alter_address_latitude_alter_address_longitude	2022-12-23 21:24:55.863601+00
94	merchant	0019_alter_seller_latitude_alter_seller_longitude	2022-12-23 21:24:55.949621+00
95	account	0016_profile_recent_viewed_products	2023-01-11 08:10:56.570566+00
96	ecommerce	0028_product_last_viewed_date	2023-01-11 08:10:56.60173+00
97	transaction	0004_merchanttransaction	2023-01-15 08:56:13.498172+00
98	ecommerce	0029_remove_returnreason_slug	2023-01-16 12:28:23.215349+00
99	account	0017_delete_forgotpasswordotp	2023-01-16 20:49:54.735923+00
100	account	0018_alter_address_options	2023-01-16 20:49:54.747716+00
101	ecommerce	0030_promo_product_type_promo_product_type_promo	2023-01-18 16:25:32.077+00
102	account	0019_profile_following	2023-01-23 13:32:56.516679+00
103	ecommerce	0031_promo_position	2023-01-23 13:32:56.550058+00
104	ecommerce	0032_dailydeal	2023-01-23 13:32:56.603349+00
105	ecommerce	0033_alter_orderproduct_status	2023-01-27 11:52:56.895454+00
106	merchant	0020_remove_merchantbanner_banner_size	2023-02-02 09:36:11.870782+00
107	ecommerce	0034_alter_promo_position	2023-02-13 12:40:29.508874+00
108	ecommerce	0035_rename_price_promo_amount_discount_and_more	2023-02-15 18:03:17.934869+00
109	ecommerce	0036_product_slug_promo_slug	2023-02-20 13:12:28.760597+00
110	store	0003_store_slug	2023-02-20 13:12:28.788092+00
111	ecommerce	0037_productcategory_slug_producttype_slug	2023-02-28 11:49:40.882206+00
112	ecommerce	0038_orderproduct_booked	2023-06-02 09:11:43.399442+00
113	transaction	0005_transaction_source	2023-07-24 12:55:01.309805+00
114	merchant	0021_bulkuploadfile_alter_seller_status	2023-10-15 21:28:48.476726+00
115	merchant	0022_alter_bulkuploadfile_errors	2023-10-15 21:28:48.488871+00
116	account	0020_alter_profile_following	2024-10-08 11:56:25.345926+00
117	authtoken	0004_alter_tokenproxy_options	2024-10-08 11:56:25.35319+00
118	ecommerce	0039_alter_image_image	2024-10-08 11:56:25.359368+00
119	ecommerce	0040_alter_image_image	2024-10-08 11:56:25.365431+00
120	ecommerce	0041_product_choice_alter_product_slug	2024-10-08 11:56:25.44991+00
121	ecommerce	0042_product_discount_end_time_product_free_shipping	2024-10-08 11:56:25.576489+00
122	merchant	0023_seller_follower	2024-10-08 11:56:25.632467+00
123	merchant	0024_bulkuploadfile_optimized_file	2024-10-08 11:56:25.636968+00
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
p3gfz1prt7hm3sx4x224y8jrkgo6n2em	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1ohoXZ:zFkk20yt42JZaETpUbxcCYaPWh4iLT2_4VObRt_naJ0	2022-10-24 08:53:37.114999+00
jy3ec8p5t5cq4luk3ymq8ea75lk3rn9s	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1oil57:I-s8lE-D7awBL6MqHbyQsdbB1BzHeiwBiDT0ihATCkY	2022-10-26 23:24:09.467225+00
rtnos9rf5vaz1rppo1rk3d3f8dk8o9zb	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1osNBd:XMHjrjor3hKDFZd5TEDbxaulZ6VuD_lPxl-fuFH3j_0	2022-11-22 11:54:37.858345+00
koz89r5wh4j0nj1nnw6j5fu08wr6cw89	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1ouXGG:XK2XfrZltfz_AavEKROwYBqmR9Z7FRGvH5msY_QFlGQ	2022-11-28 11:04:20.238816+00
4u5jxbvromwspsqorsqldtr1faa2066t	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1oxVT3:Kd4Lwmsinma3RfVV20QjtF9EMKcOyNMHFIfZ3k917yw	2022-12-06 15:45:49.29416+00
1f6nvop9o06c0cxq5akfxsjk2rvs8kwx	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1oyXQg:b-nCzZz9hMu62ZM6sau7G5AOwENS2-Ld8DeW4Dyb8Sk	2022-12-09 12:03:38.046193+00
xiyd5vra6zyilwzvpp304xk9h8p2nskp	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1ozyzi:todxN-XtSo3hNSAJYSoxa4sLeJxql3ZJtKfVPiXWtMk	2022-12-13 11:41:46.629658+00
ezfu6frf5nsj4o78mxhkionath3knix1	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1p02im:XLnlznK5zc3-BWqC2_kydjHWhtAUQa2a_T0qr8bKLKo	2022-12-13 15:40:32.534351+00
a1dxutw3yz4vosz1mmxzz2liilzyviqn	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1p0ixO:0tJmWD6CxwvZrmJ9xEcVE8dXmlUxKzTvhP_JWGZE6so	2022-12-15 12:46:26.748043+00
3o8hlqe1hjl1t69eyv0i856zxs5c3np9	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1p0lHf:9t8_yAhcxnlurpS8Psf-SO_zNap_XGgjUHN4ZYwXQQ8	2022-12-15 15:15:31.777605+00
4c1omuv21nsoegmherza4c4t8cgpagdr	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1p1BQ2:fB5GD5x3vSsPwhvU9tHjZINHcCUVWzA-rsF-i17qeOQ	2022-12-16 19:09:54.351577+00
izqz3r10sxw7fu0pb2doc3tjbhqxt83b	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1p2pjk:H2EXXW2RacKNI9C0vkqyS-fVeBr54Z97SdxakJVYKnc	2022-12-21 08:25:04.869805+00
udm1hblaziztyvr2vmrk0x5gkshsuhiq	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1p5PvN:9J-N21WN2SuwLPouWBrt0apnu9xG6EADP7Ut82JAil4	2022-12-28 11:27:45.591228+00
v74xduqxnwdzz9bwy4mt602q5qgad81d	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1p6o4N:GlJQfBLjT0f4hX5D1sSJn8NdvEdICesbVUqR3M45bl8	2023-01-01 07:26:47.509944+00
b9tknfoui196at2lznar1e0bsrh9rirb	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1p7CIc:o79A1_qSRNojmyXwMNckLEKWP0ud7SNgVtVOIcXrw-g	2023-01-02 09:19:06.602037+00
gdds4kbu5u9tbfaf74ba8z02nd32y8ml	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1p7aV7:r6_IGYtSxu-XNcMeUPi_U81319h5bV3Izpg_bArI3P4	2023-01-03 11:09:37.492825+00
g24t4ruvrd3ivyn6uix1tfzc96hkwps2	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1p7aiN:IlHAq29SyLfqnsluczPs8-MWf473brAk3d1XS_0RfnQ	2023-01-03 11:23:19.898175+00
kpez4s25vgt6pbr0b15strnogdi4gtvt	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1p7bYG:spQO2IQZrRuWibcuEqJ6bjPy6PyY9s4NshKTojc5Ppc	2023-01-03 12:16:56.010283+00
19dw2gpq916swtn75zt1behqyhnpi7qo	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1pBJ8G:0sD8T1KRbxXDRn2nvQUpcMnSxyPCMGAaqPrIcrninD8	2023-01-13 17:25:24.874691+00
wp9zifbeq2pg410oiy6rbnbjltcnn8fk	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1pD0ua:_kvmUZssvlfw_pHYX3CVwSlF5TX8ZHSd1h1q3ndk1AM	2023-01-18 10:22:20.565201+00
dhr8xrvsx5nz63nw0f8c6r763c8d673r	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1pDPE9:mYc7iEgM9ioRL9oeMJsH1zuYJqpfAN5yLuaegfCiDrA	2023-01-19 12:20:09.968646+00
44bf4bxfx8qpevjklk3u29dxew63fhrz	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1pDm7o:idhd0keTQI9jcEGUMvlQnlNhjd-3OJgZr8Mp9j0gBN0	2023-01-20 12:47:08.598545+00
a26wev1nahey2l7903tg2dz7ievn3nf2	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1pHN3A:EjGnNQyUQyyE3SS0tjFb4wS5NZ9Xhvo42IroggDd2Ck	2023-01-30 10:49:12.26073+00
bw2v3vq4rmxm0geouopjec3kpsna1hm9	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1pHN3A:EjGnNQyUQyyE3SS0tjFb4wS5NZ9Xhvo42IroggDd2Ck	2023-01-30 10:49:12.439316+00
d4scd9ii8vwnklknmsp632jvxg9i1ofi	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1pHjZk:SlIMPaO3HdAoyvX5RVcetIpfMn2cjj4fEuKicalyd6Q	2023-01-31 10:52:20.585719+00
0si0cxksdmoa2dvu7azy3o9mh0485uoq	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1pInxh:bXR_8JaB8lzBEtTChJe7LybZrK9-FfKI3g9iEycMUmk	2023-02-03 09:45:29.850829+00
st9t690l9h56unafsca4icqi96ztvpwx	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1pIuaw:bWiVDDQJCaMsM9662BBsgafOBlZZSEwHq1JB8si2zro	2023-02-03 16:50:26.836053+00
9xjbam00nd6z97l7cerpac292p9hg4ha	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1pJy5V:f1lEFyM9Dx4NFfsMgrpbztSL6yjyF8wOdxLJd8NC3-U	2023-02-06 14:46:21.461644+00
quvhr7qet9q566dhvnhpv7bfpq2ywud4	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1pL1OC:UIM9MiK4M_DDYqZzkyVHXbUxPVFddhl1HLliex4neLQ	2023-02-09 12:30:00.04276+00
6qky18j04twxndtg3x63bgn2y85airvx	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1pOCpe:wSBYqzwyHhPS62M1TCtccdQzgRT6yb5nCq_W5xF3nf8	2023-02-18 07:19:30.087237+00
ecyrdb8xnr10trcqv5esxxyz3kprkmjc	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1pPIyn:nruu8RcDwhHLdt4vrtX5ZrCNaCt7LMBn4UAJiPriQ_E	2023-02-21 08:05:29.587163+00
3e6duf4ra39p4g4bfkdf44u8698ygrxx	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1pQ53B:gw1LL5vgkVBHEgyMxQVriXjJ2lTR8KKvRs6Bt9akDzk	2023-02-23 11:25:13.164906+00
hh176i0isyps1vga52xcbckzrb0w8sx7	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1pUmh1:WLsqoOZ4y5ek89OWpObWiadcWuF3yKfA091mjTQXHyw	2023-03-08 10:49:47.005412+00
dq2vfynzk7sxbov4zqnofcoq2cl8qzt1	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1pVsZQ:pzJvkYm-eM8EVzYedkNw06uRTPvo9fYu_4JcSEnP3PA	2023-03-11 11:18:28.771966+00
huns8m07g4zoiy9m4vzcudjpqqc1q1q6	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1pZDE0:mLtVXWFCuFMDEqAw7ykLV7jnmsP0oZsZfxQZGvFfuIM	2023-03-20 15:58:08.342154+00
ivvqzjkh29m7yxuyvnu2zdq3iufn2n1z	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1qBXBN:lgCfVfBD_8nLNGr2XLYPZ-IhngoCVoSOVozz8k4lQMw	2023-07-04 08:57:49.654733+00
nak2dlznql0jpb9rcf6or9g6cuozgrr6	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1qOf16:xAhjLS1IQ9dUWDJjnraknjbAavx8BPHAT7o0XokEibc	2023-08-09 13:57:28.19069+00
xua8xmdlg1ig7s1f08k2vq0jywn38rsf	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1qOzDE:GuccgfPbqi8bqjBZHGWfaOxIgJA8FJIZwYlmkwgyGho	2023-08-10 11:31:20.160566+00
mdisjq44g8czvp5a5qbh0554zr0krx0e	.eJxVjMsOwiAQAP-FsyE8hC0evfsNZOkuUjWQlPZk_HdD0oNeZybzFhH3rcS98xoXEhehxemXJZyfXIegB9Z7k3Or27okORJ52C5vjfh1Pdq_QcFexhZNAq-8NQBT1syA1vhAPpyVcnZyyRIbsC6RRnIhK3TegDeJAirM4vMFuso3PQ:1qut1m:frRFZkc4I6TsFcJKjvfNheZt2ORVJZIdoo0ot-3uRhQ	2023-11-06 11:23:22.979467+00
\.


--
-- Data for Name: ecommerce_brand; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.ecommerce_brand (id, name, image, created_on, updated_on) FROM stdin;
2	Addidas		2022-10-10 08:55:47.585532+00	2022-10-10 08:55:47.585551+00
4	Samsung		2022-10-10 09:35:08.872142+00	2022-10-10 09:35:08.872164+00
5	LG		2022-10-10 09:35:19.53921+00	2022-10-10 09:35:19.539233+00
6	Sony		2022-10-10 09:35:36.370665+00	2022-10-10 09:35:36.370687+00
7	Vans	brand-images/vans.png	2022-11-08 11:57:01.482985+00	2022-11-08 11:57:01.483006+00
8	Glossier	brand-images/glossier.png	2022-11-08 11:57:43.063871+00	2022-11-08 11:57:43.063893+00
9	Chanel	brand-images/channel.png	2022-11-08 11:58:19.116791+00	2022-11-08 11:58:19.116813+00
10	Nvidia	brand-images/nvidia.png	2022-11-08 11:58:51.239251+00	2022-11-08 11:58:51.239273+00
11	Playstation	brand-images/playstation.png	2022-11-08 11:59:33.208107+00	2022-11-08 11:59:33.208128+00
3	Gucci	brand-images/gucii.png	2022-10-10 09:13:19.210355+00	2022-11-08 12:00:38.042669+00
1	Nike	brand-images/nike.png	2022-10-10 08:55:34.471528+00	2022-11-08 12:01:11.194352+00
12	C-way	brand-images/cway-logo.jpeg	2022-11-08 12:49:39.500522+00	2022-11-08 12:49:39.500543+00
13	Tecno		2022-11-08 13:15:21.322987+00	2022-11-08 13:15:21.323008+00
14	Chi		2022-11-29 14:11:52.414355+00	2022-11-29 14:11:52.414378+00
15	Benz		2022-12-01 13:02:47.922241+00	2022-12-01 13:02:47.922262+00
16	Others		2022-12-01 13:05:20.417653+00	2022-12-01 13:05:20.417674+00
17	Hp	brand-images/icons8-hp-240.png	2023-02-04 15:27:48.376291+00	2023-02-04 15:27:48.376312+00
18	Oraimo	brand-images/Black_helmet.jpeg	2023-02-07 09:53:38.427272+00	2023-02-07 09:53:38.427295+00
19	Brand	brand-images/Screenshot_20.png	2023-02-08 12:22:33.788167+00	2023-02-08 12:22:33.788189+00
20	Sansung	brand-images/download.jpeg	2023-03-24 11:46:08.597998+00	2023-03-24 11:46:08.598023+00
21	Bookker	brand-images/download_FZnzu19.jpeg	2023-03-24 11:47:35.623134+00	2023-03-24 11:47:35.623156+00
\.


--
-- Data for Name: ecommerce_cart; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.ecommerce_cart (id, cart_uid, status, created_on, updated_on, user_id) FROM stdin;
307		open	2022-12-15 09:53:00.373839+00	2022-12-15 09:53:00.373861+00	59
2	8d538939-c2e0-4cde-a12f-a8a33c58b8de	open	2022-11-11 13:31:47.987258+00	2022-11-11 13:31:47.987286+00	\N
3	1136555b-25cc-4f09-a2d2-289f7533afd8	open	2022-11-11 13:35:39.333729+00	2022-11-11 13:35:39.333756+00	\N
4	deca195f-496a-4bca-9020-af6a8fd13797	open	2022-11-11 13:35:57.055675+00	2022-11-11 13:35:57.055701+00	\N
5	6ddf7aaf-1595-4ba7-9344-ac777888f005	open	2022-11-11 14:14:22.356811+00	2022-11-11 14:14:22.356837+00	\N
6	decc2745-e106-432a-b1ab-4da97a930b2e	open	2022-11-11 15:28:14.549665+00	2022-11-11 15:28:14.549691+00	\N
7	d24d6a38-2e9d-492e-a47a-1620ad09253c	open	2022-11-11 15:31:49.901387+00	2022-11-11 15:31:49.901415+00	\N
8	c9adeaf4-694a-47b7-ad79-6f1a2253d2a4	open	2022-11-11 15:57:54.306685+00	2022-11-11 15:57:54.306713+00	\N
9	5615f1ef-966c-42db-8b1a-96d8c2b90a24	open	2022-11-11 16:02:57.188813+00	2022-11-11 16:02:57.18884+00	\N
10	b4eb6dc7-c826-4cc3-af2d-322334f1cd95	open	2022-11-11 16:32:33.392517+00	2022-11-11 16:32:33.392546+00	\N
11	3ee958b9-f3ed-4874-8bbc-34a5a6972ee1	open	2022-11-14 14:07:47.672454+00	2022-11-14 14:07:47.67248+00	\N
12	e95e4eb1-1bd3-4fa2-93b7-f907aed19fed	open	2022-11-14 14:08:03.796261+00	2022-11-14 14:08:03.796288+00	\N
524	cf23072b-c906-4fcd-9b1e-e87737d290b0	open	2023-02-04 20:46:09.97147+00	2023-02-04 20:46:09.971499+00	\N
15	76017149-8ac8-4dfb-b346-94bfa165735a	open	2022-11-15 11:45:36.522969+00	2022-11-15 11:45:36.523007+00	\N
16	68d07da7-f006-47ae-8091-237f62ecf161	open	2022-11-15 12:20:50.259962+00	2022-11-15 12:20:50.259989+00	\N
17	3f494783-86de-406a-9ec0-83f66dffec2d	open	2022-11-15 12:21:02.523081+00	2022-11-15 12:21:02.523111+00	\N
18	2408c765-dd2f-4cbb-ab0e-00154d56852d	open	2022-11-15 12:23:34.770305+00	2022-11-15 12:23:34.770331+00	\N
19	66b8de2d-76c3-4b6a-b22e-8528b06ab072	open	2022-11-15 15:38:34.800302+00	2022-11-15 15:38:34.800327+00	\N
20	26b88f47-0a77-44d8-bd0d-93f604e2e8da	open	2022-11-15 15:55:41.368931+00	2022-11-15 15:55:41.368956+00	\N
21	5abeba47-071f-40fa-963f-ee97d24beb17	open	2022-11-15 15:59:43.702273+00	2022-11-15 15:59:43.702299+00	\N
22	f278760a-f97c-46a5-8e58-82a201b3a605	open	2022-11-15 15:59:46.213202+00	2022-11-15 15:59:46.213238+00	\N
23	1efb4702-38fc-4b1f-8591-cfa28e498eb9	open	2022-11-15 16:00:06.828251+00	2022-11-15 16:00:06.828278+00	\N
24	6fbfc908-f54e-46db-a475-f621cfe93340	open	2022-11-15 16:08:43.679038+00	2022-11-15 16:08:43.679065+00	\N
25	b71029e0-7215-4f1b-80be-32b061d9ba59	open	2022-11-15 16:52:01.00447+00	2022-11-15 16:52:01.004496+00	\N
26	f926cc66-87bb-462d-9b2f-5724b1aac22a	open	2022-11-15 16:52:41.681629+00	2022-11-15 16:52:41.681656+00	\N
27	a9bb5d80-277b-4ee6-95f5-6c5078f4f362	open	2022-11-15 21:08:34.117244+00	2022-11-15 21:08:34.117267+00	\N
28	a9e1a6c6-b836-465b-98ca-8bbf88db06f8	open	2022-11-15 21:08:57.787803+00	2022-11-15 21:08:57.787828+00	\N
29	49fdbab5-d103-4d44-956c-83268c5ccaeb	open	2022-11-16 06:55:44.490217+00	2022-11-16 06:55:44.490244+00	\N
30	8e344da5-5459-4219-a295-4cdbb6d08b3c	open	2022-11-16 13:27:55.209337+00	2022-11-16 13:27:55.209364+00	\N
31	7f3ff24c-2ce6-4b51-883a-c57afa29ee7e	open	2022-11-16 13:30:58.871314+00	2022-11-16 13:30:58.87134+00	\N
32	347d9c81-b5d2-43ab-8af8-95e5e64298b9	open	2022-11-16 13:31:09.125209+00	2022-11-16 13:31:09.125235+00	\N
33	9dba7f94-12e7-4ac7-b4f4-16312a168c47	open	2022-11-16 13:31:12.69245+00	2022-11-16 13:31:12.692476+00	\N
34	9eeec7e4-6c06-414a-8709-ab4267302194	open	2022-11-16 13:31:14.083792+00	2022-11-16 13:31:14.08382+00	\N
35	ea8777fd-29b4-4eba-a3da-bd85e3858d0c	open	2022-11-16 13:31:26.944952+00	2022-11-16 13:31:26.944978+00	\N
36	a535e0a6-915a-4fd2-99f2-4176f2a1ea9e	open	2022-11-16 13:31:52.955672+00	2022-11-16 13:31:52.955699+00	\N
37	4f121fc3-7a94-40a0-9f6b-5830eb0739c2	open	2022-11-16 15:13:37.128823+00	2022-11-16 15:13:37.12885+00	\N
38	11b2fe1c-5064-4154-9b8c-59842d9274b0	open	2022-11-16 15:13:55.775468+00	2022-11-16 15:13:55.775493+00	\N
39	9f84dc49-3324-4239-a215-7f5ad33e886f	open	2022-11-16 15:14:24.583851+00	2022-11-16 15:14:24.583876+00	\N
40	6ed34a88-14de-400c-a290-e97f0c945a17	open	2022-11-16 15:18:17.824053+00	2022-11-16 15:18:17.824081+00	\N
41	95b319fd-d380-4308-a4e8-eea0ec8c2f0c	open	2022-11-17 13:54:44.789027+00	2022-11-17 13:54:44.789055+00	\N
42	17c22dcb-a9fc-4859-bc9b-36096776572f	open	2022-11-18 12:11:23.14304+00	2022-11-18 12:11:23.143072+00	\N
43		open	2022-11-22 01:39:37.332995+00	2022-11-22 01:39:37.333018+00	33
44	716a0791-a347-414e-951a-20318498b5a2	open	2022-11-23 06:06:58.874368+00	2022-11-23 06:06:58.874394+00	\N
1	73c0b580-3242-45d0-92e3-e6a42d1ef50f	open	2022-11-11 13:31:17.031231+00	2022-11-25 12:07:54.222431+00	34
46	d9fad55e-2358-4752-85cb-695e417a06d3	open	2022-11-28 17:06:53.758218+00	2022-11-28 17:06:53.758248+00	\N
47	34c6f3a0-307f-4c33-bbe0-eddebae253aa	open	2022-11-28 22:31:17.213285+00	2022-11-28 22:31:17.213313+00	\N
48	bb26b585-6dab-441c-8d8a-31ad7421325c	open	2022-11-28 22:31:17.786748+00	2022-11-28 22:31:17.786777+00	\N
49	5c343a8a-ac6c-450e-86a1-b9127b06f6f9	open	2022-11-29 02:43:47.223982+00	2022-11-29 02:43:47.224014+00	\N
50	65b977b9-2ddf-446f-99e3-5c72890cb26e	open	2022-11-29 02:55:20.730541+00	2022-11-29 02:55:20.730589+00	\N
51	7a151349-9ca5-46ff-ba02-ba311910c518	open	2022-11-29 03:13:02.407631+00	2022-11-29 03:13:02.407669+00	\N
52	415e7d01-6170-42f1-984f-1bbb8caefe78	open	2022-11-29 03:26:08.016654+00	2022-11-29 03:26:08.016694+00	\N
53	15f695f6-8866-4371-b49c-c8eb5b1dd8fc	open	2022-11-29 03:26:45.455742+00	2022-11-29 03:26:45.45577+00	\N
54	7307cf21-007b-43f5-a3ee-95bb522df52b	open	2022-11-29 03:27:41.544339+00	2022-11-29 03:27:41.544367+00	\N
55	6fd192de-d275-4a12-9771-53e19f3d1495	open	2022-11-29 16:07:33.276616+00	2022-11-29 16:07:33.276648+00	\N
56	a5e6f2c8-f8ad-4d9a-a4ef-03898a4a53b3	open	2022-11-29 16:08:01.459155+00	2022-11-29 16:08:01.459184+00	\N
534	c4103d95-2266-464b-a3f1-8d80bbf26008	open	2023-03-09 10:14:22.986836+00	2023-03-09 10:14:22.986863+00	\N
13	2ed45465-9e86-47d0-b792-5a54135d4cd7	discard	2022-11-15 08:45:03.657919+00	2022-11-25 15:00:25.834762+00	38
64	052b3529-7e62-4aae-af87-d976830da8ab	open	2022-12-07 17:22:43.531148+00	2022-12-07 17:22:43.531177+00	\N
65	ec89fffb-7fde-4e9d-ab4e-bfc1568f4f0f	open	2022-12-07 17:24:10.550919+00	2022-12-07 17:24:10.550948+00	\N
68		open	2022-12-08 07:54:24.322375+00	2022-12-08 07:54:24.322397+00	57
69	d75074a5-c3e2-44e9-bbc6-bc43016058d3	open	2022-12-08 08:29:30.142351+00	2022-12-08 08:29:30.142377+00	\N
70	9cfa006e-9480-43a7-be73-92c3f8291b60	open	2022-12-08 08:30:03.701618+00	2022-12-08 08:30:03.701645+00	\N
71	3ff671c4-4331-4ab7-978d-76ad3f9df5d9	open	2022-12-08 08:30:45.999585+00	2022-12-08 08:30:45.999614+00	\N
72	9df10665-8356-465e-9bfc-68ef5eff129d	open	2022-12-08 08:31:09.802022+00	2022-12-08 08:31:09.80205+00	\N
73	7710f34f-f343-422d-aff3-df67828e056d	open	2022-12-08 08:33:50.868323+00	2022-12-08 08:33:50.868349+00	\N
74	8a31ccb4-fee1-4136-b793-66be6c24a302	open	2022-12-08 08:46:14.207365+00	2022-12-08 08:46:14.207391+00	\N
75	d2866022-d847-4d18-b2de-f7f3f9d67c81	open	2022-12-08 08:46:18.889343+00	2022-12-08 08:46:18.889371+00	\N
76	c96ac0f6-f201-4a51-8e89-8382cf334e1a	open	2022-12-08 09:04:23.814184+00	2022-12-08 09:04:23.814211+00	\N
77	357aaa26-5cfa-4686-bb0a-ce1fbdfa5562	open	2022-12-08 09:04:26.009336+00	2022-12-08 09:04:26.00936+00	\N
78	1f93b33f-551e-489c-b8ca-3ed07858026c	open	2022-12-08 09:05:00.152621+00	2022-12-08 09:05:00.152648+00	\N
79	23861f8e-4df1-48ee-be18-7eae67429640	open	2022-12-08 09:35:31.2148+00	2022-12-08 09:35:31.214826+00	\N
80	40aaa0a3-04cf-472e-a91e-6a698b83a541	open	2022-12-08 09:35:36.206814+00	2022-12-08 09:35:36.206842+00	\N
81	b0a8a0d2-fafc-450c-8181-7a0d5d69340b	open	2022-12-08 09:35:39.861922+00	2022-12-08 09:35:39.86195+00	\N
82	fd09837d-d425-4599-80ee-fde2afc7d8f9	open	2022-12-08 09:35:53.855335+00	2022-12-08 09:35:53.855363+00	\N
83	b5db2357-5017-4208-a2dc-a52f546bf397	open	2022-12-08 09:45:41.630247+00	2022-12-08 09:45:41.630275+00	\N
84	621c69b4-fc85-4c2f-9c8e-0672a2e590f4	open	2022-12-08 09:45:44.925827+00	2022-12-08 09:45:44.925853+00	\N
85	6a1095c3-406f-40da-9adc-a6355c5851a9	open	2022-12-08 09:48:34.867197+00	2022-12-08 09:48:34.867225+00	\N
86		open	2022-12-08 09:48:43.542848+00	2022-12-08 09:48:43.542873+00	55
87	2785deff-c0d5-4bc9-8d65-e62c49f6a0b5	open	2022-12-08 09:56:08.180694+00	2022-12-08 09:56:08.180722+00	\N
88	47e7fff1-c952-4113-960d-86c3df15d52c	open	2022-12-08 09:58:52.066246+00	2022-12-08 09:58:52.066272+00	\N
89	1254bd0a-be42-4c4f-9e91-fb5079cc05f9	open	2022-12-08 10:01:06.574069+00	2022-12-08 10:01:06.574106+00	\N
90	c9ecc8e5-af0f-4377-b7f9-b2ce9e1c66ad	open	2022-12-08 10:03:35.032859+00	2022-12-08 10:03:35.032882+00	\N
92	4ce8b23f-ac76-460f-a2fb-46a00cc7a967	open	2022-12-08 10:18:20.224499+00	2022-12-08 10:18:20.224526+00	\N
93	764af59d-10c4-4ff2-8398-27cf101f59aa	open	2022-12-08 10:18:24.779333+00	2022-12-08 10:18:24.779361+00	\N
94	3d8b7e7f-84ee-4ac2-a90c-b74edd2cc339	open	2022-12-08 10:19:00.191589+00	2022-12-08 10:19:00.191617+00	\N
95	811e787f-fe49-4a45-875c-f3f8eb4eaa94	open	2022-12-08 10:19:00.389167+00	2022-12-08 10:19:00.389193+00	\N
96	ffe0b4c8-f528-4894-ac3c-31f3d8952a9d	open	2022-12-08 10:19:23.314981+00	2022-12-08 10:19:23.315008+00	\N
97	7dea6701-dcfb-44fe-8f32-5b9fbc558822	open	2022-12-08 10:20:15.598078+00	2022-12-08 10:20:15.598115+00	\N
525		closed	2023-02-11 21:04:22.766348+00	2023-02-12 15:23:11.780222+00	38
528		closed	2023-02-13 08:39:55.896166+00	2023-02-13 11:05:33.845602+00	35
100	238313de-ae14-4979-a303-857bcf9499a3	open	2022-12-08 13:34:19.390256+00	2022-12-08 13:34:19.390284+00	\N
101	8d361f89-c65b-4477-a731-a3903e3bfa65	open	2022-12-08 13:34:20.699547+00	2022-12-08 13:34:20.699606+00	\N
102	ed66f5e3-8916-4bb7-a6eb-31208e859e87	open	2022-12-08 13:34:22.25418+00	2022-12-08 13:34:22.254209+00	\N
103	a9733ad4-80c2-4aa7-a6ec-b9a36f5532fb	open	2022-12-08 13:34:23.836225+00	2022-12-08 13:34:23.836258+00	\N
104	1db53cba-0ab2-4c7b-ac8b-0a1ce4f20606	open	2022-12-08 13:34:25.639354+00	2022-12-08 13:34:25.63938+00	\N
105	c874dcd9-68d1-4654-9b79-c4495f646db6	open	2022-12-08 13:34:27.779725+00	2022-12-08 13:34:27.779752+00	\N
106	b720b172-0aa6-4231-8713-ee555fdf6cf3	open	2022-12-08 13:34:56.145842+00	2022-12-08 13:34:56.14587+00	\N
107	644ab474-8e7b-482b-adae-161e074e66d7	open	2022-12-08 13:34:57.433731+00	2022-12-08 13:34:57.433758+00	\N
108	b637172f-8be5-427c-ae7e-215c1ae2ff63	open	2022-12-08 13:34:59.663262+00	2022-12-08 13:34:59.663289+00	\N
109	f782c91d-9758-406b-b756-dfb10ce9868e	open	2022-12-08 13:35:01.755977+00	2022-12-08 13:35:01.756007+00	\N
110	64f4e851-0a74-4a9c-b425-76ad37c4359c	open	2022-12-08 13:36:09.310625+00	2022-12-08 13:36:09.31065+00	\N
111	ebb4bbc1-3da7-452f-8c8f-c80ea7ad24c3	open	2022-12-08 13:36:17.357631+00	2022-12-08 13:36:17.357659+00	\N
112	51476942-1443-4bc9-b71e-a0e521bca98e	open	2022-12-08 13:36:20.810672+00	2022-12-08 13:36:20.810695+00	\N
113	c4641250-2583-4641-bbae-e97095fe5abe	open	2022-12-08 13:36:23.604277+00	2022-12-08 13:36:23.6043+00	\N
114	fe6938a9-8377-4449-8394-9511526fc284	open	2022-12-08 13:38:29.826948+00	2022-12-08 13:38:29.826973+00	\N
115	635be5b7-5a17-404e-bf99-2edfe6108b53	open	2022-12-08 13:39:19.714584+00	2022-12-08 13:39:19.714603+00	\N
116	06e90403-a803-405e-b180-dc1b20a3bd99	open	2022-12-08 13:43:58.161132+00	2022-12-08 13:43:58.161163+00	\N
117	2e6e499b-fbf3-4f70-8080-a603eb3435c2	open	2022-12-08 13:43:59.247036+00	2022-12-08 13:43:59.247066+00	\N
317	a92f3e50-35fd-497a-a05a-35a388e36b1f	open	2022-12-15 14:26:22.631109+00	2022-12-15 14:26:22.631138+00	\N
320	b5fd258f-da04-4e54-aa4f-3831d569dfa0	open	2022-12-15 14:29:56.338693+00	2022-12-15 14:29:56.338721+00	\N
122	f463bd3d-b0f0-4bca-994c-936115511678	open	2022-12-08 23:01:09.983019+00	2022-12-08 23:01:09.983047+00	\N
123	67566d2a-5d33-48a6-9e30-02f4618a9165	open	2022-12-08 23:03:59.427164+00	2022-12-08 23:03:59.427192+00	\N
124	63b96d7e-450d-41d9-9060-79e454829d67	open	2022-12-08 23:04:55.186759+00	2022-12-08 23:04:55.186785+00	\N
125	e28b32be-af80-4d05-92fb-97ab809caca3	open	2022-12-09 07:54:30.968465+00	2022-12-09 07:54:30.968492+00	\N
126	10d08e13-fe38-4868-ad16-36040d163def	open	2022-12-09 07:57:06.608592+00	2022-12-09 07:57:06.608623+00	\N
127	ad036813-dab1-46a8-8cf3-2938ba15e824	open	2022-12-09 07:58:45.622986+00	2022-12-09 07:58:45.623014+00	\N
129	7db63a18-b934-46e1-8c5d-1096450b38df	open	2022-12-09 07:58:56.051845+00	2022-12-09 07:58:56.051874+00	\N
130	f302ae91-4c55-49b1-b064-f1b8416cab60	open	2022-12-09 08:00:53.606304+00	2022-12-09 08:00:53.606331+00	\N
131	2cc81001-b759-4e44-8989-3af0f838f7e3	open	2022-12-09 08:01:03.591999+00	2022-12-09 08:01:03.592024+00	\N
132	f4368c5d-bdce-4fb6-b7ec-0f769d2ff8f9	open	2022-12-09 08:01:05.872471+00	2022-12-09 08:01:05.872499+00	\N
133	b0610df8-4f50-4b45-8017-9c8d5e89ac0c	open	2022-12-09 08:01:08.372999+00	2022-12-09 08:01:08.373026+00	\N
134	2a905638-d2a4-4001-b07d-2a2a8b295b0d	open	2022-12-09 09:03:29.183329+00	2022-12-09 09:03:29.183353+00	\N
135	ed786873-cce4-4ed3-b02c-9489bebca69c	open	2022-12-09 09:04:01.818767+00	2022-12-09 09:04:01.818793+00	\N
136	7eb1ec71-919c-4b0c-ac8a-dec40ea8f742	open	2022-12-09 09:04:40.37945+00	2022-12-09 09:04:40.379476+00	\N
137	b11f855b-5fe9-48f7-a103-586f2ace4321	open	2022-12-09 09:04:41.228452+00	2022-12-09 09:04:41.228479+00	\N
138	5d9793ad-f8d0-4f9c-a6e7-8e213efd671e	open	2022-12-09 09:05:07.720538+00	2022-12-09 09:05:07.720589+00	\N
140	0a22da88-2363-46a9-8ce7-1fe9072c993f	open	2022-12-09 09:14:39.248197+00	2022-12-09 09:14:39.248222+00	\N
141	f4eed875-f790-4f43-9669-4aa1b1e249d4	open	2022-12-09 09:23:53.91734+00	2022-12-09 09:23:53.917365+00	\N
142	dbf6ba40-8b9e-4d0b-a9f9-3e7f80f16a76	open	2022-12-09 09:32:08.886288+00	2022-12-09 09:32:08.886311+00	\N
143	239df5dd-e7fe-4a96-a700-9dfe38f99558	open	2022-12-09 09:32:17.549035+00	2022-12-09 09:32:17.549061+00	\N
144	c20f6e96-dfa5-498c-977e-a05180003888	open	2022-12-09 09:32:19.279185+00	2022-12-09 09:32:19.279215+00	\N
145	af9397b5-6551-472d-ac2f-b984c6cade91	open	2022-12-09 09:32:51.019679+00	2022-12-09 09:32:51.019706+00	\N
146	a8464eec-3e30-47dd-8485-778d355a36bb	open	2022-12-09 09:37:00.368491+00	2022-12-09 09:37:00.36852+00	\N
147	b49e48b2-d44d-4da3-a03c-bb17a42d56a8	open	2022-12-09 09:38:24.877886+00	2022-12-09 09:38:24.877914+00	\N
148	97e4d944-265a-43e1-a554-5ed5d07694b0	open	2022-12-09 09:38:31.319141+00	2022-12-09 09:38:31.319168+00	\N
149	7e103fed-f291-4fd1-8427-35c5d54cc3f7	open	2022-12-09 09:38:46.073429+00	2022-12-09 09:38:46.073456+00	\N
152	3b9a0af7-90b6-476c-9956-52b5a07e6ec5	open	2022-12-09 09:44:57.018106+00	2022-12-09 09:44:57.018135+00	\N
155	eb15e1a8-31ea-4a60-8089-c2da948e7740	open	2022-12-09 10:13:00.221855+00	2022-12-09 10:13:00.221883+00	\N
156	9438f2d5-b90f-47d5-a586-2453b3cc2b96	open	2022-12-09 10:14:24.848169+00	2022-12-09 10:14:24.848196+00	\N
157	c11292b3-0c13-4b97-8a51-099c85a17fb3	open	2022-12-09 10:15:16.752801+00	2022-12-09 10:15:16.752828+00	\N
158	1aaad378-481d-4711-870f-2e5a173d2a53	open	2022-12-09 10:16:03.145018+00	2022-12-09 10:16:03.145045+00	\N
159	8c22f0f5-93e2-45fe-a031-1a7d285bcd21	open	2022-12-09 10:16:52.525144+00	2022-12-09 10:16:52.525181+00	\N
160	18dcb391-15ff-4561-bf1e-36f03ada5cc6	open	2022-12-09 10:17:23.669206+00	2022-12-09 10:17:23.669232+00	\N
165	801150f1-49dc-4c8e-9b15-b8fca3f412db	open	2022-12-09 13:46:42.918035+00	2022-12-09 13:46:42.918064+00	\N
166	9070851a-7652-415b-8dc4-ab2cb8a7c13b	open	2022-12-09 13:47:07.444699+00	2022-12-09 13:47:07.444726+00	\N
167	dcd62095-b13f-4d96-9a89-18222674d14d	open	2022-12-09 13:48:55.771666+00	2022-12-09 13:48:55.771694+00	\N
168	330999f9-09d2-4a4a-b552-d149bb64324b	open	2022-12-09 13:49:43.725269+00	2022-12-09 13:49:43.725296+00	\N
169	096c031b-e952-4345-a7d7-0a7cc399f453	open	2022-12-09 13:50:05.449066+00	2022-12-09 13:50:05.449093+00	\N
170	eb7d2b34-7e80-464e-9595-91b06579c6c1	open	2022-12-09 14:59:08.261665+00	2022-12-09 14:59:08.261695+00	\N
171	6969c2f7-f41e-4142-8101-536a63bded62	open	2022-12-09 14:59:25.124041+00	2022-12-09 14:59:25.124073+00	\N
172	f4ef4fc2-a0fe-430f-a62c-639c1fdcd8f0	open	2022-12-09 14:59:30.808414+00	2022-12-09 14:59:30.808441+00	\N
173	bd5b9ee8-b4c5-4988-b0b7-4dc49e888e5a	open	2022-12-09 14:59:31.918019+00	2022-12-09 14:59:31.918044+00	\N
174	d7b1b628-8ca6-44b6-972a-1a21c428a559	open	2022-12-09 14:59:34.180402+00	2022-12-09 14:59:34.180427+00	\N
175	e6c999f1-2e2f-435d-86a7-884376721071	open	2022-12-09 15:00:13.275984+00	2022-12-09 15:00:13.276012+00	\N
176	f386c116-02dd-4334-83be-66badb52b789	open	2022-12-09 15:00:34.032+00	2022-12-09 15:00:34.032027+00	\N
177	7d091a41-a15d-453b-9d84-bd8e8f14c933	open	2022-12-09 15:00:36.593628+00	2022-12-09 15:00:36.593652+00	\N
182	bd8976d2-f0b0-4c5a-8ef4-72e7f48e9a03	open	2022-12-10 07:38:09.481248+00	2022-12-10 07:38:09.481277+00	\N
183	fdd58043-5f82-4a1e-9009-5e560f9f443c	open	2022-12-10 07:40:07.17276+00	2022-12-10 07:40:07.172786+00	\N
184	7aa545e7-4a78-4be4-bece-daf993134b54	open	2022-12-10 07:50:46.168827+00	2022-12-10 07:50:46.168852+00	\N
185	312d835e-e022-42b4-8461-6be79e24fac3	open	2022-12-10 07:50:57.145896+00	2022-12-10 07:50:57.145922+00	\N
186	c5335bfc-8909-451d-a5bb-aaea9cdd11df	open	2022-12-10 07:51:00.75035+00	2022-12-10 07:51:00.750372+00	\N
189	6d38f5a6-32cc-438c-969d-0d17c593c508	open	2022-12-10 08:02:49.745269+00	2022-12-10 08:02:49.745299+00	\N
190	5db20f76-2a1b-4a53-b039-e9ebcc34b902	open	2022-12-10 08:02:51.44242+00	2022-12-10 08:02:51.44245+00	\N
191	069f2053-f66d-4fee-b560-31ec0bdd084a	open	2022-12-10 08:02:54.851207+00	2022-12-10 08:02:54.851236+00	\N
193	23d9ca13-4d90-4383-8c65-184758cfcdcc	open	2022-12-10 08:04:05.557866+00	2022-12-10 08:04:05.557894+00	\N
194	bd6cf16d-f7cb-413d-a51f-33dc5ae993d6	open	2022-12-10 08:04:09.752327+00	2022-12-10 08:04:09.752355+00	\N
195	e9f69e53-1230-4df0-bfe6-56567fee6711	open	2022-12-10 08:04:11.268958+00	2022-12-10 08:04:11.268986+00	\N
197	f96aead7-c2cd-4518-9759-f70f05f12bf6	open	2022-12-10 08:09:18.787879+00	2022-12-10 08:09:18.787911+00	\N
198	0190808c-7995-4b8d-9855-0988f7651c27	open	2022-12-10 08:13:17.798733+00	2022-12-10 08:13:17.79876+00	\N
199	a65b4464-22e1-48f7-ad0f-e159d9f73fb5	open	2022-12-10 08:13:24.05061+00	2022-12-10 08:13:24.050638+00	\N
200	c2189ec3-75da-4918-bff5-59443987102b	open	2022-12-10 08:14:00.031331+00	2022-12-10 08:14:00.031356+00	\N
201	d95e5d25-63a6-491c-8f1f-4f4086e215a2	open	2022-12-10 08:14:04.217523+00	2022-12-10 08:14:04.217548+00	\N
202	68344e64-8a26-4361-b82b-b04ebdffbd01	open	2022-12-10 08:15:00.044028+00	2022-12-10 08:15:00.044057+00	\N
203	1c6b670b-762f-4e80-a888-27020c009148	open	2022-12-10 08:16:27.303633+00	2022-12-10 08:16:27.30366+00	\N
204	ca20888f-764a-4e5b-8d24-14322d995f81	open	2022-12-10 08:16:40.219979+00	2022-12-10 08:16:40.22+00	\N
205	de4c0b43-7f74-4caa-b2c4-d140798f394f	open	2022-12-10 08:16:40.220101+00	2022-12-10 08:16:40.220138+00	\N
206	60b52fa0-4fb3-4d0b-9653-81ce259f6a65	open	2022-12-10 08:29:59.804236+00	2022-12-10 08:29:59.80426+00	\N
208	3b088905-6885-455d-a922-5e2f24a1812a	open	2022-12-10 08:34:02.454711+00	2022-12-10 08:34:02.454738+00	\N
318	d1d34530-d729-46e7-9552-b8306be74108	open	2022-12-15 14:28:05.650215+00	2022-12-15 14:28:05.650253+00	\N
210	59a64515-cbc4-4f98-821a-7f6b3cc50491	open	2022-12-10 08:34:56.530935+00	2022-12-10 08:34:56.530964+00	\N
211	4ec850e6-5e3c-43ba-b712-7bc73c944552	open	2022-12-10 08:34:59.582067+00	2022-12-10 08:34:59.582089+00	\N
212	7c9f5110-8174-487a-a4b4-60e2a1ffb98d	open	2022-12-10 08:42:18.956541+00	2022-12-10 08:42:18.956594+00	\N
321	c0548414-0d77-48f5-a6d3-e528f9b0cde2	open	2022-12-16 11:14:49.569041+00	2022-12-16 11:14:49.569067+00	\N
215	c35c01da-f158-4697-aa9f-7b3953fdab2f	open	2022-12-10 08:48:46.172005+00	2022-12-10 08:48:46.172032+00	\N
324	23394e7e-00bc-4673-8db2-4b6822ab2ac1	open	2022-12-16 14:48:32.829948+00	2022-12-16 14:48:32.829974+00	\N
217	0cfedd4e-5f4b-4211-b24b-d5e5036e55a6	open	2022-12-10 08:49:15.167348+00	2022-12-10 08:49:15.167373+00	\N
325	4353c261-0a10-4d96-8b82-678e928ebcfa	open	2022-12-16 14:54:45.512709+00	2022-12-16 14:54:45.512736+00	\N
219	53a03ffc-0c85-4ccc-8a94-914e338ae97f	open	2022-12-10 08:49:57.421222+00	2022-12-10 08:49:57.421249+00	\N
326	65baa72c-bf9d-4a3f-8ba8-d36440a92ee6	open	2022-12-16 15:50:22.277692+00	2022-12-16 15:50:22.27772+00	\N
327	56d55550-a936-4c4f-a008-87e937e79c55	open	2022-12-19 10:23:49.994932+00	2022-12-19 10:23:49.99496+00	\N
222	3bed855a-4523-4e93-84de-460d893f1e1c	open	2022-12-10 08:51:46.720167+00	2022-12-10 08:51:46.720188+00	\N
223	6b03acca-a2ff-468a-a440-1bfa9b14a814	open	2022-12-10 08:51:51.425352+00	2022-12-10 08:51:51.425377+00	\N
224	abcac6b2-95e4-4054-a105-cc2e36c7164f	open	2022-12-10 08:52:09.013664+00	2022-12-10 08:52:09.013685+00	\N
225	c5d68404-b1a9-498b-99b4-9640083fa32b	open	2022-12-10 08:52:11.899937+00	2022-12-10 08:52:11.899961+00	\N
226	9606ca42-1a63-49b1-a22b-ccd05aa7f11d	open	2022-12-10 08:52:21.376687+00	2022-12-10 08:52:21.376715+00	\N
227	da8b4605-6bf9-426e-a6a0-6157a387deea	open	2022-12-10 08:56:20.173973+00	2022-12-10 08:56:20.173997+00	\N
328	8205686d-43d3-4466-a72e-c7dbb710eefd	open	2022-12-20 10:02:17.697392+00	2022-12-20 10:02:17.697423+00	\N
535	a61c6980-038d-4691-99ff-763f21072467	open	2023-03-09 10:14:37.359401+00	2023-03-09 10:14:37.359422+00	\N
330	eb08c9a5-8692-480e-8c5a-18aaa5c0ff51	open	2022-12-20 10:10:47.842944+00	2022-12-20 10:10:47.842973+00	\N
231	349df982-1842-4d06-9b4f-c2e6bd61e235	open	2022-12-10 09:12:07.203622+00	2022-12-10 09:12:07.203653+00	\N
232	a88be9e5-75aa-4585-9c02-33fe793c989e	open	2022-12-10 09:12:10.704328+00	2022-12-10 09:12:10.704351+00	\N
536		closed	2023-03-24 08:36:57.486761+00	2023-03-24 09:09:58.442009+00	37
332	7867162a-649e-4379-acb0-74374b543279	open	2022-12-21 09:11:11.059439+00	2022-12-21 09:11:11.059469+00	\N
333	476f0b06-dd25-4886-9b5d-20d87cc45d1e	open	2022-12-21 09:12:56.730056+00	2022-12-21 09:12:56.730083+00	\N
334	97264ac4-ffa1-4e60-bce5-d4a733636762	open	2022-12-22 08:28:55.802637+00	2022-12-22 08:28:55.802665+00	\N
335	2ac6a200-e798-4e15-b545-52cbb2e3995f	open	2022-12-22 08:29:03.134684+00	2022-12-22 08:29:03.13471+00	\N
336	55ddffe0-77f5-4e28-9d0c-f56d36c3564a	open	2022-12-22 08:29:06.494466+00	2022-12-22 08:29:06.494488+00	\N
537		closed	2023-03-24 09:23:39.127526+00	2023-03-24 09:28:25.376335+00	37
240	b4b06b12-ecd2-4fac-b480-dd363cc1d94c	open	2022-12-10 09:51:44.09902+00	2022-12-10 09:51:44.099045+00	\N
338	f6efb99d-0aaa-40ef-829c-c640079a65c3	open	2022-12-22 13:24:45.534749+00	2022-12-22 13:24:45.534777+00	\N
339		open	2022-12-22 14:49:08.714794+00	2022-12-22 14:49:08.714817+00	61
243	93704b6d-4018-4809-a9ba-6ae759282f82	open	2022-12-10 10:11:30.367342+00	2022-12-10 10:11:30.36737+00	\N
244	e168c006-8994-4faf-aea7-4bedea025a7f	open	2022-12-10 11:25:18.81613+00	2022-12-10 11:25:18.816158+00	\N
245	027974b2-9399-464b-bd5a-c5bfcef9b4f5	open	2022-12-12 08:10:25.02005+00	2022-12-12 08:10:25.020076+00	\N
538		closed	2023-03-24 09:36:00.029021+00	2023-03-24 09:39:57.152696+00	35
341	af9532fe-28b8-45ab-a4e6-bcbdc125bf37	open	2022-12-28 09:44:48.616514+00	2022-12-28 09:44:48.616541+00	\N
248	c7bc9587-dfc6-4664-9246-35ce10f80322	open	2022-12-12 09:18:26.312719+00	2022-12-12 09:18:26.312746+00	\N
249	94ce9b2e-7628-414b-a17a-16f414e54ac0	open	2022-12-12 09:35:44.597357+00	2022-12-12 09:35:44.597383+00	\N
539		closed	2023-03-24 10:01:41.396789+00	2023-03-24 10:03:08.684377+00	35
344		open	2022-12-30 11:26:52.005452+00	2022-12-30 11:26:52.005474+00	62
254	6fbf31e6-b5b9-47aa-b1e8-f0860fff7745	open	2022-12-12 12:31:19.858156+00	2022-12-12 12:31:19.858184+00	\N
255	3c2706d9-bdba-4c10-81a8-411cb17bbef6	open	2022-12-12 12:33:31.686394+00	2022-12-12 12:33:31.686419+00	\N
256	d3e67078-e9aa-449a-9845-85eb1ad8bcef	open	2022-12-12 12:54:31.653352+00	2022-12-12 12:54:31.653376+00	\N
258	699d3a90-c746-4ef3-8ec3-f120870b5f77	open	2022-12-12 13:00:18.205126+00	2022-12-12 13:00:18.205152+00	\N
259	03bb7078-0f47-4cb6-966f-c9e9766a5c7e	open	2022-12-12 13:02:14.038382+00	2022-12-12 13:02:14.038409+00	\N
260	24665f18-b374-49d3-9c5b-3970b040220b	open	2022-12-12 13:02:14.114376+00	2022-12-12 13:02:14.114398+00	\N
347	217ecf5d-6b5c-410f-829a-828aae305af3	open	2022-12-30 15:21:25.270333+00	2022-12-30 15:21:25.27036+00	\N
262	9d248bbf-fa13-4c35-b47b-e231039e40e3	open	2022-12-12 13:32:22.678821+00	2022-12-12 13:32:22.67885+00	\N
264	49740c21-394e-49ad-8b29-57108fd0163f	open	2022-12-12 13:38:43.514857+00	2022-12-12 13:38:43.514885+00	\N
266	44033a95-3a2b-40a0-b527-339a66d7a4e8	open	2022-12-12 14:16:55.283522+00	2022-12-12 14:16:55.283545+00	\N
267	b33fe4a0-e1bf-4c7b-b035-fb6cd6d9e5d0	open	2022-12-12 14:22:54.94633+00	2022-12-12 14:22:54.946357+00	\N
268	c6ac064d-7366-4363-bf7f-4b1a947a9580	open	2022-12-12 14:59:29.050931+00	2022-12-12 14:59:29.050957+00	\N
181		closed	2022-12-09 20:00:10.334955+00	2022-12-30 17:08:11.678633+00	35
352	0abf9e73-f103-4a4a-897d-1f7234bfc57e	open	2022-12-31 07:59:09.436973+00	2022-12-31 07:59:09.437008+00	\N
274	16753420-6e5a-4162-a20c-e7b13b97da9f	open	2022-12-12 15:21:22.216741+00	2022-12-12 15:21:22.216768+00	\N
275	7c55eb19-24d7-4c7c-995c-2c3e27e1cbf3	open	2022-12-12 17:53:05.891024+00	2022-12-12 17:53:05.891053+00	\N
355	c7c5d85b-0dd4-48f6-b0ee-b313d6642e67	open	2023-01-03 07:24:23.829257+00	2023-01-03 07:24:23.829286+00	\N
280	c0332c14-52eb-4be5-af26-0794a89cbc63	open	2022-12-13 14:17:11.567102+00	2022-12-13 14:17:11.567129+00	\N
348		closed	2022-12-30 15:26:16.479699+00	2023-01-04 11:07:38.557471+00	37
353		closed	2023-01-03 06:44:46.820924+00	2023-01-16 10:38:22.165216+00	35
283	0d7e4a73-dde7-4e82-a457-84de828b8163	open	2022-12-14 06:45:19.551769+00	2022-12-14 06:45:19.551795+00	\N
287	daa3b511-8e54-4138-88e5-15f998634a17	open	2022-12-14 13:18:42.000473+00	2022-12-14 13:18:42.0005+00	\N
290	5fc5f354-cc81-4ab8-967b-55cb743dd06a	open	2022-12-14 16:48:35.205765+00	2022-12-14 16:48:35.20579+00	\N
291	966544bb-fac2-4d37-8a19-5878ff30ec59	open	2022-12-14 21:42:51.893179+00	2022-12-14 21:42:51.893208+00	\N
294	d88ca15b-ba3e-4bff-94c3-e558d2831a5b	open	2022-12-15 08:11:34.363798+00	2022-12-15 08:11:34.363824+00	\N
356		closed	2023-01-03 08:14:53.719922+00	2023-01-03 10:17:36.52292+00	64
523		closed	2023-01-28 14:20:17.963542+00	2023-02-10 15:38:18.593874+00	38
509		closed	2023-01-20 13:39:48.237614+00	2023-02-12 20:35:35.362512+00	35
359		closed	2023-01-04 17:29:47.052634+00	2023-01-04 17:31:46.687367+00	64
360		closed	2023-01-04 17:38:28.109496+00	2023-01-04 17:40:23.959066+00	64
361	19a2ecb6-4090-4799-afed-6234816edd6d	open	2023-01-04 18:10:27.216165+00	2023-01-04 18:10:27.216192+00	\N
363	83a02d8f-383a-4f3f-9592-796eb07bad8a	open	2023-01-05 08:41:57.287667+00	2023-01-05 08:41:57.287693+00	\N
364		closed	2023-01-05 08:54:07.40824+00	2023-01-05 09:08:41.473156+00	37
366	261f4d89-8290-4000-ac75-54aa0a03ab2b	open	2023-01-05 09:38:35.62954+00	2023-01-05 09:38:35.629593+00	\N
367	3f61d1f7-5858-4d66-aa73-1a8f33410c8d	open	2023-01-05 09:39:42.219548+00	2023-01-05 09:39:42.219606+00	\N
365		closed	2023-01-05 09:36:33.689661+00	2023-01-05 09:45:00.564702+00	37
368	e6c47392-b900-49c4-861f-2edbb1a29469	open	2023-01-05 10:05:25.588489+00	2023-01-05 10:05:25.588513+00	\N
369	6ed31bd5-7d05-46a2-a2e8-cde593724ed1	open	2023-01-05 10:17:19.675906+00	2023-01-05 10:17:19.675933+00	\N
362		closed	2023-01-04 18:14:17.005947+00	2023-01-05 10:33:54.507629+00	64
370		closed	2023-01-05 11:43:28.46042+00	2023-01-05 14:19:11.240924+00	64
527		closed	2023-02-13 08:28:27.234497+00	2023-02-13 08:29:58.015046+00	35
373	e8449abb-5c0c-408c-b0cc-d34351851c8f	open	2023-01-05 19:52:49.29651+00	2023-01-05 19:52:49.296537+00	\N
521		closed	2023-02-21 08:12:57.545+00	2023-02-21 10:56:12.757+00	37
378		open	2023-01-06 07:47:18.844982+00	2023-01-06 07:47:18.845007+00	72
380	66baeacb-5fe9-4061-8e90-4ef49fd5a5b4	open	2023-01-06 08:18:20.657643+00	2023-01-06 08:18:20.657669+00	\N
381	70c0db85-fc06-47df-9c85-04e62e52dd49	open	2023-01-06 08:29:51.860545+00	2023-01-06 08:29:51.860593+00	\N
382		closed	2023-01-06 08:33:35.029902+00	2023-01-06 08:41:18.957495+00	37
384	1626d1d6-98cc-4c24-ba1c-7c150dc4df3f	open	2023-01-06 08:45:38.496336+00	2023-01-06 08:45:38.496362+00	\N
385		open	2023-01-06 08:50:11.012492+00	2023-01-06 08:50:11.012516+00	53
386	f3d0dfba-6ab7-46d8-9509-07f4cf300d73	open	2023-01-06 08:55:34.393913+00	2023-01-06 08:55:34.393942+00	\N
387	bdeb7dd2-4680-4628-aeb4-edbe4df264a8	open	2023-01-06 08:57:41.157448+00	2023-01-06 08:57:41.157474+00	\N
388	c2e992ce-5b59-46ff-adbe-8f1cb02ca0d6	open	2023-01-06 09:01:02.631859+00	2023-01-06 09:01:02.631885+00	\N
389	c7616c3d-6aa9-4411-9ff9-1a4cf224fdde	open	2023-01-06 09:03:35.741776+00	2023-01-06 09:03:35.741803+00	\N
392		open	2023-01-06 10:04:25.143288+00	2023-01-06 10:04:25.143312+00	64
393	20fde32e-3915-48f4-9880-2e8a2b08aca6	open	2023-01-06 10:15:01.187626+00	2023-01-06 10:15:01.187653+00	\N
394	86d5ffa9-fce6-4c3f-b994-caca32d55092	open	2023-01-06 10:16:44.910636+00	2023-01-06 10:16:44.910664+00	\N
395	03cb95aa-4f47-476e-bf6f-0d008f00ebc9	open	2023-01-06 10:19:50.878844+00	2023-01-06 10:19:50.878871+00	\N
396	96c7a49d-c07e-44ab-a7e8-9ef27505a245	open	2023-01-06 10:21:16.34138+00	2023-01-06 10:21:16.341408+00	\N
397	cb44ff91-6860-422d-9c63-9d36e479acb9	open	2023-01-06 10:26:05.170681+00	2023-01-06 10:26:05.170709+00	\N
398	5070b4a7-92cc-42c8-b244-7856e8d73882	open	2023-01-06 10:27:37.968552+00	2023-01-06 10:27:37.968602+00	\N
399	d051bf2d-ec24-4ee0-b6d9-cdd3e644e6bc	open	2023-01-06 10:27:43.06599+00	2023-01-06 10:27:43.066018+00	\N
400	496cdd76-11c0-487d-9de7-ad17655efc50	open	2023-01-06 10:44:03.763305+00	2023-01-06 10:44:03.763331+00	\N
401	004c79e4-273d-40f7-9d57-745a43c97767	open	2023-01-06 10:46:12.675459+00	2023-01-06 10:46:12.675493+00	\N
402	9e0718d8-a8c6-44b6-92a8-4ca3169ff38d	open	2023-01-06 10:48:51.742651+00	2023-01-06 10:48:51.742681+00	\N
403	c38a1a9e-a574-453d-9d5a-402b3503ac70	open	2023-01-06 10:53:22.582703+00	2023-01-06 10:53:22.582732+00	\N
404	20656a76-743e-4c84-915a-fd25a719b42e	open	2023-01-06 10:59:58.863407+00	2023-01-06 10:59:58.863434+00	\N
405	64368dac-ff26-4e39-9e74-594f0a7b1968	open	2023-01-06 11:02:29.286062+00	2023-01-06 11:02:29.286088+00	\N
406	c72d7693-7e1a-4786-8532-4631ea272e82	open	2023-01-06 11:06:10.205194+00	2023-01-06 11:06:10.205221+00	\N
407	57ef543e-6198-4dc1-96ef-9c54aa53bb4b	open	2023-01-06 11:10:33.682996+00	2023-01-06 11:10:33.683026+00	\N
408	e43729c0-debf-4b44-a87f-86a55ca199a0	open	2023-01-06 11:15:49.490682+00	2023-01-06 11:15:49.490711+00	\N
409	4afd49b8-a4c8-4e25-ae13-78113a723c16	open	2023-01-06 11:19:25.816044+00	2023-01-06 11:19:25.81607+00	\N
410	977d9c3c-5117-4571-9b61-5b246b5212d5	open	2023-01-06 11:23:35.061939+00	2023-01-06 11:23:35.061967+00	\N
411	bdf1a54d-3cf0-41d0-b5af-949cb807b728	open	2023-01-06 11:28:15.629083+00	2023-01-06 11:28:15.62911+00	\N
412	50eb4b97-a54b-4e76-a239-5e44d588a3a4	open	2023-01-06 11:30:23.908704+00	2023-01-06 11:30:23.908731+00	\N
413	95bfefcf-1956-4c09-9334-76933df0844e	open	2023-01-06 11:34:14.205354+00	2023-01-06 11:34:14.205381+00	\N
416	8cb33660-d37b-46d4-ac80-4b73edc6d7cc	open	2023-01-06 12:17:41.370943+00	2023-01-06 12:17:41.370972+00	\N
417	77c8a372-638d-419c-8b48-9ed0b1367d7f	open	2023-01-06 12:17:54.623749+00	2023-01-06 12:17:54.623776+00	\N
420	a77e59de-42ee-46fe-a30e-83263b1cb319	open	2023-01-06 12:58:50.171928+00	2023-01-06 12:58:50.171968+00	\N
421	77f26410-f9e9-4a48-beff-3891af1bc8d4	open	2023-01-06 12:58:50.173843+00	2023-01-06 12:58:50.173866+00	\N
422	af805798-a599-4d27-9404-8d0003cc6a5f	open	2023-01-06 12:58:55.073494+00	2023-01-06 12:58:55.073521+00	\N
423	8842836e-e267-4b65-a8d8-c0a9ecf91bbb	open	2023-01-06 12:59:02.844023+00	2023-01-06 12:59:02.84405+00	\N
427	b493cff9-9cbe-4b3a-ba84-60b1eba1a0d3	open	2023-01-06 13:09:40.040552+00	2023-01-06 13:09:40.040605+00	\N
428	a99b1757-0203-4733-9f25-cf4a5492e0ac	open	2023-01-06 13:09:52.718081+00	2023-01-06 13:09:52.718108+00	\N
441		open	2023-01-06 14:57:54.265614+00	2023-01-06 14:57:54.265635+00	68
443		closed	2023-01-07 07:52:17.658449+00	2023-01-07 08:20:18.56265+00	37
450	1d4c2eb1-7447-4ee4-824f-57acd519ac37	open	2023-01-08 12:58:08.082544+00	2023-01-08 12:58:08.082601+00	\N
468	99259135-b78a-4c19-95f4-457f75ba2111	open	2023-01-09 22:02:09.80269+00	2023-01-09 22:02:09.802718+00	\N
480		open	2023-01-11 14:44:39.358855+00	2023-01-11 14:44:39.358878+00	76
467		closed	2023-01-08 16:21:10.424319+00	2023-01-11 19:00:06.550805+00	38
482		closed	2023-01-12 12:40:14.513923+00	2023-01-12 22:00:44.273728+00	38
483		closed	2023-01-12 22:01:29.317151+00	2023-01-13 06:17:19.645401+00	38
490		closed	2023-01-16 11:32:38.386982+00	2023-01-16 11:41:00.270601+00	35
491		closed	2023-01-16 11:47:51.430897+00	2023-01-16 11:50:15.093877+00	35
492		closed	2023-01-16 11:57:26.892449+00	2023-01-16 11:59:34.611256+00	35
493		closed	2023-01-16 13:16:34.452127+00	2023-01-16 13:18:08.980097+00	35
489		closed	2023-01-15 08:14:18.502923+00	2023-01-17 00:45:09.082026+00	38
479		closed	2023-01-10 08:20:57.28674+00	2023-01-17 09:35:25.520412+00	37
495		closed	2023-01-17 09:42:48.937601+00	2023-01-17 09:44:05.284293+00	37
496		closed	2023-01-17 10:59:14.644963+00	2023-01-17 11:00:23.994226+00	35
499	a024a1d1-8ec4-4733-8805-a3a22fc1a658	open	2023-01-18 11:30:35.463124+00	2023-01-18 11:30:35.463149+00	\N
500	c120746b-84ba-4c92-b33d-d813cc442430	open	2023-01-18 11:30:39.577823+00	2023-01-18 11:30:39.577847+00	\N
501	079227f8-5e58-4812-b894-60f1833a503f	open	2023-01-18 11:30:45.922343+00	2023-01-18 11:30:45.922367+00	\N
502	98a271fd-7f6b-43aa-b605-58b690cd6c7e	open	2023-01-18 11:31:57.498444+00	2023-01-18 11:31:57.498468+00	\N
503	7e5d3bc4-6038-4092-8f75-29a370fa41ea	open	2023-01-18 11:57:26.342046+00	2023-01-18 11:57:26.342067+00	\N
504		open	2023-01-18 13:38:59.625117+00	2023-01-18 13:38:59.625133+00	50
506		closed	2023-01-19 09:37:01.507942+00	2023-01-19 09:40:10.931839+00	37
510	f1d33dd5-271c-4952-8f43-fdb02679ddf3	open	2023-01-21 06:47:54.289919+00	2023-01-21 06:47:54.289946+00	\N
511	a05b1897-002c-4c55-81d7-3fc705b4ef33	open	2023-01-21 06:48:11.544065+00	2023-01-21 06:48:11.544091+00	\N
512	851ff1e0-7e24-464c-b870-3a7fec8a843e	open	2023-01-21 06:48:15.404617+00	2023-01-21 06:48:15.404643+00	\N
514	812b5755-9d81-437f-943e-7c6937daf026	open	2023-01-23 11:59:58.313944+00	2023-01-23 11:59:58.31397+00	\N
515	dcc449cb-7e9b-412e-964a-7729fff2aa0e	open	2023-01-24 09:23:24.162549+00	2023-01-24 09:23:24.162596+00	\N
519		open	2023-01-24 10:12:12.23331+00	2023-01-24 10:12:12.233331+00	80
540		closed	2023-03-24 10:15:12.545461+00	2023-03-24 14:24:24.220696+00	35
542		open	2023-03-28 09:10:08.985912+00	2023-03-28 09:10:08.985934+00	37
541		closed	2023-03-24 14:29:11.595579+00	2023-03-28 09:30:32.544469+00	35
546	971047ab-519d-427c-8dec-c065835a2f1d	open	2023-07-18 12:32:08.598555+00	2023-07-18 12:32:08.598589+00	\N
550		open	2023-08-23 16:33:31.072684+00	2023-08-23 16:33:31.072711+00	38
\.


--
-- Data for Name: ecommerce_cartproduct; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.ecommerce_cartproduct (id, price, quantity, discount, created_on, updated_on, cart_id, product_detail_id, company_id, delivery_fee, shipper_name) FROM stdin;
49	1000.00	1	10.00	2022-11-25 12:07:54.223427+00	2022-11-25 12:07:54.223441+00	1	17	\N	\N	DellyMan
442	3500.00	1	0.00	2022-12-14 21:36:24.697459+00	2022-12-30 17:07:23.388204+00	181	38	643	1262.50	DELLYMAN
51	1000111111.00	11	0.00	2022-11-25 15:00:25.835802+00	2022-11-25 15:00:25.835817+00	13	22	78886	90.00	DellyMan
612	1000.00	1	0.00	2023-01-05 11:43:28.469186+00	2023-01-05 14:17:30.123192+00	370	49	643	707.00	DELLYMAN
172	1000.00	1	0.00	2022-12-09 09:32:08.896307+00	2022-12-09 09:32:08.898002+00	142	23	\N	0.00	\N
86	1000.00	1	10.00	2022-12-08 08:33:50.87775+00	2022-12-08 08:33:50.879405+00	73	16	\N	0.00	\N
56	1000.00	1	10.00	2022-11-28 17:06:53.768309+00	2022-11-28 17:06:53.769794+00	46	17	\N	0.00	\N
57	1000.00	1	10.00	2022-11-28 22:31:17.222898+00	2022-11-28 22:31:17.224444+00	47	16	\N	0.00	\N
58	1000.00	1	10.00	2022-11-28 22:31:17.796955+00	2022-11-28 22:31:17.798388+00	48	16	\N	0.00	\N
59	1000.00	1	10.00	2022-11-29 02:43:47.235095+00	2022-11-29 02:43:47.236697+00	49	16	\N	0.00	\N
60	20500.00	1	0.04	2022-11-29 02:55:20.741109+00	2022-11-29 02:55:20.742892+00	50	18	\N	0.00	\N
61	1000.00	1	10.00	2022-11-29 03:13:02.418573+00	2022-11-29 03:13:02.420194+00	51	17	\N	0.00	\N
62	1000.00	1	10.00	2022-11-29 03:26:08.0286+00	2022-11-29 03:26:08.030285+00	52	16	\N	0.00	\N
63	1000.00	1	10.00	2022-11-29 03:26:45.465181+00	2022-11-29 03:26:45.466986+00	53	17	\N	0.00	\N
64	20500.00	1	0.04	2022-11-29 03:27:41.553896+00	2022-11-29 03:27:41.555499+00	54	18	\N	0.00	\N
96	5000.00	1	0.00	2022-12-08 09:55:08.58922+00	2023-01-04 18:03:04.935041+00	86	20	\N	0.00	\N
88	72000.00	1	0.00	2022-12-08 08:46:14.217234+00	2022-12-08 08:46:14.218849+00	74	22	\N	0.00	\N
65	1000.00	1	0.00	2022-11-29 16:07:33.288408+00	2022-11-29 16:07:33.290157+00	55	23	\N	0.00	\N
66	1000.00	1	0.00	2022-11-29 16:08:01.468187+00	2022-11-29 16:08:01.469648+00	56	23	\N	0.00	\N
174	3000.00	3	0.00	2022-12-09 09:32:19.28769+00	2022-12-09 09:32:19.289054+00	144	23	\N	0.00	\N
89	1000.00	1	0.00	2022-12-08 08:46:18.899373+00	2022-12-08 08:46:18.900761+00	75	23	\N	0.00	\N
90	1000.00	1	10.00	2022-12-08 09:04:23.825513+00	2022-12-08 09:04:23.827286+00	76	16	\N	0.00	\N
91	1000.00	1	0.00	2022-12-08 09:04:26.018309+00	2022-12-08 09:04:26.019744+00	77	23	\N	0.00	\N
92	1000.00	1	0.00	2022-12-08 09:05:00.162022+00	2022-12-08 09:05:00.163435+00	78	23	\N	0.00	\N
877	129990.00	1	0.00	2023-01-29 21:39:12.392065+00	2023-01-29 21:39:12.394039+00	441	65	\N	0.00	\N
176	1000.00	1	0.00	2022-12-09 09:38:24.886861+00	2022-12-09 09:38:24.888485+00	147	23	\N	0.00	\N
93	30000.00	1	10.00	2022-12-08 09:35:39.872019+00	2022-12-08 09:35:39.873686+00	81	16	\N	0.00	\N
94	5000.00	1	0.00	2022-12-08 09:45:44.935788+00	2022-12-08 09:45:44.93748+00	84	20	\N	0.00	\N
112	1000.00	1	0.00	2022-12-08 13:34:20.709417+00	2022-12-08 13:34:20.710926+00	101	23	\N	0.00	\N
789	10200.00	1	0.00	2023-01-15 08:14:18.507475+00	2023-01-17 00:43:39.664972+00	489	19	643	1767.50	DELLYMAN
95	30000.00	1	10.00	2022-12-08 09:48:34.877224+00	2022-12-08 09:48:34.879097+00	85	16	\N	0.00	\N
788	1000.00	1	0.00	2023-01-15 08:14:18.505325+00	2023-01-17 00:43:39.661011+00	489	23	\N	973.92	REDSTAR
324	30000.00	1	10.00	2022-12-12 09:18:26.322171+00	2022-12-12 09:18:26.323988+00	248	16	\N	0.00	\N
113	30000.00	1	10.00	2022-12-08 13:34:22.263773+00	2022-12-08 13:34:22.265324+00	102	16	\N	0.00	\N
327	30000.00	1	10.00	2022-12-12 09:35:44.606775+00	2022-12-12 09:35:44.608518+00	249	16	\N	0.00	\N
97	20500.00	1	0.04	2022-12-08 09:56:08.190067+00	2022-12-08 09:56:08.191693+00	87	18	\N	0.00	\N
98	72000.00	1	0.00	2022-12-08 10:01:06.585909+00	2022-12-08 10:01:06.587512+00	89	22	\N	0.00	\N
449	3500.00	1	0.00	2022-12-15 08:11:34.373532+00	2022-12-15 08:11:34.375857+00	294	38	\N	0.00	\N
100	10000.00	1	0.00	2022-12-08 10:20:15.607507+00	2022-12-08 10:20:15.609613+00	97	30	\N	0.00	\N
81	1000.00	1	0.00	2022-12-08 07:54:24.33068+00	2022-12-08 07:55:32.099005+00	68	23	\N	0.00	\N
82	1000.00	1	0.00	2022-12-08 08:29:30.15181+00	2022-12-08 08:29:30.15347+00	69	23	\N	0.00	\N
83	1000.00	1	0.00	2022-12-08 08:30:03.711267+00	2022-12-08 08:30:03.712797+00	70	23	\N	0.00	\N
84	72000.00	1	0.00	2022-12-08 08:30:46.008598+00	2022-12-08 08:30:46.009987+00	71	22	\N	0.00	\N
85	1000.00	1	10.00	2022-12-08 08:31:09.811029+00	2022-12-08 08:31:09.812436+00	72	16	\N	0.00	\N
114	500000.00	1	0.00	2022-12-08 13:34:23.845806+00	2022-12-08 13:34:23.847359+00	103	32	\N	0.00	\N
115	20500.00	1	0.04	2022-12-08 13:34:25.649013+00	2022-12-08 13:34:25.650497+00	104	18	\N	0.00	\N
116	100.00	1	0.00	2022-12-08 13:34:27.789178+00	2022-12-08 13:34:27.790763+00	105	31	\N	0.00	\N
117	10000.00	1	0.00	2022-12-08 13:34:56.155778+00	2022-12-08 13:34:56.157258+00	106	30	\N	0.00	\N
118	500000.00	1	0.00	2022-12-08 13:34:57.443308+00	2022-12-08 13:34:57.445098+00	107	32	\N	0.00	\N
77	20500.00	1	0.04	2022-12-06 14:10:36.826309+00	2022-12-08 13:40:59.665859+00	43	18	643	888.80	GIGLOGISTICS
111	5000.00	1	0.00	2022-12-08 13:34:19.3998+00	2022-12-08 13:34:19.401265+00	100	20	\N	0.00	\N
119	100.00	1	0.00	2022-12-08 13:34:59.672733+00	2022-12-08 13:34:59.674183+00	108	31	\N	0.00	\N
120	100.00	1	0.00	2022-12-08 13:35:01.765767+00	2022-12-08 13:35:01.767264+00	109	31	\N	0.00	\N
121	500000.00	1	0.00	2022-12-08 13:36:09.32019+00	2022-12-08 13:36:09.321709+00	110	32	\N	0.00	\N
122	10000.00	1	0.00	2022-12-08 13:36:17.366723+00	2022-12-08 13:36:17.368181+00	111	30	\N	0.00	\N
123	500000.00	1	0.00	2022-12-08 13:36:20.81987+00	2022-12-08 13:36:20.821305+00	112	32	\N	0.00	\N
124	100.00	1	0.00	2022-12-08 13:36:23.613417+00	2022-12-08 13:36:23.614894+00	113	31	\N	0.00	\N
125	10000.00	1	0.00	2022-12-08 13:38:29.842486+00	2022-12-08 13:38:29.844067+00	114	30	\N	0.00	\N
126	100.00	1	0.00	2022-12-08 13:39:19.723482+00	2022-12-08 13:39:19.725277+00	115	31	\N	0.00	\N
46	2000.00	2	20.00	2022-11-22 01:39:37.336953+00	2022-12-08 13:40:59.663119+00	43	16	643	888.80	GIGLOGISTICS
131	10000.00	1	0.00	2022-12-08 13:43:58.170707+00	2022-12-08 13:43:58.172462+00	116	30	\N	0.00	\N
132	500000.00	1	0.00	2022-12-08 13:43:59.256883+00	2022-12-08 13:43:59.258426+00	117	32	\N	0.00	\N
147	100.00	1	0.00	2022-12-08 23:01:09.992286+00	2022-12-08 23:01:09.993873+00	122	31	\N	0.00	\N
148	5000.00	1	0.00	2022-12-08 23:03:59.436987+00	2022-12-08 23:03:59.438762+00	123	20	\N	0.00	\N
149	10000.00	1	0.00	2022-12-08 23:04:55.195782+00	2022-12-08 23:04:55.197247+00	124	30	\N	0.00	\N
152	1000.00	1	0.00	2022-12-09 07:54:30.97746+00	2022-12-09 07:54:30.979288+00	125	23	\N	0.00	\N
153	1000.00	1	0.00	2022-12-09 07:57:06.617633+00	2022-12-09 07:57:06.619102+00	126	23	\N	0.00	\N
154	1000.00	1	0.00	2022-12-09 07:58:45.632029+00	2022-12-09 07:58:45.633452+00	127	23	\N	0.00	\N
156	1000.00	1	0.00	2022-12-09 07:58:56.06103+00	2022-12-09 07:58:56.062546+00	129	23	\N	0.00	\N
157	1000.00	1	0.00	2022-12-09 08:00:53.615256+00	2022-12-09 08:00:53.61672+00	130	23	\N	0.00	\N
158	2000.00	2	0.00	2022-12-09 08:01:03.600747+00	2022-12-09 08:01:03.602154+00	131	23	\N	0.00	\N
159	3000.00	3	0.00	2022-12-09 08:01:05.881375+00	2022-12-09 08:01:05.882773+00	132	23	\N	0.00	\N
160	4000.00	4	0.00	2022-12-09 08:01:08.381914+00	2022-12-09 08:01:08.383412+00	133	23	\N	0.00	\N
162	1000.00	1	0.00	2022-12-09 09:03:29.193638+00	2022-12-09 09:03:29.195096+00	134	23	\N	0.00	\N
163	20500.00	1	0.04	2022-12-09 09:04:40.388654+00	2022-12-09 09:04:40.390343+00	136	18	\N	0.00	\N
164	30000.00	1	10.00	2022-12-09 09:05:07.730279+00	2022-12-09 09:05:07.731789+00	138	16	\N	0.00	\N
310	30000.00	1	10.00	2022-12-10 09:51:44.108469+00	2022-12-10 09:51:44.110275+00	240	16	\N	0.00	\N
239	500000.00	1	0.00	2022-12-10 08:14:00.040299+00	2022-12-10 08:14:00.041772+00	200	32	\N	0.00	\N
240	500000.00	1	0.00	2022-12-10 08:14:04.226165+00	2022-12-10 08:14:04.227538+00	201	33	\N	0.00	\N
313	10000.00	1	0.00	2022-12-10 10:11:30.376909+00	2022-12-10 10:11:30.378622+00	243	30	\N	0.00	\N
316	30000.00	1	10.00	2022-12-12 08:10:25.029955+00	2022-12-12 08:10:25.031721+00	245	16	\N	0.00	\N
283	100.00	1	0.00	2022-12-10 09:12:10.713011+00	2022-12-10 10:14:33.587119+00	232	31	\N	0.00	\N
241	10000.00	1	0.00	2022-12-10 08:15:00.05393+00	2022-12-10 08:15:00.055763+00	202	30	\N	0.00	\N
173	2000.00	2	0.00	2022-12-09 09:32:17.558124+00	2022-12-09 09:32:17.559621+00	143	23	\N	0.00	\N
175	1000.00	1	0.00	2022-12-09 09:37:00.378888+00	2022-12-09 09:37:00.380596+00	146	23	\N	0.00	\N
177	2000.00	2	0.00	2022-12-09 09:38:31.328349+00	2022-12-09 09:38:31.329819+00	148	23	\N	0.00	\N
344	20500.00	1	0.04	2022-12-12 12:31:40.377392+00	2022-12-12 15:18:59.886614+00	254	18	\N	0.00	\N
181	1000.00	1	0.00	2022-12-09 09:44:57.02749+00	2022-12-09 09:44:57.028956+00	152	23	\N	0.00	\N
613	20500.00	1	23500.00	2023-01-05 11:43:48.504533+00	2023-01-05 11:43:48.506429+00	370	18	\N	0.00	\N
184	1000.00	1	10.00	2022-12-09 10:13:00.231212+00	2022-12-09 10:13:00.232945+00	155	17	\N	0.00	\N
185	1000.00	1	10.00	2022-12-09 10:14:24.857877+00	2022-12-09 10:14:24.859597+00	156	17	\N	0.00	\N
186	30000.00	1	10.00	2022-12-09 10:17:23.678428+00	2022-12-09 10:17:23.679809+00	160	16	\N	0.00	\N
328	20500.00	1	0.04	2022-12-12 09:35:46.712302+00	2022-12-12 09:35:46.714102+00	249	18	\N	0.00	\N
249	72000.00	1	0.00	2022-12-10 08:34:56.543551+00	2022-12-10 08:34:56.54534+00	210	22	\N	0.00	\N
436	23000.00	1	25000.00	2022-12-14 16:48:35.21516+00	2022-12-14 16:48:35.216595+00	290	39	\N	0.00	\N
214	500000.00	1	0.00	2022-12-10 07:38:09.490797+00	2022-12-10 07:38:09.492455+00	182	33	\N	0.00	\N
195	30000.00	1	10.00	2022-12-09 13:46:42.92759+00	2022-12-09 13:46:42.929133+00	165	16	\N	0.00	\N
196	30000.00	1	10.00	2022-12-09 13:47:07.454119+00	2022-12-09 13:47:07.455776+00	166	16	\N	0.00	\N
443	23000.00	1	25000.00	2022-12-14 21:42:51.905479+00	2022-12-14 21:42:51.907285+00	291	39	\N	0.00	\N
198	30000.00	1	10.00	2022-12-09 13:48:55.781335+00	2022-12-09 13:48:55.783168+00	167	16	\N	0.00	\N
199	30000.00	1	10.00	2022-12-09 13:49:43.734671+00	2022-12-09 13:49:43.73613+00	168	16	\N	0.00	\N
200	5000.00	1	0.00	2022-12-09 13:50:05.458247+00	2022-12-09 13:50:05.459696+00	169	20	\N	0.00	\N
215	500000.00	1	0.00	2022-12-10 07:40:07.182101+00	2022-12-10 07:40:07.1838+00	183	32	\N	0.00	\N
201	500000.00	1	0.00	2022-12-09 14:59:08.273209+00	2022-12-09 14:59:08.274914+00	170	32	\N	0.00	\N
202	30000.00	1	10.00	2022-12-09 14:59:25.132615+00	2022-12-09 14:59:25.134028+00	171	16	\N	0.00	\N
342	500000.00	1	0.00	2022-12-12 12:31:19.868242+00	2022-12-12 12:31:19.870034+00	254	33	\N	0.00	\N
203	1000.00	1	0.00	2022-12-09 14:59:30.818207+00	2022-12-09 14:59:30.819694+00	172	23	\N	0.00	\N
216	100.00	1	0.00	2022-12-10 07:50:46.177955+00	2022-12-10 07:50:46.179574+00	184	31	\N	0.00	\N
204	5000.00	1	0.00	2022-12-09 14:59:31.927623+00	2022-12-09 14:59:31.929278+00	173	20	\N	0.00	\N
205	20500.00	1	0.04	2022-12-09 14:59:34.189522+00	2022-12-09 14:59:34.191097+00	174	18	\N	0.00	\N
206	20500.00	1	0.04	2022-12-09 15:00:13.285474+00	2022-12-09 15:00:13.287015+00	175	18	\N	0.00	\N
207	500000.00	1	0.00	2022-12-09 15:00:34.041199+00	2022-12-09 15:00:34.042712+00	176	33	\N	0.00	\N
208	100.00	1	0.00	2022-12-09 15:00:36.602428+00	2022-12-09 15:00:36.603921+00	177	31	\N	0.00	\N
217	10000.00	1	0.00	2022-12-10 07:50:57.154712+00	2022-12-10 07:50:57.156121+00	185	30	\N	0.00	\N
218	500000.00	1	0.00	2022-12-10 07:51:00.758651+00	2022-12-10 07:51:00.759999+00	186	32	\N	0.00	\N
346	30000.00	1	10.00	2022-12-12 12:54:31.663353+00	2022-12-12 12:54:42.185115+00	256	16	\N	0.00	\N
350	1000.00	1	0.00	2022-12-12 13:02:14.047408+00	2022-12-12 13:02:14.049038+00	259	23	\N	0.00	\N
230	10000.00	1	0.00	2022-12-10 08:04:05.566882+00	2022-12-10 08:04:05.568332+00	193	30	\N	0.00	\N
231	1000.00	1	0.00	2022-12-10 08:04:09.76168+00	2022-12-10 08:04:09.763299+00	194	23	\N	0.00	\N
242	10000.00	1	0.00	2022-12-10 08:16:27.31278+00	2022-12-10 08:16:27.31423+00	203	30	\N	0.00	\N
354	72000.00	1	0.00	2022-12-12 13:32:46.501789+00	2022-12-12 13:32:46.503697+00	262	22	\N	0.00	\N
243	500000.00	1	0.00	2022-12-10 08:16:40.228798+00	2022-12-10 08:16:40.230309+00	204	32	\N	0.00	\N
244	500000.00	1	0.00	2022-12-10 08:16:40.229766+00	2022-12-10 08:16:40.231602+00	205	32	\N	0.00	\N
224	72000.00	1	0.00	2022-12-10 08:02:49.75484+00	2022-12-10 08:02:49.75661+00	189	22	\N	0.00	\N
225	5000.00	1	0.00	2022-12-10 08:02:51.451545+00	2022-12-10 08:02:51.453025+00	190	20	\N	0.00	\N
226	30000.00	1	10.00	2022-12-10 08:02:54.860315+00	2022-12-10 08:02:54.861792+00	191	16	\N	0.00	\N
232	72000.00	1	0.00	2022-12-10 08:04:11.278067+00	2022-12-10 08:04:11.279748+00	195	22	\N	0.00	\N
270	30000.00	1	10.00	2022-12-10 08:52:21.385667+00	2022-12-10 08:52:21.387042+00	226	16	\N	0.00	\N
358	1000.00	1	0.00	2022-12-12 13:38:43.524087+00	2022-12-12 13:38:43.525855+00	264	23	\N	0.00	\N
236	500000.00	1	0.00	2022-12-10 08:09:18.797972+00	2022-12-10 08:09:18.799688+00	197	33	\N	0.00	\N
237	10000.00	1	0.00	2022-12-10 08:13:17.80783+00	2022-12-10 08:13:17.809358+00	198	30	\N	0.00	\N
238	500000.00	1	0.00	2022-12-10 08:13:24.060055+00	2022-12-10 08:13:24.061547+00	199	32	\N	0.00	\N
245	500000.00	1	0.00	2022-12-10 08:29:59.813765+00	2022-12-10 08:29:59.815573+00	206	32	\N	0.00	\N
250	20500.00	1	0.04	2022-12-10 08:34:59.590907+00	2022-12-10 08:34:59.592323+00	211	18	\N	0.00	\N
247	500000.00	1	0.00	2022-12-10 08:34:02.463669+00	2022-12-10 08:34:02.465068+00	208	33	\N	0.00	\N
251	500000.00	1	0.00	2022-12-10 08:42:18.966046+00	2022-12-10 08:42:18.967851+00	212	33	\N	0.00	\N
272	500000.00	1	0.00	2022-12-10 08:56:20.183146+00	2022-12-10 08:56:20.184535+00	227	33	\N	0.00	\N
257	30000.00	1	10.00	2022-12-10 08:48:46.181046+00	2022-12-10 08:48:46.182479+00	215	16	\N	0.00	\N
266	500000.00	1	0.00	2022-12-10 08:51:46.728472+00	2022-12-10 08:51:46.729894+00	222	33	\N	0.00	\N
259	30000.00	1	10.00	2022-12-10 08:49:15.176679+00	2022-12-10 08:49:15.178402+00	217	16	\N	0.00	\N
262	30000.00	1	10.00	2022-12-10 08:49:57.429999+00	2022-12-10 08:49:57.431502+00	219	16	\N	0.00	\N
267	100.00	1	0.00	2022-12-10 08:51:51.434352+00	2022-12-10 08:51:51.43583+00	223	31	\N	0.00	\N
268	1000.00	1	0.00	2022-12-10 08:52:09.021879+00	2022-12-10 08:52:09.023422+00	224	23	\N	0.00	\N
269	20500.00	1	0.04	2022-12-10 08:52:11.908719+00	2022-12-10 08:52:11.910117+00	225	18	\N	0.00	\N
282	500000.00	1	0.00	2022-12-10 09:12:07.21318+00	2022-12-10 09:12:07.2149+00	231	32	\N	0.00	\N
474	4500.00	1	0.00	2022-12-15 09:53:00.382976+00	2022-12-15 10:31:41.526863+00	307	34	\N	0.00	\N
522	1000.00	1	0.00	2022-12-20 10:02:17.70658+00	2022-12-20 10:03:02.507851+00	328	23	\N	0.00	\N
509	3500.00	1	0.00	2022-12-16 11:14:49.579658+00	2022-12-16 11:14:49.581533+00	321	38	\N	0.00	\N
314	30000.00	1	10.00	2022-12-10 11:25:18.82562+00	2022-12-10 11:25:18.827369+00	244	16	\N	0.00	\N
406	23000.00	1	25000.00	2022-12-13 14:17:11.576933+00	2022-12-13 14:17:11.578732+00	280	39	\N	0.00	\N
510	12000.00	1	0.00	2022-12-16 11:14:51.748488+00	2022-12-16 11:14:51.750163+00	321	43	\N	0.00	\N
523	72000.00	1	0.00	2022-12-20 10:07:26.504337+00	2022-12-20 10:07:26.506281+00	328	22	\N	0.00	\N
365	5000.00	1	0.00	2022-12-12 14:16:55.292837+00	2022-12-12 14:16:55.294494+00	266	20	\N	0.00	\N
366	30000.00	1	10.00	2022-12-12 14:22:54.955942+00	2022-12-12 14:22:57.091331+00	267	16	\N	0.00	\N
796	1500000.00	3	0.00	2023-01-15 11:08:59.211817+00	2023-01-17 09:34:19.201012+00	479	33	643	1750.00	DELLYMAN
367	500000.00	1	0.00	2022-12-12 14:23:17.559461+00	2022-12-12 14:24:27.986016+00	267	33	\N	0.00	\N
437	45000.00	1	0.00	2022-12-14 16:49:52.42439+00	2022-12-14 16:49:52.426023+00	290	37	\N	0.00	\N
511	45000.00	1	0.00	2022-12-16 12:41:41.988452+00	2022-12-16 12:41:41.990495+00	181	42	\N	0.00	\N
450	12000.00	1	0.00	2022-12-15 08:11:36.235009+00	2022-12-15 08:11:36.236854+00	294	43	\N	0.00	\N
891	45000.00	1	0.00	2023-02-13 09:05:40.636412+00	2023-02-13 11:04:22.270691+00	528	37	643	1250.00	DELLYMAN
369	30000.00	1	10.00	2022-12-12 14:59:29.060202+00	2022-12-12 15:04:16.676672+00	268	16	\N	0.00	\N
370	500000.00	1	0.00	2022-12-12 15:05:17.795264+00	2022-12-12 15:05:17.797393+00	268	33	\N	0.00	\N
343	72000.00	1	0.00	2022-12-12 12:31:33.038603+00	2022-12-12 12:31:33.040343+00	254	22	\N	0.00	\N
345	30000.00	1	10.00	2022-12-12 12:33:31.696859+00	2022-12-12 12:33:31.698341+00	255	16	\N	0.00	\N
371	72000.00	1	0.00	2022-12-12 15:08:05.564227+00	2022-12-12 15:08:05.565877+00	268	22	\N	0.00	\N
799	1000.00	1	0.00	2023-01-16 11:32:38.396783+00	2023-01-16 11:40:17.28054+00	490	23	\N	973.92	REDSTAR
802	500.00	1	0.00	2023-01-16 11:47:51.440887+00	2023-01-16 11:49:34.37457+00	491	46	643	1868.50	DELLYMAN
347	1000.00	1	0.00	2022-12-12 12:55:54.718145+00	2022-12-12 12:59:26.36686+00	256	23	\N	0.00	\N
349	1000.00	1	0.00	2022-12-12 13:00:18.214455+00	2022-12-12 13:00:18.216407+00	258	23	\N	0.00	\N
351	1000.00	1	0.00	2022-12-12 13:02:14.123354+00	2022-12-12 13:02:54.018464+00	260	23	\N	0.00	\N
515	1500.00	3	0.00	2022-12-16 14:54:45.523284+00	2022-12-16 14:55:40.233265+00	325	46	\N	0.00	\N
353	1000.00	1	0.00	2022-12-12 13:32:22.688709+00	2022-12-12 13:32:44.124346+00	262	23	\N	0.00	\N
355	5000.00	1	0.00	2022-12-12 13:32:48.115003+00	2022-12-12 13:32:48.116647+00	262	20	\N	0.00	\N
387	30000.00	1	10.00	2022-12-12 15:21:22.226237+00	2022-12-12 15:21:22.227723+00	274	16	\N	0.00	\N
505	45000.00	1	0.00	2022-12-15 14:26:22.64073+00	2022-12-15 14:26:22.642532+00	317	42	\N	0.00	\N
375	5000.00	1	0.00	2022-12-12 15:19:01.109877+00	2022-12-12 15:19:01.111484+00	254	20	\N	0.00	\N
506	3500.00	1	0.00	2022-12-15 14:28:05.659833+00	2022-12-15 14:28:05.661339+00	318	38	\N	0.00	\N
508	3500.00	1	0.00	2022-12-15 14:29:56.348005+00	2022-12-15 14:29:56.349548+00	320	38	\N	0.00	\N
516	45000.00	1	0.00	2022-12-16 15:50:22.287515+00	2022-12-16 15:50:22.289292+00	326	42	\N	0.00	\N
805	500.00	1	0.00	2023-01-16 11:57:26.902751+00	2023-01-16 11:58:52.918072+00	492	46	643	1262.50	DELLYMAN
526	25000.00	1	30000.00	2022-12-20 10:10:47.852507+00	2022-12-20 10:10:47.854238+00	330	40	\N	0.00	\N
808	1000.00	1	0.00	2023-01-16 13:16:43.422252+00	2023-01-16 13:17:12.922753+00	493	23	\N	973.92	REDSTAR
527	3500.00	1	0.00	2022-12-20 10:10:54.964828+00	2022-12-20 10:10:54.966553+00	330	38	\N	0.00	\N
901	4000.00	1	4000.00	2023-03-24 09:24:59.775372+00	2023-03-24 09:27:18.377816+00	537	22	\N	964.28	REDSTAR
514	12000.00	1	0.00	2022-12-16 14:48:32.839358+00	2022-12-16 14:48:32.84108+00	324	43	\N	0.00	\N
540	3500.00	1	0.00	2022-12-21 09:11:11.069674+00	2022-12-21 09:11:11.071448+00	332	38	\N	0.00	\N
389	500000.00	1	0.00	2022-12-12 17:53:05.901439+00	2022-12-12 17:53:05.903157+00	275	33	\N	0.00	\N
518	45000.00	1	0.00	2022-12-19 10:23:50.005191+00	2022-12-19 10:23:50.007005+00	327	37	\N	0.00	\N
413	10200.00	1	0.00	2022-12-14 06:45:19.561732+00	2022-12-14 06:45:19.563494+00	283	19	\N	0.00	\N
907	44000.00	1	0.00	2023-03-24 10:15:12.555863+00	2023-03-24 14:23:40.277604+00	540	61	\N	964.28	REDSTAR
519	20500.00	1	23500.00	2022-12-19 10:23:51.942466+00	2022-12-19 10:23:51.94406+00	327	18	\N	0.00	\N
910	400.00	1	400.00	2023-03-28 09:15:42.817776+00	2023-03-28 09:17:25.995575+00	542	60	\N	964.28	REDSTAR
541	30000.00	1	40000.00	2022-12-21 09:12:56.740299+00	2022-12-21 09:13:22.972225+00	333	16	\N	0.00	\N
424	45000.00	1	0.00	2022-12-14 13:18:42.011239+00	2022-12-14 13:18:42.013106+00	287	37	\N	0.00	\N
425	3500.00	1	0.00	2022-12-14 13:19:00.511172+00	2022-12-14 13:19:00.51301+00	287	38	\N	0.00	\N
556	1000.00	1	10.00	2022-12-28 09:44:48.626854+00	2022-12-28 09:44:48.628743+00	341	17	\N	0.00	\N
545	4500.00	1	0.00	2022-12-22 08:28:55.813095+00	2022-12-22 08:28:55.815073+00	334	34	\N	0.00	\N
546	30000.00	1	40000.00	2022-12-22 08:29:03.143827+00	2022-12-22 08:29:03.145313+00	335	16	\N	0.00	\N
547	5000.00	1	0.00	2022-12-22 08:29:06.503287+00	2022-12-22 08:29:06.50477+00	336	20	\N	0.00	\N
551	5000.00	1	0.00	2022-12-22 13:24:45.544631+00	2022-12-22 13:25:00.658607+00	338	20	\N	0.00	\N
552	5000.00	1	0.00	2022-12-22 14:49:08.723224+00	2022-12-22 14:49:08.724978+00	339	20	\N	0.00	\N
553	1000.00	1	0.00	2022-12-22 14:49:12.658147+00	2022-12-22 14:49:12.659841+00	339	23	\N	0.00	\N
554	30000.00	1	40000.00	2022-12-22 14:49:18.796425+00	2022-12-22 14:49:18.797957+00	339	16	\N	0.00	\N
574	100.00	1	0.00	2022-12-30 15:21:25.279686+00	2022-12-30 15:21:41.459803+00	347	31	\N	0.00	\N
571	25000.00	1	30000.00	2022-12-30 14:21:09.963282+00	2022-12-30 14:21:09.965322+00	344	40	\N	0.00	\N
569	23000.00	1	25000.00	2022-12-30 14:12:51.362208+00	2022-12-30 14:21:51.361719+00	344	39	\N	0.00	\N
566	10200.00	1	0.00	2022-12-30 14:12:30.981372+00	2022-12-30 14:24:26.580317+00	344	19	643	707.00	DELLYMAN
572	3500.00	1	0.00	2022-12-30 14:22:48.192386+00	2022-12-30 14:24:26.58197+00	344	38	643	707.00	DELLYMAN
581	100.00	1	0.00	2022-12-31 07:59:09.446959+00	2022-12-31 08:14:42.54933+00	352	31	\N	0.00	\N
586	1000.00	1	10.00	2023-01-03 08:14:53.729605+00	2023-01-03 10:16:38.92287+00	356	17	643	2020.00	DELLYMAN
585	72000.00	1	0.00	2023-01-03 07:24:23.839268+00	2023-01-03 07:24:23.840998+00	355	22	\N	0.00	\N
587	72000.00	1	0.00	2023-01-04 11:03:18.583136+00	2023-01-04 11:05:22.463974+00	348	22	643	1010.00	DELLYMAN
591	20500.00	1	23500.00	2023-01-04 17:29:58.583818+00	2023-01-04 17:30:49.52258+00	359	18	643	2020.00	DELLYMAN
592	20500.00	1	23500.00	2023-01-04 17:38:28.118448+00	2023-01-04 17:39:47.242225+00	360	18	643	2020.00	DELLYMAN
593	30000.00	1	40000.00	2023-01-04 17:38:43.245304+00	2023-01-04 17:38:43.246978+00	360	16	\N	0.00	\N
594	1000.00	1	0.00	2023-01-04 18:02:32.037999+00	2023-01-04 18:02:32.040039+00	86	49	\N	0.00	\N
595	4500.00	1	0.00	2023-01-04 18:02:44.878375+00	2023-01-04 18:02:44.879979+00	86	34	\N	0.00	\N
596	30000.00	1	40000.00	2023-01-04 18:10:27.225832+00	2023-01-04 18:10:27.22771+00	361	16	\N	0.00	\N
597	5000.00	1	0.00	2023-01-04 18:10:42.006554+00	2023-01-04 18:10:42.008155+00	361	20	\N	0.00	\N
663	34900.00	1	0.00	2023-01-06 10:48:51.752007+00	2023-01-06 10:48:51.75352+00	402	54	\N	0.00	\N
601	75000.00	3	90000.00	2023-01-05 08:41:57.301361+00	2023-01-05 08:48:12.733702+00	363	40	\N	0.00	\N
699	12000.00	1	0.00	2023-01-06 14:57:54.26775+00	2023-01-28 08:36:17.422051+00	441	43	643	1250.00	DELLYMAN
602	30000.00	1	40000.00	2023-01-05 08:54:07.41772+00	2023-01-05 09:07:07.425205+00	364	16	\N	5528.24	GIGLOGISTICS
633	23000.00	1	25000.00	2023-01-06 08:29:51.870317+00	2023-01-06 08:29:51.872113+00	381	39	\N	0.00	\N
634	5000.00	1	0.00	2023-01-06 08:30:44.641741+00	2023-01-06 08:30:44.643519+00	381	20	\N	0.00	\N
605	500000.00	1	0.00	2023-01-05 09:39:42.23044+00	2023-01-05 09:39:42.232378+00	367	47	\N	0.00	\N
604	5000.00	1	0.00	2023-01-05 09:38:35.638918+00	2023-01-05 09:40:36.981933+00	366	44	\N	0.00	\N
698	20500.00	1	23500.00	2023-01-06 14:57:54.271649+00	2023-01-28 08:36:17.425964+00	441	18	643	1250.00	DELLYMAN
603	5000.00	1	0.00	2023-01-05 09:36:33.699417+00	2023-01-05 09:42:23.243762+00	365	44	643	1010.00	DELLYMAN
606	12000.00	1	0.00	2023-01-05 10:05:25.597897+00	2023-01-05 10:05:25.599696+00	368	43	\N	0.00	\N
607	30000.00	1	40000.00	2023-01-05 10:06:04.52377+00	2023-01-05 10:06:04.525511+00	368	16	\N	0.00	\N
608	500000.00	1	0.00	2023-01-05 10:07:10.763304+00	2023-01-05 10:07:10.764925+00	368	33	\N	0.00	\N
598	1000.00	1	0.00	2023-01-04 18:14:17.014831+00	2023-01-05 10:14:11.184516+00	362	49	643	707.00	DELLYMAN
635	5000.00	1	0.00	2023-01-06 08:33:35.038693+00	2023-01-06 08:39:19.458841+00	382	20	643	1010.00	DELLYMAN
664	5000.00	1	0.00	2023-01-06 10:53:22.5941+00	2023-01-06 10:53:22.59607+00	403	44	\N	0.00	\N
599	30000.00	1	40000.00	2023-01-04 18:14:32.263163+00	2023-01-05 10:15:53.257133+00	362	16	643	707.00	DELLYMAN
609	5000.00	1	0.00	2023-01-05 10:17:19.685717+00	2023-01-05 10:17:19.687594+00	369	20	\N	0.00	\N
610	100.00	1	0.00	2023-01-05 10:30:00.224768+00	2023-01-05 10:30:00.226797+00	369	31	\N	0.00	\N
611	45000.00	1	0.00	2023-01-05 10:30:32.412225+00	2023-01-05 10:30:32.413777+00	369	42	\N	0.00	\N
636	34900.00	1	0.00	2023-01-06 08:45:38.505899+00	2023-01-06 08:45:38.507728+00	384	54	\N	0.00	\N
600	10200.00	1	0.00	2023-01-04 18:14:46.863855+00	2023-01-05 10:32:41.461612+00	362	19	643	2020.00	DELLYMAN
637	75000.00	1	77000.00	2023-01-06 08:45:59.569859+00	2023-01-06 08:45:59.571434+00	384	41	\N	0.00	\N
638	34900.00	1	0.00	2023-01-06 08:55:34.404044+00	2023-01-06 08:55:34.405841+00	386	54	\N	0.00	\N
886	1000.00	1	0.00	2023-02-10 13:45:33.982299+00	2023-02-10 15:37:36.713141+00	523	23	643	964.28	REDSTAR
640	20500.00	1	23500.00	2023-01-06 08:56:00.494476+00	2023-01-06 08:56:00.496141+00	386	18	\N	0.00	\N
641	34900.00	1	0.00	2023-01-06 08:57:41.167716+00	2023-01-06 08:57:41.169283+00	387	54	\N	0.00	\N
665	100.00	1	0.00	2023-01-06 10:59:58.87324+00	2023-01-06 10:59:58.875064+00	404	31	\N	0.00	\N
618	20000.00	1	0.00	2023-01-05 19:52:49.306412+00	2023-01-05 19:53:14.272793+00	373	48	\N	0.00	\N
643	4500.00	1	0.00	2023-01-06 09:01:02.64668+00	2023-01-06 09:01:02.648462+00	388	34	\N	0.00	\N
644	72000.00	1	0.00	2023-01-06 09:01:16.072312+00	2023-01-06 09:01:16.073922+00	388	22	\N	0.00	\N
645	20000.00	1	0.00	2023-01-06 09:03:35.751456+00	2023-01-06 09:03:35.753062+00	389	48	\N	0.00	\N
678	5000.00	1	0.00	2023-01-06 12:17:54.633221+00	2023-01-06 12:17:54.63481+00	417	20	\N	0.00	\N
629	1000.00	1	0.00	2023-01-06 07:48:12.27111+00	2023-01-06 07:48:12.272677+00	378	23	\N	0.00	\N
889	710000.00	1	0.00	2023-02-13 08:28:27.252606+00	2023-02-13 08:29:15.324589+00	527	57	643	1250.00	DELLYMAN
652	5000.00	1	0.00	2023-01-06 10:04:42.946446+00	2023-01-06 10:04:42.948389+00	392	20	\N	0.00	\N
684	72000.00	1	0.00	2023-01-07 07:52:17.662587+00	2023-01-07 08:18:03.618038+00	443	22	643	1767.50	DELLYMAN
703	3500.00	1	0.00	2023-01-07 07:52:17.66071+00	2023-01-07 08:18:03.619255+00	443	38	643	1767.50	DELLYMAN
653	1000.00	1	0.00	2023-01-06 10:08:16.146536+00	2023-01-06 10:08:16.148148+00	392	23	\N	0.00	\N
666	500.00	1	0.00	2023-01-06 11:02:29.295371+00	2023-01-06 11:02:29.296863+00	405	46	\N	0.00	\N
654	34900.00	1	0.00	2023-01-06 10:09:04.647991+00	2023-01-06 10:09:04.649738+00	392	54	\N	0.00	\N
655	3500.00	1	0.00	2023-01-06 10:15:01.198066+00	2023-01-06 10:15:01.199899+00	393	38	\N	0.00	\N
656	20000.00	1	0.00	2023-01-06 10:16:44.920761+00	2023-01-06 10:16:44.923321+00	394	48	\N	0.00	\N
657	23000.00	1	25000.00	2023-01-06 10:19:50.888489+00	2023-01-06 10:19:50.890356+00	395	39	\N	0.00	\N
658	12000.00	1	0.00	2023-01-06 10:21:16.351903+00	2023-01-06 10:21:16.353437+00	396	43	\N	0.00	\N
659	45000.00	1	0.00	2023-01-06 10:26:05.180437+00	2023-01-06 10:26:05.182399+00	397	37	\N	0.00	\N
661	34900.00	1	0.00	2023-01-06 10:44:03.774473+00	2023-01-06 10:44:03.77624+00	400	54	\N	0.00	\N
662	34900.00	1	0.00	2023-01-06 10:46:12.685279+00	2023-01-06 10:46:12.687128+00	401	54	\N	0.00	\N
667	34900.00	1	0.00	2023-01-06 11:06:10.214914+00	2023-01-06 11:06:10.216832+00	406	54	\N	0.00	\N
668	45000.00	1	0.00	2023-01-06 11:10:33.693075+00	2023-01-06 11:10:33.695042+00	407	37	\N	0.00	\N
669	34900.00	1	0.00	2023-01-06 11:15:49.500821+00	2023-01-06 11:15:49.502653+00	408	54	\N	0.00	\N
670	45000.00	1	0.00	2023-01-06 11:19:25.825415+00	2023-01-06 11:19:25.826905+00	409	42	\N	0.00	\N
671	500000.00	1	0.00	2023-01-06 11:20:53.982084+00	2023-01-06 11:20:53.984143+00	409	47	\N	0.00	\N
672	20500.00	1	23500.00	2023-01-06 11:23:35.071713+00	2023-01-06 11:23:35.073518+00	410	18	\N	0.00	\N
673	34900.00	1	0.00	2023-01-06 11:28:15.638987+00	2023-01-06 11:28:15.640873+00	411	54	\N	0.00	\N
674	5000.00	1	0.00	2023-01-06 11:30:23.918867+00	2023-01-06 11:30:23.920825+00	412	44	\N	0.00	\N
675	23000.00	1	25000.00	2023-01-06 11:34:14.216327+00	2023-01-06 11:34:14.217862+00	413	39	\N	0.00	\N
899	400.00	1	400.00	2023-03-24 08:36:57.496625+00	2023-03-24 09:07:44.265636+00	536	60	\N	964.28	REDSTAR
685	34900.00	1	0.00	2023-01-07 07:52:17.667814+00	2023-01-07 08:18:03.612796+00	443	54	643	1767.50	DELLYMAN
639	400.00	4	0.00	2023-01-07 07:52:17.666075+00	2023-01-07 08:18:03.615319+00	443	31	643	1767.50	DELLYMAN
677	5000.00	1	0.00	2023-01-07 07:52:17.664344+00	2023-01-07 08:18:03.616849+00	443	44	643	1767.50	DELLYMAN
679	3500.00	1	0.00	2023-01-06 12:18:52.044254+00	2023-01-06 12:18:52.045914+00	417	38	\N	0.00	\N
615	500.00	1	0.00	2023-01-05 13:09:07.307688+00	2023-01-16 10:37:19.786586+00	353	46	643	1868.50	DELLYMAN
797	1000.00	1	0.00	2023-01-16 08:49:18.211367+00	2023-01-16 10:37:19.781151+00	353	23	\N	973.92	REDSTAR
902	5000.00	1	0.00	2023-03-24 09:25:17.59865+00	2023-03-24 09:27:18.37579+00	537	44	\N	964.28	REDSTAR
905	44000.00	1	0.00	2023-03-24 09:38:18.961229+00	2023-03-24 09:38:58.978213+00	538	61	\N	964.28	REDSTAR
908	44000.00	1	0.00	2023-03-24 14:30:16.357429+00	2023-03-28 09:29:32.994968+00	541	61	\N	964.28	REDSTAR
765	100.00	1	0.00	2023-01-09 22:02:09.813279+00	2023-01-09 22:02:09.815127+00	468	31	\N	0.00	\N
762	23000.00	1	25000.00	2023-01-08 16:21:10.430481+00	2023-01-11 18:58:04.164511+00	467	39	\N	973.92	REDSTAR
786	1000.00	1	0.00	2023-01-12 22:01:29.326342+00	2023-01-13 06:16:21.939102+00	483	23	\N	973.92	REDSTAR
787	72000.00	1	0.00	2023-01-12 22:01:33.554377+00	2023-01-13 06:16:21.942777+00	483	22	643	1262.50	DELLYMAN
555	5000.00	1	0.00	2023-01-18 13:38:59.627274+00	2023-01-18 13:39:25.261512+00	504	20	\N	0.00	\N
798	5000.00	1	0.00	2023-01-16 08:49:23.686878+00	2023-01-16 10:37:19.785164+00	353	20	643	1868.50	DELLYMAN
801	500.00	1	0.00	2023-01-16 11:35:09.051209+00	2023-01-16 11:40:17.283998+00	490	46	643	1868.50	DELLYMAN
766	25000.00	1	30000.00	2023-01-09 22:02:26.36476+00	2023-01-09 22:02:26.366594+00	468	40	\N	0.00	\N
804	1000.00	1	0.00	2023-01-16 11:48:25.971496+00	2023-01-16 11:49:34.367198+00	491	23	\N	973.92	REDSTAR
807	5000.00	1	0.00	2023-01-16 13:16:34.462146+00	2023-01-16 13:17:12.926523+00	493	20	643	1868.50	DELLYMAN
919	70.00	1	70.00	2023-07-18 12:32:08.611292+00	2023-07-18 12:32:08.613798+00	546	31	\N	0.00	\N
920	24430.00	1	24430.00	2023-07-18 12:32:22.116595+00	2023-07-18 12:32:22.118622+00	546	54	\N	0.00	\N
763	12000.00	1	0.00	2023-01-08 17:55:39.183336+00	2023-01-11 18:58:04.168403+00	467	43	643	1212.00	DELLYMAN
880	30.00	1	0.00	2023-02-05 16:58:37.841514+00	2023-02-10 15:37:36.709209+00	523	58	643	1250.00	DELLYMAN
887	700000.00	1	0.00	2023-02-11 21:04:28.014304+00	2023-02-12 15:21:48.141248+00	525	56	643	1250.00	DELLYMAN
865	700000.00	1	0.00	2023-01-26 08:12:57.547321+00	2023-03-02 10:53:32.160388+00	521	56	643	700.00	DELLYMAN
866	5000.00	1	0.00	2023-01-26 08:20:23.9674+00	2023-02-12 20:32:04.374003+00	509	20	643	1900.00	DELLYMAN
767	1500000.00	3	0.00	2023-01-10 08:20:57.289205+00	2023-01-17 09:34:19.202618+00	479	47	643	1750.00	DELLYMAN
829	4500.00	1	0.00	2023-01-18 11:30:35.472379+00	2023-01-18 11:30:35.474305+00	499	34	\N	0.00	\N
830	72000.00	1	0.00	2023-01-18 11:30:39.586974+00	2023-01-18 11:30:39.588442+00	500	22	\N	0.00	\N
783	1000.00	1	0.00	2023-01-12 21:30:32.258173+00	2023-01-12 21:59:27.13839+00	482	23	\N	973.92	REDSTAR
779	500.00	1	0.00	2023-01-12 12:40:14.518337+00	2023-01-12 21:59:27.142121+00	482	46	643	1767.50	DELLYMAN
784	120.00	1	0.00	2023-01-12 21:56:40.451855+00	2023-01-12 21:59:27.145518+00	482	24	643	1464.50	DELLYMAN
785	45000.00	1	0.00	2023-01-12 21:57:05.035001+00	2023-01-12 21:59:27.148652+00	482	42	643	1262.50	DELLYMAN
831	4500.00	1	0.00	2023-01-18 11:30:45.931458+00	2023-01-18 11:30:45.932952+00	501	36	\N	0.00	\N
822	23000.00	1	25000.00	2023-01-17 09:43:04.471453+00	2023-01-17 09:43:26.720972+00	495	39	643	1750.00	DELLYMAN
821	1000.00	1	0.00	2023-01-17 09:43:02.004228+00	2023-01-17 09:43:26.722635+00	495	23	643	1750.00	DELLYMAN
820	10200.00	1	0.00	2023-01-17 09:42:52.689346+00	2023-01-17 09:43:26.725885+00	495	19	643	1750.00	DELLYMAN
819	72000.00	1	0.00	2023-01-17 09:42:48.94677+00	2023-01-17 09:43:26.727183+00	495	22	643	1750.00	DELLYMAN
832	4500.00	1	0.00	2023-01-18 11:31:57.507377+00	2023-01-18 11:31:57.508921+00	502	34	\N	0.00	\N
823	20000.00	1	0.00	2023-01-17 10:59:14.653606+00	2023-01-17 10:59:35.568551+00	496	48	643	1400.00	DELLYMAN
890	72000.00	1	0.00	2023-02-13 08:39:55.906096+00	2023-02-13 11:04:22.272581+00	528	22	643	1250.00	DELLYMAN
900	4500.00	1	0.00	2023-03-24 09:23:39.137358+00	2023-03-24 09:27:18.379729+00	537	45	\N	964.28	REDSTAR
903	400.00	1	400.00	2023-03-24 09:26:16.608409+00	2023-03-24 09:27:18.383327+00	537	60	\N	964.28	REDSTAR
834	23000.00	1	25000.00	2023-01-18 11:57:26.350988+00	2023-01-18 11:57:26.355859+00	503	39	\N	0.00	\N
843	4500.00	1	0.00	2023-01-19 09:37:01.513596+00	2023-01-19 09:38:53.680585+00	506	45	643	1000.00	DELLYMAN
906	44000.00	1	0.00	2023-03-24 10:01:41.407175+00	2023-03-24 10:02:08.800486+00	539	61	\N	964.28	REDSTAR
827	34900.00	1	0.00	2023-01-19 09:37:01.511889+00	2023-01-19 09:38:53.682213+00	506	54	643	1000.00	DELLYMAN
828	1000.00	1	0.00	2023-01-19 09:37:01.510037+00	2023-01-19 09:38:53.685421+00	506	23	\N	0.00	DELLYMAN
898	45000.00	1	0.00	2023-08-23 16:33:31.075338+00	2023-08-23 16:33:31.075354+00	550	42	\N	0.00	\N
913	20000.00	1	0.00	2023-08-23 16:33:31.077658+00	2023-08-23 16:33:31.077674+00	550	48	\N	0.00	\N
921	12000.00	1	0.00	2023-08-23 16:33:31.079781+00	2023-08-23 16:33:31.079797+00	550	43	\N	0.00	\N
922	4000.00	1	4000.00	2023-08-23 16:33:31.081875+00	2023-08-23 16:33:31.081891+00	550	22	\N	0.00	\N
861	1000.00	1	0.00	2023-01-24 10:12:12.242884+00	2023-01-24 10:12:12.244862+00	519	23	\N	0.00	\N
776	45000.00	1	0.00	2023-01-11 09:52:37.530003+00	2023-01-28 08:36:17.42755+00	441	37	643	1250.00	DELLYMAN
867	44000.00	1	0.00	2023-01-28 08:34:39.258257+00	2023-01-28 08:36:17.431178+00	441	61	643	1250.00	DELLYMAN
\.


--
-- Data for Name: ecommerce_dailydeal; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.ecommerce_dailydeal (id, created_on, updated_on, product_id) FROM stdin;
1	2023-07-27 11:01:59.686679+00	2023-07-27 11:01:59.686699+00	44
2	2023-07-27 11:02:06.56534+00	2023-07-27 11:02:06.565361+00	23
\.


--
-- Data for Name: ecommerce_image; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.ecommerce_image (id, image, created_on) FROM stdin;
3	product-images/cway-product.jpeg	2022-11-08 12:43:46.400484+00
5	product-images/chivita.jpeg	2022-11-29 14:10:47.839779+00
6	product-images/Screenshot_2022-11-30_at_10.25.49.png	2022-11-30 11:00:40.152408+00
7	product-images/Screenshot_2022-11-30_at_10.25.49_1iiSEGd.png	2022-11-30 11:20:14.715517+00
8	product-images/Screenshot_2022-11-30_at_09.50.10.png	2022-11-30 11:21:37.698868+00
9	product-images/Screenshot_2022-11-30_at_15.05.58.png	2022-11-30 16:06:52.396602+00
10	product-images/Screenshot_2022-11-28_at_15.23.01.png	2022-11-30 16:07:03.412395+00
11	product-images/Screenshot_2022-11-30_at_15.05.58_LatW7lk.png	2022-11-30 16:16:58.45186+00
12	product-images/Screenshot_2022-11-30_at_13.33.57.png	2022-11-30 16:19:11.552848+00
13	product-images/Screenshot_9.png	2022-11-30 17:22:18.395451+00
14	product-images/Ogechi_Altraide.jpg	2022-11-30 17:23:19.202576+00
15	product-images/Screenshot_9_6G4Uh8V.png	2022-11-30 17:23:27.774324+00
16	product-images/Screenshot_9_UnfNRLU.png	2022-11-30 17:23:44.078826+00
17	product-images/Screenshot_9_VAoEzyB.png	2022-11-30 17:24:01.717941+00
18	product-images/Group_237598.png	2022-11-30 17:24:16.510921+00
19	product-images/Screenshot_9_roETWI2.png	2022-11-30 17:24:50.21453+00
20	product-images/WhatsApp_Image_2022-11-09_at_20.45.103.jpg	2022-11-30 17:25:05.635788+00
21	product-images/demo_.jpeg	2022-11-30 23:44:07.428595+00
22	product-images/lens.jpeg	2022-11-30 23:50:46.614773+00
23	product-images/eyes.jpeg	2022-11-30 23:56:04.949048+00
24	product-images/image_9.png	2022-11-30 23:56:51.81477+00
25	product-images/image_9_MCxoJ0b.png	2022-12-01 07:55:56.941047+00
26	product-images/silhouette.jpeg	2022-12-01 07:57:03.46843+00
27	product-images/Screenshot_2022-12-01_at_01.28.02.png	2022-12-01 08:39:09.017757+00
28	product-images/Screenshot_2022-12-01_at_01.28.02_dywbcqf.png	2022-12-01 10:56:12.985096+00
29	product-images/logo_4.png	2022-12-01 12:26:57.567842+00
30	product-images/benz_1.jpeg	2022-12-01 12:41:28.255406+00
31	product-images/benz_2.jpeg	2022-12-01 12:41:44.831409+00
32	product-images/benz_1_OvPSC92.jpeg	2022-12-01 12:59:19.883908+00
33	product-images/benz_2_oXekS2s.jpeg	2022-12-01 12:59:36.631724+00
34	product-images/benz_3.jpeg	2022-12-01 13:00:56.818065+00
35	product-images/benz_1_TBj3SRp.jpeg	2022-12-01 13:11:00.60935+00
36	product-images/benz_2_TZI5gxl.jpeg	2022-12-01 13:11:27.693806+00
37	product-images/benz_3_oictNeB.jpeg	2022-12-01 13:12:08.754332+00
38	product-images/Screenshot_9_qks1cA6.png	2022-12-01 16:43:03.737716+00
39	product-images/Screenshot_7.png	2022-12-01 16:43:38.751051+00
40	product-images/Screenshot_5.png	2022-12-01 16:43:46.994219+00
41	product-images/WhatsApp_Image_2022-11-09_at_20.45.128.jpg	2022-12-01 16:44:14.81282+00
42	product-images/WhatsApp_Image_2022-11-09_at_20.45.103_Bh567OO.jpg	2022-12-01 16:44:20.12673+00
43	product-images/WhatsApp_Image_2022-11-09_at_20.45.127.jpg	2022-12-01 16:45:20.88601+00
44	product-images/Screenshot_9_d81uq0I.png	2022-12-02 13:47:37.38361+00
45	product-images/demo__QcXdzlk.jpeg	2022-12-03 07:56:44.036213+00
46	product-images/demo__kvywJ7s.jpeg	2022-12-03 07:58:41.07972+00
47	product-images/image_455.png	2022-12-03 07:59:29.32894+00
48	product-images/demo__yMxfUWN.jpeg	2022-12-03 09:42:38.942174+00
49	product-images/image_457.png	2022-12-03 09:43:35.323208+00
50	product-images/Habari_Item_Pick_up.pdf	2022-12-03 12:22:44.470862+00
51	product-images/benz_silver.jfif	2022-12-03 12:22:55.468241+00
52	product-images/benz_silver_BfhDv42.jfif	2022-12-03 12:23:49.301423+00
53	product-images/benz_red.jfif	2022-12-03 12:24:02.879155+00
54	product-images/benz_yellow.jfif	2022-12-03 12:25:11.382276+00
55	product-images/benz_green.jfif	2022-12-03 12:26:00.460245+00
56	product-images/payarena_logo_CawdrZu.jpeg	2022-12-03 13:48:07.304325+00
57	product-images/payarena_logo_4whgSul.jpeg	2022-12-03 13:50:01.242002+00
58	product-images/image_455_EV081Sr.png	2022-12-03 13:51:45.18302+00
59	product-images/image_455_CFjWMMV.png	2022-12-03 13:51:56.922063+00
60	product-images/image_455_U8EYhDH.png	2022-12-03 14:15:47.068492+00
61	product-images/lens_ORP0cnc.jpeg	2022-12-03 14:15:59.014783+00
62	product-images/benz_silver_ZtcAH5e.jfif	2022-12-03 15:19:08.207514+00
63	product-images/benz_red_PfARUl8.jfif	2022-12-03 15:19:27.020984+00
64	product-images/benz_yellow_ntEcv6a.jfif	2022-12-03 15:20:30.725131+00
65	product-images/benz_green_U9fwrua.jfif	2022-12-03 15:21:14.08332+00
66	product-images/cup_white.jpeg	2022-12-07 08:37:20.766786+00
67	product-images/cup_white_siExoIt.jpeg	2022-12-07 08:58:52.705241+00
68	product-images/cup_red.jpeg	2022-12-07 09:00:22.321251+00
69	product-images/orange_cup.jpeg	2022-12-07 09:00:28.358869+00
70	product-images/blue_cup.jpeg	2022-12-07 09:01:10.311901+00
71	product-images/benz_1_Akp7dmJ.jpeg	2022-12-08 08:35:57.971358+00
72	product-images/benz_1_iXpZf3o.jpeg	2022-12-08 08:39:35.084731+00
4	product-images/benz_2_0ZWiAXJ.jpeg	2022-11-08 13:17:30.956007+00
73	product-images/shoes.jpeg	2022-12-08 08:47:21.811934+00
74	product-images/macbook.jpeg	2022-12-08 08:50:13.012945+00
75	product-images/red_dress.webp	2022-12-08 08:57:30.760164+00
76	product-images/red_dress_9GNK89J.webp	2022-12-08 09:00:25.126406+00
77	product-images/brown_shoe.jpeg	2022-12-08 09:12:23.672897+00
78	product-images/suit.jpeg	2022-12-08 09:15:15.034205+00
79	product-images/Note_pad.jpeg	2022-12-08 09:37:47.795841+00
80	product-images/Note_pad_mgvdItN.jpeg	2022-12-08 09:40:40.721163+00
81	product-images/WhatsApp_Image_2022-11-09_at_20.45.115.jpg	2022-12-08 10:07:23.343143+00
82	product-images/WhatsApp_Image_2022-11-09_at_20.45.092.jpg	2022-12-08 10:07:52.689518+00
83	product-images/WhatsApp_Image_2022-11-09_at_20.45.104.jpg	2022-12-08 10:09:03.344498+00
84	product-images/bag_01.jpeg	2022-12-08 10:24:15.469822+00
85	product-images/WhatsApp_Image_2022-11-09_at_20.45.116.jpg	2022-12-09 09:30:14.905681+00
86	product-images/WhatsApp_Image_2022-11-09_at_20.45.127_rNZU2hN.jpg	2022-12-09 09:30:35.249874+00
87	product-images/Big_hat.jpeg	2022-12-09 10:18:48.362203+00
88	product-images/Brown_hat.jpeg	2022-12-09 10:19:41.950765+00
89	product-images/Orange_hat.jpeg	2022-12-09 10:20:56.618107+00
90	product-images/Pink_hat.webp	2022-12-09 10:23:23.230361+00
91	product-images/WhatsApp_Image_2022-11-09_at_21.32.37.jpg	2022-12-09 10:23:53.377346+00
92	product-images/WhatsApp_Image_2022-11-09_at_20.45.103_NTOZoUX.jpg	2022-12-09 10:24:32.779708+00
93	product-images/red_dress_U2WO6vL.webp	2022-12-12 12:54:11.726525+00
94	product-images/brown_shoe_1.jpeg	2022-12-13 09:48:48.84784+00
95	product-images/Orange_hat_nKKaKD7.jpeg	2022-12-13 09:54:25.301393+00
96	product-images/black_bag_men.webp	2022-12-13 10:02:19.247228+00
97	product-images/brown_bag.webp	2022-12-13 10:05:41.28651+00
98	product-images/Red_bag_woman.jpeg	2022-12-13 10:11:27.607+00
99	product-images/bicycle_1.jpeg	2022-12-13 10:14:14.007813+00
100	product-images/Black_helmet.jpeg	2022-12-13 10:21:36.977469+00
101	product-images/White_wine.jpeg	2022-12-13 10:29:24.631519+00
102	product-images/wine_1.jpeg	2022-12-13 10:31:13.788904+00
103	product-images/Lemonade.jpeg	2022-12-13 10:34:11.181516+00
104	product-images/WhatsApp_Image_2022-11-09_at_20.45.127_UgsW22i.jpg	2022-12-30 20:41:10.180157+00
105	product-images/WhatsApp_Image_2022-11-09_at_20.45.103_SeVcFLK.jpg	2022-12-30 20:41:35.191321+00
106	product-images/JeanTrouser.jpg	2023-01-03 09:49:40.481899+00
107	product-images/JeanTrouser_yer2yV7.jpg	2023-01-03 18:27:52.164721+00
108	product-images/JeanTrouser_j0YtgAh.jpg	2023-01-03 18:28:41.90918+00
109	product-images/Black_helmet_qJXbAQ4.jpeg	2023-01-04 12:03:50.465244+00
110	product-images/brown_shoe_1_NtG8EXj.jpeg	2023-01-04 12:05:11.932536+00
111	product-images/brown_bag_UXVDVX6.webp	2023-01-04 12:19:40.531161+00
112	product-images/bag_01_E3cKOjc.jpeg	2023-01-04 12:20:09.755407+00
113	product-images/JeanTrouser_DJSnpd7.jpg	2023-01-04 12:32:18.692458+00
114	product-images/Screenshot_10.png	2023-01-05 10:11:27.974857+00
115	product-images/Group_237598_3nWw7L5.png	2023-01-05 10:11:44.878599+00
116	product-images/Group_237598_KoWgRnQ.png	2023-01-05 10:12:32.906902+00
117	product-images/Group_237598_t6QEhh9.png	2023-01-05 10:12:52.518858+00
118	product-images/Screenshot_2.png	2023-01-05 10:34:23.253734+00
119	product-images/WhatsApp_Image_2022-11-09_at_21.32.37_LPf28NI.jpg	2023-01-05 10:34:37.292879+00
120	product-images/FITTYWILLS.png	2023-01-05 11:03:29.119473+00
121	product-images/WhatsApp_Image_2022-11-09_at_20.45.116_5NlIXmV.jpg	2023-01-05 11:06:43.120036+00
122	product-images/FITTYWILLS_YeglyFH.png	2023-01-05 11:08:37.257788+00
123	product-images/WhatsApp_Image_2022-11-09_at_20.45.104_MeZkqeC.jpg	2023-01-05 11:08:57.362855+00
124	product-images/WhatsApp_Image_2022-11-09_at_20.45.104_8VUcP7I.jpg	2023-01-05 11:16:46.255394+00
125	product-images/WhatsApp_Image_2022-11-09_at_20.45.127_aSTGInD.jpg	2023-01-05 11:17:41.60787+00
126	product-images/WhatsApp_Image_2022-11-09_at_21.32.27.jpg	2023-01-05 11:18:34.840866+00
127	product-images/WhatsApp_Image_2022-11-09_at_20.45.128_FffNBr2.jpg	2023-01-05 11:18:45.177288+00
128	product-images/JeanTrouser_hDdH4iB.jpg	2023-01-06 08:00:12.457899+00
129	product-images/Group_237598_5F9DVt3.png	2023-01-16 18:53:27.821007+00
130	product-images/FITTYWILLS_D0n5qn9.png	2023-01-16 18:54:07.34452+00
131	product-images/FITTYWILLS_gyAUFfg.png	2023-01-16 19:07:57.1745+00
132	product-images/WhatsApp_Image_2022-11-09_at_21.32.27_9hnR959.jpg	2023-01-16 19:10:07.231807+00
133	product-images/Ogechi_Altraide.jfif	2023-01-16 19:10:32.324586+00
134	product-images/Screenshot_2_ucQ94hZ.png	2023-01-16 19:10:51.627795+00
135	product-images/Screenshot_3.png	2023-01-16 19:11:21.708304+00
136	product-images/Group_237598_t3JUTGo.png	2023-01-16 19:13:18.355755+00
137	product-images/Screenshot_2_pVsZXFe.png	2023-01-16 19:31:57.335537+00
138	product-images/Screenshot_2_uB540U3.png	2023-01-16 19:35:11.467459+00
139	product-images/Screenshot_2_g2hZ2NI.png	2023-01-16 20:50:23.503011+00
140	product-images/FITTYWILLS_AZvtaRj.png	2023-01-16 20:59:23.578247+00
141	product-images/FITTYWILLS_f3k01xM.png	2023-01-16 23:13:23.219877+00
142	product-images/Screenshot_5_dZSbHlj.png	2023-01-17 10:46:05.841169+00
143	product-images/Screenshot_11.png	2023-01-17 11:03:24.898169+00
144	product-images/Screenshot_11_AcmCjbj.png	2023-01-17 11:05:14.456147+00
145	product-images/Group_237598_ysxEDFS.png	2023-01-17 11:07:09.970275+00
146	product-images/Group_237598_UZRSa3Y.png	2023-01-17 11:07:50.116598+00
147	product-images/Like_Animation.png	2023-01-17 11:10:17.947043+00
148	product-images/WhatsApp_Image_2022-11-09_at_21.32.37_Q6Mq10s.jpg	2023-01-17 11:53:08.776864+00
149	product-images/WhatsApp_Image_2022-11-09_at_20.45.09.jpg	2023-01-17 11:55:45.421272+00
150	product-images/WhatsApp_Image_2022-11-09_at_20.45.09_XqpH6JM.jpg	2023-01-17 11:56:02.770932+00
151	product-images/FITTYWILLS_sAb6Gvc.png	2023-01-17 11:58:19.348482+00
152	product-images/WhatsApp_Image_2022-11-09_at_20.45.104_24S6kmi.jpg	2023-01-17 11:59:49.857147+00
153	product-images/Group_237598_0YikaEB.png	2023-01-17 12:00:30.07855+00
154	product-images/WhatsApp_Image_2022-11-09_at_20.45.116_fYfOWiT.jpg	2023-01-18 15:28:47.968261+00
155	product-images/Group_237598_ZyL0bvs.png	2023-01-18 15:30:59.548876+00
156	product-images/Group_237598_zYhOWzh.png	2023-01-18 15:31:31.898138+00
157	product-images/Group_237598_rN3m8ou.png	2023-01-18 15:32:49.122475+00
158	product-images/FITTYWILLS_sIY7Ai7.png	2023-01-18 15:33:39.282592+00
159	product-images/Group_237598_WbKlIcc.png	2023-01-18 15:34:20.48244+00
160	product-images/Screenshot_11_kpTFsuC.png	2023-01-18 15:41:27.832754+00
161	product-images/Screenshot_11_Lb2lem7.png	2023-01-18 15:44:53.401176+00
162	product-images/Screenshot_11_aZN5vBN.png	2023-01-18 15:45:28.081533+00
163	product-images/FITTYWILLS_XYxj8CB.png	2023-01-18 15:46:51.778848+00
164	product-images/Screenshot_11_H4OXUUo.png	2023-01-18 18:18:49.00188+00
165	product-images/banner_3.jpeg	2023-01-20 08:44:42.076269+00
166	product-images/banner_3_dM8cDMX.jpeg	2023-01-20 08:45:23.810658+00
167	product-images/Big_hat_aOeyeZl.jpeg	2023-01-20 08:46:59.337849+00
168	product-images/adashi.png	2023-01-20 08:48:02.854098+00
169	product-images/banner_3_eBoScR6.jpeg	2023-01-20 08:50:00.664154+00
170	product-images/adashi_Rs56jXk.png	2023-01-20 08:50:46.483916+00
171	product-images/download.jpeg	2023-01-21 07:01:27.529659+00
172	product-images/188378_1662192105.webp	2023-01-21 07:03:06.439409+00
173	product-images/188378_1662217034.webp	2023-01-21 07:03:25.396232+00
174	product-images/118566_1645476978.webp	2023-01-21 07:06:09.937986+00
175	product-images/banner_3_ggd9Egn.jpeg	2023-01-23 11:52:26.162021+00
176	product-images/Detox_water.webp	2023-01-23 13:50:46.273032+00
177	product-images/detox_water_2.webp	2023-01-23 13:52:32.581957+00
178	product-images/Detox_water_nKsJW0T.webp	2023-01-23 13:53:51.230346+00
179	product-images/detox_water_2_UlLgjrr.webp	2023-01-23 13:54:13.854695+00
180	product-images/detox_water_2_4VweNEC.webp	2023-01-23 13:55:19.229364+00
181	product-images/detox_water_2_JW8uJJF.webp	2023-01-23 13:56:06.999576+00
182	product-images/188378_1662192105.webp	2023-01-24 09:16:28.77414+00
183	product-images/188378_1662217034.webp	2023-01-24 09:17:40.209939+00
184	product-images/download.jpeg	2023-01-24 09:18:06.334318+00
185	product-images/118566_1645476978.webp	2023-01-24 09:18:19.422524+00
186	product-images/118566_1645476978_bgdbGjL.webp	2023-01-24 09:35:27.43484+00
187	product-images/118566_1645476978_0eaXTs0.webp	2023-01-24 09:35:46.507271+00
188	product-images/118566_1645476978_OSQC42r.webp	2023-01-24 09:36:16.057723+00
189	product-images/118566_1645476978_BaHrFJf.webp	2023-01-24 09:36:24.885846+00
190	product-images/download_Pm1DMoV.jpeg	2023-01-24 09:36:37.234532+00
191	product-images/188378_1662192105_ujiAqcm.webp	2023-01-24 09:40:09.318204+00
192	product-images/118566_1645476978_piVXzQb.webp	2023-01-24 09:40:36.45997+00
193	product-images/118566_1645476978_9jkbRsD.webp	2023-01-24 09:45:21.879436+00
194	product-images/118566_1645476978_cHTI2Sn.webp	2023-01-24 09:46:13.611371+00
195	product-images/118566_1645476978_aSCxfN1.webp	2023-01-24 09:58:46.878267+00
196	product-images/118566_1645476978_apI2j3C.webp	2023-01-24 10:00:29.622704+00
197	product-images/118566_1645476978_XmzQYT2.webp	2023-01-24 10:01:18.701021+00
198	product-images/118566_1645476978_p9OTg2n.webp	2023-01-24 10:10:35.036289+00
199	product-images/118566_1645476978_FRFDZiz.webp	2023-01-24 10:16:20.386871+00
200	product-images/118566_1645476978_47ECfo1.webp	2023-01-24 10:18:44.043453+00
201	product-images/118566_1645476978_jwCnNH8.webp	2023-01-24 10:21:54.62097+00
202	product-images/car_pic.jpg	2023-01-25 11:19:29.64337+00
203	product-images/car_pic_ztZPCIU.jpg	2023-01-25 11:20:49.792807+00
204	product-images/download_1.jpeg	2023-01-28 08:28:58.008629+00
205	product-images/download_2.jpeg	2023-01-28 08:29:14.787514+00
206	product-images/download_3.jpeg	2023-01-28 08:30:07.706061+00
207	product-images/188378_1662217034_YCjjTkD.webp	2023-01-29 10:07:22.73089+00
208	product-images/1.jpg	2023-01-29 21:11:46.633115+00
209	product-images/1_NYQuvj6.jpg	2023-01-29 21:14:07.981884+00
210	product-images/1_1.jpg	2023-01-29 21:15:00.705659+00
211	product-images/1_2.jpg	2023-01-29 21:16:17.116474+00
212	product-images/banner_3_K1u5lqR.jpeg	2023-01-30 11:19:05.745654+00
213	product-images/banner_3_vtNDrtQ.jpeg	2023-01-30 11:21:17.00901+00
214	product-images/IMG-20230130-WA0013.jpg	2023-01-30 11:40:12.536024+00
215	product-images/IMG-20230130-WA0013_QVAtzSM.jpg	2023-01-30 11:41:16.85092+00
216	product-images/1_1_WwRbJdz.jpg	2023-01-31 09:52:19.122811+00
217	product-images/1_2_q3C2yol.jpg	2023-01-31 09:53:04.174499+00
218	product-images/1_5.jpg	2023-02-07 07:09:23.659831+00
219	product-images/WhatsApp_Image_2022-12-23_at_3.22.18_PM.jpeg	2023-02-07 08:16:16.703345+00
220	product-images/WhatsApp_Image_2022-12-23_at_3.22.18_PM_lgDnnuW.jpeg	2023-02-07 08:16:36.973703+00
221	product-images/WhatsApp_Image_2022-12-23_at_3.22.18_PM_9wZw5hb.jpeg	2023-02-07 08:17:02.375192+00
222	product-images/1_5_XbzYRs2.jpg	2023-02-07 08:30:06.185524+00
223	product-images/1_3.jpg	2023-02-07 08:33:23.134544+00
224	product-images/1_5_LWdWi9l.jpg	2023-02-07 08:37:41.372717+00
225	product-images/1_5_xgWp6B7.jpg	2023-02-07 13:35:44.39318+00
226	product-images/1_3_5f4KzuU.jpg	2023-02-07 13:36:49.37008+00
227	product-images/1_5_RWQr58H.jpg	2023-02-07 13:37:58.413125+00
228	product-images/1_5_0SNY16e.jpg	2023-02-08 10:15:45.633097+00
229	product-images/1_3_7Cmdc00.jpg	2023-02-08 10:15:51.333138+00
230	product-images/1_5_HS8EgeD.jpg	2023-02-08 10:18:07.875986+00
231	product-images/1_5_9NX5SEF.jpg	2023-02-08 11:50:49.582624+00
232	product-images/1_5_ntVxMsN.jpg	2023-02-08 12:21:27.525372+00
233	product-images/1_5_kFjctjK.jpg	2023-02-09 16:28:11.408333+00
234	product-images/1_5_riJnnM4.jpg	2023-02-09 21:51:00.69019+00
235	product-images/1_3_ET6VKR0.jpg	2023-02-09 21:51:12.166499+00
236	product-images/1_3_A9a53sa.jpg	2023-02-09 21:52:01.358384+00
237	product-images/1_4.jpg	2023-02-09 21:52:08.61617+00
238	product-images/1_4_hAIXD1c.jpg	2023-02-09 21:53:20.813139+00
239	product-images/MacBook_Pro_16__-_25.jpg	2023-02-09 21:53:25.400743+00
240	product-images/1_5_BTDpIqb.jpg	2023-02-09 21:53:31.69414+00
241	product-images/1_4_gFH9srM.jpg	2023-02-10 09:51:43.882551+00
242	product-images/1_5_CGsiDNf.jpg	2023-02-10 09:52:21.700868+00
243	product-images/1_5_ibbQ3ig.jpg	2023-02-10 09:55:31.306644+00
244	product-images/1_5_kLohvfn.jpg	2023-02-10 10:02:02.847976+00
245	product-images/1_5_AdljYO7.jpg	2023-02-10 10:12:55.062029+00
246	product-images/1_3_MpxxqCC.jpg	2023-02-10 10:13:27.30627+00
247	product-images/1_5_WkuCucT.jpg	2023-02-10 10:14:02.394721+00
248	product-images/1_5_ytzB2u2.jpg	2023-02-10 10:14:18.586655+00
249	product-images/1_5_685tSC1.jpg	2023-02-10 10:14:32.019017+00
250	product-images/1_5_04PquWa.jpg	2023-02-10 10:26:56.253144+00
251	product-images/1_5_7Y3Uk5r.jpg	2023-02-10 10:27:32.72619+00
252	product-images/1_3_RZ0ckYI.jpg	2023-02-10 10:27:53.746804+00
253	product-images/1_5_qeYY2M7.jpg	2023-02-13 11:24:54.934642+00
254	product-images/1_4_SgsgY0H.jpg	2023-02-13 11:25:03.530481+00
255	product-images/60848550.png	2023-06-02 12:08:18.842002+00
256	product-images/60848550_L2l8Xzn.png	2023-06-02 12:11:41.001513+00
257	product-images/60848550_qWVlfLr.png	2023-06-02 12:22:23.223794+00
258	product-images/60848550_HjpfYQG.png	2023-06-02 12:22:41.041484+00
259	product-images/avatar.png	2023-06-04 11:41:33.091299+00
260	product-images/avatar_ugtcfrm.png	2023-06-04 11:41:43.216246+00
261	product-images/avatar_vJ9FEz2.png	2023-06-04 19:02:15.82961+00
262	product-images/avatar_Qn59OXF.png	2023-06-04 19:19:30.723947+00
263	product-images/avatar_Eiua8Tu.png	2023-06-04 19:35:59.969392+00
264	product-images/60848550_Gdbmmfb.png	2023-06-05 08:13:54.950102+00
265	product-images/60848550_0cgdYnj.png	2023-06-05 08:14:36.962708+00
266	product-images/60848550_DEtUZLy.png	2023-06-05 08:18:32.085906+00
267	product-images/60848550_fiEgqhg.png	2023-06-05 08:19:19.943938+00
268	product-images/60848550_LzIWSPs.png	2023-06-06 21:10:41.313104+00
269	product-images/60848550_XJUB9bU.png	2023-06-07 09:03:26.61663+00
270	product-images/60848550_5aYdg7V.png	2023-06-07 09:04:42.412171+00
271	product-images/avatar_k5lGWvm.png	2023-06-07 20:47:20.571264+00
272	product-images/avatar_NftnQt1.png	2023-06-07 20:51:03.489398+00
273	product-images/Screen_Shot_2023-09-19_at_11.16.05_AM.png	2023-10-23 11:25:46.5581+00
\.


--
-- Data for Name: ecommerce_order; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.ecommerce_order (id, payment_status, created_on, updates_on, address_id, cart_id, customer_id) FROM stdin;
6	pending	2022-12-08 13:27:22.710988+00	2022-12-08 13:27:22.711001+00	\N	\N	34
40	pending	2022-12-30 13:06:33.290012+00	2022-12-30 13:06:33.290029+00	44	344	47
4	pending	2022-12-02 10:44:34.088639+00	2022-12-02 10:44:34.088655+00	4	43	29
8	pending	2022-12-08 15:09:31.792755+00	2022-12-08 15:09:31.792769+00	\N	\N	34
15	pending	2022-12-12 11:27:40.34237+00	2022-12-12 11:27:40.342392+00	\N	\N	34
19	pending	2022-12-12 13:34:31.502077+00	2022-12-12 13:34:31.502103+00	\N	\N	34
1	success	2022-11-25 12:10:28.69233+00	2022-11-25 12:10:28.69235+00	\N	1	30
3	pending	2022-11-25 15:01:57.872242+00	2022-11-25 15:01:57.872264+00	\N	13	34
2	pending	2022-11-25 12:44:14.285712+00	2022-11-25 13:59:50.249572+00	\N	\N	34
5	pending	2022-12-08 12:13:02.247858+00	2022-12-08 12:13:02.247872+00	\N	\N	34
7	pending	2022-12-08 14:38:35.324278+00	2022-12-08 14:38:35.324292+00	\N	\N	34
10	pending	2022-12-08 17:39:27.404104+00	2022-12-08 17:39:27.404118+00	21	\N	31
12	pending	2022-12-08 18:21:17.370455+00	2022-12-08 18:21:17.37047+00	19	\N	31
9	pending	2022-12-08 15:37:29.192162+00	2022-12-08 15:37:29.192177+00	\N	\N	34
13	pending	2022-12-09 13:11:33.651041+00	2022-12-09 13:11:33.651057+00	5	\N	33
11	pending	2022-12-08 18:03:39.240568+00	2022-12-08 18:03:39.240584+00	\N	\N	34
33	pending	2022-12-16 14:17:49.377983+00	2022-12-16 14:17:49.377997+00	\N	\N	34
44	pending	2022-12-30 17:25:49.738881+00	2022-12-30 17:27:18.745179+00	\N	\N	34
16	pending	2022-12-12 11:40:23.194533+00	2022-12-12 11:40:23.194548+00	\N	\N	34
18	pending	2022-12-12 13:10:53.509302+00	2022-12-12 13:10:53.509317+00	\N	\N	34
21	pending	2022-12-12 13:49:04.159736+00	2022-12-12 13:49:04.159752+00	\N	\N	34
24	pending	2022-12-14 10:48:44.943085+00	2022-12-14 10:48:44.943101+00	\N	\N	34
26	pending	2022-12-14 13:45:18.003798+00	2022-12-14 13:45:18.003815+00	\N	\N	34
28	pending	2022-12-14 16:59:39.001162+00	2022-12-14 21:58:41.242168+00	\N	\N	34
20	pending	2022-12-12 13:39:56.979735+00	2022-12-12 13:39:56.97975+00	24	\N	42
32	pending	2022-12-16 12:53:43.340574+00	2022-12-16 12:53:43.340591+00	\N	\N	34
17	pending	2022-12-12 12:35:00.311475+00	2022-12-12 12:35:00.311495+00	5	\N	33
27	pending	2022-12-14 15:04:44.483326+00	2022-12-14 15:04:44.483341+00	\N	\N	34
23	pending	2022-12-14 10:06:31.090064+00	2022-12-14 10:06:31.090103+00	5	\N	33
41	pending	2022-12-30 14:24:26.598284+00	2022-12-30 14:24:26.5983+00	45	344	47
66	success	2023-01-11 18:57:27.658938+00	2023-01-11 19:00:06.522089+00	\N	467	34
67	success	2023-01-12 21:50:41.565179+00	2023-01-12 22:00:44.228393+00	70	482	34
68	pending	2023-01-12 22:12:21.884651+00	2023-01-12 22:12:21.884667+00	31	479	33
42	pending	2022-12-30 15:25:34.796304+00	2022-12-30 15:25:34.796322+00	40	\N	33
35	pending	2022-12-21 08:08:03.137689+00	2022-12-21 08:08:03.137705+00	30	\N	33
30	pending	2022-12-14 21:51:19.456751+00	2022-12-14 21:54:44.130972+00	19	181	31
29	success	2022-12-14 21:44:45.410233+00	2022-12-30 17:08:11.649364+00	21	181	31
25	pending	2022-12-14 13:09:41.098038+00	2022-12-14 13:10:50.323658+00	5	\N	33
79	failed	2023-01-18 14:15:43.933204+00	2023-01-18 19:04:58.650751+00	70	\N	34
46	success	2023-01-03 06:48:01.172607+00	2023-01-16 10:38:22.126957+00	19	353	31
31	pending	2022-12-16 11:32:41.829327+00	2022-12-16 11:32:41.829344+00	5	\N	33
70	pending	2023-01-16 11:40:17.300109+00	2023-01-16 11:40:17.300124+00	19	490	31
71	pending	2023-01-16 11:49:34.39113+00	2023-01-16 11:49:34.391144+00	19	491	31
72	pending	2023-01-16 11:58:52.930691+00	2023-01-16 11:58:52.930708+00	21	492	31
34	pending	2022-12-16 14:50:42.957083+00	2022-12-20 08:47:38.623978+00	5	\N	33
22	pending	2022-12-12 14:14:50.656797+00	2022-12-12 14:14:50.656811+00	24	\N	42
73	success	2023-01-16 13:17:12.940163+00	2023-01-16 13:18:13.777328+00	19	493	31
74	success	2023-01-17 00:43:39.678737+00	2023-01-17 00:45:09.054101+00	70	489	34
83	pending	2023-01-29 06:46:15.880323+00	2023-01-29 06:46:15.880337+00	70	523	34
36	pending	2022-12-30 09:20:47.194818+00	2022-12-30 09:20:47.194837+00	\N	\N	\N
37	pending	2022-12-30 11:36:10.285114+00	2022-12-30 11:36:10.285132+00	\N	\N	\N
76	success	2023-01-17 09:43:26.745964+00	2023-01-17 09:44:05.236327+00	30	495	33
77	success	2023-01-17 10:59:35.579889+00	2023-01-17 11:00:23.976712+00	19	496	31
38	pending	2022-12-30 12:51:26.582393+00	2022-12-30 12:51:26.582408+00	43	\N	53
86	pending	2023-02-10 14:41:08.512802+00	2023-02-10 14:41:08.512819+00	21	509	31
39	pending	2022-12-30 12:54:39.083353+00	2022-12-30 12:54:39.08337+00	38	\N	49
78	pending	2023-01-18 11:09:23.831542+00	2023-01-18 11:09:23.831571+00	30	\N	33
47	success	2023-01-03 08:15:33.024696+00	2023-01-03 10:17:36.504502+00	38	356	49
43	success	2022-12-30 15:26:55.709753+00	2023-01-04 11:07:38.539273+00	40	348	33
48	success	2023-01-04 17:30:49.532375+00	2023-01-04 17:31:46.670228+00	38	359	49
92	failed	2023-02-13 14:33:52.399971+00	2023-02-13 14:35:27.50931+00	21	\N	31
80	success	2023-01-19 09:38:53.700982+00	2023-01-19 09:40:10.891619+00	40	506	33
51	success	2023-01-05 09:07:07.435177+00	2023-01-05 09:08:41.455172+00	30	364	33
52	success	2023-01-05 09:42:23.252894+00	2023-01-05 09:45:00.546256+00	40	365	33
53	success	2023-01-05 10:14:11.198874+00	2023-01-05 10:33:54.471282+00	47	362	49
54	pending	2023-01-05 13:05:30.639523+00	2023-01-05 13:05:30.639541+00	21	353	31
55	success	2023-01-05 14:17:30.134872+00	2023-01-05 14:19:11.21351+00	38	370	49
75	success	2023-01-17 09:34:12.719715+00	2023-01-17 09:35:25.492677+00	\N	479	33
60	pending	2023-01-06 13:14:45.743013+00	2023-01-06 13:14:45.743027+00	\N	\N	33
65	failed	2023-01-10 05:58:45.56904+00	2023-01-10 06:03:32.577424+00	\N	\N	33
69	success	2023-01-13 06:16:21.955113+00	2023-01-13 06:17:19.61826+00	\N	483	34
82	pending	2023-01-28 08:36:05.666695+00	2023-01-28 08:36:05.66671+00	43	441	53
58	success	2023-01-06 08:39:19.468993+00	2023-01-06 08:41:18.938835+00	40	382	33
61	pending	2023-01-06 13:16:46.101435+00	2023-01-06 13:16:46.10145+00	30	\N	33
63	success	2023-01-07 07:54:31.344244+00	2023-01-07 08:20:18.505663+00	30	443	33
85	success	2023-02-10 13:57:54.795076+00	2023-02-10 15:38:18.56515+00	77	523	34
87	success	2023-02-12 15:21:48.152911+00	2023-02-12 15:23:11.760679+00	70	525	34
64	pending	2023-01-10 05:47:01.543656+00	2023-01-10 05:47:01.543673+00	30	\N	33
45	pending	2022-12-30 17:29:35.257321+00	2022-12-30 17:29:35.257337+00	\N	\N	34
14	pending	2022-12-12 10:19:24.758595+00	2022-12-12 10:19:24.75861+00	\N	\N	34
59	pending	2023-01-06 09:16:47.675544+00	2023-01-06 09:16:47.675586+00	\N	\N	34
57	pending	2023-01-06 00:41:42.187641+00	2023-01-06 00:41:42.187656+00	\N	\N	34
62	failed	2023-01-06 15:06:08.773328+00	2023-01-06 15:08:27.848844+00	\N	\N	34
50	pending	2023-01-04 18:12:38.951773+00	2023-01-04 18:12:38.95179+00	\N	\N	34
56	pending	2023-01-06 00:37:10.415134+00	2023-01-06 00:37:10.415149+00	\N	\N	34
81	success	2023-01-26 08:22:19.585348+00	2023-02-12 20:35:35.343089+00	19	509	31
88	success	2023-02-13 08:29:15.336018+00	2023-02-13 08:29:57.996098+00	21	527	31
89	success	2023-02-13 08:40:34.924101+00	2023-02-13 11:05:33.816676+00	21	528	31
49	success	2023-01-04 17:39:47.254538+00	2023-03-06 16:04:55.447884+00	38	360	49
84	pending	2023-02-10 13:17:16.828965+00	2023-03-02 10:08:52.080343+00	40	521	33
93	pending	2023-02-13 22:04:41.436232+00	2023-02-13 22:04:41.436248+00	19	\N	31
90	pending	2023-02-13 14:20:54.618659+00	2023-02-13 14:23:01.280835+00	70	\N	34
91	pending	2023-02-13 14:25:22.045678+00	2023-02-13 14:25:22.045694+00	77	\N	34
95	success	2023-02-21 10:53:32.171+00	2023-02-21 10:56:12.736+00	5	521	33
96	success	2023-03-24 09:04:07.09637+00	2023-03-24 09:09:58.42115+00	5	536	33
97	success	2023-03-24 09:27:18.402747+00	2023-03-24 09:28:25.320582+00	5	537	33
98	success	2023-03-24 09:38:58.989372+00	2023-03-24 09:39:57.132931+00	19	538	31
99	success	2023-03-24 10:02:08.812109+00	2023-03-24 10:03:08.663416+00	21	539	31
100	pending	2023-03-24 10:15:42.430589+00	2023-03-24 10:15:42.430607+00	19	540	31
102	pending	2023-03-28 09:16:57.953638+00	2023-03-28 09:16:57.953656+00	5	542	33
101	success	2023-03-27 15:10:52.850198+00	2023-03-28 09:30:35.149816+00	19	541	31
94	success	2023-02-20 19:03:17.185698+00	2023-06-05 20:53:49.487118+00	70	\N	34
\.


--
-- Data for Name: ecommerce_orderentry; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.ecommerce_orderentry (id, item_total, management_fee, delivery_fee, total, status, notified_for, order_no, tracking_id, shipper_settled, shipper_settled_date, merchant_settled, merchant_settled_date, created_on, updated_on, cart_id, order_id, seller_id) FROM stdin;
\.


--
-- Data for Name: ecommerce_orderproduct; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.ecommerce_orderproduct (id, price, quantity, discount, total, status, delivery_date, created_on, updated_on, cancelled_on, packed_on, shipped_on, delivered_on, returned_on, payment_on, refunded_on, request_for_return, cancelled_by_id, order_id, product_detail_id, sub_total, company_id, delivery_fee, payment_method, shipper_name, tracking_id, waybill_no, booked) FROM stdin;
1	0.00	1	0.00	0.00	paid	\N	2022-11-25 12:10:28.693294+00	2022-11-25 12:10:28.693307+00	\N	\N	\N	\N	\N	\N	\N	f	\N	1	17	0.00	\N	0.00	\N	\N	\N	\N	t
3	1000111111.00	100	10.00	0.00	paid	\N	2022-11-25 15:01:57.873139+00	2022-11-25 15:01:57.873153+00	\N	\N	\N	\N	\N	\N	\N	f	\N	3	22	1000111111.00	452	0.00	Pay Attitude X	Shippers Name	657890	1234567	t
2	10000000.00	100	10.00	1000000.00	paid	2022-12-01	2022-11-25 12:44:14.28647+00	2022-12-01 15:53:37.680262+00	\N	\N	\N	\N	\N	\N	\N	f	\N	2	20	0.00	452	10.00	Pay Attitude	dellyman	65789	1234567	t
5	45000.00	1	0.00	45000.00	paid	2023-01-02	2022-12-30 17:08:11.670888+00	2022-12-30 17:08:11.672412+00	\N	\N	\N	\N	\N	2022-12-30 17:08:11.672308+00	\N	f	\N	29	42	0.00	\N	0.00	card	\N	\N	\N	t
4	3500.00	1	0.00	3500.00	paid	2023-01-02	2022-12-30 17:08:11.65926+00	2022-12-30 17:08:11.66141+00	\N	\N	\N	\N	\N	2022-12-30 17:08:11.661299+00	\N	f	\N	29	38	0.00	643	1262.50	card	DELLYMAN	\N	\N	t
54	4500.00	1	0.00	4500.00	paid	2023-01-22	2023-01-19 09:40:10.900532+00	2023-01-19 09:40:10.902698+00	\N	\N	\N	\N	\N	2023-01-19 09:40:10.902591+00	\N	f	\N	80	45	0.00	643	1000.00	card	DELLYMAN	\N	\N	t
6	1000.00	1	10.00	990.00	paid	2023-01-06	2023-01-03 10:17:36.513765+00	2023-01-03 10:17:36.515814+00	\N	\N	\N	\N	\N	2023-01-03 10:17:36.515704+00	\N	f	\N	47	17	0.00	643	2020.00	card	DELLYMAN	\N	\N	t
7	72000.00	1	0.00	72000.00	paid	2023-01-07	2023-01-04 11:07:38.548341+00	2023-01-04 11:07:38.550445+00	\N	\N	\N	\N	\N	2023-01-04 11:07:38.55034+00	\N	f	\N	43	22	0.00	643	1010.00	card	DELLYMAN	\N	\N	t
46	1000.00	1	0.00	1000.00	processed	2023-01-20	2023-01-17 00:45:09.074168+00	2023-01-27 11:59:41.828929+00	\N	2023-01-17 00:45:13+00	\N	\N	\N	2023-01-17 00:45:09+00	\N	f	\N	74	23	0.00	\N	973.92	card	REDSTAR	PAYMALL-7446	SA01524604	t
8	20500.00	1	23500.00	-3000.00	paid	2023-01-07	2023-01-04 17:31:46.678884+00	2023-01-04 17:31:46.680874+00	\N	\N	\N	\N	\N	2023-01-04 17:31:46.680769+00	\N	f	\N	48	18	0.00	643	2020.00	card	DELLYMAN	\N	\N	t
44	5000.00	1	0.00	5000.00	processed	2023-01-19	2023-01-16 13:18:08.972352+00	2023-01-27 11:59:50.423846+00	\N	2023-01-16 13:18:13+00	\N	\N	\N	2023-01-16 13:18:08+00	\N	f	\N	73	20	0.00	643	1868.50	card	DELLYMAN	PAYMALL-7344	9338657743	t
43	1000.00	1	0.00	1000.00	processed	2023-01-19	2023-01-16 13:18:08.961443+00	2023-01-27 11:59:58.641582+00	\N	2023-01-16 13:18:13+00	\N	\N	\N	2023-01-16 13:18:08+00	\N	f	\N	73	23	0.00	\N	973.92	card	REDSTAR	PAYMALL-7343	SA01523925	t
10	100.00	1	0.00	100.00	paid	2023-01-07	2023-01-04 17:40:23.951256+00	2023-03-06 16:04:55.450415+00	\N	\N	\N	\N	\N	2023-01-04 17:40:23+00	\N	f	\N	49	16	0.00	\N	0.00	card	Redstar	\N	\N	t
11	30000.00	1	40000.00	-10000.00	paid	2023-01-08	2023-01-05 09:08:41.464142+00	2023-01-05 09:08:41.466179+00	\N	\N	\N	\N	\N	2023-01-05 09:08:41.466052+00	\N	f	\N	51	16	0.00	\N	5528.24	card	GIGLOGISTICS	\N	\N	t
12	5000.00	1	0.00	5000.00	paid	2023-01-08	2023-01-05 09:45:00.555293+00	2023-01-05 09:45:00.557487+00	\N	\N	\N	\N	\N	2023-01-05 09:45:00.557376+00	\N	f	\N	52	44	0.00	643	1010.00	card	DELLYMAN	\N	\N	t
15	10200.00	1	0.00	10200.00	paid	2023-01-08	2023-01-05 10:33:54.499744+00	2023-01-05 10:33:54.501194+00	\N	\N	\N	\N	\N	2023-01-05 10:33:54.501087+00	\N	f	\N	53	19	0.00	643	2020.00	card	DELLYMAN	\N	\N	t
14	30000.00	1	40000.00	-10000.00	paid	2023-01-08	2023-01-05 10:33:54.490287+00	2023-01-05 10:33:54.491741+00	\N	\N	\N	\N	\N	2023-01-05 10:33:54.491635+00	\N	f	\N	53	16	0.00	643	707.00	card	DELLYMAN	\N	\N	t
13	1000.00	1	0.00	1000.00	paid	2023-01-08	2023-01-05 10:33:54.47941+00	2023-01-05 10:33:54.481626+00	\N	\N	\N	\N	\N	2023-01-05 10:33:54.481487+00	\N	f	\N	53	49	0.00	643	707.00	card	DELLYMAN	\N	\N	t
17	20500.00	1	23500.00	-3000.00	paid	2023-01-08	2023-01-05 14:19:11.233356+00	2023-01-05 14:19:11.234749+00	\N	\N	\N	\N	\N	2023-01-05 14:19:11.234643+00	\N	f	\N	55	18	0.00	\N	0.00	card	\N	\N	\N	t
16	1000.00	1	0.00	1000.00	paid	2023-01-08	2023-01-05 14:19:11.22244+00	2023-01-05 14:19:11.224614+00	\N	\N	\N	\N	\N	2023-01-05 14:19:11.224473+00	\N	f	\N	55	49	0.00	643	707.00	card	DELLYMAN	\N	\N	t
18	5000.00	1	0.00	5000.00	paid	2023-01-09	2023-01-06 08:41:18.948002+00	2023-01-06 08:41:18.950192+00	\N	\N	\N	\N	\N	2023-01-06 08:41:18.950068+00	\N	f	\N	58	20	0.00	643	1010.00	card	DELLYMAN	\N	\N	t
19	34900.00	1	0.00	34900.00	paid	2023-01-10	2023-01-07 08:20:18.515169+00	2023-01-07 08:20:18.517328+00	\N	\N	\N	\N	\N	2023-01-07 08:20:18.517211+00	\N	f	\N	63	54	0.00	643	1767.50	card	DELLYMAN	\N	\N	t
20	400.00	4	0.00	400.00	paid	2023-01-10	2023-01-07 08:20:18.527099+00	2023-01-07 08:20:18.528784+00	\N	\N	\N	\N	\N	2023-01-07 08:20:18.528678+00	\N	f	\N	63	31	0.00	643	1767.50	card	DELLYMAN	\N	\N	t
21	5000.00	1	0.00	5000.00	paid	2023-01-10	2023-01-07 08:20:18.536654+00	2023-01-07 08:20:18.538075+00	\N	\N	\N	\N	\N	2023-01-07 08:20:18.537968+00	\N	f	\N	63	44	0.00	643	1767.50	card	DELLYMAN	\N	\N	t
22	72000.00	1	0.00	72000.00	paid	2023-01-10	2023-01-07 08:20:18.545874+00	2023-01-07 08:20:18.54724+00	\N	\N	\N	\N	\N	2023-01-07 08:20:18.547133+00	\N	f	\N	63	22	0.00	643	1767.50	card	DELLYMAN	\N	\N	t
23	3500.00	1	0.00	3500.00	paid	2023-01-10	2023-01-07 08:20:18.555007+00	2023-01-07 08:20:18.556384+00	\N	\N	\N	\N	\N	2023-01-07 08:20:18.556278+00	\N	f	\N	63	38	0.00	643	1767.50	card	DELLYMAN	\N	\N	t
24	12000.00	1	0.00	12000.00	paid	2023-01-14	2023-01-11 19:00:06.531686+00	2023-01-11 19:00:06.533917+00	\N	\N	\N	\N	\N	2023-01-11 19:00:06.533799+00	\N	f	\N	66	43	0.00	643	1212.00	card	DELLYMAN	\N	\N	t
25	23000.00	1	25000.00	-2000.00	paid	2023-01-14	2023-01-11 19:00:06.542919+00	2023-01-11 19:00:06.54432+00	\N	\N	\N	\N	\N	2023-01-11 19:00:06.544213+00	\N	f	\N	66	39	0.00	\N	973.92	card	REDSTAR	\N	\N	t
26	45000.00	1	0.00	45000.00	paid	2023-01-15	2023-01-12 22:00:44.237449+00	2023-01-12 22:00:44.240017+00	\N	\N	\N	\N	\N	2023-01-12 22:00:44.239909+00	\N	f	\N	67	42	0.00	643	1262.50	card	DELLYMAN	\N	\N	t
27	120.00	1	0.00	120.00	paid	2023-01-15	2023-01-12 22:00:44.248544+00	2023-01-12 22:00:44.249923+00	\N	\N	\N	\N	\N	2023-01-12 22:00:44.249826+00	\N	f	\N	67	24	0.00	643	1464.50	card	DELLYMAN	\N	\N	t
28	1000.00	1	0.00	1000.00	paid	2023-01-15	2023-01-12 22:00:44.25752+00	2023-01-12 22:00:44.258866+00	\N	\N	\N	\N	\N	2023-01-12 22:00:44.258768+00	\N	f	\N	67	23	0.00	\N	973.92	card	REDSTAR	\N	\N	t
29	500.00	1	0.00	500.00	paid	2023-01-15	2023-01-12 22:00:44.266426+00	2023-01-12 22:00:44.267756+00	\N	\N	\N	\N	\N	2023-01-12 22:00:44.267659+00	\N	f	\N	67	46	0.00	643	1767.50	card	DELLYMAN	\N	\N	t
30	72000.00	1	0.00	72000.00	paid	2023-01-16	2023-01-13 06:17:19.627119+00	2023-01-13 06:17:19.629258+00	\N	\N	\N	\N	\N	2023-01-13 06:17:19.629147+00	\N	f	\N	69	22	0.00	643	1262.50	card	DELLYMAN	\N	\N	t
31	1000.00	1	0.00	1000.00	paid	2023-01-16	2023-01-13 06:17:19.637737+00	2023-01-13 06:17:19.639106+00	\N	\N	\N	\N	\N	2023-01-13 06:17:19.639006+00	\N	f	\N	69	23	0.00	\N	973.92	card	REDSTAR	\N	\N	t
32	5000.00	1	0.00	5000.00	paid	2023-01-19	2023-01-16 10:38:22.136398+00	2023-01-16 10:38:22.138664+00	\N	\N	\N	\N	\N	2023-01-16 10:38:22.138535+00	\N	f	\N	46	20	0.00	643	1868.50	card	DELLYMAN	\N	\N	t
33	1000.00	1	0.00	1000.00	paid	2023-01-19	2023-01-16 10:38:22.14808+00	2023-01-16 10:38:22.149493+00	\N	\N	\N	\N	\N	2023-01-16 10:38:22.149391+00	\N	f	\N	46	23	0.00	\N	973.92	card	REDSTAR	\N	\N	t
34	500.00	1	0.00	500.00	paid	2023-01-19	2023-01-16 10:38:22.157438+00	2023-01-16 10:38:22.158881+00	\N	\N	\N	\N	\N	2023-01-16 10:38:22.158778+00	\N	f	\N	46	46	0.00	643	1868.50	card	DELLYMAN	\N	\N	t
35	500.00	1	0.00	500.00	paid	2023-01-19	2023-01-16 11:41:00.241603+00	2023-01-16 11:41:00.243958+00	\N	\N	\N	\N	\N	2023-01-16 11:41:00.243841+00	\N	f	\N	70	46	0.00	643	1868.50	card	DELLYMAN	\N	\N	t
37	1000.00	1	0.00	1000.00	paid	2023-01-19	2023-01-16 11:41:00.263039+00	2023-01-16 11:41:00.264403+00	\N	\N	\N	\N	\N	2023-01-16 11:41:00.264298+00	\N	f	\N	70	23	0.00	\N	973.92	card	REDSTAR	\N	\N	t
38	1000.00	1	0.00	1000.00	paid	2023-01-19	2023-01-16 11:50:15.0662+00	2023-01-16 11:50:15.06866+00	\N	\N	\N	\N	\N	2023-01-16 11:50:15.068504+00	\N	f	\N	71	23	0.00	\N	973.92	card	REDSTAR	\N	\N	t
40	500.00	1	0.00	500.00	paid	2023-01-19	2023-01-16 11:50:15.086482+00	2023-01-16 11:50:15.087833+00	\N	\N	\N	\N	\N	2023-01-16 11:50:15.087725+00	\N	f	\N	71	46	0.00	643	1868.50	card	DELLYMAN	\N	\N	t
42	500.00	1	0.00	500.00	paid	2023-01-19	2023-01-16 11:59:34.60318+00	2023-01-16 11:59:34.60465+00	\N	\N	\N	\N	\N	2023-01-16 11:59:34.604522+00	\N	f	\N	72	46	0.00	643	1262.50	card	DELLYMAN	\N	\N	t
45	10200.00	1	0.00	10200.00	paid	2023-01-20	2023-01-17 00:45:09.062987+00	2023-01-17 00:45:09.065343+00	\N	\N	\N	\N	\N	2023-01-17 00:45:09.065228+00	\N	f	\N	74	19	0.00	643	1767.50	card	DELLYMAN	\N	\N	t
47	1500000.00	3	0.00	1500000.00	paid	2023-01-20	2023-01-17 09:35:25.501613+00	2023-01-17 09:35:25.50384+00	\N	\N	\N	\N	\N	2023-01-17 09:35:25.503735+00	\N	f	\N	75	47	0.00	643	1750.00	card	DELLYMAN	\N	\N	t
48	1500000.00	3	0.00	1500000.00	paid	2023-01-20	2023-01-17 09:35:25.51242+00	2023-01-17 09:35:25.514186+00	\N	\N	\N	\N	\N	2023-01-17 09:35:25.514085+00	\N	f	\N	75	33	0.00	643	1750.00	card	DELLYMAN	\N	\N	t
49	23000.00	1	25000.00	-2000.00	paid	2023-01-20	2023-01-17 09:44:05.24536+00	2023-01-17 09:44:05.247662+00	\N	\N	\N	\N	\N	2023-01-17 09:44:05.247526+00	\N	f	\N	76	39	0.00	643	1750.00	card	DELLYMAN	\N	\N	t
50	1000.00	1	0.00	1000.00	paid	2023-01-20	2023-01-17 09:44:05.257175+00	2023-01-17 09:44:05.258749+00	\N	\N	\N	\N	\N	2023-01-17 09:44:05.258646+00	\N	f	\N	76	23	0.00	643	1750.00	card	DELLYMAN	\N	\N	t
51	10200.00	1	0.00	10200.00	paid	2023-01-20	2023-01-17 09:44:05.267045+00	2023-01-17 09:44:05.268514+00	\N	\N	\N	\N	\N	2023-01-17 09:44:05.268414+00	\N	f	\N	76	19	0.00	643	1750.00	card	DELLYMAN	\N	\N	t
52	72000.00	1	0.00	72000.00	paid	2023-01-20	2023-01-17 09:44:05.276527+00	2023-01-17 09:44:05.277942+00	\N	\N	\N	\N	\N	2023-01-17 09:44:05.277842+00	\N	f	\N	76	22	0.00	643	1750.00	card	DELLYMAN	\N	\N	t
55	34900.00	1	0.00	34900.00	paid	2023-01-22	2023-01-19 09:40:10.914341+00	2023-01-19 09:40:10.916026+00	\N	\N	\N	\N	\N	2023-01-19 09:40:10.915924+00	\N	f	\N	80	54	0.00	643	1000.00	card	DELLYMAN	\N	\N	t
56	1000.00	1	0.00	1000.00	paid	2023-01-22	2023-01-19 09:40:10.924052+00	2023-01-19 09:40:10.925456+00	\N	\N	\N	\N	\N	2023-01-19 09:40:10.925359+00	\N	f	\N	80	23	0.00	\N	0.00	card	DELLYMAN	\N	\N	t
53	20000.00	1	0.00	20000.00	processed	2023-01-20	2023-01-17 11:00:23.984765+00	2023-01-27 11:59:25.564925+00	\N	2023-01-17 11:00:26+00	\N	\N	\N	2023-01-17 11:00:23+00	\N	f	\N	77	48	0.00	643	1414.00	card	DELLYMAN	PAYMALL-7753	9377424246	t
58	30.00	1	0.00	30.00	processed	2023-02-13	2023-02-10 15:38:18.585473+00	2023-02-10 15:38:18.587038+00	\N	2023-02-10 15:38:21.356723+00	\N	\N	\N	2023-02-10 15:38:18.586931+00	\N	f	\N	85	58	0.00	643	1262.50	card	DELLYMAN	PAYMALL-8558	9938615669	t
57	1000.00	1	0.00	1000.00	processed	2023-02-13	2023-02-10 15:38:18.574369+00	2023-02-10 15:38:18.576633+00	\N	2023-02-10 15:38:21.359385+00	\N	\N	\N	2023-02-10 15:38:18.576503+00	\N	f	\N	85	23	0.00	643	\N	card	REDSTAR	PAYMALL-8557	\N	t
59	700000.00	1	0.00	700000.00	processed	2023-02-15	2023-02-12 15:23:11.770257+00	2023-02-12 15:23:11.772508+00	\N	2023-02-12 15:23:13.878512+00	\N	\N	\N	2023-02-12 15:23:11.772392+00	\N	f	\N	87	56	0.00	643	1262.50	card	DELLYMAN	PAYMALL-8759	1346443471	t
60	5000.00	1	0.00	5000.00	processed	2023-02-15	2023-02-12 20:35:35.352291+00	2023-02-12 20:35:35.35533+00	\N	2023-02-12 20:35:37.801261+00	\N	\N	\N	2023-02-12 20:35:35.355217+00	\N	f	\N	81	20	0.00	643	1919.00	card	DELLYMAN	PAYMALL-8160	2583771915	t
61	710000.00	1	0.00	710000.00	processed	2023-02-16	2023-02-13 08:29:58.004995+00	2023-02-13 08:29:58.007198+00	\N	2023-02-13 08:29:59.953914+00	\N	\N	\N	2023-02-13 08:29:58.007076+00	\N	f	\N	88	57	0.00	643	1262.50	card	DELLYMAN	PAYMALL-8861	9449763222	t
62	45000.00	1	0.00	45000.00	processed	2023-02-16	2023-02-13 11:05:33.826051+00	2023-02-13 11:05:33.8286+00	\N	2023-02-13 11:05:35.175772+00	\N	\N	\N	2023-02-13 11:05:33.82847+00	\N	f	\N	89	37	0.00	643	\N	card	DELLYMAN	PAYMALL-8962	\N	t
63	72000.00	1	0.00	72000.00	processed	2023-02-16	2023-02-13 11:05:33.83765+00	2023-02-13 11:05:33.839042+00	\N	2023-02-13 11:05:35.175772+00	\N	\N	\N	2023-02-13 11:05:33.838927+00	\N	f	\N	89	22	0.00	643	\N	card	DELLYMAN	PAYMALL-8962	\N	t
66	400.00	1	0.00	1364.28	paid	2023-03-27	2023-03-24 09:28:25.329735+00	2023-03-24 09:28:25.332101+00	\N	\N	\N	\N	\N	2023-03-24 09:28:25.33198+00	\N	f	\N	97	60	400.00	\N	964.28	card	REDSTAR	\N	\N	t
64	700000.00	1	0.00	0.00	processed	2023-03-05	2023-03-02 10:56:12.745718+00	2023-03-02 10:56:12.747898+00	\N	2023-03-02 10:56:14.977837+00	\N	\N	\N	2023-03-02 10:56:12.74779+00	\N	f	\N	95	56	0.00	643	707.00	card	DELLYMAN	PAYMALL-9564	8878577996	t
65	400.00	1	0.00	1364.28	paid	2023-03-27	2023-03-24 09:09:58.430206+00	2023-03-24 09:09:58.432721+00	\N	\N	\N	\N	\N	2023-03-24 09:09:58.432603+00	\N	f	\N	96	60	400.00	\N	964.28	card	REDSTAR	\N	\N	t
67	5000.00	1	0.00	5964.28	paid	2023-03-27	2023-03-24 09:28:25.3432+00	2023-03-24 09:28:25.344718+00	\N	\N	\N	\N	\N	2023-03-24 09:28:25.344612+00	\N	f	\N	97	44	5000.00	\N	964.28	card	REDSTAR	\N	\N	t
68	4000.00	1	0.00	4964.28	paid	2023-03-27	2023-03-24 09:28:25.355031+00	2023-03-24 09:28:25.356394+00	\N	\N	\N	\N	\N	2023-03-24 09:28:25.356289+00	\N	f	\N	97	22	4000.00	\N	964.28	card	REDSTAR	\N	\N	t
69	4500.00	1	0.00	5464.28	paid	2023-03-27	2023-03-24 09:28:25.366254+00	2023-03-24 09:28:25.367635+00	\N	\N	\N	\N	\N	2023-03-24 09:28:25.367517+00	\N	f	\N	97	45	4500.00	\N	964.28	card	REDSTAR	\N	\N	t
70	44000.00	1	0.00	44964.28	paid	2023-03-27	2023-03-24 09:39:57.141382+00	2023-03-24 09:39:57.143576+00	\N	\N	\N	\N	\N	2023-03-24 09:39:57.143438+00	\N	f	\N	98	61	44000.00	\N	964.28	card	REDSTAR	\N	\N	t
71	44000.00	1	0.00	44964.28	paid	2023-03-27	2023-03-24 10:03:08.672637+00	2023-03-24 10:03:08.674813+00	\N	\N	\N	\N	\N	2023-03-24 10:03:08.674697+00	\N	f	\N	99	61	44000.00	\N	964.28	card	REDSTAR	\N	\N	t
72	44000.00	1	0.00	44964.28	paid	2023-03-27	2023-03-24 14:24:21.158329+00	2023-03-24 14:24:24.210318+00	\N	\N	\N	\N	\N	2023-03-24 14:24:24.210203+00	\N	f	\N	100	61	44000.00	\N	964.28	card	REDSTAR	\N	\N	t
73	44000.00	1	0.00	44964.28	processed	2023-03-31	2023-03-28 09:30:32.533087+00	2023-03-28 09:30:32.535461+00	\N	2023-03-28 09:30:35.127952+00	\N	\N	\N	2023-03-28 09:30:32.535351+00	\N	f	\N	101	61	44000.00	\N	964.28	card	REDSTAR	PAYMALL-10173	SA01577634	t
\.


--
-- Data for Name: ecommerce_product; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.ecommerce_product (id, name, tags, status, is_featured, view_count, sale_count, created_on, updated_on, category_id, store_id, sub_category_id, published_on, image_id, product_type_id, brand_id, description, decline_reason, approved_by_id, checked_by_id, last_viewed_date, slug, choice, discount_end_time, free_shipping) FROM stdin;
54	Azarai Rings	rings	active	f	18	5	2023-01-28 08:31:58.829009+00	2023-07-10 15:24:16.40299+00	7	26	5	\N	204	11	16	Leila sterling silver engagement ring\n\n	\N	\N	53	2023-07-10 15:24:16.396443+00	Azarai-Rings-65319caa54	f	\N	f
16	Leather shoes	tag1, tag2, tag3	active	t	64	3	2022-12-27 13:22:07.139+00	2023-09-28 17:29:56.963649+00	1	5	2	\N	77	1	2	Brown men's shoe	\N	\N	\N	2023-09-28 17:29:56.960223+00	Leather-shoes-9708fac116	f	\N	f
44	Jean	jean	inactive	f	14	2	2023-01-04 12:38:47.908317+00	2023-02-14 01:25:43.32888+00	1	15	2	\N	113	3	16	Jean for men	\N	\N	57	2023-01-24 09:20:18.821363+00	product-slug4	f	\N	f
52	Samsung S22 Ultra	samsung,  android,  phone,  bixbie	active	f	188	4	2023-01-21 07:06:46.758373+00	2023-09-01 13:24:26.320407+00	3	6	6	\N	171	4	4	Write your best stories\nGet the best of innovation with the Samsung Galaxy S22 Ultra. Featuring a stunning 6.8" Infinity Dynamic AMOLED display with Quad HD+ 1440 x 3088 pixel resolution, it offers 120Hz adaptive refresh for incredible smoothness. Plus, with its 2.9GHz Exynos 2200 Octo-Core processor backed by 12GB of RAM and 256GB of storage, you can install all your favourite applications easily and without strain.\nAnd with a high-performance 108+12+10+10 quad-sensor main camera and the ability to record 8K video, you'll never look at your smartphone the same way again.\n\nGorgeous screen\nThe Samsung Galaxy S22 Ultra features a 6.8" Infinity-O Dynamic AMOLED display withQuad HD+ resolution of 1440 x 3088 pixels, which enhances the richness of the images while giving you a spectacularly immersive experience. And with an adaptive refresh rate of 120Hz, using your smartphone has never been more enjoyable. In addition, the S22 Ultra features a2.9GHz Exynos 2200 Octo-Core processor, 12GB of RAM and256GB of capacityto give you all the power you need to get the most out of your smartphone, so even the most graphics-intensive games run ultra smoothly.\nDual SIM, the Samsung Galaxy S22 Ultra allows you to efficiently manage your business and personal life in the best way.\n\nBreathtaking photos\nEnjoy the ultimate photo and video experience with the Samsung Galaxy S22 Ultra and its quadruple 108+12+10+10 MP photo sensor. Offering exceptional detail with its 108 MP sensor, it also has an exceptional 10x optical zoom to help you take unique shots. And the Space Zoom x100 is great for capturing every detail without compromising the quality of your photo.\nPlus, shoot breathtaking video with the ability to shoot in 8K 24 fps via the main camera or 4K 60 fps via the main and front cameras. The 40 MP Dual Pixel front camera, with HDR10+ technology, offers many possibilities for studio quality portraits.\n\nA smart smartphone\nThe Samsung Galaxy S22 Ultra offers seamless security throughfacial recognition and anultrasonic fingerprint reader located under the screen. The ultrasonic fingerprint reader works in all light conditions, but also in cold and wet conditions and has a better security. The Samsung Galaxy S22 Ultra is also equipped with a5000 mAh smart battery that learns from your usage to optimise performance.\nMore powerful than ever, the Galaxy S22 Ultra features better WiFi thanks to its compatibility with the new generation of WiFi 6E to provide you with higher speeds than the old generation.\n\nAndroid 12\nWithAndroid 12, Google brings more security, but above all a big aesthetic change. Indeed, Android 12 rethinks the entire user interface to be more spacious and comfortable. As a result, the interface is alive with every tap, swipe and scroll, responding quickly and expressively with fluid movements and animations.\nAnd with a brand new conversation widget, you can put conversations with the people you love front and centre on your home screen.\n\nKey features:\nProcessor: Exynos 2200 Octo-Core clocked at 2.9 GHz\nSystem: Android 12 (Samsung One UI 4.1 overlay)\nDisplay: 6.8-inch Infinity-O, Quad HD+ resolution of 1440 x 3088 pixels, 500 dpi, 120 Hz adaptive, Dynamic AMOLED 2x, Gorilla Glass Victus+, Blue Light Filter, HDR10+\nRAM: 12 GB\nMain camera: 108 MP (f/1.8 aperture, OIS) + 12 MP (ultra wide angle, Dual Pixel, f/2.2 aperture) + 10 MP (telephoto, OIS, 10x optical zoom, 100x Space Zoom, Dual Pixel, f/4.9) + 10 MP (Telephoto, OIS, 3x optical zoom, 30x Space Zoom, Dual Pixel, f/2.4 aperture), Artificial Intelligence, Optical Stabilisation, Scene Optimiser, Intelligent Professional Framing, 8K 24 fps / 4K 60 fps video\nFront camera: 40 MP Dual Pixel, f/2.2 aperture, autofocus, HDR10+, motion control, voice control, 4K 60 fps video\nStorage: 512 GB\nConnectivity: 5G LTE, NFC, Bluetooth 5.0, GPS, GLONASS, Beidou, Galileo, Wi-Fi 6E (2.4/5/6 GHz), under-screen ultrasonic fingerprint reader, facial recognition, USB Type C\n5000 mAh battery with 45W fast charge capability\nDimensions: 163.3 x 77.9 x 8.9 mm and 228 g	\N	\N	53	2023-09-01 13:24:26.313443+00	Samsung-S22-Ultra-27b8e0f052	f	\N	f
33	Brown shoe	Leather	active	f	18	2	2022-12-27 13:22:07.139+00	2023-02-23 14:41:42.952281+00	1	6	2	\N	94	10	16	Brown shoe	\N	\N	\N	2023-02-23 14:41:42.95202+00	Brown-shoe-9c145dae33	f	\N	f
21	TF Military Drone		declined	f	4	0	2022-12-27 13:22:07.139+00	2022-12-27 14:52:54.735+00	3	6	6	2022-11-23 13:20:25+00	102	5	9	Drone	This product didn't meet I required standard	\N	\N	\N	product-slug6	f	\N	f
28	Red dress	Red dress	active	f	16	2	2022-12-27 13:22:07.139+00	2023-02-24 11:20:42.351631+00	1	6	30	2022-12-08 10:12:24+00	76	9	16	Pretty dress	\N	\N	57	2023-02-24 11:20:42.349143+00	Red-dress-9a3f624228	f	\N	f
23	Benz	Juice, drink	active	t	149	10	2022-12-18 13:22:07.139+00	2023-07-27 11:02:22.445644+00	5	7	5	\N	72	6	14	Product Description	\N	\N	\N	2023-07-27 11:02:22.440779+00	Benz-9a85cebd23	f	\N	f
50	Daniel	book	active	f	83	2	2023-01-05 11:19:01.610497+00	2023-09-28 17:20:35.707998+00	13	6	15	\N	126	10	5	fghjklkjhg	\N	\N	53	2023-09-28 17:20:35.70485+00	Daniel-fd7e168150	f	\N	f
27	Cup	Cup, Drink, mug	declined	f	0	0	2022-12-07 09:03:01.161793+00	2022-12-08 09:06:52.688256+00	9	8	29	\N	67	8	16	Durable cups		\N	\N	\N	product-slug1	f	\N	f
36	Office bag	Laptop bag	active	f	13	0	2022-12-27 13:22:07.139+00	2023-09-05 08:45:14.467983+00	1	7	2	\N	97	10	16	Brown office bag	\N	\N	\N	2023-09-05 08:45:14.464483+00	Office-bag-267ce36536	f	\N	f
29	Note Pad	Book	active	f	43	9	2022-12-27 13:22:07.139+00	2023-07-25 08:14:53.832978+00	13	6	15	2022-12-08 10:02:14+00	80	10	16	Mini note pad	\N	\N	57	2023-07-25 08:14:53.829036+00	Note-Pad-703d1bb029	f	\N	f
45	Test	bag	declined	f	0	0	2023-01-04 13:25:02.699205+00	2023-01-21 11:21:11.107757+00	1	11	30	\N	111	9	16	dsfghjk	Fake item	\N	\N	\N	product-slug7	f	\N	f
49	Phone	book, book2	declined	f	0	0	2023-01-05 11:09:09.641269+00	2023-01-20 13:06:46.751126+00	13	6	15	\N	121	10	2	rtrertertyrt		\N	\N	\N	product-slug5	f	\N	f
34	Hat	hat, beach	active	f	20	3	2022-12-18 13:22:07.139+00	2023-02-27 07:26:07.19443+00	1	6	30	\N	95	10	16	Beach hats	\N	\N	\N	2023-02-27 07:26:07.192202+00	Hat-a5f2a6e634	f	\N	f
18	Suit		active	t	73	6	2022-12-27 13:22:07.139+00	2023-09-05 08:46:32.000413+00	1	6	2	2022-11-23 13:20:25+00	78	1	16	Black suit	\N	\N	\N	2023-09-05 08:46:31.997174+00	Suit-82640f0518	f	\N	f
43	Iphone 11	iphone, phone	active	f	14	3	2022-12-30 20:42:21.958507+00	2023-02-28 14:35:37.648105+00	11	6	27	\N	104	7	5	An iphone 11	\N	\N	53	2023-02-28 14:35:37.644748+00	Iphone-11-b6e5306343	f	\N	f
20	Sneakers		active	t	46	4	2022-11-23 13:22:07.139288+00	2023-02-22 11:11:39.13031+00	1	6	30	2022-11-23 13:20:25+00	73	5	8	Product Description	\N	\N	\N	2023-02-22 11:11:39.130145+00	Sneakers-16dba4db20	f	\N	f
30	Cabbage	food	active	f	12	0	2022-12-27 13:22:07.139+00	2023-07-25 08:12:10.253342+00	11	6	26	\N	83	7	3	helooooooooooooooooooooooooooo	\N	\N	\N	2023-07-25 08:12:10.250031+00	Cabbage-1a506d7e30	f	\N	f
38	Bicycle	bicycle	active	f	3	2	2022-12-13 10:16:09.288357+00	2023-02-23 10:58:41.575108+00	10	5	10	\N	99	10	15	Easy ride	\N	\N	\N	2023-02-23 10:58:41.574929+00	Bicycle-fe545b7738	f	\N	f
53	Detox Water	drinks, water	active	f	19	2	2023-01-23 13:52:52.322327+00	2023-09-29 08:31:54.256106+00	9	11	29	\N	178	8	16	Infused water	\N	\N	53	2023-09-29 08:31:54.251536+00	Detox-Water-e694e0ff53	f	\N	f
39	Helmet		active	f	41	1	2022-12-27 13:22:07.139+00	2023-02-22 13:54:27.800224+00	10	5	10	\N	100	10	16	Black helmet	\N	\N	\N	2023-02-22 13:54:27.800003+00	Helmet-da4009f939	f	\N	f
37	Bag	Luxury	active	f	14	0	2022-12-27 13:22:07.139+00	2023-02-22 13:33:29.245666+00	1	7	30	\N	98	10	3	Durable bag	\N	\N	\N	2023-02-22 13:33:29.245439+00	Bag-dc05c31d37	f	\N	f
42	Lemonade	Lemonade\r\nLemon	active	f	16	5	2022-12-27 13:22:07.139+00	2023-02-23 14:45:02.472488+00	31	6	7	2022-12-18 05:00:00+00	103	10	16	Lemonade	\N	\N	\N	2023-02-23 14:45:02.472265+00	Lemonade-8af4146642	f	\N	f
26	Benz	Car, ride, luxury	active	f	34	1	2022-12-03 15:25:14.610822+00	2023-02-23 14:45:06.881172+00	11	8	26	\N	62	7	15	Luxury	\N	\N	\N	2023-02-23 14:45:06.880912+00	Benz-1a624a5326	f	\N	f
32	Hat	hat, beach	active	f	11	0	2022-12-27 13:22:07.139+00	2023-02-23 14:45:09.242997+00	1	6	30	2022-12-13 09:58:09+00	87	3	3	Hat	\N	\N	\N	2023-02-23 14:45:09.242766+00	Hat-e10a155532	f	\N	f
19	Jacket		active	f	41	6	2022-12-27 13:22:07.139+00	2023-02-23 14:45:12.786468+00	1	6	2	2022-11-23 13:20:25+00	121	1	9	\N	\N	\N	\N	2023-02-23 14:45:12.786228+00	Jacket-9e798f8319	f	\N	f
17	Laptop	tag1, tag2	active	t	97	10	2022-12-27 13:22:07.139+00	2023-03-04 12:18:22.873581+00	3	6	3	\N	4	4	13	r6t7y8iuo	\N	\N	\N	2023-03-04 12:18:22.870725+00	Laptop-bd7a88ce17	f	\N	f
31	Iphone 14	phone, iphone, android	active	f	50	3	2022-12-27 13:22:07.139+00	2023-03-04 12:18:11.669599+00	3	6	6	\N	85	4	4	this is an iphone	\N	\N	\N	2023-03-04 12:18:11.667234+00	Iphone-14-c1f5c2d731	f	\N	f
35	Office bag		active	f	2	2	2022-12-27 13:22:07.139+00	2023-02-23 14:45:26.312876+00	1	7	2	\N	96	10	3	Black office bag for men	\N	\N	\N	2023-02-23 14:45:26.312656+00	Office-bag-015ce4f635	f	\N	f
56	Pancake	Food	declined	f	0	0	2023-01-30 11:42:02.083721+00	2023-01-30 11:43:33.507994+00	7	11	21	\N	214	11	16	Vanilla flavour	Not accepted	\N	\N	\N	product-slug	f	\N	f
47	Camers 360	tedt, kok	declined	f	0	0	2023-01-05 10:16:28.762001+00	2023-01-21 11:25:53.190255+00	3	6	19	\N	116	4	4	rghgghjj	we have no idea what this item is please, be more descriptive next time\n	\N	\N	\N	product-slug3	f	\N	f
48	Wall	book	declined	f	0	0	2023-01-05 10:42:10.425979+00	2023-01-21 11:22:53.524869+00	1	6	2	\N	118	9	16	tyikhjklhjkl	This is item isn't desciptive enough though	\N	\N	\N	product-slug8	f	\N	f
60	HP Pavillion 15'	laptop,  pro,  gadget,  hp	active	f	48	0	2023-02-09 21:54:19.961395+00	2023-06-06 22:06:36.487002+00	9	6	24	\N	234	2	17	Hp pavillion 15 inch laptop 1920 x 1080	\N	\N	53	2023-06-06 22:06:36.481776+00	HP-Pavillion-15'-c419f65260	f	\N	f
55	Tecno Camon 19 Pro 8GB 256GB-Mondrian(Tiwa Savage Signature)	tecno, android	active	f	52	0	2023-01-29 21:20:17.904805+00	2023-09-01 13:53:32.544664+00	7	26	5	\N	208	11	13	Memory\nROM: 256GB\nRAM : 8GB\nExternal Memory: up to 2T\n\nnetwork\n\nData: GPRS, EDGE, 3G, 4G,5G\nCamera Location: Front/Rear\nPixels: Front(16MP )/Rear(64MP AI Enhanced Triple Camera)\nFlash Light : Yes with Dual Front Flash And Quad Rear Flash\n\n \n\nBody And Display\n\nDimension: 166.7*74.3*8.6mm\nWeight: 185g\nDisplay Features: 120Hz FHD+ High Gamut Display\nColor: Black\nScreen Type: IPS\nScreen Size: 6.8” Inch\nResolution: 1080 x 2460 pixels\nBuild: Glass front, plastic back, plastic frame\nSim: Dual SIM (Nano-SIM, dual stand-by)\n\n \n\nDevicePlatform\n\nOperating System: Android 12, HIOS 8.6\nChipset: MediaTek MT6833P Dimensity 810 (6 nm)\nCPU: 2×2.4 GHz Cortex-A76 & 6×2.0 GHz Cortex-A55 (Octa-Core)\nGPU: Mali-G57 MC2\n\nbandwidth\n\n2G：B3-8 2G：B2-3-5-8\n3G：B1-8 3G： B1-5-8 3G：B1-2-4-5-8\n4G：B1-3-7-8-20 4G： B1-3-5-8-38-40-41 4G：B1-2-3-4-5-7-8-20-28A-38-40-41 5G: SA/NSA\n\nSpeed: HSPA 42.2/5.76 Mbps, LTE-A, 5G\n\n \n\nbatteries\n\nCapacity: 5000mAh\nFlash Charge: 33W\n\nConnectivity\n\nWIFI: Wi-Fi 802.11 a/b/g/n/ac, dual-band, Wi-Fi Direct, hotspot\nBluetooth: YES\nNFC: YES\nGPS: Yes, with A-GPS\nRadio: FM radio\nUSB: MicroUSB Type-C 2.0 USB OTG\n\n \n\nAudio\n\nAlert Types: Vibration; Sounds\nLoudspeaker: Yes\n3.5mm Jack: Yes\n\nOther features\n\nSensors: Fingerprint (Side-mounted), G-Sensor, Light Sensor, Proximity Sensor\n\nThe 0.98mm Slimmest Bezel\nThe industry's TOP 1 extremely slim bezel, as slim as 0.98mm. No sense of black edge, greater expansion of visual range.\n\n\nDazzling Backshell With 200 million stars\nWe moved the Milky Way to your phone. The diamond coating of 200 million stars is like a bright starry sky; the delicate touch, non-stick fingerprints and premium texture will make you love it.\n\n\nNFC\nCAMON 19 Pro guards your transactions strictly with NFC technology. Every payment will be simple, easy and safe.	\N	\N	53	2023-09-01 13:53:32.541366+00	Tecno-Camon-19-Pro-8GB-256GB-Mondrian(Tiwa-Savage-Signature)-9e045ec355	f	\N	f
41	Wine	Wine	active	f	13	2	2022-12-27 13:22:07.139+00	2023-09-28 17:20:21.244801+00	31	6	7	\N	102	11	16	Wine	\N	\N	\N	2023-09-28 17:20:21.241563+00	Wine-a3fc0c7d41	f	\N	f
64	urer	he,  jds,  d,  ds	active	f	1	0	2023-06-04 19:02:20.079424+00	2023-09-28 17:20:28.297862+00	7	6	5	\N	261	6	4	rer	\N	\N	\N	2023-09-28 17:20:28.294528+00	urer-b34b6fef64	f	\N	f
24	LG tv New	tv, lg	active	f	53	1	2022-12-18 13:22:07.139+00	2023-03-09 09:26:06.120702+00	3	8	20	\N	60	4	5	this is the lg tv	\N	\N	\N	2023-03-09 09:26:06.118543+00	LG-tv-New-fd832fc424	f	\N	f
69	Daniel	\N	pending	f	0	0	2023-10-23 11:24:23.741925+00	2023-10-23 11:24:23.749673+00	1	6	2	\N	\N	1	1	The official	\N	\N	\N	\N	Daniel-c7ce9d0769	f	\N	f
22	Macbook	macbook\r\nlaptop	active	t	173	7	2022-12-27 13:22:07.139+00	2023-03-24 09:28:25.360958+00	3	6	6	2022-11-23 13:20:25+00	74	5	10	This is a Macbook	\N	\N	\N	2023-02-28 13:51:16.284141+00	Macbook-47b1e8c822	f	\N	f
25	LG tv Bonanza	tv, lg	declined	f	0	0	2022-12-03 14:37:25.435293+00	2022-12-05 23:54:33.602074+00	3	8	20	\N	60	4	5	this is the lg tv	The product doesn't have a price	\N	\N	\N	product-slug2	f	\N	f
63	Hp 3 4	laptop,     hp	inactive	f	0	0	2023-02-13 11:26:34.163287+00	2023-07-10 14:03:56.352342+00	9	6	24	\N	253	2	17	Prodjc test	\N	\N	56	\N	product-slug9	f	\N	f
57	Apple Smart Watch	apple,   watch	active	f	2	0	2023-02-07 08:07:38.420008+00	2023-07-10 15:21:52.980479+00	1	5	2	\N	217	1	1	Describe the product	\N	\N	\N	2023-07-10 15:21:52.975725+00	product-slug10	f	\N	f
67	Barcelona Jersey	\N	pending	f	0	0	2023-10-19 12:45:51.815172+00	2023-10-19 12:46:53.958417+00	1	6	2	\N	\N	1	17	The official jersey of Arsenal Football Club (AFC)	\N	\N	\N	\N	Barcelona-Jersey-97d0565c67	f	\N	f
65	Daniel Adekoya	\N	active	f	2	0	2023-06-04 19:21:14.020181+00	2023-07-25 08:13:43.011307+00	7	6	5	\N	262	6	2	rer	\N	\N	\N	2023-07-25 08:13:43.007975+00	Daniel-Adekoya-40ac3c7865	f	\N	f
66	Arsenal Jersey	\N	pending	f	0	0	2023-10-19 11:04:22.084171+00	2023-10-19 13:15:24.654221+00	1	6	2	\N	\N	1	17	The official jersey of Arsenal Football Club (AFC)	\N	\N	\N	\N	Arsenal-Jersey-6f59099d66	f	\N	f
40	White wine	Wine \r\nwhite wine	active	f	28	3	2022-12-27 13:22:07.139+00	2023-09-01 13:43:07.858879+00	31	6	7	\N	101	11	16	Sweet	\N	\N	\N	2023-09-01 13:43:07.855657+00	White-wine-34189bd240	f	\N	f
68	Manchester United Jersey	\N	pending	f	0	0	2023-10-19 12:47:45.305728+00	2023-10-20 08:46:08.008805+00	1	6	2	\N	\N	1	17	The official jersey of Arsenal Football Club (AFC)	\N	\N	\N	\N	Manchester-United-Jersey-095ee63168	f	\N	f
\.


--
-- Data for Name: ecommerce_productcategory; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.ecommerce_productcategory (id, name, image, created_on, updated_on, parent_id, slug) FROM stdin;
44	Sub Test	category-images/bag_01_UQV25P5.jpeg	2023-02-09 08:54:12.455798+00	2023-02-09 08:54:12.465759+00	43	sub-test
45	Test 2	category-images/bag_01_Ac1HEcy.jpeg	2023-02-09 14:29:03.333485+00	2023-02-09 14:29:03.335994+00	\N	test-2
28	Medium Car		2022-12-01 13:08:03.087052+00	2022-12-01 13:08:03.087074+00	11	mid-car
46	Sub test 1	category-images/bag_01_HavBP7R.jpeg	2023-02-09 14:36:42.723033+00	2023-02-09 14:36:42.734074+00	45	sub-test-1
29	Kitchen utensils		2022-12-07 08:53:06.596121+00	2022-12-07 08:53:06.596144+00	9	kitchen
12	Livestock		2022-11-30 12:15:09.541425+00	2022-11-30 12:15:09.541447+00	\N	livestock
47	Carrot	category-images/download.jpeg	2023-03-02 12:34:14.99929+00	2023-03-02 12:34:15.015092+00	31	Carrot-c361258347
30	Women's wear		2022-12-08 08:14:19.181952+00	2022-12-08 08:14:19.181974+00	1	women-wear
1	Fashion	category-images/fashion_mall_1.jpeg	2022-10-10 09:25:56.818377+00	2022-12-08 08:18:47.503121+00	\N	fashion
13	Books & Stationaries	category-images/Books_and_stationery.webp	2022-11-30 12:15:48.192841+00	2022-12-08 09:21:47.337058+00	\N	book-stationaries
14	Plastic & Paper Products		2022-11-30 12:16:32.138911+00	2022-11-30 12:16:32.138931+00	13	pastic-paper
15	Books		2022-11-30 12:16:57.75424+00	2022-11-30 12:16:57.754261+00	13	books
3	Electronics	category-images/elect_1.jpeg	2022-10-10 09:36:29.400912+00	2022-12-08 10:25:39.764064+00	\N	elect
11	Vehicle & Automotives	category-images/vehicles_1.jpeg	2022-11-30 12:15:02.93476+00	2022-12-08 10:27:28.471188+00	\N	vehicle
16	Religious Articles		2022-11-30 12:17:17.254022+00	2022-11-30 12:17:17.254043+00	13	religion-articles
17	Console		2022-11-30 12:17:41.679087+00	2022-11-30 12:17:41.67911+00	8	console
10	Sport & Fitness	category-images/Work_out.jpeg	2022-11-30 12:14:36.304203+00	2022-12-08 10:32:13.601794+00	\N	sport
18	Game Accessories		2022-11-30 12:17:50.863721+00	2022-11-30 12:17:50.863742+00	8	game-accessories
31	Grocery	category-images/Grocery_1.jpeg	2022-12-13 10:27:53.559833+00	2022-12-13 10:39:30.04175+00	\N	grocery
7	Drinks and Wines		2022-11-30 11:31:47.894413+00	2023-01-25 12:21:22.4106+00	\N	drinks-wine
36	Phone & Mobile		2023-01-25 12:23:08.890161+00	2023-01-25 12:23:08.890191+00	\N	phone
2	Men's Wear	product-images/FcSZS5XWQAEa4g9_0lnOgH7.jpeg	2022-10-10 09:26:24.125883+00	2022-10-10 09:26:24.125904+00	1	mens-wear
19	Cameras		2022-11-30 12:18:02.273823+00	2022-11-30 12:18:02.273845+00	3	cameras
4	Televison	product-images/tv.webp	2022-10-10 09:38:52.4319+00	2022-10-10 09:38:52.431917+00	3	television
37	Android Phones		2023-01-25 12:23:27.642676+00	2023-01-25 12:23:27.642695+00	36	android
6	Gadgets	product-images/payarena_logo_gzhwv2P.jpeg	2022-11-23 13:36:23.143603+00	2022-11-23 13:36:23.143625+00	3	gadgets
38	iPhone		2023-01-25 12:23:44.523435+00	2023-01-25 12:23:44.523456+00	36	iphone
5	Drinks	product-images/water.jpeg	2022-11-08 12:50:58.209449+00	2022-11-30 11:32:08.226773+00	7	drinks
20	Home Theatres & Audio Systems		2022-11-30 12:18:36.689212+00	2022-11-30 12:18:36.689234+00	3	home-theatres-aud
8	Gaming		2022-11-30 12:14:02.891736+00	2022-11-30 12:14:02.891757+00	\N	gaming
41	Greens	category-images/download_2.jpeg	2023-02-02 21:37:14.058833+00	2023-02-02 21:37:14.070108+00	31	green
9	Home and Office Equipment		2022-11-30 12:14:22.193383+00	2022-11-30 12:14:22.193405+00	\N	homes-and-office
21	Cooking Ingredients		2022-11-30 12:19:02.590488+00	2022-11-30 12:19:02.59051+00	7	cooking
42	Some	category-images/Screenshot_20.png	2023-02-08 12:15:05.550444+00	2023-02-08 12:15:05.552814+00	\N	some
22	Home Furnitures		2022-11-30 12:19:43.870345+00	2022-11-30 12:19:43.870366+00	9	funiture
43	Test	category-images/bag_01.jpeg	2023-02-09 08:52:01.224165+00	2023-02-09 08:52:01.226398+00	\N	test
23	Large Appliances		2022-11-30 12:19:57.801403+00	2022-11-30 12:19:57.801425+00	9	large-app
24	Medium Appliances		2022-11-30 12:20:11.779004+00	2022-11-30 12:20:11.779025+00	9	mid-app
26	Big Cars		2022-12-01 12:53:21.042435+00	2022-12-01 12:53:21.042456+00	11	big-car
27	Small Car		2022-12-01 13:07:36.952912+00	2022-12-01 13:07:36.952933+00	11	small-car
\.


--
-- Data for Name: ecommerce_productcategory_brands; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.ecommerce_productcategory_brands (id, productcategory_id, brand_id) FROM stdin;
1	1	1
2	1	2
3	1	3
4	3	4
5	3	5
6	3	6
7	4	4
8	4	5
9	4	6
10	5	12
11	41	1
12	41	6
13	44	1
14	44	6
15	46	1
16	46	6
17	47	1
18	47	2
19	47	6
\.


--
-- Data for Name: ecommerce_productdetail; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.ecommerce_productdetail (id, sku, size, color, weight, length, width, height, stock, price, discount, low_stock_threshold, shipping_days, out_of_stock_date, created_on, updated_on, product_id) FROM stdin;
54			green	0	0	0	0	18	34900.00	24430.00	5	3	\N	2023-01-05 11:19:01.617266+00	2023-01-19 09:40:10.920287+00	50
65	98uf433	medium	green	0	0	0	0	500	129990.00	0.00	5	3	\N	2023-01-29 21:20:17.920503+00	2023-01-29 21:20:17.920514+00	55
61	r3r323k	large	silver	0	0	0	0	395	44000.00	0.00	5	3	\N	2023-01-28 08:31:58.83591+00	2023-03-28 09:30:32.54224+00	54
47			blue	0	0	0	0	17	500000.00	350000.00	5	3	\N	2022-12-30 20:42:21.964886+00	2023-01-17 09:35:25.508602+00	43
49			Blue	0	0	0	0	0	1000.00	0.00	5	3	\N	2023-01-04 12:38:47.914684+00	2023-01-05 14:19:11.229421+00	44
70	uie84tf	large	light sky blue	0	0	0	0	45	560495.00	392346.50	5	3	\N	2023-02-09 21:54:19.968295+00	2023-06-06 21:29:34.14935+00	60
25			Yellow	0	0	0	0	3	115.00	0.00	5	3	\N	2022-12-03 15:25:14.620156+00	2022-12-03 15:25:14.620169+00	26
26			Green	0	0	0	0	3	125.00	0.00	5	3	\N	2022-12-03 15:25:14.622361+00	2022-12-03 15:25:14.622374+00	26
21	MTU12348	M	Green	0.100000000000000006	0.400000000000000022	0.200000000000000011	0.299999999999999989	0	18000.00	0.00	5	3	\N	2022-11-23 13:22:07.141299+00	2022-12-04 17:03:17.341278+00	21
27			Red	0	0	0	0	3	120.00	0.00	5	3	\N	2022-12-07 09:03:01.168292+00	2022-12-07 09:03:01.168303+00	27
28			Orange	0	0	0	0	3	120.00	0.00	5	3	\N	2022-12-07 09:03:01.171079+00	2022-12-07 09:03:01.171091+00	27
29			Blue	0	0	0	0	3	120.00	0.00	5	3	\N	2022-12-07 09:03:01.173302+00	2022-12-07 09:03:01.173314+00	27
71	nfiu44	large	ash	0	0	0	0	34	659444.00	392346.50	5	3	\N	2023-02-09 21:54:19.972958+00	2023-06-06 21:29:34.157128+00	60
57			green	0	0	0	0	99	710000.00	0.00	5	3	\N	2023-01-21 07:06:46.770341+00	2023-06-07 11:59:23.434949+00	52
34	\N	\N	Brown	0	0	0	0	5	4500.00	0.00	5	3	\N	2022-12-09 10:32:19.386413+00	2022-12-13 09:57:32.777247+00	32
35	\N	\N	Orange	0	0	0	0	5	4500.00	0.00	5	3	\N	2022-12-09 10:32:19.389075+00	2022-12-13 09:57:32.778055+00	32
36	\N	\N	Pink	0	0	0	0	5	4500.00	0.00	5	3	\N	2022-12-09 10:32:19.391185+00	2022-12-13 09:57:32.778792+00	32
51			Blue	0	0	0	0	10	10000.00	0.00	5	3	\N	2023-01-05 10:16:28.768882+00	2023-01-05 10:16:28.768893+00	47
38	12	Big	Orange	0	0	0	0	8	3500.00	0.00	4	3	\N	2022-12-13 09:55:42.669366+00	2023-01-07 08:20:18.560366+00	34
43	7654	Big	Black	0	0	0	0	4	12000.00	0.00	2	3	\N	2022-12-13 10:22:38.398921+00	2023-01-11 19:00:06.538906+00	39
41	432	Midi	Red	0	0	0	0	5	75000.00	77000.00	2	3	\N	2022-12-13 10:12:47.963777+00	2022-12-13 10:12:47.96379+00	37
40	567	Big	Brown	0.100000000000000006	0.100000000000000006	0.100000000000000006	0.100000000000000006	5	25000.00	30000.00	2	3	\N	2022-12-13 10:07:01.874819+00	2022-12-20 12:17:23.72326+00	36
56			black	0	0	0	0	98	700000.00	0.00	5	3	\N	2023-01-21 07:06:46.765665+00	2023-06-07 11:59:23.442108+00	52
17	AQW18766	XL	White	30	10	10	30	0	1000.00	10.00	5	3	\N	2022-11-18 14:38:28.021383+00	2023-01-03 10:17:36.520648+00	17
30	1234	12	Red	10	10	10	0	20	10000.00	9000.00	5	3	\N	2022-12-08 09:02:33.399652+00	2022-12-08 10:15:44.288515+00	28
50			Yellow	0	0	0	0	20	10.00	0.00	5	3	\N	2023-01-04 13:25:02.705879+00	2023-01-04 13:25:02.705891+00	45
16	AQW12129i	M	White	9	8	7	10	0	30000.00	40000.00	1	3	\N	2022-11-18 14:36:31.891144+00	2023-01-05 10:33:54.495829+00	16
52			green	0	0	0	0	20	34900.00	0.00	5	3	\N	2023-01-05 10:42:10.432832+00	2023-01-05 10:42:10.432844+00	48
53			green	0	0	0	0	10	34900.00	0.00	5	3	\N	2023-01-05 11:09:09.647838+00	2023-01-05 11:09:09.64785+00	49
32			green	0	0	0	0	20	500000.00	350000.00	5	3	\N	2022-12-08 10:09:34.624321+00	2022-12-08 10:09:34.624333+00	30
18	MTU12345	L	Black	0.100000000000000006	0.400000000000000022	0.200000000000000011	0.299999999999999989	7	20500.00	23500.00	5	3	\N	2022-11-23 13:22:07.141299+00	2023-01-05 14:19:11.238783+00	18
33			Ash	0	0	0	0	297	500000.00	0.00	5	3	\N	2022-12-09 09:31:43.163389+00	2023-01-17 09:35:25.518167+00	31
42	765	Big	Black	0	0	0	0	8	45000.00	0.00	3	3	\N	2022-12-13 10:16:09.29046+00	2023-01-12 22:00:44.244738+00	38
24			Red	0	0	0	0	2	120.00	0.00	5	3	\N	2022-12-03 15:25:14.617345+00	2023-01-12 22:00:44.253885+00	26
39	4567	Big	Black	0.100000000000000006	0.100000000000000006	0.100000000000000006	0.100000000000000006	3	23000.00	25000.00	2	3	\N	2022-12-13 10:04:09.068311+00	2023-01-17 09:44:05.253065+00	35
66	123	Nil	Nil	0	0	0	0	500	1000.00	0.00	5	3	\N	2023-01-30 11:42:02.090256+00	2023-01-30 11:42:02.090267+00	56
19	MTU12346	M	Blue	0.100000000000000006	0.400000000000000022	0.200000000000000011	0.299999999999999989	8	10200.00	0.00	5	3	\N	2022-11-23 13:22:07.141299+00	2023-01-17 09:44:05.27266+00	19
48	1234	L	Black	1	2	1	2	9	20000.00	0.00	5	3	\N	2022-12-31 09:03:02.522837+00	2023-01-17 11:00:23.99198+00	24
63	r3r323k	medium	blue	0	0	0	0	500	209000.00	0.00	5	3	\N	2023-01-29 21:20:17.912131+00	2023-01-29 21:20:17.912142+00	55
64	3u3o23h	medium	sky blue	0	0	0	0	500	129490.00	0.00	5	3	\N	2023-01-29 21:20:17.916648+00	2023-01-29 21:20:17.916659+00	55
23	CHI4567	M	Yello	0.100000000000000006	0.200000000000000011	0.299999999999999989	1	0	1000.00	0.00	5	3	\N	2022-11-29 14:38:28.021+00	2023-02-10 15:38:18.581489+00	23
73	r3r323k	large	navy	0	0	0	0	20	170494.00	0.00	8	3	\N	2023-02-13 11:26:34.170599+00	2023-07-10 14:03:56.356669+00	63
20	MTU12347	M	Yellow	0.100000000000000006	0.400000000000000022	0.200000000000000011	0.299999999999999989	6	5000.00	0.00	5	3	\N	2022-11-23 13:22:07.141299+00	2023-02-12 20:35:35.360171+00	20
37	123456	46	Brown	2	0	0	0	4	45000.00	0.00	2	3	\N	2022-12-13 09:51:40.642688+00	2023-02-13 11:05:33.833685+00	33
67	ASW123	M	black	0	0	0	0	3	21550.00	0.00	5	3	\N	2023-02-07 08:07:38.426854+00	2023-06-07 09:04:47.260377+00	57
58			brown	0	0	0	0	99	30.00	0.00	5	3	\N	2023-01-21 07:06:46.774038+00	2023-06-07 11:59:23.426413+00	52
60			Nil	0	0	0	0	498	500.00	400.00	5	3	\N	2023-01-23 13:56:30.534044+00	2023-03-24 09:28:25.339148+00	53
31	12345	Mini	White	0.5	6	5	3	6	100.00	70.00	5	3	2022-12-08 10:03:10+00	2022-12-08 09:43:28.265696+00	2023-01-07 08:20:18.53283+00	29
62	3u3o23h	extra large	brown	0	0	0	0	400	54000.00	0.00	5	3	\N	2023-01-28 08:31:58.840404+00	2023-01-28 08:31:58.840415+00	54
46	i675436	Nil	Nil	0	0	0	0	95	500.00	0.00	500	3	\N	2022-12-13 10:35:32.460739+00	2023-01-16 11:59:34.608977+00	42
44	876	Nil	White wine	0	0	0	0	97	5000.00	0.00	20	3	\N	2022-12-13 10:30:35.684782+00	2023-03-24 09:28:25.351184+00	40
22	MTU12349	M	Black	0.100000000000000006	0.400000000000000022	0.200000000000000011	0.299999999999999989	5	72000.00	4000.00	5	3	\N	2022-11-23 13:22:07.141299+00	2023-03-24 09:28:25.362427+00	22
45	987	Nil	Red	0	0	0	0	98	4500.00	0.00	20	3	\N	2022-12-13 10:32:14.35936+00	2023-03-24 09:28:25.374075+00	41
72	8iurjjfj	large	blonde	0	0	0	0	65	469000.00	392346.50	5	3	\N	2023-02-09 21:54:19.976761+00	2023-06-06 21:29:34.138361+00	60
74	testSKU	M	Red	0.100000000000000006	0.599999999999999978	0.299999999999999989	0	4	25000.00	0.00	2	3	\N	2023-10-19 11:04:22.0969+00	2023-10-19 11:04:22.096916+00	66
75	testSKU	M	Red	0.100000000000000006	0.599999999999999978	0.299999999999999989	0	4	25000.00	0.00	2	3	\N	2023-10-19 12:11:10.993507+00	2023-10-19 12:11:10.993524+00	66
76	testSKU	M	Red	0.100000000000000006	0.599999999999999978	0.299999999999999989	0	4	25000.00	0.00	2	3	\N	2023-10-19 12:43:09.362166+00	2023-10-19 12:43:09.362182+00	66
77	testSKU	M	Red	0.100000000000000006	0.599999999999999978	0.299999999999999989	0	4	25000.00	0.00	2	3	\N	2023-10-19 12:45:51.827362+00	2023-10-19 12:45:51.827378+00	67
78	testSKU	M	Red	0.100000000000000006	0.599999999999999978	0.299999999999999989	0	4	25000.00	0.00	2	3	\N	2023-10-19 12:46:53.960639+00	2023-10-19 12:46:53.960655+00	67
79	testSKU	M	Red	0.100000000000000006	0.599999999999999978	0.299999999999999989	0	4	25000.00	0.00	2	3	\N	2023-10-19 12:47:45.317606+00	2023-10-19 12:47:45.317622+00	68
80	testSKU	M	Red	0.100000000000000006	0.599999999999999978	0.299999999999999989	0	4	25000.00	0.00	2	3	\N	2023-10-19 12:48:12.751832+00	2023-10-19 12:48:12.751847+00	68
81	testSKU	M	Red	0.100000000000000006	0.599999999999999978	0.299999999999999989	0	4	25000.00	0.00	2	3	\N	2023-10-19 12:48:36.297232+00	2023-10-19 12:48:36.297251+00	68
82	testSKU	M	Red	0.100000000000000006	0.599999999999999978	0.299999999999999989	0	4	25000.00	0.00	2	3	\N	2023-10-19 12:52:38.706057+00	2023-10-19 12:52:38.706073+00	68
83	testSKU	M	Red	0.100000000000000006	0.599999999999999978	0.299999999999999989	0	4	25000.00	0.00	2	3	\N	2023-10-19 13:15:15.183614+00	2023-10-19 13:15:15.183632+00	66
84	testSKU	M	Red	0.100000000000000006	0.599999999999999978	0.299999999999999989	0	4	25000.00	0.00	2	3	\N	2023-10-19 13:15:24.656494+00	2023-10-19 13:15:24.65651+00	66
85	testSKU	M	Red	0.100000000000000006	0.599999999999999978	0.299999999999999989	0	4	25000.00	0.00	2	3	\N	2023-10-19 13:17:35.571031+00	2023-10-19 13:17:35.571047+00	68
86	testSKU	M	Red	0.100000000000000006	0.599999999999999978	0.299999999999999989	0	4	25000.00	0.00	2	3	\N	2023-10-20 08:46:08.010811+00	2023-10-20 08:46:08.010823+00	68
87	dansock	L	purple	0.299999999999999989	1.30000000000000004	1.10000000000000009	3.5	70	4000.00	10.00	30	3	\N	2023-10-23 11:24:23.751755+00	2023-10-23 11:24:23.751768+00	69
\.


--
-- Data for Name: ecommerce_productimage; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.ecommerce_productimage (id, created_on, updated_on, product_detail_id, image_id) FROM stdin;
1	2023-01-05 11:19:01.620508+00	2023-01-05 11:19:01.620523+00	54	127
5	2023-01-23 13:56:30.537359+00	2023-01-23 13:56:30.537373+00	60	181
6	2023-01-28 08:31:58.839066+00	2023-01-28 08:31:58.839079+00	61	205
7	2023-01-28 08:31:58.842861+00	2023-01-28 08:31:58.842874+00	62	206
8	2023-01-29 21:20:17.915362+00	2023-01-29 21:20:17.915376+00	63	209
9	2023-01-29 21:20:17.919188+00	2023-01-29 21:20:17.919202+00	64	210
10	2023-01-29 21:20:17.923078+00	2023-01-29 21:20:17.923091+00	65	211
11	2023-01-30 11:42:02.093487+00	2023-01-30 11:42:02.0935+00	66	215
18	2023-06-06 21:29:34.144993+00	2023-06-06 21:29:34.145012+00	72	240
19	2023-06-06 21:29:34.154723+00	2023-06-06 21:29:34.154741+00	70	235
20	2023-06-06 21:29:34.162329+00	2023-06-06 21:29:34.162347+00	71	237
22	2023-06-07 09:04:47.264715+00	2023-06-07 09:04:47.264733+00	67	270
23	2023-06-07 11:59:23.432243+00	2023-06-07 11:59:23.432261+00	58	174
24	2023-06-07 11:59:23.439749+00	2023-06-07 11:59:23.439766+00	57	173
25	2023-06-07 11:59:23.447211+00	2023-06-07 11:59:23.447231+00	56	172
\.


--
-- Data for Name: ecommerce_productreview; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.ecommerce_productreview (id, rating, headline, review, created_on, product_id, user_id) FROM stdin;
2	4	Good Product	This product is good	2022-11-23 13:22:07.142029+00	18	26
\.


--
-- Data for Name: ecommerce_producttype; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.ecommerce_producttype (id, name, image, percentage_commission, fixed_commission, commission_applicable, category_id, slug) FROM stdin;
14	Cabbage		0.00	0.00	t	41	Cabbage-54e222b514
15	dcxcvsvsdv		0.00	0.00	t	37	dcxcvsvsdv-1522fea215
11	Wine		0.00	0.00	t	7	wine
10	Others		0.00	0.00	t	15	others
9	Dresses		0.00	0.00	t	30	dresses
8	Cup		0.00	0.00	t	29	cup
7	Car		0.00	0.00	t	28	car
6	Juice	product-type-images/chivita.jpeg	4.00	3.00	t	5	juice
5	Gadgets		0.00	100.00	t	6	gadgets
4	Android	product-type-images/andriod.png	2.10	1.80	t	37	android
3	T-shirt		1.20	0.00	t	2	t-shirt
2	Laptop	product-type-images/apple-laptop.jpeg	2.30	100.00	t	24	laptop
1	Jacket		0.00	100.00	t	2	jacket
12	Simbian		0.00	0.00	t	37	sinbian
13	Lettuce		0.00	0.00	t	41	lettuce
\.


--
-- Data for Name: ecommerce_productwishlist; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.ecommerce_productwishlist (id, created_on, product_id, user_id) FROM stdin;
2	2022-11-27 00:39:06.261647+00	18	37
3	2022-11-27 00:39:09.937039+00	17	37
4	2022-11-28 10:17:23.462537+00	16	37
5	2022-11-29 16:00:21.275424+00	18	26
12	2022-11-30 21:14:13.358066+00	23	38
13	2022-11-30 21:14:17.619133+00	17	38
15	2022-12-05 09:47:15.405957+00	26	53
16	2022-12-05 13:11:19.311768+00	24	57
17	2022-12-07 11:10:14.069335+00	16	53
18	2022-12-07 11:11:48.375362+00	17	53
19	2022-12-07 13:17:39.385992+00	26	38
21	2022-12-07 13:36:42.03472+00	20	38
22	2022-12-07 13:36:57.964664+00	18	38
23	2022-12-07 17:49:28.477154+00	16	38
24	2022-12-09 09:37:57.51918+00	31	38
25	2022-12-14 21:50:44.451166+00	42	38
26	2022-12-15 11:52:38.788304+00	41	60
37	2022-12-16 15:53:42.992419+00	38	35
38	2022-12-19 14:42:07.32105+00	39	37
39	2022-12-19 15:45:52.511409+00	37	37
40	2022-12-21 07:43:43.784601+00	23	37
41	2022-12-21 07:43:54.33127+00	22	37
42	2022-12-21 07:44:11.879662+00	23	53
43	2022-12-21 07:44:14.680678+00	18	53
44	2022-12-21 07:45:18.532286+00	38	37
46	2023-01-11 09:52:33.208495+00	33	68
47	2023-01-11 22:11:04.491204+00	29	38
48	2023-01-11 22:11:08.909458+00	40	38
49	2023-01-14 20:26:34.392145+00	27	38
50	2023-01-24 08:38:47.210955+00	52	38
51	2023-02-13 08:39:54.228187+00	22	35
52	2023-06-06 22:12:06.641182+00	60	38
53	2023-06-06 22:13:53.874837+00	38	38
54	2023-06-06 22:13:59.803716+00	45	38
55	2023-06-06 22:14:20.073456+00	54	38
56	2023-06-06 22:18:53.062635+00	36	38
\.


--
-- Data for Name: ecommerce_promo; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.ecommerce_promo (id, title, amount_discount, discount_type, promo_type, details, banner_image, status, created_on, updated_on, "position", fixed_price, percentage_discount, slug) FROM stdin;
45	Test 3232	0.00	percentage	deal	\N	promo-banners/wp9384511-4k-apple-mac-wallpapers_LrRFtBx.jpeg	active	2023-02-20 15:44:43.734737+00	2023-02-20 16:35:16.479398+00	big_deal	\N	20.00	promo-slug22
32	Banner 2	700000.00	fixed	banner	\N	promo-banners/Rectangle_1482_oYNaL7y.png	active	2023-02-13 23:58:38.623876+00	2023-02-13 23:58:38.630727+00	big_banner	0.00	0.00	promo-slug1
31	Med 2	50000.00	fixed	deal	\N	promo-banners/download_1.jpeg	active	2023-02-13 18:44:48.027841+00	2023-02-13 18:44:48.034621+00	medium_deal	0.00	0.00	promo-slug14
46	Valentine specials	0.00	fixed	promo	\N	promo-banners/wp9384511-4k-apple-mac-wallpapers_h25P3RL.jpeg	active	2023-02-20 18:52:48.994217+00	2023-02-20 18:52:49.017826+00	big_deal	4000.00	0.00	promo-slug23
47	Valentine Special	0.00	percentage	deal	\N	promo-banners/istockphoto-1124657162-612x612.jpeg	active	2023-02-21 02:07:04.833332+00	2023-02-21 02:07:04.905582+00	big_deal	\N	30.00	promo-slug24
23	yt7	710000.00	fixed	deal	\N	promo-banners/Rectangle_1413_6qo0jcU.png	active	2023-02-13 14:08:16.57712+00	2023-02-13 14:08:16.578816+00	\N	0.00	0.00	promo-slug8
35	Banner small 2	20000.00	fixed	banner	\N	promo-banners/378x252-copy-10.png_eT1s3s8.png	active	2023-02-14 00:38:39.209089+00	2023-02-14 00:38:39.21532+00	small_banner	0.00	0.00	promo-slug15
48	Test Wednesday	0.00	percentage	banner	\N	promo-banners/low_size_banner_3.jpeg	active	2023-02-22 10:23:29.213879+00	2023-02-22 10:23:29.236802+00	footer_banner	\N	10.00	promo-slug25
36	Banner medium 2	70000.00	fixed	banner	\N	promo-banners/Group_100_W6V5vzg.png	active	2023-02-14 00:43:18.061243+00	2023-02-14 00:43:18.067552+00	medium_banner	0.00	0.00	promo-slug16
25	test435	710000.00	fixed	banner	\N	promo-banners/Rectangle_1413_YoQeHp5.png	active	2023-02-13 15:01:30.455788+00	2023-02-13 15:01:30.467847+00	footer_banner	0.00	0.00	promo-slug9
49	Test wed 2	0.00	percentage	deal	\N	promo-banners/banner_3.jpeg	active	2023-02-22 10:34:24.241588+00	2023-02-22 10:34:24.267105+00	medium_deal	\N	20.00	promo-slug26
33	Banner medium 1	199999.00	fixed	banner	\N	promo-banners/mattress-store-banners.webp	active	2023-02-14 00:07:16.913688+00	2023-02-14 00:07:16.920441+00	medium_banner	0.00	0.00	promo-slug2
37	footer 2	10000.00	fixed	banner	\N	promo-banners/eni_wealth.png	active	2023-02-14 01:04:52.048912+00	2023-02-14 01:04:52.057492+00	footer_banner	0.00	0.00	promo-slug17
27	Deal 1	100000.00	fixed	deal	\N	promo-banners/Rectangle_1482.png	active	2023-02-13 17:38:58.108286+00	2023-02-13 17:38:58.125254+00	big_deal	0.00	0.00	promo-slug10
28	Books	599998.00	fixed	deal	\N	promo-banners/Rectangle_1482_MgChSAy.png	active	2023-02-13 18:15:51.824778+00	2023-02-13 18:15:51.846819+00	medium_deal	0.00	0.00	promo-slug11
38	Small Banner	59997.00	fixed	deal	\N	promo-banners/markus-spiske-WIpNUhklTQg-unsplash_1.png	active	2023-02-14 09:08:03.938849+00	2023-02-14 09:08:03.946042+00	medium_deal	0.00	0.00	promo-slug18
39	Test banner	1000.00	fixed	deal	\N	promo-banners/WhatsApp_Image_2023-02-14_at_9.59.19_AM.jpeg	active	2023-02-14 09:10:30.772001+00	2023-02-14 09:10:30.782865+00	big_deal	0.00	0.00	promo-slug19
40	Banner me	0.00	percentage	undefined	\N	promo-banners/cardmapr-nl-pwxESDWRwDE-unsplash.png	active	2023-02-18 18:36:24.253363+00	2023-02-18 18:36:24.273718+00	big_banner	\N	20.00	promo-slug20
29	Deal 22	200000.00	fixed	deal	\N	promo-banners/Rectangle_1482_7U4oAjw.png	active	2023-02-13 18:27:50.954398+00	2023-02-13 18:27:50.961708+00	big_deal	0.00	0.00	promo-slug12
30	heade 2	1000.00	fixed	banner	\N	promo-banners/Rectangle_1413_Gf8D89z.png	active	2023-02-13 18:33:10.33249+00	2023-02-13 18:33:10.346338+00	header_banner	0.00	0.00	promo-slug13
34	Banner small 1	40000.00	fixed	banner	\N	promo-banners/378x252-copy-10.png.png	active	2023-02-14 00:10:08.091518+00	2023-02-14 00:10:08.098249+00	small_banner	0.00	0.00	promo-slug3
19	TestingBanner	1000.00	fixed	banner		promo-banners/banner_low_size_1_kw4lZxY.png	active	2023-02-13 12:40:49.12637+00	2023-02-13 12:55:46.231393+00	big_banner	0.00	0.00	promo-slug4
20	Range Deal	0.00	fixed	deal	\N	promo-banners/banner_low_size_1_X8zaJVc.png	active	2023-02-13 13:01:01.163587+00	2023-02-13 13:01:01.173713+00	\N	0.00	0.00	promo-slug5
41	Banner Me ME	0.00	percentage	banner	\N	promo-banners/cardmapr-nl-pwxESDWRwDE-unsplash_YRyZJAz.png	active	2023-02-18 19:05:33.172924+00	2023-02-18 19:05:33.196125+00	medium_banner	\N	10.00	promo-slug21
21	Banner New	0.00	fixed	banner	\N	promo-banners/banner_low_size_1_f1MOLnb.png	active	2023-02-13 13:23:35.566729+00	2023-02-13 13:23:35.57654+00	\N	0.00	0.00	promo-slug6
22	TEst 20	730000.00	fixed	deal	\N	promo-banners/Rectangle_1413.png	active	2023-02-13 14:05:08.104327+00	2023-02-13 14:05:08.106434+00	\N	0.00	0.00	promo-slug7
\.


--
-- Data for Name: ecommerce_promo_category; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.ecommerce_promo_category (id, promo_id, productcategory_id) FROM stdin;
15	40	9
16	41	1
17	41	9
39	45	9
40	45	7
41	46	3
42	46	45
43	46	31
44	46	9
45	47	7
46	47	13
47	47	11
48	47	9
49	48	11
50	48	1
51	49	9
\.


--
-- Data for Name: ecommerce_promo_merchant; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.ecommerce_promo_merchant (id, promo_id, seller_id) FROM stdin;
16	40	30
17	40	32
18	40	29
19	41	31
20	41	32
48	45	31
49	45	32
50	49	11
\.


--
-- Data for Name: ecommerce_promo_product; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.ecommerce_promo_product (id, promo_id, product_id) FROM stdin;
123	20	40
124	20	41
125	20	42
126	21	40
127	21	41
128	21	42
129	25	52
130	25	55
131	25	60
138	27	29
139	27	26
140	27	22
141	27	17
142	27	16
145	28	16
146	28	17
147	28	18
148	28	19
149	28	20
150	28	26
151	29	55
152	30	36
153	31	54
154	32	52
155	33	55
156	34	54
157	35	38
158	36	31
159	37	39
160	37	38
161	38	50
162	39	42
163	39	41
164	39	40
165	40	60
166	41	28
167	41	60
188	45	60
189	45	53
190	46	22
191	46	53
192	46	60
193	47	60
194	47	53
195	47	50
196	47	43
197	47	30
198	47	29
199	48	28
200	49	53
\.


--
-- Data for Name: ecommerce_promo_product_type; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.ecommerce_promo_product_type (id, promo_id, producttype_id) FROM stdin;
1	47	10
2	47	8
3	47	7
4	47	6
5	47	2
6	48	9
7	49	8
\.


--
-- Data for Name: ecommerce_promo_sub_category; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.ecommerce_promo_sub_category (id, promo_id, productcategory_id) FROM stdin;
9	47	26
10	47	24
11	47	23
12	47	22
13	47	21
14	47	16
15	47	15
16	47	5
17	47	14
18	47	29
19	47	28
20	47	27
21	48	30
22	49	29
23	49	24
\.


--
-- Data for Name: ecommerce_returnedproduct; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.ecommerce_returnedproduct (id, status, payment_status, comment, created_on, updated_on, product_id, reason_id, returned_by_id, updated_by_id) FROM stdin;
1	approved	rejected	I dont like this product	2022-12-01 15:19:30.655212+00	2022-12-01 15:19:30.655239+00	2	\N	26	38
\.


--
-- Data for Name: ecommerce_returnproductimage; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.ecommerce_returnproductimage (id, is_primary, return_product_id, image) FROM stdin;
\.


--
-- Data for Name: ecommerce_returnreason; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.ecommerce_returnreason (id, reason) FROM stdin;
1	Item does not match description
2	I received a damaged item
3	Item is not functioning (Gadgets)
4	Item is different from my order
5	Others
\.


--
-- Data for Name: ecommerce_shipper; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.ecommerce_shipper (id, name, description, slug, vat_fee, is_active, created_on, updated_on) FROM stdin;
\.


--
-- Data for Name: generic_custom_shipper_endpoints; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.generic_custom_shipper_endpoints (endpoints_key, label, generic_custom_shipper_id, url) FROM stdin;
0	0	4	
1	1	4	
2	2	4	
3	3	4	
\.


--
-- Data for Name: merchant_bankaccount; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.merchant_bankaccount (id, bank_name, account_name, account_number, seller_id, bank_code) FROM stdin;
2	Sterling bank	Nwachukwu Wisdom	2114616054	8	044
5	FCMB Bank	THADDEUS UGOCHUKWU ALAWUBA	1774691015	11	214
9	FCMB Bank	THADDEUS UGOCHUKWU ALAWUBA	1774691015	15	214
10	FCMB Bank	THADDEUS UGOCHUKWU ALAWUBA	1774691015	16	214
20	FCMB Bank	THADDEUS UGOCHUKWU ALAWUBA	1774691015	27	214
21	FCMB Bank	THADDEUS UGOCHUKWU ALAWUBA	1774691015	28	214
22	FCMB Bank	THADDEUS UGOCHUKWU ALAWUBA	1774691015	29	214
23	FCMB Bank	THADDEUS UGOCHUKWU ALAWUBA	1774691015	30	214
24	FCMB Bank	THADDEUS UGOCHUKWU ALAWUBA	1774691015	31	214
25	FCMB Bank	THADDEUS UGOCHUKWU ALAWUBA	1774691015	32	214
26		THADDEUS UGOCHUKWU ALAWUBA	1774691015	33	214
27	FCMB Bank	THADDEUS UGOCHUKWU ALAWUBA	1774691015	34	214
28	FCMB Bank	THADDEUS UGOCHUKWU ALAWUBA	1774691015	35	214
\.


--
-- Data for Name: merchant_bulkuploadfile; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.merchant_bulkuploadfile (id, file, used, errors, optimized_file) FROM stdin;
1	bulk-upload/bulk-product-upload-sample.csv	t	['Product Name: Arsenal Jersey - ProductCategory matching query does not exist.']	\N
2	bulk-upload/bulk-product-upload-sample_hlBohv1.csv	t	['Product Name: Arsenal Jersey - ProductCategory matching query does not exist.']	\N
3	bulk-upload/bulk-product-upload-sample_x6IpwLW.csv	t	['Product Name: Arsenal Jersey - ProductCategory matching query does not exist.']	\N
4	bulk-upload/bulk-product-upload-sample_biGCSTH.csv	t	['Product Name: Arsenal Jersey - ProductCategory matching query does not exist.']	\N
5	bulk-upload/bulk-product-upload-sample_vUzgADW.csv	t	['Product Name: Arsenal Jersey - ProductCategory matching query does not exist.']	\N
6	bulk-upload/bulk-product-upload-sample_ALCMkub.csv	t	['Product Name: Arsenal Jersey - ProductCategory matching query does not exist.']	\N
7	bulk-upload/bulk-product-upload-sample_OlgQB0f.csv	t	['Product Name: Arsenal Jersey - ProductCategory matching query does not exist.']	\N
8	bulk-upload/bulk-product-upload-sample_4uaCa4u.csv	t	['Product Name: Arsenal Jersey - ProductCategory matching query does not exist.']	\N
9	bulk-upload/bulk-product-upload-sample_I05lnzt.csv	t	['Product Name: Arsenal Jersey - ProductCategory matching query does not exist.']	\N
10	bulk-upload/bulk-product-upload-sample_fyQE0zH.csv	t	['Product Name: Arsenal Jersey - Store matching query does not exist.']	\N
11	bulk-upload/bulk-product-upload-sample_wG90gE8.csv	t	['Product Name: Arsenal Jersey - Store matching query does not exist.']	\N
12	bulk-upload/bulk-product-upload-sample_fBOKIKR.csv	t	['Product Name: Arsenal Jersey - Store matching query does not exist.']	\N
13	bulk-upload/bulk-product-upload-sample_BZOZt4m.csv	t	['Product Name: Arsenal Jersey - Store matching query does not exist.']	\N
14	bulk-upload/bulk-product-upload-sample_ZVDbeya.csv	t	[]	\N
15	bulk-upload/bulk-product-upload-sample2.csv	t	[]	\N
16	bulk-upload/bulk-product-upload-sample_uHSVCnB.csv	t	["Product Name: Arsenal Jersey - Field 'id' expected a number but got ''."]	\N
17	bulk-upload/bulk-product-upload-sample2_JBIRYfs.csv	t	[]	\N
18	bulk-upload/bulk-product-upload-sample2_xcO1CJF.csv	t	[]	\N
19	bulk-upload/bulk-product-upload-sample2_maYHxhE.csv	t	[]	\N
20	bulk-upload/bulk-product-upload-sample2_twbK9nw.csv	t	[]	\N
21	bulk-upload/bulk-product-upload-sample2_kM7cXo4.csv	t	[]	\N
22	bulk-upload/bulk-product-upload-sample2_bAOAC2W.csv	t	[]	\N
23	bulk-upload/bulk-product-upload-sample2_M4sAH7h.csv	t	[]	\N
24	bulk-upload/bulk-product-upload-sample_bRwVOBL.csv	t	[]	\N
25	bulk-upload/bulk-product-upload-sample_XTnjM70.csv	t	[]	\N
26	bulk-upload/bulk-product-upload-sample2_pXZb3oT.csv	t	[]	\N
27	bulk-upload/Bulk_Products_Upload_template.csv	t	['Product Name: Daniel - list index out of range']	\N
28	bulk-upload/Bulk_Products_Upload_template_0FFOZaY.csv	t	['Product Name: Daniel - list index out of range']	\N
29	bulk-upload/Bulk_Products_Upload_template_6gAudiZ.csv	t	['Product Name: Daniel - list index out of range']	\N
30	bulk-upload/Bulk_Products_Upload_template_rmR7VGR.csv	t	['Product Name: Daniel - list index out of range']	\N
31	bulk-upload/Bulk_Products_Upload_template_0DJMdGI.csv	t	['Product Name: Daniel - list index out of range']	\N
32	bulk-upload/Bulk_Products_Upload_template_P21GVDP.csv	t	['Product Name: Daniel - list index out of range']	\N
33	bulk-upload/Bulk_Products_Upload_template_cNBscCD.csv	t	['Product Name: Danit - list index out of range']	\N
34	bulk-upload/Bulk_Products_Upload_template_tyysNMV.csv	t	['Product Name: Danit - list index out of range']	\N
35	bulk-upload/Bulk_Products_Upload_template_lmSIkE6.csv	t	['Product Name: Danit - list index out of range']	\N
36	bulk-upload/Bulk_Products_Upload_template_g69IAZK.csv	t	['Product Name: Danit - list index out of range']	\N
37	bulk-upload/bulk-product-upload-sample2_iTwJ9rv.csv	t	[]	\N
38	bulk-upload/Bulk_Products_Upload_template_1.csv	t	['Product Name: Daniel - list index out of range']	\N
39	bulk-upload/Bulk_Products_Upload_template_1_FoC1tdB.csv	t	['Product Name: Daniel - list index out of range']	\N
40	bulk-upload/Bulk_Products_Upload_template_1_z5jAv2v.csv	f	\N	\N
41	bulk-upload/Bulk_Products_Upload_template_1_wLFlity.csv	t	['Product Name: Daniel - ProductType matching query does not exist.']	\N
42	bulk-upload/Bulk_Products_Upload_template_1_EGMjghd.csv	t	['Product Name: Daniel - ProductType matching query does not exist.']	\N
43	bulk-upload/Bulk_Products_Upload_template_1_hZNHWLL.csv	t	['Product Name: Daniel - Brand matching query does not exist.']	\N
44	bulk-upload/Bulk_Products_Upload_template_1_PPBVobQ.csv	t	[]	\N
\.


--
-- Data for Name: merchant_director; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.merchant_director (id, name, phone_number, address) FROM stdin;
\.


--
-- Data for Name: merchant_merchantbanner; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.merchant_merchantbanner (id, banner_image, is_active, created_on, updated_on, seller_id) FROM stdin;
10	promo-banners/Group_95_CzKoOj0.png	f	2023-03-04 12:25:06.719818+00	2023-03-04 12:25:06.71984+00	7
11	promo-banners/markus-spiske-WIpNUhklTQg-unsplash_1_6rWAEn9.png	f	2023-03-04 12:40:06.920684+00	2023-03-04 12:40:06.920707+00	11
\.


--
-- Data for Name: merchant_seller; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.merchant_seller (id, phone_number, address, profile_picture, status, created_on, updated_on, user_id, city, state, town, latitude, longitude, biller_code, feel, fep_type, merchant_id, town_id, approved_by_id, checked_by_id) FROM stdin;
27	2348085820883	71 Community Road, Akoka		active	2022-12-30 20:53:19.47123+00	2022-12-31 19:01:11.231462+00	68	LAGOS ISLAND	LAGOS	NAFORIJA	0	0	98767	45.2	rate	3UP1LA000000169	\N	53	\N
15	2349033207487	7, Idowu Taylor Str		active	2022-12-30 08:11:32.486774+00	2022-12-30 14:36:49.36033+00	64	LAGOS ISLAND	LAGOS	LEKKI TOWN	0	0	89293	12	rate	2057RI000003728	\N	53	\N
29	2347087990595	12 Mainstreet 		active	2023-01-03 08:59:04.758607+00	2023-01-03 09:09:12.582678+00	71	LAGOS MAINLAND	LAGOS	OSHODI	0	0	700	200	rate	3UP1LA000000169	\N	53	\N
30	2349033207487	Plot 688		active	2023-01-05 16:36:09.481993+00	2023-01-05 18:04:21.149272+00	72	ABUJA	ABUJA	WUSE ZONE II	0	0	444444	666666	rate	3UP1LA000000169	\N	53	\N
31	2348090641563	71 Community Road, Lagos		active	2023-01-06 09:59:57.641508+00	2023-01-06 10:49:50.541651+00	74	LAGOS MAINLAND	LAGOS	AKUTE	0	0	9876546	34576	rate	3UP1LA000000169	\N	53	\N
33	2340999999999	29, Berkley street Off King George road, Onikan Lagos		active	2023-01-07 08:08:25.228907+00	2023-01-07 08:10:01.589812+00	75	LAGOS ISLAND	LAGOS	LAGOS ISLAND	0	0	6565656	545454	rate	3UP1LA000000169	\N	53	\N
35	2347051673435	Idowu Taylor street		pending	2023-01-20 13:11:07.373081+00	2023-01-20 13:11:07.373122+00	80	LAGOS ISLAND	LAGOS	VICTORIA ISLAND	0	0	\N	\N	flat	\N	\N	\N	\N
32	2347087990595	29 Berkley Street off King George road Onikan Lagos		active	2023-01-06 14:36:43.071293+00	2023-01-21 13:23:23.199801+00	73	LAGOS ISLAND	LAGOS	ONIKAN	0	0	975786	767578	rate	3UP1LA000000169	\N	53	\N
16	2348117575388	3, Idowu Taylor		active	2022-12-30 08:13:26.858936+00	2023-01-21 13:23:29.273251+00	62	LAGOS ISLAND	LAGOS	VICTORIA ISLAND	0	0	999666	1.25	rate	3UP1LA000000169	\N	53	\N
7	08105700750	17 Anthony Obe Street	seller-profile-picture/payarena_logo.jpeg	active	2022-11-23 12:17:32.32455+00	2023-10-06 10:16:33.712485+00	38	LAGOS MAINLAND	LAGOS	MAFOLUKU	6.56907529999999973	3.33328960000000007	\N	\N	flat	KGB34576789	4295	\N	\N
11	234 8136812997	71 Community Road, Lagos		active	2022-12-29 12:09:29.774568+00	2023-01-21 13:30:42.42019+00	37	LAGOS MAINLAND	LAGOS	YABA	0	0	89832	12	rate	3UP1LA000000169	\N	53	\N
8	08057784797	Ayeteju, Ibeju-Lekki, Lagos State	seller-profile-picture/channel.png	active	2022-11-29 13:58:53.826045+00	2023-01-21 13:30:47.196743+00	47	Lagos Island	Lagos	Ajah	32.4200000000000017	21.3399999999999999	34378	12	rate	3UP1LA000000169	32	53	\N
28	2346066666666	24, Alhaja Zainab Street, Osaro Akute. Ogun state		inactive	2022-12-31 08:24:36.929592+00	2023-01-27 10:24:21.53411+00	70	SANGO OTA	OGUN	IFO\t\t	0	0	141414	2.22	rate	3UP1LA000000169	\N	53	\N
2	+2348077665554	ajah, lagos, Nigeria	seller-profile-picture/Screenshot_from_2022-09-03_20-16-41.png	declined	2022-10-10 09:48:53.918128+00	2023-02-06 10:43:06.634254+00	33	\N	\N	\N	\N	\N	\N	\N	flat	KGB89786754	32	\N	\N
6	2349021345678	address, lagos		active	2022-11-18 13:24:36.138752+00	2023-02-07 08:05:58.030804+00	26	ajah	lagos	ajah	132.430000000000007	213.300000000000011	\N	\N	flat	KGB30987654	32	\N	\N
34	2347087990595	71 Community Road		pending	2023-01-09 11:07:25.970041+00	2023-09-27 17:31:48.248387+00	76	LAGOS MAINLAND	LAGOS	AKOKA	6.5249113000000003	3.39363999999999999	3570	20	rate	3UP1LA000000169	\N	55	\N
\.


--
-- Data for Name: merchant_seller_follower; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.merchant_seller_follower (id, seller_id, user_id) FROM stdin;
\.


--
-- Data for Name: merchant_sellerdetail; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.merchant_sellerdetail (id, company_name, business_address, business_state, business_city, business_drop_off_address, business_type, market_size, number_of_outlets, maximum_price_range, id_card, id_card_verified, cac_number, cac_verified, verified, created_on, updated_on, seller_id, director_id, company_type, company_tin_number, tin_verified) FROM stdin;
2	Company name	\N	\N	\N	\N	registered-individual-business	21	3	230000.00		f	1234567890	f	f	2022-11-18	2022-11-18	6	\N	sole-proprietorship	45678911	f
3	Eni Wealth	Lagos	Lagos	Iyana Ipaja	Lagos	registered-individual-business	10	2	20000.00		t	RC1234567456	t	t	2022-11-23	2022-11-23	7	\N	sole-proprietorship	TIN3456789234	t
4	Channel	Kekere, Ajah, Lagos State	Lagos State	Ajah	Ajah, Lagos State	registered-individual-business	100	20	10000000.00	seller-verification/WhatsApp_Image_2022-07-24_at_4.55.24_PM_jj7cFng.jpeg	t	v87o8v79p9i	t	t	2022-11-29	2022-11-29	8	\N	sole-proprietorship	gctycuhj	t
5	Ei Store	Lagos	Lagos	Lagos	Lagos	registered-individual-business	10	2	10000.00	seller-verification/payarena_logo.jpeg	t	1234567	t	t	2022-11-30	2022-11-30	2	\N	sole-proprietorship	TIN123456u78	t
8	\N	71 Community Road, Lagos	LAGOS	LAGOS MAINLAND	\N	unregistered-individual-business	345	76	2345678.00		f	\N	f	f	2022-12-29	2022-12-29	11	\N	\N	\N	f
12	\N	7, Idowu Taylor Str	LAGOS	LAGOS ISLAND	\N	registered-individual-business	200	25	5000.00		f	\N	f	f	2022-12-30	2022-12-30	15	\N	\N	\N	f
13	\N	3, Idowu Taylor	LAGOS	LAGOS ISLAND	\N	unregistered-individual-business	1	2	30000.00		f	\N	f	f	2022-12-30	2022-12-30	16	\N	\N	\N	f
23	Dmi Ent.	71 Community Road, Akoka	LAGOS	LAGOS ISLAND	\N	unregistered-individual-business	65789	67890	87907.00		f	\N	f	f	2022-12-30	2022-12-30	27	\N	\N	\N	f
24	Feyz	24, Alhaja Zainab Street, Osaro Akute. Ogun state	OGUN	SANGO OTA	\N	registered-individual-business	1	1	1000000.00		f	1234	f	f	2022-12-31	2022-12-31	28	\N	sole-proprietorship	12345	f
25	\N	12 Mainstreet 	LAGOS	LAGOS MAINLAND	\N	registered-individual-business	2333	555	700.00		f	\N	f	f	2023-01-03	2023-01-03	29	\N	\N	\N	f
26	\N	Plot 688	ABUJA	ABUJA	\N	registered-individual-business	55	5	234.00		f	\N	f	f	2023-01-05	2023-01-05	30	\N	\N	\N	f
27	Thomiwa Entreprises	71 Community Road, Lagos	LAGOS	LAGOS MAINLAND	\N	unregistered-individual-business	7890342	3	7890930.00		f	\N	f	f	2023-01-06	2023-01-06	31	\N	\N	\N	f
28	\N	29 Berkley Street off King George road Onikan Lagos	LAGOS	LAGOS ISLAND	\N	limited-liability-company	40	10	200.00		f	\N	f	f	2023-01-06	2023-01-06	32	\N	\N	\N	f
29	Tommm fashion	29, Berkley street Off King George road, Onikan Lagos	LAGOS	LAGOS ISLAND	\N	registered-individual-business	1	2	10000000.00		f	435643	f	f	2023-01-07	2023-01-07	33	\N	partnership	7564576	f
30	\N	29 Berkley Street off King George road Onikan Lagos	LAGOS	LAGOS ISLAND	\N	registered-individual-business	400	20	40.00		f	\N	f	f	2023-01-09	2023-01-09	34	\N	\N	\N	f
31	Tobi Enterprise	Idowu Taylor street	LAGOS	LAGOS ISLAND	\N	unregistered-individual-business	1	1	1000000.00		f	\N	f	f	2023-01-20	2023-01-20	35	\N	\N	\N	f
\.


--
-- Data for Name: merchant_sellerfile; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.merchant_sellerfile (id, file, created_on, updated_on, seller_id) FROM stdin;
1	seller-files/WhatsApp_Image_2022-07-24_at_4.55.24_PM.jpeg	2022-10-10 09:49:58.539362+00	2022-10-10 09:49:58.539376+00	2
4	seller-files/wallet_api.json	2022-11-23 12:17:32.326705+00	2022-11-23 12:17:32.326721+00	7
5	seller-files/Screenshot_from_2022-11-26_21-07-59.png	2022-11-29 13:58:53.82877+00	2022-11-29 13:58:53.828787+00	8
\.


--
-- Data for Name: order_detail; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.order_detail (instant_delivery, order_id, shipment_id, description, customer_code, delivery_address, delivery_locality, delivery_requested_time, delivery_station_id, destination_state, order_no, payment_mode, pickup_address, pickup_locality, pickup_requested_date, pickup_requested_time, pickup_state, pickup_station_id, pickup_type, receiver_name, receiver_phone, receiver_town_id, recipient_email, sender_email, sender_name, sender_phone, sender_town_id, service_id, system_reference, vehicle_id, weight) FROM stdin;
\.


--
-- Data for Name: order_detail_items; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.order_detail_items (order_detail_order_id, amount, color, delivery_city, delivery_contact_name, delivery_contact_number, delivery_google_place_address, delivery_landmark, delivery_state, description, id, item_type, name, pick_up_contact_name, pick_up_contact_number, pick_up_google_place_address, pick_up_landmark, pick_up_latitude, pick_up_longitude, pickup_city, pickup_state, quantity, shipment_type, size, weight, weight_range) FROM stdin;
\.


--
-- Data for Name: shipment; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.shipment (cost, client_id, created_date, id, shipper_id, message, tracking_no, shipper_assigned_reference, shipper_assigned_tracking_no, status) FROM stdin;
\.


--
-- Data for Name: shipment_order_details; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.shipment_order_details (order_details_order_id, shipment_id) FROM stdin;
\.


--
-- Data for Name: shipper; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.shipper (type, id, dtype, password, api_key, auth_type, biller_code, email, factory_id, name, shipper_id, status) FROM stdin;
1	2	StandardShipper	\N	\N	\N	\N	\N	GIGL	GIG	bbec4604-d9dc-46c8-9a94-a0a376fc8448	ACTIVE
2	3	GenericCustomShipper	\N	\N	\N	\N	\N	TM30	TM30	00f9f8e3-5c51-4ac7-858f-9a4a19374bba	INACTIVE
1	1	StandardShipper	\N	\N	\N	\N	\N	DELLYMAN	DELLYMAN	28834312-827a-4921-b8cc-e00226b3e284	ACTIVE
2	4	GenericCustomShipper	konga123	OBvHqGz9CZ57HkpHA3yPIJbcBLhc64OlD570i1EOpY0tOtyyeuuxcr5IUiRNS88VQfbHqZGcPoSbjY1mUFIpMYLnIjcQGpiz6cd5gdJlmmifWP4NvY0vqNfhXuSfUpg8	API_KEY		info@konga.com	\N	konga2 logistics	38ce8b87-2707-4790-bcc8-63003d04556a	INACTIVE
\.


--
-- Data for Name: shipper_apis; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.shipper_apis (shipper_id, endpoint, label, method, request_body, require_params, api_labels) FROM stdin;
\.


--
-- Data for Name: shipper_clients; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.shipper_clients (approved_shippers_id, clients_id) FROM stdin;
\.


--
-- Data for Name: shipper_modes_of_transportation; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.shipper_modes_of_transportation (shipper_id, modes_of_transportation) FROM stdin;
\.


--
-- Data for Name: state; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.state (id, state_id, state_name) FROM stdin;
1	26	NASSARAWA
2	4	AKWA IBOM
3	11	DELTA
4	37	ZAMFARA
5	12	EBONYI
6	35	TARABA
7	10	CROSS RIVER
8	15	ENUGU
9	24	KWARA
10	18	JIGAWA
11	29	ONDO
12	13	EDO
13	28	OGUN
14	6	BAUCHI
15	30	OSUN
16	25	LAGOS
17	9	BORNO
18	21	KATSINA
19	7	BAYELSA
20	31	OYO
21	34	SOKOTO
22	23	KOGI
23	16	GOMBE
24	1	ABIA
25	17	IMO
26	3	ADAMAWA
27	22	KEBBI
28	36	YOBE
29	20	KANO
30	27	NIGER
31	32	PLATEAU
32	19	KADUNA
33	14	EKITI
34	2	ABUJA
35	8	BENUE
36	33	RIVERS
37	5	ANAMBRA
\.


--
-- Data for Name: state_cities; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.state_cities (cities_id, state_id) FROM stdin;
1	1
2	2
3	2
4	2
5	3
6	3
7	3
8	4
9	5
10	6
11	7
12	8
13	8
14	9
15	9
16	10
17	11
18	12
19	13
20	13
21	13
22	13
23	14
24	15
25	15
26	16
27	16
28	17
29	18
30	20
31	20
32	20
33	21
34	22
35	23
36	24
37	24
38	25
39	26
40	27
41	28
42	29
43	30
44	30
45	31
46	32
47	32
48	33
49	34
50	35
51	36
52	36
53	37
54	37
55	37
\.


--
-- Data for Name: state_stations; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.state_stations (state_id, code, id, name, state) FROM stdin;
\.


--
-- Data for Name: store_store; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.store_store (id, name, logo, description, is_active, created_on, updated_on, seller_id, on_sale, slug) FROM stdin;
33	Yop tech			f	2023-01-09 11:07:25.975741+00	2023-01-09 11:07:25.975757+00	34	f	Test-slug15
6	Eni Wealth	store-logo/payarena_logo.jpeg	Fashoin shop	t	2022-11-23 12:19:40.35895+00	2022-11-23 12:19:40.358975+00	7	f	Test-slug1
5	Tommy	store-logo/17DE134D-3075-4D89-9C15-4A3A9D2A80DC.jpeg	Description	t	2022-11-18 13:24:36.140315+00	2022-11-22 15:52:16.863842+00	6	f	Tommy-123
8	Eni Wealth Store	store-logo/payarena_logo_KOG6DUP.jpeg	This is a test store	t	2022-12-01 01:18:58.398469+00	2022-12-01 01:18:58.39849+00	2	f	Test-slug2
15	Ipeopletech			t	2022-12-30 08:11:32.491214+00	2022-12-30 08:11:32.491228+00	15	f	Test-slug3
27	Feyz			t	2022-12-31 08:24:36.934548+00	2022-12-31 08:24:36.934582+00	28	f	Test-slug4
26	Dmi ent.			t	2022-12-30 20:53:19.476147+00	2022-12-30 20:53:19.476161+00	27	f	Test-slug5
28	Beestech			t	2023-01-03 08:59:04.764252+00	2023-01-03 08:59:04.76427+00	29	f	Test-slug6
29	Ochitech33			t	2023-01-05 16:36:09.487195+00	2023-01-05 16:36:09.487211+00	30	f	Test-slug7
30	Thomiwa entreprises			t	2023-01-06 09:59:57.647364+00	2023-01-06 09:59:57.647381+00	31	f	Test-slug8
32	Tommm wears			t	2023-01-07 08:08:25.234212+00	2023-01-07 08:08:25.234227+00	33	f	Test-slug9
34	Tobi enterprise			f	2023-01-20 13:11:07.379341+00	2023-01-20 13:11:07.379358+00	35	f	Test-slug10
31	Abatech33			t	2023-01-06 14:36:43.076653+00	2023-01-06 14:36:43.076668+00	32	f	Test-slug11
16	Agada stores			t	2022-12-30 08:13:26.863756+00	2022-12-30 08:13:26.86377+00	16	f	Test-slug12
11	Dhaniel entreprises			t	2022-12-29 12:09:29.779051+00	2022-12-29 12:09:29.779065+00	11	f	Test-slug13
7	Prime	store-logo/tiger.jpeg	Store description ...	t	2022-11-29 14:02:28.459554+00	2022-11-29 14:02:28.459597+00	8	f	Test-slug14
\.


--
-- Data for Name: store_store_categories; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.store_store_categories (id, store_id, productcategory_id) FROM stdin;
13	5	1
14	6	1
15	7	1
16	7	2
17	7	3
18	7	4
19	7	5
20	7	6
21	8	8
22	8	1
23	8	3
25	11	1
26	11	3
30	16	1
37	26	10
38	30	10
39	34	31
\.


--
-- Data for Name: superadmin_adminuser; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.superadmin_adminuser (id, created_on, update_on, role_id, user_id) FROM stdin;
2	2022-12-02 13:26:48.075333+00	2022-12-02 13:26:48.076967+00	3	54
1	2022-12-01 11:05:53.456116+00	2022-12-03 07:10:42.015871+00	4	53
3	2022-12-03 15:40:12.479943+00	2022-12-03 15:40:12.481151+00	2	55
4	2022-12-04 14:47:35.870928+00	2022-12-04 14:47:35.872114+00	1	56
5	2022-12-05 09:26:06.926024+00	2022-12-05 09:26:06.927535+00	1	57
6	2022-12-07 15:20:47.681891+00	2022-12-07 15:20:47.683265+00	3	58
7	2022-12-07 15:22:34.698402+00	2022-12-07 15:22:34.699798+00	2	59
\.


--
-- Data for Name: superadmin_role; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.superadmin_role (id, created_on, updated_on, admin_type) FROM stdin;
1	2022-12-01 11:04:03.911595+00	2022-12-01 11:04:03.911617+00	reviewer
2	2022-12-01 11:04:08.128989+00	2022-12-01 11:04:08.12901+00	authorizer
3	2022-12-01 11:04:15.985107+00	2022-12-01 11:04:15.985127+00	admin
4	2022-12-01 11:04:21.009112+00	2022-12-01 11:04:21.009132+00	super_admin
\.


--
-- Data for Name: transaction_merchanttransaction; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.transaction_merchanttransaction (id, shipper, amount, delivery_fee, total, created_on, updated_on, merchant_id, order_id, transaction_id) FROM stdin;
1	REDSTAR	1000.00	973.92	1973.92	2023-01-16 13:18:13.769494+00	2023-01-16 13:18:13.769513+00	8	73	124
2	DELLYMAN	5000.00	1868.50	6868.50	2023-01-16 13:18:13.776153+00	2023-01-16 13:18:13.776169+00	7	73	124
3	DELLYMAN	10200.00	1767.50	11967.50	2023-01-17 00:45:13.452324+00	2023-01-17 00:45:13.452342+00	7	74	125
4	REDSTAR	1000.00	973.92	1973.92	2023-01-17 00:45:13.460035+00	2023-01-17 00:45:13.46005+00	8	74	125
5	DELLYMAN	3000000.00	1750.00	3001750.00	2023-01-17 09:35:26.881625+00	2023-01-17 09:35:26.881646+00	7	75	126
6	DELLYMAN	20000.00	1414.00	21414.00	2023-01-17 11:00:26.098049+00	2023-01-17 11:00:26.098068+00	2	77	129
7	DELLYMAN	39400.00	1000.00	40400.00	2023-01-19 09:40:12.663926+00	2023-01-19 09:40:12.663947+00	7	80	135
8	DELLYMAN	1000.00	0.00	1000.00	2023-01-19 09:40:12.670577+00	2023-01-19 09:40:12.670593+00	8	80	135
9	DELLYMAN	700000.00	1262.50	701262.50	2023-02-12 15:23:13.895994+00	2023-02-12 15:23:13.896012+00	7	87	154
10	DELLYMAN	5000.00	1919.00	6919.00	2023-02-12 20:35:37.823979+00	2023-02-12 20:35:37.824001+00	7	81	136
11	DELLYMAN	710000.00	1262.50	711262.50	2023-02-13 08:29:59.97739+00	2023-02-13 08:29:59.977407+00	7	88	156
13	REDSTAR	100.00	964.28	1064.28	2023-02-21 16:05:25.48+00	2023-02-21 16:14:33.919+00	7	95	82
14	REDSTAR	44964.28	964.28	45928.56	2023-03-28 09:30:35.147269+00	2023-03-28 09:30:35.147291+00	27	101	173
\.


--
-- Data for Name: transaction_transaction; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.transaction_transaction (id, payment_method, amount, status, transaction_reference, transaction_detail, order_id, created_on, updated_on, source) FROM stdin;
2	wallet	10000.00	success	REF-2424	Details ...	2	2022-11-25 12:44:49.751366+00	2022-11-25 15:13:16.27469+00	\N
5	pay_attitude	3888.80	pending	\N	\N	4	2022-12-02 10:44:34.095073+00	2022-12-02 10:44:34.095089+00	\N
7	pay_attitude	512525.00	pending	\N	\N	5	2022-12-08 12:30:41.473574+00	2022-12-08 12:30:41.473591+00	\N
33	card	7020.00	pending	38595	Payment for OrderID: 20	20	2022-12-12 13:39:56.985537+00	2022-12-12 13:39:58.322006+00	\N
6	card	512525.00	pending	38471	Payment for OrderID: 5	5	2022-12-08 12:13:02.304965+00	2022-12-08 13:25:43.795227+00	\N
8	card	512525.00	pending	38472	Payment for OrderID: 6	6	2022-12-08 13:27:22.717495+00	2022-12-08 13:27:23.474712+00	\N
9	card	587150.00	pending	38479	Payment for OrderID: 7	7	2022-12-08 14:38:35.330994+00	2022-12-08 14:38:36.033015+00	\N
10	wallet	587150.00	pending	\N	\N	7	2022-12-08 14:43:43.619596+00	2022-12-08 14:43:43.619611+00	\N
12	card	502625.00	pending	38482	Payment for OrderID: 8	8	2022-12-08 15:09:31.799807+00	2022-12-08 15:09:32.481508+00	\N
13	pay_attitude	502625.00	pending	\N	\N	7	2022-12-08 15:18:03.514649+00	2022-12-08 15:18:03.514663+00	\N
34	card	73262.50	pending	38596	Payment for OrderID: 21	21	2022-12-12 13:49:04.16542+00	2022-12-12 13:49:04.823314+00	\N
47	card	59525.00	pending	38737	Payment for OrderID: 26	26	2022-12-14 15:33:32.446598+00	2022-12-14 15:33:33.297858+00	\N
32	card	73262.50	pending	38598	Payment for OrderID: 19	19	2022-12-12 13:34:31.507797+00	2022-12-12 13:52:19.777934+00	\N
30	card	32323.00	pending	38599	Payment for OrderID: 17	17	2022-12-12 12:35:00.318465+00	2022-12-12 13:56:12.682198+00	\N
46	card	46262.50	pending	38738	Payment for OrderID: 26	26	2022-12-14 15:26:07.115216+00	2022-12-14 15:42:51.235228+00	\N
11	card	502625.00	pending	38489	Payment for OrderID: 7	7	2022-12-08 14:45:23.505079+00	2022-12-08 15:32:18.05895+00	\N
14	card	1362.50	pending	38492	Payment for OrderID: 7	7	2022-12-08 15:35:41.458465+00	2022-12-08 15:35:42.066259+00	\N
16	card	11262.50	pending	\N	\N	10	2022-12-08 17:39:27.410475+00	2022-12-08 17:39:27.410489+00	\N
36	card	7020.00	pending	38602	Payment for OrderID: 22	22	2022-12-12 14:14:50.661995+00	2022-12-12 14:18:44.12454+00	\N
37	wallet	59338.00	pending	\N	\N	17	2022-12-12 15:25:33.151567+00	2022-12-12 15:25:33.151582+00	\N
35	card	59338.00	pending	38603	Payment for OrderID: 17	17	2022-12-12 14:00:50.722805+00	2022-12-12 15:26:20.487597+00	\N
15	card	1362.50	pending	38501	Payment for OrderID: 9	9	2022-12-08 15:37:29.197769+00	2022-12-08 17:59:34.685724+00	\N
18	wallet	11262.50	pending	\N	\N	12	2022-12-08 18:21:17.377409+00	2022-12-08 18:21:17.377423+00	\N
17	card	553984.50	pending	38506	Payment for OrderID: 11	11	2022-12-08 18:03:39.246892+00	2022-12-08 20:06:04.844957+00	\N
19	card	54084.50	pending	\N	\N	11	2022-12-09 06:33:35.169287+00	2022-12-09 06:33:35.169302+00	\N
20	card	1362.50	pending	\N	\N	11	2022-12-09 07:28:02.679726+00	2022-12-09 07:28:02.67974+00	\N
21	card	14887.50	pending	\N	\N	11	2022-12-09 09:50:50.650127+00	2022-12-09 09:50:50.65014+00	\N
48	card	124914.00	pending	38745	Payment for OrderID: 25	25	2022-12-14 16:53:42.422498+00	2022-12-14 16:54:04.042295+00	\N
38	card	17000.00	pending	38694	Payment for OrderID: 23	23	2022-12-14 10:06:31.096838+00	2022-12-14 10:32:42.005128+00	\N
22	card	36650.00	pending	38537	Payment for OrderID: 11	11	2022-12-09 12:06:22.07563+00	2022-12-09 12:53:04.784081+00	\N
23	card	511515.00	pending	38540	Payment for OrderID: 13	13	2022-12-09 13:11:33.657504+00	2022-12-09 13:11:34.282775+00	\N
24	card	24025.00	pending	\N	\N	11	2022-12-09 13:46:09.887599+00	2022-12-09 13:46:09.887613+00	\N
25	card	79525.00	pending	38576	Payment for OrderID: 14	14	2022-12-12 10:19:24.765523+00	2022-12-12 10:19:26.782644+00	\N
26	card	52722.00	pending	38579	Payment for OrderID: 15	15	2022-12-12 11:27:40.349252+00	2022-12-12 11:27:41.933508+00	\N
27	card	28025.00	pending	38580	Payment for OrderID: 16	16	2022-12-12 11:40:23.20027+00	2022-12-12 11:40:23.91241+00	\N
28	card	21762.50	pending	38581	Payment for OrderID: 16	16	2022-12-12 12:01:41.787013+00	2022-12-12 12:01:43.02555+00	\N
29	card	124762.50	pending	38587	Payment for OrderID: 16	16	2022-12-12 12:27:58.475211+00	2022-12-12 12:27:59.468743+00	\N
31	card	30959.50	pending	38593	Payment for OrderID: 18	18	2022-12-12 13:10:53.514933+00	2022-12-12 13:10:54.444126+00	\N
56	card	4388.80	pending	38776	Payment for OrderID: 30	30	2022-12-14 21:51:19.462395+00	2022-12-14 21:54:44.132622+00	\N
49	card	37959.50	pending	38747	Payment for OrderID: 28	28	2022-12-14 16:59:39.006628+00	2022-12-14 17:04:13.491491+00	\N
39	card	51388.80	pending	38712	Payment for OrderID: 24	24	2022-12-14 10:48:44.949797+00	2022-12-14 11:08:51.98466+00	\N
40	wallet	79388.80	pending	\N	\N	25	2022-12-14 13:09:41.105185+00	2022-12-14 13:09:41.105202+00	\N
41	card	79388.80	pending	38719	Payment for OrderID: 25	25	2022-12-14 13:10:00.766207+00	2022-12-14 13:10:50.325209+00	\N
42	card	93388.80	pending	38722	Payment for OrderID: 26	26	2022-12-14 13:45:18.009766+00	2022-12-14 13:45:19.048494+00	\N
43	card	95166.40	pending	38723	Payment for OrderID: 26	26	2022-12-14 13:46:47.5047+00	2022-12-14 13:46:48.497196+00	\N
44	card	144777.60	pending	38731	Payment for OrderID: 27	27	2022-12-14 15:04:44.490152+00	2022-12-14 15:04:45.871619+00	\N
50	card	91388.80	pending	38748	Payment for OrderID: 28	28	2022-12-14 17:18:36.088366+00	2022-12-14 17:18:36.973191+00	\N
45	card	144777.60	pending	38734	Payment for OrderID: 26	26	2022-12-14 15:06:52.021421+00	2022-12-14 15:11:17.44824+00	\N
51	card	91459.50	pending	38749	Payment for OrderID: 28	28	2022-12-14 17:20:07.98092+00	2022-12-14 17:20:09.22204+00	\N
52	card	92722.00	pending	38750	Payment for OrderID: 28	28	2022-12-14 17:22:25.244846+00	2022-12-14 17:22:26.124738+00	\N
59	card	125277.60	pending	38792	Payment for OrderID: 25	25	2022-12-15 08:13:25.298141+00	2022-12-15 08:13:26.713029+00	\N
57	card	17777.60	pending	38777	Payment for OrderID: 28	28	2022-12-14 21:57:18.128043+00	2022-12-14 21:58:41.243796+00	\N
53	card	92348.30	pending	38767	Payment for OrderID: 28	28	2022-12-14 20:08:56.5597+00	2022-12-14 21:31:13.923782+00	\N
54	card	4388.80	pending	38769	Payment for OrderID: 28	28	2022-12-14 21:33:11.842137+00	2022-12-14 21:33:50.193949+00	\N
63	card	50277.60	pending	38901	Payment for OrderID: 33	33	2022-12-16 14:17:49.383543+00	2022-12-16 14:17:51.252959+00	\N
55	card	4388.80	failed	38826	Payment for OrderID: 29	29	2022-12-14 21:44:45.41701+00	2022-12-15 11:27:52.316037+00	\N
60	wallet	12888.80	pending	\N	\N	31	2022-12-16 11:32:41.836193+00	2022-12-16 11:32:41.836209+00	\N
61	card	12888.80	pending	38892	Payment for OrderID: 31	31	2022-12-16 11:32:49.178193+00	2022-12-16 11:34:51.789138+00	\N
58	card	16388.80	pending	38791	Payment for OrderID: 28	28	2022-12-14 22:27:48.776916+00	2022-12-15 05:17:28.372532+00	\N
65	card	1388.80	pending	39039	Payment for OrderID: 22	22	2022-12-19 09:42:36.791698+00	2022-12-20 14:30:07.412618+00	\N
62	card	50277.60	pending	38897	Payment for OrderID: 32	32	2022-12-16 12:53:43.347092+00	2022-12-16 12:58:26.901843+00	\N
64	card	5388.80	pending	38902	Payment for OrderID: 34	34	2022-12-16 14:50:42.96269+00	2022-12-20 08:47:38.625729+00	\N
66	card	11277.60	pending	39061	Payment for OrderID: 35	35	2022-12-21 08:08:03.144359+00	2022-12-21 09:41:59.598368+00	\N
69	card	22368.50	pending	39272	Payment for OrderID: 38	38	2022-12-30 12:51:26.588202+00	2022-12-30 14:29:11.398844+00	\N
70	card	3020.00	pending	39262	Payment for OrderID: 39	39	2022-12-30 12:54:39.090487+00	2022-12-30 13:39:58.745703+00	\N
71	card	2414.00	pending	39253	Payment for OrderID: 40	40	2022-12-30 13:06:33.295749+00	2022-12-30 13:09:48.170897+00	\N
72	card	63114.00	pending	39270	Payment for OrderID: 41	41	2022-12-30 14:24:26.603886+00	2022-12-30 14:24:27.435335+00	\N
73	card	6010.00	pending	39277	Payment for OrderID: 42	42	2022-12-30 15:25:34.803268+00	2022-12-30 15:25:35.756752+00	\N
111	wallet	154301.49	pending	\N	\N	54	2023-01-06 15:09:56.462103+00	2023-01-06 15:09:56.462118+00	\N
75	card	49762.50	success	39292	Payment for OrderID: 29	29	2022-12-30 17:07:23.405547+00	2022-12-30 17:08:11.651306+00	\N
76	card	74731.55	pending	39293	Payment for OrderID: 44	44	2022-12-30 17:25:49.745597+00	2022-12-30 17:27:18.746961+00	\N
77	card	74731.55	pending	39294	Payment for OrderID: 45	45	2022-12-30 17:29:35.264438+00	2022-12-30 17:29:35.490643+00	\N
78	card	6868.50	pending	39321	Payment for OrderID: 46	46	2023-01-03 06:48:01.179773+00	2023-01-03 06:48:04.937892+00	\N
123	card	4859.17	pending	40324	Payment for OrderID: 72	72	2023-01-16 11:58:52.935441+00	2023-01-16 11:58:53.579817+00	\N
74	card	1110.00	pending	39322	Payment for OrderID: 43	43	2022-12-30 15:26:55.715187+00	2023-01-03 07:29:01.063046+00	\N
112	card	117567.50	success	39472	Payment for OrderID: 63	63	2023-01-07 07:54:31.349494+00	2023-01-07 08:20:18.507863+00	\N
113	card	573767.50	pending	40092	Payment for OrderID: 64	64	2023-01-10 05:47:01.549621+00	2023-01-10 05:47:02.609687+00	\N
99	card	16743.37	pending	39406	Payment for OrderID: 56	56	2023-01-06 00:59:18.844965+00	2023-01-06 07:37:20.393884+00	\N
100	card	14405.72	pending	39408	Payment for OrderID: 56	56	2023-01-06 07:39:28.289627+00	2023-01-06 07:39:46.000954+00	\N
79	card	3020.00	success	39332	Payment for OrderID: 47	47	2023-01-03 08:15:33.031635+00	2023-01-03 10:17:36.506397+00	\N
80	card	73010.00	success	39350	Payment for OrderID: 43	43	2023-01-04 11:05:22.477901+00	2023-01-04 11:07:38.541098+00	\N
81	card	22520.00	success	39358	Payment for OrderID: 48	48	2023-01-04 17:30:49.538027+00	2023-01-04 17:31:46.671933+00	\N
114	card	573767.50	failed	40093	Payment for OrderID: 65	65	2023-01-10 05:58:45.574722+00	2023-01-10 06:03:32.579362+00	\N
82	card	1064.28	success	39359	Payment for OrderID: 49	49	2023-02-21 17:39:47.261+00	2023-02-21 16:05:19.277+00	\N
83	card	74731.55	pending	39360	Payment for OrderID: 50	50	2023-01-04 18:12:38.957538+00	2023-01-04 18:12:39.564753+00	\N
101	card	589967.16	pending	39411	Payment for OrderID: 56	56	2023-01-06 07:44:44.743577+00	2023-01-06 07:48:08.468246+00	\N
84	card	35528.24	success	39366	Payment for OrderID: 51	51	2023-01-05 09:07:07.442019+00	2023-01-05 09:08:41.456898+00	\N
85	card	6010.00	success	39368	Payment for OrderID: 52	52	2023-01-05 09:42:23.258709+00	2023-01-05 09:45:00.548089+00	\N
86	card	41907.00	pending	\N	\N	53	2023-01-05 10:14:11.204642+00	2023-01-05 10:14:11.204657+00	\N
87	card	42614.00	pending	39369	Payment for OrderID: 53	53	2023-01-05 10:15:53.276291+00	2023-01-05 10:15:55.441044+00	\N
88	card	44634.00	success	39370	Payment for OrderID: 53	53	2023-01-05 10:32:41.479448+00	2023-01-05 10:33:54.473033+00	\N
89	wallet	45959.50	pending	\N	\N	54	2023-01-05 13:05:30.646505+00	2023-01-05 13:05:30.64652+00	\N
90	wallet	1762.50	pending	\N	\N	54	2023-01-05 13:10:18.117906+00	2023-01-05 13:10:18.117922+00	\N
102	card	6010.00	success	39412	Payment for OrderID: 58	58	2023-01-06 08:39:19.474749+00	2023-01-06 08:41:18.940522+00	\N
91	card	22207.00	success	39375	Payment for OrderID: 55	55	2023-01-05 14:17:30.140675+00	2023-01-05 14:19:11.215091+00	\N
133	card	27450.00	failed	40498	Payment for OrderID: 79	79	2023-01-18 19:03:14.857157+00	2023-01-18 19:04:58.652809+00	\N
93	wallet	2368.50	pending	\N	\N	46	2023-01-05 17:51:59.010027+00	2023-01-05 17:51:59.010044+00	\N
103	card	59331.91	pending	39413	Payment for OrderID: 59	59	2023-01-06 09:16:47.682761+00	2023-01-06 09:17:02.701758+00	\N
115	card	37185.92	success	40124	Payment for OrderID: 66	66	2023-01-11 18:57:27.66498+00	2023-01-11 19:00:06.523949+00	\N
104	card	119370.00	pending	39425	Payment for OrderID: 60	60	2023-01-06 13:14:45.749999+00	2023-01-06 13:14:46.752106+00	\N
94	card	2368.50	pending	39391	Payment for OrderID: 46	46	2023-01-05 17:54:57.782592+00	2023-01-05 18:06:21.338295+00	\N
95	card	140789.66	pending	39394	Payment for OrderID: 56	56	2023-01-06 00:37:10.422098+00	2023-01-06 00:37:12.584955+00	\N
96	card	140789.66	pending	39395	Payment for OrderID: 57	57	2023-01-06 00:41:42.193655+00	2023-01-06 00:41:43.154464+00	\N
97	card	15743.37	pending	39396	Payment for OrderID: 56	56	2023-01-06 00:50:49.236268+00	2023-01-06 00:50:49.859332+00	\N
98	card	15743.37	pending	39397	Payment for OrderID: 57	57	2023-01-06 00:57:12.286691+00	2023-01-06 00:57:12.898362+00	\N
116	card	4241.42	pending	40158	Payment for OrderID: 67	67	2023-01-12 21:50:41.571389+00	2023-01-12 21:50:43.557816+00	\N
105	card	175381.56	pending	39429	Payment for OrderID: 61	61	2023-01-06 13:16:46.107823+00	2023-01-06 13:18:12.077709+00	\N
92	card	1762.50	pending	39432	Payment for OrderID: 54	54	2023-01-05 17:48:59.510926+00	2023-01-06 13:49:26.248925+00	\N
106	card	2262.50	pending	39433	Payment for OrderID: 54	54	2023-01-06 13:51:08.481452+00	2023-01-06 13:51:09.127722+00	\N
107	card	119370.00	pending	39434	Payment for OrderID: 61	61	2023-01-06 13:54:25.727748+00	2023-01-06 13:54:26.3679+00	\N
124	card	8842.42	success	40329	Payment for OrderID: 73	73	2023-01-16 13:17:12.946048+00	2023-01-16 13:18:13.778602+00	\N
117	card	52088.42	success	40159	Payment for OrderID: 67	67	2023-01-12 21:59:27.170215+00	2023-01-12 22:00:44.230219+00	\N
108	card	159602.98	pending	39439	Payment for OrderID: 54	54	2023-01-06 13:55:15.15399+00	2023-01-06 14:02:19.495434+00	\N
109	card	154301.49	pending	39445	Payment for OrderID: 54	54	2023-01-06 14:35:41.455008+00	2023-01-06 14:35:43.756806+00	\N
118	wallet	762741.42	pending	\N	\N	68	2023-01-12 22:12:21.889279+00	2023-01-12 22:12:21.889293+00	\N
110	card	46585.01	failed	39447	Payment for OrderID: 62	62	2023-01-06 15:06:08.779264+00	2023-01-06 15:08:27.850603+00	\N
119	card	75236.42	success	40163	Payment for OrderID: 69	69	2023-01-13 06:16:21.95993+00	2023-01-13 06:17:19.620038+00	\N
129	card	21400.00	success	40427	Payment for OrderID: 77	77	2023-01-17 10:59:35.584781+00	2023-01-17 11:00:23.978491+00	\N
120	card	9342.42	success	40308	Payment for OrderID: 46	46	2023-01-16 10:37:19.805807+00	2023-01-16 10:38:22.128869+00	\N
121	card	7439.09	pending	40314	Payment for OrderID: 70	70	2023-01-16 11:40:17.305918+00	2023-01-16 11:40:18.015621+00	\N
122	card	7439.09	pending	40320	Payment for OrderID: 71	71	2023-01-16 11:49:34.397005+00	2023-01-16 11:49:35.049518+00	\N
125	card	13941.42	success	40365	Payment for OrderID: 74	74	2023-01-17 00:43:39.684715+00	2023-01-17 00:45:09.055901+00	\N
126	wallet	3001750.00	pending	\N	\N	75	2023-01-17 09:34:12.725437+00	2023-01-17 09:34:12.725451+00	\N
127	card	3001750.00	success	40381	Payment for OrderID: 75	75	2023-01-17 09:34:19.218926+00	2023-01-17 09:35:25.494569+00	\N
130	card	37650.00	pending	40478	Payment for OrderID: 78	78	2023-01-18 11:09:23.836079+00	2023-01-18 11:09:26.261029+00	\N
128	card	109700.00	success	40388	Payment for OrderID: 76	76	2023-01-17 09:43:26.75071+00	2023-01-17 09:44:05.238034+00	\N
131	wallet	37650.00	pending	\N	\N	78	2023-01-18 11:10:24.149488+00	2023-01-18 11:10:24.149502+00	\N
132	card	606815.00	pending	40485	Payment for OrderID: 79	79	2023-01-18 14:15:43.938172+00	2023-01-18 14:15:44.771425+00	\N
136	card	6850.00	pending	\N	\N	81	2023-01-26 08:22:19.591188+00	2023-01-26 08:22:19.591214+00	\N
134	card	27164.28	pending	40499	Payment for OrderID: 79	79	2023-01-18 19:06:15.761133+00	2023-01-18 19:06:16.373071+00	\N
135	card	41400.00	success	40505	Payment for OrderID: 80	80	2023-01-19 09:38:53.706446+00	2023-01-19 09:40:10.893498+00	\N
137	card	125250.00	pending	\N	\N	82	2023-01-28 08:36:05.672372+00	2023-01-28 08:36:05.672386+00	\N
138	card	2027000.00	pending	\N	\N	83	2023-01-29 06:46:15.886163+00	2023-01-29 06:46:15.886176+00	\N
139	card	1839704.28	pending	\N	\N	83	2023-02-01 22:38:10.602773+00	2023-02-01 22:38:10.602789+00	\N
140	card	1839440.00	pending	\N	\N	83	2023-02-04 13:22:18.003143+00	2023-02-04 13:22:18.003157+00	\N
141	card	2504074.28	pending	\N	\N	83	2023-02-10 10:56:57.269125+00	2023-02-10 10:56:57.269147+00	\N
142	card	2503110.00	pending	\N	\N	83	2023-02-10 11:20:50.712673+00	2023-02-10 11:20:50.712688+00	\N
143	card	2504910.00	pending	\N	\N	83	2023-02-10 13:07:56.069769+00	2023-02-10 13:07:56.069783+00	\N
144	card	1401000.00	pending	\N	\N	84	2023-02-10 13:17:16.834099+00	2023-02-10 13:17:16.834114+00	\N
146	card	2506302.84	pending	\N	\N	83	2023-02-10 13:51:16.64584+00	2023-02-10 13:51:16.645853+00	\N
147	card	2506588.56	pending	41423	Payment for OrderID: 83	83	2023-02-10 13:54:07.777216+00	2023-02-10 13:54:08.376716+00	\N
148	card	3530.00	pending	41425	Payment for OrderID: 85	85	2023-02-10 13:57:54.800735+00	2023-02-10 13:57:55.474436+00	\N
149	card	6250.00	pending	41428	Payment for OrderID: 86	86	2023-02-10 14:41:08.51788+00	2023-02-10 14:48:58.595879+00	\N
172	card	44964.28	pending	42721	Payment for OrderID: 100	100	2023-03-24 10:15:42.436486+00	2023-03-24 14:23:41.004729+00	\N
150	card	1994.28	pending	41430	Payment for OrderID: 83	83	2023-02-10 15:22:51.014497+00	2023-02-10 15:28:50.501106+00	\N
151	card	2280.00	pending	41431	Payment for OrderID: 85	85	2023-02-10 15:32:21.377607+00	2023-02-10 15:32:22.846943+00	\N
152	card	3244.28	pending	41432	Payment for OrderID: 83	83	2023-02-10 15:35:20.493517+00	2023-02-10 15:35:21.14369+00	\N
153	card	3244.28	success	41433	Payment for OrderID: 85	85	2023-02-10 15:37:36.729281+00	2023-02-10 15:38:18.567032+00	\N
154	card	701250.00	success	41434	Payment for OrderID: 87	87	2023-02-12 15:21:48.158519+00	2023-02-12 15:23:11.762848+00	\N
155	wallet	6900.00	pending	\N	\N	81	2023-02-12 20:31:26.123538+00	2023-02-12 20:31:26.123572+00	\N
145	card	6900.00	success	41435	Payment for OrderID: 81	81	2023-02-10 13:34:19.569372+00	2023-02-12 20:35:35.345323+00	\N
156	card	711250.00	success	41437	Payment for OrderID: 88	88	2023-02-13 08:29:15.341984+00	2023-02-13 08:29:57.997816+00	\N
157	wallet	73250.00	pending	\N	\N	89	2023-02-13 08:40:34.928692+00	2023-02-13 08:40:34.928707+00	\N
174	card	1364.28	pending	42809	Payment for OrderID: 102	102	2023-03-28 09:16:57.958189+00	2023-03-28 09:17:29.941284+00	\N
158	card	118250.00	success	41443	Payment for OrderID: 89	89	2023-02-13 09:09:03.601603+00	2023-02-13 11:05:33.818553+00	\N
173	card	44964.28	success	42822	Payment for OrderID: 101	101	2023-03-27 15:10:52.856075+00	2023-03-28 09:30:35.151908+00	\N
159	card	21750.00	pending	41444	Payment for OrderID: 90	90	2023-02-13 14:20:54.624406+00	2023-02-13 14:23:01.282593+00	\N
160	card	21750.00	pending	41445	Payment for OrderID: 91	91	2023-02-13 14:25:22.050587+00	2023-02-13 14:25:23.543919+00	\N
161	card	73250.00	failed	41446	Payment for OrderID: 92	92	2023-02-13 14:33:52.404728+00	2023-02-13 14:35:27.510998+00	\N
162	card	335280.00	pending	\N	\N	93	2023-02-13 22:04:41.442283+00	2023-02-13 22:04:41.442298+00	\N
163	card	333430.00	pending	\N	\N	92	2023-02-13 22:05:51.615054+00	2023-02-13 22:05:51.615069+00	\N
166	card	334294.28	pending	41934	Payment for OrderID: 93	93	2023-03-01 14:40:04.951467+00	2023-03-01 15:04:32.283404+00	\N
165	card	700900.00	pending	41963	Payment for OrderID: 84	84	2023-03-01 14:33:08.231035+00	2023-03-02 10:08:52.082158+00	\N
167	card	700700.00	success	41964	Payment for OrderID: 95	95	2023-03-02 10:53:32.176981+00	2023-03-02 10:56:12.738368+00	\N
168	card	1364.28	success	42714	Payment for OrderID: 96	96	2023-03-24 09:04:07.10254+00	2023-03-24 09:09:58.422993+00	\N
164	card	148714.28	success	\N	\N	94	2023-02-20 19:03:17.191206+00	2023-06-05 20:53:49.488957+00	\N
169	card	15828.56	success	42715	Payment for OrderID: 97	97	2023-03-24 09:27:18.408694+00	2023-03-24 09:28:25.322356+00	\N
170	card	44964.28	success	42716	Payment for OrderID: 98	98	2023-03-24 09:38:58.995365+00	2023-03-24 09:39:57.136652+00	\N
171	card	44964.28	success	42717	Payment for OrderID: 99	99	2023-03-24 10:02:08.818036+00	2023-03-24 10:03:08.665239+00	\N
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.users (dtype, id, date_modified, email, name, password, phone, registration_date, status, user_id, settlement_type, wallet_id) FROM stdin;
\.


--
-- Data for Name: wallet; Type: TABLE DATA; Schema: public; Owner: payarena
--

COPY public.wallet (balance, settlement_balance, client_id, id) FROM stdin;
\.


--
-- Data for Name: base_user; Type: TABLE DATA; Schema: shipping; Owner: payarena
--

COPY shipping.base_user (dtype, id, date_modified, email, name, password, phone, registration_date, role, status, user_id, api_key, settlement_type, commission_type_id, wallet_id) FROM stdin;
\.


--
-- Data for Name: base_user_approved_shippers; Type: TABLE DATA; Schema: shipping; Owner: payarena
--

COPY shipping.base_user_approved_shippers (client_id, approved_shippers_id, approved_shippers_key) FROM stdin;
\.


--
-- Data for Name: base_user_roles; Type: TABLE DATA; Schema: shipping; Owner: payarena
--

COPY shipping.base_user_roles (base_user_id, roles) FROM stdin;
96	CLIENT
197	CLIENT
\.


--
-- Data for Name: base_user_shipments; Type: TABLE DATA; Schema: shipping; Owner: payarena
--

COPY shipping.base_user_shipments (client_id, shipments_id) FROM stdin;
\.


--
-- Data for Name: city; Type: TABLE DATA; Schema: shipping; Owner: payarena
--

COPY shipping.city (id, code, name, state_id) FROM stdin;
104	DAM	DAMATURU	103
106	PHC	PORT HARCOURT	105
107	BNY	BONNY	105
109	GUS	GUSAU	108
111	KAN	KANO	110
113	JAL	JALINGO	112
115	IKP	IKOT EKPENE	114
116	EKT	EKET	114
117	UYO	UYO	114
119	ISL	LAGOS ISLAND	118
120	MLD	LAGOS MAINLAND	118
122	AWK	AWKA	121
123	NNI	NNEWI	121
124	ONA	ONITSHA	121
126	BNI	BENIN	125
128	ABV	ABUJA	127
130	SKO	SOKOTO	129
132	ADK	ADO EKITI	131
134	LKJ	LOKOJA	133
136	OFA	OFA	135
137	ILR	ILORIN	135
139	AKK	ABAKALIKI	138
141	DUT	DUTSE	140
143	KAS	KASTINA	142
145	ABK	ABEOKUTA	144
146	SAG	SAGAMU	144
147	IJB	IJEBU ODE	144
148	OTA	SANGO OTA	144
150	OGB	OGBOMOSHO	149
151	IBA	IBADAN	149
152	OYO	OYO	149
154	BAU	BAUCHI	153
156	KAD	KADUNA	155
157	ZRI	ZARIA	155
159	MNA	MINNA	158
160	SUL	SULEJA	158
162	WRI	WARRI	161
163	ASB	ASABA	161
164	SAE	SAPELE	161
166	OSG	OSHOGBO	165
167	IFE	ILE-IFE	165
169	LAF	LAFIA	168
171	ORI	OWERRI	170
173	MDI	MAKURDI	172
176	YOL	YOLA	175
178	CBQ	CALABAR	177
180	UHA	UMUAHIA	179
181	ABA	ABA	179
183	GOM	GOMBE	182
185	NSK	NSUKKA	184
186	ENU	ENUGU	184
188	JOS	JOS	187
190	MIU	MAIDUGURI	189
192	BRK	BIRNIN KEBBI	191
194	AKR	AKURE	193
\.


--
-- Data for Name: city_towns; Type: TABLE DATA; Schema: shipping; Owner: payarena
--

COPY shipping.city_towns (city_id, name, town_id) FROM stdin;
104	FEDERAL LOW COST	3027
104	GEIDAM	1048
104	GUJBA/BUNI YADI	1050
104	BINDIGARI	3023
104	BARA	1040
104	FIKA	1045
104	NEW GENERAL HOSPITAL	3040
104	DAPCHI	1044
104	DAMATURU	3025
104	LAMISULA	3035
104	GONIRI	3029
104	LEGISLATIVE QUARTERS	3036
104	POTISKUM	1057
104	D.H PALACE	3024
104	GWANGE	3031
104	GASHUA	1047
104	FUNE	136
104	BANKALIO ESTATE	3022
104	YUSUFARI	138
104	BABBAN-GIDA	1038
104	BUNI-YADI	1042
104	IBRAHIM ABACHA ESTATE	3032
104	BABBANGIDA/TARMUWA	1039
104	NENGERE	3039
104	GAIDAM	1046
104	GENERAL HOSPITAL	3028
104	GULANI	1051
104	JAJIMAJI/KARASUWA	1052
104	JAJI-MAJI	137
104	MAXIMUM SECURITY PRISON	3038
104	YUNUSARI	1058
104	JAKUSCO	3033
104	SAPETERI	3041
104	DAMAGUM	1043
104	WOMEN TEACHER'S COLLEGE	3044
104	ABUJA GARAGE	3021
104	MACHINA	1054
104	NGURU	1056
104	YUSUFFARI	3045
104	NANGERE	1055
104	KANAMA	3034
104	GUJBA	1049
104	STATE LOW COST HOUSING VILLAGE	3043
104	JAKUSKO	1053
104	SPECIALIST HOSPITAL	3042
104	GRA	3030
104	BARA/GULANI	1041
104	EMIRS PALACE	3026
104	MAISANDARI	3037
106	OGBOGU	2023
106	EREKU	1967
106	CHOBA	1922
106	BUKUMA	1918
106	EMUOHA	1964
106	IPO	4908
106	OKWUZU	2027
106	EMEZI	1963
106	RUMUODOGO	470
106	DEEYOR	1926
106	OBIGBO	4922
106	AGADA	1857
106	ALO-MINI	4887
106	AMAJI	1886
106	ISIOKPO	1987
106	OBITE	2015
106	UBIMA	2048
106	RUMUOSI	4952
106	AKPARA	1878
106	MBIAMA RD	4914
106	EGBOLOM	1946
106	GOKANA	1972
106	TRANS AMADI	4955
106	ANYU	1899
106	AMOROTA	1893
106	IKWERRE	4907
106	AKOH	1876
106	NDONI	2007
106	EBUGUMA	1937
106	MBUAMA	2000
106	OKRIKA	4932
106	EAGLE ISLAND RUMUEME/OROAKWO	4898
106	AHI OGBAKIRI	1867
106	APANI	1900
106	OMOGHO	4936
106	BERA	1908
106	UBETA	2047
106	NEW LAYOUT	4919
106	IWOFE	4910
106	NDOKI	4917
106	TAI	4953
106	BORI	1914
106	EKPE- AGGAH	1951
106	YEGHE	2062
106	ETCHE	1970
106	MGBO	2004
106	ABARIKPO	1848
106	KPOR	1994
106	ELELENWO	4900
106	DEGEMA	1927
106	DIBIRIGA	1931
106	CHOKOCHO	1923
106	RUMUAKPU	586
106	RUMUEKINI	467
106	RUMUIKPE	4944
106	IGBO-ETCHIE	4905
106	NGO	2010
106	OGU BOLO	4928
106	AMAKU	1887
106	EGBPRMA	1948
106	RUMUOKORO	4949
106	SAMA	2041
106	UEGURE	2051
106	BORI KORI	4891
106	UMUCHI	2053
106	AKIKWO	1873
106	DEME-UE	1930
106	CHIWOKINWERE	1921
106	ELEME	465
106	EGBELU	1945
106	B-DERE	1907
106	AMININGBOKA	1892
106	OKPOSI	2312
106	IFOKO	1976
106	ISIODU	1986
106	AMARAKE	1890
106	MINIMA	2005
106	ELELE ALIMINI	1957
106	EMOHUA	4902
106	OGBAKIRI	2021
106	KONO	1993
106	ABULOMA	4878
106	DIOBU MILE 4	4896
106	EKUCHE	1954
106	ABARO	1849
106	ONNE	2032
106	DIKIBOAMA	1932
106	NEW-OL	2008
106	ONIKU	2031
106	USOKIM	2059
106	RUMUAKPU	587
106	RUMUKRUESHI	4945
106	IBAA	1973
106	AGAH	1858
106	ELOK	1961
106	CHOKOTAA	1924
106	EGBEDA	2248
106	WOJI	4958
106	NEW GRA	4918
106	EBERI	1934
106	EGAMINI	1943
106	RUMUKWURUSI	4946
106	OKOGBE	4931
106	ELIETA	1960
106	ALINSO-OKENU	1884
106	EGBELEMA	1944
106	OPOBO NKORO	4939
106	AMUAJIE	1894
106	IKURU	1980
106	KALAIBIAMA	1991
106	ASE-AZAGA	1901
106	EBIRIBA	1935
106	ELELEWO	4901
106	WILYAAKARA	2061
106	OGU	2024
106	OKIRIKA TOWN	4929
106	BANGHA	1905
106	OBIGBO	4923
106	SOGHO	2042
106	RUMUEKPE	468
106	ELEM-AMA	1958
106	KRAKRAMA	1995
106	UMECHEM	2052
106	EEKEN	1941
106	KHANA	1992
106	BARAKO	1906
106	BETTER LAND	1909
106	IKPO	1978
106	EREMA	1968
106	OZUZU	2037
106	QUEENS TOWN	2038
106	OBO	2016
106	OBEAMA	4921
106	AFAM	1856
106	RUMUOMASI	4951
106	ESALA	1969
106	D-LINE	4897
106	OBUAMA	2017
106	DEMA	1929
106	IKPOKIRI	1979
106	OLD TOWNSHIP	4934
106	MGBEDE	2003
106	OLD GRA	4933
106	ANWUNIGBOKOR	1898
106	OGBA/EGBEMA	2020
106	NGOLOLO	2011
106	EKPEME	1952
106	RUMUIBEWKE	4943
106	NDELE	4916
106	OMUMA	2315
106	AKABUKA	1870
106	ASARI TORU	4890
106	OBUBURU	2018
106	BUGUMA	1917
106	IGWURUTA	466
106	AGGA	4880
106	EBOAHA	1936
106	IRIEBE	1985
106	BOMU	1913
106	ELEKAIHIA	4899
106	EDUGBERI	1940
106	TRANSAMADI	4956
106	AGBO/AKOGBOLOGBA	1865
106	EGITA-AKABUKA	1949
106	CHIO	1920
106	KREIGANI	1996
106	EKUNCHARA	1955
106	DIOBU MILE 1	4893
106	NONWA	2013
106	ABISSA	1850
106	OLAM-NKORO	2028
106	IMOGU	1984
106	ABALAMA	1847
106	KUNUSHA	1998
106	DANKIRI	1925
106	ASA	4889
106	ELE-OGU	1959
106	ENEKA	1965
106	FUCHE	1971
106	AFAM/OYIGBO	4879
106	ANAKPA	1895
106	UPATABO	2058
106	BUNDELE	1919
106	TERE-UE	2045
106	AHIA WOKOMA	1868
106	MBUNTA	2001
106	TERE-KURU	2044
106	DIOBU MILE 2	4894
106	OGBA	4926
106	AKPUTA	1879
106	ILOMA	1982
106	TOMBIA	2322
106	AGANOFOR	1859
106	AKINIRI	1875
106	ITU	2272
106	AKPAJO	4884
106	OCHOMA LAYOUT	4924
106	ISUA	1988
106	RUMUAPARALI/RUMUALOGU/O	4941
106	RUMUJI	469
106	EDECHA	1938
106	OBIRIK	2014
106	DEKEN	1928
106	OLUM	2029
106	AMADI FLAT	4888
106	ODEKPE	4925
106	OMOKU	2030
106	ANGULAMA	1897
106	AHODA WEST	4882
106	AKANI	1871
106	OMUOKO	4937
106	ICHOMA	1975
106	ATABA	1902
106	FOT/FLT/FZE/ONNE/PORT	4903
106	AKPABU	1877
106	OKIRIKATOWN	4930
106	OPUM	2034
106	AGBALU	1862
106	DIOBU	4892
106	ABONNEMA	1851
106	UBITE	2049
106	OGBOGORO	4927
106	ALA-AHOADA	1882
106	OPOBO	2033
106	UMUIGWE	2055
106	MBIAMA	1999
106	AMATAMUNO	1891
106	OMAGWA	4935
106	MOGHO	2006
106	AFARA	2231
106	BOUE	1915
106	BAKANA	1904
106	DIMAMA	1933
106	ALIMINI	4886
106	OYIGBO	2036
106	EMELOGO	1962
106	EFEBIRI	1942
106	RUMUODARA	4948
106	BIARA	1910
106	SOKU	2043
106	MEMBE	2002
106	ODAGA	2019
106	IGWA LAYOUT	4906
106	OGBEOGENE	2022
106	AGBANDELE	1863
106	ALAKAHIA	1883
106	AGBAOGA	1864
106	UDOHA	2050
106	UBARAMA	2046
106	AHOADA EAST	4881
106	NCHIA	4915
106	ANYAMA	2237
106	IWOAMA	1989
106	ACHARA	1853
106	ADANTA	1854
106	BAEN	1903
106	AKWUKOBI	1881
106	AKINIMA	1874
106	IBEWA	1974
106	PORT HARCOURT RD	4940
106	AMA	1885
106	ISAKA	4909
106	OKEHI	2303
106	AKINIMA AHOADA WEST	4883
106	NKORO	2012
106	AGUYA	1866
106	IGBODO	2262
106	IMERE	1983
106	AHOADA EAST/WEST	1869
106	RUMULUEMENI	4947
106	EGBONMA	1947
106	WAKAMA	2060
106	OWAZZA	2035
106	ABUA	1852
106	BODO	1912
106	IWOKIRI-AMA	1990
106	AKARAMIMI	1872
106	ALUU	464
106	RUMUAPU	4942
106	ABUA/ODUAL	4877
106	UMUEBULE	4957
106	AMAPA	1889
106	OKIRIKA	2025
106	AKUKUTORU	4885
106	ZAAKPON	2063
106	UMUORIEKE	2057
106	TOWN	4954
106	UMUDIOGA	2054
106	ELELE	1956
106	OBAGI	4920
106	SAKPONWA	2040
106	ANDONI	1896
106	RUMUOKWUOTA	4950
106	AMALEM	1888
106	ENGENI	1966
106	KDERA/OGONI	4911
106	ABONEMA/AKUKUTORU	4876
106	IGWURUTA-ALI	1977
106	AKWA	1880
106	SAGAMA	2039
106	AGBAKOROMA	1861
106	AGBADAMA	1860
106	EKPE-MGBEDE	1953
106	AGWARA	2236
106	OMUOKO/OMUOKIRI	4938
106	UMUNACHI	2323
106	BUAN	1916
106	ADIAI-OBIOFU	1855
106	MAGBUOBA	4913
106	EDEOHA	1939
106	NGBERE	2009
106	OKOROBO-ILE	2026
106	ABADA	1846
106	GARRISON	4904
106	KOLOKUMA	4912
106	EKEREKANA	1950
106	DIOBU MILE 3	4895
106	BILLA	1911
106	IKWATA	1981
106	KULA	1997
106	UMUOGA	2056
107	ALCON CONSTRUCTION SITE	974
107	BOUYGUES CONSTRUCTION SITE	975
107	FINIMA	977
107	BOROKIRI TOWN	132
107	PETERSIDE COMMUNITY	135
107	NLNG RESIDENTIAL AREA	980
107	NLNG CONSTRUCTION SITE	979
107	OLOMA COMMUNITY	134
107	ABALAMABIA	973
107	BONNY	2893
107	DBN  CONSTRUCTION SITE	976
107	DBN CONSTRUCTION SITE	2894
107	GREENS TOWN	133
107	JULLIUS BIGGER	2896
107	JULLIUS  BIGGER	978
107	JULIUS BERGER	2895
109	LUNGUN SARKIN MARAFA	3207
109	GUMMI	1163
109	GENERAL HOSPITAL	3198
109	UNGUMAR DAWAKI	3221
109	ZURMI	1171
109	KAURA NAMODA	179
109	BAKURA	1158
109	KOTROKASHI FED UNIVERSITY GUS	1164
109	ANKA	1157
109	DANCHADI	1162
109	SHIYAR MAI JUBBU	3215
109	ZURIMI	3222
109	TALAT MAFARA	180
109	TSOHUWAR KASUWA	3219
109	MARADU	3210
109	FED.POLYTECHNIC	3197
109	MAFARA	3209
109	BUNGUDU	1161
109	MIYENCHI	1168
109	BIRWIN MAGAJI	3192
109	BUBGUDU	3193
109	MARADUN	1165
109	SHINKAFI	1169
109	EMIRS PALACE	3196
109	MARU	1167
109	LUNGUN GALADIMA	3206
109	BUKKUYUM	3194
109	AROKA	3191
109	TUDUN WADA	3220
109	GUASAU	3199
109	SHIYAR DAN GALADIMA	3213
109	POST OFFICE	3212
109	SHIYAR WALI	3217
109	NNPC	2288
109	BYE PASS	3195
109	NNPC GUSAU DEPOT	3211
109	KOFAR KWATAR KWASHI	3204
109	TALAFA MAFARA	3218
109	HAKIMI DAN HASSAN	3202
109	TSAFE	1170
109	SHIYAR LIMANCHI	3214
109	GUSAU DEPOT	3201
109	GUSAU	3200
109	BUKKUYU	1160
109	MARAFA	1166
109	BIRNIN MAGAJI	1159
109	KASUWA DANJI	178
109	LUNGUN YAN NASSARAWA	3208
109	JANYAU	3203
109	KOTORKOSHI	3205
109	SHIYAR SARKIN BAURA	3216
111	KANO STATE UNIVERSITY	3807
111	NAIBAWA	3827
111	BELA/YADAKUNYA	1456
111	DAWAKIN TOFA	1463
111	POLICE BARRACKS	3830
111	DANBATTA	1461
111	BAGWAI	1454
111	CIROMAWA	1459
111	TSANGAWA	3843
111	TUDUNWADA	1499
111	TAMBURAWA	3841
111	JANGOZA	1475
111	WUDIL	1502
111	DAKATA	3774
111	DOGUWA	1465
111	KABO TOWN	3801
111	GAYA	1470
111	KWA	3817
111	RIMINGADO	1491
111	HAUSAWA QTRS	3798
111	BADAWA	3765
111	GARUN MALAM	1469
111	GARKO	1468
111	MUNICIPAL	1486
111	DANZANBUWA	3776
111	ALBASU	1452
111	JIGAWA	3800
111	FAGGE TAKUDU	3782
111	GABASAWA	1467
111	CORNER DANGORA	3773
111	AJINGI	1451
111	YABO	3851
111	TAKAI	1495
111	KOFAR MATA	3813
111	KOFAR FADA	3812
111	MADOBI	1483
111	GEZAWA	1471
111	GORON DUTSE	3789
111	BAGAUDA	1453
111	NASSARAWA	1487
111	RIMI GADO	3831
111	GORON MARAM	3790
111	SUMAILA	1494
111	WARAWA	3848
111	TARAUNI	1496
111	KANO	3805
111	BAGAWAI	3767
111	AGURU	3763
111	KOFAR NASSARAWA	3814
111	RIMIN GADO	3832
111	PANISAU	1488
111	KANGIWA	3804
111	BRIGADE QUARTER	3769
111	OLD CITY	3829
111	BADUME	3766
111	UNGOGO	1500
111	YADANKUNYA	3852
111	EMIRS PALACE	3781
111	DALA	1460
111	KAZARE	3810
111	TSANYAWA	1498
111	SHANONO	1493
111	GARUGAJA	3788
111	RUMFA COLLEGE	3833
111	KURNA	3816
111	ARBASU	3764
111	KARAYE	1477
111	TOFA	1497
111	WARAWAA	1501
111	DAWANAU	1464
111	HOTORO	3799
111	KABUGA	3802
111	KIBIYA	276
111	GANDU ALBASA	3784
111	TUDU WADA	3844
111	KAZAURE	1478
111	SHAGARI QUARTERS	3838
111	KWANAR DISO/KOFAR NA'ISA	3819
111	SABONGARI	3836
111	FAGGE	1466
111	WUDU	3850
111	SABON GARI	3835
111	GOVERNMENT HOUSE	3791
111	DOLE KAINA	3779
111	MALAMADORI	3822
111	HADEJIA TOWN	3797
111	CHALAWA PHASE 1	3770
111	SABIN	3834
111	UNLIOLIO	3847
111	KANO MUNICIPAL	3806
111	GWARZA	3792
111	KABO	1476
111	HADEJIA ROAD	3796
111	WUDII COMPREHENSIVE HEALTH	3849
111	GWARZO	1474
111	GWALE	1473
111	CHALAWA PHASE 3	3772
111	KUNCHI	3815
111	DAWAKIN KUDU	1462
111	DAMBATA	3775
111	KILOMETER 26	3811
111	GYADI-GYADI	3795
111	ZAKIRIA	3853
111	LOCAL GOVERNMENT SECRETARIAT	3821
111	BUNKURE	1458
111	BABURA	2242
111	BEBEJI	1455
111	GYADI GYADI	3793
111	UNGUWAR FULANI	3846
111	MAKODA	1484
111	MINICIPAL	3824
111	MINNA	3825
111	SHARADA	3840
111	SAMARI KATAF	3837
111	GARFIDA	3786
111	BICHI	1457
111	SHAHUCHI	3839
111	UGOGO	3845
111	RANGAZA	1489
111	ROGO	1492
111	GANO	3785
111	KATURJE	3808
111	GUNDUWWA DISTRICT	1472
111	RANO	1490
111	KUMBOTSO	1480
111	GYADI GYADI/KARKASARA	3794
111	CHALAWA PHASE 2	3771
111	LAHADIN  MAKALI	3820
111	TIGA	3842
111	GARINDO	3787
111	KADEMI	3803
111	NO MAN'S ISLAND	3828
111	KURA	1482
111	FARIN GADA	3783
111	DARA	3777
111	BOMPAI	3768
111	DARKI	3778
111	MICHAKA	3823
111	KIRU	1479
111	KUNCI	1481
111	KWANA YAU DADDAWA	3818
111	DOLIUWA	3780
111	MINJIBIR	1485
113	EMIRS PALACE/CENTRAL MARKET	3542
113	SABO GIDA TELLA	3559
113	KOFAI A/NUNKAI A	3549
113	KUNINI TOWN	1363
113	SIBRE	251
113	KPANTISAWA	1362
113	MAISAMARI	1366
113	KURMI	1364
113	SUKANNI	3560
113	LAU	248
113	MARARABA KUNINI	3553
113	ZING	254
113	BAMBUR	1343
113	NUKKAI	1372
113	JEN	1357
113	KAKARA	1358
113	PUPULE	1373
113	MAGAMI	3551
113	GEMBU	1352
113	YORROW	253
113	TELLA	3561
113	MAINA REWO	3552
113	GASHAKA GUMTI	1350
113	TUDUN WADA	3562
113	SARDAUNA	1376
113	YAKOKO	1383
113	SUNTAI	1378
113	GASSOL	1351
113	CHANCHANGI	1345
113	DORAWA	3541
113	UNGUWAN GADI	3563
113	YELWA B	3565
113	GINDURUWA	3544
113	MAYO GWAI/A.J OWONNIYI ESTATE	3554
113	SERTI	1377
113	SABO GIDA TELA	1375
113	NASSARAWA JEKA DA FARI	3556
113	USSA	1381
113	BARUWA	1344
113	MAYO LOPE	3555
113	JALINGO	3547
113	GIDIN DORUWA	1353
113	ATC	3537
113	JAURO YINU	1356
113	TELA	1380
113	MILE SIX	1369
113	NGUREJE	3557
113	ABUJA/MAYO DASA	3536
113	HOUSE OF ASSEMBLY	3545
113	IBI	1354
113	TAKUM	1379
113	BARADE WARD	3539
113	JAM	3548
113	BAISSA	1341
113	KARIM LAMIDO	1359
113	WUKARI	1382
113	MAYO-LOPE	1368
113	ARDO-KOLA	247
113	SABO GARI	1374
113	KOFAI B/NUNKAI B/AWONIYI QTRS	3550
113	PRESIDENTIAL LODGE	3558
113	DONGA	1347
113	SUNKANI	252
113	DAKA	1346
113	KONA	1361
113	NGUROJE	1371
113	LANKAVIRI	1365
113	GARBA CHEDE	1348
113	BALI	1342
113	YELWA A	3564
113	MARABA DONGA	1367
113	IWARE	1355
113	KASHIBILA DAM	1360
113	BAISSA/KURMI	3538
113	GASHAKA	1349
113	MONKI	1370
113	MUTUM BIYU	249
113	CHACHANGI	3540
113	YOKOKO	3566
113	GIDAN DOROWA	3543
113	NYSC CAMP	250
115	IKOTE EPENE	3406
115	INI	1222
115	OBOT AKARA	214
115	IKONO	213
115	ESSIEN UDIM	212
116	ESIT EKET	142
116	ONNA	147
116	IKOT  ABASI	144
116	MKPATENIN	3079
116	EKET	3077
116	IKOT ABASI	3078
116	NSIT UBIUM	146
116	MKPAT  ENIN	145
116	IBENO	143
116	EASTERN OBOLO	141
117	UBOT AKARA	5103
117	UKANAFUN	528
117	School Of Art and Science	5102
117	IKOT OSURUA	5086
117	ITU	571
117	NKAN UDE	5094
117	Housing Estate Ewet	5075
117	URUAN	529
117	ENWANG	5069
117	OKU IBOKU	5101
117	EKPARAKWA	5068
117	Military Office Iba Oku	5091
117	IBAKA	5076
117	Ewet Village	5073
117	ETIM EKPO	518
117	IBIAKU NTOKPO	5079
117	OBOT IDEM	5096
117	OKOBO	525
117	OKOITAH	5100
117	IKOT EBOM	5082
117	NDON EBOM	5092
117	ESSIEN  UDIM	5071
117	EASTERN OBOLO	5065
117	MBO	522
117	NDONUDUE	5093
117	AFAHA NSIT	5063
117	Uyo Market	5109
117	ITAM	5089
117	Akpan St.	5064
117	IBIONO IBOM	520
117	Iboko	5080
117	IBESIKPO ASUTAN	2117
117	IKOT ABIA	5081
117	UYO	5108
117	ABAK	517
117	IBESIKPO	5078
117	NSIT ATAI	523
117	UBOT IDEM	5104
117	UTUNG UDE	5107
117	NTUNG UDE	5095
117	EDIENE ABAK	5067
117	IKOT EKPENE	5083
117	EDIENE ABAK	5066
117	ETINAN	5072
117	IBENU	5077
117	ORUK ANAM	2118
117	Faha Oku Akpon	5074
117	IKA	521
117	ERIAM ABAK	5070
117	IKPE IKOT NKON	5088
117	IKOT EKWERE	5085
117	ODOT	5097
117	OKBO	5098
117	ORON	526
117	OKITAH	5099
117	UDUNG UKO	527
117	ETNAN	519
117	NSIT IBOM	524
117	UKPOM ABAK	5105
117	URUEFONG ORUKO	530
117	ITU MBO USO	5090
117	URE UKO	5106
119	BOGIJE	1298
119	TEMU	1340
119	IDUMOTA	3495
119	IMOBIDO	236
119	ISALE EKO	3500
119	ONOSA	1332
119	1004	3462
119	CROWN ESTATE	3480
119	MUSEYO	241
119	ODOMOLA	1327
119	OGUNFAYO TOWN	1329
119	EPE TOWN	1304
119	TAQWA  BAY	3529
119	ILEGE	235
119	BADORE	3474
119	SOIL CONSERVATION SPG	3527
119	BROAD STREET	3477
119	ILESAN	3499
119	MASSY	3511
119	UNIAGRIC	3533
119	APAKIN	230
119	FREE TRADE ZONE	234
119	LADOL  JETTY	1316
119	LEKKI	3507
119	POJA	3523
119	ADEBA TOWN	1289
119	NOFORIJA	1325
119	LISA VILLAGE	3508
119	MOKOPED	3513
119	BOLORUNPELU TOWN	1299
119	OTUNLA	1335
119	BABA ADISA	1297
119	AJIRAN	3469
119	ELERANGBE	1302
119	LISA TOWN	1320
119	CHEVRON	3479
119	ITAMARUN	3502
119	APONGBO	3471
119	AKODO	227
119	MAYFAIR GARDEN	1324
119	ABULE PANU	1288
119	GBOSERE	3490
119	DOLPHIN ESTATE	3483
119	IDUMAGBO	3494
119	TEMU VILAGE	3532
119	ABULE FOLLY	1287
119	IBOWON	3493
119	OKE ARIN	3517
119	SAGOPTEDO	1337
119	IBEJU AGBE	1309
119	ODO SHIWOLA	1326
119	ITAFAJI	3501
119	LAGBADE	1317
119	TARKWA BAY	3530
119	AGARAWU	3467
119	OKEIRANLA	3518
119	ELEMORO	1301
119	ILARA	1312
119	POKA	1336
119	ATLATIC HALL	1294
119	NAFORIJA	3514
119	LAKOWE	1318
119	ATLAS  COVE	1293
119	DANGOTE REFINERY	3481
119	DEBOJO TOWN	232
119	ONIRU	3522
119	EKO AKETE CITY	1300
119	IKOYI	3498
119	ONISHON	1331
119	BALOGUN	3476
119	ELEKO	233
119	KAIYETORO	1314
119	LEKKI TOWN	238
119	TIYE	246
119	VICTORIA ISLAND	3535
119	AWOYAYA	1296
119	TARQUA BAY	3531
119	AJAH	3468
119	SERVTRUST	3526
119	OSOROKO	1334
119	MINNA	3512
119	MAJODA	1322
119	ATLANTIC HALL	3472
119	SPG	3528
119	AGRIC	1290
119	ISE	2270
119	OKEGUN	1330
119	LADOL JETTY	3504
119	IGBOOYE	3497
119	EPUTU TOWN	1305
119	MAGBON SEGUN	240
119	BALOGUN	3475
119	DANGOTE REFINERY	3482
119	ITOKE	237
119	SANGO TEDO	3524
119	FOLU	1308
119	ELESE KAN	1303
119	IBEJU	3492
119	ATLAS COVE	3473
119	LAGOS ISLAND	3506
119	321	3463
119	ORUNMIJA	244
119	OLOWOGBOWO	3520
119	DANGOTE EFINERY	231
119	ELEKO BEACH 	3486
119	LAFIAJI	3505
119	BROAD STREET	3478
119	EREPOTO	1307
119	OFFIN	3516
119	IGBONLA	1310
119	KAJOLA	2276
119	LAKOWE GOLF	1319
119	ADENIJI ADELE	3465
119	AGARAWU	3466
119	ABIJO	1285
119	MARINA	3510
119	HFC	3491
119	OKEPOPO	3519
119	AIYETEJU	1291
119	AMEN ESTATE	229
119	ALASIA	3470
119	MAJEK TOWN	1321
119	322	3464
119	ILAMIJA	1311
119	IGANDO OLOJA	3496
119	EPE	3488
119	MAGBON ALADE	239
119	ODORAGUSHI	1328
119	ONIKAN	3521
119	AUGUSTINE UNIVERSITY	1295
119	TAKWA  BAY	1339
119	ORIMEDU	243
119	ALASIA OKUN	228
119	VICTORIA GARDEN	3534
119	ITA MAUN	1313
119	ALATISHE	1292
119	MAGBON	3509
119	OKUNRAYE	242
119	ABULE ADE	1286
119	SANGOTEDO	3525
119	ELETU	3487
119	MALETE ALAFIA	1323
119	EPE TEDO	3489
119	EREDO	1306
119	SOLU ADE	245
119	EJIRIN	3485
119	LA CA PAIGNE	1315
119	OBALENDE	3515
119	ORIBANWA TOWN	1333
119	DOSUNMU	3484
119	SHAPATI	1338
120	BAKARE FARO	4205
120	FESTAC COMMUNITY IV	4229
120	IYANA ILOGBO	4282
120	AKUTE	4177
120	EJIGBO ORINLE OWO	4222
120	SNAKE ISLAND	4355
120	MENDE	4302
120	IJU	4258
120	OWODE EGBEDO	4338
120	IJU ISAGA	4259
120	OWODE EGBADO	345
120	OPEBI	4330
120	ALLEN	4187
120	OJOTA	4313
120	AJEGUNLE BOUNDARY	4172
120	JORA BADIA CENTRAL	4286
120	OKE ODAN	4316
120	AHMADIYA	4168
120	OJOKORO	4312
120	IGBOBI	4243
120	IJESHATEDO	4251
120	ISHERI OKE	4275
120	UBOWO	4361
120	MURTALA MUHAMMED AIRPORT	4303
120	AREPO	4201
120	IBOGUN IFO	315
120	AMUKOKO ALABA ORO	4189
120	MEIRAN	4301
120	BODE THOMAS	4207
120	IGAJUN	4240
120	OKE-ODAN	341
120	AJEGUNLE	4171
120	KIRIKIRI PHASE	4292
120	DOKPEMU	4213
120	SUBERU OJE	4356
120	IKATE	4261
120	EGBEDA	4220
120	LUSUDA	4294
120	IGANMU	4242
120	MUSHIN	4304
120	OKO OBA AGEGE	4320
120	ASCON	4202
120	SURULERE	4357
120	BUNGALOW ESTATE	4208
120	OBANIKORO	4306
120	ISHERI OFIN	4274
120	EJIRI	4223
120	ANTHONY	4194
120	EJIRIN	310
120	ALAGBADO	4180
120	OTA	4336
120	AMUKOKO WEST	4192
120	OLOWOIRA	4324
120	SATELITE TOWN	4349
120	EJIGBO	4221
120	BADAGRY TOWN	4204
120	MAGODO	4297
120	COKER VILLAGE	4212
120	ORILE IGAMU	4333
120	SHOMOLU PEDRO	4353
120	ISHERI	4273
120	GBAGADA	4230
120	IDIROKO	316
120	NARFORIJA	4305
120	IGBOLOGUN VILLAGE	4244
120	KIRIKIRI	4290
120	IJOKO	4252
120	IJORA BADIA EAST	4254
120	ALABA	4178
120	IDI ARABA	4234
120	AKOKA	4176
120	IPONRI	4271
120	IKORODU	4264
120	AKINTAN	4175
120	FESTAC	4225
120	OYA ESTATE	4342
120	ISHERI OSUN	4277
120	ERIKITI	311
120	YABA/EBUTE META EAST	4363
120	ILAJE	4267
120	IJAKO	321
120	AMUKOKO NORTH	4191
120	IBASA	4232
120	AKESAN	4174
120	AMUKOKO EAST	4190
120	KETU ORISIGUN	4289
120	ABARENJI	4156
120	ABULE EGBA	4158
120	AJIDO	302
120	AJEROMI	4173
120	FESTAC COMMUNITY III	4228
120	OGBA	4307
120	IDI-IROKO	4236
120	ASESE	305
120	ATAN-OTA	307
120	KIRIKIRI INDUSTRIAL	4291
120	IJANIKIN	322
120	ADENIRAN OGUNSANYA	4161
120	OWODE ITORI	346
120	IBAFO	312
120	OFADA	338
120	OWODE	584
120	ISHERI OSHUN	4276
120	JOBBA	4285
120	OWODE YEWA	347
120	FESTAC COMMUNITY 1	4226
120	MAFOLUKU	4295
120	REDEMPTION CAMP  	4346
120	ATAN	306
120	OWORONSHOKI	4339
120	MARYLAND	4300
120	IJAGEMO	4245
120	ONIPANU	4329
120	IYANA OLOGBO	330
120	SURULERE CENTRAL	4358
120	ORILE IGANMU	4334
120	IFO	317
120	SANGISA	4347
120	IJORA BADIA NORTH	4255
120	ILASAMAJA	4268
120	OTO	4337
120	IJEBU-ALA	4247
120	LAWANSON	4293
120	OKE-IRA	4319
120	AJUWON	304
120	MOWE	574
120	AMUWO	4193
120	GRA	4231
120	OLOWORA	4325
120	ISAGA TEDO	4272
120	OJO	4311
120	AGUDA	4167
120	ILA OJA	4266
120	IMOTA	325
120	KETU	4287
120	AGBARA AGEMOWO	299
120	IFAKO AGEGE	4239
120	EGBE	4219
120	PAIM GROVE	4343
120	AGEGE	4164
120	OREGUN	4331
120	TINCAN ISLAND	4360
120	AJILETE(IDIROKO)	303
120	PALMGROOVE	4344
120	AGBOWA	300
120	TEJUOSHO	4359
120	AMUKOKO	4188
120	ALAGBA	4179
120	ISOLO	4278
120	OKO AFO	343
120	SITE C	4354
120	KETU MILE 12	4288
120	OGUDU	4309
120	IGBODU	319
120	IKOSI	324
120	IJORA	4253
120	OWOROSOKI	4340
120	CAPITO	4210
120	ATUNRASE ESTATE GBAGADA	4203
120	MAKOKO	4298
120	ANTHONY VILLAGE	4195
120	BADAGRY	308
120	IJEDODO	4248
120	OWOROSOKI L AND K	4341
120	AGO PALACE	4165
120	IGANDO	4241
120	OLUTE/NAVY TOWN	4327
120	APAPA CENTRAL	4197
120	ABORU	4157
120	OKE OSA	4318
120	ILUPEJU	4269
120	IJEDE	323
120	IJORA OLOYE	4257
120	EBUTE	4215
120	OJA ODAN	4310
120	OLOTA	4323
120	CISARI IGANMU ORILE SOUTH	4211
120	LAFARGE	333
120	IFAKO	4238
120	IJEGUN	4249
120	ODOGUNYAN	337
120	DOPEMU	4214
120	ABULE OJA	4159
120	JANKARA	4283
120	YABA	4362
120	OJA-ODAN	340
120	APAPA NORTH	4198
120	ILOGBO	569
120	IDI ORO	4235
120	OREMEJI IFAKO	4332
120	OSHODI	4335
120	FADEYI	4224
120	APAPA WEST	4200
120	IKEJA	4262
120	ITIRE	4279
120	MAKOKO EXTENSION	4299
120	IWORO	329
120	IYAMOMO	4281
120	IKEJA OBA AKRAN	4263
120	IYESI	331
120	IBESHE	314
120	APAPA	4196
120	EGAN	4218
120	ONIKE	4328
120	ABULE OKUTA	4160
120	OKE ODO	4317
120	TIGBO	350
120	EBUTE META WEST	4216
120	ALAKIJA/OLD OJO	4183
120	IJU WATER WORKS	4260
120	AGBELEKALE	4163
120	ITELE(AYETORO)	327
120	EGBIN	309
120	IGBOGILA	563
120	JIBOWU	4284
120	APAPA SOUTH	4199
120	ITORI	570
120	OYERO	348
120	KETU ITOKIN	332
120	AGBARA	4162
120	OGIJO	339
120	AGOSASA	301
120	EBUTE METTA	4217
120	IGBESA	318
120	LISA VILLAGE	334
120	OKE AFA JAKANDE	4314
120	AGODO	4166
120	IBESE	4233
120	OGBA AGUDA	4308
120	ALAPERE KETU	4185
120	BARIGA	4206
120	ITOKIN	328
120	FESTAC COMMUNITY II	4227
120	OLUTE	4326
120	C2 SARI IGANMU ORILE NORTH	4209
120	OLORUNSOGO	344
120	ALAGBADO	4181
120	IPAJA	4270
120	ALAKA	4182
120	OLODI APAPA	4322
120	OKE-OSAN	342
120	OKOTA	4321
120	EWEKORO	558
120	TOPO	351
120	SHOMOLU CENTRAL	4352
120	MOSIMI	335
120	OKE IRA	4315
120	IGBOGBO	320
120	AJAO ESTATE	4170
120	IDIMU	4237
120	IJAYE	4246
120	IBEFUN	313
120	IKOTUN	4265
120	OBELE	336
120	ALIMOSHO	4186
120	AHMADU BANAGU	4169
120	SANGO	4348
120	IJORA BADIA WEST	4256
120	IWAYA	4280
120	PAPA AJAO	4345
120	IPOKIA	326
120	SEME BORDER	349
120	IJESHA	4250
120	MAGODO	4296
120	ALAKUKO	4184
122	ABAGANA	109
122	Cemestry Area	2801
122	Industrial Layout	2806
122	NIBO	865
122	UKWULU	122
122	NANDO	575
122	ISIAGU	115
122	IFITEDUNU	2805
122	MBAUKWU	117
122	MGBAKWU	118
122	EZINATO	113
122	Obunagu Vill	2810
122	UGBENU	868
122	MBAUKWU (AKWA)	2808
122	ABBA	551
122	Asu Tech Area	2799
122	IGBARIAM	559
122	UMUDIOKA	124
122	AWKA	2800
122	ENUGWU-UKWU	863
122	UGBENE	867
122	High Court	2804
122	EBENEBE	112
122	ENUGWU-AGIDI	862
122	AMANUKE	111
122	IFITE-DUNU	114
122	ACHALLA	110
122	AKPONMU	2798
122	AMANSEA	861
122	ENUGU-AGIDI	2802
122	Izuocha Layout	2807
122	NIMO	120
122	NTEJE	578
122	NTOKOR	2809
122	URUM	126
122	AGULU UZIGBO	2797
122	ENUGU-UKWU	2803
122	NAWGU	119
122	AGULU	2233
122	NISE	121
122	UMUNNACHI	125
122	AWKUZU	552
122	UMUAWULU	123
122	OFEMMILI	866
122	NAWFIA	864
122	ISUANIOCHA	116
122	UKPO	2811
123	NNOBI	1674
123	NNEWI	4449
123	AWKA-ETIT	1664
123	NDIOKPALA-EZE	4443
123	NDIONWU	4444
123	OKO	2305
123	ADAZI-ANI	1656
123	ACHINA	1654
123	ICHIDA	1668
123	AKWA-UKWU	1660
123	AMAOKPALA	4433
123	AGULU	2234
123	ADAZI-ENU	4429
123	NGBOLOKWU	4445
123	NNENWE	4447
123	UKE	4460
123	NNEOKWA	4448
123	ORAIFITE	1677
123	ADAZI- NNUKWU	1655
123	AMORKA	1663
123	AKUKU OBA	4432
123	AMICHI	1662
123	OSUMEYI	4456
123	AJALLI	1658
123	OKOFIA  OTOLO	4453
123	UMUNZE	1682
123	IHIALA	1671
123	UKPOR	1679
123	OJOTO	1675
123	IDEANI	4436
123	UTU	1684
123	OTOLO	360
123	URUAGU	4466
123	UMUZE	4465
123	IKENJA OKIJA	4438
123	NKPOLOGWU	1673
123	OKOFIA	359
123	OFUMA	4450
123	AKPO	4431
123	OZUBLU	361
123	AGUATA	1657
123	NENI	1672
123	OZUBULU	4458
123	UGA	1678
123	AKOR	1659
123	IHEBOMSI	1670
123	ULI	1680
123	ISUOFIA	4440
123	UMUDIM	4463
123	UMAKULU	4462
123	NDIKELIONWU	4442
123	IGBO-UKWU	4437
123	OWENREZUKALA	4457
123	UFUMA	4459
123	NANKA	4441
123	UMUEZE	4464
123	OJOTO OFIA	4452
123	OREARI	4455
123	EZIOWELLE	1667
123	UMUCHU	1681
123	ULA	4461
123	OGBOJI	4451
123	AWKA-ETITI	4435
123	ISULO	4439
123	EKWULOBIA	1665
123	ORAUKWU	4454
123	ACHI	4428
123	AMCHI	4434
123	UNUBI	1683
123	NKPOLOGU	4446
123	ADAZI-NUKWU	4430
123	ALOR	1661
123	EKWULUMMIRI	1666
123	OKIJA	1676
123	IGBOUKWU	1669
124	Awka Rd	4505
124	AWKA	4504
124	IFITE-UKPO	4514
124	Akuzor Village	4496
124	OCHECHE UMUODU	4534
124	Umusiome Ibo	4569
124	UMUOBA OTUOCHA	4567
124	NTEJE	579
124	ABATETE	365
124	ONITSHA	4548
124	Onyeabo St	4549
124	OCHUCHE	1744
124	ANYAMELUM	1737
124	ORAMA -ETITI	1749
124	GRA II	4511
124	Amafor	4498
124	OGBAKUBA	1745
124	OTUOCHA	372
124	ANAKU	1736
124	New Market Rd	4521
124	Three Three I	4556
124	GRA III	4512
124	OBEAGWEG 2	1743
124	ASABA	4503
124	ASAA	4502
124	IFITE -OGWARI	1738
124	NKWELLE EZUNAKA	370
124	NKPOR	4525
124	OSAMALE	4551
124	MPUTU	1739
124	ONICHA OLONA	4545
124	Umuota	4568
124	AAWARA	4488
124	EJIOKU	4507
124	ONICSA UKU	4547
124	EZINIFITE	4509
124	IYIOWA ODEKPE	369
124	ODAKPU	4535
124	Ose II	4553
124	Akuzor Rd	4495
124	AGULERI	366
124	OSHITA	4554
124	UMUOJI	375
124	NANDO	576
124	ONICHA UGBO	4546
124	NNENWE	4530
124	UKPULU	4561
124	Ububa	4557
124	UKPOR AKPU	4560
124	OGBUNIKE	1746
124	Omagba Lyt Phase I & II	4544
124	Aforadike	4492
124	UMUNAYA EXPRESS	4564
124	UMUNNACHI	4566
124	OBOSI	4533
124	OGWU EPELE	1747
124	AMAESE	4497
124	Odume Layout I	4538
124	AKILI OGIDI	1733
124	Niger Bridge Head Rd	4524
124	UMUNAYA VILLAGE	4565
124	MDI 	4517
124	Odume Layout II	4539
124	OWASHI NKU	4555
124	ABBA	4491
124	OHITA	4543
124	AKILI OZIZA	1734
124	EKWU OHA	4508
124	OGBARU	4540
124	ABACHA	4489
124	MMIATA	4518
124	UBULU 	4558
124	Uruowulu Village	4571
124	AMAWBIA	4499
124	UMUOBA AWAM	1752
124	NGWO	4523
124	Oguta Rd	4542
124	AMICHI	4500
124	NADO	4519
124	AKATA-ORU	4494
124	NKPOR MARKET	4526
124	NZAM	1740
124	OMOR	1748
124	AKPAKA	1735
124	UBULU	4559
124	IGBARIAM	560
124	ATANI	367
124	ODEKPE	4536
124	Agulu  A	4493
124	Iweka Rd	4515
124	UMULERI	373
124	IDU MUJE	4513
124	OBEAGWEG 1	1742
124	UMUNYA	374
124	ANAWBIO	4501
124	OGIDI	4541
124	OROMA ETITI	4550
124	Ejikemi Qtrs	4506
124	UMUIKWU ANAM	4563
124	OSOMALLA	1750
124	UMUNAKWO	1751
124	Odoakpu	4537
124	NGURU	4522
124	UMUEZE ANAM	4562
124	NANKA AWKA	4520
124	UMUNACHI	589
124	NKPOR-AGU	4527
124	NSUGBE	371
124	NKWELE-OGIDIKA	4528
124	AWADA OBOSI	368
124	Uper Iweka	4570
124	NKWERRE	4529
124	ABAJA	4490
124	Ose I	4552
124	Zik A	4572
124	NRI	4531
124	OBA	1741
124	GRA I	4510
124	AWKUZU	553
124	Obompa	4532
126	UVBE	2888
126	EWOHIMI	930
126	OWA AGBOR	2880
126	SOBE	2882
126	Old Ilushi	2876
126	EKPOMA	929
126	WARREKE	2891
126	Ugbekun	2883
126	Ekosodin Village	2852
126	UGO	967
126	Ugbowo	2884
126	KOKO	2279
126	EHOR	926
126	G.R.A	2859
126	OPOJI	959
126	Oregbeni	2877
126	UTESI	971
126	EKIADOLOR	928
126	IGIEDUMA	937
126	EWURU  ESTATE AGBO	2858
126	OLUKU	958
126	Egbemije	2850
126	ABUDU	915
126	EGBA	925
126	OBAYANTOR	948
126	AGBEDE	917
126	WARAKE	972
126	OGBESE	2297
126	SABONGIDA- ORA	963
126	USELU	2887
126	OGWA	2301
126	IRUEKPEN	942
126	OBEHIE	2870
126	IRRUA	941
126	OTUO	2879
126	Ukpaja Quarters	2886
126	IGIEBEN	2863
126	Ohovbeokao	2874
126	IGARRA	2862
126	Ekenhaun	2851
126	NGUZU EDDA	2869
126	OKPELLA	956
126	OKUMODU	2875
126	OSSOSO	961
126	IGUEBEN	938
126	OGHEDE	2873
126	OKOMU	954
126	IBILLO	935
126	OLOGBO	957
126	ISIOHOR	2866
126	AFUZE	916
126	AKARAN	2846
126	Ebhuru Quarters II	2849
126	OGAN	950
126	OSSEE	2878
126	OGBA ZOO / OBA AKENZUA II	2871
126	Evbotube	2854
126	UROMI	969
126	GELEGELE	934
126	OKADA	953
126	Uhumwuimwu	2885
126	IGUOBAZUWA	939
126	WEPA WANO	2892
126	IYAMHO	943
126	OBEN	949
126	OWA-OYIBO	962
126	OKPEKPE	955
126	EBELLE	924
126	AUCHI	923
126	AGBOR	918
126	UWALOR	2889
126	EWU	931
126	AKARA	2845
126	EYAEN	932
126	OBARETIN	947
126	Ogbelaka	2872
126	EWATTO	2855
126	EWURU	2857
126	ABAVO	914
126	Ikpoba	2865
126	IVBIARO	2867
126	URHONIGBE	968
126	Ihogben	2864
126	USEN	970
126	Oyomon Quarters	2881
126	IDOGBO	2861
126	Ewemade Village	2856
126	FUGAR	933
126	Ebhuru Quarters I	2848
126	IYANOMO	944
126	OGUA	952
126	AGENEBODE	919
126	Etete	2853
126	UGBEGUN	966
126	IHOVBOR	940
126	AJAGBODUDU	920
126	UBIAJA	964
126	OSSE	960
126	AHOADA	2844
126	ANEGBETE	921
126	OBAGIE	946
126	AGO  AMODU	2843
126	BENIN	2847
126	IGBANKE	936
126	APANA	922
126	Uwelu	2890
126	UDO	965
126	OGHADA	951
126	EKEWAN BARRACKS	927
126	NIFOR	945
126	Iwogban	2868
128	NYANYA	2534
128	MABUSHI	2520
128	KARU (OLD)	2508
128	UTAKO	2547
128	IDU	2498
128	MAKERA	2523
128	USMAN DAM	79
128	SHINKAFI	2543
128	GARKI AREA 8	2491
128	NYANYA	2535
128	BASSA	2243
128	MARARABA	2525
128	SULEJA	2544
128	GARKI AREA 3	2489
128	KWA FALLS	2516
128	NASARAWA TOTO	685
128	NAI AIRPORT 	2529
128	KADO	2504
128	IDU YARD	2499
128	PEGI KUJE	76
128	UKE	77
128	DUTSE ALHAJI	2481
128	THREE ARMS ZONE	2545
128	PYAKASA	690
128	GWARIMPA	2495
128	NASSARAWA	2531
128	TOTO	2546
128	KUCHINGORO	2513
128	MODEL CITY	683
128	KURUDU	679
128	GAUBE KUJE	71
128	LOWER USMAN DAM	2519
128	KARU (NEW)	2507
128	ABUJA	2469
128	DAWAKI	665
128	DEI-DEI	2480
128	GWOSA	671
128	MOJODA	2528
128	JABI	2502
128	ALAGUNTAN COMMUNITY	2472
128	NEW NYANYA	686
128	LIFE CAMP	2518
128	BOLORI	2478
128	LOKOGOMA	681
128	SEA SIDE ESTATE	2542
128	OROZO	688
128	GALADIMAWA	668
128	JIKWOYI	673
128	WUSE ZONE 2	2550
128	ADO	661
128	GARKI AREA 1	2485
128	ABUGI	2468
128	CENTRAL BUSINESS DISTRICT	2479
128	GADAGBUKE/NAKUSE	666
128	IGBONLA EPE	2500
128	DAKWO	664
128	KUCHIKAU	74
128	ABUMET/KADO	2470
128	KARU	2506
128	UNIABUJA MAIN IDDO	692
128	WUSE ZONE 3	2551
128	NASARAWA	684
128	AUTA BALEFI	2476
128	MASHI	2527
128	ASOKORO	2474
128	GARKI AREA 7	2490
128	SAUKA	2541
128	MAITAMA	2522
128	WUSE ZONE 5	2553
128	ORITA MARUN	2538
128	F.C.T.	2483
128	GARKI	2484
128	BWARI	68
128	WUSE ZONE 4	2552
128	MAITAMA	2521
128	AKODO	2471
128	OLORA PALACE AREA	2537
128	GIDAN MANGORO	2492
128	SAUKA	2540
128	INTERNATIONAL AIRPORT	2501
128	WUSE ZONE 7	2555
128	GARKI AREA 11	2487
128	JAHI	672
128	ELEKO	2482
128	ROYAL GARDEN ESTATE	2539
128	KURNA	2515
128	GOSHEN CITY	72
128	KUBWA	2511
128	KUJE	2514
128	ODOMALA	2536
128	ALETA	662
128	NASSARAWA TOT	2532
128	GITATA	669
128	MARABA	2524
128	MASAKA	75
128	WUSE ZONE II	2556
128	LOKO	680
128	CAPITAL SCIENCE KUJE	69
128	GUDU	2493
128	KABUSA	2503
128	GARKI AREA 2	2488
128	CHITA	663
128	kuchigoro	677
128	KATAMPE	2510
128	KEFFI	573
128	SABON LUGBE	691
128	GALADIMA	667
128	WUSE	2548
128	WUSE ZONE 6	2554
128	ONE MAN VILLAGE/KORODUMA	687
128	NASSARAWA TOTO	2533
128	MARARBA	2526
128	IBEJU LEKKI	2496
128	GWAGWA	670
128	KAFE	2505
128	GARKI AREA 10	2486
128	KARSANA	676
128	NAKUSE	2530
128	KARIMO	675
128	KUGBO	678
128	USHAFA	78
128	WUSE ZONE 1	2549
128	LUGBE	682
128	AUTABALEFI	67
128	IDDO(UNIABUJA)	2497
128	LANGBASA	2517
128	KAGINI	674
128	ASOKORO	2475
128	ASO ROCK	2473
128	BERGER GARDEN ESTATE	2477
128	KARSHI	73
128	PANDA	689
128	GWAGWALADA	2494
128	DAKWA	70
130	MABERA IDI	4998
130	BODINGA	2070
130	MALAM MADURI	5003
130	OLD MARKET	5005
130	WURNO	494
130	SABON-BIRNI	2082
130	GADA	2073
130	FARFARU	4984
130	BINJI	2069
130	GORONYO	2075
130	BAGIDANE	4980
130	KWARE LGA	2081
130	YABO	495
130	SILAMI	5008
130	UNGUWAN ROGO	5012
130	ALI AKILU	4979
130	WAMAKKO	493
130	BARIKIN MARMATO	4981
130	TAMBUWAL	492
130	DANGE SHUNNI	2071
130	GIDAN IGWAI	4987
130	RABAH	490
130	ISA LGA	2079
130	MABERA GIDAN GWADABE	4997
130	KEBBI	4992
130	ILELLA	4989
130	TANGAZA	2084
130	FEDERAL SECRETARIAT QUARTERS	4985
130	DANGE	4982
130	TUSUN WADA	5011
130	GAWO NAMA	4986
130	SOKOTO	5009
130	KALAMBINA GIDAN MANUMA	4990
130	MAGAJIN GARI	5002
130	MABERA SHIYAR NASSARAWA	4999
130	KEBBE	2080
130	ILLELA	2078
130	RIJIYAN DORAWA	5006
130	KASARAWA	4991
130	GUDU	2076
130	MABERA TSOHON GIDA II	5001
130	MABERA GIDAN DAHALA	4996
130	SILAME	2083
130	TURETA	2085
130	DENGE	4983
130	SHAGARI	491
130	KWARE	4994
130	RUNJIN SAMBO	5007
130	GWADABAWA	2077
130	LOW COST GWIWA	4995
130	MALUFASHI	5004
130	DOGON DAJI	2072
130	SOKOTO NORTH/SOUTH	5010
130	GIDANMADI	2074
130	AMANAWA	2068
130	MABERA TSOHON GIDA 1	5000
130	HAJIYA HALIMA	4988
130	KET	4993
130	YAURI FLAT HOUSE	5013
132	IDOGUN	2585
132	ELEKOLE'S PALACE	2575
132	ERUWA	2576
132	USI	732
132	IGBARA ODO	706
132	IYIN	724
132	ADO EKITI	2557
132	IPOLE ILORO	2609
132	IMIKAN	2608
132	IGBARA ODO EKITI	2587
132	OTUN-EKITI	2631
132	OTUN	729
132	IFISIN	705
132	AYEE	80
132	OKE IGBALA	2622
132	GRA	2580
132	ODO ORO	2621
132	ONWARD	2628
132	AYETORO	699
132	AGBADO	693
132	ERIO	703
132	OMUO EKITI	2626
132	IJERO	711
132	ilokun	2604
132	ILAWE	717
132	IYIN  EKITI	2614
132	IWOROKO	2613
132	OYE EKITI	2633
132	IYEE	723
132	ODO OJA	2620
132	IGBOLE	707
132	EFON	700
132	OKEOSUN	2624
132	EFFON  ALAYE	2572
132	ILOKA	2603
132	OSI	2316
132	cocoa dev. unit area	2571
132	IKOYI IKORO	2601
132	STADIUM	2635
132	EFON ALAYE	2573
132	AWO	696
132	IKOGOSO	2595
132	OTUNJA	2632
132	IKORO	716
132	IKORO EKITI	2598
132	amuniklo	2562
132	IJAN	710
132	KAJOLA QUARTERS	2615
132	HAVANA QUATERS	2581
132	IKOYI 2	2600
132	ISE-EKITI	2611
132	federal polytechnic	2578
132	AYETORO EGBADO	2569
132	IGEDE	708
132	AMOYE GRAMMER SCHOOL	2561
132	AISEGBA EKITI	2559
132	IKOLE GENERAL HOSPITAL	2597
132	IKWO(FUNI)	2602
132	ARAMOKO EKITI	2564
132	AYEGBAJU	698
132	isolo	2612
132	ITAJI	721
132	ARAROMI	2566
132	idolofin	2586
132	IFAKI	81
132	IJERO EKITI	2592
132	IJOKA QUARTERS	2593
132	IKERE EKITI	2594
132	IKOGOSI	714
132	IJAN EKITI	2591
132	MOSHUDI	2617
132	ISAN	720
132	USI-EKITI	2636
132	ODO OJA	2619
132	ILOTIN	2605
132	ARAROMI	2565
132	ST. PETERS	2634
132	IKERE	713
132	ISE	2269
132	AISEGBA	694
132	ARAMOKO	695
132	ASIN	2568
132	ITAPA	722
132	OMUO	727
132	OYE	730
132	IDO EKITI	2584
132	IBARAM AKOKO	2583
132	OKEMESI	726
132	ORIN	728
132	OKE IRU	2623
132	ORIN-EKITI	2629
132	IBALE IKOYI	2582
132	AYEDE	697
132	ILUMOBA	719
132	ISABA	2610
132	IJESA ISU	712
132	IDO	704
132	MINE-CAMPU AREA	2616
132	OSIN-EKITI	2630
132	AZIKWE STADIUM	2570
132	omodowa	2625
132	IKOLE	715
132	AJOGBEJE QUATERS	2560
132	IGEDE EKITI	2590
132	EMURE	701
132	ODO ISE	2618
132	AGBADO EKITI	2558
132	FEHINTOLA ESTATE	2579
132	TEMIDIRE	731
132	ILUDUN-EKITI	2606
132	IKOYI 1	2599
132	ARAROMI	2567
132	ONITCHA	2627
132	ILOGBO	2268
132	ORA	82
132	USIN	2637
132	EJIGBO	2574
132	ODE	725
132	ILUDUN	718
132	ILUPEJU-EKITI	2607
132	EPE	702
132	ANAYE	2563
132	IGBONNA	2588
132	falegan estate	2577
132	IGOGO	709
132	IKOLE EKITI	2596
134	KUMO	3962
134	OBANGEDE	1553
134	OKEGWE	1556
134	ANYIGBA	1538
134	GENERAL HOSPITAL	3943
134	IBAJI LKJ	3944
134	ADOGO	1535
134	LOKOJA BYE PASS	3965
134	AJAOKUTA	1536
134	ERINRIN-ADE	3941
134	LOCAL GOVERNMENT SECRETARIAT	3963
134	G.R.A	3942
134	KAOJE	3954
134	KOTONKARFE	1551
134	IYA EGBEDE	3948
134	UGWU ALAO	1558
134	KABBA TOWN HALL	3952
134	DIKINA	3938
134	KARA	3955
134	KARD	3956
134	OKENE	1557
134	EKIRIN ADE	3940
134	ITAKPE	1546
134	JOBELE	3951
134	IBAJI	1543
134	IDAH	1544
134	OBAJANA	1552
134	EGUME	1542
134	IYA_GBEDE	1547
134	AYANGBA	3936
134	IGBEKEBO	3947
134	APAYAN	1539
134	OKEHI	2302
134	IYAMOYE	1548
134	KAJURU	3953
134	MAY ADOWA	3967
134	IYARA	1549
134	DEKINA	1541
134	ADOGI	3932
134	ALLOMA	1537
134	OKPO	2306
134	ABEJUKOLO	1534
134	DUDUGURU	3939
134	ANYANGBA	3935
134	AYETORO GBEDE	1540
134	MANGOGO	3966
134	ADUDU	3933
134	SIR JAMES OLORUNTOBA WAY	3969
134	COLLEGE OF AGRIC	3937
134	KOGI	3960
134	IYA-GBEDE	3949
134	KABBA	1550
134	IHIMA	1545
134	OGUGU	1555
134	OGORI	1554
134	LOKOJA	3964
136	OFFA	4469
137	ESSIE	3420
137	ORO	222
137	EYENKORIN	1246
137	MOPA	1266
137	OKUTA	1276
137	OKELELE	3451
137	OSI	2317
137	IDOFIAN (NNAFUFE & ARMTI)	1251
137	OMU ARAN	1277
137	KWARAPOLY	1262
137	EDN	3416
137	SABON LINE AMILEGBE	3456
137	SHARE	225
137	APATA YAKUBA	1236
137	AFON	217
137	KAINJI	3439
137	OKE OYI	221
137	EDIDI	3415
137	JEBBA	1257
137	EJIBA	1242
137	ILESHA BARUBA	1253
137	MALETE	220
137	CHIKANDA	3414
137	EGBE	1241
137	EFFON AMURO	3417
137	OBBO AIYEGUNLE	1268
137	OKE ONIGBIN	1274
137	MAGAMA	3444
137	SHAO	224
137	ERIN ILE	3419
137	OKO	2304
137	JATTU	3437
137	YIKPATA	1284
137	KOSUBOSUN	3441
137	OBBO AYIEGUNLE	3448
137	SWACHI	1281
137	LAFIAGI	1263
137	ADEWOLE ESTATE	3408
137	NNPC PPMC	3447
137	UNILORIN MAIN CAMPUS	3460
137	SONGA	3457
137	PADA	1278
137	TSONGA	1282
137	OLOJE	3453
137	ERUKU	1244
137	OLD YIDI	3452
137	ODOERE	1271
137	JEBBA DAM	3438
137	OGBOJI	3449
137	OFFA	1272
137	BODE SA'ADU	3413
137	TAIWO	3459
137	NEW BUSSA	1267
137	IDFIAN	3423
137	ESIE	1245
137	IDOFIAN	3424
137	BABALOMA	3411
137	OKEPAGE	1275
137	AIYETORO	3409
137	ILESA IBARUBA	3428
137	ISAPA	1255
137	NNPC DEPOT	2290
137	KAIAMA	1258
137	MOKWA	1265
137	IPEE	3434
137	BABOKO	3412
137	ILORIN	3430
137	PATEGI	1279
137	EFO AMURO	1240
137	MURITALA ROAD	3445
137	IDOFIAN (NCAN & ARMTI)	3425
137	KAINJI/NEW BUSSA	1259
137	OKE ODE	1273
137	BODE SAADU	1239
137	GAA AKANBI	3422
137	ISTANBUL	1256
137	KOSUBOSU	1261
137	AJASEPO	218
137	BACITA	1237
137	G.R.A	3421
137	AL HIKMAH UNIVERSITY	3410
137	ILOFA/ODO OWA	1254
137	GBUGBU	1249
137	ODO ERI	1270
137	GBARARA	1247
137	GURE	1250
137	NIGER	3446
137	EJINE	1243
137	IJAGBO	3427
137	OTTE	223
137	ERINLE	219
137	MAFA	3443
137	SUNTI SUGAR COMPANY	1280
137	BALLAH	1238
137	IGOSUN	3426
137	GBASORO	1248
137	KULENDE	3442
137	OMUPO	3454
137	JANTU	3436
137	ISANLU	3435
137	KORO	1260
137	GAMBARI	2252
137	OBBO ILE	1269
137	IGBAJA	1252
137	UITH	226
137	ABDUL AZEEZ	3407
137	YASIKIRA	1283
137	EMIR'S PALACE	3418
137	PAKATA	3455
137	LUBCON DEPOT	1264
137	OKE IGOSUN	3450
137	STADIUM RD. GBALASA	3458
139	New Layout	2662
139	OBEAGU	764
139	UGWULANGWU	780
139	ONEKE	2673
139	G.R.A	2650
139	NKWO EGU	2664
139	EDDA	741
139	IKWO/ FUNI	751
139	OKOTO/EVENGAL CAMP	2671
139	EZZA UMUOGHARU	745
139	ISU	2657
139	IBOKO	749
139	OZZIZZA AFIKPO	776
139	IKWO(FUNI)	2652
139	ONITCHA	2675
139	NOYO	761
139	ONUNWEKE/MARIST BROTHERS	772
139	IZIOGO	755
139	NTEZI	762
139	UKAWU	781
139	ODUDU(RANCH)	766
139	AFIKPO NORTH	735
139	ONICHA	2674
139	Enugu-Ogoja Expr.	2649
139	OKPOSI OKWU	768
139	SHARON NYSC	2680
139	ODUDU	765
139	UWANA POLY	2684
139	IGBAGU IZZI	750
139	AGBA	736
139	IKOM	2264
139	AFIKPO	2641
139	Enugu Exp Rd.	2648
139	AFIKPO-SOUTH	2643
139	INYIMAGU	753
139	OKPOSI	2311
139	OUEBONYI   	2677
139	AFI BARACK	2640
139	YAHE	2325
139	YALA	2327
139	SHARON	777
139	INYERE	752
139	ISHIELU	2656
139	ONUEKE	771
139	OKPOSI OHOZARA	2672
139	UBURU	778
139	AKAEZE	2645
139	ISU/ONITCHA	754
139	UWANA AFIKPO	2683
139	UGBODO	779
139	EDDA/OWUTU	2647
139	EFFUM	742
139	RANCH	2679
139	OKPOMA	2308
139	IKWO/FUNI	2654
139	Pressco Junction	2678
139	NKWOEGU(BARRACK)	760
139	AFIKPO- NORTH	2642
139	AGUBIA	737
139	EZILLO	743
139	IKWO/FUNI	2655
139	UWANA	2682
139	ORIUZOR	773
139	AZOBODO	2646
139	NWAOFE	2666
139	AMASIRI	739
139	IKWO/FUNI	2653
139	EZZAGU	746
139	Udensi St	2681
139	OKPUITUMO	769
139	EZZA PRESCO	744
139	ABAKALIKI	2638
139	Nkaliki Rd	2663
139	NGUZU EDDA	759
139	EZZAMGBO	747
139	IKWO	2651
139	NDUFU ALIKE IKWO	757
139	OWUTU EDDA	775
139	OGOJA	2298
139	EZZAMGBO 135	748
139	Mbukobe	2660
139	AJAGBAODUDU	2644
139	ABAOMEGHE	733
139	Ndiaguo	2661
139	NGBO	758
139	UWANA/POLY	782
139	AKPUOHA	738
139	ONUEBONYI	2676
139	NWOFE	763
139	ACHIEGU	734
139	OHAOZARA	2670
139	IYABA	2658
139	OKOTO/EVENGAL CAMP.	767
139	OBIOZARA	2667
139	Abakpa	2639
139	EBUNWANA	740
139	Kpiri-Kpiri	2659
139	Ntezi Aba	2665
139	OTAM NDIEZECHI	774
139	Ogbaga Rd	2669
139	NDUBIA	756
139	OKWOR NGBO	770
141	KIRI-KASSAMMA	1071
141	GUMEL	1065
141	YANKWASHI	1080
141	INTERNET AREA	3061
141	GURI	1066
141	MAKWALLA	3067
141	DABANTU	3054
141	MAIGATARI	1073
141	FAGOJI	3055
141	 ANDAZA	3052
141	GARKI	1064
141	GWIWA	1067
141	CENTRAL MARKET	3053
141	GARKO	3058
141	BIRNIWA	1060
141	SABON GARIN ZAI	3072
141	TAURA	1079
141	HADEJIA	1068
141	MALAM MADORI	1074
141	KAUGAMA	1070
141	SABUWAR MARINJUWA	3073
141	POLICE HEADQUARTERS	3070
141	POLICE BARRACKS	3069
141	BIRNIN KUDU	139
141	JAHUN	140
141	G.R.A	3056
141	BUJI	1061
141	KIYAWA	1072
141	KACHAKO	3062
141	AUYO	1059
141	NEW G.R.A	3068
141	GWARAM	2259
141	GOVERNMENT HOUSE	3060
141	KIRIKASAMA	3064
141	RONI	1077
141	RINGIM TOWN	3071
141	RINGIM	1076
141	TAKUR QUATERS	3074
141	DUTSE	1062
141	BABURA	2241
141	GAGARAWA	1063
141	SULETANKARKAR	1078
141	GAZULMARI	3059
141	MIGA	1075
141	KALGO VILLAGE	3063
141	KOFAR GABAS	3065
141	MAJEMA	3066
141	GALDIMAWA	3057
141	KAFIN HAUSA	1069
143	KANKARA	572
143	DUTSINMA	1508
143	HOTORO	3872
143	KOFAR AREWA	3881
143	JABIRI	3874
143	RAHAMAIMA	3896
143	DAN DUTSE	3859
143	KUSADA	289
143	MANI	290
143	POLICE BARRACKS	3895
143	BATSARI	1506
143	BAURE	277
143	INGAWA	3873
143	LGA SECRETARIAT	3887
143	FILIN KALLO	3865
143	DUTSI MA	3863
143	DANDANGORO	3860
143	UNGUWAR DAU	3908
143	MMIATA	3892
143	AJIWA	1503
143	KATSINA	3879
143	GRA	3871
143	SABONB FEGI	3899
143	EMIRS PALACE	3864
143	TUNDUN WADA	3906
143	KOFON KARFE	3885
143	UNGWAR MAGINA	3912
143	UNGUWAR TARNAWA	3909
143	BATAGARAWA	1505
143	BABBAR RUGA	1504
143	MASHI	291
143	KAITA	286
143	MALADOWA	3891
143	GARIN TANDU	3869
143	KOFAR BARU	3882
143	TUDUN IYA	3904
143	BINDAWA	278
143	DANJA	555
143	TUDUN WADA	3905
143	KANTI	3875
143	LOW COST	3888
143	SANDAMU	294
143	MATAZU	292
143	SHINKAFI	3903
143	UNGWARUWAR MATOYA	3913
143	DUTSI	284
143	NAWGU	3894
143	DANKAMA	280
143	KAYAUKI	3880
143	MUSAWA	293
143	SABON LAYI	3898
143	SAFANA	3900
143	DUTSEN REME	3862
143	KASTINA RACE COURSE	3878
143	SHAGARI QUARTERS	3902
143	KUSUGU HALL	3886
143	UNGUWAR DAHIRU	3907
143	DUTSEN TSAFE	283
143	KANKIA	287
143	FUSKAR YAMMA	3867
143	BARSARI	3855
143	KOFAR MARUSA	3883
143	DADARA	3857
143	KAROFI	3876
143	MAGAMA	3889
143	KOFAR SAMRI LAYOUT	3884
143	SABARI GARI	3897
143	ZANGON DAURA	296
143	MAI-ADUA	1511
143	DADDARA	279
143	UNGUWAR TUKUR	3910
143	FUSKAR GABAS	3866
143	DIDAN  MUTUMDAYA	3861
143	CHARANCHI	1507
143	BCJ	3856
143	JIBIA	1509
143	MAKERA	3890
143	KASTINA	3877
143	AJIWALE	3854
143	NASSARAWA	3893
143	DANMUSA	281
143	GRA	3870
143	MALUMFASHI	2285
143	DAURA	282
143	UNGWAR GANGAREN RAFIN KASA	3911
143	JIKAMSHI	1510
143	SHARGALLE	295
143	SHAGALLE	3901
143	DAMMARNA	3858
143	UNGWARUWAR MUSA	3914
143	GARAMA	3868
143	RIMI	1512
143	KURFI	288
143	GIDAN MUTUM DAYA	285
145	IFO IBOGUN	2419
145	ADO-ODD	2401
145	IDIABA	2418
145	OLODO-KILA	61
145	AYETORO EGBADO	2409
145	IGAN ALADE	2420
145	IKOPA/IAWO-ONIGUNU-DOGO	2431
145	OSIELE	2462
145	OLORUNDA	62
145	ILARA (YEWA)	2432
145	SHAGAMU	2466
145	PAPALANTO	66
145	ILEWO-ORILE	56
145	LAFENWA	2443
145	IJEBU-EAST	2422
145	ITORI	2271
145	IMASHAI	57
145	AGO OKO	2403
145	ONIGBEDU	63
145	ONIKOLOBO/GRA EXTENSION	2460
145	MODAKEKE	2445
145	OWODE EGBA	2464
145	AGODI	2404
145	AJEROMI	2406
145	IGAN-ALADE	646
145	AYETORO-EGBADO	51
145	OLOMORE	2457
145	ADEBA	2399
145	IBARA	2413
145	ADATAN	2398
145	OBA-ERIN	655
145	IJEBU-ODE	2426
145	OJOKODO/IDO AWE	2452
145	AJEBO	645
145	OKE OKO	2454
145	IWOYE-KETU	652
145	IBORO	54
145	IBEREKODO/AKOMOJE	2416
145	IJEBU-OGBERE	2427
145	TOTORO/OWU/IJEJA/ITORY	2467
145	IGAN OKOTO	2421
145	ITOKO	2440
145	MAWUKO	654
145	ILARO	592
145	OKE-MOSAN	2455
145	OWIWI	659
145	ABEOKUTA	2397
145	AIYETORO GBEDE	2405
145	OWODE	2463
145	IBARA ORILE	2414
145	NEW NYANYA	2446
145	ORILE- ILUGUN	64
145	IRO	651
145	OKE ILEWO	2453
145	ISAGA-ORILE	58
145	OLUWO	2459
145	OLODO KILA	2456
145	OLORUNSOGO	2458
145	ISHAGA ORILE	2439
145	IJEBU-MUSHIN	2425
145	ILARA(YEWA)	648
145	AJURA	591
145	OBAFE	656
145	ASU	50
145	IJOGA-ORILE	55
145	IJEBU-IFE	2423
145	JEMO	2441
145	ADO ODO/OTA	2400
145	OBAFEMI- OWODE	59
145	ODEDA	60
145	IBESE	53
145	KUGBO	2442
145	IASBO	2411
145	IJEBU-ORU	2428
145	IJOGA ORILE	2429
145	MAKINDE	2444
145	ORILE-ILUGUN	2461
145	OBAFEMI OWODE	2448
145	ONIHALE	658
145	OWODE-EGBA	65
145	IGBOGILA	562
145	EWEKORO	557
145	IJEBU-IGBO	2424
145	OBOSI	2450
145	GRA	2410
145	AWODE EGBA	2408
145	OWODE-IDIEMI	660
145	IMEKO	650
145	ARO	2407
145	IBAGWE	2412
145	IGAN-OKOTO	647
145	IBARA/GRA	2415
145	IBARA-ORILE	52
145	OCHECHE UMUODU	2451
145	IMALA	649
145	OBANTOKO	2449
145	MOWE	2287
145	KOBAPE	653
145	OBA-ERIN(OBA)	2447
145	IBULE	2417
145	OLORUNSOGO(POWER PLANT)	657
145	AGBOMEJI	2402
145	OGUNMAKIN	2300
145	ISALE IGBEIN	2438
145	QUARRY	2465
146	LIKOSI	4971
146	SAPADE	488
146	SIMAWA	4977
146	SOTUPO	4978
146	SABO	4975
146	SAGAMU	4976
146	ILARA-REMO	479
146	ODE-LEMO	485
146	ISHARA-REMO	483
146	ODEDA	4972
146	OGERE REMO	4974
146	IJOKUN	4970
146	OGBERE REMO	4973
146	IROLU-REMO	482
146	IPARA-REMO	481
146	LIKOSI-REMO	484
146	IJEBU-AIYEPE	4969
146	IKENNE-REMO	2065
146	AIYEPE-REMO	476
146	ODE-REMO	486
146	WAPCO	2067
146	SOTUBO	489
146	FLOWERGATE EXPRESSWAY	478
146	ILISHAN-REMO	480
146	ODOGBOLU	487
146	AKAKA-REMO	477
146	IPERU	2066
147	IJEBU-WATERSIDE	3372
147	IJEBU-ITELE	3367
147	IJEBU  IFE	3358
147	IJEBU-ORU	3371
147	MOBALUFON	3388
147	AGORO	3351
147	SABO	3405
147	IJARI/OGBOGBO AREA	3357
147	IMAGBON	211
147	OWU-IKEJA	3404
147	J4/J5	3386
147	IJEBU IMUSHIN	207
147	IWADE AREA	3383
147	ILESE	3373
147	IJEBU ODE	3360
147	IDOWA	203
147	ITELE	3382
147	AGO IWOYE	1217
147	IDOMILA	3355
147	IMODIMOSAN	3376
147	LATOGUN	3387
147	IJEBU OGBERE	209
147	IJEBU-MUSHIN	3369
147	OMU-IJEBU  	3399
147	IJAGUN	1218
147	OGERE REMO	3395
147	ISASA POROGUN AREA	3379
147	ONIRUGBA AREA	3400
147	IWESI VILLAGE	3384
147	IJEBU-IGBO	3365
147	OKUN-OWA\t	3398
147	ORUU	3401
147	IJEBU EAST	1219
147	OSIMORE	3402
147	ABIGI	1216
147	OGBERE	3393
147	ISHONYI-IJEBU	3380
147	IJEBU MUSHIN	3359
147	IJEBU IGBO	206
147	IJEBU-IFE	3364
147	OSOSA	3403
147	IJEBU-ODE	3370
147	ATAN-IJEBU	3352
147	IDOMOWA	3356
147	IBIDO	3354
147	IJEBU IFE	205
147	IJEBU WATERSIDE	3361
147	IJEBU ORU	210
147	IMAWEJE	3374
147	IJEBU-EAST	3363
147	IJEBU WATER SIDE	1220
147	IBEFUN	3353
147	IJEBU-IMUSHIN	3366
147	ODO-EPO	3390
147	OKUN-OWA	3397
147	IJEBU ALA	204
147	MOLIPA	3389
147	IJEBU-ALA	3362
147	IJEBU-JESA	3368
147	IMORU	3377
147	IREWON	3378
147	OGERE	3394
147	IJEBU ITELE	208
147	ODOLEWU	3391
147	IKANGBA	1221
147	OKE- OWA AREA	3396
147	ISONYIN-IJEBU	3381
147	IWOPIN/WATERSIDE	3385
147	OGBA/IMAWEJE	3392
147	IMODI-IJASI	3375
148	AJILETE	4803
148	ADALEMO	4799
148	ERINKO	4807
148	IJOKO OTA	4818
148	IGBOGILA	4815
148	TAMARK ENG /G.W HOTEL/OTA WATE	4843
148	IDI ROKO\t	4809
148	IJAMIDO	4816
148	MEFUN RD / BABY O	4826
148	OWODE ITORI	4838
148	ARAROMI	4805
148	IFO IBOGUN\t	4812
148	ORUBA QTRS	4834
148	OTA-IDIROKO RD/TOMORI	4835
148	ATAN/OTA	4806
148	ADO-ODO OTA	4801
148	JOJU	4824
148	OLOTA PALACE/OTUN	4833
148	OLD IYANRU/IJANAGANG	4832
148	JIBOWU	4823
148	OTTA	4836
148	OWODE-IDIROKO	4839
148	ADO OTA/OTA	4800
148	IDIROKO RD / OJUORE	4810
148	IFO\t\t	4813
148	ITELE (AYETORO)	4822
148	OWODE IBESE	4837
148	ABEBI/OKESUNA	4798
148	AFOBAJE ESTATE/AGBALA OBANIBAS	4802
148	IJANA QTRS/OKE OYINBO/MEFUN	4817
148	TEMIDIRE	4844
148	IPAMESAN	4820
148	OBASANJO FARM	4828
148	OBASANJO FARM	4829
148	OJABI QUARTERS	4830
148	AKILO QUARTERS	4804
148	IGBESA	4814
148	SANGO OTA	4841
148	SANGO OTTA	4842
148	IPOKIA	4821
148	ILOJE	4819
148	NEW IYANRU	4827
148	PILO	4840
148	IDI IROKO	4808
148	KETERE	4825
148	OKE ODAN ROAD 	4831
150	ILUJU	1727
150	IYA-OJE	364
150	KISHI	1730
150	OGBOMOSHO	4479
150	UMUNEDE	4487
150	SAANU-AJE	4482
150	IWOFIN	1729
150	IGBOYI AREA/BAPTIST THEOLOGICA	4475
150	IRESA	1728
150	ISEYIN	4476
150	GAA MASIFA	4473
150	AYEDAADE	4472
150	GAMBARI	2253
150	IRESA-ADU	362
150	EGBEDA	2247
150	IKOSE	2266
150	APAKE AREA/OKELERIN	4471
150	IKOYI-ILE	1726
150	SOUN PALACE OSUPA	4484
150	IGBON	1725
150	OOLO	1732
150	OUT	4481
150	AJE-IKOSE	1719
150	ABAA	1716
150	ELEGA	1722
150	IGBOHO	1724
150	ODOOBA	1731
150	AJASE	1718
150	ARINKINKIN	1720
150	SABO MOTOR PARK	4483
150	TEWURE	4486
150	AJAAWA	1717
150	AJASE IPO	4470
150	IGBETI	1723
150	IGBOYI AREA/BAPTIST THEOLOGICA	4474
150	AROJE	1721
150	IRESA-APA	363
150	ONIPAANU	4480
150	STADIUM AREA/OYO NORTH	4485
150	IKOYI	2267
150	NITEL OFFICE/OLUODE LAYOUT	4478
150	OKO	582
150	LAUTECH	4477
151	OLODO IWO RD	3312
151	ORILE OWU	1203
151	SAKI	2318
151	ORILE ILUGUN	195
151	OLUNLOYO/AKANRAN	3317
151	OJEOWODE	1200
151	AGBENI	3227
151	MONIYA	1197
151	IRESA DU	3283
151	AYETE	1185
151	GBENLA/OLD IFE RD	3259
151	AKINYELE	184
151	SAPETERI	1204
151	AGO-AMODU	1174
151	OLOMI/ODO OBA	3314
151	KILA	593
151	APANPA	1182
151	CHALLENGE	3250
151	AYETE VILLAGE	3246
151	IGANGAN	1190
151	OLODO	192
151	OMI ADIO	193
151	IBADAN	3261
151	IDI AYUNRE	3268
151	ORIN-OWU	3321
151	ELEYELE	3255
151	IDI APE	3267
151	IDI-ATA	1189
151	DUGBE	3252
151	OJOO	3306
151	IDIAYUNRE	3271
151	LALUPON	191
151	QUARRY-LAG/IBA EXP	3323
151	YEMETU/OJE/OKE/AREMO	3331
151	EGBEDA	3254
151	AMOLOKO	3238
151	SAKI	2319
151	MOLETE	3296
151	ADAMASINGBA/EKOTEDO	3225
151	FELELE/OLORUN-SOGO	3257
151	ALAKO VILLAGE	3237
151	ELEYELE-OKO VILLAGE	3256
151	ERUNMU	188
151	OLORUNDA ABA	1202
151	PARAKOYI	3322
151	IBEITO	3264
151	ARULOGUN	1184
151	AREMO/ADEKILE	3243
151	LAGUN	190
151	OLUYOIE/NEW ADEOYE/ORITA CHALL	3318
151	ERUWA	1187
151	IKIRE	565
151	OGBOORO	1198
151	IJOKODO/ELEYELE	3277
151	OBAN	3300
151	AYO ALAAFIN	3248
151	IDI-ATA VILLAGE	3270
151	JERICHO/IDISHIN	3291
151	ALAKO	1179
151	RING RD/OSOSADI	3324
151	APETE-AWAOTAN	1183
151	ABA-OLOHAN	181
151	AJIBODE/IITA	3231
151	OLOGUNERU	1201
151	IJAYE	1192
151	AKANRAN	183
151	AJODA-NEW TOWN	3232
151	LAGOS TOLL GATE	3293
151	OGBAKUBA	3304
151	TAPA VILLAGE	3330
151	ABEBI/IDIKAN/OKESENI	3224
151	ODINJO/ACADEMY	3301
151	ORANYAN/ELEKURO	3320
151	OGUNGBADE	1199
151	OLUYOLE	3319
151	IFEWARA	3273
151	IRETAMEFA	3284
151	IGANGAN VILLAGE	3274
151	IRELE	3282
151	ABANLA	3223
151	MORE PLANTATION	3297
151	ABA EDUN	1172
151	AGUGU/OREMEJI	3230
151	ADO AWAYE	3226
151	AJANLA FARMS	1176
151	AKUFO VILLAGE	3234
151	IDI- AYUNRE	3269
151	IDERE	2261
151	SALVATION ARMY/INALENDE	3327
151	AKUNLEMU/AGBOYE	3235
151	OKE ADO	3307
151	ABA NLA	1173
151	ASEJIRE	3245
151	NEW BODIJA/IKOLABA/AGODI	3298
151	IJAYE VILLAGE	3276
151	APATA GANGAN/OLD ONA	3241
151	ANOWO VILLAGE/ALOMOMASIFALA	3239
151	IYAGANKU/OKEBOLA	3288
151	DELET	3251
151	LANLATE	1195
151	OSENGERE	196
151	ITA-ELEWA	3286
151	DUGBE/LABAOWO/FOKO	3253
151	IDERE	2260
151	IDERE VILLAGE	3266
151	ALOMAJA	1180
151	MOKOLA	3295
151	ALAKIA/MONATAN/PDC ESTATE	3236
151	IDDO	3265
151	OMI-AIDO	194
151	IKOYI	568
151	IWO RD/BASORUN/AGODI GRA	3287
151	IGBETI  	3275
151	iyanganku/okebola	3290
151	OLORUNDA-ABA	3316
151	NEW IFE ROAD	3299
151	IGBOORA	1191
151	ILERO	1193
151	AKOBO/ODOGBO/ARMY BARRACKS	3233
151	ELEYELE-OKO	1186
151	IFETEDO	3272
151	ODUOKPANI	3303
151	SABO/OKE ADO	3326
151	SECRETARIAT/OLD OYO RD	3329
151	IDDO-ERUWA	1188
151	AMULOKO	1181
151	EJIOKU	187
151	OLD BODIJA/U.C.H/MOKOLA	3311
151	AJODA	182
151	OKOLO VILLAGE	3310
151	AKUFO	1178
151	IYANA-OFFA	3289
151	OKE BOLA	3309
151	ILUGUN	3280
151	IKOSE	567
151	RING ROAD	3325
151	AYEYE	3247
151	SANGO/MOKOLA	3328
151	OLOHUNDA ABA	3313
151	GBELEKALE/OJA IGBO	3258
151	LAGUN VILLAGE	3294
151	OKE ADO/CHALLENGE/MOLETE	3308
151	BODIJA	3249
151	IDI-AYUNRE	189
151	ISOKAN LOCALO GOVT	3285
151	ARULOGUN VILLAGE	3244
151	AGODI	3229
151	MAYA	1196
151	IBADAN POLYTECHNIC/UNIVERSITY 	3262
151	AGO-ARE	1175
151	OGUNGBADE VILLAGE	3305
151	TAPA	1205
151	IYANA OFFA	1194
151	OLOROGUN VILLAGE/AMOLAJE	3315
151	QUARRY	594
151	APANPA VILLAGE	3240
151	APOMU	185
151	IBADO	3263
151	KUDET/ILETUNTUN	3292
151	OGUNMAKIN	580
151	APETE-AWOTAN	3242
151	ODO ONA OGA TAYLOR	3302
151	AGOBWO/OROGUN/SAMONDA	3228
151	AKINGBILE	1177
151	CRIN	186
152	APAARA/BALOGUN	4851
152	KOSO	4863
152	OYO ALAAFIN	4870
152	SEPENTERI	4874
152	OYO TOWN	4871
152	ISOKUN	4861
152	IWERE-ILE	1838
152	OKAKA	1842
152	OKE APO/AJAGBAA/GAA	4867
152	IPAPO	1836
152	ELEGA	4853
152	MOGBA/IYAJI	4865
152	IROKO	1837
152	AWE	2240
152	AKUNLEMU/AGBOOYE	4850
152	AARE OGO/ODOARO	4845
152	IGBOJAYE	1832
152	ADO-AWAYE	1827
152	IGBO-ORA	4855
152	KOMU	1840
152	IYALAMU/OKE OLOLA	4862
152	TEDE	1845
152	AHIPA/ISALE OYO	4848
152	OWODE	4869
152	OTU	1844
152	OKOMU	4868
152	SAKI	4872
152	AKINMORIN	1828
152	AGO  AMODU	4846
152	OKE AAFIN	4866
152	KOSOBO	4864
152	OGBORO	1841
152	ELEJA	1829
152	IGANNA	1831
152	ISEYIN	463
152	ARAROMI/MOBOLAJE	4852
152	IJAWAYA	1833
152	JOBELE	1839
152	FASOLA	4854
152	SAKUTU/SABO	4873
152	ISAALE OYO/OGBEGBE	4857
152	FIDITI	1830
152	IJIHO	1834
152	ISELE BASOORUN/ADESHINA	4858
152	ILAKA/ARAODI	4856
152	ILORA	1835
152	OKEHO	1843
152	YEGHE	4875
152	AGO  ARE	4847
152	AKEETAN TITUN	4849
154	BOTO	872
154	HANAFARI	890
154	Lushi	2832
154	ATBU PERMANENT SITE	869
154	GANJUWA	886
154	Kofar Wambai	2829
154	SAKWA	904
154	Kofar Jahun	2828
154	Y/DUGURI	2841
154	DARAZO	878
154	Kofar Wasa	2830
154	HAS	2823
154	LIMAN KATAGUM	128
154	JAMA?ARE	2824
154	DANGADA	2819
154	NINGI	2834
154	KATAGUM	2827
154	LERE	2281
154	BAUCHI	2816
154	DISINA	880
154	GOBIYA	888
154	DASS	879
154	FAGGO	884
154	TAPSHIN	907
154	LANZAI	2831
154	TAPHIN	2838
154	Abubakar Tafawa Balewa Univers	2812
154	Army Barracks	2814
154	RISHI	903
154	KARI	894
154	Abubakar Umar State Secretaria	2813
154	MISAU	898
154	YELWA	2842
154	WARJI	2840
154	SORO	906
154	YELWAN DUGURI	912
154	NABORDO	901
154	MURMUR	900
154	YANKARI	911
154	BURSALI	876
154	GAMAWA	885
154	TSANGAYA	130
154	DURUM	883
154	NAKA	2833
154	G.R.A	2820
154	KANGERE	893
154	Tambarari Village	2837
154	ALKALERI	127
154	KALAJANGA	2825
154	AZARE	870
154	SHIRA	905
154	ZAKI	913
154	Bacas	2815
154	KANGARE	2826
154	DAMBAM	877
154	DOGON JEJI	881
154	WAILO	910
154	GWARAM	2258
154	BOGORO	871
154	TURUM	908
154	BAYARA	2817
154	BULKACHUWA	873
154	BURA	875
154	ITAS-GADAU	891
154	KIRFI	895
154	TAFAWA BALEWA	129
154	SHIRA/YANA	2836
154	Gumi Hill	2821
154	BUESALI	2818
154	GIADE	887
154	GOLOLO	889
154	MIYA	899
154	UDOBO	909
154	MAKAWA	897
154	MAGARYA	896
154	BUNUNU	874
154	HANAFAFARI	2822
154	TSANGWA	2839
154	JAMA’ARE	892
154	DUGURI	882
154	ZABI	131
154	NASARU	902
154	Railway Station	2835
156	SABON TASHA	3742
156	TUDUN NUPAWA	3747
156	UNGUWA MA'AZU	3749
156	KM 36 OPEN HEAVEN	3704
156	RIGASA NORTH	3739
156	G.R.A	3674
156	IKARA LGA	3684
156	KURMIN JIBRIN	3712
156	NO MAN'S LAND	3731
156	KAKURI	3696
156	KWANGILA	3714
156	RIGACHIKUN	3737
156	MARABA RIDO VILLAGE	3721
156	KOFAR GAYA	3705
156	RIGASA VILLAGE	3740
156	NYSC CAMP\t	3733
156	KURMI MASHI	3710
156	KABALA WEST	3690
156	KAGONKO	1443
156	YELWA	3759
156	BARNAWA G.R.A	3663
156	KAD AIRPORT	1441
156	JABA	3685
156	KAURA    	3700
156	UNGWAR KANAWA	3754
156	KWAGIRADA	3713
156	IDON	1436
156	DOKA	1432
156	GODO GIDO	1435
156	ABAKPA	3654
156	KAFANCHAN	1442
156	GASKIYA CORPORATION	3675
156	UNGWAR SHANU	3755
156	GIDANWAYA	3676
156	KETERI	3703
156	SABON GARI	3741
156	ZONKWUA	1450
156	DOKA VILLIAGE	1433
156	JUNCTION RD.	3688
156	MANDO	3718
156	NASSARAWA	3727
156	BIRNIN GWARI	3666
156	NARAYI	3726
156	DOKA V/LAGE	3672
156	KACHIA	1440
156	SARKIN PAWA	3743
156	NNPC	3730
156	HAYIN DOGO	3681
156	K/MAGANI	1439
156	AFAKA	1427
156	ZANGO KATAF	3761
156	KUJAMA	3709
156	KADUNA	3693
156	JAJI	1437
156	MARMARA	3722
156	TSUGUGI	3745
156	BURUKU	3667
156	CHIYODA	3669
156	BURUKR	1429
156	B/GWARI	1428
156	CHIKALI	3668
156	NAGARTA	3725
156	BADIKO	3658
156	MANDO	3719
156	S/PAWA	1448
156	KOFAR JATAU	3706
156	M/JOS	275
156	MANCHOK	1447
156	KAWO	3702
156	CHIKUN	1430
156	ZONKWA	3762
156	PAMBEGUA	3735
156	MANCHOCK	3717
156	BARNAWA VILLAGE	3664
156	GIDER WAYA	1434
156	BARNAWA	3662
156	TUDUN NAPAWA	3746
156	UNGWAR SUNDAY	3756
156	KAURE LGA	3701
156	AHMADU BELLO WAY	3657
156	UNGUWAN KANAWA	3750
156	KALAJANGA	3698
156	BARDIKO	3661
156	TUDUN WADA	3748
156	BARUKU	3665
156	FADIA	3673
156	HAYIN BANK	3680
156	MARABA RIDO	3720
156	BADIKO	3659
156	JERE	1438
156	NDA	3728
156	MALALI	3716
156	UNGWARIMI	3758
156	KADINT'L SCHOOL	3692
156	UNGUWAR KANAWA	3751
156	ZAGON KATAF	3760
156	KAJURU	3695
156	IGABI LGA	3683
156	UNGWAR GWARI	3753
156	KAD INT?L AIRPORT	3691
156	ABKPA	3655
156	MAKERA	3715
156	KUBACHA	3707
156	KUFANA	3708
156	KURMI MASHI	3711
156	GONI GARA	3677
156	KASUWAN MAGANI	3699
156	PALACE	3734
156	UNGWAR T.V	3757
156	N.D.A	3724
156	KAGORO	1444
156	IGABI	3682
156	HANWA	3679
156	AHMADU BELLO STADIUM	3656
156	KAKURI	3697
156	UDAWA	1449
156	GYALLESU	3678
156	NIGERIAN AIRFORCE BASE	3729
156	DALLET BARRACKS	3671
156	KWOI	1446
156	DANKANDE	1431
156	BARDAWA	3660
156	KUFENA	1445
156	RIGASA	3738
156	KAGARKO	3694
156	NTI	3732
156	RAILWAY QUATERS	3736
156	UNGWAR DOSA	3752
156	TELEVISION	3744
156	CHUKUN	3670
157	KANKARA	2277
157	MALUMFASHI	2286
157	BASAWA	2219
157	PAMBEGUA	2226
157	MAKARFI	2225
157	ZANGODAURA	5229
157	SAMARU	5226
157	DANDUME	2221
157	GIWA	548
157	SABONGARI	5225
157	SAYE  VILLAGE	5227
157	DAKACHI	5221
157	WUSASA	5228
157	HUNKUYI	549
157	KAURU	2224
157	SOBA	2229
157	GWARABE	5222
157	SAYE	2228
157	DAKACE	2220
157	ZARIA	5230
157	BAKORI	2218
157	FASKARI	2222
157	SABUWA	2227
157	KAFUR	5223
157	FUNTUA	595
157	IKARA	2223
157	SHIKA	550
157	DANJA	2246
159	LAPAI	4395
159	MNA	4405
159	SABON DAGA	4413
159	NTIGHA	4410
159	SHIRORO DAM	4417
159	WATER WORKS	4426
159	EDATI	1626
159	NASKO	4407
159	MINNA	4404
159	KATA EREGI	4391
159	TUNGAN ALADE	4424
159	GUSSORO	1629
159	BADEGI NCRI	4367
159	IBB HOSPITAL/CHANCHAGA	4384
159	KAGARA	1633
159	BADEGGI/NCRI	1623
159	BARO	4371
159	AGALE	4364
159	DARACHITA TAKWASA	4377
159	DOKKO	4378
159	SARKIN-PAWA	1648
159	AIRPORT KWANGALI	4365
159	TEGINA	356
159	TUNGAN CHANCHAGA	4425
159	MAITUMBI DANA PHARM.	1639
159	KUCHITA NDAK POTUN	4394
159	MAIZUBE WATERS	4403
159	AGAIE	1622
159	IBB HOSPITAL/ CHANCHAGA	1631
159	KAFINKORO	4389
159	GWADA	1630
159	YAKILA	4427
159	KPAKUNGU	4393
159	KONTAGORA	1637
159	DANA PHARM	4376
159	TAGWAI DAM/ FGC/SCIENTIFIC EQU	4419
159	BIDA	352
159	ZUNGERU DAM/ POWER STATION	1653
159	NASKO/AUNA	1642
159	CHANCHAGA/IBB HOS&FGC	4374
159	MAIKUNKELE	4397
159	NINTH MILE	4409
159	SHONGO	4418
159	BANGANJE	4368
159	SARINPAWA	4414
159	KAMPALA	4390
159	NASKO	4406
159	BOSSO	4372
159	IZOM	4387
159	MAIRIGA	4398
159	TUNGAMAGAJIN	4423
159	PAIKO	1643
159	MASHEGU	1641
159	KATEREGI	1636
159	DOKO	1625
159	TUDUN FULANI	4420
159	NDENZUBA	4408
159	BARKIN SALE	4370
159	BADA	4366
159	KATCHA	1635
159	ADUNU	1621
159	RIVER BASIN AUTHORITY	4412
159	KAMPALA/MAIZUBE WATERS	1634
159	SHIRORO	1649
159	IBB HOSPITAL	4382
159	LAPPAI IBB UNIV.	4396
159	TAGWAI DAM/ FGC/SCIENTIFIC EQUIP.	1650
159	PANDOGARI	1644
159	KUTA	354
159	TUDUN FULANI	4421
159	KUTIGI	1638
159	POGO/NNPC	1645
159	KABOJI	1632
159	SHANGO	4416
159	BEJI	1624
159	KAFFIN-KORO	353
159	RIJAU	1646
159	GIDAN-KWANO/FUT/NECO	1627
159	KOIDA KURA	4392
159	MAITUMBI	4400
159	KAFIKORO	4388
159	MAITUMBE 	4399
159	IBB UNIVERSITY	4385
159	MAIYUMBI DANA PHARM	4402
159	IYARUWA	4386
159	COLLEGE OF EDUCATION	4375
159	IBB HOSPITAL/CHANCHAGA	4383
159	MARIGA/BANGI	1640
159	LAPAI/IBB UNIVERSITY	355
159	POGO/NNPC EPORT	4411
159	GULU	1628
159	WUSHISHI	357
159	SARKIN PAWA	4415
159	DUTSEN KURA	4379
159	ZUNGERU	358
159	TUNGA MAGAJIYA	4422
159	TUNGA-MAGAJIA	1652
159	BOSSO DUSTIN KURA	4373
159	MAITUMBI GWADAI	4401
159	TUDUN-FULANI	1651
159	GIDANKWANO	4381
159	BANGAYI EKPAT SUNARU	4369
159	EDIATI	4380
159	SABON-DAGA/ MAIZUBE YOGHURT	1647
160	GURARA	497
160	YANGOJI	504
160	GAWU-BABANGIDA	496
160	YABAA	5042
160	TUNGA MAJE	5040
160	KUJE ROAD	2093
160	KWALI	499
160	LAMBATA	500
160	DEPOT	5033
160	ABAJI	2086
160	GAURAKA	5035
160	BIWATER	5032
160	TAFA	2097
160	SABON-WUSE	502
160	ZUBA JUNCTION	5044
160	GANU BANGIDA	5034
160	SULEJA	5039
160	SHEDA	2096
160	GWAGWALADA	2091
160	LAMBATA/GURARA	501
160	MAJE	2094
160	KADUNA ROAD	2092
160	ZUBA	5043
160	KWAMI	5036
160	TUNGA-MAJE	2098
160	ROBOCHI	2095
160	IZOM	498
160	MADALA	5037
160	SULEJA	5038
160	GIRI	2090
160	DIKO	2089
160	BI-WATER	2087
160	TUNGA-YAKUBU	503
160	DIKKO	2088
160	WUSE	5041
160	YABA	2099
162	EKPAN	5117
162	OROGUN	5129
162	OKPARA WATERSIDE	2142
162	ENERHEN	5118
162	OGUME/AMAI	2139
162	KWALE(AGIP PLANT)	2133
162	ESCRAVOS	2125
162	EMEVOR	2124
162	FORCADOS	2127
162	AKO	5113
162	EFFURUN-OTOR	2329
162	OGULAHA	2138
162	OKWAGBE	5125
162	OZORO	2153
162	UMUTU	2155
162	OKPARA INLAND	536
162	OTUJEREMI	2149
162	EKU	534
162	OKPAI	2141
162	AGBARHO	2120
162	OREROKPE	2146
162	OSUBI	2147
162	OKWOKOKO	5126
162	ABBI	2119
162	JEDDO	2130
162	UGHELLI	538
162	EFFURUN	5115
162	AGBAHA OTOR	5111
162	NGALA	5122
162	KWALE (ASHAKA)	5120
162	OJOBOLO	2140
162	AGULABIRI	2121
162	EKAKPAMRE	5116
162	BOMADI	2122
162	GBARAMATU	2128
162	IFIOKPORO	2129
162	AGBARAHOR	5112
162	OPORAZA	5127
162	KWALE(ABOH)	2132
162	OFUAGBE	2136
162	OTO-OWHE	2148
162	OWHOLOGBO	2152
162	BURUTU	2123
162	UGHOTON	539
162	EDJEBA	5114
162	ABRAKA	531
162	ORE ROKPE	5128
162	EVWRENI	2126
162	KWALE (AB(ABOH)	5119
162	OLOMORO	2144
162	OLOMU	2145
162	ALADJA	533
162	EKEREMOR	2250
162	ABONYMA	5110
162	UBEJI	5132
162	OGIDIGBEN	2137
162	N.N.P.C. DEPOT	5121
162	OBIARUKU	2135
162	SAPELE	5131
162	OTUJEVWEN	2150
162	AGBARHO-OTOR	532
162	OWHE	2151
162	KWALE	2131
162	OTUJEUWEN	5130
162	WARRI	5133
162	OGIDEGBEN	5123
162	OKWAGBE	5124
162	UGBOKODO	537
162	EWEN	535
162	KWALE(ASHAKA)	2134
162	PATANI	2154
162	OLEH	2143
163	Warri Airport	2796
163	UBULUBU	855
163	ISSELEGWU	846
163	UBULU OKITI	2787
163	ASABA	2755
163	ISSELE UKU	97
163	OKO ANALA	101
163	ADONTE	829
163	B.  D. P. A. Area	2759
163	OTULU	2781
163	EKUMA	840
163	OLO	851
163	ONICHA OLONA	103
163	Ojolu /Ghana	2776
163	EBU	836
163	AJUMA IGA	830
163	AKWUKWO IGBO	90
163	Ezenei	2768
163	AKUMAZI	832
163	EKWUOMA	91
163	Overhead Bridge Layout	2782
163	Upper Erejuwa	2795
163	Catholic Mission Rd.	2764
163	OGWASHI UKU	99
163	Boji-Boji Agbor	2760
163	Boli-Boji Owa	2761
163	Alibuba Quarters	2754
163	UBULU UKU	105
163	UGBOLU	107
163	IDUMUJE UGBOKO	93
163	NSUKWA	847
163	AKWUOHA	833
163	Ugborikoko	2789
163	Ekpan(Tori)	2767
163	EMUHU	92
163	UTAGBA UNOR	860
163	ISELE UKU	2772
163	NBTC	2775
163	UBIAJA	2786
163	ASHAMA	835
163	UGBODO	2788
163	ISSELE MKPITIME	96
163	OBIOR	848
163	Isieke	2773
163	IBUSA	842
163	OVWIAN-UDU	2783
163	Borrow Pit	2762
163	ISSELE ASABA	2774
163	Agimele Village	2750
163	Umuagu	2791
163	ILLAH	95
163	EGBUDU AKA	837
163	UMUTE	859
163	EJEME ANIOGOR	838
163	ONICHA UKU	853
163	ANWAI	834
163	ACHALA IBUSA	828
163	OKO OGBELE	2777
163	ATUMA IGA	2757
163	Okpe Rd.	2779
163	OSSISSA	854
163	UGBODU	856
163	Okpanam Asaba Rd.	2778
163	UBULU UNOR	106
163	G. R. A.	2769
163	Okuamagba Layout	2780
163	AKALA	831
163	Umueze	2792
163	OKOOGBELE	102
163	Cablepoint	2763
163	OKPANAM	849
163	UKWU OBA	858
163	Atufe Rd.	2756
163	ONICHA UGBO	104
163	Owa-Alero Rd.	2784
163	Golf Course Rd.	2770
163	OKO AMAKOM	100
163	ISSELE ASAGBA	845
163	AKWU OHA	2752
163	IDUMU OGOR	843
163	Central Core Area	2765
163	OBOMKPA	98
163	UKWU NZU	857
163	UMUNEDE	2793
163	Reclamation Rd.	2785
163	ISHEAGU	844
163	IDUMUJEUNOR	2771
163	AKWA-UKWU-IGBO	2751
163	IDUMUJE UNOR	94
163	Chickester Rd.	2766
163	EWULU	841
163	OLODU	852
163	EJEME UNOR	839
163	UKALA UKPUNOR	108
163	Alders Town	2753
163	Ayomanor Rd.	2758
163	OKWE	850
163	Umuonaje	2794
163	IGBODO	561
163	UKALA	2790
164	JESSE TOWN	2064
164	OGHAREKI	4964
164	KOKORI	4962
164	OGHARA	474
164	SAPELE	4967
164	OBIARUKU AMAI	4963
164	EGBE OGUME	4960
164	OKPARA INLAND	4966
164	MOSOGAR	473
164	OGORODE	4965
164	YESSE	4968
164	OGHARA-EFE	475
164	ISIOKOLO	4961
164	ABRAKA	4959
164	IBADA ELUME	472
164	AGHALOKPE	471
166	OKEOLA	4773
166	IRE AKARI	4732
166	IJABE	1813
166	IREE	1820
166	SUSU	4796
166	IMESI ILE	4728
166	ABIOLA AVE	4674
166	IDOMINASI	4710
166	OKE OOYE	4767
166	IWARA	4740
166	OROMU QUARTERS	4782
166	PALACE	4792
166	OTAN AYEGBAJU	1825
166	IROJO QUARTERS	4735
166	OKE OPO	4769
166	ILARE	4720
166	ADE OWO	4676
166	OGBON OGBEJE	4758
166	GBONGAN	2255
166	IBOKUN	4705
166	INISHA	1817
166	IWO	1822
166	BOSA STR	4688
166	IKIRUN	1814
166	OKE BAALE	462
166	ISALE APATA	4736
166	OBOKUN HIGH SCHOOL	4748
166	ODO OJA	4753
166	EJIGBO	1808
166	ERIN OSUN	4697
166	ODE AGBALA/ISALE AFFON	4749
166	FAGBEWESA	4701
166	OKE ONITI	4766
166	IREMO	4733
166	BODE	4686
166	KUTA ILEGBO	4744
166	OWODE	585
166	OTA EFUN	4786
166	ILERIN QUARTERS	4721
166	IKEJI ARAKEJI	4716
166	IDIORO/THE APOSTOLIC GRAMMAR S	4709
166	DADA ESTATE	4690
166	IWOPIN	1823
166	ALAPATA	4680
166	OAU	4747
166	IDO-OSUN	4711
166	CARETAKER/OKE ALAPATA	4689
166	IFON OSUN	1811
166	STADIUM	4795
166	ALEKUWODO	4681
166	ONPETU PALACE	4778
166	IJOKA	4715
166	ODO ESE	4752
166	AIYETORO ORUNGUN	4678
166	OMO WEST	4777
166	ISALE OLA QUARTERS	4737
166	OGBADORE	4757
166	IPAPO	4730
166	IRESI	1821
166	ERIN IJESA	4694
166	OKE ESE	4761
166	ILESHA	4724
166	IKIRE	4717
166	ILA ORANGUN	1815
166	IWARAJA	4741
166	AYANSHOLA	4684
166	ODO AFIN	4751
166	ILOBU	459
166	IRAGBIJI	1819
166	ILA ORAGUN	4719
166	GENERAL HOSPITAL	4703
166	ODOGO	4754
166	OKE OPE QUARTERS	4768
166	OWENA IJESA	4789
166	ESUYARE QUARTERS	4700
166	ERIN OKE	4696
166	ILOKO IJESHA	4727
166	LEVENTIS AGRIC FARM	4745
166	OKEYIDI	4775
166	ASOKO QUARTERS	4683
166	ARAROMI OKESA	4682
166	OSHOGBO	4784
166	OTAN AYEGBANJU	4787
166	ESA OKE	4698
166	IBA	1809
166	EGBEIDE	4692
166	GOVERNMENT QUARTERS	4704
166	BODE OSI	4687
166	OGOOLUWA	4759
166	ABA COKER	4673
166	ELEYELE	4693
166	ILE OGBO	1816
166	ODE OMU	461
166	AIYETORO	4677
166	ITA OLOKAN	4739
166	ILODE	4726
166	OKE ESO IGBAYE	4762
166	IDO OSUN	1810
166	ODIOLOWO	4750
166	OKEFIA	4771
166	IWOYE	4742
166	OLD AKURE RD	4776
166	AYESO	4685
166	IDI SEKE	4708
166	IRAGBERI	1818
166	OGBADARE	4756
166	IDASA	4707
166	EDE	1807
166	OBAAGUN	460
166	OKUKU	2314
166	ESA-OKE	4699
166	KOLA BALOGUN	4743
166	OKE IRO	4764
166	SOOKO	4794
166	OKEIYIN	4772
166	OSADEP ZONAL OFFICE	4783
166	ISIDA	4738
166	MORE	4746
166	OWENA IJESA	4788
166	OYAN	1826
166	IGBAJO	1812
166	TEMIDIRE	4797
166	OPA	4779
166	AKARABATA	4679
166	ORANMIYAN SHRINE	4780
166	IGBON ILORO	4712
166	ILESA LOCAL GOVERNMENT	4723
166	OKEREWE	4774
166	ADA	4675
166	IRAYE STR	4731
166	ERIN ILE	4695
166	OKE ILA	1824
166	IJEBU IJESHA	4713
166	ODUNDUN	4755
166	OREMERIN	4781
166	IREPODUN	4734
166	OKE OTUBU QUARTERS	4770
166	OYO STATE GRA	4791
166	OSU	4785
166	IJEDA	4714
166	IMO QUARTERS	4729
166	OKE D.O RD	4760
166	OWENA IJESA	4790
166	EDE DIMEJI	4691
166	OKE OLA	4765
166	FEDERA TECHNICAL COLLEGE	4702
166	ILESA	4722
166	OKE INISA	4763
166	RING RD	4793
167	WAASINMI	1214
167	IBOKUN	3335
167	IYAN - FOWOROGI	1211
167	IYAN-FOWOROGI	3344
167	IFETEDO	1208
167	IYAN-FOWOROGI	3343
167	OLODE	200
167	ABA IYA-GANI	3332
167	GBONGAN	2254
167	AKIRIBOTU	3333
167	IKIRE	566
167	PARAKIN	3350
167	IFEWARE	198
167	ITA-ELEWA	1210
167	IFE	3336
167	IFEWARA	3337
167	ONIKOKO	202
167	IJEDA	3340
167	IYAN-FOWOROGI	3345
167	OMIFUNFUN	201
167	ODEOMU	199
167	AKINLALU	1207
167	OKUU	3349
167	EDUNABAN	3334
167	OKUU-OMONI	1213
167	MORO	1212
167	IFEWARA	3338
167	IJEBU IJESHA	3339
167	ODE OMU	3348
167	YAKOOYO	1215
167	MODAKEKE	3347
167	ILESA	3342
167	ABA IYA GANI	1206
167	IPETUMODU	1209
167	COKER	197
167	IKOYI	3341
167	LAGERE	3346
169	AKWANGA	1515
169	AZARA	1519
169	AGWASHI	3915
169	ANDAHA	1517
169	AGWATASHI	3916
169	GWANTU	2257
169	OLA	1529
169	GARAKU KOKONA	3922
169	GUDI	1524
169	GIBA	3923
169	KURGWUI	3926
169	BASA	3920
169	ANGWAN ZARIA	3917
169	NASARAWA EGGON	297
169	GIZA	1523
169	GWANJE	1525
169	AZARE	3919
169	AWE	2239
169	AGWADA	1513
169	RUKUBI	1531
169	LAFIA	3927
169	AGYARAGU	1514
169	MADA STATION	1528
169	QUANPAN	3931
169	TUNGA	1532
169	OBI	2294
169	ASAKIO	1518
169	NASSU	3930
169	RINZE	1530
169	JIRIYA	3925
169	GARAKU	1522
169	MOROA	3928
169	KWANDERE	1527
169	DADDARE	3921
169	DOMA	1520
169	KEANA	1526
169	FARIN RUWA	1521
169	ALUSHI	1516
169	NASSARAWA EGON	3929
169	WAMBA	1533
169	ASSAKIO	3918
169	GIZAWA	3924
169	KADARKO	2274
171	UMUTANZE ORLU	456
171	ALADINMA ESTATE	4579
171	EGBEMA	1793
171	AWO OMAMA	4597
171	AMUZARI	4592
171	INDUSTRIAL AREA	4614
171	INYISHI	4615
171	UMUOWA ORLU	454
171	OWERRI EBIRI	4651
171	ITU EZINIHITTE	401
171	UMUDIOKA ORLU	447
171	AKOKWA	4578
171	OBODOUKWU	424
171	OGUTA ISLAND	4641
171	OWERE EBIRI	443
171	MGBIDI	411
171	UMUOWA NGOR	453
171	ORSU	441
171	ORIAGU-NSU MBANO	439
171	OWERRI	4650
171	UMUHUOKABIA ORLU	450
171	MBIERI	408
171	UZOAGBA	4671
171	MGBEE	410
171	OPUOMA	438
171	ATTAH	1780
171	AGAWARA`	4576
171	AMIRI	1775
171	AMAIMO	4584
171	UMUECHE	4659
171	MBAITOLI	405
171	UMUSASA	4668
171	AMUCHA	4591
171	ITU EZINIWHITE MBAISE	4618
171	AWO-IDEMILI	1786
171	NDIKWAEKE	4631
171	AWAKA	1785
171	AMIGBO	1774
171	IKENEGBU	4611
171	ATTA	4594
171	NKEWERE	4634
171	IMO STATE UNIVERSITY	4613
171	AMALIM	1769
171	MBEKE	407
171	UMUOWA (NGOR)	4665
171	NGOR-OKPALA	413
171	LOCAL GOVERNMENT HEADQUARTERS	4619
171	STATE HIGH COURT	4653
171	EZIAMA OBIATO	389
171	EZIORSU	1800
171	OKOLOCHI	433
171	AMUZI- OBOWO	379
171	ETITI	386
171	ANMANFOR	1777
171	UMUGUMA	449
171	IKEDURU L.G H/Q	4609
171	AMAIGBO	4583
171	AMAKOHIA-IKEDURU	1767
171	IZOMBE	1801
171	MBAITOLU L.G H/Q	4623
171	UMUOZO MBANO	4667
171	OKWUDOR ORLU	4645
171	ABO  MBAISE	4574
171	UMUAKA NJABA	4658
171	AMAWOM	4589
171	OBIBI-EZENA	4637
171	AMAKOHIA- URATTA	1766
171	IKENEGBU LAYOUT	4612
171	EZIAMA NGOR-OKPOALA	388
171	AMARURU	1772
171	UDOR ORLU	4655
171	AMAUZARE-ISIALA MBANO	1773
171	ORODO	4649
171	OKPORO	434
171	MMAHU	1803
171	UMUELEMAI	4660
171	NKWOSI	416
171	IHITTE UBONA	395
171	MECHANIC VILLAGE	4626
171	NNARAMBIA	417
171	ETEKWURU	1799
171	EMEKUKU	4599
171	ENYIOGUGU-MBAISE	385
171	OBODOUKWU IDEATO	4638
171	UMUAKA	446
171	EHIME- MBANO	382
171	IKENAZIZI	398
171	UBAHU	4654
171	EMII	1798
171	OROGWE	1805
171	AWA	1784
171	NGOR OKPALA	4633
171	OSU IHITTE UKWA	442
171	AMAIFEKE	4582
171	OKOWELLE	4642
171	ABO-ORLU	4575
171	ASAA	1779
171	URUALLA	458
171	OGBOMORO	4639
171	LOW COST	4620
171	OBIANGWU	420
171	NGURU MBAISE	414
171	OHI	431
171	URATTA	1806
171	AVU	1781
171	AVUTU	1782
171	EHIME MBANO	4598
171	EZIAMA IKEDURU	387
171	ALADINMA NORTHERN EXTENSION	4580
171	EGBU	1794
171	UGWU ORJI	4656
171	AMAOJI	4586
171	MGIDI	4628
171	IHITTE NANSA	394
171	ULAKWO,	444
171	IRETE	4616
171	OKUKU	4644
171	IKENANZIZI	4610
171	NEW OWERRI	4632
171	OGWA	581
171	MBAISE	404
171	NAZE	4630
171	NWORIEUBI	4635
171	AGIRIGA	4577
171	AKABOR	1763
171	IDEATO SOUTH	4605
171	ULAKWO	4657
171	OGBAKU	428
171	ABBA	2230
171	EGBUOMA-OGUTA	1795
171	OMUOZO 	4647
171	AWO IDEMILI	4596
171	OBILUBI	422
171	AHIAZU MBAISE	378
171	AGBALA	1760
171	ABACHEKE	1755
171	IDEATO NORTH	4604
171	UMUOZU MBANO	455
171	OGBUERURU	429
171	UMUOYINMA EMMANUEL COLLEGE LAY	4666
171	AMARAKU	1771
171	IMERIENWE	399
171	AGWA	1761
171	IHIOMA	393
171	EKWE	384
171	NEKEDE	1804
171	NWANGENE	419
171	DIKENAFAI	1791
171	GENERAL HOSPITAL	4601
171	ISU	4617
171	ENYIOGUGU MBAISE	4600
171	IDEATO	4603
171	OBINZE	423
171	AVUVU	1783
171	AMAOPARA	4588
171	OBOWO	426
171	ORLU	440
171	ABAJA	1757
171	EZINIHITTE MBAISE	390
171	ORIAGUM BANO NSU	4648
171	AMAKOHIA-UB1	4585
171	EGWE-OGUTA	1796
171	IHITTE UBOMA	4608
171	MGBIRICHI	412
171	OGUATA ISLAND	4640
171	AWO-OMAMA	1787
171	EJEMEKWURU	383
171	IHIT-OWERE	4607
171	MBUTU OKOHIA	409
171	AZARA-OBIATO	1788
171	ARONDIZUOGU	1778
171	OHUBA	432
171	ABO- ORLU	1758
171	IHIAGWA	392
171	IHITE NANSA	4606
171	AHIARA	377
171	AKATA	1765
171	ABAEZI	1756
171	UMUNDUGBA	451
171	LAGWA	403
171	OLOKWU	437
171	AAWARA	1753
171	OGUTA	430
171	EZIOBODO	391
171	OMUMA	583
171	OKPARA	4643
171	AFORORU-MBAISE	1759
171	NKWERE	415
171	ABOR-MBAISE	376
171	IKEDURU	397
171	UZI LAYOUT	4670
171	AMIKE ORLU	4590
171	UMUOKWARA	4664
171	AMANDUGBA	1770
171	MBANO	406
171	REV.MANN	4652
171	OKWUDOR ORLU	4646
171	OKWUDOR - ORLU	436
171	WORKS LAYOUT	4672
171	ABACHIEKE	4573
171	MGBALA AGWA	1802
171	OBOSIMA	425
171	ARUGO LAYOUT	4593
171	EMEABIAM	1797
171	EBENANO	380
171	AMAOKHIA-IKEDURU	4587
171	OFROLA	427
171	UMUNA	4662
171	CHOKONAEZE	1790
171	UMUHUOKIABIA ORLU	4661
171	AMAIFEKE	4581
171	AKABO	1762
171	NNEMPI	418
171	ISU NJABA	400
171	UMUODU	4663
171	UMUZIKE ORLU	457
171	AVTU	4595
171	UMUNDUGBA ORLU	452
171	AKAOKWA	1764
171	URUALLA IDEATO	4669
171	AMAKOHIA-UBI	1768
171	NWORIUBI	4636
171	AZARSEGBELU	1789
171	GERMAN HILL	4602
171	IHO	396
171	UMUAGWO	445
171	ANARA	1776
171	OBIBIEZENA	421
171	OKWELLE	435
171	UMUESHI	448
171	MBAISE OTHERS	4622
171	IYISHI	402
171	NAZE	4629
171	ABA-BRANCH	1754
171	EBENATO	381
171	EGBEADA	1792
173	AMILE	4001
173	Federal Housing Area	4011
173	Ochido's Palace	4062
173	45 NAF HOSP	1559
173	TALKAMAWA	4075
173	OJANTELE	1594
173	TARAKU	4076
173	GUMEL	4019
173	RURAL HEALTH CENTER	4072
173	Kokoroo	4043
173	BUNKUBE	4006
173	UPU. Rd	4080
173	IHUGE 	4027
173	ABWA	1562
173	MAKURDI	4047
173	NASME	1588
173	ALIADE	1567
173	UNIVERSITY OF AGRICULTURE	298
173	LESSEL	1582
173	MKD AIRPORT	4055
173	IKPAYONGO	4029
173	IHUGH	4028
173	Army Barracks	4003
173	IGHU	1576
173	No. Cross	4058
173	GBAJIMBA	4014
173	ISU	4032
173	ASUKUNYA	4004
173	TSEKUCHA	4077
173	APA	1569
173	JESSE	4038
173	KWADE	4044
173	KASTINA-ALA	4041
173	OGBADIBO	1590
173	AJEBO	3998
173	LOGO	1583
173	OYUKPO	4068
173	UKUM	4078
173	IGA	1575
173	General Hospital	4016
173	GWER WEST	4020
173	NORTH BANK	4059
173	ADOKA	1564
173	Eupi	4009
173	USHONGO	4081
173	NNPC	2289
173	UTONKON	4082
173	ITAOGOLU	4034
173	KONSHISHA	1580
173	MKD TOLGATE	1586
173	KAIMA	4040
173	MAKUNKELE	4046
173	MKD AIR PORT	1585
173	AGASHA	3996
173	Federal Low	4012
173	OHIMINI	1592
173	IGUMALE	1577
173	GBAJIMBA	4015
173	ISONYI	4031
173	OGODUMU	1591
173	SHIYAR KALGAWA	4074
173	Wurukum	4084
173	OJU	1595
173	Sabon Gari	4073
173	AGATU	1565
173	Ahmadu Bello	3997
173	GETSO	4017
173	LUGA	1584
173	ZAKIBAM	4086
173	ABINSE	1561
173	MANI	4050
173	GUMA	1574
173	Ministry Of Works	4053
173	NAKA	1587
173	New Market	4056
173	OBI	2295
173	OTOBI	4066
173	OTURKPO   	4067
173	GOBIRAWA	4018
173	Hudco Quarters	4022
173	UGBOJU	1603
173	MBAAKON	4052
173	72 BATTALION	1560
173	VANDEIKYA	1605
173	AKANKPA	3999
173	Wadata	4083
173	JATO AKA	1578
173	JOGA	4039
173	AYIN	1570
173	Unijos Campus	4079
173	UGBA	1602
173	ADIKPO	1563
173	DAUDU	1572
173	EMIRS PALACE	4008
173	Ella Market	4007
173	BURUKU	1571
173	ONYAGEDE	1597
173	OTUKPO	1599
173	MARADUN	4051
173	MKAR	4054
173	KATSINA-ALA	1579
173	OOL	4064
173	AKWAI	4000
173	OBARIKE-ITO	4061
173	OROKAM	4065
173	IDANRE	4024
173	AUGIRI	4005
173	ITELE(AYETORO)	4036
173	OBAGAJI	1589
173	ANKPA	1568
173	KATSINA ALA	4042
173	High Level Ass. Vill.	4021
173	ZAKIBIAM	1607
173	ADO	3995
173	Post Office	4069
173	APIR	4002
173	UGBOKOLO	1604
173	WANNUNE	1606
173	AKPAHER	1566
173	Rail Way Station	4070
173	ITAS	4035
173	OTUKPA	1598
173	IZOMBE	4037
173	ICHAMA	4023
173	NORTH BANK	4060
173	Rice Mills	4071
173	NNPC DEPOT	4057
173	Eupi-New Layout	4010
173	Ogwonogba	4063
173	OKPOGA	1596
173	G.R.A	4013
173	OJAKPAMA	1593
173	Local Government Clinic	4045
173	KORINYA	1581
173	OWUKPA	1600
173	TSE AGBARAGBA	1601
173	GBOKO	1573
173	YANDEV	4085
176	GARKIDA	2193
176	KWARHI	2203
176	BELE	5179
176	MARARABA MUBI	2206
176	MICHIKA	2208
176	MUBI	5207
176	MAIHA	2205
176	LAMURDE	5200
176	NUMAN	2212
176	TOUNGO	2216
176	GUYUK	2197
176	Industrial	5194
176	LAMBA	2204
176	NNPC DEPOT	2292
176	Nasarawa	5208
176	GAWANA	5187
176	MADAGALI	2284
176	MUBI NORTH	2209
176	BORON	5180
176	TONGO	5215
176	DEMSA	2189
176	Wuro Patuji	5218
176	JEBILAMBA	2202
176	JABI	2200
176	GEWANA	5189
176	SAVANNA	5212
176	GANYE	2192
176	BORRONG	2188
176	FURORE	2191
176	FGGC	2190
176	Lamido Palace	5199
176	Yelwa Ward	5219
176	GERFI	5188
176	SHUWA	2321
176	JIMETA	5196
176	Gwadabawa	5192
176	Demsawo	5182
176	Old G.R.A.	5211
176	Jambutu	5195
176	UBA	2217
176	Luggere	5201
176	SHELLENG	2214
176	Karewa	5197
176	FOFORE	5186
176	School Of Arts	5213
176	MAYOBELUWA	5205
176	Wuro Gude Ward	5216
176	Kochifa Ward	5198
176	GEREI	2195
176	Shuware ward	5214
176	Airfield	5178
176	MAYO-BELWA	2207
176	SAVANAH	2213
176	HONG	2199
176	MUBI SOUTH	2210
176	NGURORE AFCOTH	5209
176	Federal Housing	5185
176	GIREI	5190
176	JADA	2201
176	Damilo	5181
176	GOMBI	2196
176	Ijari	5193
176	SONG	2215
176	MAYO BELWA	5204
176	Dubeli	5183
176	GYAWANA	2198
176	Majalisa	5203
176	NGURORE	2211
176	MICHKA	5206
176	NGWRORE-AFFCOT	5210
176	DUTSE	5184
176	Wuro Jibirward	5217
176	GBORONG	2194
176	Lukuwa	5202
176	GULAK	5191
176	YOLA	5220
178	KWAFALLS	1021
178	Egerton Area II	2974
178	OBANLIKU L.G.A	1028
178	OHONG OBUDU	1033
178	IWURU	1019
178	IGOLI  OGOJA	1015
178	ESIGHI	1012
178	IKANG	1016
178	Ogja Rd	3004
178	MBUBE-OGOJA	1023
178	NKO UGEP	2993
178	NKPANI	2994
178	YAHE	2326
178	YALA	2328
178	Uwanse	3017
178	UGEP	1035
178	EKORI UGEP	2975
178	OBUDU RANGE	1031
178	Goldie	2980
178	AKPABUYO	2956
178	ETUNG LGA	1014
178	Ukwel	3016
178	YUSUFARI	3020
178	MFAMOSING	1024
178	Mission Road	2990
178	OBUDU	2999
178	Ikorinim	2984
178	Abakpa	2954
178	Post Office Forestry	3007
178	IKOT ENE AKPABUYO	1017
178	Essien Town	2977
178	Okim Osabor Rd	3006
178	Stadium	3009
178	BAKASSI	2958
178	BIASE	1008
178	BEKWARRA	2960
178	BEKWARA	1007
178	Biko	2962
178	OKPOMA	2309
178	YAKURR	1037
178	NANFE	2992
178	IKOM	2265
178	Bisiri	2963
178	OBALIKU LGA	2995
178	ETUNG	2979
178	OKONDI	1034
178	WULA	3018
178	OBANLIKU	2996
178	BOJE	1009
178	OBAN	1027
178	ABI	1004
178	Ekpo Abasi	2976
178	Ukelle	3015
178	ITIGIDI	1018
178	IYAHE	1020
178	CALABAR SOUTH	2969
178	Eta Agbor	2978
178	Scout Lane	3008
178	YAKURR LGA	3019
178	CREEK TOWN	1011
178	UYANGA	1036
178	UGEP LGA	3012
178	Ediba	2972
178	IGOLI-OGOJA	2982
178	Bogobiri	2964
178	State Housing Estate	3010
178	OHONG-OBUDU	3005
178	Egerton	2973
178	Calabar Rd	2968
178	MANFE	1022
178	BOKI	1010
178	Obudu Rd	3002
178	OBUDU LGA	3000
178	ESUK MBA	1013
178	MKPANI-UGEP	1025
178	Ikot Omin	2986
178	BESENI	2961
178	OBANLIKU LGA	2997
178	Ikot Ansa	2985
178	OBUDU L.G.A	1030
178	IKA-NORTH EAST	2983
178	OGOJA	2299
178	Airport	2955
178	OBURU	3003
178	Comm. Sec. Sch.	2970
178	Bojor Archibong	2965
178	BOKYI LGA	2966
178	AKAMKPA	1005
178	Ukamusha	3014
178	ODUKPANI	1032
178	BAKWARRA	2959
178	OKUKU	2313
178	OBUDU RANCH	3001
178	AKPET	2957
178	Local Govt. Councl	2988
178	MKPANI UGEP	2991
178	OBUBRA	1029
178	CALABAR	2967
178	Dan Archibon	2971
178	IGOLI OGOJA	2981
178	Main Market	2989
178	Udama Ubug	3011
178	AKWA IKOT EFFANGA	1006
178	OBUBURA	2998
178	UGEP YAKURR	3013
178	KWA FALLS	2987
178	NKO-UGEP	1026
180	ISIKWUATO	511
180	Ossah	5052
180	OHAFIA	513
180	UMUAKWU NSULU	515
180	OHUHU	2113
180	UMUOKPARA	5058
180	BENDE	508
180	OZUITEM	514
180	ABIRIBA	505
180	AHIAEKE	2102
180	ACHA	2100
180	MBALANO	5049
180	ISUOCHI	2108
180	ONICHA LGA	5051
180	UZOAKOLI	5060
180	EKEOBA	2106
180	UTURU	516
180	AFARA	2232
180	UMUOSU NSULU	590
180	ITUMBAUZO	2110
180	World Bank	5061
180	EZINACHI OKIGWE	2107
180	OLOKORO	2115
180	Umuahia Urban III	5056
180	AFUGURI	2101
180	ISIUKWATO	5048
180	ALAYI	506
180	Amuzukwu	5046
180	AROCHUKWU	2105
180	UMUAHIA	5054
180	UMUDIKE	5057
180	ARIAM	2104
180	ITEM	2109
180	OBORO	512
180	UMUOSU N.	5059
180	OFEME	2112
180	IHECHIOWA	5047
180	NSULU	577
180	MBUDO	5050
180	AZUIYI OLOKORO	507
180	UMUOPARA	2116
180	AJATA IBEKU	2103
180	MBALANA	2111
180	IGBERE	509
180	OKIGWE	2114
180	Umuahia Urban I	5055
180	IKWUANO	510
180	ABRIBA	5045
180	ugwunchara	5053
181	ASA OBEHI	2341
181	Iheorji Layout	2354
181	UMUOBI N.	2392
181	UKWA NDOKI	628
181	NDIAKATA	25
181	NDIOLUMBA	2369
181	MBAWUSI	2359
181	AMAVO VILLAGE	602
181	AMACHI NSULU	601
181	MBUTU	23
181	NDIEEGORO	2366
181	AZUMIRI ADOKO	2347
181	AKIRIKA VILLAGE	598
181	UMUAHALA	633
181	UMUAGU	632
181	ASA UMUNKA	17
181	OBIGA VILLAGE	29
181	UMUBA VILLAGE	636
181	AMAORJI	14
181	UMUNKPEI	641
181	OBIOMA NGWA	2376
181	UMUGURU	638
181	OHANKU VILLAGE	619
181	ASAD UKWU	2343
181	UMU AKPI	39
181	UMUALA	634
181	ISIALA NGWA VILLAGE	2358
181	ASANNETU	2344
181	UMUODU	643
181	UMUOLIOKE	2395
181	EZIALA	2350
181	AKIRIKA	2338
181	OSISIOMA VILLAGE	33
181	UMUODE	47
181	UMU NKWO	41
181	ONICHA NGWA	2382
181	UKPAKIRI	37
181	NEMBE TOWN	2370
181	OSUSU	2384
181	EKE ARU VILLAGE	19
181	UNUAKWU NSULU	644
181	ABALA VILLAGE	2333
181	ONITSHA	2383
181	MBUTU NGWA	609
181	NTIGHA UZO	614
181	ARO NDIZUOGU	2340
181	NDI-AKATA	2365
181	UMUOBA	642
181	ABA	2331
181	Ohabiam Layout	2378
181	NDI OLUMBE	2364
181	OMOBA	621
181	UMUGO	45
181	MGBOKO VILLAGE	24
181	IHIE ORJI	21
181	OKPUALA N.	2381
181	OWAZA	624
181	OSUSU AMAUKWA	34
181	UMUEZE VILLAGE	2389
181	NDIEEGORO	2367
181	UMUEZE	44
181	Eziama layout	2351
181	EZIAMA NVOSI	2352
181	AMUZU	603
181	UMUOSU NSULU	2324
181	AGBARAGWU	2336
181	ASANNETU	2345
181	EKE-ARO	2349
181	UMUOBI NGWA	2393
181	OBUBA NVOSI VILLAGE	618
181	UMUNKO VILLAGE	2391
181	OBEHIE VILLAGE	28
181	UMU ADURU	38
181	NGWA IHIEKWE	2373
181	OBETE	616
181	UMUIKAA	639
181	OWERRINTA	625
181	OWOAHIAFOR	2387
181	NGWAIHIEKWE	27
181	EZIALA NSULU	606
181	IHIE	20
181	UMUARIAWA	2388
181	NKPATI ENIN	2374
181	OSAA VILLAGE	623
181	AZUMIRI	605
181	NANKA-AWKA	2362
181	OGWE VILLAGE	31
181	OBINGWA VILLAGE	30
181	AMAVO	15
181	ABAYI ARIARIA	597
181	NDIEGORO VILLAGE	26
181	OWO ASA	36
181	ALAOJI	600
181	ASA UMUAKACHI	2342
181	NSULU	2293
181	AKABO-IKEDURU	2337
181	IHIEORJI	2355
181	UMU AHIALA	630
181	NGURU IHIEKWE	2372
181	UMUWOMA	49
181	ABALLA VILLAGE	596
181	IMO RIVER	608
181	UBAHA NSULU	627
181	IDI AYUNRE	2353
181	OHURU VILLAGE	32
181	ASANNENTU	18
181	UMUOBASI	46
181	NENU VILLAGE	612
181	UMUOJIMA  VILLAGE	2394
181	NENU	2371
181	Aba Central	2332
181	NBAWSI	610
181	ONITSHA NGWA	622
181	ABA	2330
181	EKE AKPARA	2348
181	UMUCHIMA	637
181	ASA OBEHIE	604
181	OWERINTA	2386
181	OBEHIE  VILLAGE	2375
181	OVOM 2	35
181	OWOAHIOFOR	626
181	OHAMBELE	2379
181	EZIAMA  NVOSI	607
181	NTIGHA VILLAGE	615
181	OHUHU NSULU	2380
181	UMUANUNU	635
181	UMU OWUKE	42
181	UMUADIENWA	43
181	UMUNKO	640
181	ARIARIA	2339
181	OBOHIA VILLAGE	617
181	 AGBARAGWU	2335
181	AKWETTE VILLAGE	599
181	ISIALA NGWA	2357
181	Abaukwu	2334
181	MGBOKO	2361
181	OVOM AMASAA	2385
181	UKWA VILLAGE	629
181	Asaokpuja	2346
181	NDI AKATA	2363
181	UMU KALU	631
181	ITU NGWA	22
181	NDIEGORO VILLAG	2368
181	OKPUALA NGWA	620
181	UMUOJIMA	48
181	UMUOTUTU	2396
181	ASA UMUEKECHI	16
181	NLAGU	613
181	NDI OLUMBA	611
181	OBUBA	2377
181	UMU ARIWA	40
181	Umungasi	2390
183	BURIA	1133
183	KOBUWA	3173
183	BAGANJE	1128
183	KALTUNGO	173
183	G.R.A	3166
183	BAMABAM	1131
183	MALLAM SIDI	1148
183	SHINGA	1150
183	EMIR'S PALACE	3165
183	GOMBE	3169
183	MONUGA	3179
183	KURI	1143
183	TULA	1154
183	TALLASE	1152
183	BABAM BAM	3160
183	BIU	2244
183	GADA UKU	171
183	KEMBU	1141
183	KWADOM	1144
183	KAMO	1140
183	KWADAN	3176
183	PANTAMI	3182
183	AYABA	1127
183	LAWANTI	1146
183	TURE	1156
183	DUKKU	170
183	KALMAI	1139
183	TUMU	1155
183	DADIN KOWA	168
183	NAFADA	1149
183	LADONGO	3177
183	GEBUNU	3167
183	BAJOGA	1129
183	DADIYA	1134
183	AKKO	3158
183	DIFA	169
183	KUMBIYA KUMBIYA	3174
183	YIDEBA	3189
183	MONGONO	3178
183	BOJUDE	167
183	BANGANJE	3162
183	TUDUN HATSI	3187
183	PINDIGA	175
183	POLICE C.I.D	3184
183	EMENEKE BUS STOP	3164
183	JEKA DA FARI	3172
183	BAGUNJE	3161
183	GADAM	1135
183	PIDINGA	3183
183	TAI	3186
183	ZAMBUK	3190
183	GELENGU	1137
183	BALANGA	1130
183	GELBUNU	3168
183	SHONGOM	1151
183	BILLIRI	166
183	DEBA	3163
183	TODI	1153
183	ASHAKA	1125
183	GOVERNMENT HOUSE	3170
183	BOH	1132
183	GADAWO	172
183	HERO GANA	3171
183	TUDUN WADA	3188
183	KWAMI	1145
183	GOMBE ABBA	1138
183	KUBUWA	1142
183	TANGLANG	176
183	AWKA	3159
183	KASHERE	174
183	NATADA	3181
183	AWAK	1126
183	NASSARAWO	3180
183	SHAMAKI	3185
183	MAIKAFO	1147
183	TONGO	177
183	GARIN HASHIDU	1136
183	KUMO	3175
185	DIOBE	1688
185	NSUKKA	4468
185	OPI	1708
185	MILIKE	1701
185	IHEAKPU AWKA	1697
185	OKUTU	1707
185	IHE ALUMONA	1695
185	OKPANDA	1705
185	UMUIDA	1712
185	OBUKPA	1703
185	OVOKO	1710
185	ENUGU- EZIKE	1691
185	UNADU	1714
185	OGBEDE	1704
185	ISI-UZO	1699
185	ICHI	1694
185	INYI ENUGU EZIKE	1698
185	EDEM -ANI	1689
185	IKEM	2263
185	OKPO	2307
185	IBAGWA-ANI	1693
185	LEJJA	1700
185	AKU	1687
185	IHEAKA	1696
185	IBAGWA-AKA	1692
185	UKEHE	1711
185	AJI	1686
185	ISI UZO	4467
185	EKWEGBWE	1690
185	OKPUJE	1706
185	OBOLLO-AFOR	1702
185	EHA AMUFU	2249
185	ADANI	1685
185	ORBA	1709
185	UMUITODO	1713
185	UZO-UWANI	1715
186	AMUFIE	3101
186	UGWUAJI	1121
186	AMAKWU	1090
186	ANINRI	1092
186	AMAOJI AGU NIKE	3094
186	CHINA TOWN	3104
186	UMUABI	1122
186	MBURUMBU	157
186	AKAGBE-UGWU	1083
186	IGBOEZE SOUTH	3114
186	UGWAWKA	3150
186	OJIAGU	1116
186	AMORJI-NIKE	1091
186	NKPOLOGWU-ENU	1109
186	AMAKOFIA	1089
186	UWAM	3156
186	AKOKWA-IDEATO	3088
186	EZEAGU	155
186	NIKE	3130
186	AGBANI  ROAD	3086
186	OZALLA	3146
186	ETTEH	3111
186	UDI ABIA	1118
186	ODUMA	1112
186	ENUGU	3109
186	UMULUMGBE	1123
186	NGURORE	3128
186	OGBOLI	3144
186	OZALA	1117
186	GABON VILLAGE	3112
186	AGBANI  TOWN	3087
186	MPU	3124
186	AMARA	3095
186	EHA AMUFU	556
186	ADANI	3085
186	NJODO NIKE	1107
186	ATTAKWU	1093
186	IKPAMODO	3116
186	9TH MILE CORNER	3080
186	AMACHALLA	3093
186	INYI	1100
186	NARA UNATEZE	1104
186	NKPOKITI	3137
186	ABAKPA NIKE	3083
186	UGWOGO NIKE	1119
186	EKE OBINAGU	3106
186	AMAECHI IDODO	1087
186	IHE	156
186	IJI NIKE	1099
186	UNN	3155
186	ALULU- NIKE	1086
186	AMMACHALLA	3099
186	AKPUGO (NKANU)	150
186	UDAH	3148
186	EMENE	3108
186	ACHI	148
186	AMAGUNZE	1088
186	IVO (LGA)	1102
186	UZO NWANI LGA	3157
186	AMMUGWU	3100
186	NACHI	1103
186	AKPUGO[NKANU]	3090
186	REPUBLIC LAYOUT	3147
186	UGBAWKA	165
186	AMECHI AWKNANAW	3096
186	MBU	3122
186	AMOKPO NIKE	153
186	AWGU	1094
186	NKPANI	3136
186	UMUNACHI- NIKE	1124
186	IKEM	564
186	AKPAKWUME	1084
186	ABAKPA	3082
186	INDEPENDENCE LAYOUT	3118
186	NEW HEAVEN	3127
186	AMMA GUNZE	3098
186	AMUGWU	154
186	UMMULUMGBE	3151
186	COLLERY SNR. STAFF QUATERS	3105
186	IMILIKI	3117
186	NKEREFI	1108
186	OPANDA	3145
186	OBE	1111
186	AKWNANAW	3091
186	NDIABOR	1105
186	NKANU EAST	3135
186	MGBOWO	158
186	AMECHI AWKANANAW	152
186	UMULOKPA	3153
186	ABAKALIKI	3081
186	AKWUKE	151
186	AGU-ABORHILL	1082
186	NKALAGU	161
186	ISHIAGU	1101
186	UMUNACHI NIKE	3154
186	ISI UZO  LGA	3119
186	ANIOCHA	3102
186	NACHA	3125
186	ENUGU CENTRAL	3110
186	IBAGWA-NIKE	1098
186	UDI	164
186	NKANU	3134
186	UGBO ODOGWU	3149
186	UGWU OBA	1120
186	ABOR	3084
186	NSUDE    (NBL SALES OFFICE)	1110
186	AGBOGWUGWU	1081
186	AWHUM	1095
186	OBINAGU	3142
186	AMA GUNZE	3092
186	ARMY BARRACKS	3103
186	UMUEZE EJEH	3152
186	OGBETE LAYOUT	3143
186	MEROGUN WATERSI	3123
186	NNI	3139
186	NNSUDE    (NBL SALES OFFICE)	3140
186	AKPOGA NIKE	1085
186	NEW HAVEN	3126
186	NNADO	3138
186	NINTH MILE	3131
186	EKEREMUO	3107
186	NGWO	3129
186	OBINAGU(EZEAGU LGA)	163
186	MMAKU	159
186	NKANU -EAST	162
186	OGBOLI- AWGU	1113
186	EGEDE	1096
186	NKANU	3132
186	NSUKKA	3141
186	AKPOF	3089
186	AFFA	149
186	NENWE	160
186	ITUKU	3121
186	OJI RIVER	1115
186	EKE	1097
186	IGBOEZE SOUTH NORTH	3115
186	ITICHI	3120
186	OGHE	1114
186	IDAW RIVER LAYOUT	3113
186	AMIKE	3097
186	NINTH MILE(9TH MILE)	1106
186	NKANU	3133
188	KWANDE	3618
188	YELWA SHENDAM	1425
188	GUMAU VILLAGE	1398
188	SABON LAYI/KWASHANGWA	3638
188	LANGTANG NORTH	1409
188	LERE LGA	3622
188	ROCKHAVEN	3636
188	BISICHI	3581
188	BARAKIN LADI	3573
188	CHAFE	3584
188	DADIN KOWA/KUFFANG	3587
188	BARDAWA	3574
188	DUCHI	1390
188	AMPER	1385
188	NARAGUTA	1415
188	BUKURU	3583
188	GIDIN DORUWA	3599
188	BARIKI LADI	3575
188	KURU	259
188	LAMINGA	3619
188	FOBUR	257
188	HOUSING ESTATE/LOCAL GOVERNMEN	3607
188	KADARKO	2273
188	TUDU WADA	3644
188	ALHERI/UTAN	3567
188	FADAU KERSHIN	3593
188	LERE	2282
188	BADEGI	3570
188	UNGUWAR KWANO/KAMFARI	3646
188	ZALLAKI	1426
188	RIKKOS/NASSARAWA	3635
188	SHEMDAM	3641
188	MUSHERE	1413
188	MANGUN	3626
188	APATA/SEMINARY/KATAKO	3569
188	MANGU	1412
188	DOGON AGOGO/SABON PEGI	3590
188	GINDIRI	1396
188	SHENDAM	1422
188	KADARKO (WUSE)	3614
188	RAYFIELD 	3633
188	MADO VILLAGE	3625
188	BOKKOS	3582
188	BASSA	554
188	BADIKO	3571
188	GARKAWA	1395
188	MARARABA JAMA'S	3628
188	DAKWAK	1388
188	BARIKIN LADI	3576
188	KERANG	1404
188	KURA FALLS	1405
188	KURGWI	1406
188	LIBERTY DAM/BRITISH AMERICA	3623
188	ANGLO JOS	3568
188	SAMILAKA	3639
188	MARAGUTA	3627
188	RAYFIED/MAI ADIKO	3632
188	BINCHI	3580
188	FARIN GADA	3594
188	SANGA	1421
188	TOWNSHIP STADIUM	3643
188	GANGARE/DILIMI	3597
188	TILDEN FULANI	272
188	MISTA-ALI	265
188	RAFIKI	267
188	KWALLA	1407
188	ZOLOGICAL GARDEN/HOUSE OF ASSE	3653
188	NAMU	1414
188	DONG	3591
188	DUH	1391
188	RUKUBA	269
188	YEWA SHENDAM	3649
188	DOEMARK	3589
188	HAWAN KIBO	1400
188	HOUSING ESTATE/LOCAL GOVERNMEN	3608
188	UNIJOS/UNGWAN/KWARARAFA/KASUWA	3647
188	GYEL	3604
188	KWAL	3617
188	DEOMARK	3588
188	KANKE	1403
188	K-VOM	260
188	POLICE COLLEGE KURU	266
188	UNIJOS/UNGWAN/KWARARAFA/KASUWA	3648
188	KANAM	1402
188	ANGULDI	255
188	DU	3592
188	MIANGO	264
188	GANAROPP	3595
188	FAJU	1392
188	RIYOM	1419
188	RIZEK	268
188	GENGERE	3598
188	TUNKUS	1423
188	MARABAN JAMA’A	263
188	GANGARE	3596
188	M.N.P.C. (DEPOT)	3624
188	PANKSHIN	1416
188	MISTALI VILLAGE	3630
188	GWANTU	2256
188	SAMINAKA	1420
188	GIRING/DOGON KARFE	3600
188	SATIZEN QUARY	270
188	BEJIN-DOKO	3579
188	HEIPANG	258
188	CHARANGI	3585
188	GUMAU	3601
188	ZOLOGICAL GARDEN/HOUSE OF ASSE	3652
188	NIPOST G.P.O/C.B.N	3631
188	TORO	273
188	QUAN-PAN	1418
188	JAGINDI	3609
188	GUT	3602
188	KATAKO	3616
188	TENTI	3642
188	SANGA LGA	3640
188	HOUSING ESTATE/LOCAL GOVERNMEN	3606
188	GANAROP	1393
188	VOM	274
188	ANGWARE	1386
188	CHERRY HILL	3586
188	HASKE	3605
188	LAKUSHI	1408
188	LAMINGO	262
188	JANTA	3610
188	NNPC DEPOT	2291
188	WASE	1424
188	JOS	3612
188	GWAUTU	3603
188	KWALL	261
188	BARKIN-LADI	1387
188	MABUDI	1411
188	LARANTO	3621
188	DENGI	1389
188	GANAWURI	1394
188	LANZAI	3620
188	JENGRE	1401
188	PANYAM	1417
188	TUDUN WADA/SECRETARIAT/HWOLSHE	3645
188	MIKANG	3629
188	SHERE HILLS	271
188	GUMAU JUNCTION	1397
188	 ZABOLO	3650
188	GWORI	1399
188	RUKUBA BARRACK	3637
188	JEBBU BASSA	3611
188	 ZAWAN VILLAGE	3651
188	KABONG	3613
188	DORUWA	256
188	LANGTANG SOUTH	1410
188	KANAM(DENGI)	3615
188	AMPANG WEST	1384
188	BARNAWA	3577
188	RIFIZA	3634
188	BAU	3578
188	BAGUDU	3572
190	KWAYA KUSAR	1616
190	Elkanemi islamic Theology	4102
190	Shehu's Palace	4147
190	London ciki	4125
190	GAJIGANA	4105
190	DAPCHI	4099
190	NNPC Depot	4140
190	Kasugula	4117
190	Zannari	4154
190	KADAKA	4114
190	BIU	2245
190	BAYO	4092
190	SHANI/HAWUL	1620
190	Tabra	4150
190	BAGA	1609
190	SHANNI	4146
190	Post Office	4145
190	BAMA/BANKI	1610
190	GWOZA	1614
190	Stadium	4148
190	KAGA	1615
190	Lamisula / mafoni	4124
190	Tandari	4151
190	Molai G. R. A.	4136
190	College of agric.	4097
190	MAMAMADURI	4133
190	KHADDAMARI	4119
190	Bolori	4094
190	Mbula Mel.	4135
190	Galdimary	4106
190	Nursing Home	4141
190	Coca Cola Factory	4096
190	Dugja	4101
190	G.R.A Police Station	4104
190	GUBIO	1613
190	Kidari	4120
190	MOBBAR	1618
190	Birmajugwal	4093
190	Garwashina	4107
190	DIKWA	4100
190	GAMBORU NGALA	1612
190	GEIDAM	4108
190	KONDUGA	4121
190	Pompamari Industrial	4144
190	Bulabulin	4095
190	Yerimari	4153
190	Ajari	4088
190	NIPOST Head Quarters	4139
190	ASKIRA/UBA	1608
190	Kangeleri	4116
190	KEAYA KUSAR	4118
190	Zarawuyaku	4155
190	Abuja	4087
190	Gwange	4111
190	NGALA	4138
190	MONGUNO	1619
190	State low cost	4149
190	MAIGATARI	4130
190	MAIDUGURI	4127
190	Mandara Abdu	4134
190	Pompamari Housing Estate	4143
190	MALAFATORI	4132
190	Police College	4142
190	JAKUSCO	4113
190	KWAYAKUSA	4123
190	MADAGALI	2283
190	ASKIRA UBA	4089
190	MAFA	4126
190	CHIBOK	1611
190	Government House	4110
190	MAFA/DIKWA	1617
190	GONIRI	4109
190	New G.R.A	4137
190	KUKAWA	4122
190	Maiduguri Flour mills	4128
190	Makintari	4131
190	BANKI	4091
190	FIKA	4103
190	DAMBOA	4098
190	WAKA BIUU	4152
190	HAWUL	4112
190	Kaigamari	4115
190	SHUWA	2320
190	BAMA	4090
192	FAKAI	991
192	EMIRS PALACE	2910
192	KANGIWA	998
192	RIMA QUARTERS	2937
192	NGASKI	2932
192	ALIERO	981
192	HILUKA	2918
192	BUNZA	987
192	GWANGE	2917
192	DOLE KAINA	2908
192	DG's QUATERS	2906
192	JEGA	996
192	MEKERA GANDU	2927
192	KAOJE	2920
192	DANKO WASAGU	2905
192	LIBATA	2924
192	GULUMBE	2916
192	TASHAR GARKUWA	2942
192	BIRNIN KEBI	2900
192	UNGUWAR WALI	2944
192	BAGUDO	985
192	BOMGOGOMO	2902
192	ANDARAI	982
192	RAFIN ATIKU	2936
192	DIRN DAJI	2907
192	G.R.A	2912
192	BIRNIN KEBBI	2899
192	KALGO	997
192	PRISON SERVICE	2935
192	AGWARA	2235
192	YELWA YAURI	2946
192	ARGUNGU	983
192	DAKIN GARI	2904
192	GWANDU	993
192	SURU	2941
192	SAKABA	2938
192	LOLO	1000
192	AUGIE	984
192	INGASKI	995
192	MAGAJIN RAFI	2925
192	UNGUWAR ZURU	2945
192	DIRIN DAJI	990
192	NEW PRISON QUATERS	2931
192	KOKANI SOUTH	2922
192	ZURU FADA	2949
192	SHANGA	2940
192	ZURU TUDUN WADA	2952
192	ZURU ZANGO	2953
192	KOKANI NORTH	2921
192	ZURU	1003
192	GAKAR JATAU	2913
192	BY PASS ROAD	2903
192	GALADIMA	2914
192	KAMBA	2919
192	GESSE LOW COST	2915
192	KARD	999
192	POLICE AREA COMMAND	2934
192	NASSARAWA II	2929
192	TWIN QUARTERS	2943
192	FANA	992
192	ILLO	994
192	MARKET	2926
192	SAURO	2939
192	BIRNIN YAURI	2901
192	ZURU JAKASSA EAST	2950
192	KOKO	2280
192	ZURU CENTRAL	2947
192	ZURU EMIRATE COUNCIL	2948
192	AMBURSA	2897
192	ETUNG LGA	2911
192	DANDI	989
192	YAURI	1002
192	AREWA DANDI	2898
192	NASSARAWA I	2928
192	EMIRS PALACE	2909
192	BULASA	986
192	DAKINGARI	988
192	MAIYAMA	1001
192	NEW MOTOR PARK	2930
192	NKASKI	2933
192	KOKO BESSE	2923
192	ZURU JAKASSA WEST	2951
194	ADO AWAYE	2685
194	AIYEDUN EKITI	2686
194	IJARE IRESE RD	2706
194	IPE AKOKO	808
194	OKE RUWA	2731
194	ISE  AKOKO	2716
194	ERUSU AKOKO	794
194	ONDO	823
194	ARIGIDI AKOKO	792
194	ARAROMI WATERSIDE	791
194	KAJOLA	2275
194	OKITIPUPA	821
194	ILODUN EKITI	2711
194	OKE ARO DANJUMA	2730
194	IFON	799
194	EDE GEDE AKOKO	2690
194	ORE	825
194	SOBE	2748
194	IJAPO ESTATE	2704
194	IFO OWO	2700
194	ILORO EKITI	2712
194	IJOMU	2708
194	APONMU	789
194	OKA AKOKO	818
194	OYINMO	2744
194	ISE  EKITI	2717
194	ODE IRELE	814
194	IFAKI EKITI	2699
194	IBARAM	795
194	IRUN	2715
194	ODO OWA	2726
194	FANINI ESTATE	2695
194	OMOTOSO	822
194	ILUTITUN	807
194	IGBARA OKE	84
194	HIGH COURT	2697
194	OTUTU EKITI	2740
194	NIPOST HEADQUARTERS	2722
194	ODE AYE	812
194	IKARAM	804
194	ILUPEJU EKITI	2713
194	ISUA AKOKO	811
194	OGBESE	2296
194	AJOWA AKOKO	786
194	SHAGARI VILLAGE	2747
194	OYEMEKUN	2743
194	OBA ILE	2723
194	OWENA	89
194	EKAN OYINMO	2692
194	IKARE AKOKO	805
194	IPE	2714
194	EDEGEDE AKOKO	2691
194	OMIPARAGA	2736
194	OSINLE SIJUADE ESTATE	2739
194	IGBOKODA	801
194	IGEDE EKITI	2702
194	OLUKARE'S PALACE	2735
194	ADO FURE	783
194	OBAS PALACE	2724
194	OGOTUN	2729
194	ILE OLUJI	806
194	USI EKITI	2749
194	ITAOGBOLU	88
194	OGBAGI AKOKO	817
194	OYE EKITI	2742
194	GBADARE ONDO BYE PASS	2696
194	OKE IGBO	820
194	AGADAGBA	784
194	IJU ODO	803
194	IBULE	796
194	IJARE	85
194	OKEGBE	2733
194	ONIPARAGA	824
194	IJAN  EKITI	2703
194	AKOTOGBO	787
194	IJU	86
194	SUPARE AKOKO	827
194	ILARA MOKIN	87
194	LISAGBEDE	2720
194	ALAGBAKA	2688
194	IDOGUN	798
194	IKU	2709
194	OFOSU	816
194	ODE EKITAN	813
194	OWO	826
194	AJEBANDELE	785
194	BOLORUNDURO	793
194	ODEYARE OKOJA	2725
194	OKORUN	2734
194	ARAROMI OBU	790
194	OGBAGI	2727
194	SCHOOL OF AGRIC	2746
194	IWOROKO 	2718
194	IYAHE	2719
194	OWODE	2741
194	ILARA -MOKIN	2710
194	RAMOKO EKITI 	2745
194	OGBUERURU-ORLU	2728
194	IDOANI	797
194	AKUNGBA AKOKO	788
194	MAKINDE	2721
194	ERUZU AKOKO	2694
194	IPELE	809
194	OKEARO	2732
194	EPIMMI	2693
194	IGBDE	2701
194	ORIN EKITI	2738
194	AKURE	2687
194	IGBEKEBO	800
194	IDANRE	83
194	IDO ANI	2698
194	IGBOTAKO	802
194	ODIGBO	815
194	IRUN AKOKO	810
194	AROMOKO EKITI	2689
194	OKE AGBE	819
194	ONDO TOWN	2737
\.


--
-- Data for Name: client_commission; Type: TABLE DATA; Schema: shipping; Owner: payarena
--

COPY shipping.client_commission (id, commission, commission_id, client_id) FROM stdin;
98	0.0100000000000000002	PERCENTAGE	96
199	0.0100000000000000002	PERCENTAGE	197
\.


--
-- Data for Name: generic_custom_shipper_endpoints; Type: TABLE DATA; Schema: shipping; Owner: payarena
--

COPY shipping.generic_custom_shipper_endpoints (generic_custom_shipper_id, label, url, endpoints_key) FROM stdin;
\.


--
-- Data for Name: order_detail; Type: TABLE DATA; Schema: shipping; Owner: payarena
--

COPY shipping.order_detail (id, description, order_id, order_no, order_ref, shipment_id, customer_code, delivery_address, delivery_locality, delivery_requested_time, delivery_station_id, destination_state, instant_delivery, payment_mode, pickup_address, pickup_locality, pickup_requested_date, pickup_requested_time, pickup_state, pickup_station_id, pickup_type, receiver_name, receiver_phone, receiver_town_id, recipient_email, sender_email, sender_name, sender_phone, sender_town_id, service_id, system_reference, vehicle_id, weight) FROM stdin;
99	Test Nike Jean	\N	PAYMALL-1	 	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
101	Leila sterling silver engagement ring\n\n	\N	PAYMALL-10173	 	102	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: order_detail_items; Type: TABLE DATA; Schema: shipping; Owner: payarena
--

COPY shipping.order_detail_items (order_detail_order_id, amount, color, delivery_city, delivery_contact_name, delivery_contact_number, delivery_google_place_address, delivery_landmark, delivery_state, description, id, item_type, name, pick_up_contact_name, pick_up_contact_number, pick_up_google_place_address, pick_up_landmark, pick_up_latitude, pick_up_longitude, pickup_city, pickup_state, quantity, shipment_type, size, weight, weight_range) FROM stdin;
\.


--
-- Data for Name: shipment; Type: TABLE DATA; Schema: shipping; Owner: payarena
--

COPY shipping.shipment (id, cost, created_date, message, shipment_status, tracking_no, client_id, order_detail_id, shipper_shipment, shipper_assigned_reference, shipper_assigned_tracking_no, status, shipper_id) FROM stdin;
100	964.28	2023-03-27 15:06:14.329233	Shipment Pickup Request Created Successully	SUCCESSFUL	SA01577054	96	99	1	\N	\N	\N	\N
102	964.28	2023-03-28 09:30:34.99214	Shipment Pickup Request Created Successully	SUCCESSFUL	SA01577634	96	101	1	\N	\N	\N	\N
\.


--
-- Data for Name: shipment_order_details; Type: TABLE DATA; Schema: shipping; Owner: payarena
--

COPY shipping.shipment_order_details (shipment_id, order_details_order_id) FROM stdin;
\.


--
-- Data for Name: shipper; Type: TABLE DATA; Schema: shipping; Owner: payarena
--

COPY shipping.shipper (dtype, id, access_token, api_type, base_url, biller_code, customer_code, customer_id, email, name, password, phone, shipper_id, status, token_auth_payload_type, token_constant, username, factory_id, type, api_key, auth_type) FROM stdin;
GigLogistics	3	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1laWQiOiJmMDJmZjE5Mi0xMWFmLTQ2YjYtYmQwYS1iZjExOGQwYzNkNDciLCJ1bmlxdWVfbmFtZSI6IkVDTzAwMTQ0OSIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vYWNjZXNzY29udHJvbHNlcnZpY2UvMjAxMC8wNy9jbGFpbXMvaWRlbnRpdHlwcm92aWRlciI6IkFTUC5ORVQgSWRlbnRpdHkiLCJBc3BOZXQuSWRlbnRpdHkuU2VjdXJpdHlTdGFtcCI6IjRmMmFhZDhkLTgwMTItNDc4Mi05MmQxLWM2NDM1MGRhMTcxMiIsInJvbGUiOiJUaGlyZFBhcnR5IiwiQWN0aXZpdHkiOlsiQ3JlYXRlLlRoaXJkUGFydHkiLCJEZWxldGUuVGhpcmRQYXJ0eSIsIlVwZGF0ZS5UaGlyZFBhcnR5IiwiVmlldy5UaGlyZFBhcnR5Il0sIlByaXZpbGVnZSI6IlB1YmxpYzpQdWJsaWMiLCJpc3MiOiJodHRwczovL2FnaWxpdHlzeXN0ZW1hcGlkZXZtLmF6dXJld2Vic2l0ZXMubmV0LyIsImF1ZCI6IjQxNGUxOTI3YTM4ODRmNjhhYmM3OWY3MjgzODM3ZmQxIiwiZXhwIjoxNjkzMTQwMDYwLCJuYmYiOjE2OTE0MTIwNjB9.8OQNhnHs-plS4-y-5rVxdQVYVJxvWRdsrfCnvYbUEyQ	t	https://giglthirdpartyapitestenv.azurewebsites.net/api/thirdparty	987675	f02ff192-11af-46b6-bd0a-bf118d0c3d47	\N	\N	GIGLOGISTICS	1234567	\N	76995882-8629-4af1-92b8-a1d3ce586cab	ACTIVE	JSON	f	ECO001449	\N	\N	\N	\N
RedStar	1	XUZCziRP9YsHdcsu0pSe2CNHtVpDrGHEAWJSyLTdrglB6EW3QuNDaT3mLMq59JXUZAccUzRL_5O0ViPiTHNrEnTamPCXlvUwq3n6OaZevMWnKU9CmWHn998DuEuXD0LkSXl7PlTNbuoSwzoDZDDgn8kSFdFdhtaVb5RfArFZbege-e6b-wtPprKR9u2B-QHgewGLhobW7raydAVQH0IhdU7CE1LHlrbFtjk5VgRC-jS71NjNhyz8K3DUgl4B48eZiCYD_VoLSc-qTKsAsiQz0XC4jKGsAXITskrHsbS-Zut8Um1KpNQiabadO5fwqEe4cNBVBJgKeZhMiaCGGNFgWnrmwz3ThkW0B5HFyx5u02YjydgI-WoytkD7mYDn3b0c04KqtdHhvtOgaGTYmRs75AxDxVKx9kywbUWDn5e9bXE	t	https://api.clicknship.com.ng	98767453	\N	\N	\N	REDSTAR	ClickNShip$12345	\N	2ad2e4ea-74e4-46b6-80df-f93396168397	ACTIVE	URL_ENCODED	f	cnsdemoapiacct	\N	\N	\N	\N
DellyMan	2	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiODc2In0.heKD_aXs2W39Qido3vhsztIqKwsvIKhtTuX_xpbo77Q	t	https://dev.dellyman.com/api/v3.0/	301817	\N	726	\N	DELLYMAN	vnp-1234	\N	5cb825a1-068a-4c09-9e0e-214a74d51429	ACTIVE	JSON	t	eplatform@up-ng.com	\N	\N	\N	\N
\.


--
-- Data for Name: shipper_apis; Type: TABLE DATA; Schema: shipping; Owner: payarena
--

COPY shipping.shipper_apis (shipper_id, endpoint, label, method, request_body, require_params, api_labels) FROM stdin;
2	/GetQuotes		POST	 	t	quote
2	/Cities?StateID=		POST	 	t	cities
2	/BookOrder		POST	 	t	book
2	/TrackOrder		POST	 	t	track
2	/Login	token	GET	 	t	token
2	/States		GET	 	f	states
\.


--
-- Data for Name: shipper_clients; Type: TABLE DATA; Schema: shipping; Owner: payarena
--

COPY shipping.shipper_clients (approved_shippers_id, clients_id) FROM stdin;
2	96
3	96
1	96
3	197
2	197
1	197
\.


--
-- Data for Name: shipper_modes_of_transportation; Type: TABLE DATA; Schema: shipping; Owner: payarena
--

COPY shipping.shipper_modes_of_transportation (shipper_id, modes_of_transportation) FROM stdin;
\.


--
-- Data for Name: state; Type: TABLE DATA; Schema: shipping; Owner: payarena
--

COPY shipping.state (id, state_id, state_name) FROM stdin;
103	36	YOBE
105	33	RIVERS
108	37	ZAMFARA
110	20	KANO
112	35	TARABA
114	4	AKWA IBOM
118	25	LAGOS
121	5	ANAMBRA
125	13	EDO
127	2	ABUJA
129	34	SOKOTO
131	14	EKITI
133	23	KOGI
135	24	KWARA
138	12	EBONYI
140	18	JIGAWA
142	21	KATSINA
144	28	OGUN
149	31	OYO
153	6	BAUCHI
155	19	KADUNA
158	27	NIGER
161	11	DELTA
165	30	OSUN
168	26	NASSARAWA
170	17	IMO
172	8	BENUE
174	7	BAYELSA
175	3	ADAMAWA
177	10	CROSS RIVER
179	1	ABIA
182	16	GOMBE
184	15	ENUGU
187	32	PLATEAU
189	9	BORNO
191	22	KEBBI
193	29	ONDO
\.


--
-- Data for Name: state_cities; Type: TABLE DATA; Schema: shipping; Owner: payarena
--

COPY shipping.state_cities (state_id, cities_id) FROM stdin;
\.


--
-- Data for Name: state_stations; Type: TABLE DATA; Schema: shipping; Owner: payarena
--

COPY shipping.state_stations (state_id, code, id, name, state) FROM stdin;
103	DAMATURU	54	DAMATURU	YOBE
105	BNY	39	BONNY	RIVERS
105	PHC	30	PORT HARCOURT	RIVERS
108	GUSAU	62	GUSAU	ZAMFARA
110	KAN	20	KANO	KANO
112	JALINGO	57	JALINGO	TARABA
114	UYO	33	UYO	AKWA IBOM
114	EKT	12	EKET	AKWA IBOM
118	GHI	297	GHANA INTERNATIONAL	LAGOS
118	LOS	4	LAGOS	LAGOS
121	NKA	46	NSUKKA	ANAMBRA
121	NNI	45	NNEWI	ANAMBRA
121	AWKA	9	AWKA	ANAMBRA
121	ONA	28	ONITSHA	ANAMBRA
125	AUC	8	AUCHI	EDO
125	BNI	6	BENIN	EDO
125	EKP	40	EKPOMA	EDO
127	ABV	3	ABUJA	FCT
127	GWA	41	GWAGWALADA	FCT
129	SKO	49	SOKOTO	SOKOTO
131	ADO	38	ADO EKITI	EKITI
133	LKJ	23	LOKOJA	KOGI
135	ILR	17	ILORIN	KWARA
138	ABL	37	ABAKALIKI	EBONYI
140	DUTSE	55	DUTSE	JIGAWA
142	KAS	43	KATSINA	KATSINA
144	OGUN	31	OGUN	OGUN
144	SOT	296	SANGO OTA	OGUN
144	IJB	42	IJEBU-ODE	OGUN
144	FUNAAB	280	ABEOKUTA(FUNAAB)	OGUN
144	ABEOKU	2	ABEOKUTA	OGUN
149	IFE	15	IFE	OYO
149	IBA	14	IBADAN	OYO
153	BAU	10	BAUCHI	BAUCHI
155	KAD	19	KADUNA	KADUNA
155	ZRI	36	ZARIA	KADUNA
158	MNA	26	MINNA	NIGER
161	UGHELLI	60	UGHELLI	DELTA
161	QRW	34	WARRI	DELTA
161	SAE	48	SAPELE	DELTA
161	ASA	7	ASABA	DELTA
165	OGBO	281	OGBOMOSHO	OSUN
165	OSO	47	OSOGBO	OSUN
168	NASARAWA	22	NASARAWA	NASARAWA
168	LFA	44	LAFIA	NASARAWA
170	ORI	29	OWERRI	IMO
172	MDI	25	MAKURDI	BENUE
174	BAYELSA	35	BAYELSA	BAYELSA
174	YEN	51	YENAGOA	BAYELSA
175	YOL	52	YOLA	ADAMAWA
177	CAL	11	CALABAR	CROSS RIVER
179	ABA	1	ABA	ABIA
179	ANAMBRA	27	ANAMBRA	ABIA
179	ABIA	32	ABIA	ABIA
179	UHA	50	UMUAHIA	ABIA
184	ENU	13	ENUGU	ENUGU
187	JOS	18	JOS	PLATEAU
189	MAI	24	MAIDUGURI	BORNO
191	BIRNIN KEBI	53	BIRNIN KEBI	KEBBI
193	AKE	5	AKURE	ONDO
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: shipping; Owner: payarena
--

COPY shipping.users (dtype, id, date_modified, email, name, password, phone, registration_date, status, user_id, settlement_type, wallet_id) FROM stdin;
Client	96	2023-03-28 09:30:35.1	client@payarena.com	PayArena Mall	$2a$10$2eq6If49FDAZxjTIofGS3O7AhRWXwJ5VxVEZjcu5Huu.KBHoYkiTa	08025365767	2023-03-27 14:59:39.982	0	9b058eb2-45be-47f6-a234-de6acac0a9d1	POSTPAID	97
Client	197	2023-07-26 13:45:19.067	info@zara.com	Zara Store	$2a$10$bVPG.p7ANcRGNqNs9ybYC.d4.zUpZK6j2xTTR0gNnLeSs/F8f.nM2	08025365767	2023-07-26 13:45:19.067	0	1699d34b-b47d-4270-8981-f66bf67f3209	POSTPAID	198
\.


--
-- Data for Name: wallet; Type: TABLE DATA; Schema: shipping; Owner: payarena
--

COPY shipping.wallet (id, balance, client_id) FROM stdin;
97	-1928.55999999999995	96
198	0	197
\.


--
-- Name: hibernate_sequence; Type: SEQUENCE SET; Schema: billing; Owner: payarena
--

SELECT pg_catalog.setval('billing.hibernate_sequence', 44, true);


--
-- Name: account_address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.account_address_id_seq', 80, true);


--
-- Name: account_profile_following_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.account_profile_following_id_seq', 28, true);


--
-- Name: account_profile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.account_profile_id_seq', 69, true);


--
-- Name: account_usercard_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.account_usercard_id_seq', 1, false);


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 196, true);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 84, true);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- Name: base_user_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.base_user_seq', 51, true);


--
-- Name: city_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.city_seq', 101, true);


--
-- Name: client_commission_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.client_commission_seq', 1, false);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 443, true);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 49, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 123, true);


--
-- Name: ecommerce_brand_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.ecommerce_brand_id_seq', 21, true);


--
-- Name: ecommerce_cart_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.ecommerce_cart_id_seq', 550, true);


--
-- Name: ecommerce_cartproduct_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.ecommerce_cartproduct_id_seq', 922, true);


--
-- Name: ecommerce_dailydeal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.ecommerce_dailydeal_id_seq', 2, true);


--
-- Name: ecommerce_image_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.ecommerce_image_id_seq', 273, true);


--
-- Name: ecommerce_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.ecommerce_order_id_seq', 102, true);


--
-- Name: ecommerce_orderentry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.ecommerce_orderentry_id_seq', 1, false);


--
-- Name: ecommerce_orderproduct_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.ecommerce_orderproduct_id_seq', 73, true);


--
-- Name: ecommerce_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.ecommerce_product_id_seq', 69, true);


--
-- Name: ecommerce_productcategory_brands_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.ecommerce_productcategory_brands_id_seq', 19, true);


--
-- Name: ecommerce_productcategory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.ecommerce_productcategory_id_seq', 47, true);


--
-- Name: ecommerce_productdetail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.ecommerce_productdetail_id_seq', 87, true);


--
-- Name: ecommerce_productimage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.ecommerce_productimage_id_seq', 25, true);


--
-- Name: ecommerce_productreview_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.ecommerce_productreview_id_seq', 2, true);


--
-- Name: ecommerce_producttype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.ecommerce_producttype_id_seq', 15, true);


--
-- Name: ecommerce_productwishlist_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.ecommerce_productwishlist_id_seq', 56, true);


--
-- Name: ecommerce_promo_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.ecommerce_promo_category_id_seq', 51, true);


--
-- Name: ecommerce_promo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.ecommerce_promo_id_seq', 49, true);


--
-- Name: ecommerce_promo_merchant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.ecommerce_promo_merchant_id_seq', 50, true);


--
-- Name: ecommerce_promo_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.ecommerce_promo_product_id_seq', 200, true);


--
-- Name: ecommerce_promo_product_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.ecommerce_promo_product_type_id_seq', 7, true);


--
-- Name: ecommerce_promo_sub_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.ecommerce_promo_sub_category_id_seq', 23, true);


--
-- Name: ecommerce_returnedproduct_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.ecommerce_returnedproduct_id_seq', 1, true);


--
-- Name: ecommerce_returnproductimage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.ecommerce_returnproductimage_id_seq', 1, false);


--
-- Name: ecommerce_returnreason_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.ecommerce_returnreason_id_seq', 5, true);


--
-- Name: ecommerce_shipper_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.ecommerce_shipper_id_seq', 1, false);


--
-- Name: merchant_bankaccount_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.merchant_bankaccount_id_seq', 28, true);


--
-- Name: merchant_bulkuploadfile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.merchant_bulkuploadfile_id_seq', 44, true);


--
-- Name: merchant_director_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.merchant_director_id_seq', 1, false);


--
-- Name: merchant_merchantbanner_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.merchant_merchantbanner_id_seq', 11, true);


--
-- Name: merchant_seller_follower_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.merchant_seller_follower_id_seq', 1, false);


--
-- Name: merchant_seller_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.merchant_seller_id_seq', 35, true);


--
-- Name: merchant_sellerdetail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.merchant_sellerdetail_id_seq', 31, true);


--
-- Name: merchant_sellerfile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.merchant_sellerfile_id_seq', 5, true);


--
-- Name: order_detail_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.order_detail_seq', 1, false);


--
-- Name: shipment_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.shipment_seq', 1, false);


--
-- Name: shipper_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.shipper_seq', 51, true);


--
-- Name: state_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.state_seq', 51, true);


--
-- Name: store_store_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.store_store_categories_id_seq', 39, true);


--
-- Name: store_store_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.store_store_id_seq', 34, true);


--
-- Name: superadmin_adminuser_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.superadmin_adminuser_id_seq', 7, true);


--
-- Name: superadmin_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.superadmin_role_id_seq', 4, true);


--
-- Name: transaction_merchanttransaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.transaction_merchanttransaction_id_seq', 14, true);


--
-- Name: transaction_transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.transaction_transaction_id_seq', 174, true);


--
-- Name: wallet_seq; Type: SEQUENCE SET; Schema: public; Owner: payarena
--

SELECT pg_catalog.setval('public.wallet_seq', 1, false);


--
-- Name: base_user_seq; Type: SEQUENCE SET; Schema: shipping; Owner: payarena
--

SELECT pg_catalog.setval('shipping.base_user_seq', 1, false);


--
-- Name: city_seq; Type: SEQUENCE SET; Schema: shipping; Owner: payarena
--

SELECT pg_catalog.setval('shipping.city_seq', 1, false);


--
-- Name: client_commission_seq; Type: SEQUENCE SET; Schema: shipping; Owner: payarena
--

SELECT pg_catalog.setval('shipping.client_commission_seq', 1, false);


--
-- Name: hibernate_sequence; Type: SEQUENCE SET; Schema: shipping; Owner: payarena
--

SELECT pg_catalog.setval('shipping.hibernate_sequence', 199, true);


--
-- Name: order_detail_seq; Type: SEQUENCE SET; Schema: shipping; Owner: payarena
--

SELECT pg_catalog.setval('shipping.order_detail_seq', 1, false);


--
-- Name: shipment_seq; Type: SEQUENCE SET; Schema: shipping; Owner: payarena
--

SELECT pg_catalog.setval('shipping.shipment_seq', 1, false);


--
-- Name: shipper_seq; Type: SEQUENCE SET; Schema: shipping; Owner: payarena
--

SELECT pg_catalog.setval('shipping.shipper_seq', 1, false);


--
-- Name: state_seq; Type: SEQUENCE SET; Schema: shipping; Owner: payarena
--

SELECT pg_catalog.setval('shipping.state_seq', 1, false);


--
-- Name: wallet_seq; Type: SEQUENCE SET; Schema: shipping; Owner: payarena
--

SELECT pg_catalog.setval('shipping.wallet_seq', 1, false);


--
-- Name: base_user_approved_payment_types base_user_approved_payment_types_pkey; Type: CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.base_user_approved_payment_types
    ADD CONSTRAINT base_user_approved_payment_types_pkey PRIMARY KEY (company_id, approved_payment_types_id);


--
-- Name: base_user_customers base_user_customers_pkey; Type: CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.base_user_customers
    ADD CONSTRAINT base_user_customers_pkey PRIMARY KEY (company_id, customers_id);


--
-- Name: base_user base_user_pkey; Type: CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.base_user
    ADD CONSTRAINT base_user_pkey PRIMARY KEY (id);


--
-- Name: company_settings_billing_details company_settings_billing_details_pkey; Type: CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.company_settings_billing_details
    ADD CONSTRAINT company_settings_billing_details_pkey PRIMARY KEY (company_settings_id, billing_details_label);


--
-- Name: company_settings company_settings_pkey; Type: CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.company_settings
    ADD CONSTRAINT company_settings_pkey PRIMARY KEY (id);


--
-- Name: customer_payment_details_payment_info customer_payment_details_payment_info_pkey; Type: CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.customer_payment_details_payment_info
    ADD CONSTRAINT customer_payment_details_payment_info_pkey PRIMARY KEY (customer_payment_details_id, payment_info_key);


--
-- Name: customer_payment_details customer_payment_details_pkey; Type: CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.customer_payment_details
    ADD CONSTRAINT customer_payment_details_pkey PRIMARY KEY (id);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);


--
-- Name: payment_provider payment_provider_pkey; Type: CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.payment_provider
    ADD CONSTRAINT payment_provider_pkey PRIMARY KEY (id);


--
-- Name: payment_type_adopted_companies payment_type_adopted_companies_pkey; Type: CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.payment_type_adopted_companies
    ADD CONSTRAINT payment_type_adopted_companies_pkey PRIMARY KEY (payment_type_id, adopted_companies_id);


--
-- Name: payment_type payment_type_pkey; Type: CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.payment_type
    ADD CONSTRAINT payment_type_pkey PRIMARY KEY (id);


--
-- Name: provider_payment_type_fk provider_payment_type_fk_pkey; Type: CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.provider_payment_type_fk
    ADD CONSTRAINT provider_payment_type_fk_pkey PRIMARY KEY (payment_provider_id, payment_types_key);


--
-- Name: transaction transaction_pkey; Type: CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.transaction
    ADD CONSTRAINT transaction_pkey PRIMARY KEY (id);


--
-- Name: base_user uk_b4hwa8i589s1em8fh6wn5gw4a; Type: CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.base_user
    ADD CONSTRAINT uk_b4hwa8i589s1em8fh6wn5gw4a UNIQUE (email);


--
-- Name: base_user_customers uk_exfq9j3xhh4s42dqvlbyhxnrd; Type: CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.base_user_customers
    ADD CONSTRAINT uk_exfq9j3xhh4s42dqvlbyhxnrd UNIQUE (customers_id);


--
-- Name: wallet wallet_pkey; Type: CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.wallet
    ADD CONSTRAINT wallet_pkey PRIMARY KEY (id);


--
-- Name: account_address account_address_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.account_address
    ADD CONSTRAINT account_address_pkey PRIMARY KEY (id);


--
-- Name: account_profile_following account_profile_following_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.account_profile_following
    ADD CONSTRAINT account_profile_following_pkey PRIMARY KEY (id);


--
-- Name: account_profile_following account_profile_following_profile_id_store_id_ecbf5fd3_uniq; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.account_profile_following
    ADD CONSTRAINT account_profile_following_profile_id_store_id_ecbf5fd3_uniq UNIQUE (profile_id, store_id);


--
-- Name: account_profile account_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.account_profile
    ADD CONSTRAINT account_profile_pkey PRIMARY KEY (id);


--
-- Name: account_profile account_profile_user_id_key; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.account_profile
    ADD CONSTRAINT account_profile_user_id_key UNIQUE (user_id);


--
-- Name: account_usercard account_usercard_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.account_usercard
    ADD CONSTRAINT account_usercard_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: authtoken_token authtoken_token_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.authtoken_token
    ADD CONSTRAINT authtoken_token_pkey PRIMARY KEY (key);


--
-- Name: authtoken_token authtoken_token_user_id_key; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.authtoken_token
    ADD CONSTRAINT authtoken_token_user_id_key UNIQUE (user_id);


--
-- Name: base_user_approved_shippers base_user_approved_shippers_approved_shippers_id_key; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.base_user_approved_shippers
    ADD CONSTRAINT base_user_approved_shippers_approved_shippers_id_key UNIQUE (approved_shippers_id);


--
-- Name: base_user_approved_shippers base_user_approved_shippers_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.base_user_approved_shippers
    ADD CONSTRAINT base_user_approved_shippers_pkey PRIMARY KEY (approved_shippers_key, client_id);


--
-- Name: base_user base_user_commission_type_id_key; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.base_user
    ADD CONSTRAINT base_user_commission_type_id_key UNIQUE (commission_type_id);


--
-- Name: base_user base_user_email_key; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.base_user
    ADD CONSTRAINT base_user_email_key UNIQUE (email);


--
-- Name: base_user base_user_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.base_user
    ADD CONSTRAINT base_user_pkey PRIMARY KEY (id);


--
-- Name: base_user_shipments base_user_shipments_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.base_user_shipments
    ADD CONSTRAINT base_user_shipments_pkey PRIMARY KEY (client_id, shipments_id);


--
-- Name: base_user_shipments base_user_shipments_shipments_id_key; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.base_user_shipments
    ADD CONSTRAINT base_user_shipments_shipments_id_key UNIQUE (shipments_id);


--
-- Name: base_user base_user_user_id_key; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.base_user
    ADD CONSTRAINT base_user_user_id_key UNIQUE (user_id);


--
-- Name: base_user base_user_wallet_id_key; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.base_user
    ADD CONSTRAINT base_user_wallet_id_key UNIQUE (wallet_id);


--
-- Name: city city_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.city
    ADD CONSTRAINT city_pkey PRIMARY KEY (id);


--
-- Name: client_commission client_commission_client_id_key; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.client_commission
    ADD CONSTRAINT client_commission_client_id_key UNIQUE (client_id);


--
-- Name: client_commission client_commission_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.client_commission
    ADD CONSTRAINT client_commission_pkey PRIMARY KEY (id);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: ecommerce_brand ecommerce_brand_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_brand
    ADD CONSTRAINT ecommerce_brand_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_cart ecommerce_cart_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_cart
    ADD CONSTRAINT ecommerce_cart_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_cartproduct ecommerce_cartproduct_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_cartproduct
    ADD CONSTRAINT ecommerce_cartproduct_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_dailydeal ecommerce_dailydeal_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_dailydeal
    ADD CONSTRAINT ecommerce_dailydeal_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_image ecommerce_image_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_image
    ADD CONSTRAINT ecommerce_image_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_order ecommerce_order_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_order
    ADD CONSTRAINT ecommerce_order_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_orderentry ecommerce_orderentry_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_orderentry
    ADD CONSTRAINT ecommerce_orderentry_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_orderproduct ecommerce_orderproduct_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_orderproduct
    ADD CONSTRAINT ecommerce_orderproduct_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_product ecommerce_product_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_product
    ADD CONSTRAINT ecommerce_product_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_product ecommerce_product_slug_2644eea2_uniq; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_product
    ADD CONSTRAINT ecommerce_product_slug_2644eea2_uniq UNIQUE (slug);


--
-- Name: ecommerce_productcategory_brands ecommerce_productcategor_productcategory_id_brand_ba79773d_uniq; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_productcategory_brands
    ADD CONSTRAINT ecommerce_productcategor_productcategory_id_brand_ba79773d_uniq UNIQUE (productcategory_id, brand_id);


--
-- Name: ecommerce_productcategory_brands ecommerce_productcategory_brands_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_productcategory_brands
    ADD CONSTRAINT ecommerce_productcategory_brands_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_productcategory ecommerce_productcategory_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_productcategory
    ADD CONSTRAINT ecommerce_productcategory_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_productdetail ecommerce_productdetail_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_productdetail
    ADD CONSTRAINT ecommerce_productdetail_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_productimage ecommerce_productimage_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_productimage
    ADD CONSTRAINT ecommerce_productimage_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_productreview ecommerce_productreview_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_productreview
    ADD CONSTRAINT ecommerce_productreview_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_producttype ecommerce_producttype_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_producttype
    ADD CONSTRAINT ecommerce_producttype_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_productwishlist ecommerce_productwishlist_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_productwishlist
    ADD CONSTRAINT ecommerce_productwishlist_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_promo_category ecommerce_promo_category_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_promo_category
    ADD CONSTRAINT ecommerce_promo_category_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_promo_category ecommerce_promo_category_promo_id_productcategory_45ab3a15_uniq; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_promo_category
    ADD CONSTRAINT ecommerce_promo_category_promo_id_productcategory_45ab3a15_uniq UNIQUE (promo_id, productcategory_id);


--
-- Name: ecommerce_promo_merchant ecommerce_promo_merchant_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_promo_merchant
    ADD CONSTRAINT ecommerce_promo_merchant_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_promo_merchant ecommerce_promo_merchant_promo_id_seller_id_de06850b_uniq; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_promo_merchant
    ADD CONSTRAINT ecommerce_promo_merchant_promo_id_seller_id_de06850b_uniq UNIQUE (promo_id, seller_id);


--
-- Name: ecommerce_promo ecommerce_promo_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_promo
    ADD CONSTRAINT ecommerce_promo_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_promo_product_type ecommerce_promo_product__promo_id_producttype_id_a96823bf_uniq; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_promo_product_type
    ADD CONSTRAINT ecommerce_promo_product__promo_id_producttype_id_a96823bf_uniq UNIQUE (promo_id, producttype_id);


--
-- Name: ecommerce_promo_product ecommerce_promo_product_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_promo_product
    ADD CONSTRAINT ecommerce_promo_product_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_promo_product ecommerce_promo_product_promo_id_product_id_009065d7_uniq; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_promo_product
    ADD CONSTRAINT ecommerce_promo_product_promo_id_product_id_009065d7_uniq UNIQUE (promo_id, product_id);


--
-- Name: ecommerce_promo_product_type ecommerce_promo_product_type_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_promo_product_type
    ADD CONSTRAINT ecommerce_promo_product_type_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_promo_sub_category ecommerce_promo_sub_cate_promo_id_productcategory_6b909cb2_uniq; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_promo_sub_category
    ADD CONSTRAINT ecommerce_promo_sub_cate_promo_id_productcategory_6b909cb2_uniq UNIQUE (promo_id, productcategory_id);


--
-- Name: ecommerce_promo_sub_category ecommerce_promo_sub_category_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_promo_sub_category
    ADD CONSTRAINT ecommerce_promo_sub_category_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_returnedproduct ecommerce_returnedproduct_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_returnedproduct
    ADD CONSTRAINT ecommerce_returnedproduct_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_returnproductimage ecommerce_returnproductimage_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_returnproductimage
    ADD CONSTRAINT ecommerce_returnproductimage_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_returnreason ecommerce_returnreason_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_returnreason
    ADD CONSTRAINT ecommerce_returnreason_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_shipper ecommerce_shipper_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_shipper
    ADD CONSTRAINT ecommerce_shipper_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_shipper ecommerce_shipper_slug_key; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_shipper
    ADD CONSTRAINT ecommerce_shipper_slug_key UNIQUE (slug);


--
-- Name: generic_custom_shipper_endpoints generic_custom_shipper_endpoints_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.generic_custom_shipper_endpoints
    ADD CONSTRAINT generic_custom_shipper_endpoints_pkey PRIMARY KEY (endpoints_key, generic_custom_shipper_id);


--
-- Name: merchant_bankaccount merchant_bankaccount_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.merchant_bankaccount
    ADD CONSTRAINT merchant_bankaccount_pkey PRIMARY KEY (id);


--
-- Name: merchant_bulkuploadfile merchant_bulkuploadfile_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.merchant_bulkuploadfile
    ADD CONSTRAINT merchant_bulkuploadfile_pkey PRIMARY KEY (id);


--
-- Name: merchant_director merchant_director_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.merchant_director
    ADD CONSTRAINT merchant_director_pkey PRIMARY KEY (id);


--
-- Name: merchant_merchantbanner merchant_merchantbanner_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.merchant_merchantbanner
    ADD CONSTRAINT merchant_merchantbanner_pkey PRIMARY KEY (id);


--
-- Name: merchant_seller_follower merchant_seller_follower_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.merchant_seller_follower
    ADD CONSTRAINT merchant_seller_follower_pkey PRIMARY KEY (id);


--
-- Name: merchant_seller_follower merchant_seller_follower_seller_id_user_id_899cd865_uniq; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.merchant_seller_follower
    ADD CONSTRAINT merchant_seller_follower_seller_id_user_id_899cd865_uniq UNIQUE (seller_id, user_id);


--
-- Name: merchant_seller merchant_seller_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.merchant_seller
    ADD CONSTRAINT merchant_seller_pkey PRIMARY KEY (id);


--
-- Name: merchant_sellerdetail merchant_sellerdetail_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.merchant_sellerdetail
    ADD CONSTRAINT merchant_sellerdetail_pkey PRIMARY KEY (id);


--
-- Name: merchant_sellerdetail merchant_sellerdetail_seller_id_key; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.merchant_sellerdetail
    ADD CONSTRAINT merchant_sellerdetail_seller_id_key UNIQUE (seller_id);


--
-- Name: merchant_sellerfile merchant_sellerfile_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.merchant_sellerfile
    ADD CONSTRAINT merchant_sellerfile_pkey PRIMARY KEY (id);


--
-- Name: order_detail order_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_pkey PRIMARY KEY (order_id);


--
-- Name: shipment_order_details shipment_order_details_order_details_order_id_key; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.shipment_order_details
    ADD CONSTRAINT shipment_order_details_order_details_order_id_key UNIQUE (order_details_order_id);


--
-- Name: shipment shipment_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.shipment
    ADD CONSTRAINT shipment_pkey PRIMARY KEY (id);


--
-- Name: shipper_apis shipper_apis_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.shipper_apis
    ADD CONSTRAINT shipper_apis_pkey PRIMARY KEY (shipper_id, api_labels);


--
-- Name: shipper_clients shipper_clients_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.shipper_clients
    ADD CONSTRAINT shipper_clients_pkey PRIMARY KEY (approved_shippers_id, clients_id);


--
-- Name: shipper shipper_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.shipper
    ADD CONSTRAINT shipper_pkey PRIMARY KEY (id);


--
-- Name: shipper shipper_shipper_id_key; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.shipper
    ADD CONSTRAINT shipper_shipper_id_key UNIQUE (shipper_id);


--
-- Name: state_cities state_cities_cities_id_key; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.state_cities
    ADD CONSTRAINT state_cities_cities_id_key UNIQUE (cities_id);


--
-- Name: state_cities state_cities_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.state_cities
    ADD CONSTRAINT state_cities_pkey PRIMARY KEY (cities_id, state_id);


--
-- Name: state state_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.state
    ADD CONSTRAINT state_pkey PRIMARY KEY (id);


--
-- Name: state state_state_id_key; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.state
    ADD CONSTRAINT state_state_id_key UNIQUE (state_id);


--
-- Name: state state_state_name_key; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.state
    ADD CONSTRAINT state_state_name_key UNIQUE (state_name);


--
-- Name: store_store_categories store_store_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.store_store_categories
    ADD CONSTRAINT store_store_categories_pkey PRIMARY KEY (id);


--
-- Name: store_store_categories store_store_categories_store_id_productcategory_e5f65a8c_uniq; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.store_store_categories
    ADD CONSTRAINT store_store_categories_store_id_productcategory_e5f65a8c_uniq UNIQUE (store_id, productcategory_id);


--
-- Name: store_store store_store_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.store_store
    ADD CONSTRAINT store_store_pkey PRIMARY KEY (id);


--
-- Name: superadmin_adminuser superadmin_adminuser_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.superadmin_adminuser
    ADD CONSTRAINT superadmin_adminuser_pkey PRIMARY KEY (id);


--
-- Name: superadmin_adminuser superadmin_adminuser_user_id_key; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.superadmin_adminuser
    ADD CONSTRAINT superadmin_adminuser_user_id_key UNIQUE (user_id);


--
-- Name: superadmin_role superadmin_role_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.superadmin_role
    ADD CONSTRAINT superadmin_role_pkey PRIMARY KEY (id);


--
-- Name: transaction_merchanttransaction transaction_merchanttransaction_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.transaction_merchanttransaction
    ADD CONSTRAINT transaction_merchanttransaction_pkey PRIMARY KEY (id);


--
-- Name: transaction_transaction transaction_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.transaction_transaction
    ADD CONSTRAINT transaction_transaction_pkey PRIMARY KEY (id);


--
-- Name: users uk_6dotkott2kjsp8vw4d0m25fb7; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uk_6dotkott2kjsp8vw4d0m25fb7 UNIQUE (email);


--
-- Name: users uk_6efs5vmce86ymf5q7lmvn2uuf; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uk_6efs5vmce86ymf5q7lmvn2uuf UNIQUE (user_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: wallet wallet_client_id_key; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.wallet
    ADD CONSTRAINT wallet_client_id_key UNIQUE (client_id);


--
-- Name: wallet wallet_pkey; Type: CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.wallet
    ADD CONSTRAINT wallet_pkey PRIMARY KEY (id);


--
-- Name: base_user_approved_shippers base_user_approved_shippers_pkey; Type: CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.base_user_approved_shippers
    ADD CONSTRAINT base_user_approved_shippers_pkey PRIMARY KEY (client_id, approved_shippers_key);


--
-- Name: base_user base_user_pkey; Type: CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.base_user
    ADD CONSTRAINT base_user_pkey PRIMARY KEY (id);


--
-- Name: base_user_shipments base_user_shipments_pkey; Type: CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.base_user_shipments
    ADD CONSTRAINT base_user_shipments_pkey PRIMARY KEY (client_id, shipments_id);


--
-- Name: city city_pkey; Type: CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.city
    ADD CONSTRAINT city_pkey PRIMARY KEY (id);


--
-- Name: client_commission client_commission_pkey; Type: CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.client_commission
    ADD CONSTRAINT client_commission_pkey PRIMARY KEY (id);


--
-- Name: generic_custom_shipper_endpoints generic_custom_shipper_endpoints_pkey; Type: CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.generic_custom_shipper_endpoints
    ADD CONSTRAINT generic_custom_shipper_endpoints_pkey PRIMARY KEY (generic_custom_shipper_id, endpoints_key);


--
-- Name: order_detail order_detail_pkey; Type: CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.order_detail
    ADD CONSTRAINT order_detail_pkey PRIMARY KEY (id);


--
-- Name: shipment shipment_pkey; Type: CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.shipment
    ADD CONSTRAINT shipment_pkey PRIMARY KEY (id);


--
-- Name: shipper_apis shipper_apis_pkey; Type: CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.shipper_apis
    ADD CONSTRAINT shipper_apis_pkey PRIMARY KEY (shipper_id, api_labels);


--
-- Name: shipper_clients shipper_clients_pkey; Type: CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.shipper_clients
    ADD CONSTRAINT shipper_clients_pkey PRIMARY KEY (approved_shippers_id, clients_id);


--
-- Name: shipper shipper_pkey; Type: CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.shipper
    ADD CONSTRAINT shipper_pkey PRIMARY KEY (id);


--
-- Name: state_cities state_cities_pkey; Type: CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.state_cities
    ADD CONSTRAINT state_cities_pkey PRIMARY KEY (state_id, cities_id);


--
-- Name: state state_pkey; Type: CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.state
    ADD CONSTRAINT state_pkey PRIMARY KEY (id);


--
-- Name: base_user_shipments uk_327tygt0s7g2m34w6p86sr5r4; Type: CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.base_user_shipments
    ADD CONSTRAINT uk_327tygt0s7g2m34w6p86sr5r4 UNIQUE (shipments_id);


--
-- Name: base_user_approved_shippers uk_53lg8p9sc0b9r2woy2k0d4knd; Type: CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.base_user_approved_shippers
    ADD CONSTRAINT uk_53lg8p9sc0b9r2woy2k0d4knd UNIQUE (approved_shippers_id);


--
-- Name: shipper uk_68cpt5y7qh7gv9m4swbw0e2rc; Type: CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.shipper
    ADD CONSTRAINT uk_68cpt5y7qh7gv9m4swbw0e2rc UNIQUE (shipper_id);


--
-- Name: users uk_6dotkott2kjsp8vw4d0m25fb7; Type: CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.users
    ADD CONSTRAINT uk_6dotkott2kjsp8vw4d0m25fb7 UNIQUE (email);


--
-- Name: users uk_6efs5vmce86ymf5q7lmvn2uuf; Type: CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.users
    ADD CONSTRAINT uk_6efs5vmce86ymf5q7lmvn2uuf UNIQUE (user_id);


--
-- Name: base_user uk_92luaulhtsc3iul2xa5otp7l8; Type: CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.base_user
    ADD CONSTRAINT uk_92luaulhtsc3iul2xa5otp7l8 UNIQUE (user_id);


--
-- Name: base_user uk_b4hwa8i589s1em8fh6wn5gw4a; Type: CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.base_user
    ADD CONSTRAINT uk_b4hwa8i589s1em8fh6wn5gw4a UNIQUE (email);


--
-- Name: base_user uk_bqg536o8lvj8b7u5ndt8svdmp; Type: CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.base_user
    ADD CONSTRAINT uk_bqg536o8lvj8b7u5ndt8svdmp UNIQUE (commission_type_id);


--
-- Name: shipment_order_details uk_gahpxqo818sg7fi8paawv2cbi; Type: CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.shipment_order_details
    ADD CONSTRAINT uk_gahpxqo818sg7fi8paawv2cbi UNIQUE (order_details_order_id);


--
-- Name: state_cities uk_gj2lfi3uw998e8etrpthd7knq; Type: CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.state_cities
    ADD CONSTRAINT uk_gj2lfi3uw998e8etrpthd7knq UNIQUE (cities_id);


--
-- Name: base_user uk_lt1xvfkwo6tf1q5iyqs3sq9i3; Type: CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.base_user
    ADD CONSTRAINT uk_lt1xvfkwo6tf1q5iyqs3sq9i3 UNIQUE (wallet_id);


--
-- Name: shipper uk_nx3gatbnkqu3624h7jbb45hss; Type: CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.shipper
    ADD CONSTRAINT uk_nx3gatbnkqu3624h7jbb45hss UNIQUE (username);


--
-- Name: state uk_puh4b4w1dwwxr2bp5d73heovb; Type: CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.state
    ADD CONSTRAINT uk_puh4b4w1dwwxr2bp5d73heovb UNIQUE (state_id);


--
-- Name: state uk_qtjsbpmp2ejq0753ktldenyqo; Type: CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.state
    ADD CONSTRAINT uk_qtjsbpmp2ejq0753ktldenyqo UNIQUE (state_name);


--
-- Name: order_detail uk_r55n7ieoh0nx1dvsisurugqic; Type: CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.order_detail
    ADD CONSTRAINT uk_r55n7ieoh0nx1dvsisurugqic UNIQUE (order_no);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: wallet wallet_pkey; Type: CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.wallet
    ADD CONSTRAINT wallet_pkey PRIMARY KEY (id);


--
-- Name: account_address_customer_id_752e23ab; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX account_address_customer_id_752e23ab ON public.account_address USING btree (customer_id);


--
-- Name: account_profile_following_profile_id_0016a31b; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX account_profile_following_profile_id_0016a31b ON public.account_profile_following USING btree (profile_id);


--
-- Name: account_profile_following_store_id_401027f6; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX account_profile_following_store_id_401027f6 ON public.account_profile_following USING btree (store_id);


--
-- Name: account_usercard_profile_id_37824d40; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX account_usercard_profile_id_37824d40 ON public.account_usercard USING btree (profile_id);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- Name: authtoken_token_key_10f0b77e_like; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX authtoken_token_key_10f0b77e_like ON public.authtoken_token USING btree (key varchar_pattern_ops);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: ecommerce_cart_user_id_d140a08b; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_cart_user_id_d140a08b ON public.ecommerce_cart USING btree (user_id);


--
-- Name: ecommerce_cartproduct_cart_id_679c2fdb; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_cartproduct_cart_id_679c2fdb ON public.ecommerce_cartproduct USING btree (cart_id);


--
-- Name: ecommerce_cartproduct_product_detail_id_844b79de; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_cartproduct_product_detail_id_844b79de ON public.ecommerce_cartproduct USING btree (product_detail_id);


--
-- Name: ecommerce_dailydeal_product_id_f1b1361c; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_dailydeal_product_id_f1b1361c ON public.ecommerce_dailydeal USING btree (product_id);


--
-- Name: ecommerce_o_item_to_b12b29_idx; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_o_item_to_b12b29_idx ON public.ecommerce_orderentry USING btree (item_total, management_fee, delivery_fee, total, status, order_no, tracking_id, merchant_settled, created_on, updated_on);


--
-- Name: ecommerce_o_price_7a94a5_idx; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_o_price_7a94a5_idx ON public.ecommerce_orderproduct USING btree (price, quantity, discount, total, status, delivery_date, created_on, updated_on, cancelled_on, packed_on, shipped_on, delivered_on, returned_on, payment_on, refunded_on, request_for_return);


--
-- Name: ecommerce_order_address_id_93a4db03; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_order_address_id_93a4db03 ON public.ecommerce_order USING btree (address_id);


--
-- Name: ecommerce_order_cart_id_ee2246e6; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_order_cart_id_ee2246e6 ON public.ecommerce_order USING btree (cart_id);


--
-- Name: ecommerce_order_customer_id_40daaaca; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_order_customer_id_40daaaca ON public.ecommerce_order USING btree (customer_id);


--
-- Name: ecommerce_orderentry_cart_id_259607be; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_orderentry_cart_id_259607be ON public.ecommerce_orderentry USING btree (cart_id);


--
-- Name: ecommerce_orderentry_order_id_4a040204; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_orderentry_order_id_4a040204 ON public.ecommerce_orderentry USING btree (order_id);


--
-- Name: ecommerce_orderentry_seller_id_4adc503d; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_orderentry_seller_id_4adc503d ON public.ecommerce_orderentry USING btree (seller_id);


--
-- Name: ecommerce_orderproduct_cancelled_by_id_2a1c1b11; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_orderproduct_cancelled_by_id_2a1c1b11 ON public.ecommerce_orderproduct USING btree (cancelled_by_id);


--
-- Name: ecommerce_orderproduct_order_id_774fb1ed; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_orderproduct_order_id_774fb1ed ON public.ecommerce_orderproduct USING btree (order_id);


--
-- Name: ecommerce_orderproduct_product_detail_id_7847a731; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_orderproduct_product_detail_id_7847a731 ON public.ecommerce_orderproduct USING btree (product_detail_id);


--
-- Name: ecommerce_product_approved_by_id_5c3effd7; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_product_approved_by_id_5c3effd7 ON public.ecommerce_product USING btree (approved_by_id);


--
-- Name: ecommerce_product_brand_id_d87be8b9; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_product_brand_id_d87be8b9 ON public.ecommerce_product USING btree (brand_id);


--
-- Name: ecommerce_product_category_id_53003707; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_product_category_id_53003707 ON public.ecommerce_product USING btree (category_id);


--
-- Name: ecommerce_product_checked_by_id_d76729e5; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_product_checked_by_id_d76729e5 ON public.ecommerce_product USING btree (checked_by_id);


--
-- Name: ecommerce_product_image_id_ff2e79bd; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_product_image_id_ff2e79bd ON public.ecommerce_product USING btree (image_id);


--
-- Name: ecommerce_product_product_type_id_05b335e3; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_product_product_type_id_05b335e3 ON public.ecommerce_product USING btree (product_type_id);


--
-- Name: ecommerce_product_slug_2644eea2_like; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_product_slug_2644eea2_like ON public.ecommerce_product USING btree (slug varchar_pattern_ops);


--
-- Name: ecommerce_product_store_id_534b1672; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_product_store_id_534b1672 ON public.ecommerce_product USING btree (store_id);


--
-- Name: ecommerce_product_sub_category_id_215b6538; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_product_sub_category_id_215b6538 ON public.ecommerce_product USING btree (sub_category_id);


--
-- Name: ecommerce_productcategory_brands_brand_id_ced754e2; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_productcategory_brands_brand_id_ced754e2 ON public.ecommerce_productcategory_brands USING btree (brand_id);


--
-- Name: ecommerce_productcategory_brands_productcategory_id_1f793909; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_productcategory_brands_productcategory_id_1f793909 ON public.ecommerce_productcategory_brands USING btree (productcategory_id);


--
-- Name: ecommerce_productcategory_parent_id_f8995244; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_productcategory_parent_id_f8995244 ON public.ecommerce_productcategory USING btree (parent_id);


--
-- Name: ecommerce_productdetail_product_id_6c4fbd17; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_productdetail_product_id_6c4fbd17 ON public.ecommerce_productdetail USING btree (product_id);


--
-- Name: ecommerce_productimage_image_id_37d59e18; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_productimage_image_id_37d59e18 ON public.ecommerce_productimage USING btree (image_id);


--
-- Name: ecommerce_productimage_product_detail_id_999a875f; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_productimage_product_detail_id_999a875f ON public.ecommerce_productimage USING btree (product_detail_id);


--
-- Name: ecommerce_productreview_product_id_5e7ff970; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_productreview_product_id_5e7ff970 ON public.ecommerce_productreview USING btree (product_id);


--
-- Name: ecommerce_productreview_user_id_7ca433fa; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_productreview_user_id_7ca433fa ON public.ecommerce_productreview USING btree (user_id);


--
-- Name: ecommerce_producttype_category_id_8ee9665d; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_producttype_category_id_8ee9665d ON public.ecommerce_producttype USING btree (category_id);


--
-- Name: ecommerce_productwishlist_product_id_8dadb659; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_productwishlist_product_id_8dadb659 ON public.ecommerce_productwishlist USING btree (product_id);


--
-- Name: ecommerce_productwishlist_user_id_6599752d; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_productwishlist_user_id_6599752d ON public.ecommerce_productwishlist USING btree (user_id);


--
-- Name: ecommerce_promo_category_productcategory_id_a92e59ed; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_promo_category_productcategory_id_a92e59ed ON public.ecommerce_promo_category USING btree (productcategory_id);


--
-- Name: ecommerce_promo_category_promo_id_9c6792b1; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_promo_category_promo_id_9c6792b1 ON public.ecommerce_promo_category USING btree (promo_id);


--
-- Name: ecommerce_promo_merchant_promo_id_9613adcb; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_promo_merchant_promo_id_9613adcb ON public.ecommerce_promo_merchant USING btree (promo_id);


--
-- Name: ecommerce_promo_merchant_seller_id_bd41d397; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_promo_merchant_seller_id_bd41d397 ON public.ecommerce_promo_merchant USING btree (seller_id);


--
-- Name: ecommerce_promo_product_product_id_befa59bb; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_promo_product_product_id_befa59bb ON public.ecommerce_promo_product USING btree (product_id);


--
-- Name: ecommerce_promo_product_promo_id_a08b0e9e; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_promo_product_promo_id_a08b0e9e ON public.ecommerce_promo_product USING btree (promo_id);


--
-- Name: ecommerce_promo_product_type_producttype_id_3c4eb48d; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_promo_product_type_producttype_id_3c4eb48d ON public.ecommerce_promo_product_type USING btree (producttype_id);


--
-- Name: ecommerce_promo_product_type_promo_id_f1106f44; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_promo_product_type_promo_id_f1106f44 ON public.ecommerce_promo_product_type USING btree (promo_id);


--
-- Name: ecommerce_promo_sub_category_productcategory_id_9f5cb4e5; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_promo_sub_category_productcategory_id_9f5cb4e5 ON public.ecommerce_promo_sub_category USING btree (productcategory_id);


--
-- Name: ecommerce_promo_sub_category_promo_id_fb05a8c0; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_promo_sub_category_promo_id_fb05a8c0 ON public.ecommerce_promo_sub_category USING btree (promo_id);


--
-- Name: ecommerce_r_status_ca3888_idx; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_r_status_ca3888_idx ON public.ecommerce_returnedproduct USING btree (status, payment_status, created_on, updated_on);


--
-- Name: ecommerce_returnedproduct_product_id_1f9ecd5f; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_returnedproduct_product_id_1f9ecd5f ON public.ecommerce_returnedproduct USING btree (product_id);


--
-- Name: ecommerce_returnedproduct_reason_id_66736a6f; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_returnedproduct_reason_id_66736a6f ON public.ecommerce_returnedproduct USING btree (reason_id);


--
-- Name: ecommerce_returnedproduct_returned_by_id_ab1ac6dd; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_returnedproduct_returned_by_id_ab1ac6dd ON public.ecommerce_returnedproduct USING btree (returned_by_id);


--
-- Name: ecommerce_returnedproduct_updated_by_id_7331ca3c; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_returnedproduct_updated_by_id_7331ca3c ON public.ecommerce_returnedproduct USING btree (updated_by_id);


--
-- Name: ecommerce_returnproductimage_return_product_id_fbbd7812; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_returnproductimage_return_product_id_fbbd7812 ON public.ecommerce_returnproductimage USING btree (return_product_id);


--
-- Name: ecommerce_shipper_slug_c711753f_like; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX ecommerce_shipper_slug_c711753f_like ON public.ecommerce_shipper USING btree (slug varchar_pattern_ops);


--
-- Name: merchant_bankaccount_seller_id_dbe39827; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX merchant_bankaccount_seller_id_dbe39827 ON public.merchant_bankaccount USING btree (seller_id);


--
-- Name: merchant_merchantbanner_seller_id_f3354f9c; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX merchant_merchantbanner_seller_id_f3354f9c ON public.merchant_merchantbanner USING btree (seller_id);


--
-- Name: merchant_seller_approved_by_id_f75e90d9; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX merchant_seller_approved_by_id_f75e90d9 ON public.merchant_seller USING btree (approved_by_id);


--
-- Name: merchant_seller_checked_by_id_fa025061; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX merchant_seller_checked_by_id_fa025061 ON public.merchant_seller USING btree (checked_by_id);


--
-- Name: merchant_seller_follower_seller_id_2cb9a7a8; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX merchant_seller_follower_seller_id_2cb9a7a8 ON public.merchant_seller_follower USING btree (seller_id);


--
-- Name: merchant_seller_follower_user_id_aa8334f1; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX merchant_seller_follower_user_id_aa8334f1 ON public.merchant_seller_follower USING btree (user_id);


--
-- Name: merchant_seller_user_id_dfb085f7; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX merchant_seller_user_id_dfb085f7 ON public.merchant_seller USING btree (user_id);


--
-- Name: merchant_sellerdetail_director_id_5b763f33; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX merchant_sellerdetail_director_id_5b763f33 ON public.merchant_sellerdetail USING btree (director_id);


--
-- Name: merchant_sellerfile_seller_id_994c062f; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX merchant_sellerfile_seller_id_994c062f ON public.merchant_sellerfile USING btree (seller_id);


--
-- Name: store_store_categories_productcategory_id_f620d16e; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX store_store_categories_productcategory_id_f620d16e ON public.store_store_categories USING btree (productcategory_id);


--
-- Name: store_store_categories_store_id_9d31aa64; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX store_store_categories_store_id_9d31aa64 ON public.store_store_categories USING btree (store_id);


--
-- Name: store_store_seller_id_18308c60; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX store_store_seller_id_18308c60 ON public.store_store USING btree (seller_id);


--
-- Name: superadmin_adminuser_role_id_fcbbf87b; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX superadmin_adminuser_role_id_fcbbf87b ON public.superadmin_adminuser USING btree (role_id);


--
-- Name: transaction_merchanttransaction_merchant_id_43c4afe3; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX transaction_merchanttransaction_merchant_id_43c4afe3 ON public.transaction_merchanttransaction USING btree (merchant_id);


--
-- Name: transaction_merchanttransaction_order_id_f52041fa; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX transaction_merchanttransaction_order_id_f52041fa ON public.transaction_merchanttransaction USING btree (order_id);


--
-- Name: transaction_merchanttransaction_transaction_id_6beacb91; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX transaction_merchanttransaction_transaction_id_6beacb91 ON public.transaction_merchanttransaction USING btree (transaction_id);


--
-- Name: transaction_transaction_order_id_a814b212; Type: INDEX; Schema: public; Owner: payarena
--

CREATE INDEX transaction_transaction_order_id_a814b212 ON public.transaction_transaction USING btree (order_id);


--
-- Name: company_address fk1ms8sqcndn8qebu7955vrmyew; Type: FK CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.company_address
    ADD CONSTRAINT fk1ms8sqcndn8qebu7955vrmyew FOREIGN KEY (company_id) REFERENCES billing.base_user(id);


--
-- Name: base_user_phone fk317349fumscl42vm4f9klk71n; Type: FK CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.base_user_phone
    ADD CONSTRAINT fk317349fumscl42vm4f9klk71n FOREIGN KEY (base_user_id) REFERENCES billing.base_user(id);


--
-- Name: base_user_approved_payment_types fk35bux99p26s18yd28qc0rjqi5; Type: FK CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.base_user_approved_payment_types
    ADD CONSTRAINT fk35bux99p26s18yd28qc0rjqi5 FOREIGN KEY (company_id) REFERENCES billing.base_user(id);


--
-- Name: provider_payment_type_fk fk4f5ckr4sxx390wsyvdy9q6fsr; Type: FK CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.provider_payment_type_fk
    ADD CONSTRAINT fk4f5ckr4sxx390wsyvdy9q6fsr FOREIGN KEY (payment_provider_id) REFERENCES billing.payment_provider(id);


--
-- Name: payment_type fkbps7ka10dbfrelylwvcrk2w65; Type: FK CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.payment_type
    ADD CONSTRAINT fkbps7ka10dbfrelylwvcrk2w65 FOREIGN KEY (provider_id) REFERENCES billing.payment_provider(id);


--
-- Name: customer fkc7guoxiavvvnkkopbag4g22lq; Type: FK CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.customer
    ADD CONSTRAINT fkc7guoxiavvvnkkopbag4g22lq FOREIGN KEY (company_id) REFERENCES billing.base_user(id);


--
-- Name: base_user fkdrntgo6c2vsrsuqg7m7tjpwes; Type: FK CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.base_user
    ADD CONSTRAINT fkdrntgo6c2vsrsuqg7m7tjpwes FOREIGN KEY (company_settings_id) REFERENCES billing.company_settings(id);


--
-- Name: payment_type_adopted_companies fkgpdg453echymswxdgqxkoy2m2; Type: FK CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.payment_type_adopted_companies
    ADD CONSTRAINT fkgpdg453echymswxdgqxkoy2m2 FOREIGN KEY (payment_type_id) REFERENCES billing.payment_type(id);


--
-- Name: provider_payment_type_fk fkkb5ey4un1pi5wv3hqfpoxbh5v; Type: FK CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.provider_payment_type_fk
    ADD CONSTRAINT fkkb5ey4un1pi5wv3hqfpoxbh5v FOREIGN KEY (payment_types_id) REFERENCES billing.payment_type(id);


--
-- Name: base_user_roles fkki942qehxvbx1adsnfuchxg4j; Type: FK CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.base_user_roles
    ADD CONSTRAINT fkki942qehxvbx1adsnfuchxg4j FOREIGN KEY (base_user_id) REFERENCES billing.base_user(id);


--
-- Name: customer fkllb0hl41fafqyx3bqwq6jc4yu; Type: FK CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.customer
    ADD CONSTRAINT fkllb0hl41fafqyx3bqwq6jc4yu FOREIGN KEY (payment_types_id) REFERENCES billing.customer_payment_details(id);


--
-- Name: base_user_customers fkmodx9r5mfof21uywpy62372eq; Type: FK CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.base_user_customers
    ADD CONSTRAINT fkmodx9r5mfof21uywpy62372eq FOREIGN KEY (customers_id) REFERENCES billing.customer(id);


--
-- Name: transaction fknbpjofb5abhjg5hiovi0t3k57; Type: FK CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.transaction
    ADD CONSTRAINT fknbpjofb5abhjg5hiovi0t3k57 FOREIGN KEY (customer_id) REFERENCES billing.customer(id);


--
-- Name: base_user_customers fkr30p1ehpc7vohyjvsv03j5gqx; Type: FK CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.base_user_customers
    ADD CONSTRAINT fkr30p1ehpc7vohyjvsv03j5gqx FOREIGN KEY (company_id) REFERENCES billing.base_user(id);


--
-- Name: company_settings_billing_details fkrcu75gg2wpf1hk0ksult6s5oy; Type: FK CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.company_settings_billing_details
    ADD CONSTRAINT fkrcu75gg2wpf1hk0ksult6s5oy FOREIGN KEY (company_settings_id) REFERENCES billing.company_settings(id);


--
-- Name: base_user_approved_payment_types fkrfnplk6qu1nkg6f7ymfy5nv9e; Type: FK CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.base_user_approved_payment_types
    ADD CONSTRAINT fkrfnplk6qu1nkg6f7ymfy5nv9e FOREIGN KEY (approved_payment_types_id) REFERENCES billing.payment_type(id);


--
-- Name: payment_type_adopted_companies fkrgle1phmyjk5b6ouldu5s1y4f; Type: FK CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.payment_type_adopted_companies
    ADD CONSTRAINT fkrgle1phmyjk5b6ouldu5s1y4f FOREIGN KEY (adopted_companies_id) REFERENCES billing.base_user(id);


--
-- Name: customer_payment_details_payment_info fktc69fusqujnw8w8fvcxuds7mh; Type: FK CONSTRAINT; Schema: billing; Owner: payarena
--

ALTER TABLE ONLY billing.customer_payment_details_payment_info
    ADD CONSTRAINT fktc69fusqujnw8w8fvcxuds7mh FOREIGN KEY (customer_payment_details_id) REFERENCES billing.customer_payment_details(id);


--
-- Name: account_address account_address_customer_id_752e23ab_fk_account_profile_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.account_address
    ADD CONSTRAINT account_address_customer_id_752e23ab_fk_account_profile_id FOREIGN KEY (customer_id) REFERENCES public.account_profile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: account_profile_following account_profile_foll_profile_id_0016a31b_fk_account_p; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.account_profile_following
    ADD CONSTRAINT account_profile_foll_profile_id_0016a31b_fk_account_p FOREIGN KEY (profile_id) REFERENCES public.account_profile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: account_profile_following account_profile_following_store_id_401027f6_fk_store_store_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.account_profile_following
    ADD CONSTRAINT account_profile_following_store_id_401027f6_fk_store_store_id FOREIGN KEY (store_id) REFERENCES public.store_store(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: account_profile account_profile_user_id_bdd52018_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.account_profile
    ADD CONSTRAINT account_profile_user_id_bdd52018_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: account_usercard account_usercard_profile_id_37824d40_fk_account_profile_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.account_usercard
    ADD CONSTRAINT account_usercard_profile_id_37824d40_fk_account_profile_id FOREIGN KEY (profile_id) REFERENCES public.account_profile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: authtoken_token authtoken_token_user_id_35299eff_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.authtoken_token
    ADD CONSTRAINT authtoken_token_user_id_35299eff_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_cart ecommerce_cart_user_id_d140a08b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_cart
    ADD CONSTRAINT ecommerce_cart_user_id_d140a08b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_cartproduct ecommerce_cartproduc_product_detail_id_844b79de_fk_ecommerce; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_cartproduct
    ADD CONSTRAINT ecommerce_cartproduc_product_detail_id_844b79de_fk_ecommerce FOREIGN KEY (product_detail_id) REFERENCES public.ecommerce_productdetail(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_cartproduct ecommerce_cartproduct_cart_id_679c2fdb_fk_ecommerce_cart_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_cartproduct
    ADD CONSTRAINT ecommerce_cartproduct_cart_id_679c2fdb_fk_ecommerce_cart_id FOREIGN KEY (cart_id) REFERENCES public.ecommerce_cart(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_dailydeal ecommerce_dailydeal_product_id_f1b1361c_fk_ecommerce_product_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_dailydeal
    ADD CONSTRAINT ecommerce_dailydeal_product_id_f1b1361c_fk_ecommerce_product_id FOREIGN KEY (product_id) REFERENCES public.ecommerce_product(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_order ecommerce_order_address_id_93a4db03_fk_account_address_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_order
    ADD CONSTRAINT ecommerce_order_address_id_93a4db03_fk_account_address_id FOREIGN KEY (address_id) REFERENCES public.account_address(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_order ecommerce_order_cart_id_ee2246e6_fk_ecommerce_cart_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_order
    ADD CONSTRAINT ecommerce_order_cart_id_ee2246e6_fk_ecommerce_cart_id FOREIGN KEY (cart_id) REFERENCES public.ecommerce_cart(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_order ecommerce_order_customer_id_40daaaca_fk_account_profile_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_order
    ADD CONSTRAINT ecommerce_order_customer_id_40daaaca_fk_account_profile_id FOREIGN KEY (customer_id) REFERENCES public.account_profile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_orderentry ecommerce_orderentry_cart_id_259607be_fk_ecommerce_cart_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_orderentry
    ADD CONSTRAINT ecommerce_orderentry_cart_id_259607be_fk_ecommerce_cart_id FOREIGN KEY (cart_id) REFERENCES public.ecommerce_cart(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_orderentry ecommerce_orderentry_order_id_4a040204_fk_ecommerce_order_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_orderentry
    ADD CONSTRAINT ecommerce_orderentry_order_id_4a040204_fk_ecommerce_order_id FOREIGN KEY (order_id) REFERENCES public.ecommerce_order(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_orderentry ecommerce_orderentry_seller_id_4adc503d_fk_merchant_seller_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_orderentry
    ADD CONSTRAINT ecommerce_orderentry_seller_id_4adc503d_fk_merchant_seller_id FOREIGN KEY (seller_id) REFERENCES public.merchant_seller(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_orderproduct ecommerce_orderprodu_product_detail_id_7847a731_fk_ecommerce; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_orderproduct
    ADD CONSTRAINT ecommerce_orderprodu_product_detail_id_7847a731_fk_ecommerce FOREIGN KEY (product_detail_id) REFERENCES public.ecommerce_productdetail(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_orderproduct ecommerce_orderproduct_cancelled_by_id_2a1c1b11_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_orderproduct
    ADD CONSTRAINT ecommerce_orderproduct_cancelled_by_id_2a1c1b11_fk_auth_user_id FOREIGN KEY (cancelled_by_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_orderproduct ecommerce_orderproduct_order_id_774fb1ed_fk_ecommerce_order_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_orderproduct
    ADD CONSTRAINT ecommerce_orderproduct_order_id_774fb1ed_fk_ecommerce_order_id FOREIGN KEY (order_id) REFERENCES public.ecommerce_order(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_product ecommerce_product_approved_by_id_5c3effd7_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_product
    ADD CONSTRAINT ecommerce_product_approved_by_id_5c3effd7_fk_auth_user_id FOREIGN KEY (approved_by_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_product ecommerce_product_brand_id_d87be8b9_fk_ecommerce_brand_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_product
    ADD CONSTRAINT ecommerce_product_brand_id_d87be8b9_fk_ecommerce_brand_id FOREIGN KEY (brand_id) REFERENCES public.ecommerce_brand(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_product ecommerce_product_category_id_53003707_fk_ecommerce; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_product
    ADD CONSTRAINT ecommerce_product_category_id_53003707_fk_ecommerce FOREIGN KEY (category_id) REFERENCES public.ecommerce_productcategory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_product ecommerce_product_checked_by_id_d76729e5_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_product
    ADD CONSTRAINT ecommerce_product_checked_by_id_d76729e5_fk_auth_user_id FOREIGN KEY (checked_by_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_product ecommerce_product_image_id_ff2e79bd_fk_ecommerce_image_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_product
    ADD CONSTRAINT ecommerce_product_image_id_ff2e79bd_fk_ecommerce_image_id FOREIGN KEY (image_id) REFERENCES public.ecommerce_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_product ecommerce_product_product_type_id_05b335e3_fk_ecommerce; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_product
    ADD CONSTRAINT ecommerce_product_product_type_id_05b335e3_fk_ecommerce FOREIGN KEY (product_type_id) REFERENCES public.ecommerce_producttype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_product ecommerce_product_store_id_534b1672_fk_store_store_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_product
    ADD CONSTRAINT ecommerce_product_store_id_534b1672_fk_store_store_id FOREIGN KEY (store_id) REFERENCES public.store_store(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_product ecommerce_product_sub_category_id_215b6538_fk_ecommerce; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_product
    ADD CONSTRAINT ecommerce_product_sub_category_id_215b6538_fk_ecommerce FOREIGN KEY (sub_category_id) REFERENCES public.ecommerce_productcategory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_productcategory_brands ecommerce_productcat_brand_id_ced754e2_fk_ecommerce; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_productcategory_brands
    ADD CONSTRAINT ecommerce_productcat_brand_id_ced754e2_fk_ecommerce FOREIGN KEY (brand_id) REFERENCES public.ecommerce_brand(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_productcategory ecommerce_productcat_parent_id_f8995244_fk_ecommerce; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_productcategory
    ADD CONSTRAINT ecommerce_productcat_parent_id_f8995244_fk_ecommerce FOREIGN KEY (parent_id) REFERENCES public.ecommerce_productcategory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_productcategory_brands ecommerce_productcat_productcategory_id_1f793909_fk_ecommerce; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_productcategory_brands
    ADD CONSTRAINT ecommerce_productcat_productcategory_id_1f793909_fk_ecommerce FOREIGN KEY (productcategory_id) REFERENCES public.ecommerce_productcategory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_productdetail ecommerce_productdet_product_id_6c4fbd17_fk_ecommerce; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_productdetail
    ADD CONSTRAINT ecommerce_productdet_product_id_6c4fbd17_fk_ecommerce FOREIGN KEY (product_id) REFERENCES public.ecommerce_product(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_productimage ecommerce_productima_product_detail_id_999a875f_fk_ecommerce; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_productimage
    ADD CONSTRAINT ecommerce_productima_product_detail_id_999a875f_fk_ecommerce FOREIGN KEY (product_detail_id) REFERENCES public.ecommerce_productdetail(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_productimage ecommerce_productimage_image_id_37d59e18_fk_ecommerce_image_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_productimage
    ADD CONSTRAINT ecommerce_productimage_image_id_37d59e18_fk_ecommerce_image_id FOREIGN KEY (image_id) REFERENCES public.ecommerce_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_productreview ecommerce_productrev_product_id_5e7ff970_fk_ecommerce; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_productreview
    ADD CONSTRAINT ecommerce_productrev_product_id_5e7ff970_fk_ecommerce FOREIGN KEY (product_id) REFERENCES public.ecommerce_product(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_productreview ecommerce_productreview_user_id_7ca433fa_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_productreview
    ADD CONSTRAINT ecommerce_productreview_user_id_7ca433fa_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_producttype ecommerce_producttyp_category_id_8ee9665d_fk_ecommerce; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_producttype
    ADD CONSTRAINT ecommerce_producttyp_category_id_8ee9665d_fk_ecommerce FOREIGN KEY (category_id) REFERENCES public.ecommerce_productcategory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_productwishlist ecommerce_productwis_product_id_8dadb659_fk_ecommerce; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_productwishlist
    ADD CONSTRAINT ecommerce_productwis_product_id_8dadb659_fk_ecommerce FOREIGN KEY (product_id) REFERENCES public.ecommerce_product(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_productwishlist ecommerce_productwishlist_user_id_6599752d_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_productwishlist
    ADD CONSTRAINT ecommerce_productwishlist_user_id_6599752d_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_promo_category ecommerce_promo_cate_productcategory_id_a92e59ed_fk_ecommerce; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_promo_category
    ADD CONSTRAINT ecommerce_promo_cate_productcategory_id_a92e59ed_fk_ecommerce FOREIGN KEY (productcategory_id) REFERENCES public.ecommerce_productcategory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_promo_category ecommerce_promo_cate_promo_id_9c6792b1_fk_ecommerce; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_promo_category
    ADD CONSTRAINT ecommerce_promo_cate_promo_id_9c6792b1_fk_ecommerce FOREIGN KEY (promo_id) REFERENCES public.ecommerce_promo(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_promo_merchant ecommerce_promo_merc_promo_id_9613adcb_fk_ecommerce; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_promo_merchant
    ADD CONSTRAINT ecommerce_promo_merc_promo_id_9613adcb_fk_ecommerce FOREIGN KEY (promo_id) REFERENCES public.ecommerce_promo(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_promo_merchant ecommerce_promo_merc_seller_id_bd41d397_fk_merchant_; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_promo_merchant
    ADD CONSTRAINT ecommerce_promo_merc_seller_id_bd41d397_fk_merchant_ FOREIGN KEY (seller_id) REFERENCES public.merchant_seller(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_promo_product ecommerce_promo_prod_product_id_befa59bb_fk_ecommerce; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_promo_product
    ADD CONSTRAINT ecommerce_promo_prod_product_id_befa59bb_fk_ecommerce FOREIGN KEY (product_id) REFERENCES public.ecommerce_product(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_promo_product_type ecommerce_promo_prod_producttype_id_3c4eb48d_fk_ecommerce; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_promo_product_type
    ADD CONSTRAINT ecommerce_promo_prod_producttype_id_3c4eb48d_fk_ecommerce FOREIGN KEY (producttype_id) REFERENCES public.ecommerce_producttype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_promo_product_type ecommerce_promo_prod_promo_id_f1106f44_fk_ecommerce; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_promo_product_type
    ADD CONSTRAINT ecommerce_promo_prod_promo_id_f1106f44_fk_ecommerce FOREIGN KEY (promo_id) REFERENCES public.ecommerce_promo(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_promo_product ecommerce_promo_product_promo_id_a08b0e9e_fk_ecommerce_promo_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_promo_product
    ADD CONSTRAINT ecommerce_promo_product_promo_id_a08b0e9e_fk_ecommerce_promo_id FOREIGN KEY (promo_id) REFERENCES public.ecommerce_promo(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_promo_sub_category ecommerce_promo_sub__productcategory_id_9f5cb4e5_fk_ecommerce; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_promo_sub_category
    ADD CONSTRAINT ecommerce_promo_sub__productcategory_id_9f5cb4e5_fk_ecommerce FOREIGN KEY (productcategory_id) REFERENCES public.ecommerce_productcategory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_promo_sub_category ecommerce_promo_sub__promo_id_fb05a8c0_fk_ecommerce; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_promo_sub_category
    ADD CONSTRAINT ecommerce_promo_sub__promo_id_fb05a8c0_fk_ecommerce FOREIGN KEY (promo_id) REFERENCES public.ecommerce_promo(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_returnedproduct ecommerce_returnedpr_product_id_1f9ecd5f_fk_ecommerce; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_returnedproduct
    ADD CONSTRAINT ecommerce_returnedpr_product_id_1f9ecd5f_fk_ecommerce FOREIGN KEY (product_id) REFERENCES public.ecommerce_orderproduct(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_returnedproduct ecommerce_returnedpr_reason_id_66736a6f_fk_ecommerce; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_returnedproduct
    ADD CONSTRAINT ecommerce_returnedpr_reason_id_66736a6f_fk_ecommerce FOREIGN KEY (reason_id) REFERENCES public.ecommerce_returnreason(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_returnedproduct ecommerce_returnedpr_returned_by_id_ab1ac6dd_fk_auth_user; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_returnedproduct
    ADD CONSTRAINT ecommerce_returnedpr_returned_by_id_ab1ac6dd_fk_auth_user FOREIGN KEY (returned_by_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_returnedproduct ecommerce_returnedpr_updated_by_id_7331ca3c_fk_auth_user; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_returnedproduct
    ADD CONSTRAINT ecommerce_returnedpr_updated_by_id_7331ca3c_fk_auth_user FOREIGN KEY (updated_by_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecommerce_returnproductimage ecommerce_returnprod_return_product_id_fbbd7812_fk_ecommerce; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.ecommerce_returnproductimage
    ADD CONSTRAINT ecommerce_returnprod_return_product_id_fbbd7812_fk_ecommerce FOREIGN KEY (return_product_id) REFERENCES public.ecommerce_returnedproduct(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: state_stations fk2mtcyqwhybtg9uteqf42ttsjd; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.state_stations
    ADD CONSTRAINT fk2mtcyqwhybtg9uteqf42ttsjd FOREIGN KEY (state_id) REFERENCES public.state(id);


--
-- Name: client_commission fk505220xdphpf5reh26nwcxbbt; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.client_commission
    ADD CONSTRAINT fk505220xdphpf5reh26nwcxbbt FOREIGN KEY (client_id) REFERENCES public.base_user(id);


--
-- Name: city_towns fk5wimfh9ukjkpihm5h59292v3r; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.city_towns
    ADD CONSTRAINT fk5wimfh9ukjkpihm5h59292v3r FOREIGN KEY (city_id) REFERENCES public.city(id);


--
-- Name: shipment fk6lwe8m9h5hf6g4gskrdmn80pn; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.shipment
    ADD CONSTRAINT fk6lwe8m9h5hf6g4gskrdmn80pn FOREIGN KEY (shipper_id) REFERENCES public.shipper(id);


--
-- Name: generic_custom_shipper_endpoints fk6tqfxuehu59pxund32rej0h01; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.generic_custom_shipper_endpoints
    ADD CONSTRAINT fk6tqfxuehu59pxund32rej0h01 FOREIGN KEY (generic_custom_shipper_id) REFERENCES public.shipper(id);


--
-- Name: base_user fk7jda17ndlooe9h0sm72m1835v; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.base_user
    ADD CONSTRAINT fk7jda17ndlooe9h0sm72m1835v FOREIGN KEY (commission_type_id) REFERENCES public.client_commission(id);


--
-- Name: wallet fk7sfuwb1ewlv43oe3ohe2r1150; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.wallet
    ADD CONSTRAINT fk7sfuwb1ewlv43oe3ohe2r1150 FOREIGN KEY (client_id) REFERENCES public.base_user(id);


--
-- Name: order_detail fk7u7dm4fdc78nttlrbv6silfq8; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT fk7u7dm4fdc78nttlrbv6silfq8 FOREIGN KEY (shipment_id) REFERENCES public.shipment(id);


--
-- Name: base_user_approved_shippers fk7wtbu4xj2unrybrsnlg0fmg78; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.base_user_approved_shippers
    ADD CONSTRAINT fk7wtbu4xj2unrybrsnlg0fmg78 FOREIGN KEY (approved_shippers_key) REFERENCES public.shipper(id);


--
-- Name: shipper_clients fk9ksw1f90gmtelk7g8bfqk4vs2; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.shipper_clients
    ADD CONSTRAINT fk9ksw1f90gmtelk7g8bfqk4vs2 FOREIGN KEY (clients_id) REFERENCES public.users(id);


--
-- Name: base_user_approved_shippers fk9of5nc31urk5bb04clxig6k03; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.base_user_approved_shippers
    ADD CONSTRAINT fk9of5nc31urk5bb04clxig6k03 FOREIGN KEY (approved_shippers_id) REFERENCES public.shipper(id);


--
-- Name: order_detail_items fka3ixv58bch2bkemnp7rewp0s2; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.order_detail_items
    ADD CONSTRAINT fka3ixv58bch2bkemnp7rewp0s2 FOREIGN KEY (order_detail_order_id) REFERENCES public.order_detail(order_id);


--
-- Name: shipment_order_details fkesysgp6iyv7wokoj2t2rev3sq; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.shipment_order_details
    ADD CONSTRAINT fkesysgp6iyv7wokoj2t2rev3sq FOREIGN KEY (order_details_order_id) REFERENCES public.order_detail(order_id);


--
-- Name: shipment_order_details fki0jayk8hstjo6v412mj89lrlb; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.shipment_order_details
    ADD CONSTRAINT fki0jayk8hstjo6v412mj89lrlb FOREIGN KEY (shipment_id) REFERENCES public.shipment(id);


--
-- Name: shipment fkk30ujq5l3dfhmy5yuvpdfl3xx; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.shipment
    ADD CONSTRAINT fkk30ujq5l3dfhmy5yuvpdfl3xx FOREIGN KEY (client_id) REFERENCES public.base_user(id);


--
-- Name: base_user_shipments fkkc5b5lg2lyggpwcjueomd5am9; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.base_user_shipments
    ADD CONSTRAINT fkkc5b5lg2lyggpwcjueomd5am9 FOREIGN KEY (client_id) REFERENCES public.base_user(id);


--
-- Name: base_user_roles fkkoh2p91oolq8ew3ourtmntxfi; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.base_user_roles
    ADD CONSTRAINT fkkoh2p91oolq8ew3ourtmntxfi FOREIGN KEY (base_user_id) REFERENCES public.users(id);


--
-- Name: base_user fkksplgcyusirssriua6m67xojl; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.base_user
    ADD CONSTRAINT fkksplgcyusirssriua6m67xojl FOREIGN KEY (wallet_id) REFERENCES public.wallet(id);


--
-- Name: base_user_approved_shippers fklgmdyjvohfdpph382xkrscvrs; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.base_user_approved_shippers
    ADD CONSTRAINT fklgmdyjvohfdpph382xkrscvrs FOREIGN KEY (client_id) REFERENCES public.base_user(id);


--
-- Name: base_user_shipments fkojmxb747k85bdjxt7tpbhagn8; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.base_user_shipments
    ADD CONSTRAINT fkojmxb747k85bdjxt7tpbhagn8 FOREIGN KEY (shipments_id) REFERENCES public.shipment(id);


--
-- Name: state_cities fkpube83cheofigcts5krj0ai0i; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.state_cities
    ADD CONSTRAINT fkpube83cheofigcts5krj0ai0i FOREIGN KEY (cities_id) REFERENCES public.city(id);


--
-- Name: state_cities fkssrnsj5h3nujymbko4suh9jsp; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.state_cities
    ADD CONSTRAINT fkssrnsj5h3nujymbko4suh9jsp FOREIGN KEY (state_id) REFERENCES public.state(id);


--
-- Name: merchant_bankaccount merchant_bankaccount_seller_id_dbe39827_fk_merchant_seller_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.merchant_bankaccount
    ADD CONSTRAINT merchant_bankaccount_seller_id_dbe39827_fk_merchant_seller_id FOREIGN KEY (seller_id) REFERENCES public.merchant_seller(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: merchant_merchantbanner merchant_merchantban_seller_id_f3354f9c_fk_merchant_; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.merchant_merchantbanner
    ADD CONSTRAINT merchant_merchantban_seller_id_f3354f9c_fk_merchant_ FOREIGN KEY (seller_id) REFERENCES public.merchant_seller(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: merchant_seller merchant_seller_approved_by_id_f75e90d9_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.merchant_seller
    ADD CONSTRAINT merchant_seller_approved_by_id_f75e90d9_fk_auth_user_id FOREIGN KEY (approved_by_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: merchant_seller merchant_seller_checked_by_id_fa025061_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.merchant_seller
    ADD CONSTRAINT merchant_seller_checked_by_id_fa025061_fk_auth_user_id FOREIGN KEY (checked_by_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: merchant_seller_follower merchant_seller_foll_seller_id_2cb9a7a8_fk_merchant_; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.merchant_seller_follower
    ADD CONSTRAINT merchant_seller_foll_seller_id_2cb9a7a8_fk_merchant_ FOREIGN KEY (seller_id) REFERENCES public.merchant_seller(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: merchant_seller_follower merchant_seller_follower_user_id_aa8334f1_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.merchant_seller_follower
    ADD CONSTRAINT merchant_seller_follower_user_id_aa8334f1_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: merchant_seller merchant_seller_user_id_dfb085f7_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.merchant_seller
    ADD CONSTRAINT merchant_seller_user_id_dfb085f7_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: merchant_sellerdetail merchant_sellerdetai_director_id_5b763f33_fk_merchant_; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.merchant_sellerdetail
    ADD CONSTRAINT merchant_sellerdetai_director_id_5b763f33_fk_merchant_ FOREIGN KEY (director_id) REFERENCES public.merchant_director(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: merchant_sellerdetail merchant_sellerdetail_seller_id_37b49f5e_fk_merchant_seller_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.merchant_sellerdetail
    ADD CONSTRAINT merchant_sellerdetail_seller_id_37b49f5e_fk_merchant_seller_id FOREIGN KEY (seller_id) REFERENCES public.merchant_seller(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: merchant_sellerfile merchant_sellerfile_seller_id_994c062f_fk_merchant_seller_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.merchant_sellerfile
    ADD CONSTRAINT merchant_sellerfile_seller_id_994c062f_fk_merchant_seller_id FOREIGN KEY (seller_id) REFERENCES public.merchant_seller(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: store_store_categories store_store_categori_productcategory_id_f620d16e_fk_ecommerce; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.store_store_categories
    ADD CONSTRAINT store_store_categori_productcategory_id_f620d16e_fk_ecommerce FOREIGN KEY (productcategory_id) REFERENCES public.ecommerce_productcategory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: store_store_categories store_store_categories_store_id_9d31aa64_fk_store_store_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.store_store_categories
    ADD CONSTRAINT store_store_categories_store_id_9d31aa64_fk_store_store_id FOREIGN KEY (store_id) REFERENCES public.store_store(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: store_store store_store_seller_id_18308c60_fk_merchant_seller_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.store_store
    ADD CONSTRAINT store_store_seller_id_18308c60_fk_merchant_seller_id FOREIGN KEY (seller_id) REFERENCES public.merchant_seller(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: superadmin_adminuser superadmin_adminuser_role_id_fcbbf87b_fk_superadmin_role_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.superadmin_adminuser
    ADD CONSTRAINT superadmin_adminuser_role_id_fcbbf87b_fk_superadmin_role_id FOREIGN KEY (role_id) REFERENCES public.superadmin_role(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: superadmin_adminuser superadmin_adminuser_user_id_bfd03f5e_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.superadmin_adminuser
    ADD CONSTRAINT superadmin_adminuser_user_id_bfd03f5e_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: transaction_merchanttransaction transaction_merchant_merchant_id_43c4afe3_fk_merchant_; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.transaction_merchanttransaction
    ADD CONSTRAINT transaction_merchant_merchant_id_43c4afe3_fk_merchant_ FOREIGN KEY (merchant_id) REFERENCES public.merchant_seller(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: transaction_merchanttransaction transaction_merchant_order_id_f52041fa_fk_ecommerce; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.transaction_merchanttransaction
    ADD CONSTRAINT transaction_merchant_order_id_f52041fa_fk_ecommerce FOREIGN KEY (order_id) REFERENCES public.ecommerce_order(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: transaction_merchanttransaction transaction_merchant_transaction_id_6beacb91_fk_transacti; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.transaction_merchanttransaction
    ADD CONSTRAINT transaction_merchant_transaction_id_6beacb91_fk_transacti FOREIGN KEY (transaction_id) REFERENCES public.transaction_transaction(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: transaction_transaction transaction_transaction_order_id_a814b212_fk_ecommerce_order_id; Type: FK CONSTRAINT; Schema: public; Owner: payarena
--

ALTER TABLE ONLY public.transaction_transaction
    ADD CONSTRAINT transaction_transaction_order_id_a814b212_fk_ecommerce_order_id FOREIGN KEY (order_id) REFERENCES public.ecommerce_order(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: shipper_apis fk1ck11m4vqu5f2q8h98y13x90g; Type: FK CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.shipper_apis
    ADD CONSTRAINT fk1ck11m4vqu5f2q8h98y13x90g FOREIGN KEY (shipper_id) REFERENCES shipping.shipper(id);


--
-- Name: state_stations fk2mtcyqwhybtg9uteqf42ttsjd; Type: FK CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.state_stations
    ADD CONSTRAINT fk2mtcyqwhybtg9uteqf42ttsjd FOREIGN KEY (state_id) REFERENCES shipping.state(id);


--
-- Name: users fk2ndfo1foff7a36v7f6sst12ix; Type: FK CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.users
    ADD CONSTRAINT fk2ndfo1foff7a36v7f6sst12ix FOREIGN KEY (wallet_id) REFERENCES shipping.wallet(id);


--
-- Name: shipper_modes_of_transportation fk3y6p0u5a4megdof6w8twg4k68; Type: FK CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.shipper_modes_of_transportation
    ADD CONSTRAINT fk3y6p0u5a4megdof6w8twg4k68 FOREIGN KEY (shipper_id) REFERENCES shipping.shipper(id);


--
-- Name: city_towns fk5wimfh9ukjkpihm5h59292v3r; Type: FK CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.city_towns
    ADD CONSTRAINT fk5wimfh9ukjkpihm5h59292v3r FOREIGN KEY (city_id) REFERENCES shipping.city(id);


--
-- Name: shipment fk6lwe8m9h5hf6g4gskrdmn80pn; Type: FK CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.shipment
    ADD CONSTRAINT fk6lwe8m9h5hf6g4gskrdmn80pn FOREIGN KEY (shipper_id) REFERENCES shipping.shipper(id);


--
-- Name: city fk6p2u50v8fg2y0js6djc6xanit; Type: FK CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.city
    ADD CONSTRAINT fk6p2u50v8fg2y0js6djc6xanit FOREIGN KEY (state_id) REFERENCES shipping.state(id);


--
-- Name: generic_custom_shipper_endpoints fk6tqfxuehu59pxund32rej0h01; Type: FK CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.generic_custom_shipper_endpoints
    ADD CONSTRAINT fk6tqfxuehu59pxund32rej0h01 FOREIGN KEY (generic_custom_shipper_id) REFERENCES shipping.shipper(id);


--
-- Name: base_user fk7jda17ndlooe9h0sm72m1835v; Type: FK CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.base_user
    ADD CONSTRAINT fk7jda17ndlooe9h0sm72m1835v FOREIGN KEY (commission_type_id) REFERENCES shipping.client_commission(id);


--
-- Name: order_detail fk7u7dm4fdc78nttlrbv6silfq8; Type: FK CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.order_detail
    ADD CONSTRAINT fk7u7dm4fdc78nttlrbv6silfq8 FOREIGN KEY (shipment_id) REFERENCES shipping.shipment(id);


--
-- Name: base_user_approved_shippers fk7wtbu4xj2unrybrsnlg0fmg78; Type: FK CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.base_user_approved_shippers
    ADD CONSTRAINT fk7wtbu4xj2unrybrsnlg0fmg78 FOREIGN KEY (approved_shippers_key) REFERENCES shipping.shipper(id);


--
-- Name: shipper_clients fk8g911t4koppaiqykglytp95cg; Type: FK CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.shipper_clients
    ADD CONSTRAINT fk8g911t4koppaiqykglytp95cg FOREIGN KEY (approved_shippers_id) REFERENCES shipping.shipper(id);


--
-- Name: shipment fk8k20ke1r2oybhwm0dro5msa55; Type: FK CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.shipment
    ADD CONSTRAINT fk8k20ke1r2oybhwm0dro5msa55 FOREIGN KEY (client_id) REFERENCES shipping.users(id);


--
-- Name: shipper_clients fk9ksw1f90gmtelk7g8bfqk4vs2; Type: FK CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.shipper_clients
    ADD CONSTRAINT fk9ksw1f90gmtelk7g8bfqk4vs2 FOREIGN KEY (clients_id) REFERENCES shipping.users(id);


--
-- Name: base_user_approved_shippers fk9of5nc31urk5bb04clxig6k03; Type: FK CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.base_user_approved_shippers
    ADD CONSTRAINT fk9of5nc31urk5bb04clxig6k03 FOREIGN KEY (approved_shippers_id) REFERENCES shipping.shipper(id);


--
-- Name: order_detail_items fka3ixv58bch2bkemnp7rewp0s2; Type: FK CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.order_detail_items
    ADD CONSTRAINT fka3ixv58bch2bkemnp7rewp0s2 FOREIGN KEY (order_detail_order_id) REFERENCES shipping.order_detail(id);


--
-- Name: client_commission fke2oqbfj127jm1me48cdh2bb8b; Type: FK CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.client_commission
    ADD CONSTRAINT fke2oqbfj127jm1me48cdh2bb8b FOREIGN KEY (client_id) REFERENCES shipping.users(id);


--
-- Name: shipment_order_details fkesysgp6iyv7wokoj2t2rev3sq; Type: FK CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.shipment_order_details
    ADD CONSTRAINT fkesysgp6iyv7wokoj2t2rev3sq FOREIGN KEY (order_details_order_id) REFERENCES shipping.order_detail(id);


--
-- Name: wallet fkgdu3rambvw0a9qpc3sn2972e; Type: FK CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.wallet
    ADD CONSTRAINT fkgdu3rambvw0a9qpc3sn2972e FOREIGN KEY (client_id) REFERENCES shipping.users(id);


--
-- Name: shipment_order_details fki0jayk8hstjo6v412mj89lrlb; Type: FK CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.shipment_order_details
    ADD CONSTRAINT fki0jayk8hstjo6v412mj89lrlb FOREIGN KEY (shipment_id) REFERENCES shipping.shipment(id);


--
-- Name: base_user_shipments fkkc5b5lg2lyggpwcjueomd5am9; Type: FK CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.base_user_shipments
    ADD CONSTRAINT fkkc5b5lg2lyggpwcjueomd5am9 FOREIGN KEY (client_id) REFERENCES shipping.base_user(id);


--
-- Name: base_user_roles fkkoh2p91oolq8ew3ourtmntxfi; Type: FK CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.base_user_roles
    ADD CONSTRAINT fkkoh2p91oolq8ew3ourtmntxfi FOREIGN KEY (base_user_id) REFERENCES shipping.users(id);


--
-- Name: base_user fkksplgcyusirssriua6m67xojl; Type: FK CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.base_user
    ADD CONSTRAINT fkksplgcyusirssriua6m67xojl FOREIGN KEY (wallet_id) REFERENCES shipping.wallet(id);


--
-- Name: base_user_approved_shippers fklgmdyjvohfdpph382xkrscvrs; Type: FK CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.base_user_approved_shippers
    ADD CONSTRAINT fklgmdyjvohfdpph382xkrscvrs FOREIGN KEY (client_id) REFERENCES shipping.base_user(id);


--
-- Name: shipment fkm2tgh13rl44gpo7vq7xc3gb7p; Type: FK CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.shipment
    ADD CONSTRAINT fkm2tgh13rl44gpo7vq7xc3gb7p FOREIGN KEY (order_detail_id) REFERENCES shipping.order_detail(id);


--
-- Name: base_user_shipments fkojmxb747k85bdjxt7tpbhagn8; Type: FK CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.base_user_shipments
    ADD CONSTRAINT fkojmxb747k85bdjxt7tpbhagn8 FOREIGN KEY (shipments_id) REFERENCES shipping.shipment(id);


--
-- Name: state_cities fkpube83cheofigcts5krj0ai0i; Type: FK CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.state_cities
    ADD CONSTRAINT fkpube83cheofigcts5krj0ai0i FOREIGN KEY (cities_id) REFERENCES shipping.city(id);


--
-- Name: shipment fksf2rixruf0lca99exajacbvpo; Type: FK CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.shipment
    ADD CONSTRAINT fksf2rixruf0lca99exajacbvpo FOREIGN KEY (shipper_shipment) REFERENCES shipping.shipper(id);


--
-- Name: state_cities fkssrnsj5h3nujymbko4suh9jsp; Type: FK CONSTRAINT; Schema: shipping; Owner: payarena
--

ALTER TABLE ONLY shipping.state_cities
    ADD CONSTRAINT fkssrnsj5h3nujymbko4suh9jsp FOREIGN KEY (state_id) REFERENCES shipping.state(id);


--
-- PostgreSQL database dump complete
--


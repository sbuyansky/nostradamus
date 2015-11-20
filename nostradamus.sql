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

--
-- Name: question_type; Type: TYPE; Schema: public; Owner: sbuyansky
--

CREATE TYPE question_type AS ENUM (
    'multiple_select',
    'numeric',
    'time'
);


ALTER TYPE public.question_type OWNER TO sbuyansky;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: choices; Type: TABLE; Schema: public; Owner: sbuyansky; Tablespace: 
--

CREATE TABLE choices (
    choice_id integer NOT NULL,
    text text NOT NULL
);


ALTER TABLE public.choices OWNER TO sbuyansky;

--
-- Name: choices_choice_id_seq; Type: SEQUENCE; Schema: public; Owner: sbuyansky
--

CREATE SEQUENCE choices_choice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.choices_choice_id_seq OWNER TO sbuyansky;

--
-- Name: choices_choice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sbuyansky
--

ALTER SEQUENCE choices_choice_id_seq OWNED BY choices.choice_id;


--
-- Name: prediction; Type: TABLE; Schema: public; Owner: sbuyansky; Tablespace: 
--

CREATE TABLE prediction (
    prediction_id integer NOT NULL,
    user_id integer NOT NULL,
    quiz_id integer NOT NULL,
    answers text[]
);


ALTER TABLE public.prediction OWNER TO sbuyansky;

--
-- Name: prediction_prediction_id_seq; Type: SEQUENCE; Schema: public; Owner: sbuyansky
--

CREATE SEQUENCE prediction_prediction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.prediction_prediction_id_seq OWNER TO sbuyansky;

--
-- Name: prediction_prediction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sbuyansky
--

ALTER SEQUENCE prediction_prediction_id_seq OWNED BY prediction.prediction_id;


--
-- Name: q_to_a; Type: TABLE; Schema: public; Owner: sbuyansky; Tablespace: 
--

CREATE TABLE q_to_a (
    question_id integer,
    choice_id integer
);


ALTER TABLE public.q_to_a OWNER TO sbuyansky;

--
-- Name: question; Type: TABLE; Schema: public; Owner: sbuyansky; Tablespace: 
--

CREATE TABLE question (
    question_id integer NOT NULL,
    type question_type NOT NULL,
    text text
);


ALTER TABLE public.question OWNER TO sbuyansky;

--
-- Name: question_question_id_seq; Type: SEQUENCE; Schema: public; Owner: sbuyansky
--

CREATE SEQUENCE question_question_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.question_question_id_seq OWNER TO sbuyansky;

--
-- Name: question_question_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sbuyansky
--

ALTER SEQUENCE question_question_id_seq OWNED BY question.question_id;


--
-- Name: quiz; Type: TABLE; Schema: public; Owner: sbuyansky; Tablespace: 
--

CREATE TABLE quiz (
    quiz_id integer NOT NULL,
    title text,
    for_date date
);


ALTER TABLE public.quiz OWNER TO sbuyansky;

--
-- Name: quiz_questions; Type: TABLE; Schema: public; Owner: sbuyansky; Tablespace: 
--

CREATE TABLE quiz_questions (
    quiz_id integer,
    question_id integer,
    gui_order integer
);


ALTER TABLE public.quiz_questions OWNER TO sbuyansky;

--
-- Name: quiz_quiz_id_seq; Type: SEQUENCE; Schema: public; Owner: sbuyansky
--

CREATE SEQUENCE quiz_quiz_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quiz_quiz_id_seq OWNER TO sbuyansky;

--
-- Name: quiz_quiz_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sbuyansky
--

ALTER SEQUENCE quiz_quiz_id_seq OWNED BY quiz.quiz_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: sbuyansky; Tablespace: 
--

CREATE TABLE users (
    user_id integer NOT NULL,
    username text NOT NULL,
    score integer
);


ALTER TABLE public.users OWNER TO sbuyansky;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: sbuyansky
--

CREATE SEQUENCE users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_user_id_seq OWNER TO sbuyansky;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sbuyansky
--

ALTER SEQUENCE users_user_id_seq OWNED BY users.user_id;


--
-- Name: choice_id; Type: DEFAULT; Schema: public; Owner: sbuyansky
--

ALTER TABLE ONLY choices ALTER COLUMN choice_id SET DEFAULT nextval('choices_choice_id_seq'::regclass);


--
-- Name: prediction_id; Type: DEFAULT; Schema: public; Owner: sbuyansky
--

ALTER TABLE ONLY prediction ALTER COLUMN prediction_id SET DEFAULT nextval('prediction_prediction_id_seq'::regclass);


--
-- Name: question_id; Type: DEFAULT; Schema: public; Owner: sbuyansky
--

ALTER TABLE ONLY question ALTER COLUMN question_id SET DEFAULT nextval('question_question_id_seq'::regclass);


--
-- Name: quiz_id; Type: DEFAULT; Schema: public; Owner: sbuyansky
--

ALTER TABLE ONLY quiz ALTER COLUMN quiz_id SET DEFAULT nextval('quiz_quiz_id_seq'::regclass);


--
-- Name: user_id; Type: DEFAULT; Schema: public; Owner: sbuyansky
--

ALTER TABLE ONLY users ALTER COLUMN user_id SET DEFAULT nextval('users_user_id_seq'::regclass);


--
-- Data for Name: choices; Type: TABLE DATA; Schema: public; Owner: sbuyansky
--

COPY choices (choice_id, text) FROM stdin;
1	Carl
2	Judy
\.


--
-- Name: choices_choice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sbuyansky
--

SELECT pg_catalog.setval('choices_choice_id_seq', 2, true);


--
-- Data for Name: prediction; Type: TABLE DATA; Schema: public; Owner: sbuyansky
--

COPY prediction (prediction_id, user_id, quiz_id, answers) FROM stdin;
\.


--
-- Name: prediction_prediction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sbuyansky
--

SELECT pg_catalog.setval('prediction_prediction_id_seq', 1, false);


--
-- Data for Name: q_to_a; Type: TABLE DATA; Schema: public; Owner: sbuyansky
--

COPY q_to_a (question_id, choice_id) FROM stdin;
3	1
3	2
6	1
6	2
8	1
8	2
\.


--
-- Data for Name: question; Type: TABLE DATA; Schema: public; Owner: sbuyansky
--

COPY question (question_id, type, text) FROM stdin;
1	numeric	Start Time:
2	multiple_select	Carl or Judy
3	numeric	How many bugs in a box?
4	numeric	Start Time:
5	multiple_select	Carl or Judy
6	numeric	How many bugs in a box?
7	numeric	Start Time:
8	multiple_select	Carl or Judy
9	numeric	How many bugs in a box?
\.


--
-- Name: question_question_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sbuyansky
--

SELECT pg_catalog.setval('question_question_id_seq', 9, true);


--
-- Data for Name: quiz; Type: TABLE DATA; Schema: public; Owner: sbuyansky
--

COPY quiz (quiz_id, title, for_date) FROM stdin;
1	Staff meeting	2015-11-14
2	Staff meeting	2015-11-14
3	Staff meeting	2015-11-14
\.


--
-- Data for Name: quiz_questions; Type: TABLE DATA; Schema: public; Owner: sbuyansky
--

COPY quiz_questions (quiz_id, question_id, gui_order) FROM stdin;
1	1	1
1	2	2
1	3	3
2	4	1
2	5	2
2	6	3
3	7	1
3	8	2
3	9	3
\.


--
-- Name: quiz_quiz_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sbuyansky
--

SELECT pg_catalog.setval('quiz_quiz_id_seq', 3, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: sbuyansky
--

COPY users (user_id, username, score) FROM stdin;
\.


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sbuyansky
--

SELECT pg_catalog.setval('users_user_id_seq', 1, false);


--
-- Name: choices_pkey; Type: CONSTRAINT; Schema: public; Owner: sbuyansky; Tablespace: 
--

ALTER TABLE ONLY choices
    ADD CONSTRAINT choices_pkey PRIMARY KEY (choice_id);


--
-- Name: prediction_pkey; Type: CONSTRAINT; Schema: public; Owner: sbuyansky; Tablespace: 
--

ALTER TABLE ONLY prediction
    ADD CONSTRAINT prediction_pkey PRIMARY KEY (prediction_id);


--
-- Name: question_pkey; Type: CONSTRAINT; Schema: public; Owner: sbuyansky; Tablespace: 
--

ALTER TABLE ONLY question
    ADD CONSTRAINT question_pkey PRIMARY KEY (question_id);


--
-- Name: quiz_pkey; Type: CONSTRAINT; Schema: public; Owner: sbuyansky; Tablespace: 
--

ALTER TABLE ONLY quiz
    ADD CONSTRAINT quiz_pkey PRIMARY KEY (quiz_id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: sbuyansky; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: prediction_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sbuyansky
--

ALTER TABLE ONLY prediction
    ADD CONSTRAINT prediction_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES quiz(quiz_id) ON DELETE RESTRICT;


--
-- Name: prediction_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sbuyansky
--

ALTER TABLE ONLY prediction
    ADD CONSTRAINT prediction_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE RESTRICT;


--
-- Name: q_to_a_choice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sbuyansky
--

ALTER TABLE ONLY q_to_a
    ADD CONSTRAINT q_to_a_choice_id_fkey FOREIGN KEY (choice_id) REFERENCES choices(choice_id);


--
-- Name: q_to_a_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sbuyansky
--

ALTER TABLE ONLY q_to_a
    ADD CONSTRAINT q_to_a_question_id_fkey FOREIGN KEY (question_id) REFERENCES question(question_id);


--
-- Name: quiz_questions_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sbuyansky
--

ALTER TABLE ONLY quiz_questions
    ADD CONSTRAINT quiz_questions_question_id_fkey FOREIGN KEY (question_id) REFERENCES question(question_id);


--
-- Name: quiz_questions_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sbuyansky
--

ALTER TABLE ONLY quiz_questions
    ADD CONSTRAINT quiz_questions_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES quiz(quiz_id);


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


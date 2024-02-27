--
-- PostgreSQL database dump
--

-- Dumped from database version 16.0
-- Dumped by pg_dump version 16.1

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
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- Name: dodajklienta(character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.dodajklienta(imie_klienta character varying, nazwisko_klienta character varying, login_uzytkownika character varying, haslo_uzytkownika character varying, email_uzytkownika character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    uuid_klienta UUID := gen_random_uuid();
    uuid_uzytkownika UUID := gen_random_uuid();
BEGIN
    INSERT INTO Klienci (KlienciID, Imie, Nazwisko)
    VALUES (uuid_klienta, imie_klienta, nazwisko_klienta);

    INSERT INTO Uzytkownicy (UzytkownicyID, Login, Haslo, Email, KlientID, uprawnienia)
    VALUES (uuid_uzytkownika, login_uzytkownika, haslo_uzytkownika, email_uzytkownika, uuid_klienta, 'klient');
END $$;


ALTER FUNCTION public.dodajklienta(imie_klienta character varying, nazwisko_klienta character varying, login_uzytkownika character varying, haslo_uzytkownika character varying, email_uzytkownika character varying) OWNER TO postgres;

--
-- Name: dodajpracownika(character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.dodajpracownika(imie_pracownika character varying, nazwisko_pracownika character varying, login_uzytkownika character varying, haslo_uzytkownika character varying, email_uzytkownika character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    uuid_klienta UUID := gen_random_uuid();
    uuid_uzytkownika UUID := gen_random_uuid();
BEGIN
    INSERT INTO Klienci (KlienciID, Imie, Nazwisko)
    VALUES (uuid_klienta, imie_pracownika, nazwisko_pracownika);

    INSERT INTO Uzytkownicy (UzytkownicyID, Login, Haslo, Email, KlientID, uprawnienia)
    VALUES (uuid_uzytkownika, login_uzytkownika, haslo_uzytkownika, email_uzytkownika, uuid_klienta, 'pracownik');
END $$;


ALTER FUNCTION public.dodajpracownika(imie_pracownika character varying, nazwisko_pracownika character varying, login_uzytkownika character varying, haslo_uzytkownika character varying, email_uzytkownika character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: gatunki; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gatunki (
    gatunkiid uuid NOT NULL,
    nazwa character varying(255) NOT NULL
);


ALTER TABLE public.gatunki OWNER TO postgres;

--
-- Name: klienci; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.klienci (
    klienciid uuid NOT NULL,
    imie character varying(255) NOT NULL,
    nazwisko character varying(255) NOT NULL
);


ALTER TABLE public.klienci OWNER TO postgres;

--
-- Name: platformy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.platformy (
    platformyid uuid NOT NULL,
    nazwa character varying(255) NOT NULL
);


ALTER TABLE public.platformy OWNER TO postgres;

--
-- Name: produkty; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produkty (
    produktyid uuid NOT NULL,
    nazwa character varying(255) NOT NULL,
    opis text NOT NULL,
    cena numeric(10,2),
    wydawcaid uuid NOT NULL,
    gatunekid uuid NOT NULL,
    platformaid uuid NOT NULL,
    data_wydania date,
    ilosc integer DEFAULT 0 NOT NULL,
    CONSTRAINT produkty_ilosc_check CHECK ((ilosc >= 0))
);


ALTER TABLE public.produkty OWNER TO postgres;

--
-- Name: uzytkownicy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.uzytkownicy (
    uzytkownicyid uuid NOT NULL,
    login character varying(255) NOT NULL,
    haslo character varying(255) NOT NULL,
    email character varying NOT NULL,
    klientid uuid NOT NULL,
    uprawnienia character varying NOT NULL
);


ALTER TABLE public.uzytkownicy OWNER TO postgres;

--
-- Name: wydawcy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wydawcy (
    wydawcyid uuid NOT NULL,
    nazwa character varying(255) NOT NULL,
    panstwo character varying(255) NOT NULL
);


ALTER TABLE public.wydawcy OWNER TO postgres;

--
-- Name: zamowienia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.zamowienia (
    zamowienieid uuid NOT NULL,
    klientid uuid NOT NULL,
    produktid uuid NOT NULL,
    cenazakupu numeric(10,2) NOT NULL,
    datazamowienia date NOT NULL
);


ALTER TABLE public.zamowienia OWNER TO postgres;

--
-- Data for Name: gatunki; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gatunki (gatunkiid, nazwa) FROM stdin;
68809915-e681-488b-8d8b-144d76154325	RPG
48821f84-a87a-4c54-b0c1-612cbe59b3dd	FPS
496c9224-d5a5-40d7-ab90-91f72adc52bd	RTS
ce72e139-9d83-47f4-b311-db4540b3ed9b	Akcja
b09746df-132e-4dbe-901a-94e90a246d73	Survival Horror
fc9bfd05-afc4-456b-b7d5-20ee6f52d62d	Przygodowa
90933599-e184-4a1b-b378-5ccb62f6ee9e	Platformowa
c15593ab-8d2c-4042-8b82-82106d522a29	Strategiczna
dcd15050-e4f5-489e-8b1c-1825141697d1	Wyścigi
44cbaa79-d681-4134-9e55-a3c40b81a6d8	Symulacyjna
\.


--
-- Data for Name: klienci; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.klienci (klienciid, imie, nazwisko) FROM stdin;
201205f4-cbc0-487e-a1cb-afe9320d3ee3	Szymon	Kluska
051d266f-cd28-4a6f-a159-befb59daa73c	Adam	Moska
bad47517-9e63-4cce-a3d5-38045fc29498	Wojtek	Kluska
191412e0-fbff-49e0-bd07-f5e876ea839b	Test	test
91599668-b950-49ad-8929-e2751b736676	szymon	nazwisko
f90bfc78-2bfd-4539-8a1e-297267a28a59	szymon	nazwisko
99c8bac6-48b6-47c4-b22e-fee628d0396b	Szymon	Kluska
9a50fab9-c3c0-43e7-9e46-3ecab8e6ec4e	Szymon	Kluska
2674d270-47df-4876-8c6d-e2cc3c6c63f0	new	user
d2cc26fd-fcc1-4240-8a55-e6f2db9f0958	new2	user2
a72516d2-96ea-4e2f-b1ea-1383bd41802b	new	user2
acd6795b-72ac-4f06-a1e9-c5c08dba9c7e	test	zajecia
\.


--
-- Data for Name: platformy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.platformy (platformyid, nazwa) FROM stdin;
51e25813-0cce-4705-8d3d-dd5ffb8874d3	PC
d3ada428-24e3-4cab-963c-c11b5bba62de	PlayStation 5
70dc4f64-a16c-4449-b638-c2740a65a305	Switch
b6786c57-2cbd-4d9e-9ec4-a8dd14b48664	PlayStation 4
cf0abf97-295d-484d-948a-887532a2fce2	Xbox Series X
e145d354-0ca0-46df-8ada-de0f1880e182	PlayStation 3
5617515e-756e-494f-900c-296892392d02	Xbox 360
\.


--
-- Data for Name: produkty; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produkty (produktyid, nazwa, opis, cena, wydawcaid, gatunekid, platformaid, data_wydania, ilosc) FROM stdin;
30add590-e1a0-43eb-806d-940c07839864	Resident Evil 2 Remake	Remake kultowej gry survival horror, opowiadający historię Leona Kennedy’ego i Claire Redfield próbujących przetrwać w zainfekowanym zombie miastem Racoon City.	35.00	48acaac0-9f76-45e2-8a83-fce3f442d54f	b09746df-132e-4dbe-901a-94e90a246d73	51e25813-0cce-4705-8d3d-dd5ffb8874d3	2019-01-25	0
d9283d24-1d20-4e56-b865-05393be77f63	Halo Infinite	Najnowsza odsłona kultowej serii FPS, w której gracze wcielają się w Master Chiefa i walczą z przeciwnikami w futurystycznym świecie.	60.00	f660b288-0f16-47af-8ef1-4baf67068874	48821f84-a87a-4c54-b0c1-612cbe59b3dd	cf0abf97-295d-484d-948a-887532a2fce2	2021-12-08	0
520d7f74-9dbe-46bc-a596-5026ef37544b	Marvel's Spider-Man 2	Druga część bestsellerowej serii Spider-Man autorstwa Insomniac Games. Gra została stworzona z myślą o konsoli PS5 i zawiera dwie grywalne postacie – Petera Parkera i Milesa Moralesa..	70.00	53381a70-41a5-4b78-9ba8-759e81fa574e	ce72e139-9d83-47f4-b311-db4540b3ed9b	d3ada428-24e3-4cab-963c-c11b5bba62de	2023-10-20	0
0c7b4161-0266-4b5f-8ab6-c7913a260816	Crysis	Opracowana przez niemieckie studio Crytek futurystyczna strzelanina FPS, która w pierwotnych założeniach miała stanowić kontynuację bestsellerowego Far Cry. Akcja gry toczy się na niewielkiej wyspie, na której uczeni dokonują przełomowego odkrycia.	30.00	e9a9cfd8-1fe6-4206-b1c3-ab3e3bdc6746	48821f84-a87a-4c54-b0c1-612cbe59b3dd	51e25813-0cce-4705-8d3d-dd5ffb8874d3	2007-11-13	0
9e7f17db-d55a-4e6a-be0c-53181fd1f7bf	Crysis 2	Kontynuacja gry FPS, która przenosi akcję do zniszczonego Nowego Jorku, gdzie gracz walczy z kolejną obcą inwazją.	40.00	e9a9cfd8-1fe6-4206-b1c3-ab3e3bdc6746	48821f84-a87a-4c54-b0c1-612cbe59b3dd	e145d354-0ca0-46df-8ada-de0f1880e182	2011-03-22	0
fcb51fc2-5d9c-4e18-bfcb-bdb93bf34c17	Crysis 3	trzeciej odsłonie serii Crysis przenosimy się do roku 2047 i wcielamy w posiadacza nanokombinezonu Proroka, który staje do walki z obcą rasą Ceph oraz korporacją Cell. Firma doprowadziła do powstania gigantycznej kopuły na terenie Nowego Jorku. Wewnątrz znajduje się zróżnicowany mikroświat, nazywany „Siedmioma Cudami”. Prorok wybiera się w to miejsce, aby poznać prawdę o planach Cell i wziąć odwet za wcześniejsze wydarzenia.	50.00	e9a9cfd8-1fe6-4206-b1c3-ab3e3bdc6746	48821f84-a87a-4c54-b0c1-612cbe59b3dd	5617515e-756e-494f-900c-296892392d02	2013-02-19	0
0d78c0a9-f569-4947-8f61-adbb21a0f1b3	Baldur's Gate 3	Zbierz swoją drużynę i wyrusz ponownie do Zapomnianych Krain w opowieści o przyjaźni i zdradzie, poświęceniu i przetrwaniu oraz pokusie władzy absolutnej.	70.00	e9a9cfd8-1fe6-4206-b1c3-ab3e3bdc6746	68809915-e681-488b-8d8b-144d76154325	51e25813-0cce-4705-8d3d-dd5ffb8874d3	2023-08-03	0
0e9ca8b4-c480-4415-8c2a-04726d4f0cc1	Baldur's Gate 3	Zbierz swoją drużynę i wyrusz ponownie do Zapomnianych Krain w opowieści o przyjaźni i zdradzie, poświęceniu i przetrwaniu oraz pokusie władzy absolutnej.	70.00	0bd506fc-88c2-4faa-b716-f6eb9b6bdd90	68809915-e681-488b-8d8b-144d76154325	d3ada428-24e3-4cab-963c-c11b5bba62de	2023-08-03	0
a9ddc190-6560-4a0c-a60f-837660f56f67	The Witcher 3: Wild Hunt	Gra action RPG, stanowiąca trzecią część przygód Geralta z Rivii. Podobnie jak we wcześniejszych odsłonach cyklu, Wiedźmin 3: Dziki Gon bazuje na motywach twórczości literackiej Andrzeja Sapkowskiego, jednak nie jest bezpośrednią adaptacją żadnej z jego książek.	40.00	077956da-0bf5-422b-b6bd-4db314bc579c	68809915-e681-488b-8d8b-144d76154325	d3ada428-24e3-4cab-963c-c11b5bba62de	2015-05-19	4
9a6b2147-316a-447c-b018-49f3862e4558	Resident Evil 2 Remake	Remake kultowej gry survival horror, opowiadający historię Leona Kennedy’ego i Claire Redfield próbujących przetrwać w zainfekowanym zombie miastem Racoon City.	35.00	48acaac0-9f76-45e2-8a83-fce3f442d54f	b09746df-132e-4dbe-901a-94e90a246d73	b6786c57-2cbd-4d9e-9ec4-a8dd14b48664	2019-01-25	6
0dc67db5-f758-4b94-a480-83209ef6f76f	Warcraft 3	Warcraft III: Reign of Chaos to trzecia odsłona kultowej serii osadzonych w realiach fantasy RTS-ów, zapoczątkowanej w 1994 roku przez studio Blizzard. W krainie Azeroth siły ludzi, orków i nocnych elfów stawiają czoła inwazji nieumarłych, zwanych Plagą albo Nocnym Legionem.	50.00	62458347-e22c-44c0-aa61-85eec533844b	496c9224-d5a5-40d7-ab90-91f72adc52bd	51e25813-0cce-4705-8d3d-dd5ffb8874d3	2002-07-03	3
e0d2f72d-074c-4193-8772-c6e12580e0ab	The Witcher 3: Wild Hunt	Gra action RPG, stanowiąca trzecią część przygód Geralta z Rivii. Podobnie jak we wcześniejszych odsłonach cyklu, Wiedźmin 3: Dziki Gon bazuje na motywach twórczości literackiej Andrzeja Sapkowskiego, jednak nie jest bezpośrednią adaptacją żadnej z jego książek.	40.00	077956da-0bf5-422b-b6bd-4db314bc579c	68809915-e681-488b-8d8b-144d76154325	51e25813-0cce-4705-8d3d-dd5ffb8874d3	2015-05-19	1
eedd6ad3-f4f6-4150-b6a4-3a0fbd4928e4	Diablo III	Trzecia część cieszącej się ogromną popularnością serii gier RPG akcji, wykreowanej i rozwijanej przez firmę Blizzard Entertainment. Fabuła Diablo III ponownie zabiera graczy do świata Sanktuarium, gdzie muszą stawić czoła siłom zła	40.00	62458347-e22c-44c0-aa61-85eec533844b	68809915-e681-488b-8d8b-144d76154325	51e25813-0cce-4705-8d3d-dd5ffb8874d3	2012-05-15	22
9a34be26-ae6e-4b09-8166-d7a8d1a90ae5	The Witcher 3: Wild Hunt	Gra action RPG, stanowiąca trzecią część przygód Geralta z Rivii. Podobnie jak we wcześniejszych odsłonach cyklu, Wiedźmin 3: Dziki Gon bazuje na motywach twórczości literackiej Andrzeja Sapkowskiego, jednak nie jest bezpośrednią adaptacją żadnej z jego książek.	40.00	077956da-0bf5-422b-b6bd-4db314bc579c	68809915-e681-488b-8d8b-144d76154325	70dc4f64-a16c-4449-b638-c2740a65a305	2015-05-19	5
3d50c1a0-6091-48f8-8e4d-d5756c1a7a3b	The Elder Scrolls V: Skyrim	Zrealizowana z dużym rozmachem gra action-RPG, będąca piątą częścią popularnego cyklu The Elder Scrolls. Produkcja studia Bethesda Softworks pozwala graczom ponownie przenieść się do fantastycznego świata Nirn.	50.00	f43177c0-cfb5-4cb9-910d-2c4af7afdd8a	68809915-e681-488b-8d8b-144d76154325	51e25813-0cce-4705-8d3d-dd5ffb8874d3	2022-11-11	10
03f2c801-a744-44b3-8b35-4a1d57196767	TEST	lorem ipsum dolores	100000.00	48acaac0-9f76-45e2-8a83-fce3f442d54f	b09746df-132e-4dbe-901a-94e90a246d73	51e25813-0cce-4705-8d3d-dd5ffb8874d3	2019-01-25	20
\.


--
-- Data for Name: uzytkownicy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.uzytkownicy (uzytkownicyid, login, haslo, email, klientid, uprawnienia) FROM stdin;
47b31fd3-b840-4c61-9652-8f164398d5b5	SzymonK	$2b$12$MsANwHZfu/WDrhIePgViBu3/rHQTlOgufBWOWrEnrHcDy7CQsSioa	admin@admin.pl	99c8bac6-48b6-47c4-b22e-fee628d0396b	pracownik
58d5055f-328b-4a95-b08c-fe4d7d0681f9	SzymonK	$2b$12$R6ryApvS7GRwy3W0EoRjPeyXNs5sbGv2q49KZLpeKej22GJxTw.e2	newadmin@admin.pl	9a50fab9-c3c0-43e7-9e46-3ecab8e6ec4e	klient
98bde7a4-e23d-4248-8653-3aedcde57552	nowy	$2b$12$osG/In5IXJx4c6.CTixmW...oFXG7A3A7WPheP.J1HOznoW5LXcoG	new@m.pl	2674d270-47df-4876-8c6d-e2cc3c6c63f0	klient
4152193b-89ab-4c86-a23b-a5fdf8370777	nowy2	$2b$12$P6cyFvXpKsAdd498kOcxSOiA45leNxUMggDbLZpxFzHWsfJSk6G7e	n@2.pl	d2cc26fd-fcc1-4240-8a55-e6f2db9f0958	klient
b3fbeaad-0f14-401d-8471-88bb192af914	new2	$2b$12$ZYehTuUx.0RPx31XOj5QduFRaaorvsuxEWn/ofWIFTdaPD/yZOU06	user2@mn.pl	a72516d2-96ea-4e2f-b1ea-1383bd41802b	klient
e0e9d134-968a-4740-a1b9-e235d53374f5	szymonk	$2b$12$ojNRHp.JcqAi3/Dj/Z4xp.h24Wt3S/46FFRjqY65FYtZ.VsKRFL0S	szymon@edu.pl	f90bfc78-2bfd-4539-8a1e-297267a28a59	klient
4d79a81d-d1dd-433f-9b70-fa766f3e47df	zajecia	$2b$12$Zhr2I75d/PbWSXq62crVaeoQDPSZoQDuiMwYkxglFLIiVRvTY0RGG	zajecia@m.pl	acd6795b-72ac-4f06-a1e9-c5c08dba9c7e	klient
\.


--
-- Data for Name: wydawcy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wydawcy (wydawcyid, nazwa, panstwo) FROM stdin;
f43177c0-cfb5-4cb9-910d-2c4af7afdd8a	Bethesda	Stany Zjednoczone
62458347-e22c-44c0-aa61-85eec533844b	Blizzard	Stany Zjednoczone
077956da-0bf5-422b-b6bd-4db314bc579c	CD Projekt Red	Polska
2afc4595-8beb-4bd1-b6b6-53f3c95e6890	Techland	Polska
e9a9cfd8-1fe6-4206-b1c3-ab3e3bdc6746	EA	Stany Zjednoczone
e9fa3fa8-79ed-42d7-b371-81ffd8edbaa0	Ubisoft	Francja
428fb381-078b-4696-a891-7667b9461d23	Nintendo	Japonia
174704e3-d4a9-478d-b29d-5bf03d5e7a11	Square Enix	Japonia
de1d9497-ccb8-4efd-9d8d-ab8cb2d7b7a1	Rockstar Games	Stany Zjednoczone
48acaac0-9f76-45e2-8a83-fce3f442d54f	Capcom	Japonia
53381a70-41a5-4b78-9ba8-759e81fa574e	Sony Interactive Entertainment	Japonia
f660b288-0f16-47af-8ef1-4baf67068874	Microsoft Studios	Stany Zjednoczone
15ac6f2c-63ba-4d2c-89bf-eeaaa392235e	2K Games	Stany Zjednoczone
4323776b-103c-4483-bac6-abaf38517bb6	Sega	Japonia
acdf85b5-9560-4d83-b388-434f56a571fc	Konami	Japonia
ca16e0af-c0e3-40bf-a4d2-3168e0af01cc	Bandai Namco Entertainment	Japonia
915f56ea-9e1e-43cb-9924-7de5cc3c5784	Activision	Stany Zjednoczone
11c897c7-cf89-4acf-b47a-d17acb102e78	Valve Corporation	Stany Zjednoczone
0258c0e2-23c4-4145-8c3b-017b6c1f0ebd	THQ Nordic	Austria
0bd506fc-88c2-4faa-b716-f6eb9b6bdd90	Larian Studios	Belgia
\.


--
-- Data for Name: zamowienia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.zamowienia (zamowienieid, klientid, produktid, cenazakupu, datazamowienia) FROM stdin;
e1026329-7e76-442f-88f2-d94d2948bd6a	201205f4-cbc0-487e-a1cb-afe9320d3ee3	0dc67db5-f758-4b94-a480-83209ef6f76f	46.00	2021-10-03
f5b70ca2-9401-47fc-bfe0-a3e3a871769f	201205f4-cbc0-487e-a1cb-afe9320d3ee3	30add590-e1a0-43eb-806d-940c07839864	26.00	2023-10-03
3a3f4db6-aab6-435c-806a-4143a3e51b33	201205f4-cbc0-487e-a1cb-afe9320d3ee3	0d78c0a9-f569-4947-8f61-adbb21a0f1b3	71.00	2022-10-03
55109952-1f7b-4885-b705-e897f1424d86	051d266f-cd28-4a6f-a159-befb59daa73c	d9283d24-1d20-4e56-b865-05393be77f63	50.99	2023-12-14
8867956e-afe8-4b35-8670-5dc15fd002cc	051d266f-cd28-4a6f-a159-befb59daa73c	e0d2f72d-074c-4193-8772-c6e12580e0ab	21.50	2023-12-14
758c6a9e-19b2-416f-8812-5aad68dcdfc0	99c8bac6-48b6-47c4-b22e-fee628d0396b	30add590-e1a0-43eb-806d-940c07839864	35.00	2024-01-08
f7772393-3bb6-45c6-acaf-308d2fdbf70a	99c8bac6-48b6-47c4-b22e-fee628d0396b	3d50c1a0-6091-48f8-8e4d-d5756c1a7a3b	50.00	2024-01-08
96ed4e7e-022f-4e12-bc74-f0f06400c413	2674d270-47df-4876-8c6d-e2cc3c6c63f0	eedd6ad3-f4f6-4150-b6a4-3a0fbd4928e4	40.00	2024-01-11
6919fef1-25df-4d97-82a1-70f6493021b1	99c8bac6-48b6-47c4-b22e-fee628d0396b	0d78c0a9-f569-4947-8f61-adbb21a0f1b3	70.00	2024-01-11
1be65b7d-4114-4488-8676-6c3ec73b516c	99c8bac6-48b6-47c4-b22e-fee628d0396b	0dc67db5-f758-4b94-a480-83209ef6f76f	50.00	2024-01-11
7aa477fc-f15e-4698-a5a8-33472a00e871	99c8bac6-48b6-47c4-b22e-fee628d0396b	0c7b4161-0266-4b5f-8ab6-c7913a260816	30.00	2024-01-11
2a9e7d58-f26d-4812-af5c-417b64a45639	d2cc26fd-fcc1-4240-8a55-e6f2db9f0958	9e7f17db-d55a-4e6a-be0c-53181fd1f7bf	40.00	2024-01-30
\.


--
-- Name: gatunki gatunki_nazwa_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gatunki
    ADD CONSTRAINT gatunki_nazwa_key UNIQUE (nazwa);


--
-- Name: gatunki gatunki_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gatunki
    ADD CONSTRAINT gatunki_pkey PRIMARY KEY (gatunkiid);


--
-- Name: klienci klienci_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.klienci
    ADD CONSTRAINT klienci_pkey PRIMARY KEY (klienciid);


--
-- Name: platformy platformy_nazwa_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.platformy
    ADD CONSTRAINT platformy_nazwa_key UNIQUE (nazwa);


--
-- Name: platformy platformy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.platformy
    ADD CONSTRAINT platformy_pkey PRIMARY KEY (platformyid);


--
-- Name: produkty produkty_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produkty
    ADD CONSTRAINT produkty_pkey PRIMARY KEY (produktyid);


--
-- Name: uzytkownicy uzytkownicy_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uzytkownicy
    ADD CONSTRAINT uzytkownicy_email_key UNIQUE (email);


--
-- Name: uzytkownicy uzytkownicy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uzytkownicy
    ADD CONSTRAINT uzytkownicy_pkey PRIMARY KEY (uzytkownicyid);


--
-- Name: wydawcy wydawcy_nazwa_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wydawcy
    ADD CONSTRAINT wydawcy_nazwa_key UNIQUE (nazwa);


--
-- Name: wydawcy wydawcy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wydawcy
    ADD CONSTRAINT wydawcy_pkey PRIMARY KEY (wydawcyid);


--
-- Name: zamowienia zamówienia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zamowienia
    ADD CONSTRAINT "zamówienia_pkey" PRIMARY KEY (zamowienieid);


--
-- Name: produkty fk_produkty_gatunki; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produkty
    ADD CONSTRAINT fk_produkty_gatunki FOREIGN KEY (gatunekid) REFERENCES public.gatunki(gatunkiid);


--
-- Name: produkty fk_produkty_platformy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produkty
    ADD CONSTRAINT fk_produkty_platformy FOREIGN KEY (platformaid) REFERENCES public.platformy(platformyid);


--
-- Name: produkty fk_produkty_wydawcy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produkty
    ADD CONSTRAINT fk_produkty_wydawcy FOREIGN KEY (wydawcaid) REFERENCES public.wydawcy(wydawcyid);


--
-- Name: uzytkownicy fk_uzytkownicy_klienci; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uzytkownicy
    ADD CONSTRAINT fk_uzytkownicy_klienci FOREIGN KEY (klientid) REFERENCES public.klienci(klienciid);


--
-- Name: zamowienia fk_zamowienia_klienci; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zamowienia
    ADD CONSTRAINT fk_zamowienia_klienci FOREIGN KEY (klientid) REFERENCES public.klienci(klienciid);


--
-- Name: zamowienia fk_zamowienia_produkty; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zamowienia
    ADD CONSTRAINT fk_zamowienia_produkty FOREIGN KEY (produktid) REFERENCES public.produkty(produktyid);


--
-- PostgreSQL database dump complete
--


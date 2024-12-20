CREATE TABLE ATTORI(CodAttore INT PRIMARY KEY,
                     Nome VARCHAR(40) NOT NULL ,
                      AnnoNascita DATE NOT NULL,
                       Nazionalita VARCHAR(40) NOT NULL);

CREATE TABLE FILM(CodFilm INT PRIMARY KEY,
                  Titolo VARCHAR(40) NOT NULL,
                  AnnoProduzione VARCHAR(40) NOT NULL,
                  Nazionalita VARCHAR(40) NOT NULL,
                  Regista VARCHAR(40) NOT NULL,
                  Genere VARCHAR(40) NOT NULL);


CREATE TABLE RECITA( CodAttore INT NOT NULL,
                     CodFilm INT NOT NULL,
FOREIGN KEY (CodAttore) REFERENCES ATTORI(CodAttore),
FOREIGN KEY (CodFilm) REFERENCES FILM(CodFilm));



CREATE TABLE SALE(CodSala INT PRIMARY KEY,
                  Posti VARCHAR(40) NOT NULL,
                  Nome VARCHAR(40) NOT NULL,
                  Citta VARCHAR(40) NOT NULL);


CREATE TABLE PROIEZIONI(CodProiezione INT PRIMARY KEY,
                         CodFilm INT NOT NULL,
                         CodSala INT NOT NULL,
                         Incasso VARCHAR(40) NOT NULL,
                         DataProiezione VARCHAR(40) NOT NULL,
FOREIGN KEY (CodFilm) REFERENCES FILM (CodFilm),
FOREIGN KEY (CodSala) REFERENCES SALE (CodSala));





-- 1-Il nome di tutte le sale di Pisa
SELECT NOME
 FROM SALE
 WHERE CITTA = 'PISA';

-- 2-Il titolo dei film di F. Fellini prodotti dopo il 1960.
SELECT TITOLO
FROM FILM
WHERE REGISTA = 'F.FELLINI'
AND ANNOPRODUZIONE>1960;

-- 3- Il titolo e la durata dei film di fantascienza giapponesi o francesi prodotti dopo il 1990
SELECT TITOLO, DURATA
FROM FILM
WHERE GENERE='FANTASCIENZA' 
AND (NATIONALITA='GIAPPONESI' OR NATIONALITA='FRANCESI')
AND ANNOPRODUZIONE>1990;

-- 4- Il titolo dei film di fantascienza giapponesi prodotti dopo il 1990 oppure francesi
SELECT TITOTO
FROM FILM
WHERE GENERE = 'FANTASCIENZA'
AND NATIONALITA ='GIAPPONESI'
AND ANNOPRODUZIONE >1990
OR NATIONALITA='FRANCESI';

-- 5- I titolo dei film dello stesso regista di “Casablanca”
SELECT TITOLO 
FROM FILM
WHERE REGISTA = (
                 SELECT REGISTA
                 FROM FILM
                 WHERE TITOLO ='CASABLANCA';
                 
-- 6- Il titolo ed il genere dei film proiettati il giorno di Natale 2004
SELECT F.TITOLO, F.GENERE
FROM FILM F
JOIN PROIEZIONI P ON F.CODILM = P.CODFILM
WHERE DATAPROIEZIONE BETWEEN '2004-12-25 00:00:00' AND '2004-12-25 23:59:59';

-- 7- Il titolo ed il genere dei film proiettati a Napoli il giorno di Natale 2004
SELECT F.TITOLO, F.GENERE
FROM FILM F
JOIN PROIEZIONE P ON F.CODFILM = P.CODFILM
JOIN SALE S ON P.CODSALA = S.CODSALA
WHERE P.DATAPROIEZIONE BETWEEN '2004-12-25 00:00:00' AND '2004-12-25 23:59:59' 
AND S.CITTA = 'NAPOLI';

-- 8- I nomi delle sale di Napoli in cui il giorno di Natale 2004 è stato proiettato un film con R.Williams
SELECT S.NOME 
FROM SALE S
JOIN PROIEZIONE P ON S.CODSALA = P.CODSALA
JOIN FILM F ON P.CODFILM = F.CODFILM
JOIN RECITA R ON F.CODFILM = R.CODFILM
JOIN ATTORI A ON R.CODATTORE = A.CODATTORE
WHERE P.DATAPROIEZIONE = '2004-12-25' AND S.CITTA='NAPLES' AND A.NOME = 'R.WILLIAMS';

-- 9- Il titolo dei film in cui recita M. Mastroianni oppure S.Loren
SELECT F.TITOLO
FROM FILM F
JOIN RECITA R ON F.CODFILM = R.CODFILM
JOIN ATTORI A ON R.CODATTORE = A.CODATTORE
WHERE A.NOME IN ('M.MASTROIANNI', 'S.LOREN');

-- 10- Il titolo dei film in cui recitano M. Mastroianni e S.Loren
SELECT F.TITOLO
FROM FILM F
WHERE EXISTS (SELECT 1 FROM RECITA R JOIN ATTORI A ON R.CODATTORE = A.CODATTORE
              WHERE R.CODFILM = F.CODFILM AND A.NOME='M. MASTROIANNI')
              (SELECT 1 FROM RECITA R JOIN ATTORI A ON R.CODATTORE = A.CODATTORE
              WHERE R.CODFILM = F.CODFILM AND A.NOME='S. LOREN');
-- 11- Per ogni film in cui recita un attore francese, il titolo del film e il nome dell’attore
SELECT F.TITOLO, A.NOME
FROM FILM F
JOIN RECITA R ON F.CODFILM = R.CODFILM
JOIN ATTORI A ON R.CODATTORE = A.CODATTORE
WHERE A.NATIONALITA = 'FRENCESI';
-- 12- Per ogni film che è stato proiettato a Pisa nel gennaio 2005, il titolo del film e il nome della sala.
SELECT F.TITOLO, S.NOME
FROM F
JOIN PROIEZIONI P ON F.CODFILM = P.CODFILM
JOIN SALE S ON P.CODSALA = S.CODSALA
WHERE S.CITTA = 'PISA' AND P.DATAPROIEZIONE BETWEEN '2005-01-01' AND '2005-01-31';

-- 13- Il numero di sale di Pisa con più di 60 posti
SELECT COUNT(*)
FROM SALE 
WHERE CITTA = 'PISA' AND POSTI > 60;

-- 14- Il numero totale di posti nelle sale di Pisa
SELECT SUM(POSTI)
FROM SALE
WHERE CITTA = 'PISA';

-- 15- Per ogni città, il numero di sale
SELECT CITTA, COUNT(*) AS NUMEROSALE
FROM SALE
GROUP BY CITTA;

-- 16- Per ogni città, il numero di sale con più di 60 posti
SELECT CITTA, COUNT(*) AS NUMEROSALE
FROM SALE
WHERE POSTI > 60;

-- 17- Per ogni regista, il numero di film diretti dopo il 1990
SELECT REGISTA, COUNT(*) AS NUMEROFILM
FROM FILM 
WHERE ANNOPRODUZIONE > 1990
GROUP BY REGISTA;

-- 18- Per ogni regista, l’incasso totale di tutte le proiezioni dei suoi film
SELECT F.REGISTA, SUM(P.INCASSO) AS TOTALEINCASSI
FROM FILM F
JOIN PROIEZIONE P ON F.CODFILM = P.CODFILM
GROUP BY F.REGISTA;

-- 19- Per ogni film di S.Spielberg, il titolo del film, il numero totale di proiezioni a Pisa e l’incasso totale
SELECT F.TITOLO, COUNT(P.CODPROIEZIONE) AS NUMEROPROIEZIONI, SUM(P.INCASSO) AS TOTALEINCASSO
FROM FILM F
JOIN PROIEZIONI P ON F.CODFILM = P.CODFILM
JOIN SALE S ON P.CODSALE = S.CODSALE
WHERE F.REGISTA = 'S. SPIELBERG' AND S.CITTA = 'PISA'
GROUP BY F.TITOLO;

-- 20- Per ogni regista e per ogni attore, il numero di film del regista con l’attore
SELECT F.REGISTA, A.NOME, COUNT(*) AS NUMEROFILM
FROM FILM F
JOIN RECITA R ON F.CODFILM = R. CODFILM
JOIN ATTORI A ON R.CODATTORE = A.CODATTORE
GROUP BY F.REGISTA, A.NOME;
/*
21 - Il regista ed il titolo dei film in cui recitano meno di 6 attori
22- Per ogni film prodotto dopo il 2000, il codice, il titolo e l’incasso totale di tutte le sue
proiezioni
23 - Il numero di attori dei film in cui appaiono solo attori nati prima del 1970
24- Per ogni film di fantascienza, il titolo e l’incasso totale di tutte le sue proiezioni
25- Per ogni film di fantascienza il titolo e l’incasso totale di tutte le sue proiezioni successive al
1/1/01
26- Per ogni film di fantascienza che non è mai stato proiettato prima del 1/1/01 il titolo e
l’incasso totale di tutte le sue proiezioni
27- Per ogni sala di Pisa, che nel mese di gennaio 2005 ha incassato più di 20000 €, il nome della
sala e l’incasso totale (sempre del mese di gennaio 2005)
28- I titoli dei film che non sono mai stati proiettati a Pisa
29- I titoli dei film che sono stati proiettati solo a Pisa
30- I titoli dei film dei quali non vi è mai stata una proiezione con incasso superiore a 500 €
31- I titoli dei film le cui proiezioni hanno sempre ottenuto un incasso superiore a 500 €
32- Il nome degli attori italiani che non hanno mai recitato in film di Fellini
33- Il titolo dei film di Fellini in cui non recitano attori italiani
34- Il titolo dei film senza attori
35- Gli attori che prima del 1960 hanno recitato solo nei film di Fellini
36- Gli attori che hanno recitato in film di Fellini solo prima del 1960

*/
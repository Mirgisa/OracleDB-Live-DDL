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


SELECT NOME FROM SALE WHERE CITTA = 'PISA';
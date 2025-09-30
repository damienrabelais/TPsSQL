CREATE TABLE Technicien(
 noTechnicien SERIAL,
 nom VARCHAR(50) NOT NULL,
 prenom VARCHAR(50) NOT NULL,
 noportable CHAR(10) NOT NULL,
 PRIMARY KEY(noTechnicien)
);

CREATE TABLE Intervention(
 noIntervention SERIAL,
 dateHeureIntervention TIMESTAMP NOT NULL,
 duree SMALLINT,
 noTechnicien INTEGER NOT NULL,
 PRIMARY KEY(noIntervention),
 FOREIGN KEY(noTechnicien) REFERENCES Technicien(noTechnicien)
);

CREATE TABLE Piece(
 reference CHAR(4),
 designation VARCHAR(50) NOT NULL,
 prixunitaire NUMERIC(5,2)  NOT NULL,
 PRIMARY KEY(reference)
);

CREATE TABLE necessiter(
 noIntervention INTEGER,
 reference CHAR(4),
 nombre INTEGER NOT NULL,
 PRIMARY KEY(noIntervention, reference),
 FOREIGN KEY(noIntervention) REFERENCES Intervention(noIntervention),
 FOREIGN KEY(reference) REFERENCES Piece(reference)
);

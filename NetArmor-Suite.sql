1.2.	Modifications sur la structure de la base de données, ajout de contraintes… 

1. Les  nom et prenom du technicien ne doivent pas dépasser 30 caractères. 
ALTER TABLE Technicien ALTER COLUMN nom TYPE varchar(30); 
ALTER TABLE Technicien ALTER COLUMN prenom TYPE varchar(30);

2. Le prix d’une pièce doit être > à 0. 
ALTER TABLE Piece ADD CONSTRAINT ck_prixpiece CHECK (prixunitaire>0);

1.3.	Alimentation de la base 'NetArmor'
-- //// INSERTIONS DANS TABLE Technicien ////
INSERT INTO Technicien (nom, prenom, noportable) VALUES ('Durant', 'Pierre', '0745102255');
INSERT INTO Technicien (nom, prenom, noportable) VALUES ('Martin', 'Jean', '0645101111');
INSERT INTO Technicien (nom, prenom, noportable) VALUES ('Dupont', 'Jacques', '0678561199');

-- //// INSERTIONS DANS TABLE Piece ////
INSERT INTO Piece(reference, designation, prixunitaire) VALUES ('P001', 'Souris USB', 10.2);
INSERT INTO Piece(reference, designation, prixunitaire) VALUES ('P002', 'Clavier USB', 30.99);
INSERT INTO Piece(reference, designation, prixunitaire) VALUES ('P078', 'Disque dur SATA 500go', 50.78);

-- //// PREMIERE INTERVENTION ////
INSERT INTO Intervention (dateHeureIntervention, duree, noTechnicien) VALUES ('2021-09-07 10:00:00-00', 3, 2) ;
-- notechnicien = 2 pour Jean Martin, mais peut-être différent, selon l'ordre ou les INSERT ont été faits

-- NECESSITER(noIntervention, reference, nombre)
INSERT INTO necessiter VALUES(1, 'P078', 1) ; 
INSERT INTO necessiter VALUES(1, 'P001', 1) ;
-- noIntervention généré ici = 1
-- Le point-virgule après chaque instruction (cas où l’on souhaite exécuter plusieurs instructions à la fois)

-- //// DEUXIEME INTERVENTION ////
INSERT INTO Intervention (dateHeureIntervention, duree, noTechnicien) VALUES ('2021-10-17 15:00:00-00',null, 1);
-- notechnicien = 1 pour Pierre Durant, mais peut-être différent, selon l'ordre ou les INSERT ont été faits
INSERT INTO necessiter VALUES(2, 'P078', 1)   
-- noIntervention généré ici = 2

1.4.	Nouvelles modifications sur la structure de la base de données…
•	Ajoutez la contrainte : la durée d’une intervention est forcément renseignée. Que se passe-t-il ?
ALTER TABLE intervention ALTER COLUMN duree SET NOT NULL;

Modification impossible, il existe une intervention avec une durée à « null ».

•	Ajoutez un champ 'année de naissance' (entier) dans la table Technicien. Que se passe-t-il ?
ALTER TABLE Technicien ADD anneenaissance integer ;
La modification est effective. Nota Bene : impossible d’ajouter la contrainte NOT NULL, les années de naissance sont à NULL pour les techniciens déjà enregistrés… 

1.5.	Ajout d’une nouvelle intervention
Le technicien Jean Martin a réalisé une intervention le 9/09/2021 à 11h00 d’une durée de 1h. Cette intervention a nécessité le remplacement d’une pièce, de référence P003. Procédez à l’insertion de cette nouvelle intervention.

-- //// TROISIEME INTERVENTION ////
INSERT INTO Intervention (dateHeureIntervention, duree, noTechnicien) VALUES ('2021-09-09 11:00:00-00', 1, 2) ;

-- Ici noIntervention généré=3 on écrira donc ce qui suit pour l’insertion dans necessiter : 

-- NECESSITER(noIntervention, reference, nombre)
INSERT INTO necessiter VALUES(3, 'P003', 1) ;
   
Résultat : 
ERROR: ERREUR:  une instruction insert ou update sur la table « necessiter » viole la contrainte de clé étrangère « necessiter_reference_fkey »
DETAIL:  La clé (reference)=(P003) n'est pas présente dans la table « piece ».

Notre technicien essaye d’utiliser une pièce non référencée dans la base de données : incohérence !  L’ajout est refusé par PostgreSQL (car les contraintes de clés étrangères ont bien été implémentées !)

-- 3.	Gestion de la section BTS SIO.
-- 3.1.	Implémentation d'un Modèle Relationnel
CREATE TABLE classe (
    noclasse integer NOT NULL,
    nomclasse varchar(60) NOT NULL,
    PRIMARY KEY (noclasse)
);

CREATE TABLE eleve (
    noeleve integer NOT NULL,
    nomeleve varchar(60) NOT NULL,
    prenomeleve varchar(60) NOT NULL,
    noclasse integer NOT NULL,
    PRIMARY KEY (noeleve),
    FOREIGN KEY(noclasse) REFERENCES classe(noclasse)
);

-- 3.2.	Alimentation de la base 'btssio
INSERT INTO classe VALUES (1, 'sio1');
INSERT INTO classe VALUES (2, 'sio1slam');
INSERT INTO classe VALUES (3, 'sio1sisr');
INSERT INTO classe VALUES (4, 'sio2slam');
INSERT INTO classe VALUES (5, 'sio2sisr');

INSERT INTO eleve VALUES (1, 'Durant', 'Pierre', 1);
INSERT INTO eleve VALUES (2, 'Dupont', 'Jean',1);
INSERT INTO eleve VALUES (3, 'Martin', 'Jacques',1);
INSERT INTO eleve VALUES (4, 'Tremblay', 'Céline',1);
INSERT INTO eleve VALUES (5, 'Debussy', 'Robert',1);
INSERT INTO eleve VALUES (6, 'Jaouen', 'Yann',4);
INSERT INTO eleve VALUES (7, 'Tanguy', 'Gwenaël',4);
INSERT INTO eleve VALUES (8, 'Dupont', 'Brieuc',4);
INSERT INTO eleve VALUES (9, 'Le Guen', 'Loic',5);
INSERT INTO eleve VALUES (10, 'Arnault', 'Robert',5);

-- 3.3.	Modifications sur la structure de la base de données, ajout de contraintes… 
-- 1.	Ajoutez un champ 'date de naissance' (type date) dans la table ELEVE. Que se passe-t-il ?
ALTER TABLE ELEVE ADD datenaissance date ;
-- Pour les élèves déjà inscrits le champ datenaissance est mis à NULL.

-- 2.	Ajoutez la contrainte : la date de naissance est forcément renseignée. Que se passe-t-il ?
ALTER TABLE ELEVE ALTER COLUMN datenaissance SET NOT NULL;
-- Impossible d'ajouter la contrainte NO NULL. Les années de naissance sont à NULL pour les élèves déjà enregistrés…

-- 3.	Martin, Jacques est démissionnaire, supprimez-le de la base. 
DELETE FROM ELEVE
WHERE nomeleve = 'Martin' and prenomeleve = 'Jacques'

-- 4.	Tremblay, Céline s'est mariée et porte désormais le nom de ‘Mesnil’. Procédez à la mise à jour nécessaire.
UPDATE ELEVE
SET nomeleve = 'Mesnil'
WHERE nomeleve = 'Tremblay' and prenomeleve='Céline';

-- 5.	Après le conseil de classe du semestre 1 les élèves  Pierre Durant et Robert Debussy sont affectés en sio1slam. Procédez aux mises à jour nécessaires.
UPDATE ELEVE
SET noclasse = 2
WHERE nomeleve = 'Durant' and prenomeleve='Pierre';

UPDATE ELEVE
SET noclasse = 2
WHERE nomeleve = 'Debussy' and prenomeleve='Robert';

-- 6.	Supprimez la classe sio1 (via son n°).
DELETE FROM CLASSE
WHERE noclasse = 1;
-- La suppression n’est pas possible. Violation de contrainte de clé étrangère. Il y toujours des élèves membres de cette classe.

-- 7.	Est-il possible de supprimer la table CLASSE (faites l’essai) ?
DROP TABLE CLASSE;
-- La suppression est impossible… idem question précédente. Il reste des élèves membres de classes… la suppression de la table CLASSE provoquerait des incohérences au niveau de la base.

-- 8.	Supprimez les élèves de la classe sio2sisr (via le nom de la classe).
DELETE FROM ELEVE WHERE noclasse IN (SELECT noclasse FROM CLASSE where nomclasse='sio2sisr');
-- Nota Bene : la jointure ‘classique’ n’est pas autorisée avec l’instruction DELETE, vous écrirez quelque chose de la forme : DELETE * FROM table_a_supprimer WHERE champ IN (SELECT champ FROM table_reference....)

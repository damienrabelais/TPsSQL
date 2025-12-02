-- 4.	Subventions européennes
-- 4.1.	Questions
-- 1. Afficher la capitale de l'Italie
SELECT Capitale
FROM PAYS
WHERE NomPays='Italie'

-- 2. Taux de croissance moyen pour l'ensemble des pays
SELECT AVG(TauxCroissanceMoyen)
FROM PAYS

-- 3. Lister les régions (noms) de France
SELECT NomRegion
FROM PAYS 
INNER JOIN REGION ON (REGION.NoPays=PAYS.NoPays)
WHERE NomPays='France'

-- 4. Nombre de régions dans la base, par pays
SELECT NomPays, COUNT(*)
FROM PAYS 
INNER JOIN REGION ON (REGION.NoPays=PAYS.NoPays)
GROUP BY NomPays

-- 5. Lister les noms de pays et taux de croissance des pays dont le taux de croissance en 2005 a été > à 2
SELECT NomPays, TauxDeCroissance
FROM PAYS
INNER JOIN RENSEIGNEMENT ON (RENSEIGNEMENT.NoPays=PAYS.NoPays)
WHERE  TauxDeCroissance > 2 AND Annee=2005

-- 6. Population moyenne par pays
SELECT NomPays, AVG(Population)
FROM PAYS
INNER JOIN RENSEIGNEMENT ON (RENSEIGNEMENT.NoPays=PAYS.NoPays)
GROUP BY NomPays

-- 7. Afficher le total des populations pour 2005
SELECT SUM(Population)
FROM RENSEIGNEMENT
WHERE Annee=2006
 
-- 8. Afficher le ou les secteurs (Type subvention) n'ayant pas reçu(s) de subventions en 2006
SELECT LibelleType
FROM TYPESUBVENTION
WHERE CodeType NOT IN (
    SELECT CodeType
    FROM ENVELOPPE
    WHERE Annee=2006
    )

-- 9. Montant total des subventions versées par région (Nom Région)
SELECT NomRegion, SUM(Montant)
FROM ENVELOPPE
INNER JOIN REGION ON (ENVELOPPE.NoRegion = REGION.NoRegion)
GROUP BY NomRegion

-- 10. Montant total des subventions versées par pays (NomPays)
SELECT NomPays, SUM(Montant)
FROM ENVELOPPE
INNER JOIN REGION ON (ENVELOPPE.NoRegion = REGION.NoRegion)
INNER JOIN PAYS ON (REGION.NoPays = PAYS.NoPays)
GROUP BY NomPays

-- 11. Pays n'ayant pas bénéficiés du tout de subventions (NomPays)
SELECT NomPays
FROM PAYS
WHERE NoPays NOT IN (
    SELECT NoPays
    FROM ENVELOPPE
    INNER JOIN REGION ON (ENVELOPPE.NoRegion = REGION.NoRegion)
    )

-- 12. Montant total des subventions versées par type de subventions (Libellés Type) (inclus les types pour lesquels il n'y a pas eut de subventions versées : Montant = 0) 
-- On peut répondre à cette question par une jointure externe, écrite comme suit : 

SELECT LibelleType, SUM(Montant)
FROM TYPESUBVENTION
LEFT OUTER JOIN ENVELOPPE ON (TYPESUBVENTION.CodeType = ENVELOPPE.CodeType)
GROUP BY TYPESUBVENTION.LibelleType


-- 13. Afficher le nom du pays et la population du pays ayant la plus grande population en 2006
SELECT NomPays, Population
FROM PAYS
INNER JOIN RENSEIGNEMENT ON (RENSEIGNEMENT.NoPays=PAYS.NoPays)
WHERE Annee=2006
AND Population = 
    (SELECT Max(Population)
    FROM RENSEIGNEMENT
    WHERE Annee=2006
    )

-- 14. Ajouter la région Pays de Galles (en Grande-Bretagne) dans la table REGION
INSERT INTO REGION VALUES (30, 'Pays de Galles', 2);

-- 15. Ajouter la région Poméranie (en Pologne) dans la table REGION
INSERT INTO PAYS VALUES (6, 'Pologne','Varsovie', 4);
INSERT INTO REGION VALUES (31, 'Poméranie', 6);

-- 16. En 2005 la population de la Pologne était de 37 millions, en 2006 de 37.5. Les taux de croissance étaient respectivement de 3 et 5. Faites les insertions nécessaires dans la base de sorte que ces informations soient stockées.
INSERT INTO RENSEIGNEMENT VALUES (6, 2005,3, 37);
INSERT INTO RENSEIGNEMENT VALUES (6, 2006, 5, 37.5); 

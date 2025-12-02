-- 1. Obtenir les départements (numéro, nom) ayant des employés.
SELECT nodepartement, nomdepartement
FROM Departement
WHERE nodepartement in 
(SELECT nodepartement 
FROM Employe);
-- Ou: 
SELECT Distinct d.nodepartement, nomdepartement
FROM Departement d
INNER JOIN Employe e ON (d.nodepartement = e.nodepartement)

-- 2. Donner la liste des employés (numéro, nom) non vendeurs.
SELECT noemploye, nomemploye
FROM Employe
WHERE fonction <> 'VENDEUR';

-- 3. Donner les employés embauchés entre le 01-01-1981 et le 30-06-81.
SELECT noemploye, nomemploye
FROM Employe
WHERE dateembauche between '1981-01-01' AND '1981-06-30';

-- 4. Donner le salaire le plus élevé et le salaire le plus bas par département et fonction. 
SELECT nomdepartement, fonction, max(salaire) as Maximum, min(salaire) as Minimum
FROM Employe e
INNER JOIN Departement d ON (e.nodepartement = d.nodepartement)
GROUP BY nomdepartement, fonction;

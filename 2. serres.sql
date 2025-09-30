1. Lister toutes les plantes, avec affichage de tous les champs.

SELECT *
FROM PLANTE

2. Lister les plantes (n°, nom) dont le nom commence par R

SELECT nomplante
FROM PLANTE
WHERE nomplante LIKE 'R%'

3. Lister les plantes (noms), sans doublon

SELECT DISTINCT nomplante
FROM PLANTE

4. Lister les plantes (noms) de la région n°6

SELECT nomplante
FROM PLANTE
WHERE noregion = 6;

5. Lister les régions (noms) par ordre alphabétique descendant

SELECT nomregion
FROM REGION
ORDER BY nomregion DESC;

6. Afficher le nombre de serres dans le jardin (= la base) (avec colonne 'renommée')

SELECT count(*) as "Nombre de serres"
FROM SERRE

7. Afficher le nombre de bananier dans le jardin (avec colonne 'renommée')

SELECT count(*) as "Nombre de bananier"
FROM PLANTE
WHERE nomplante='Bananier'

8. Afficher le nombre de plantes pour chaque région (n° région), dans la base

SELECT noregion, count(*) as "Nombre de plantes"
FROM PLANTE
GROUP BY noregion;

9. Lister les régions (n°) représentées par plus de 2 plantes dans le jardin (HAVING)

SELECT noregion, count(*) as "Nombre de plantes"
FROM PLANTE
GROUP BY noregion
HAVING count(*) > 2;


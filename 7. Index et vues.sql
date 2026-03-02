-- 2. Sur la table Commande, créez des index pour les attributs noVendeur et noClient. L'ajout de la contrainte UNIQUE sur ces attributs est-il possible ? 
CREATE INDEX noVendeur_idx ON commande(noVendeur);
CREATE INDEX noClient_idx ON commande(noClient);

-- 3. Créez la vue totauxvendeur regroupant les ventes totales (HT) par vendeur. 
CREATE VIEW totauxvendeur
AS
    SELECT c.noVendeur, nom, SUM(totalHT) AS "Total"
    FROM commande c
    INNER JOIN vendeur v ON (c.noVendeur=v.noVendeur)
    GROUP BY c.noVendeur, nom;

-- 4. Dans la vue totauxvendeur procédez à l'insertion des données suivantes : Durant, Pierre, n° vendeur = 100, Total de ses ventes : 2000.
INSERT INTO totauxvendeur VALUES (100,' Durant, Pierre', 2000);
 
-- 5. Créez la vue produitsalapiece regroupant les produits vendus à la pièce (descriptif='P'). 
CREATE VIEW produitsalapiece
    AS
    SELECT * FROM PRODUIT
    WHERE descriptif = 'P'

-- 6. Sur la vue produitsalapiece  vous passerez la requête d'insertion suivante : 
-- INSERT INTO produitsalapiece (reference, designation, quantite, descriptif, prixUnitaireHT, stock, poidsPiece) values (5000, 'PALETS BRETONS', 500, 'G', 18.00, 120, 0);
-- Cette requête s'est-elle exécutée correctement ? L'ajout a-t-il été fait dans la table Produit ? Si oui, est-ce normal ? Si non que fallait-il écrire pour que cet ajout ne puisse pas se faire ? (Nota Bene : examinez le contenu de la vue produitsalapiece ?)


L'insertion est OK alors que, logiquement, il ne devrait pas être possible d'ajouter un produit au poids ('G') dans une vue regroupant les produits vendus à la pièce ('P').
Pour interdire cette insertion il aurait fallu créer notre vue de la façon suivante : 
CREATE VIEW produitsalapieceC
    AS
    SELECT  * FROM PRODUIT
    WHERE descriptif = 'P'
    WITH CHECK OPTION;

-- L'insertion suivante : 
INSERT INTO produitsalapieceC (reference, designation, quantite, descriptif, prixUnitaireHT, stock, poidsPiece) values (5001, 'PALETS BRETONS', 500, 'G', 18.00, 120, 0);
.. provoque une erreur
 
-- 7. Créez la vue vendeursnomsvilles, sans vérification... 
Rappel : 
CREATE TABLE Vendeur
(
noVendeur integer,
nom varchar(35)  NOT NULL,
adresse varchar(40) NOT NULL,
codePostal char(5) NOT NULL,
ville varchar(30) NOT NULL,
telephone varchar(16),
PRIMARY KEY (noVendeur)
);


CREATE VIEW vendeursnomsvilles (nomvendeur, villevendeur)
AS
SELECT nom, ville from vendeur


-- 8. Procédez à l'insertion suivante (dans la vue précédente) : INSERT INTO vendeursnomsvilles(nomvendeur,villevendeur) VALUES ('Dupont, Jean', 'DIJON');
-- Que se passe-t-il ? A quelle condition cette insertion aurait-elle été possible ? 

L'insertion aurait été possible si les attributs non renseignés de la table Vendeur avaient été autorisés à prendre des valeurs NULL (non à NOT NULL). Là on a la sortie suivante : 
novendeur est lui aussi à NOT NULL … C'est la clé primaire. 

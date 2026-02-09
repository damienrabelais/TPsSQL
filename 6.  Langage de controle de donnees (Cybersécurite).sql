Nota Bene : Il est possible d'ouvrir plusieurs fenêtres SQL Shell en même temps, et de s’authentifier avec des utilisateurs différents sur chacune de ces fenêtres !

1. Créez un utilisateur paul (ayant le droit de créer une base de données).
CREATE USER paul WITH PASSWORD 'test' CREATEDB;

2. Connectez-vous en tant que paul, via SQL Shell, et créer une base de donnée dbeleves (instruction CREATE DATABASE nombase)
CREATE DATABASE dbeleves;

3. Connectez vous, en tant paul à cette base et créez la table eleve via l'instruction suivante : 
CREATE TABLE eleve (numero serial NOT NULL,nom character varying(50) NOT NULL,  prenom character varying(50), anneenaissance integer, CONSTRAINT eleve_pkey PRIMARY KEY (numero));

4. Passez l'instruction SELECT * from eleve. Est-elle fonctionnelle ? Pourquoi ? 
Oui, car paul est propriétaire de la base dbeleves (et donc de la table eleve).

5. Créez un role btssio (en tant que paul, puis en tant que postgresql : qu'observez-vous ?).
CREATE ROLE btssio;
 (impossible de créer un role, ou un utilisateur  avec un utilisateur autre que l'administrateur).

6. Créez 2 utilisateurs anne et antoine (sans droit particulier, mais avec mot de passe).
CREATE USER anne WITH PASSWORD 'test';
CREATE USER antoine WITH PASSWORD 'test';

7. Affectez anne et antoine au role btssio. 
GRANT btssio TO anne;
GRANT btssio TO antoine;

8. Connectez-vous en tant que anne, ou antoine et essayez de lister la table eleve. Que se passe-t-il ? 
 

9. Ecrivez la requête qui autorise tous les membres du role btssio à lister la table eleve. Vérifiez avec antoine, ou anne (il est possible d'ouvrir plusieurs SQL Shell en même temps) (L'instruction sera passée en tant que paul, propriétaire de la base dbeleves).

GRANT SELECT ON eleve TO btssio;

10. Insérez, en tant qu'antoine les élèves ci-après (insertions partielles, les identifiants seront générés automatiquement). Que se passe-t-il ? 
Dupont, François né en 1990.
Martin, Louis né en 1995.

INSERT INTO eleve(nom,prenom,anneenaissance) VALUES ('Dupont', 'François', 1990);
INSERT INTO eleve(nom,prenom,anneenaissance) VALUES ('Martin', 'Louis', 1995);
Insertion impossible.

11. Donnez la permission à antoine, seul, d'ajouter des données dans la table eleve (et repassez vos requêtes d'insertion, question ci-dessus)
(Nota Bene : pour pouvoir faire une insertion partielle – n° élève généré automatiquement par la séquence adéquate – il faudra donner à antoine la permission d’utiliser (USAGE) la séquence, voir documentation officielle pour attribuer cette permission   : http://www.postgresql.org/docs/9.0/static/sql-grant.html ).

GRANT INSERT ON eleve TO antoine;
- Insertions ‘totales’ possibles.

GRANT USAGE ON SEQUENCE eleve_numero_seq TO antoine;
- Insertions ‘partielles’ possibles.

12. Il n'est pas très correct que tous les membres de btssio connaissent l'année de naissance de tous les élèves et encore moins qu'ils aient accès en écriture à la table élève. Passez les requêtes pour que les insertions soient désormais impossibles à anne et antoine, et que seuls les nom et prénom des élèves soient visibles par les membres de btssio (avec quel utilisateur travaillerez-vous ?). Ecrivez les requêtes de test pour valider votre modification.

On écrira, connecté en tant que paul : 
REVOKE ALL ON eleve FROM btssio;
GRANT SELECT (nom, prenom) ON eleve TO btssio;

En tant qu'antoine, ou anne : 
SELECT * from eleve;  -- droit refusé
SELECT * from eleve;  -- droit refusé

13. Dans un accès de générosité paul donne les droit d'insérer dans la table eleve à antoine, et lui permets de transmettre ce droit à qui bon lui semble. Ecrire la requête correspondante et les requêtes de test avec les utilisateurs adéquats. anne devra au final pouvoir faire l'insertion de Durant, Marie née en 1996 avec un droit d'insertion transmis par antoine (Nota Bene : idem n°11, pour insertion partielle le droit d’usage de la séquence doit être transmis).

En tant que paul : 
GRANT INSERT ON eleve TO antoine WITH GRANT OPTION;

En tant qu'antoine :
GRANT INSERT ON eleve TO anne;

En tant qu'anne :
INSERT INTO eleve(nom,prenom,anneenaissance) VALUES ('Durant', 'Marie', 1996);

 

eleve_numero_seq est l'objet de type séquence, qui génère les identifiants élève (Serial). Antoine et anne n'ont aucun accès à ce dernier. paul devra donc donner accès à cette objet à antoine… qui transmettra ce droit à anne.

paul : GRANT USAGE ON eleve_numero_seq TO antoine WITH GRANT OPTION;
antoine : GRANT USAGE ON eleve_numero_seq TO anne;
anne : INSERT INTO eleve(nom,prenom,anneenaissance) VALUES ('Durant', 'Marie', 1996);

14. Pour terminer, donnez le droit administrateur (super utilisateur) à anne (vérifiez qu'elle peut désormais lister la totalité de la table eleve) (voir http://www.postgresql.org/docs/current/static/sql-alteruser.html) (que signifie, et qu'implique la phrase "ALTER USER is now an alias for ALTER ROLE")  Vérifiez que anne est maintenant en capacité de créer des utilisateurs… roles.. 

ALTER USER anne WITH SUPERUSER;
La notion de USER tends à s'effacer pour faire place à la notion de ROLE, plus générale, USER étant un cas particulier de ROLE (cf. cours).
Il faut être connecté postgres pour pouvoir passer cette commande ! 


Nota Bene : Si un superutilisateur choisit de lancer une commande GRANT ou REVOKE, la commande est exécutée comme si elle avait été lancée par le propriétaire de l’objet concerné (idem pour les affiliations aux rôles). Mais, cette possibilité n’est pas offerte aux administrateurs par tous les SGBDR !  
Aussi vous retiendrez que les attributions de droits à des objets devront être faites par leur seul propriétaire ! (règle à appliquer en TP, en DS …)

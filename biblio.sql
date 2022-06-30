-- Active: 1656329448116@@127.0.0.1@3306@maBiblio

-- ❓1. Charger la base biblio.

-- ❓2. Corriger les erreurs : expliquer les corrections que vous apportez.
    /*
        Dans table emprunteur où NL=12 j'ai mofier la DateEmp pour "2021-12-17" et DateRet pour "2021-09-02" car avant la date d'emprunt
        été avancé de celui de DateRet et qu'elles étaient trop éloigné l'un de l'autre.
        Et de celui NL=26 j'ai juste inversé les valeurs de DateEmp et DateRet.
    */  


-- ❓3. Combien y a-t-il de tuples dans la table résultat de la requête suivante juste après exécution du script de création des tables et des tuples (mettez la formule de calcul plutôt que le résultat).


-- ❓ 4. Combien y a-t-il d’attributs dans la table résultat de la requête précédente ?


-- ❓5. Quelle est la clé primaire de la table résultat de la requête précédente ?


-- ❓6. Quels sont les livres actuellement empruntés ?
SELECT titre FROM  oeuvres, livres, emprunteur WHERE dateRet IS NULL  AND(oeuvres.NO=livres.NO) AND  (emprunteur.NL=livres.NL) ;


-- ❓7. Quels sont les livres empruntés par Jeanette Lecoeur ? Vérifier dans la réponse qu’il n’y a pas d’homonymes.
SELECT titre FROM oeuvres, livres, emprunteur, adherents WHERE emprunteur.NA=adherents.NA AND livres.NL=emprunteur.NL  AND oeuvres.NO=livres.NO AND nom LIKE 'Lecoeur' AND prenom LIKE 'Jeanette' ;


-- ❓8. Quels sont tous les livres empruntés en septembre 2009.
SELECT titre FROM oeuvres, livres, emprunteur WHERE emprunteur.NA=adherents.NA AND livres.NL=emprunteur.NL  AND oeuvres.NO=livres.NO AND dateEmp LIKE "2021"


-- ❓9. Tous les adhérents qui ont emprunté un livre de Fedor Dostoievski.
SELECT nom, prenom FROM adherents WHERE NA=(SELECT NA from emprunteur WHERE NL=(SELECT NL FROM livres WHERE NO=(SELECT NO FROM oeuvres WHERE auteur="Fedor Dostoievski")));


-- ❓10. Un nouvel adhérent vient de s’inscrire : Olivier DUPOND, 76, quai de la Loire,75019 Paris, téléphone : 0102030405
INSERT INTO adherents (NA, nom	, prenom, adr	, tel ) VALUES ( NA,'Olivier','DUPOND','76 ai de la Loire, 75019 Paris','0102030405');
SELECT * FROM adherents;


-- ❓11. Martine CROZIER vient d’emprunter « Au coeur des ténèbres » que vous venez d’ajouter et « Le rouge et le noir » chez Hachette, livre n°23. Faire les mises à jour de la BD.
INSERT INTO emprunteur ( NL,  dateEmp, dureeMax,   dateRet, NA) VALUES
    (31, NOW(), 33, NULL, 7),
    (23, NOw(), 44, NULL, 7);
SELECT * FROM emprunteur;


-- ❓12. M. Cyril FREDERIC ramène les livres qu’il a empruntés. Faire la mise à jour de la BD.
UPDATE emprunteur SET dateRet=NOW() WHERE NA=(SELECT NA from adherents WHERE nom LIKE'FREDERIC' AND prenom LIKE 'Cyril' );


-- ❓13. M. Cyril FREDERIC essaye d’emprunter le livre n°23. Ecrire la requête. Que constatez-vous ?
SELECT  NL FROM emprunteur, adherents WHERE emprunteur.NA=adherents.NA AND nom LIKE 'FREDERIC';
⛑️INSERT INTO emprunteur ( NL,  dateEmp, dureeMax,   dateRet, NA) VALUES(
    23, NOW(), 55,  NULL, 28
);
    /*
        La requette n'est un échec car dans la question Num 11 ci dessus le livre n°23 a déjà été emprunter.
    */


-- ❓14. M. Cyril FREDERIC essaye d’emprunter le livre n°29. Écrire la requête. Que constatez-vous ?
INSERT INTO emprunteur ( NL,  dateEmp, dureeMax,   dateRet, NA) VALUES(
    29, NOW(), 66,  NULL, 28
);
    /*
       Le livre n°29 personne l'a emprunté alors la requête est réussi
    */


-- ❓15. Quels sont le ou les auteurs du titre « Voyage au bout de la nuit »
SELECT auteur FROM oeuvres WHERE titre="Voyage au bout de la nuit";


-- ❓16. Quels sont les ou les éditeurs du titre « Narcisse et Goldmund »
SELECT DISTINCT editeur FROM livres, oeuvres WHERE livres.NO=oeuvres.NO AND titre = "Narcisse et Goldmund ";


-- ❓17 Quels sont les adhérents actuellement en retard ?
SELECT DISTINCT nom, prenom FROM adherents, emprunteur WHERE DATEDIFF(dateRet , dateEmp)>dureeMax AND (adherents.NA=emprunteur.NA) ;
-- SELECT DISTINCT NA FROM emprunteur WHERE DATEDIFF(dateRet , dateEmp)>dureeMax;

-- ❓18. Quels sont les livres actuellement en retard ?
SELECT DISTINCT titre FROM oeuvres, livres, emprunteur WHERE DATEDIFF(dateRet , dateEmp)>dureeMax AND (oeuvres.NO=livres.NO) AND  (emprunteur.NL=livres.NL) ;

-- ❓19. Quels sont les adhérents en retard, avec le nombre de livres en retard et la moyenne du nombre de jours de retard.
SELECT nom, COUNT(emprunteur.NL) as nbreLivreRet, AVG(DATEDIFF(dateRet , dateEmp)) AS moyenneRet FROM adherents, oeuvres, livres, emprunteur WHERE oeuvres.NO=livres.NO AND livres.NL=emprunteur.NL AND emprunteur.NA=adherents.NA AND DATEDIFF(dateRet , dateEmp)>dureeMax GROUP BY nom ASC;


-- ❓20. Nombre de livres empruntés par auteur.
SELECT auteur, COUNT(emprunteur.NL) as nbreLivreEmp FROM oeuvres, livres, emprunteur WHERE oeuvres.NO=livres.NO AND livres.NL=emprunteur.NL GROUP BY auteur ASC;


-- ❓21. Nombre de livres empruntés par éditeur
SELECT editeur, COUNT(emprunteur.NL) as nbreLivreEmp FROM livres, emprunteur WHERE livres.NL=emprunteur.NL  GROUP BY editeur ASC;


-- ❓22. Durée moyenne des emprunts rendus. On commencera par afficher les durées des emprunts rendus.
SELECT NL, DATEDIFF(dateRet, dateEmp) AS dureeDeRetardEmp FROM emprunteur  WHERE dateRet IS NOT NULL;
SELECT AVG( DATEDIFF(dateRet, dateEmp) ) AS dureeMoyenneEmp FROM emprunteur WHERE dateRet IS NOT NULL;


-- ❓23. Durée moyenne des retards pour l’ensemble des emprunts.
SELECT AVG(  DATEDIFF(dateRet, dateEmp) ) AS dureeMoyenneEmp FROM emprunteur ;

-- ❓24. Durée moyenne des retards parmi les seuls retardataires
SELECT AVG(  DATEDIFF(dateRet, dateEmp) ) AS dureeMoyenneEmp FROM emprunteur WHERE DATEDIFF(dateRet , dateEmp)>dureeMax;
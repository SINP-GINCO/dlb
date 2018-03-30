UPDATE website.content SET value='Versement des données de biodiversité' WHERE name='homepage.title';

UPDATE website.content SET value='<div>
<p>Bienvenue sur la plateforme de versement de données de biodiversité permettant l’agrégation, la standardisation et le 
dépôt des données d’observations de biodiversité contribuant à l’Inventaire national du patrimoine naturel(INPN).</p>

<p>Cet espace s’adresse en priorité aux professionnels souhaitant procéder au versement de données brutes de biodiversité 
dans le cadre de l’article L411-1 A du Code l’environnement (Article 7 de la loi du 8 août 2016 pour la reconquête de la 
biodiversité).</p>

<p>Cette plateforme permet dans sa version actuelle
<ol>
  <li>de procéder au versement d’occurrences de taxons,</li>
  <li>de lister et trier les jeux de données ayant fait l’objet d’un dépôt légal</li>
  <li>de visualiser les données d’occurrences de taxons ayant fait l’objet d’un dépôt légal sur la plateforme, dans la 
limite de leur niveau de sensibilité définissant un degré de menace sur l’espèce,</li>
  <li>de consulter les certificats de dépôt d’une <a href="https://www.demarches-simplifiees.fr/commencer/projets-environnement-gouv-fr" target="_blank">télé-procédure </a> associée à une étude
d’évaluation préalable ou de suivi des impacts réalisées dans le cadre de l’élaboration de projet d’aménagement 
soumis à l’approbation de l’autorité administrative.</li>
</ol>
</p>
</div>
' WHERE name='homepage.intro';


UPDATE website.content SET value='Les outils du dépôt légal' WHERE name='presentation.title';
UPDATE website.content SET value='Le dépôt légal de données brutes de biodiversité s’inscrit dans une démarche partenariale regroupant différents acteurs proposant plusieurs outils interconnectés. 
Ceux-ci assurent les tâches indispensables du processus de dépôt légal : déclarer une étude, décrire les jeux, saisir et verser les données.' WHERE name='presentation.intro';

UPDATE website.content SET value='{"anchor":"Le portail Nature France","href":"http:\/\/www.naturefrance.fr","target":"_blank"}' WHERE name='homepage.link.1';
UPDATE website.content SET value='{"anchor":"Le dépôt légal de données brutes de biodiversité","href":"http:\/\/www.naturefrance.fr\/reglementation\/depot-legal-de-donnees-brutes-de-biodiversite","target":"_blank"}' WHERE name='homepage.link.4';
UPDATE website.content SET value='{"anchor":"FAQ","href":"http:\/\/www.naturefrance.fr\/reglementation\/depot-legal-de-donnees-brutes-de-biodiversite\/faq","target":"_blank"}' WHERE name='homepage.link.5';

UPDATE website.content SET value='{"anchor":"Plateforme de m\u00e9tadonn\u00e9es","href":"https:\/\/inpn.mnhn.fr\/mtd","target":"_blank"}' WHERE name='homepage.private.link.1';
UPDATE website.content SET value='{"anchor":"Standard de fichier Dépôt de données brutes de biodiversité V.1","href":"http:\/\/www.naturefrance.fr\/depot-legal-de-donnees\/description-de-la-tele-procedure","target":"_blank"}' WHERE name='homepage.private.link.2';
UPDATE website.content SET value='{"anchor":"Principes et cas d’usages pour le géo-référencement","href":"http://www.naturefrance.fr/sites/default/files/fichiers/ressources/pdf/sinp_principes_cas_usages_geo-referencement.pdf","target":"_blank"}' WHERE name='homepage.private.link.3';
UPDATE website.content SET value='{"anchor":"Principes et cas d’usages pour la structuration des jeux de données","href":"#","target":"_blank"}' WHERE name='homepage.private.link.4';

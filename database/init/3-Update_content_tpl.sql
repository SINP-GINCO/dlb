SET SEARCH_PATH = website;

DELETE FROM content;


INSERT INTO content ("name",value,description) VALUES
  ('homepage.title','@site.name@','Versement des données de biodiversité'),
  ('homepage.intro','<div>
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
','Texte d''introduction sur la page d''accueil'),
  ('homepage.image',NULL,'Image d''illustration sur la page d''accueil'),
  ('homepage.links.title','Plus d''informations','Titre du bloc de liens publics sur la page d''accueil'),
  ('homepage.link.1','{"anchor":"Pr\u00e9sentation du SINP","href":"http:\/\/www.naturefrance.fr","target":"_blank"}','Lien public sur page accueil'),
  ('homepage.link.2','{"anchor":"INPN - Inventaire National du Patrimoine Naturel","href":"https:\/\/inpn.mnhn.fr","target":"_blank"}','Lien public sur page accueil'),
  ('homepage.link.3','{"anchor":null,"href":null,"target":"_self"}','Lien public sur page accueil'),
  ('homepage.link.4','{"anchor":"Projet Dépôt légal de données de biodiversité","href":"http://www.naturefrance.fr/depot-legal-de-donnees/description-de-la-tele-procedure","target":"_blank"}','Lien public sur page accueil'),
  ('homepage.link.5','{"anchor":"FAQ de la télé-procédure","href":"http://www.naturefrance.fr/depot-legal-de-donnees/faq","target":"_blank"}','Lien public sur page accueil'),
  ('homepage.doc.1','{"anchor":null,"file":""}','Document public sur page accueil'),
  ('homepage.doc.2','{"anchor":null,"file":""}','Document public sur page accueil'),
  ('homepage.doc.3','{"anchor":null,"file":""}','Document public sur page accueil'),
  ('homepage.doc.4','{"anchor":null,"file":""}','Document public sur page accueil'),
  ('homepage.doc.5','{"anchor":null,"file":""}','Document public sur page accueil'),
  ('homepage.private.links.title','Informations Pétitionnaires','Titre du bloc de liens privés sur la page d''accueil'),
  ('homepage.private.link.1','{"anchor":"Plateforme de m\u00e9tadonn\u00e9es","href":"https:\/\/inpn.mnhn.fr\/mtd","target":"_blank"}','Lien privé sur page accueil'),
  ('homepage.private.link.2','{"anchor":"Standard de fichier Dépôt de données brutes de biodiversité V.1","href":"http:\/\/www.naturefrance.fr\/depot-legal-de-donnees\/description-de-la-tele-procedure","target":"_blank"}','Lien privé sur page accueil'),
  ('homepage.private.link.3','{"anchor":"Principes et cas d’usages pour le géo-référencement","href":"http://www.naturefrance.fr/sites/default/files/fichiers/ressources/pdf/sinp_principes_cas_usages_geo-referencement.pdf","target":"_blank"}','Lien privé sur page accueil'),
  ('homepage.private.link.4','{"anchor":"Principes et cas d’usages pour la structuration des jeux de données","href":"#","target":"_blank"}','Lien privé sur page accueil'),
  ('homepage.private.link.5','{"anchor":null,"href":null,"target":"_self"}','Lien privé sur page accueil'),
  ('homepage.private.doc.1','{"anchor":null,"file":""}','document privé sur page accueil'),
  ('homepage.private.doc.2','{"anchor":null,"file":""}','document privé sur page accueil'),
  ('homepage.private.doc.3','{"anchor":null,"file":""}','document privé sur page accueil'),
  ('homepage.private.doc.4','{"anchor":null,"file":""}','document privé sur page accueil'),
  ('homepage.private.doc.5','{"anchor":null,"file":""}','document privé sur page accueil'),
  ('presentation.title','Les outils du dépôt légal','Titre de la page de presentation'),
  ('presentation.abstract','<div>
<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce malesuada tincidunt nisi. Fusce orci mauris, pharetra ac ipsum ornare, interdum pretium velit. Ut sed diam ut felis bibendum lacinia. Donec id pulvinar massa. Integer malesuada, lorem vel sodales tincidunt, felis nunc accumsan magna, nec commodo justo purus sit amet tellus. Vivamus hendrerit varius massa eu varius. Duis sit amet quam et tellus maximus lacinia. Nulla turpis velit, dapibus nec sagittis sit amet, luctus vulputate augue. Etiam a tortor accumsan quam placerat facilisis nec in tellus. Ut id quam mi. Nunc dignissim nulla vel ultrices sollicitudin. Vestibulum molestie ac diam vitae vulputate. Sed pretium erat id tortor iaculis, ac rutrum dui facilisis. Quisque mauris mi, ultrices in aliquet at, tristique non risus.</p>
</div>','Résumé du texte d''introduction de la page de présentation'),
  ('presentation.intro','Le dépôt légal de données brutes de biodiversité s’inscrit dans une démarche partenariale regroupant différents acteurs proposant plusieurs outils interconnectés. 
Ceux-ci assurent les tâches indispensables du processus de dépôt légal : déclarer une étude, décrire les jeux, saisir et verser les données.','Texte d''introduction sur la page de presentation'),
  ('presentation.image',NULL,'Image d''illustration sur la page de presentation'),
  ('presentation.links.title','Sites et documents de référence','Titre du bloc de liens publics sur la page de presentation'),
  ('presentation.link.1','{"anchor":"Le portail Nature France","href":"http:\/\/www.naturefrance.fr","target":"_blank"}','Lien public sur page de presentation'),
  ('presentation.link.2','{"anchor":null,"href":null,"target":"_self"}','Lien public sur page de presentation'),
  ('presentation.link.3','{"anchor":null,"href":null,"target":"_self"}','Lien public sur page de presentation'),
  ('presentation.link.4','{"anchor":"Le dépôt légal de données brutes de biodiversité","href":"http:\/\/www.naturefrance.fr\/reglementation\/depot-legal-de-donnees-brutes-de-biodiversite","target":"_blank"}','Lien public sur page de presentation'),
  ('presentation.link.5','{"anchor":"FAQ","href":"http:\/\/www.naturefrance.fr\/reglementation\/depot-legal-de-donnees-brutes-de-biodiversite\/faq","target":"_blank"}','Lien public sur page de presentation'),
  ('presentation.doc.1','{"anchor":null,"file":""}','Document public sur page de presentation'),
  ('presentation.doc.2','{"anchor":null,"file":""}','Document public sur page de presentation'),
  ('presentation.doc.3','{"anchor":null,"file":""}','Document public sur page de presentation'),
  ('presentation.doc.4','{"anchor":null,"file":""}','Document public sur page de presentation'),
  ('presentation.doc.5','{"anchor":null,"file":""}','Document public sur page de presentation');



UPDATE website.content SET value='<div>
<p>Bienvenue sur la plateforme de dépôt légal de données de biodiversité, plateforme thématique du <a href="http://www.naturefrance.fr/sinp/presentation-du-sinp">
Système d’Information Nature et Paysage (SINP)</a> permettant l’agrégation, la standardisation et le versement des données d’observations de biodiversité dans 
l’<a href="https://inpn.mnhn.fr/accueil/index">Inventaire national du patrimoine naturel(INPN)</a>.
Elle s’adresse aux professionnels souhaitant procéder au versement de données brutes de biodiversité (uniquement occurrences de taxons) 
dans le cadre de l’article L411-1 A du Code l’environnement (Article 7 de la loi du 8 août 2016 pour la reconquête de la biodiversité).</p>

<p>Cette plateforme permet de visualiser les données d’occurrences de taxons alimentant les études d’évaluation préalable ou de suivi des impacts réalisées dans le cadre de 
l’élaboration de projet d’aménagement soumis à l’approbation de l’autorité administrative.</p>
<p>Les visiteurs ont accès à l’ensemble des données associées à une <a href="https://tps-dev.apientreprise.fr/commencer/depot-etudes-d-impact-et-biodiversite">télé-procédure</a>
 et ayant fait l’objet d’un dépôt légal sur la plateforme, dans la limite de leur niveau de sensibilité définissant un degré de menace sur l’espèce.</p>
</div>
' WHERE name='homepage.intro';

UPDATE website.content SET value='IMG_Accueil-alt-opt.png' WHERE name='homepage.image';
UPDATE website.content SET value='Présentation de la télé-procédure' WHERE name='presentation.title';
UPDATE website.content SET value='{"anchor":"Projet Dépôt légal de données de biodiversité","href":"http://www.naturefrance.fr/depot-legal-de-donnees/description-de-la-tele-procedure","target":"_blank"}' WHERE name='homepage.link.4';
UPDATE website.content SET value='{"anchor":"FAQ de la télé-procédure","href":"http://www.naturefrance.fr/depot-legal-de-donnees/faq","target":"_blank"}' WHERE name='homepage.link.5';

UPDATE website.content SET value='Informations Pétitionnaires' WHERE name='homepage.private.links.title';
UPDATE website.content SET value='{"anchor":"Standard du fichier de données brutes","href":"http://www.naturefrance.fr/depot-legal-de-donnees/description-de-la-tele-procedure","target":"_blank"}' WHERE name='homepage.private.link.2';
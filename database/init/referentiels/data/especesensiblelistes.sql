CREATE TABLE referentiels.especesensiblelistes
(
  short_citation character varying(500),
  cd_insee_reg character varying(500),
  date_liste integer,
  full_citation character varying(500),
  url character varying(500),
  cd_doc integer,
  cd_sl integer,
  CONSTRAINT pk_cd_doc PRIMARY KEY (cd_doc)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE referentiels.especesensiblelistes
  OWNER TO admin;
 
GRANT ALL ON TABLE referentiels.especesensiblelistes TO admin;
GRANT ALL ON TABLE referentiels.especesensiblelistes TO ogam;
GRANT ALL ON TABLE referentiels.especesensiblelistes TO postgres;
  
INSERT INTO referentiels.especesensiblelistes VALUES ('Anonyme (2015)', '24', 2015, 'Anonyme. 2015. Référentiel régional de données sensibles SINP Centre-Val de Loire Volet "Occurrence de taxons" (validé; le 25 juin 2015 en CSRPN). 5 pp.', 'http://www.centre.developpement-durable.gouv.fr/IMG/pdf/Notice_referentiel_donnees_sensibles_region_Centre-Val_de_Loire_cle03e5ed.pdf', 189968, 13);
INSERT INTO referentiels.especesensiblelistes VALUES ('Observatoire <i>et al.</i> (2019)', '53', 2019, 'Observatoire de l''environnement en Bretagne. 2019. <em>Référentiel régional des données sensibles en Bretagne</em>. 27 pp.', NULL, 306929, 18);
INSERT INTO referentiels.especesensiblelistes VALUES ('Touroult (2016)', 'R', 2016, 'Touroult, J. 2016. SINP. Liste nationale des taxons potentiellement sensibles et des conditions de sensibilité/non sensibilité de la donnée, Version 2.', NULL, 142869, 9);
INSERT INTO referentiels.especesensiblelistes VALUES ('Anonyme (2016)', '26', 2016, 'Anonyme. 2016. <em>Liste régionale des espèces potentiellement sensibles pour la diffusion des données. Bourgogne</em>. fichier Excel.', NULL, 161372, 12);
INSERT INTO referentiels.especesensiblelistes VALUES ('Anonyme (2018)', '91', 2019, 'Anonyme. 2018. <em>Référentiel des données sensibles du Languedoc-Roussillon. Version 2.0 validée le 03/12/2018 par le CSRPN Languedoc-Roussillon</em>. Fichier Excel.', NULL, 280289, 16);
INSERT INTO referentiels.especesensiblelistes VALUES ('Nevé <i>et al.</i> (2019)', '52', 2019, 'Le Nevé, A., Dortel, F., Magnanon, S., Marchadour, B., Quinton, D., Herbrecht, F., Mouren V., Dacharry, A. &amp; Normand, F. 2019. <em>Plateforme des données naturalistes des Pays de la Loire - Données sensibles&nbsp;: liste des espèces de faune et de flore - version 1.0</em>. DREAL Pays de la Loire, Nantes. 26 pp. + annexes.', NULL, 302515, 17);
INSERT INTO referentiels.especesensiblelistes VALUES ('Anonyme (2019)', 'R75', 2019, 'Anonyme. 2019. <em>Liste des espèces et des données sensibles faune de Nouvelle-Aquitaine</em>. Observatoire Aquitain de la Faune Sauvage. 19 pp.', NULL, 308609, 19);
INSERT INTO referentiels.especesensiblelistes VALUES ('Anonyme (2020)', 'R44', 2020, 'Anonyme. 2020. <em>Liste des données sensibles de l''inventaire du patrimoine naturel du Grand-Est.</em> Fichier excel.', NULL, 324029, 20);
INSERT INTO referentiels.especesensiblelistes VALUES ('Anonyme (2016)', '73', 2016, 'Anonyme. 2016. <em>Référentiel des espèces sensibles de Midi-Pyrénées</em>. Observatoire de la biodiversité de Midi-Pyrénées. Archive Zip.', 'http://ob-mp.fr/sites/default/files/esp_sensibles_SINP_MP.pdf', 236853, 14);
INSERT INTO referentiels.especesensiblelistes VALUES ('Happe (2015)', '83', 2015, 'Happe, D. 2015. Liste régionale des espèces potentiellement sensibles pour la diffusion des données. Auvergne.<br>', NULL, 124583, 8);
INSERT INTO referentiels.especesensiblelistes VALUES ('Caze & Leblond (2016)', '72', 2016, 'Caze G. & Leblond N. 2016. <em>Liste des especes sensibles de la flore vasculaire en Aquitaine dans le cadre du Systeme d Information sur la Nature et les Paysages (SINP), version 1.0</em>. Conservatoire Botanique National Sud-Atlantique.', NULL, 158568, 10);
INSERT INTO referentiels.especesensiblelistes VALUES ('Anonyme (2019)', '4', 2019, 'Anonyme. 2019. <em>Référentiel de données sensibles du Système d’information sur la nature et les paysages de La Réunion (version 1.3.0). Rapport pour le SINP 974</em>. 13 pp. + 5 annexes.', 'http://www.naturefrance.fr/sites/default/files/fichiers/la_reunion/documents/pages/referentiel_de_sensibilite/ref_donnees_sensibles_sinp974_v1.3.0_export_web.zip', 273629, 15);


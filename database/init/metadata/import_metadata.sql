-- script de peuplement de metadata ou metadata_work
/*==============================================================*/
/*	Metamodel initialization - populate script
	Reads and copies data from CSV files to metadata
	or metadata_work schema, which are generated from
	metadata.ods
	To update data, modify the metadata.ods file first
	then generate the CSV files, and run this script		*/
/*==============================================================*/

SET client_encoding='UTF8';
SET search_path TO metadata, public;

BEGIN;
SET CONSTRAINTS ALL DEFERRED;

--
-- Remove old data
--
delete from translation;
delete from table_tree;
delete from event_listener;

delete from file_field;
delete from table_field;
delete from form_field;
delete from field_mapping;
delete from dataset_fields;
delete from model_tables;
delete from dataset_files;

delete from group_mode;
delete from checks_per_provider;
delete from checks;
delete from model_datasets;
delete from dataset_forms;

delete from form_format;
delete from file_format;
delete from table_format;

delete from field;
delete from format;
delete from dynamode;
delete from mode_tree;
delete from mode;
delete from range;
delete from data;
delete from unit;
delete from model;
delete from standard;
delete from dataset;
delete from table_schema;


-- INSERTION IN TABLE unit
INSERT INTO unit VALUES ('Integer','INTEGER',NULL,'entier',NULL);
INSERT INTO unit VALUES ('Decimal','NUMERIC',NULL,'flotant',NULL);
INSERT INTO unit VALUES ('CharacterString','STRING',NULL,'texte','Lors d''une recherche on regardera l''appartenance du motif recherché aux valeurs du champ.');
INSERT INTO unit VALUES ('IDString','STRING','ID','identifiant sous forme de texte','Les recherches d''un motif pour un champ de ce type seront strictes (exactes).');
INSERT INTO unit VALUES ('Date','DATE',NULL,'date',NULL);
INSERT INTO unit VALUES ('DateTime','DATE',NULL,'date heure',NULL);
INSERT INTO unit VALUES ('Time','TIME','Time','heure',NULL);
INSERT INTO unit VALUES ('BOOLEAN','BOOLEAN',NULL,'booléen',NULL);
INSERT INTO unit VALUES ('GEOM','GEOM',NULL,'Géométrie d''une observation','Géométrie d''une observation');
INSERT INTO unit VALUES ('PROVIDER_ID','CODE','DYNAMIC','Fournisseur de données','Fournisseur de données');
INSERT INTO unit VALUES ('StatutSourceValue','CODE','DYNAMIC','Statut de la source','Statut de la source');
INSERT INTO unit VALUES ('DSPubliqueValue','CODE','DYNAMIC','DS de la DEE publique ou privée','DS de la DEE publique ou privée');
INSERT INTO unit VALUES ('StatutObservationValue','CODE','DYNAMIC','Statut de l''observation','Statut de l''observation');
INSERT INTO unit VALUES ('TaxRefValue','CODE','TAXREF','Code cd_nom du taxon','Code cd_nom du taxon');
INSERT INTO unit VALUES ('ObjetDenombrementValue','CODE','DYNAMIC','Objet du dénombrement','Objet du dénombrement');
INSERT INTO unit VALUES ('TypeDenombrementValue','CODE','DYNAMIC','Méthode de dénombrement','Méthode de dénombrement');
INSERT INTO unit VALUES ('CodeHabitatValue','ARRAY','DYNAMIC','[Liste] Code de l''habitat du taxon','Code de l''habitat du taxon');
INSERT INTO unit VALUES ('CodeRefHabitatValue','ARRAY','DYNAMIC','[Liste] Référentiel identifiant l''habitat','Référentiel identifiant l''habitat');
INSERT INTO unit VALUES ('NatureObjetGeoValue','CODE','DYNAMIC','Nature de l’objet géographique ','Nature de l’objet géographique ');
INSERT INTO unit VALUES ('CodeMailleValue','ARRAY','DYNAMIC','[Liste] Maille INPN 10*10 kms','Maille INPN 10*10 kms');
INSERT INTO unit VALUES ('CodeCommuneValue','ARRAY','DYNAMIC','[Liste] Code de la commune','Code de la commune');
INSERT INTO unit VALUES ('NomCommuneValue','ARRAY','STRING','[Liste] Nom de la commune','Nom de la commune');
INSERT INTO unit VALUES ('CodeENValue','ARRAY','DYNAMIC','[Liste] Code de l''espace naturel','Code de l''espace naturel');
INSERT INTO unit VALUES ('TypeENValue','ARRAY','DYNAMIC','[Liste] Type d''espace naturel oude zonage','Type d''espace naturel oude zonage');
INSERT INTO unit VALUES ('CodeDepartementValue','ARRAY','DYNAMIC','[Liste] Code INSEE du département','Code INSEE du département');
INSERT INTO unit VALUES ('CodeHabRefValue','ARRAY','DYNAMIC','[Liste] Code HABREF de l''habitat','Code HABREF de l''habitat');
INSERT INTO unit VALUES ('IDCNPValue','CODE','DYNAMIC','Code dispositif de collecte','Code dispositif de collecte');
INSERT INTO unit VALUES ('TypeInfoGeoValue','CODE','DYNAMIC','Type d''information géographique','Type d''information géographique');
INSERT INTO unit VALUES ('VersionMasseDEauValue','CODE','DYNAMIC','Version du référentiel Masse d''Eau','Version du référentiel Masse d''Eau');
INSERT INTO unit VALUES ('NiveauPrecisionValue','CODE','DYNAMIC','Niveau maximal de diffusion','Niveau maximal de diffusion');
INSERT INTO unit VALUES ('DEEFloutageValue','CODE','DYNAMIC','Floutage transformation DEE','Floutage transformation DEE');
INSERT INTO unit VALUES ('SensibleValue','CODE','DYNAMIC','Observation sensible','Observation sensible');
INSERT INTO unit VALUES ('SensibiliteValue','CODE','DYNAMIC','Degré de sensibilité','Degré de sensibilité');
INSERT INTO unit VALUES ('TypeRegroupementValue','CODE','DYNAMIC','Type de regroupement','Type de regroupement');
INSERT INTO unit VALUES ('OccurrenceNaturalisteValue','CODE','DYNAMIC','Naturalité de l''occurrence','Naturalité de l''occurrence');
INSERT INTO unit VALUES ('OccurrenceSexeValue','CODE','DYNAMIC','Sexe','Sexe');
INSERT INTO unit VALUES ('OccurrenceStadeDeVieValue','CODE','DYNAMIC','Stade de développement','Stade de développement');
INSERT INTO unit VALUES ('OccurrenceStatutBiologiqueValue','CODE','DYNAMIC','Comportement','Comportement');
INSERT INTO unit VALUES ('PreuveExistanteValue','CODE','DYNAMIC','Preuve de l''existance','Preuve de l''existance');
INSERT INTO unit VALUES ('ObservationMethodeValue','CODE','DYNAMIC','Méthode d''observation','Méthode d''observation');
INSERT INTO unit VALUES ('OccurrenceEtatBiologiqueValue','CODE','DYNAMIC','Code de l''état biologique','Code de l''état biologique');
INSERT INTO unit VALUES ('OccurrenceStatutBiogeographiqueValue','CODE','DYNAMIC','Code de l''état biogéographique','Code de l''état biogéographique');
INSERT INTO unit VALUES ('SensiManuelleValue','CODE','DYNAMIC','Mode de calcul de la sensibilité','Mode de calcul de la sensibilité');
INSERT INTO unit VALUES ('SensiAlerteValue','CODE','DYNAMIC','Alerte calcul sensibilité','Alerte calcul sensibilité');
INSERT INTO unit VALUES ('CodeMailleCalculeValue','ARRAY','DYNAMIC','[Liste] Code de la maille calculé','Code de la maille calculé');
INSERT INTO unit VALUES ('CodeCommuneCalculeValue','ARRAY','DYNAMIC','[Liste] Code de la commune calculé','Code de la commune calculé');
INSERT INTO unit VALUES ('NomCommuneCalculeValue','ARRAY','DYNAMIC','[Liste] Nom de la commune calculé','Nom de la commune calculé');
INSERT INTO unit VALUES ('CodeDepartementCalculeValue','ARRAY','DYNAMIC','[Liste] Code du département calculé','Code du département calculé');
INSERT INTO unit VALUES ('TypeAttributValue','CODE','DYNAMIC','Type de l''attribut additionnel','Type de l''attribut additionnel (quantitatif ou qualitatif)');
INSERT INTO unit VALUES ('CodeMasseEauValue','ARRAY','STRING','[Liste] Code de la masse d''eau','Code de la masse d''eau');
INSERT INTO unit VALUES ('TaxoStatutValue','CODE','DYNAMIC','[Liste] Statut du taxon pour la migration TAXREF','Statut du taxon pour la migration TAXREF');
INSERT INTO unit VALUES ('TaxoModifValue','CODE','DYNAMIC','[Liste] Modification effectuée lors de la migration TAXREF','Modification effectuée sur le taxon lors de la migration TAXREF');
INSERT INTO unit VALUES ('TaxoAlerteValue','CODE','DYNAMIC','[Liste] Taxon en alerte ou non pour la migration TAXREF','Taxon en alerte ou non pour la migration TAXREF');
INSERT INTO unit VALUES ('USER_LOGIN','STRING','DYNAMIC','Utilisateur','Utilisateur');

-- INSERTION IN TABLE data
INSERT INTO data VALUES ('PROVIDER_ID','PROVIDER_ID','Organisme du compte GINCO','Organisme du compte utilisateur GINCO qui a importé la donnée dans GINCO',NULL,true);
INSERT INTO data VALUES ('SUBMISSION_ID','Integer','Identifiant de la soumission','Identifiant de la soumission',NULL,true);
INSERT INTO data VALUES ('OGAM_ID_table_observation','IDString','Clé primaire table observation','Clé primaire table observation',NULL,true);
INSERT INTO data VALUES ('codecommune','CodeCommuneValue','codeCommune','Code de la/les commune(s) où a été effectuée l’observation suivant le référentiel INSEE en vigueur. ',NULL,true);
INSERT INTO data VALUES ('nomcommune','NomCommuneValue','nomCommune','Libellé de la/les commune(s) où a été effectuée l’observation suivant le référentiel INSEE en vigueur.',NULL,true);
INSERT INTO data VALUES ('anneerefcommune','Integer','anneeRefCommune','Année de production du référentiel INSEE, qui sert à déterminer quel est le référentiel en vigueur pour le code et le nom de la commune.',NULL,true);
INSERT INTO data VALUES ('typeinfogeocommune','TypeInfoGeoValue','typeInfoGeoCommune','Indique le type d''information géographique suivant la nomenclature TypeInfoGeoValue.',NULL,true);
INSERT INTO data VALUES ('denombrementmin','Integer','denombrementMin','Nombre minimum d''individus du taxon composant l''observation.',NULL,true);
INSERT INTO data VALUES ('denombrementmax','Integer','denombrementMax','Nombre maximum d''individus du taxon composant l''observation.',NULL,true);
INSERT INTO data VALUES ('objetdenombrement','ObjetDenombrementValue','objetDenombrement','Objet sur lequel porte le dénombrement.',NULL,true);
INSERT INTO data VALUES ('typedenombrement','TypeDenombrementValue','typeDenombrement','Méthode utilisée pour le dénombrement (Inspire).',NULL,true);
INSERT INTO data VALUES ('codedepartement','CodeDepartementValue','codeDepartement','Code INSEE en vigueur suivant l''année du référentiel INSEE des départements, auquel l''information est rattachée.',NULL,true);
INSERT INTO data VALUES ('anneerefdepartement','Integer','anneeRefDepartement','Année du référentiel INSEE utilisé.',NULL,true);
INSERT INTO data VALUES ('typeinfogeodepartement','TypeInfoGeoValue','typeInfoGeoDepartement','Indique le type d''information géographique suivant la nomenclature TypeInfoGeoValue.',NULL,true);
INSERT INTO data VALUES ('typeen','TypeENValue','typeEN','Indique le type d’espace naturel protégé, ou de zonage (Natura 2000, Znieff1, Znieff2).',NULL,true);
INSERT INTO data VALUES ('codeen','CodeENValue','codeEN','Code de l’espace naturel sur lequel a été faite l’observation, en fonction du type d''espace naturel.',NULL,true);
INSERT INTO data VALUES ('versionen','Date','versionEN','Version du référentiel consulté respectant la norme ISO 8601, sous la forme YYYY-MM-dd (année-mois-jour), YYYY-MM (année-mois), ou YYYY (année).',NULL,true);
INSERT INTO data VALUES ('typeinfogeoen','TypeInfoGeoValue','typeInfoGeoEN','Indique le type d''information géographique suivant la nomenclature TypeInfoGeoValue.',NULL,true);
INSERT INTO data VALUES ('refhabitat','CodeRefHabitatValue','refHabitat','RefHabitat correspond au référentiel utilisé pour identifier l''habitat de l''observation. Il est codé selon les acronymes utilisés sur le site de l''INPN mettant à disposition en téléchargement les référentiels "habitats" et "typologies".',NULL,true);
INSERT INTO data VALUES ('codehabitat','CodeHabitatValue','codeHabitat','Code métier de l''habitat où le taxon de l''observation a été identifié. Le référentiel Habitat est indiqué dans le champ « RefHabitat ». Il peut être trouvé dans la colonne "LB_CODE" d''HABREF.',NULL,true);
INSERT INTO data VALUES ('versionrefhabitat','CharacterString','versionRefHabitat','Version du référentiel utilisé (suivant la norme ISO 8601, sous la forme YYYY-MM-dd, YYYY-MM, ou YYYY).',NULL,false);
INSERT INTO data VALUES ('codehabref','CodeHabRefValue','codeHabRef','Code HABREF de l''habitat où le taxon de l''observation a été identifié. Il peut être trouvé dans la colonne "CD_HAB" d''HabRef.',NULL,true);
INSERT INTO data VALUES ('codemaille','CodeMailleValue','codeMaille','Code de la cellule de la grille de référence nationale 10kmx10km dans laquelle se situe l’observation.',NULL,true);
INSERT INTO data VALUES ('versionrefmaille','CharacterString','versionRefMaille','Version du référentiel des mailles utilisé.',NULL,true);
INSERT INTO data VALUES ('nomrefmaille','CharacterString','nomRefMaille','Nom de la couche de maille utilisée : Concaténation des éléments des colonnes "couche" et "territoire" de la page http://inpn.mnhn.fr/telechargement/cartes-et-information-geographique/ref.',NULL,true);
INSERT INTO data VALUES ('typeinfogeomaille','TypeInfoGeoValue','typeInfoGeoMaille','Indique le type d''information géographique suivant la nomenclature TypeInfoGeoValue.',NULL,true);
INSERT INTO data VALUES ('codeme','CodeMasseEauValue','codeME','Code de la ou les masse(s) d''eau à la (aux)quelle(s) l''observation a été rattachée.',NULL,true);
INSERT INTO data VALUES ('versionme','VersionMasseDEauValue','versionME','Version du référentiel masse d''eau utilisé et prélevé sur le site du SANDRE, telle que décrite sur le site du SANDRE.',NULL,true);
INSERT INTO data VALUES ('dateme','Date','dateME','Date de consultation ou de prélèvement du référentiel sur le site du SANDRE.',NULL,true);
INSERT INTO data VALUES ('typeinfogeome','TypeInfoGeoValue','typeInfoGeoME','Indique le type d''information géographique suivant la nomenclature TypeInfoGeoValue.',NULL,true);
INSERT INTO data VALUES ('geometrie','GEOM','geometrie','La géométrie de la localisationl (au format WKT)',NULL,true);
INSERT INTO data VALUES ('natureobjetgeo','NatureObjetGeoValue','natureObjetGeo','Nature de la localisation transmise ',NULL,true);
INSERT INTO data VALUES ('precisiongeometrie','Integer','precisionGeometrie','Estimation en mètres d’une zone tampon autour de l''objet géographique. Cette précision peut inclure la précision du moyen technique d’acquisition des coordonnées (GPS,…) et/ou du protocole naturaliste.',NULL,true);
INSERT INTO data VALUES ('observateurnomorganisme','CharacterString','observateurNomOrganisme','Organisme(s) de la ou des personnes ayant réalisé l''observation.',NULL,true);
INSERT INTO data VALUES ('observateuridentite','CharacterString','observateurIdentite','Nom(s), prénom de la ou des personnes ayant réalisé l''observation.',NULL,true);
INSERT INTO data VALUES ('observateurmail','CharacterString','observateurMail','Mail(s) de la ou des personnes ayant réalisé l''observation.',NULL,true);
INSERT INTO data VALUES ('determinateurnomorganisme','CharacterString','determinateurNomOrganisme','Organisme de la ou les personnes ayant réalisé la détermination taxonomique de l’observation.',NULL,true);
INSERT INTO data VALUES ('determinateuridentite','CharacterString','determinateurIdentite','Prénom, nom de la ou les personnes ayant réalisé la détermination taxonomique de l’observation.',NULL,true);
INSERT INTO data VALUES ('determinateurmail','CharacterString','determinateurMail','Mail de la ou les personnes ayant réalisé la détermination taxonomique de l’observation.',NULL,true);
INSERT INTO data VALUES ('validateurnomorganisme','CharacterString','validateurNomOrganisme','Organisme de la personne ayant réalisée la validation scientifique de l’observation pour le Producteur.',NULL,true);
INSERT INTO data VALUES ('validateuridentite','CharacterString','validateurIdentite','Prénom, nom de la personne ayant réalisée la validation scientifique de l’observation pour le Producteur.',NULL,true);
INSERT INTO data VALUES ('validateurmail','CharacterString','validateurMail','Mail de la personne ayant réalisée la validation scientifique de l’observation pour le Producteur.',NULL,true);
INSERT INTO data VALUES ('identifiantorigine','CharacterString','identifiantOrigine','Identifiant unique de la Donnée Source de l’observation dans la base de données du producteur où est stockée et initialement gérée la Donnée Source. La DS est caractérisée par jddId et/ou jddCode,.',NULL,true);
INSERT INTO data VALUES ('dspublique','DSPubliqueValue','dSPublique','Indique explicitement si la DS de la DEE est publique ou privée. Définit uniquement les droits nécessaires et suffisants des DS pour produire une DEE. Ne doit être utilisé que pour indiquer si la DEE résultante est susceptible d’être floutée.',NULL,true);
INSERT INTO data VALUES ('diffusionniveauprecision','NiveauPrecisionValue','diffusionNiveauPrecision','Niveau maximal de précision de la diffusion souhaitée par le producteur vers le grand public. Ne concerne que les DEE non sensibles.',NULL,true);
INSERT INTO data VALUES ('deefloutage','DEEFloutageValue','dEEFloutage','Indique si un floutage a été effectué lors de la transformation en DEE. Cela ne concerne que des données d''origine privée.',NULL,true);
INSERT INTO data VALUES ('sensible','SensibleValue','sensible','Indique si l''observation est sensible d''après les principes du SINP. Va disparaître.',NULL,true);
INSERT INTO data VALUES ('sensiniveau','SensibiliteValue','sensiNiveau','Indique si l''observation ou le regroupement est sensible d''après les principes du SINP et à quel degré. La manière de déterminer la sensibilité est définie dans le guide technique des données sensibles disponible sur la plate-forme naturefrance.',NULL,true);
INSERT INTO data VALUES ('sensidateattribution','DateTime','sensiDateAttribution','Date à laquelle on a attribué un niveau de sensibilité à la donnée. C''est également la date à laquelle on a consulté le référentiel de sensibilité associé.',NULL,false);
INSERT INTO data VALUES ('sensireferentiel','CharacterString','sensiReferentiel','Référentiel de sensibilité consulté lors de l''attribution du niveau de sensibilité.',NULL,true);
INSERT INTO data VALUES ('sensiversionreferentiel','CharacterString','sensiVersionReferentiel','Version du référentiel consulté. Peut être une date si le référentiel n''a pas de numéro de version. Doit être rempli par "NON EXISTANTE" si un référentiel n''existait pas au moment de l''attribution de la sensibilité par un Organisme.',NULL,true);
INSERT INTO data VALUES ('statutsource','StatutSourceValue','statutSource','Indique si la DS de l’observation provient directement du terrain (via un document informatisé ou une base de données), d''une collection, de la littérature, ou n''est pas connu.',NULL,true);
INSERT INTO data VALUES ('jddcode','CharacterString','jddCode','Nom, acronyme, ou code de la collection du jeu de données dont provient la donnée source.',NULL,true);
INSERT INTO data VALUES ('jddid','CharacterString','jddId','Identifiant pour la collection ou le jeu de données source d''où provient l''enregistrement.',NULL,true);
INSERT INTO data VALUES ('jddsourceid','CharacterString','jddSourceId','Il peut arriver, pour un besoin d''inventaire, par exemple, qu''on réutilise une donnée en provenance d''un autre jeu de données DEE déjà existant au sein du SINP.',NULL,true);
INSERT INTO data VALUES ('jddmetadonneedeeid','CharacterString','jddMetadonneeDEEId','Identifiant permanent et unique de la fiche métadonnées du jeu de données auquel appartient la donnée.',NULL,true);
INSERT INTO data VALUES ('organismegestionnairedonnee','CharacterString','organismeGestionnaireDonnee','Nom de l’organisme qui détient la Donnée Source (DS) de la DEE et qui en a la responsabilité. Si plusieurs organismes sont nécessaires, les séparer par des virgules.',NULL,true);
INSERT INTO data VALUES ('codeidcnpdispositif','IDCNPValue','codeIDCNPDispositif','Code du dispositif de collecte dans le cadre duquel la donnée a été collectée.',NULL,true);
INSERT INTO data VALUES ('deedatetransformation','DateTime','dEEDateTransformation','Date de transformation de la donnée source (DSP ou DSR) en donnée élémentaire d''échange (DEE).',NULL,false);
INSERT INTO data VALUES ('deedatedernieremodification','DateTime','dEEDateDerniereModification','Date de dernière modification de la donnée élémentaire d''échange. Postérieure à la date de transformation en DEE, égale dans le cas de l''absence de modification.',NULL,false);
INSERT INTO data VALUES ('referencebiblio','CharacterString','referenceBiblio','Référence de la source de l’observation lorsque celle-ci est de type « Littérature », au format ISO690. La référence bibliographique doit concerner l''observation même et non uniquement le taxon ou le protocole.',NULL,true);
INSERT INTO data VALUES ('orgtransformation','CharacterString','orgTransformation','Nom de l''organisme ayant créé la DEE finale (plate-forme ou organisme mandaté par elle).',NULL,false);
INSERT INTO data VALUES ('identifiantpermanent','CharacterString','identifiantPermanent','Identifiant unique et pérenne de la Donnée Elémentaire d’Echange de l''observation dans le SINP attribué par la plateforme régionale ou thématique.',NULL,true);
INSERT INTO data VALUES ('statutobservation','StatutObservationValue','statutObservation','Indique si le taxon a été observé directement ou indirectement (indices de présence), ou non observé ',NULL,true);
INSERT INTO data VALUES ('nomcite','CharacterString','nomCite','Nom du taxon cité à l’origine par l’observateur. Celui-ci peut être le nom scientifique reprenant idéalement en plus du nom latin, l’auteur et la date. ',NULL,true);
INSERT INTO data VALUES ('jourdatedebut','Date','jourDateDebut','Date du jour, dans le système local de l’observation dans le système grégorien. En cas d’imprécision, cet attribut représente la date la plus ancienne de la période d’imprécision.',NULL,true);
INSERT INTO data VALUES ('jourdatefin','Date','jourDateFin','Date du jour, dans le système local de l’observation dans le système grégorien. En cas d’imprécision sur la date, cet attribut représente la date la plus récente de la période d’imprécision.',NULL,true);
INSERT INTO data VALUES ('altitudemin','Decimal','altitudeMin','Altitude minimum de l’observation en mètres.',NULL,true);
INSERT INTO data VALUES ('altitudemax','Decimal','altitudeMax','Altitude maximum de l’observation en mètres.',NULL,true);
INSERT INTO data VALUES ('profondeurmin','Decimal','profondeurMin','Profondeur minimale de l’observation en mètres selon le référentiel des profondeurs indiqué dans les métadonnées (système de référence spatiale verticale).',NULL,true);
INSERT INTO data VALUES ('profondeurmax','Decimal','profondeurMax','Profondeur maximale de l’observation en mètres selon le référentiel des profondeurs indiqué dans les métadonnées (système de référence spatiale verticale).',NULL,true);
INSERT INTO data VALUES ('cdnom','CharacterString','cdNom','Code du taxon « cd_nom » de TaxRef référençant au niveau national le taxon. Le niveau ou rang taxinomique de la DEE doit être celui de la DS.',NULL,true);
INSERT INTO data VALUES ('cdref','CharacterString','cdRef','Code du taxon « cd_ref » de TAXREF référençant au niveau national le taxon. Le niveau ou rang taxinomique de la DEE doit être celui de la DS.',NULL,true);
INSERT INTO data VALUES ('versiontaxref','CharacterString','versionTAXREF','Version du référentiel TAXREF utilisée pour le cdNom et le cdRef.',NULL,false);
INSERT INTO data VALUES ('datedetermination','Date','dateDetermination','Date/heure de la dernière détermination du taxon de l’observation dans le système grégorien.',NULL,true);
INSERT INTO data VALUES ('organismestandard','CharacterString','organismeStandard','Nom(s) de(s) organisme(s) qui ont participés à la standardisation de la DS en DEE (codage, formatage, recherche des données obligatoires) ',NULL,true);
INSERT INTO data VALUES ('commentaire','CharacterString','commentaire','Champ libre pour informations complémentaires indicatives sur le sujet d''observation.',NULL,true);
INSERT INTO data VALUES ('nomattribut','CharacterString','nomAttribut','Libellé court et implicite de l’attribut additionnel.',NULL,true);
INSERT INTO data VALUES ('definitionattribut','CharacterString','definitionAttribut','Définition précise et complète de l''attribut additionnel.',NULL,true);
INSERT INTO data VALUES ('valeurattribut','CharacterString','valeurAttribut','Valeur qualitative ou quantitative de l’attribut additionnel.',NULL,true);
INSERT INTO data VALUES ('uniteattribut','CharacterString','uniteAttribut','Unité de mesure de l’attribut additionnel.',NULL,true);
INSERT INTO data VALUES ('thematiqueattribut','CharacterString','thematiqueAttribut','Thématique relative à l''attribut additionnel (mot-clé).',NULL,true);
INSERT INTO data VALUES ('typeattribut','TypeAttributValue','typeAttribut','Indique si l''attribut additionnel est de type quantitatif ou qualitatif.',NULL,true);
INSERT INTO data VALUES ('obsdescription','CharacterString','obsDescription','Description libre de l''observation, aussi succincte et précise que possible.',NULL,true);
INSERT INTO data VALUES ('obsmethode','ObservationMethodeValue','obsMethode','Indique de quelle manière on a pu constater la présence d''un sujet d''observation.',NULL,true);
INSERT INTO data VALUES ('occetatbiologique','OccurrenceEtatBiologiqueValue','occEtatBiologique','Code de l''état biologique de l''organisme au moment de l''observation.',NULL,true);
INSERT INTO data VALUES ('occmethodedetermination','CharacterString','occMethodeDetermination','Description de la méthode utilisée pour déterminer le taxon lors de l''observation.',NULL,true);
INSERT INTO data VALUES ('occnaturalite','OccurrenceNaturalisteValue','occNaturalite','Naturalité de l''occurrence, conséquence de l''influence anthropique directe qui la caractérise. Elle peut être déterminée immédiatement par simple observation, y compris par une personne n''ayant pas de formation dans le domaine de la biologie considéré.',NULL,true);
INSERT INTO data VALUES ('occsexe','OccurrenceSexeValue','occSexe','Sexe du sujet de l''observation.',NULL,true);
INSERT INTO data VALUES ('occstadedevie','OccurrenceStadeDeVieValue','occStadeDeVie','Stade de développement du sujet de l''observation.',NULL,true);
INSERT INTO data VALUES ('occstatutbiologique','OccurrenceStatutBiologiqueValue','occStatutBiologique','Comportement général de l''individu sur le site d''observation.',NULL,true);
INSERT INTO data VALUES ('occstatutbiogeographique','OccurrenceStatutBiogeographiqueValue','occStatutBioGeographique','Couvre une notion de présence (présence/absence), et d''origine (indigénat ou introduction)',NULL,true);
INSERT INTO data VALUES ('preuveexistante','PreuveExistanteValue','preuveExistante','Indique si une preuve existe ou non. Par preuve on entend un objet physique ou numérique permettant de démontrer l''existence de l''occurrence et/ou d''en vérifier l''exactitude.',NULL,true);
INSERT INTO data VALUES ('preuvenonnumerique','CharacterString','preuveNonNumerique','Adresse ou nom de la personne ou de l''organisme qui permettrait de retrouver la preuve non numérique de L''observation.',NULL,true);
INSERT INTO data VALUES ('preuvenumerique','CharacterString','preuveNumerique','Adresse web à laquelle on pourra trouver la preuve numérique ou l''archive contenant toutes les preuves numériques (image(s), sonogramme(s), film(s), séquence(s) génétique(s)...).',NULL,true);
INSERT INTO data VALUES ('obscontexte','CharacterString','obsContexte','Description libre du contexte de l''observation, aussi succincte et précise que possible.',NULL,true);
INSERT INTO data VALUES ('identifiantregroupementpermanent','CharacterString','identifiantRegroupementPermanent','Identifiant permanent du regroupement, sous forme d''UUID.',NULL,true);
INSERT INTO data VALUES ('methoderegroupement','CharacterString','methodeRegroupement','Description de la méthode ayant présidé au regroupement, de façon aussi succincte que possible : champ libre.',NULL,true);
INSERT INTO data VALUES ('typeregroupement','TypeRegroupementValue','typeRegroupement','Indique quel est le type du regroupement suivant la liste typeRegroupementValue.',NULL,true);
INSERT INTO data VALUES ('altitudemoyenne','Decimal','altitudeMoyenne','Altitude moyenne considérée pour le regroupement.',NULL,true);
INSERT INTO data VALUES ('profondeurmoyenne','Decimal','profondeurMoyenne','Profondeur moyenne considérée pour le regroupement.',NULL,true);
INSERT INTO data VALUES ('sensimanuelle','SensiManuelleValue','sensiManuelle','Indique si la sensibilité a été attribuée manuellement.',NULL,true);
INSERT INTO data VALUES ('sensialerte','SensiAlerteValue','sensiAlerte','Indique si la sensibilité est à attribuer manuellement.',NULL,true);
INSERT INTO data VALUES ('codemaillecalcule','CodeMailleCalculeValue','codeMailleCalcule','Code de la maille calculé',NULL,true);
INSERT INTO data VALUES ('codecommunecalcule','CodeCommuneCalculeValue','codeCommuneCalcule','Code de la commune calculé',NULL,true);
INSERT INTO data VALUES ('nomcommunecalcule','NomCommuneCalculeValue','nomCommuneCalcule','Nom de la commune calculé',NULL,true);
INSERT INTO data VALUES ('codedepartementcalcule','CodeDepartementCalculeValue','codeDepartementCalcule','Code du département calculé',NULL,true);
INSERT INTO data VALUES ('heuredatedebut','Time','heureDateDebut','Heure du jour, dans le système local de l’observation dans le système grégorien. En cas d’imprécision, cet attribut représente la date la plus ancienne de la période d’imprécision.',NULL,true);
INSERT INTO data VALUES ('heuredatefin','Time','heureDateFin','Heure du jour, dans le système local de l’observation dans le système grégorien. En cas d’imprécision sur la date, cet attribut représente la date la plus récente de la période d’imprécision.',NULL,true);
INSERT INTO data VALUES ('nomvalide','CharacterString','nomValide','Le nomValide est le nom du taxon correspondant au cd_ref',NULL,true);
INSERT INTO data VALUES ('tpsid','Integer','tpsId','Identifiant TPS','Identifiant TPS',true);
INSERT INTO data VALUES ('cdnomcalcule','TaxRefValue','cdNomCalcule','Code du taxon « cd_nom » calculé.',NULL,true);
INSERT INTO data VALUES ('cdrefcalcule','TaxRefValue','cdRefCalcule','Code du taxon « cd_ref » calculé.',NULL,true);
INSERT INTO data VALUES ('taxostatut','TaxoStatutValue','taxoStatut','Statut du taxon pour la migration TAXREF.',NULL,true);
INSERT INTO data VALUES ('taxomodif','TaxoModifValue','taxoModif','Modification effectuée sur le taxon lors de la migration TAXREF.',NULL,true);
INSERT INTO data VALUES ('taxoalerte','TaxoAlerteValue','taxoAlerte','Alerte sur le taxon pour la migration TAXREF.',NULL,true);
INSERT INTO data VALUES ('USER_LOGIN','USER_LOGIN','Utilisateur','Utilisateur',NULL,true);

-- INSERTION IN TABLE mode
INSERT INTO mode VALUES ('PROVIDER_ID','1',1,'organisme A','organisme A');

-- INSERTION IN TABLE dataset
INSERT INTO dataset VALUES ('dataset_01','modèle d''import de données brutes de biodiversité','1','modèle d''import de données brutes de biodiversité','IMPORT','unpublished');
INSERT INTO dataset VALUES ('dataset_02','modèle de visualisation de données brutes de biodiversité','0','modèle de visualisation de données brutes de biodiversité','QUERY',NULL);

-- INSERTION IN TABLE dynamode
INSERT INTO dynamode VALUES ('CodeCommuneValue','SELECT insee_com as code, insee_com as label, ''''::text as definition, ''''::text as position FROM referentiels.commune_carto_2017 ORDER BY insee_com');
INSERT INTO dynamode VALUES ('CodeDepartementValue','SELECT code_dept as code, nom_dept || '' ('' || code_dept || '')'' as label, ''''::text as definition, ''''::text as position FROM referentiels.departement_carto_2017 ORDER BY code_dept');
INSERT INTO dynamode VALUES ('CodeMailleValue','SELECT code_10km as code, cd_sig || '' ('' || code_10km || '')'' as label, ''''::text as definition, ''''::text as position FROM referentiels.codemaillevalue ORDER BY cd_sig');
INSERT INTO dynamode VALUES ('CodeENValue','SELECT codeen as code, codeen || '' ('' || libelleen || '')'' as label, ''''::text as definition, ''''::text as position FROM referentiels.codeenvalue ORDER BY codeEN');
INSERT INTO dynamode VALUES ('StatutSourceValue','SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.StatutSourceValue ORDER BY code');
INSERT INTO dynamode VALUES ('DSPubliqueValue','SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.DSPubliqueValue ORDER BY code');
INSERT INTO dynamode VALUES ('StatutObservationValue','SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.StatutObservationValue ORDER BY code');
INSERT INTO dynamode VALUES ('ObjetDenombrementValue','SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.ObjetDenombrementValue ORDER BY code');
INSERT INTO dynamode VALUES ('TypeDenombrementValue','SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.TypeDenombrementValue ORDER BY code');
INSERT INTO dynamode VALUES ('CodeHabitatValue','SELECT lb_code as code, lb_code as label, min(lb_hab_fr) as definition, ''''::text as position FROM referentiels.habref_20 GROUP BY lb_code having count(lb_code)>1');
INSERT INTO dynamode VALUES ('CodeRefHabitatValue','SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.CodeRefHabitatValue ORDER BY code');
INSERT INTO dynamode VALUES ('NatureObjetGeoValue','SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.NatureObjetGeoValue ORDER BY code');
INSERT INTO dynamode VALUES ('TypeENValue','SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.TypeENValue ORDER BY code');
INSERT INTO dynamode VALUES ('CodeHabRefValue','SELECT cd_hab as code, cd_hab as label, lb_description as definition, ''''::text as position FROM referentiels.habref_20 ORDER BY code');
INSERT INTO dynamode VALUES ('IDCNPValue','SELECT code, label, definition, ''''::text as position FROM referentiels.IDCNPValue ORDER BY code');
INSERT INTO dynamode VALUES ('TypeInfoGeoValue','SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.TypeInfoGeoValue ORDER BY code');
INSERT INTO dynamode VALUES ('VersionMasseDEauValue','SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.VersionMasseDEauValue ORDER BY code');
INSERT INTO dynamode VALUES ('NiveauPrecisionValue','SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.NiveauPrecisionValue ORDER BY code');
INSERT INTO dynamode VALUES ('DEEFloutageValue','SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.DEEFloutageValue ORDER BY code');
INSERT INTO dynamode VALUES ('SensibleValue','SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.SensibleValue ORDER BY code');
INSERT INTO dynamode VALUES ('SensibiliteValue','SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.SensibiliteValue ORDER BY code');
INSERT INTO dynamode VALUES ('TypeRegroupementValue','SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.TypeRegroupementValue ORDER BY code');
INSERT INTO dynamode VALUES ('OccurrenceNaturalisteValue','SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.OccurrenceNaturalisteValue ORDER BY code');
INSERT INTO dynamode VALUES ('OccurrenceSexeValue','SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.OccurrenceSexeValue ORDER BY code');
INSERT INTO dynamode VALUES ('OccurrenceStadeDeVieValue','SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.OccurrenceStadeDeVieValue ORDER BY code');
INSERT INTO dynamode VALUES ('OccurrenceStatutBiologiqueValue','SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.OccurrenceStatutBiologiqueValue ORDER BY code');
INSERT INTO dynamode VALUES ('PreuveExistanteValue','SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.PreuveExistanteValue ORDER BY code');
INSERT INTO dynamode VALUES ('ObservationMethodeValue','SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.ObservationMethodeValue ORDER BY code');
INSERT INTO dynamode VALUES ('OccurrenceEtatBiologiqueValue','SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.OccurrenceEtatBiologiqueValue ORDER BY code');
INSERT INTO dynamode VALUES ('OccurrenceStatutBiogeographiqueValue','SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.OccurrenceStatutBiogeographiqueValue ORDER BY code');
INSERT INTO dynamode VALUES ('PROVIDER_ID','SELECT id as code, label, definition, ''''::text as position FROM website.providers ORDER BY label');
INSERT INTO dynamode VALUES ('SensiAlerteValue','SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.SensiAlerteValue ORDER BY code');
INSERT INTO dynamode VALUES ('SensiManuelleValue','SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.SensiManuelleValue ORDER BY code');
INSERT INTO dynamode VALUES ('CodeMailleCalculeValue','SELECT code_10km as code, cd_sig || '' ('' || code_10km || '')'' as label, ''''::text as definition, ''''::text as position FROM referentiels.codemaillevalue ORDER BY cd_sig');
INSERT INTO dynamode VALUES ('CodeCommuneCalculeValue','SELECT insee_com as code, insee_com as label, ''''::text as definition, ''''::text as position FROM referentiels.commune_carto_2017 ORDER BY insee_com');
INSERT INTO dynamode VALUES ('NomCommuneCalculeValue','SELECT nom_com as code, nom_com || '' ('' || insee_com || '')'' as label, ''''::text as definition, ''''::text as position FROM referentiels.commune_carto_2017 ORDER BY nom_com');
INSERT INTO dynamode VALUES ('CodeDepartementCalculeValue','SELECT code_dept as code, nom_dept || '' ('' || code_dept || '')'' as label, ''''::text as definition, ''''::text as position FROM referentiels.departement_carto_2017 ORDER BY code_dept');
INSERT INTO dynamode VALUES ('TypeAttributValue','SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.typeattributvalue ORDER BY code');
INSERT INTO dynamode VALUES ('TaxoStatutValue','SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.TaxoStatutValue ORDER BY code');
INSERT INTO dynamode VALUES ('TaxoModifValue','SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.TaxoModifValue ORDER BY code');
INSERT INTO dynamode VALUES ('TaxoAlerteValue','SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.TaxoAlerteValue ORDER BY code');
INSERT INTO dynamode VALUES ('USER_LOGIN','SELECT user_login as code, user_name as label, user_name as definition, ''''::text as position FROM website.users ORDER BY user_login');

-- INSERTION IN TABLE form_format
INSERT INTO form_format VALUES ('form_observation','Observation','Groupement des champs d''observation',1,'1');
INSERT INTO form_format VALUES ('form_localisation','Localisation','Groupement des champs de localisation',2,'1');
INSERT INTO form_format VALUES ('form_regroupements','Regroupements','Groupement des champs de regroupement',3,'1');
INSERT INTO form_format VALUES ('form_standardisation','Standardisation','Groupement des champs de standardisation',4,'1');
INSERT INTO form_format VALUES ('form_autres','Autres','Autres champs',6,'1');

-- INSERTION IN TABLE table_schema
INSERT INTO table_schema VALUES ('RAW_DATA','RAW_DATA','Données sources','Contains raw data');
INSERT INTO table_schema VALUES ('METADATA','METADATA','Metadata','Contains the tables describing the data');
INSERT INTO table_schema VALUES ('WEBSITE','WEBSITE','Website','Contains the tables used to operate the web site');
INSERT INTO table_schema VALUES ('PUBLIC','PUBLIC','Public','Contains the default PostgreSQL tables and PostGIS functions');

-- INSERTION IN TABLE standard
INSERT INTO standard VALUES ('occtax','Standard d''occurences de taxons','v1.2.1');

-- INSERTION IN TABLE model
INSERT INTO model VALUES ('model_01','Données brutes de biodiversité','Données brutes de biodiversité','RAW_DATA',TRUE,'unpublished',NULL,'occtax');

-- INSERTION IN TABLE table_format
INSERT INTO table_format VALUES ('table_observation','model_1_observation','RAW_DATA','OGAM_ID_table_observation, PROVIDER_ID, USER_LOGIN','observation','table_dsr_exemple_observation');

-- INSERTION IN TABLE model_tables
INSERT INTO model_tables VALUES ('model_01','table_observation');

-- INSERTION IN TABLE model_datasets
INSERT INTO model_datasets VALUES ('model_01','dataset_01');
INSERT INTO model_datasets VALUES ('model_01','dataset_02');

-- INSERTION IN TABLE file_format
INSERT INTO file_format VALUES ('file_dbb','CSV','file_dbb',0,'fichier de données brutes de biodiversité','fichier de données brutes de biodiversité');

-- INSERTION IN TABLE event_listener
INSERT INTO event_listener VALUES ('GincoChecksDSRService','fr.ifn.ogam.integration.business.ChecksDSRGincoService');
INSERT INTO event_listener VALUES ('JddDlbService','fr.ifn.ogam.integration.business.JddDlbService');
INSERT INTO event_listener VALUES ('GeoAssociationService','fr.ifn.ogam.integration.business.GeoAssociationService');

-- Fill the parent table
INSERT INTO format (format, type)
SELECT format, 'FILE'
FROM   file_format;

INSERT INTO format (format, type)
SELECT format, 'TABLE'
FROM   table_format;

INSERT INTO format (format, type)
SELECT format, 'FORM'
FROM   form_format;


-- INSERTION IN TABLE form_field
INSERT INTO form_field VALUES ('altitudemax','form_localisation','1','1','NUMERIC',1,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('altitudemin','form_localisation','1','1','NUMERIC',2,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('altitudemoyenne','form_localisation','1','1','NUMERIC',3,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('anneerefcommune','form_localisation','1','1','NUMERIC',4,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('anneerefdepartement','form_localisation','1','1','NUMERIC',5,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('cdnom','form_observation','1','1','TEXT',6,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('cdnomcalcule','form_observation','1','1','TAXREF',7,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('cdref','form_observation','1','1','TEXT',8,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('cdrefcalcule','form_observation','1','1','TAXREF',9,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('codecommune','form_localisation','1','1','SELECT',10,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('codedepartement','form_localisation','1','1','SELECT',11,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('codeen','form_localisation','1','1','SELECT',12,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('codehabitat','form_localisation','1','1','SELECT',13,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('codehabref','form_localisation','1','1','SELECT',14,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('codeidcnpdispositif','form_standardisation','1','1','SELECT',15,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('codemaille','form_localisation','1','1','SELECT',16,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('codeme','form_localisation','1','1','TEXT',17,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('commentaire','form_observation','1','1','TEXT',18,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('jourdatedebut','form_observation','1','1','DATE',19,'0','1',NULL,NULL,'yyyy-MM-dd');
INSERT INTO form_field VALUES ('datedetermination','form_observation','1','1','DATE',20,'0','0',NULL,NULL,'yyyy-MM-dd');
INSERT INTO form_field VALUES ('jourdatefin','form_observation','1','1','DATE',21,'0','1',NULL,NULL,'yyyy-MM-dd');
INSERT INTO form_field VALUES ('dateme','form_localisation','1','1','DATE',22,'0','0',NULL,NULL,'yyyy-MM-dd');
INSERT INTO form_field VALUES ('deedatedernieremodification','form_standardisation','1','1','DATE',23,'0','0',NULL,NULL,'yyyy-MM-dd');
INSERT INTO form_field VALUES ('deefloutage','form_standardisation','1','1','SELECT',24,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('denombrementmax','form_observation','1','1','NUMERIC',25,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('denombrementmin','form_observation','1','1','NUMERIC',26,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('determinateuridentite','form_observation','1','1','TEXT',27,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('determinateurmail','form_observation','1','1','TEXT',28,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('determinateurnomorganisme','form_observation','1','1','TEXT',29,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('diffusionniveauprecision','form_standardisation','1','1','SELECT',30,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('dspublique','form_standardisation','1','1','SELECT',31,'0','1',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('geometrie','form_localisation','1','1','GEOM',32,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('identifiantorigine','form_standardisation','1','1','TEXT',33,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('identifiantpermanent','form_standardisation','1','1','TEXT',34,'0','1',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('identifiantregroupementpermanent','form_regroupements','1','1','TEXT',35,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('jddcode','form_standardisation','1','1','TEXT',36,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('jddid','form_standardisation','1','1','TEXT',37,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('jddmetadonneedeeid','form_standardisation','1','1','TEXT',38,'0','1',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('jddsourceid','form_standardisation','1','1','TEXT',39,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('methoderegroupement','form_regroupements','1','1','TEXT',40,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('natureobjetgeo','form_localisation','1','1','SELECT',41,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('nomcite','form_observation','1','1','TEXT',42,'0','1',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('nomcommune','form_localisation','1','1','TEXT',43,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('nomrefmaille','form_localisation','1','1','TEXT',44,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('objetdenombrement','form_observation','1','1','SELECT',45,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('obscontexte','form_observation','1','1','TEXT',46,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('obsdescription','form_observation','1','1','TEXT',47,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('observateuridentite','form_observation','1','1','TEXT',48,'0','1',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('observateurmail','form_observation','1','1','TEXT',49,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('observateurnomorganisme','form_observation','1','1','TEXT',50,'0','1',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('obsmethode','form_observation','1','1','SELECT',51,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('occetatbiologique','form_observation','1','1','SELECT',52,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('occmethodedetermination','form_observation','1','1','TEXT',53,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('occnaturalite','form_observation','1','1','SELECT',54,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('occsexe','form_observation','1','1','SELECT',55,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('occstadedevie','form_observation','1','1','SELECT',56,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('occstatutbiogeographique','form_observation','1','1','SELECT',57,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('occstatutbiologique','form_observation','1','1','SELECT',58,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('OGAM_ID_table_observation','form_autres','1','1','TEXT',59,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('organismegestionnairedonnee','form_standardisation','1','1','TEXT',60,'0','1',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('organismestandard','form_standardisation','1','1','TEXT',61,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('orgtransformation','form_standardisation','1','1','TEXT',62,'0','1',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('precisiongeometrie','form_localisation','1','1','NUMERIC',63,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('preuveexistante','form_observation','1','1','SELECT',64,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('preuvenonnumerique','form_observation','1','1','TEXT',65,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('preuvenumerique','form_observation','1','1','TEXT',66,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('profondeurmax','form_localisation','1','1','NUMERIC',67,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('profondeurmin','form_localisation','1','1','NUMERIC',68,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('profondeurmoyenne','form_localisation','1','1','NUMERIC',69,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('PROVIDER_ID','form_autres','1','1','SELECT',70,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('USER_LOGIN','form_autres','1','1','SELECT',71,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('referencebiblio','form_standardisation','1','1','TEXT',72,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('refhabitat','form_localisation','1','1','SELECT',73,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('sensible','form_standardisation','1','1','SELECT',74,'0','1',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('sensidateattribution','form_standardisation','1','1','DATE',75,'0','0',NULL,NULL,'yyyy-MM-dd');
INSERT INTO form_field VALUES ('sensiniveau','form_standardisation','1','1','SELECT',76,'0','1',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('sensireferentiel','form_standardisation','1','1','TEXT',77,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('sensiversionreferentiel','form_standardisation','1','1','TEXT',78,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('statutobservation','form_observation','1','1','SELECT',79,'0','1',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('statutsource','form_standardisation','1','1','SELECT',80,'0','1',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('SUBMISSION_ID','form_autres','1','1','NUMERIC',81,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('typedenombrement','form_observation','1','1','SELECT',82,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('typeen','form_localisation','1','1','SELECT',83,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('typeinfogeocommune','form_localisation','1','1','SELECT',84,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('typeinfogeodepartement','form_localisation','1','1','SELECT',85,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('typeinfogeoen','form_localisation','1','1','SELECT',86,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('typeinfogeomaille','form_localisation','1','1','SELECT',87,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('typeinfogeome','form_localisation','1','1','SELECT',88,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('typeregroupement','form_regroupements','1','1','SELECT',89,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('validateuridentite','form_standardisation','1','1','TEXT',90,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('validateurmail','form_standardisation','1','1','TEXT',91,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('validateurnomorganisme','form_standardisation','1','1','TEXT',92,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('versionen','form_localisation','1','1','DATE',93,'0','0',NULL,NULL,'yyyy-MM-dd');
INSERT INTO form_field VALUES ('versionme','form_localisation','1','1','SELECT',94,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('versionrefhabitat','form_localisation','1','1','TEXT',95,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('versionrefmaille','form_localisation','1','1','TEXT',96,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('versiontaxref','form_observation','1','1','TEXT',97,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('sensimanuelle','form_standardisation','1','1','SELECT',98,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('sensialerte','form_standardisation','1','1','SELECT',99,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('codemaillecalcule','form_localisation','1','1','SELECT',100,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('codecommunecalcule','form_localisation','1','1','SELECT',101,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('nomcommunecalcule','form_localisation','1','1','TEXT',102,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('codedepartementcalcule','form_localisation','1','1','SELECT',103,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('heuredatedebut','form_observation','1','1','TIME',104,'0','1',NULL,NULL,'HH:mm');
INSERT INTO form_field VALUES ('heuredatefin','form_observation','1','1','TIME',105,'0','1',NULL,NULL,'HH:mm');
INSERT INTO form_field VALUES ('nomvalide','form_observation','1','1','TEXT',106,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('tpsid','form_autres','1','1','NUMERIC',107,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('taxostatut','form_observation','1','1','SELECT',108,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('taxomodif','form_observation','1','1','SELECT',109,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('taxoalerte','form_observation','1','1','SELECT',110,'0','0',NULL,NULL,NULL);

-- INSERTION IN TABLE file_field
INSERT INTO file_field VALUES ('altitudemax','file_dbb','0',NULL,'altMax',NULL);
INSERT INTO file_field VALUES ('altitudemin','file_dbb','0',NULL,'altMin',NULL);
INSERT INTO file_field VALUES ('altitudemoyenne','file_dbb','0',NULL,'altMoy',NULL);
INSERT INTO file_field VALUES ('anneerefcommune','file_dbb','0',NULL,'anRefCom',NULL);
INSERT INTO file_field VALUES ('anneerefdepartement','file_dbb','0',NULL,'anRefDept',NULL);
INSERT INTO file_field VALUES ('cdnom','file_dbb','0',NULL,'cdNom',NULL);
INSERT INTO file_field VALUES ('cdref','file_dbb','0',NULL,'cdRef',NULL);
INSERT INTO file_field VALUES ('codecommune','file_dbb','0',NULL,'cdCom',NULL);
INSERT INTO file_field VALUES ('codedepartement','file_dbb','0',NULL,'cdDept',NULL);
INSERT INTO file_field VALUES ('codemaille','file_dbb','0',NULL,'cdM10',NULL);
INSERT INTO file_field VALUES ('commentaire','file_dbb','0',NULL,'comment',NULL);
INSERT INTO file_field VALUES ('datedetermination','file_dbb','0','dd/MM/yyyy','dateDet',NULL);
INSERT INTO file_field VALUES ('denombrementmax','file_dbb','0',NULL,'denbrMax',NULL);
INSERT INTO file_field VALUES ('denombrementmin','file_dbb','0',NULL,'denbrMin',NULL);
INSERT INTO file_field VALUES ('determinateuridentite','file_dbb','0',NULL,'detId',NULL);
INSERT INTO file_field VALUES ('determinateurnomorganisme','file_dbb','0',NULL,'detNomOrg',NULL);
INSERT INTO file_field VALUES ('dspublique','file_dbb','1',NULL,'dSPublique',NULL);
INSERT INTO file_field VALUES ('geometrie','file_dbb','0',NULL,'WKT',NULL);
INSERT INTO file_field VALUES ('heuredatedebut','file_dbb','0','HH:mm','heureDebut',NULL);
INSERT INTO file_field VALUES ('heuredatefin','file_dbb','0','HH:mm','heureFin',NULL);
INSERT INTO file_field VALUES ('identifiantorigine','file_dbb','0',NULL,'idOrigine',NULL);
INSERT INTO file_field VALUES ('identifiantpermanent','file_dbb','1',NULL,'permId',NULL);
INSERT INTO file_field VALUES ('identifiantregroupementpermanent','file_dbb','0',NULL,'permIdGrp',NULL);
INSERT INTO file_field VALUES ('jddsourceid','file_dbb','0',NULL,'jddSourId',NULL);
INSERT INTO file_field VALUES ('jourdatedebut','file_dbb','1','dd/MM/yyyy','dateDebut',NULL);
INSERT INTO file_field VALUES ('jourdatefin','file_dbb','1','dd/MM/yyyy','dateFin',NULL);
INSERT INTO file_field VALUES ('methoderegroupement','file_dbb','0',NULL,'methGrp',NULL);
INSERT INTO file_field VALUES ('natureobjetgeo','file_dbb','0',NULL,'natObjGeo',NULL);
INSERT INTO file_field VALUES ('nomcite','file_dbb','1',NULL,'nomCite',NULL);
INSERT INTO file_field VALUES ('nomcommune','file_dbb','0',NULL,'nomCom',NULL);
INSERT INTO file_field VALUES ('nomrefmaille','file_dbb','0',NULL,'nomRefM10',NULL);
INSERT INTO file_field VALUES ('objetdenombrement','file_dbb','0',NULL,'objDenbr',NULL);
INSERT INTO file_field VALUES ('obscontexte','file_dbb','0',NULL,'obsCtx',NULL);
INSERT INTO file_field VALUES ('obsdescription','file_dbb','0',NULL,'obsDescr',NULL);
INSERT INTO file_field VALUES ('observateuridentite','file_dbb','1',NULL,'obsId',NULL);
INSERT INTO file_field VALUES ('observateurnomorganisme','file_dbb','1',NULL,'obsNomOrg',NULL);
INSERT INTO file_field VALUES ('obsmethode','file_dbb','0',NULL,'obsMeth',NULL);
INSERT INTO file_field VALUES ('occetatbiologique','file_dbb','0',NULL,'ocEtatBio',NULL);
INSERT INTO file_field VALUES ('occmethodedetermination','file_dbb','0',NULL,'ocMethDet',NULL);
INSERT INTO file_field VALUES ('occnaturalite','file_dbb','0',NULL,'ocNat',NULL);
INSERT INTO file_field VALUES ('occsexe','file_dbb','0',NULL,'ocSex',NULL);
INSERT INTO file_field VALUES ('occstadedevie','file_dbb','0',NULL,'ocStade',NULL);
INSERT INTO file_field VALUES ('occstatutbiogeographique','file_dbb','0',NULL,'ocBiogeo',NULL);
INSERT INTO file_field VALUES ('occstatutbiologique','file_dbb','0',NULL,'ocStatBio',NULL);
INSERT INTO file_field VALUES ('organismegestionnairedonnee','file_dbb','1',NULL,'orgGestDat',NULL);
INSERT INTO file_field VALUES ('precisiongeometrie','file_dbb','0',NULL,'precisGeo',NULL);
INSERT INTO file_field VALUES ('preuveexistante','file_dbb','0',NULL,'preuveOui',NULL);
INSERT INTO file_field VALUES ('preuvenonnumerique','file_dbb','0',NULL,'preuvNoNum',NULL);
INSERT INTO file_field VALUES ('preuvenumerique','file_dbb','0',NULL,'preuvNum',NULL);
INSERT INTO file_field VALUES ('profondeurmax','file_dbb','0',NULL,'profMax',NULL);
INSERT INTO file_field VALUES ('profondeurmin','file_dbb','0',NULL,'profMin',NULL);
INSERT INTO file_field VALUES ('profondeurmoyenne','file_dbb','0',NULL,'profMoy',NULL);
INSERT INTO file_field VALUES ('referencebiblio','file_dbb','0',NULL,'refBiblio',NULL);
INSERT INTO file_field VALUES ('statutobservation','file_dbb','1',NULL,'statObs',NULL);
INSERT INTO file_field VALUES ('statutsource','file_dbb','1',NULL,'statSource',NULL);
INSERT INTO file_field VALUES ('typedenombrement','file_dbb','0',NULL,'typDenbr',NULL);
INSERT INTO file_field VALUES ('typeinfogeocommune','file_dbb','0',NULL,'typInfGeoC',NULL);
INSERT INTO file_field VALUES ('typeinfogeodepartement','file_dbb','0',NULL,'typInfGeoD',NULL);
INSERT INTO file_field VALUES ('typeinfogeomaille','file_dbb','0',NULL,'typInfGeoM',NULL);
INSERT INTO file_field VALUES ('typeregroupement','file_dbb','0',NULL,'typGrp',NULL);
INSERT INTO file_field VALUES ('versionrefmaille','file_dbb','0',NULL,'vRefM10',NULL);

-- INSERTION IN TABLE table_field
INSERT INTO table_field VALUES ('SUBMISSION_ID','table_observation','submission_id','1','0','0','0',1,NULL,NULL);
INSERT INTO table_field VALUES ('PROVIDER_ID','table_observation','provider_id','0','0','0','1',2,NULL,NULL);
INSERT INTO table_field VALUES ('OGAM_ID_table_observation','table_observation','ogam_id_table_observation','1','0','0','1',3,'séquence',NULL);
INSERT INTO table_field VALUES ('codecommune','table_observation','codecommune','0','1','1','0',4,NULL,NULL);
INSERT INTO table_field VALUES ('nomcommune','table_observation','nomcommune','0','1','1','0',5,NULL,NULL);
INSERT INTO table_field VALUES ('anneerefcommune','table_observation','anneerefcommune','0','1','1','0',6,NULL,NULL);
INSERT INTO table_field VALUES ('typeinfogeocommune','table_observation','typeinfogeocommune','0','1','1','0',7,NULL,NULL);
INSERT INTO table_field VALUES ('denombrementmin','table_observation','denombrementmin','0','1','1','0',8,NULL,NULL);
INSERT INTO table_field VALUES ('denombrementmax','table_observation','denombrementmax','0','1','1','0',9,NULL,NULL);
INSERT INTO table_field VALUES ('objetdenombrement','table_observation','objetdenombrement','0','1','1','0',10,NULL,NULL);
INSERT INTO table_field VALUES ('typedenombrement','table_observation','typedenombrement','0','1','1','0',11,NULL,NULL);
INSERT INTO table_field VALUES ('codedepartement','table_observation','codedepartement','0','1','1','0',12,NULL,NULL);
INSERT INTO table_field VALUES ('anneerefdepartement','table_observation','anneerefdepartement','0','1','1','0',13,NULL,NULL);
INSERT INTO table_field VALUES ('typeinfogeodepartement','table_observation','typeinfogeodepartement','0','1','1','0',14,NULL,NULL);
INSERT INTO table_field VALUES ('typeen','table_observation','typeen','0','1','1','0',15,NULL,NULL);
INSERT INTO table_field VALUES ('codeen','table_observation','codeen','0','1','1','0',16,NULL,NULL);
INSERT INTO table_field VALUES ('versionen','table_observation','versionen','0','1','1','0',17,NULL,NULL);
INSERT INTO table_field VALUES ('typeinfogeoen','table_observation','typeinfogeoen','0','1','1','0',18,NULL,NULL);
INSERT INTO table_field VALUES ('refhabitat','table_observation','refhabitat','0','1','1','0',19,NULL,NULL);
INSERT INTO table_field VALUES ('codehabitat','table_observation','codehabitat','0','1','1','0',20,NULL,NULL);
INSERT INTO table_field VALUES ('versionrefhabitat','table_observation','versionrefhabitat','0','1','1','0',21,NULL,NULL);
INSERT INTO table_field VALUES ('codehabref','table_observation','codehabref','0','1','1','0',22,NULL,NULL);
INSERT INTO table_field VALUES ('codemaille','table_observation','codemaille','0','1','1','0',23,NULL,NULL);
INSERT INTO table_field VALUES ('versionrefmaille','table_observation','versionrefmaille','0','1','1','0',24,NULL,NULL);
INSERT INTO table_field VALUES ('nomrefmaille','table_observation','nomrefmaille','0','1','1','0',25,NULL,NULL);
INSERT INTO table_field VALUES ('typeinfogeomaille','table_observation','typeinfogeomaille','0','1','1','0',26,NULL,NULL);
INSERT INTO table_field VALUES ('codeme','table_observation','codeme','0','1','1','0',27,NULL,NULL);
INSERT INTO table_field VALUES ('versionme','table_observation','versionme','0','1','1','0',28,NULL,NULL);
INSERT INTO table_field VALUES ('dateme','table_observation','dateme','0','1','1','0',29,NULL,NULL);
INSERT INTO table_field VALUES ('typeinfogeome','table_observation','typeinfogeome','0','1','1','0',30,NULL,NULL);
INSERT INTO table_field VALUES ('observateurnomorganisme','table_observation','observateurnomorganisme','0','1','1','0',31,NULL,NULL);
INSERT INTO table_field VALUES ('observateuridentite','table_observation','observateuridentite','0','1','1','0',32,NULL,NULL);
INSERT INTO table_field VALUES ('observateurmail','table_observation','observateurmail','0','1','1','0',33,NULL,NULL);
INSERT INTO table_field VALUES ('determinateurnomorganisme','table_observation','determinateurnomorganisme','0','1','1','0',34,NULL,NULL);
INSERT INTO table_field VALUES ('determinateuridentite','table_observation','determinateuridentite','0','1','1','0',35,NULL,NULL);
INSERT INTO table_field VALUES ('determinateurmail','table_observation','determinateurmail','0','1','1','0',36,NULL,NULL);
INSERT INTO table_field VALUES ('validateurnomorganisme','table_observation','validateurnomorganisme','0','1','1','0',37,NULL,NULL);
INSERT INTO table_field VALUES ('validateuridentite','table_observation','validateuridentite','0','1','1','0',38,NULL,NULL);
INSERT INTO table_field VALUES ('validateurmail','table_observation','validateurmail','0','1','1','0',39,NULL,NULL);
INSERT INTO table_field VALUES ('identifiantorigine','table_observation','identifiantorigine','0','1','1','0',40,NULL,NULL);
INSERT INTO table_field VALUES ('dspublique','table_observation','dspublique','0','1','1','1',41,NULL,NULL);
INSERT INTO table_field VALUES ('diffusionniveauprecision','table_observation','diffusionniveauprecision','0','1','1','0',42,NULL,NULL);
INSERT INTO table_field VALUES ('deefloutage','table_observation','deefloutage','0','1','1','0',43,NULL,NULL);
INSERT INTO table_field VALUES ('sensible','table_observation','sensible','1','0','0','0',44,NULL,NULL);
INSERT INTO table_field VALUES ('sensiniveau','table_observation','sensiniveau','1','1','0','0',45,NULL,NULL);
INSERT INTO table_field VALUES ('sensidateattribution','table_observation','sensidateattribution','1','1','0','0',46,NULL,NULL);
INSERT INTO table_field VALUES ('sensireferentiel','table_observation','sensireferentiel','1','1','0','0',47,NULL,NULL);
INSERT INTO table_field VALUES ('sensiversionreferentiel','table_observation','sensiversionreferentiel','1','1','0','0',48,NULL,NULL);
INSERT INTO table_field VALUES ('statutsource','table_observation','statutsource','0','1','1','1',49,NULL,NULL);
INSERT INTO table_field VALUES ('jddcode','table_observation','jddcode','0','1','1','0',50,NULL,NULL);
INSERT INTO table_field VALUES ('jddid','table_observation','jddid','0','1','1','0',51,NULL,NULL);
INSERT INTO table_field VALUES ('jddsourceid','table_observation','jddsourceid','0','1','1','0',52,NULL,NULL);
INSERT INTO table_field VALUES ('jddmetadonneedeeid','table_observation','jddmetadonneedeeid','1','0','0','1',53,NULL,NULL);
INSERT INTO table_field VALUES ('organismegestionnairedonnee','table_observation','organismegestionnairedonnee','0','1','1','1',54,NULL,NULL);
INSERT INTO table_field VALUES ('codeidcnpdispositif','table_observation','codeidcnpdispositif','0','1','1','0',55,NULL,NULL);
INSERT INTO table_field VALUES ('deedatedernieremodification','table_observation','deedatedernieremodification','1','1','0','1',56,NULL,NULL);
INSERT INTO table_field VALUES ('referencebiblio','table_observation','referencebiblio','0','1','1','0',57,NULL,NULL);
INSERT INTO table_field VALUES ('orgtransformation','table_observation','orgtransformation','0','0','1','0',58,NULL,NULL);
INSERT INTO table_field VALUES ('identifiantpermanent','table_observation','identifiantpermanent','0','1','1','1',59,NULL,NULL);
INSERT INTO table_field VALUES ('statutobservation','table_observation','statutobservation','0','1','1','1',60,NULL,NULL);
INSERT INTO table_field VALUES ('nomcite','table_observation','nomcite','0','1','1','1',61,NULL,NULL);
INSERT INTO table_field VALUES ('jourdatedebut','table_observation','jourdatedebut','0','1','1','1',62,NULL,NULL);
INSERT INTO table_field VALUES ('jourdatefin','table_observation','jourdatefin','0','1','1','1',63,NULL,NULL);
INSERT INTO table_field VALUES ('altitudemin','table_observation','altitudemin','0','1','1','0',64,NULL,NULL);
INSERT INTO table_field VALUES ('altitudemax','table_observation','altitudemax','0','1','1','0',65,NULL,NULL);
INSERT INTO table_field VALUES ('profondeurmin','table_observation','profondeurmin','0','1','1','0',66,NULL,NULL);
INSERT INTO table_field VALUES ('profondeurmax','table_observation','profondeurmax','0','1','1','0',67,NULL,NULL);
INSERT INTO table_field VALUES ('cdnom','table_observation','cdnom','0','1','1','0',68,NULL,NULL);
INSERT INTO table_field VALUES ('cdref','table_observation','cdref','0','1','1','0',69,NULL,NULL);
INSERT INTO table_field VALUES ('versiontaxref','table_observation','versiontaxref','0','1','1','0',70,NULL,NULL);
INSERT INTO table_field VALUES ('datedetermination','table_observation','datedetermination','0','1','1','0',71,NULL,NULL);
INSERT INTO table_field VALUES ('organismestandard','table_observation','organismestandard','0','1','1','0',72,NULL,NULL);
INSERT INTO table_field VALUES ('commentaire','table_observation','commentaire','0','1','1','0',73,NULL,NULL);
INSERT INTO table_field VALUES ('obsdescription','table_observation','obsdescription','0','1','1','0',74,NULL,NULL);
INSERT INTO table_field VALUES ('obsmethode','table_observation','obsmethode','0','1','1','0',75,NULL,NULL);
INSERT INTO table_field VALUES ('occetatbiologique','table_observation','occetatbiologique','0','1','1','0',76,NULL,NULL);
INSERT INTO table_field VALUES ('occstatutbiogeographique','table_observation','occstatutbiogeographique','0','1','1','0',77,NULL,NULL);
INSERT INTO table_field VALUES ('occmethodedetermination','table_observation','occmethodedetermination','0','1','1','0',78,NULL,NULL);
INSERT INTO table_field VALUES ('occnaturalite','table_observation','occnaturalite','0','1','1','0',79,NULL,NULL);
INSERT INTO table_field VALUES ('occsexe','table_observation','occsexe','0','1','1','0',80,NULL,NULL);
INSERT INTO table_field VALUES ('occstadedevie','table_observation','occstadedevie','0','1','1','0',81,NULL,NULL);
INSERT INTO table_field VALUES ('occstatutbiologique','table_observation','occstatutbiologique','0','1','1','0',82,NULL,NULL);
INSERT INTO table_field VALUES ('preuveexistante','table_observation','preuveexistante','0','1','1','0',83,NULL,NULL);
INSERT INTO table_field VALUES ('preuvenonnumerique','table_observation','preuvenonnumerique','0','1','1','0',84,NULL,NULL);
INSERT INTO table_field VALUES ('preuvenumerique','table_observation','preuvenumerique','0','1','1','0',85,NULL,NULL);
INSERT INTO table_field VALUES ('obscontexte','table_observation','obscontexte','0','1','1','0',86,NULL,NULL);
INSERT INTO table_field VALUES ('identifiantregroupementpermanent','table_observation','identifiantregroupementpermanent','0','1','1','0',87,NULL,NULL);
INSERT INTO table_field VALUES ('methoderegroupement','table_observation','methoderegroupement','0','1','1','0',88,NULL,NULL);
INSERT INTO table_field VALUES ('typeregroupement','table_observation','typeregroupement','0','1','1','0',89,NULL,NULL);
INSERT INTO table_field VALUES ('altitudemoyenne','table_observation','altitudemoyenne','0','1','1','0',90,NULL,NULL);
INSERT INTO table_field VALUES ('profondeurmoyenne','table_observation','profondeurmoyenne','0','1','1','0',91,NULL,NULL);
INSERT INTO table_field VALUES ('geometrie','table_observation','geometrie','1','1','1','0',92,NULL,NULL);
INSERT INTO table_field VALUES ('natureobjetgeo','table_observation','natureobjetgeo','0','1','1','0',93,NULL,NULL);
INSERT INTO table_field VALUES ('precisiongeometrie','table_observation','precisiongeometrie','0','1','1','0',94,NULL,NULL);
INSERT INTO table_field VALUES ('sensimanuelle','table_observation','sensimanuelle','1','1','0','0',95,NULL,NULL);
INSERT INTO table_field VALUES ('sensialerte','table_observation','sensialerte','1','1','0','0',96,NULL,NULL);
INSERT INTO table_field VALUES ('codemaillecalcule','table_observation','codemaillecalcule','1','0','1','0',97,NULL,NULL);
INSERT INTO table_field VALUES ('codecommunecalcule','table_observation','codecommunecalcule','1','0','1','0',98,NULL,NULL);
INSERT INTO table_field VALUES ('nomcommunecalcule','table_observation','nomcommunecalcule','1','0','1','0',99,NULL,NULL);
INSERT INTO table_field VALUES ('codedepartementcalcule','table_observation','codedepartementcalcule','1','0','1','0',100,NULL,NULL);
INSERT INTO table_field VALUES ('heuredatedebut','table_observation','heuredatedebut','1','1','1','1',101,NULL,NULL);
INSERT INTO table_field VALUES ('heuredatefin','table_observation','heuredatefin','1','1','1','1',102,NULL,NULL);
INSERT INTO table_field VALUES ('nomvalide','table_observation','nomvalide','1','1','1','0',103,NULL,NULL);
INSERT INTO table_field VALUES ('tpsid','table_observation','tpsid','1','0','1','1',104,NULL,NULL);
INSERT INTO table_field VALUES ('cdnomcalcule','table_observation','cdnomcalcule','1','0','1','0',105,NULL,NULL);
INSERT INTO table_field VALUES ('cdrefcalcule','table_observation','cdrefcalcule','1','0','1','0',106,NULL,NULL);
INSERT INTO table_field VALUES ('taxostatut','table_observation','taxostatut','1','1','0','0',107,NULL,NULL);
INSERT INTO table_field VALUES ('taxomodif','table_observation','taxomodif','1','1','0','0',108,NULL,NULL);
INSERT INTO table_field VALUES ('taxoalerte','table_observation','taxoalerte','1','1','0','0',109,NULL,NULL);
INSERT INTO table_field VALUES ('USER_LOGIN','table_observation','user_login','0','0','0','1',110,NULL,NULL);

-- Fill the parent table
INSERT INTO field (data, format, type)
SELECT data, format, 'FILE'
FROM   file_field;

INSERT INTO field (data, format, type)
SELECT data, format, 'TABLE'
FROM   table_field;

INSERT INTO field (data, format, type)
SELECT data, format, 'FORM'
FROM   form_field;



-- INSERTION IN TABLE field_mapping
INSERT INTO field_mapping VALUES ('codecommune','file_dbb','codecommune','table_observation','FILE');
INSERT INTO field_mapping VALUES ('nomcommune','file_dbb','nomcommune','table_observation','FILE');
INSERT INTO field_mapping VALUES ('anneerefcommune','file_dbb','anneerefcommune','table_observation','FILE');
INSERT INTO field_mapping VALUES ('typeinfogeocommune','file_dbb','typeinfogeocommune','table_observation','FILE');
INSERT INTO field_mapping VALUES ('denombrementmin','file_dbb','denombrementmin','table_observation','FILE');
INSERT INTO field_mapping VALUES ('denombrementmax','file_dbb','denombrementmax','table_observation','FILE');
INSERT INTO field_mapping VALUES ('objetdenombrement','file_dbb','objetdenombrement','table_observation','FILE');
INSERT INTO field_mapping VALUES ('typedenombrement','file_dbb','typedenombrement','table_observation','FILE');
INSERT INTO field_mapping VALUES ('codedepartement','file_dbb','codedepartement','table_observation','FILE');
INSERT INTO field_mapping VALUES ('anneerefdepartement','file_dbb','anneerefdepartement','table_observation','FILE');
INSERT INTO field_mapping VALUES ('typeinfogeodepartement','file_dbb','typeinfogeodepartement','table_observation','FILE');
INSERT INTO field_mapping VALUES ('codemaille','file_dbb','codemaille','table_observation','FILE');
INSERT INTO field_mapping VALUES ('versionrefmaille','file_dbb','versionrefmaille','table_observation','FILE');
INSERT INTO field_mapping VALUES ('nomrefmaille','file_dbb','nomrefmaille','table_observation','FILE');
INSERT INTO field_mapping VALUES ('typeinfogeomaille','file_dbb','typeinfogeomaille','table_observation','FILE');
INSERT INTO field_mapping VALUES ('observateurnomorganisme','file_dbb','observateurnomorganisme','table_observation','FILE');
INSERT INTO field_mapping VALUES ('observateuridentite','file_dbb','observateuridentite','table_observation','FILE');
INSERT INTO field_mapping VALUES ('determinateurnomorganisme','file_dbb','determinateurnomorganisme','table_observation','FILE');
INSERT INTO field_mapping VALUES ('determinateuridentite','file_dbb','determinateuridentite','table_observation','FILE');
INSERT INTO field_mapping VALUES ('identifiantorigine','file_dbb','identifiantorigine','table_observation','FILE');
INSERT INTO field_mapping VALUES ('dspublique','file_dbb','dspublique','table_observation','FILE');
INSERT INTO field_mapping VALUES ('statutsource','file_dbb','statutsource','table_observation','FILE');
INSERT INTO field_mapping VALUES ('jddsourceid','file_dbb','jddsourceid','table_observation','FILE');
INSERT INTO field_mapping VALUES ('organismegestionnairedonnee','file_dbb','organismegestionnairedonnee','table_observation','FILE');
INSERT INTO field_mapping VALUES ('referencebiblio','file_dbb','referencebiblio','table_observation','FILE');
INSERT INTO field_mapping VALUES ('identifiantpermanent','file_dbb','identifiantpermanent','table_observation','FILE');
INSERT INTO field_mapping VALUES ('statutobservation','file_dbb','statutobservation','table_observation','FILE');
INSERT INTO field_mapping VALUES ('nomcite','file_dbb','nomcite','table_observation','FILE');
INSERT INTO field_mapping VALUES ('jourdatedebut','file_dbb','jourdatedebut','table_observation','FILE');
INSERT INTO field_mapping VALUES ('jourdatefin','file_dbb','jourdatefin','table_observation','FILE');
INSERT INTO field_mapping VALUES ('altitudemin','file_dbb','altitudemin','table_observation','FILE');
INSERT INTO field_mapping VALUES ('altitudemax','file_dbb','altitudemax','table_observation','FILE');
INSERT INTO field_mapping VALUES ('profondeurmin','file_dbb','profondeurmin','table_observation','FILE');
INSERT INTO field_mapping VALUES ('profondeurmax','file_dbb','profondeurmax','table_observation','FILE');
INSERT INTO field_mapping VALUES ('cdnom','file_dbb','cdnom','table_observation','FILE');
INSERT INTO field_mapping VALUES ('cdref','file_dbb','cdref','table_observation','FILE');
INSERT INTO field_mapping VALUES ('datedetermination','file_dbb','datedetermination','table_observation','FILE');
INSERT INTO field_mapping VALUES ('commentaire','file_dbb','commentaire','table_observation','FILE');
INSERT INTO field_mapping VALUES ('obsdescription','file_dbb','obsdescription','table_observation','FILE');
INSERT INTO field_mapping VALUES ('obsmethode','file_dbb','obsmethode','table_observation','FILE');
INSERT INTO field_mapping VALUES ('occetatbiologique','file_dbb','occetatbiologique','table_observation','FILE');
INSERT INTO field_mapping VALUES ('occmethodedetermination','file_dbb','occmethodedetermination','table_observation','FILE');
INSERT INTO field_mapping VALUES ('occnaturalite','file_dbb','occnaturalite','table_observation','FILE');
INSERT INTO field_mapping VALUES ('occsexe','file_dbb','occsexe','table_observation','FILE');
INSERT INTO field_mapping VALUES ('occstadedevie','file_dbb','occstadedevie','table_observation','FILE');
INSERT INTO field_mapping VALUES ('occstatutbiologique','file_dbb','occstatutbiologique','table_observation','FILE');
INSERT INTO field_mapping VALUES ('occstatutbiogeographique','file_dbb','occstatutbiogeographique','table_observation','FILE');
INSERT INTO field_mapping VALUES ('preuveexistante','file_dbb','preuveexistante','table_observation','FILE');
INSERT INTO field_mapping VALUES ('preuvenonnumerique','file_dbb','preuvenonnumerique','table_observation','FILE');
INSERT INTO field_mapping VALUES ('preuvenumerique','file_dbb','preuvenumerique','table_observation','FILE');
INSERT INTO field_mapping VALUES ('obscontexte','file_dbb','obscontexte','table_observation','FILE');
INSERT INTO field_mapping VALUES ('identifiantregroupementpermanent','file_dbb','identifiantregroupementpermanent','table_observation','FILE');
INSERT INTO field_mapping VALUES ('methoderegroupement','file_dbb','methoderegroupement','table_observation','FILE');
INSERT INTO field_mapping VALUES ('typeregroupement','file_dbb','typeregroupement','table_observation','FILE');
INSERT INTO field_mapping VALUES ('altitudemoyenne','file_dbb','altitudemoyenne','table_observation','FILE');
INSERT INTO field_mapping VALUES ('profondeurmoyenne','file_dbb','profondeurmoyenne','table_observation','FILE');
INSERT INTO field_mapping VALUES ('geometrie','file_dbb','geometrie','table_observation','FILE');
INSERT INTO field_mapping VALUES ('natureobjetgeo','file_dbb','natureobjetgeo','table_observation','FILE');
INSERT INTO field_mapping VALUES ('precisiongeometrie','file_dbb','precisiongeometrie','table_observation','FILE');
INSERT INTO field_mapping VALUES ('heuredatedebut','file_dbb','heuredatedebut','table_observation','FILE');
INSERT INTO field_mapping VALUES ('heuredatefin','file_dbb','heuredatefin','table_observation','FILE');
INSERT INTO field_mapping VALUES ('altitudemax','form_localisation','altitudemax','table_observation','FORM');
INSERT INTO field_mapping VALUES ('altitudemin','form_localisation','altitudemin','table_observation','FORM');
INSERT INTO field_mapping VALUES ('altitudemoyenne','form_localisation','altitudemoyenne','table_observation','FORM');
INSERT INTO field_mapping VALUES ('anneerefcommune','form_localisation','anneerefcommune','table_observation','FORM');
INSERT INTO field_mapping VALUES ('anneerefdepartement','form_localisation','anneerefdepartement','table_observation','FORM');
INSERT INTO field_mapping VALUES ('cdnom','form_observation','cdnom','table_observation','FORM');
INSERT INTO field_mapping VALUES ('cdref','form_observation','cdref','table_observation','FORM');
INSERT INTO field_mapping VALUES ('codecommune','form_localisation','codecommune','table_observation','FORM');
INSERT INTO field_mapping VALUES ('codedepartement','form_localisation','codedepartement','table_observation','FORM');
INSERT INTO field_mapping VALUES ('codeen','form_localisation','codeen','table_observation','FORM');
INSERT INTO field_mapping VALUES ('codehabitat','form_localisation','codehabitat','table_observation','FORM');
INSERT INTO field_mapping VALUES ('codehabref','form_localisation','codehabref','table_observation','FORM');
INSERT INTO field_mapping VALUES ('codeidcnpdispositif','form_standardisation','codeidcnpdispositif','table_observation','FORM');
INSERT INTO field_mapping VALUES ('codemaille','form_localisation','codemaille','table_observation','FORM');
INSERT INTO field_mapping VALUES ('codeme','form_localisation','codeme','table_observation','FORM');
INSERT INTO field_mapping VALUES ('commentaire','form_observation','commentaire','table_observation','FORM');
INSERT INTO field_mapping VALUES ('jourdatedebut','form_observation','jourdatedebut','table_observation','FORM');
INSERT INTO field_mapping VALUES ('datedetermination','form_observation','datedetermination','table_observation','FORM');
INSERT INTO field_mapping VALUES ('jourdatefin','form_observation','jourdatefin','table_observation','FORM');
INSERT INTO field_mapping VALUES ('dateme','form_localisation','dateme','table_observation','FORM');
INSERT INTO field_mapping VALUES ('deedatedernieremodification','form_standardisation','deedatedernieremodification','table_observation','FORM');
INSERT INTO field_mapping VALUES ('deefloutage','form_standardisation','deefloutage','table_observation','FORM');
INSERT INTO field_mapping VALUES ('denombrementmax','form_observation','denombrementmax','table_observation','FORM');
INSERT INTO field_mapping VALUES ('denombrementmin','form_observation','denombrementmin','table_observation','FORM');
INSERT INTO field_mapping VALUES ('determinateuridentite','form_observation','determinateuridentite','table_observation','FORM');
INSERT INTO field_mapping VALUES ('determinateurmail','form_observation','determinateurmail','table_observation','FORM');
INSERT INTO field_mapping VALUES ('determinateurnomorganisme','form_observation','determinateurnomorganisme','table_observation','FORM');
INSERT INTO field_mapping VALUES ('diffusionniveauprecision','form_standardisation','diffusionniveauprecision','table_observation','FORM');
INSERT INTO field_mapping VALUES ('dspublique','form_standardisation','dspublique','table_observation','FORM');
INSERT INTO field_mapping VALUES ('geometrie','form_localisation','geometrie','table_observation','FORM');
INSERT INTO field_mapping VALUES ('identifiantorigine','form_standardisation','identifiantorigine','table_observation','FORM');
INSERT INTO field_mapping VALUES ('identifiantpermanent','form_standardisation','identifiantpermanent','table_observation','FORM');
INSERT INTO field_mapping VALUES ('identifiantregroupementpermanent','form_regroupements','identifiantregroupementpermanent','table_observation','FORM');
INSERT INTO field_mapping VALUES ('jddcode','form_standardisation','jddcode','table_observation','FORM');
INSERT INTO field_mapping VALUES ('jddid','form_standardisation','jddid','table_observation','FORM');
INSERT INTO field_mapping VALUES ('jddmetadonneedeeid','form_standardisation','jddmetadonneedeeid','table_observation','FORM');
INSERT INTO field_mapping VALUES ('jddsourceid','form_standardisation','jddsourceid','table_observation','FORM');
INSERT INTO field_mapping VALUES ('methoderegroupement','form_regroupements','methoderegroupement','table_observation','FORM');
INSERT INTO field_mapping VALUES ('natureobjetgeo','form_localisation','natureobjetgeo','table_observation','FORM');
INSERT INTO field_mapping VALUES ('nomcite','form_observation','nomcite','table_observation','FORM');
INSERT INTO field_mapping VALUES ('nomcommune','form_localisation','nomcommune','table_observation','FORM');
INSERT INTO field_mapping VALUES ('nomrefmaille','form_localisation','nomrefmaille','table_observation','FORM');
INSERT INTO field_mapping VALUES ('objetdenombrement','form_observation','objetdenombrement','table_observation','FORM');
INSERT INTO field_mapping VALUES ('obscontexte','form_observation','obscontexte','table_observation','FORM');
INSERT INTO field_mapping VALUES ('obsdescription','form_observation','obsdescription','table_observation','FORM');
INSERT INTO field_mapping VALUES ('observateuridentite','form_observation','observateuridentite','table_observation','FORM');
INSERT INTO field_mapping VALUES ('observateurmail','form_observation','observateurmail','table_observation','FORM');
INSERT INTO field_mapping VALUES ('observateurnomorganisme','form_observation','observateurnomorganisme','table_observation','FORM');
INSERT INTO field_mapping VALUES ('obsmethode','form_observation','obsmethode','table_observation','FORM');
INSERT INTO field_mapping VALUES ('occetatbiologique','form_observation','occetatbiologique','table_observation','FORM');
INSERT INTO field_mapping VALUES ('occmethodedetermination','form_observation','occmethodedetermination','table_observation','FORM');
INSERT INTO field_mapping VALUES ('occnaturalite','form_observation','occnaturalite','table_observation','FORM');
INSERT INTO field_mapping VALUES ('occsexe','form_observation','occsexe','table_observation','FORM');
INSERT INTO field_mapping VALUES ('occstadedevie','form_observation','occstadedevie','table_observation','FORM');
INSERT INTO field_mapping VALUES ('occstatutbiogeographique','form_observation','occstatutbiogeographique','table_observation','FORM');
INSERT INTO field_mapping VALUES ('occstatutbiologique','form_observation','occstatutbiologique','table_observation','FORM');
INSERT INTO field_mapping VALUES ('OGAM_ID_table_observation','form_autres','OGAM_ID_table_observation','table_observation','FORM');
INSERT INTO field_mapping VALUES ('organismegestionnairedonnee','form_standardisation','organismegestionnairedonnee','table_observation','FORM');
INSERT INTO field_mapping VALUES ('organismestandard','form_standardisation','organismestandard','table_observation','FORM');
INSERT INTO field_mapping VALUES ('orgtransformation','form_standardisation','orgtransformation','table_observation','FORM');
INSERT INTO field_mapping VALUES ('precisiongeometrie','form_localisation','precisiongeometrie','table_observation','FORM');
INSERT INTO field_mapping VALUES ('preuveexistante','form_observation','preuveexistante','table_observation','FORM');
INSERT INTO field_mapping VALUES ('preuvenonnumerique','form_observation','preuvenonnumerique','table_observation','FORM');
INSERT INTO field_mapping VALUES ('preuvenumerique','form_observation','preuvenumerique','table_observation','FORM');
INSERT INTO field_mapping VALUES ('profondeurmax','form_localisation','profondeurmax','table_observation','FORM');
INSERT INTO field_mapping VALUES ('profondeurmin','form_localisation','profondeurmin','table_observation','FORM');
INSERT INTO field_mapping VALUES ('profondeurmoyenne','form_localisation','profondeurmoyenne','table_observation','FORM');
INSERT INTO field_mapping VALUES ('PROVIDER_ID','form_autres','PROVIDER_ID','table_observation','FORM');
INSERT INTO field_mapping VALUES ('referencebiblio','form_standardisation','referencebiblio','table_observation','FORM');
INSERT INTO field_mapping VALUES ('refhabitat','form_localisation','refhabitat','table_observation','FORM');
INSERT INTO field_mapping VALUES ('sensible','form_standardisation','sensible','table_observation','FORM');
INSERT INTO field_mapping VALUES ('sensidateattribution','form_standardisation','sensidateattribution','table_observation','FORM');
INSERT INTO field_mapping VALUES ('sensiniveau','form_standardisation','sensiniveau','table_observation','FORM');
INSERT INTO field_mapping VALUES ('sensireferentiel','form_standardisation','sensireferentiel','table_observation','FORM');
INSERT INTO field_mapping VALUES ('sensiversionreferentiel','form_standardisation','sensiversionreferentiel','table_observation','FORM');
INSERT INTO field_mapping VALUES ('statutobservation','form_observation','statutobservation','table_observation','FORM');
INSERT INTO field_mapping VALUES ('statutsource','form_standardisation','statutsource','table_observation','FORM');
INSERT INTO field_mapping VALUES ('SUBMISSION_ID','form_autres','SUBMISSION_ID','table_observation','FORM');
INSERT INTO field_mapping VALUES ('typedenombrement','form_observation','typedenombrement','table_observation','FORM');
INSERT INTO field_mapping VALUES ('typeen','form_localisation','typeen','table_observation','FORM');
INSERT INTO field_mapping VALUES ('typeinfogeocommune','form_localisation','typeinfogeocommune','table_observation','FORM');
INSERT INTO field_mapping VALUES ('typeinfogeodepartement','form_localisation','typeinfogeodepartement','table_observation','FORM');
INSERT INTO field_mapping VALUES ('typeinfogeoen','form_localisation','typeinfogeoen','table_observation','FORM');
INSERT INTO field_mapping VALUES ('typeinfogeomaille','form_localisation','typeinfogeomaille','table_observation','FORM');
INSERT INTO field_mapping VALUES ('typeinfogeome','form_localisation','typeinfogeome','table_observation','FORM');
INSERT INTO field_mapping VALUES ('typeregroupement','form_regroupements','typeregroupement','table_observation','FORM');
INSERT INTO field_mapping VALUES ('validateuridentite','form_standardisation','validateuridentite','table_observation','FORM');
INSERT INTO field_mapping VALUES ('validateurmail','form_standardisation','validateurmail','table_observation','FORM');
INSERT INTO field_mapping VALUES ('validateurnomorganisme','form_standardisation','validateurnomorganisme','table_observation','FORM');
INSERT INTO field_mapping VALUES ('versionen','form_localisation','versionen','table_observation','FORM');
INSERT INTO field_mapping VALUES ('versionme','form_localisation','versionme','table_observation','FORM');
INSERT INTO field_mapping VALUES ('versionrefhabitat','form_localisation','versionrefhabitat','table_observation','FORM');
INSERT INTO field_mapping VALUES ('versionrefmaille','form_localisation','versionrefmaille','table_observation','FORM');
INSERT INTO field_mapping VALUES ('versiontaxref','form_observation','versiontaxref','table_observation','FORM');
INSERT INTO field_mapping VALUES ('sensimanuelle','form_standardisation','sensimanuelle','table_observation','FORM');
INSERT INTO field_mapping VALUES ('sensialerte','form_standardisation','sensialerte','table_observation','FORM');
INSERT INTO field_mapping VALUES ('codemaillecalcule','form_localisation','codemaillecalcule','table_observation','FORM');
INSERT INTO field_mapping VALUES ('codecommunecalcule','form_localisation','codecommunecalcule','table_observation','FORM');
INSERT INTO field_mapping VALUES ('nomcommunecalcule','form_localisation','nomcommunecalcule','table_observation','FORM');
INSERT INTO field_mapping VALUES ('codedepartementcalcule','form_localisation','codedepartementcalcule','table_observation','FORM');
INSERT INTO field_mapping VALUES ('heuredatedebut','form_observation','heuredatedebut','table_observation','FORM');
INSERT INTO field_mapping VALUES ('heuredatefin','form_observation','heuredatefin','table_observation','FORM');
INSERT INTO field_mapping VALUES ('tpsid','form_autres','tpsid','table_observation','FORM');
INSERT INTO field_mapping VALUES ('cdnomcalcule','form_observation','cdnomcalcule','table_observation','FORM');
INSERT INTO field_mapping VALUES ('cdrefcalcule','form_observation','cdrefcalcule','table_observation','FORM');
INSERT INTO field_mapping VALUES ('taxostatut','form_observation','taxostatut','table_observation','FORM');
INSERT INTO field_mapping VALUES ('taxomodif','form_observation','taxomodif','table_observation','FORM');
INSERT INTO field_mapping VALUES ('taxoalerte','form_observation','taxoalerte','table_observation','FORM');
INSERT INTO field_mapping VALUES ('USER_LOGIN','form_autres','USER_LOGIN','table_observation','FORM');
INSERT INTO field_mapping VALUES ('nomvalide','form_observation','nomvalide','table_observation','FORM');


-- INSERTION IN TABLE checks
INSERT INTO checks VALUES (1000,'COMPLIANCE','EMPTY_FILE_ERROR','Fichier vide.','Les fichiers ne doivent pas être vides.',NULL,'ERROR');
INSERT INTO checks VALUES (1001,'COMPLIANCE','WRONG_FIELD_NUMBER','Nombre de champs incorrect.','Le fichier doit contenir le bon nombre de champs, séparés par des points-virgules et aucun ne doit contenir de point-virgule.',NULL,'ERROR');
INSERT INTO checks VALUES (1002,'COMPLIANCE','INTEGRITY_CONSTRAINT','Contrainte d''intégrité non respectée.','La valeur de la clé étrangère n''existe pas dans la table mère.',NULL,'ERROR');
INSERT INTO checks VALUES (1003,'COMPLIANCE','UNEXPECTED_SQL_ERROR','Erreur SQL non répertoriée.','Erreur SQL non répertoriée, veuillez contacter l''administrateur.',NULL,'ERROR');
INSERT INTO checks VALUES (1004,'COMPLIANCE','DUPLICATE_ROW','Ligne dupliquée.','Ligne dupliquée. La donnée existe déjà.',NULL,'ERROR');
INSERT INTO checks VALUES (1101,'COMPLIANCE','MANDATORY_FIELD_MISSING','Champ obligatoire manquant.','Champ obligatoire manquant, veuillez indiquer une valeur.',NULL,'ERROR');
INSERT INTO checks VALUES (1102,'COMPLIANCE','INVALID_FORMAT','Format non respecté.','Le format du champ ne correspond pas au format attendu.',NULL,'ERROR');
INSERT INTO checks VALUES (1103,'COMPLIANCE','INVALID_TYPE_FIELD','Type de champ erroné.','Le type du champ ne correspond pas au type attendu.',NULL,'ERROR');
INSERT INTO checks VALUES (1104,'COMPLIANCE','INVALID_DATE_FIELD','Date erronée.','Le format de la date est erroné, veuillez respecter le format indiqué.',NULL,'ERROR');
INSERT INTO checks VALUES (1105,'COMPLIANCE','INVALID_CODE_FIELD','Code erroné.','Le code du champ ne correspond pas au code attendu.',NULL,'ERROR');
INSERT INTO checks VALUES (1106,'COMPLIANCE','INVALID_RANGE_FIELD','Valeur du champ hors limites.','La valeur du champ n''entre pas dans la plage attendue (min et max).',NULL,'ERROR');
INSERT INTO checks VALUES (1107,'COMPLIANCE','STRING_TOO_LONG','Chaîne de caractères trop longue.','La valeur du champ comporte trop de caractères.',NULL,'ERROR');
INSERT INTO checks VALUES (1108,'COMPLIANCE','UNDEFINED_COLUMN','Colonne indéfinie.','Colonne indéfinie.',NULL,'ERROR');
INSERT INTO checks VALUES (1109,'COMPLIANCE','NO_MAPPING','Pas de mapping pour ce champ.','Le champ dans le fichier n''a pas de colonne de destination dans une table en base.',NULL,'ERROR');
INSERT INTO checks VALUES (1110,'COMPLIANCE','TRIGGER_EXCEPTION','Valeur incorrecte.','La valeur donnée n''est pas reconnue et empêche l''exécution du code (remplissage automatique de champs).',NULL,'ERROR');
INSERT INTO checks VALUES (1111,'COMPLIANCE','INVALID_GEOMETRY','Géométrie invalide.','Le WKT de la géométrie n''est pas valide.',NULL,'ERROR');
INSERT INTO checks VALUES (1112,'COMPLIANCE','WRONG_GEOMETRY_TYPE','Mauvais type de géométrie.','Le type de la géométrie ne correspond pas au type attendu.',NULL,'ERROR');
INSERT INTO checks VALUES (1113,'COMPLIANCE','WRONG_GEOMETRY_SRID','Mauvais SRID pour la géométrie.','L''identifiant du système de coordonnées (srid) indiqué ne correspond pas à celui des données.',NULL,'ERROR');
INSERT INTO checks VALUES (1114,'COMPLIANCE','WRONG_FILE_FIELD_CSV_LABEL','Nom du champ incorrect.','Le nom de la colonne du fichier csv n''existe pas dans le modèle d''import.',NULL,'ERROR');
INSERT INTO checks VALUES (1115,'COMPLIANCE','DUPLICATED_FILE_LABEL','Des noms de colonnes sont en double.','Des noms de colonnes sont en double.',NULL,'ERROR');
INSERT INTO checks VALUES (1116,'COMPLIANCE','MANDATORY_HEADER_LABEL_MISSING','Colonne obligatoire manquante.','Colonne obligatoire manquante, veuillez l''ajouter à votre fichier.',NULL,'ERROR');
INSERT INTO checks VALUES (1200,'CONFORMITY','MANDATORY_CONDITIONAL_FIELDS','Champs obligatoires conditionnels manquants.','Champs obligatoires conditionnels manquants.',NULL,'ERROR');
INSERT INTO checks VALUES (1201,'CONFORMITY','ARRAY_OF_SAME_LENGTH','Tableaux n''ayant pas le même nombre d''éléments.','Tableaux n''ayant pas le même nombre d''éléments.',NULL,'ERROR');
INSERT INTO checks VALUES (1202,'CONFORMITY','TAXREF_VERSION','Version Taxref manquante.','Version Taxref manquante.',NULL,'ERROR');
INSERT INTO checks VALUES (1203,'CONFORMITY','BIBLIO_REF','Référence bibliographique manquante.','Référence bibliographique manquante.',NULL,'ERROR');
INSERT INTO checks VALUES (1204,'CONFORMITY','PROOF','Incohérence entre les champs de preuve.','Incohérence entre les champs de preuve.',NULL,'ERROR');
INSERT INTO checks VALUES (1205,'CONFORMITY','NUMERIC_PROOF_URL','PreuveNumerique n''est pas une url.','PreuveNumerique n''est pas une url.',NULL,'ERROR');
INSERT INTO checks VALUES (1206,'CONFORMITY','HABITAT','Incohérence entre les champs d''habitat.','Incohérence entre les champs d''habitat.',NULL,'ERROR');
INSERT INTO checks VALUES (1207,'CONFORMITY','NO_GEOREFERENCE','Géoréférencement manquant.','Géoréférencement manquant.',NULL,'ERROR');
INSERT INTO checks VALUES (1208,'CONFORMITY','MORE_THAN_ONE_GEOREFERENCE','Plusieurs géoréférencements.','Plusieurs géoréférencements.',NULL,'ERROR');
INSERT INTO checks VALUES (1209,'CONFORMITY','DATE_ORDER','Incohérence sur la chronologie des dates.','Incohérence sur la chronologie des dates.',NULL,'ERROR');


-- INSERTION IN TABLE dataset_fields
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','SUBMISSION_ID');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','PROVIDER_ID');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','OGAM_ID_table_observation');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','codecommune');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','nomcommune');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','anneerefcommune');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','typeinfogeocommune');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','denombrementmin');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','denombrementmax');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','objetdenombrement');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','typedenombrement');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','codedepartement');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','anneerefdepartement');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','typeinfogeodepartement');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','typeen');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','codeen');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','versionen');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','typeinfogeoen');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','refhabitat');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','codehabitat');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','versionrefhabitat');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','codehabref');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','codemaille');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','versionrefmaille');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','nomrefmaille');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','typeinfogeomaille');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','codeme');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','versionme');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','dateme');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','typeinfogeome');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','observateurnomorganisme');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','observateuridentite');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','observateurmail');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','determinateurnomorganisme');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','determinateuridentite');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','determinateurmail');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','validateurnomorganisme');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','validateuridentite');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','validateurmail');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','identifiantorigine');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','dspublique');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','diffusionniveauprecision');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','deefloutage');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','sensible');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','sensiniveau');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','sensidateattribution');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','sensireferentiel');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','sensiversionreferentiel');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','statutsource');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','jddcode');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','jddid');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','jddsourceid');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','jddmetadonneedeeid');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','organismegestionnairedonnee');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','codeidcnpdispositif');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','deedatedernieremodification');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','referencebiblio');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','orgtransformation');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','identifiantpermanent');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','statutobservation');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','nomcite');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','jourdatedebut');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','jourdatefin');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','altitudemin');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','altitudemax');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','profondeurmin');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','profondeurmax');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','cdnom');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','cdref');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','versiontaxref');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','datedetermination');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','organismestandard');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','commentaire');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','obsdescription');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','obsmethode');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','occetatbiologique');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','occstatutbiogeographique');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','occmethodedetermination');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','occnaturalite');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','occsexe');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','occstadedevie');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','occstatutbiologique');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','preuveexistante');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','preuvenonnumerique');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','preuvenumerique');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','obscontexte');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','identifiantregroupementpermanent');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','methoderegroupement');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','typeregroupement');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','altitudemoyenne');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','profondeurmoyenne');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','geometrie');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','natureobjetgeo');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','precisiongeometrie');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','sensimanuelle');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','sensialerte');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','codemaillecalcule');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','codecommunecalcule');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','nomcommunecalcule');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','codedepartementcalcule');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','heuredatedebut');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','heuredatefin');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','nomvalide');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','tpsid');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','cdnomcalcule');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','cdrefcalcule');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','taxostatut');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','taxomodif');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','taxoalerte');
INSERT INTO dataset_fields VALUES ('dataset_02','RAW_DATA','table_observation','USER_LOGIN');

-- INSERTION IN TABLE dataset_files
INSERT INTO dataset_files VALUES ('dataset_01','file_dbb');

-- INSERTION IN TABLE dataset_forms
INSERT INTO dataset_forms VALUES ('dataset_02','form_observation');
INSERT INTO dataset_forms VALUES ('dataset_02','form_localisation');
INSERT INTO dataset_forms VALUES ('dataset_02','form_regroupements');
INSERT INTO dataset_forms VALUES ('dataset_02','form_standardisation');
INSERT INTO dataset_forms VALUES ('dataset_02','form_autres');


-- INSERTION IN TABLE table_tree
INSERT INTO table_tree VALUES ('RAW_DATA','table_observation',NULL,NULL,NULL);


-- INSERTION IN TABLE translation
INSERT INTO translation VALUES ('table_observation','PROVIDER_ID','FR','Organisme','L''organisme');
INSERT INTO translation VALUES ('table_observation','SUBMISSION_ID','FR','Identifiant de soumission','L''identifiant de soumission');
INSERT INTO translation VALUES ('table_observation','OGAM_ID_table_observation','FR','Observation','L''identifiant de l''observation');
INSERT INTO translation VALUES ('table_observation','PROVIDER_ID','EN','The identifier of the provider','The identifier of the provider');
INSERT INTO translation VALUES ('table_observation','SUBMISSION_ID','EN','Submission ID','The identifier of a submission');
INSERT INTO translation VALUES ('table_observation','OGAM_ID_table_observation','EN','Observation','The identifier of a observation');


-- Fill the empty label and definition for the need of the tests
UPDATE translation t
   SET label= 'EN...' || t2.label
   FROM translation t2
 WHERE t.table_format = t2.table_format and t.row_pk = t2.row_pk and t.lang = 'EN' and t2.lang = 'FR' and t.label is null;

 UPDATE translation t
   SET definition= 'EN...' || t2.definition
   FROM translation t2
 WHERE t.table_format = t2.table_format and t.row_pk = t2.row_pk and t.lang = 'EN' and t2.lang = 'FR' and t.definition is null;

COMMIT;

--
-- Consistency checks
--

-- Units of type CODE should have an entry in the CODE table
SELECT UNIT, 'This unit of type CODE is not described in the MODE table'
FROM unit
WHERE (type = 'CODE' OR type = 'ARRAY')
AND subtype = 'MODE'
AND unit not in (SELECT UNIT FROM MODE WHERE MODE.UNIT=UNIT)
UNION
-- Units of type RANGE should have an entry in the RANGE table
SELECT UNIT, 'This unit of type RANGE is not described in the RANGE table'
FROM unit
WHERE TYPE = 'NUMERIC' AND SUBTYPE = 'RANGE'
AND unit not in (SELECT UNIT FROM RANGE WHERE RANGE.UNIT=UNIT)
UNION
-- File fields should have a FILE mapping
SELECT format||'_'||data, 'This file field has no FILE mapping defined'
FROM file_field
WHERE format||'_'||data NOT IN (
	SELECT (src_format||'_'||src_data )
	FROM field_mapping
	WHERE mapping_type = 'FILE'
	)
UNION
-- Form fields should have a FORM mapping
SELECT format||'_'||data, 'This form field has no FORM mapping defined'
FROM form_field
WHERE format||'_'||data NOT IN (
	SELECT (src_format||'_'||src_data )
	FROM field_mapping
	WHERE mapping_type = 'FORM'
	)
UNION
-- Raw data field should be mapped with harmonized fields
SELECT format||'_'||data, 'This raw_data table field is not mapped with an harmonized field'
FROM table_field
JOIN table_format using (format)
WHERE schema_code = 'RAW_DATA'
AND data <> 'SUBMISSION_ID'
AND data <> 'LINE_NUMBER'
AND format||'_'||data NOT IN (
	SELECT (src_format||'_'||src_data )
	FROM field_mapping
	WHERE mapping_type = 'HARMONIZE'
	)
UNION
-- Raw data field should be mapped with harmonized fields
SELECT format||'_'||data, 'This harmonized_data table field is not used by a mapping'
FROM table_field
JOIN table_format using (format)
WHERE schema_code = 'HARMONIZED_DATA'
AND column_name <> 'REQUEST_ID'  -- request ID added automatically
AND is_calculated <> '1'  -- field is not calculated
AND format||'_'||data NOT IN (
	SELECT (dst_format||'_'||dst_data )
	FROM field_mapping
	WHERE mapping_type = 'HARMONIZE'
	)
UNION
-- the SUBMISSION_ID field is mandatory for raw data tables
SELECT format, 'This raw table format is missing the SUBMISSION_ID field'
FROM table_format
WHERE schema_code = 'RAW_DATA'
AND NOT EXISTS (SELECT * FROM table_field WHERE table_format.format = table_field.format AND table_field.data='SUBMISSION_ID')
UNION
-- the INPUT_TYPE is not in the list
SELECT format||'_'||data, 'The INPUT_TYPE type is not in the list'
FROM form_field
WHERE input_type NOT IN ('TEXT', 'SELECT', 'DATE', 'GEOM', 'NUMERIC', 'CHECKBOX', 'MULTIPLE', 'TREE', 'TAXREF', 'IMAGE')
UNION
-- the UNIT type is not in the list
SELECT unit||'_'||type, 'The UNIT type is not in the list'
FROM unit
WHERE type NOT IN ('BOOLEAN', 'CODE', 'ARRAY', 'DATE', 'INTEGER', 'NUMERIC', 'STRING', 'GEOM', 'IMAGE')
UNION
-- the subtype is not consistent with the type
SELECT unit||'_'||type, 'The UNIT subtype is not consistent with the type'
FROM unit
WHERE (type = 'CODE' AND subtype NOT IN ('MODE', 'TREE', 'DYNAMIC', 'TAXREF'))
OR    (type = 'ARRAY' AND subtype NOT IN ('MODE', 'TREE', 'DYNAMIC'))
OR    (type = 'NUMERIC' AND subtype NOT IN ('RANGE', 'COORDINATE'))
UNION
-- the unit type is not consistent with the form field input type
SELECT form_field.format || '_' || form_field.data, 'The form field input type (' || input_type || ') is not consistent with the unit type (' || type || ')'
FROM form_field
LEFT JOIN data using (data)
LEFT JOIN unit using (unit)
WHERE (input_type = 'NUMERIC' AND type NOT IN ('NUMERIC', 'INTEGER'))
OR (input_type = 'DATE' AND type <> 'DATE')
OR (input_type = 'SELECT' AND NOT (type = 'ARRAY' or TYPE = 'CODE') AND (subtype = 'CODE' OR subtype = 'DYNAMIC'))
OR (input_type = 'TEXT' AND type <> 'STRING')
OR (input_type = 'CHECKBOX' AND type <> 'BOOLEAN')
OR (input_type = 'GEOM' AND type <> 'GEOM')
OR (input_type = 'IMAGE' AND type <> 'IMAGE')
OR (input_type = 'TREE' AND NOT ((type = 'ARRAY' or TYPE = 'CODE') AND subtype = 'TREE'))
UNION
-- TREE_MODEs should be defined
SELECT unit, 'The unit should have at least one MODE_TREE defined'
FROM unit
WHERE (type = 'CODE' OR type = 'ARRAY')
AND subtype = 'TREE'
AND (SELECT count(*) FROM mode_tree WHERE mode_tree.unit = unit.unit) = 0
UNION
-- DYNAMODEs should be defined
SELECT unit, 'The unit should have at least one DYNAMODE defined'
FROM unit
WHERE (type = 'CODE' OR type = 'ARRAY')
AND subtype = 'DYNAMIC'
AND (SELECT count(*) FROM dynamode WHERE dynamode.unit = unit.unit) = 0

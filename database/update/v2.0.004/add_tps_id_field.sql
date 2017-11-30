--fixme: ce script met à jour metadata_work pour le modèle DEE (qui joue le rôle de modèle de DSR.)
--il faut donc dépublier et republier le modèle DEE pour prendre en compte les modifications.

SET client_encoding = 'UTF8';

SET search_path = metadata_work, pg_catalog;

INSERT INTO data(data, unit, label, definition, comment)
    VALUES ('tpsid', 'Integer', 'tpsId', 'Identifiant TPS', 'Identifiant TPS');

INSERT INTO field VALUES ('tpsid', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('tpsid', 'form_autres', 'FORM');

INSERT INTO metadata_work.table_field VALUES ('tpsid', 'table_observation', 'tpsid', '1', '0', '1', '1', 104, NULL);

INSERT INTO metadata_work.form_field VALUES ('tpsid', 'form_autres', '1', '1', 'NUMERIC', 104, '0', '0', NULL, NULL, NULL);

INSERT INTO metadata_work.field_mapping VALUES ('tpsid', 'form_autres', 'tpsid', 'table_observation', 'FORM');

INSERT INTO metadata_work.dataset_fields VALUES ('dataset_02', 'RAW_DATA', 'table_observation', 'tpsid');

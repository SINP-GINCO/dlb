--#1299: Remove mandatory parameter for heuredatedebut and heuredatefin and set to calculated
UPDATE metadata_work.table_field SET is_calculated = '1', is_mandatory = '0' WHERE data IN('heuredatedebut', 'heuredatefin') AND format = 'table_observation';
UPDATE metadata_work.file_field SET is_mandatory = '0' WHERE data IN('heuredatedebut', 'heuredatefin') AND format = 'file_dbb';
UPDATE metadata.table_field SET is_calculated = '1', is_mandatory = '0' WHERE data IN('heuredatedebut', 'heuredatefin') AND format = 'table_observation';
UPDATE metadata.file_field SET is_mandatory = '0' WHERE data IN('heuredatedebut', 'heuredatefin') AND format = 'file_dbb';
-----------------------------------------------------------
--#1223 : Add new MANAGE_DATASETS_OTHER_PROVIDER permission
-----------------------------------------------------------

-- Create new permission
INSERT INTO website.permission (permission_code, permission_label) VALUES ('CANCEL_DATASET_PUBLICATION', 'Annuler le dépôt d''un jdd et dépublier les soumissions');
-- Add permission to dev role
INSERT INTO website.permission_per_role(role_code, permission_code) VALUES (1, 'CANCEL_DATASET_PUBLICATION');
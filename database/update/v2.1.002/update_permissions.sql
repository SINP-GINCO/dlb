INSERT INTO website.permission_per_role VALUES(
	(SELECT role_code FROM website.role WHERE role_label = 'Pétitionnaire'),
	'CANCEL_VALIDATED_SUBMISSION'
);

UPDATE website.permission SET 
	permission_group_code = 'JDD_MANAGEMENT',
	description = 'Annuler le dépôt d''un jeu de données et dépublier les soumissions.'
	WHERE permission_code = 'CANCEL_DATASET_PUBLICATION';

UPDATE website.permission SET 
	permission_group_code = 'JDD_MANAGEMENT',
	description = 'Visualiser les jeux de données ayant fait l''objet d''un dépôt légal.'
	WHERE permission_code = 'VIEW_PUBLISHED_DATASETS';
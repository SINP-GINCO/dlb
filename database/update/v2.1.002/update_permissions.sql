INSERT INTO website.permission_per_role VALUES(
	(SELECT role_code FROM website.role WHERE role_label = 'Pétitionnaire'),
	'CANCEL_VALIDATED_SUBMISSION'
);
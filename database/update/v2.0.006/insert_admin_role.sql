INSERT INTO website.role(role_code, role_label, role_definition, is_default) VALUES (2, 'Administrateur', 'Administrateur de plateforme', false);

INSERT INTO website.permission_per_role(role_code, permission_code) VALUES (2, 'MANAGE_USERS');
INSERT INTO website.permission_per_role(role_code, permission_code) VALUES (2, 'DATA_INTEGRATION');
INSERT INTO website.permission_per_role(role_code, permission_code) VALUES (2, 'DATA_QUERY');
INSERT INTO website.permission_per_role(role_code, permission_code) VALUES (2, 'DATA_QUERY_OTHER_PROVIDER');
INSERT INTO website.permission_per_role(role_code, permission_code) VALUES (2, 'EXPORT_RAW_DATA');
INSERT INTO website.permission_per_role(role_code, permission_code) VALUES (2, 'CANCEL_VALIDATED_SUBMISSION');
INSERT INTO website.permission_per_role(role_code, permission_code) VALUES (2, 'CANCEL_OTHER_PROVIDER_SUBMISSION');
INSERT INTO website.permission_per_role(role_code, permission_code) VALUES (2, 'CONFIGURE_METAMODEL');
INSERT INTO website.permission_per_role(role_code, permission_code) VALUES (2, 'VIEW_SENSITIVE');
INSERT INTO website.permission_per_role(role_code, permission_code) VALUES (2, 'VIEW_PRIVATE');
INSERT INTO website.permission_per_role(role_code, permission_code) VALUES (2, 'MANAGE_DATASETS');
INSERT INTO website.permission_per_role(role_code, permission_code) VALUES (2, 'MANAGE_DATASETS_OTHER_PROVIDER');
INSERT INTO website.permission_per_role(role_code, permission_code) VALUES (2, 'DATA_EDITION');
INSERT INTO website.permission_per_role(role_code, permission_code) VALUES (2, 'DATA_EDITION_OTHER_PROVIDER');
INSERT INTO website.permission_per_role(role_code, permission_code) VALUES (2, 'CONFIRM_SUBMISSION');
INSERT INTO website.permission_per_role(role_code, permission_code) VALUES (2, 'MANAGE_PUBLIC_REQUEST');
INSERT INTO website.permission_per_role(role_code, permission_code) VALUES (2, 'MANAGE_PRIVATE_REQUEST');
INSERT INTO website.permission_per_role(role_code, permission_code) VALUES (2, 'CONFIGURE_WEBSITE_PARAMETERS');
INSERT INTO website.permission_per_role(role_code, permission_code) VALUES (2, 'VIEW_PUBLISHED_DATASETS');

UPDATE website.role_to_user SET role_code = 2 WHERE user_login= 'jpanijel';
UPDATE website.role_to_user SET role_code = 2 WHERE user_login= 'nbotte';



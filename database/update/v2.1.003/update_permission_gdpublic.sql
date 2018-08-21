DELETE FROM website.permission_per_role ppr
WHERE ppr.permission_code = 'EXPORT_RAW_DATA'
and ppr.role_code in (SELECT role_code FROM website.role WHERE role_label = 'Grand public');

DELETE FROM website.permission_per_role 
WHERE permission_code = 'MANAGE_OWN_PROVIDER' ;
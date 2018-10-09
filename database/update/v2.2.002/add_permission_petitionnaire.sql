
 DELETE from  website.permission_per_role 
 WHERE role_code in (
    SELECT role_code FROM role
    WHERE role_label LIKE 'Pétitionnaire')
 AND permission_code LIKE 'MANAGE_JDD_SUBMISSION_OWN';
 
 DELETE from  website.permission_per_role 
 WHERE role_code in (
    SELECT role_code FROM role
    WHERE role_label LIKE 'Pétitionnaire')
 AND permission_code LIKE 'VIEW_SENSITIVE';
    
INSERT INTO website.permission_per_role(role_code, permission_code)
  (SELECT role_code, 'MANAGE_JDD_SUBMISSION_OWN' 
   FROM website.role
   WHERE  role_label LIKE 'Pétitionnaire');

INSERT INTO website.permission_per_role(role_code, permission_code)
  (SELECT role_code, 'VIEW_SENSITIVE' 
   FROM website.role
   WHERE  role_label LIKE 'Pétitionnaire');
  

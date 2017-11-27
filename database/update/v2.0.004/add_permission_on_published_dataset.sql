INSERT INTO website.permisssions(permission_code, permission_label) VALUES ('VIEW_PUBLISHED_DATASETS','Visualiser les jeux de données ayant fait l''objet d''un dépôt légal');

INSERT INTO website.permission_per_role(role_code, permission_code) 
 (SELECT role_code, 'VIEW_PUBLISHED_DATASETS'
    FROM website.permission_per_role 
   GROUP BY role_code)
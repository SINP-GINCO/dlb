INSERT INTO permission_per_role
  SELECT role_code, 'MANAGE_OWNED_PRIVATE_REQUEST'
  FROM website.role
  WHERE role_label = 'Administrateur';
  
INSERT INTO permission_per_role
  SELECT role_code, 'GENERATE_DEE_OWN_JDD'
  FROM website.role
  WHERE role_label = 'Administrateur';

INSERT INTO permission_per_role
  SELECT role_code, 'GENERATE_DEE_ALL_JDD'
  FROM website.role
  WHERE role_label = 'Administrateur';
 
INSERT INTO permission_per_role
  SELECT role_code, 'GENERATE_DEE_OWN_JDD'
  FROM website.role
  WHERE role_label = 'Pétitionnaire';

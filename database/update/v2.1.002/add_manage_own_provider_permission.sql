INSERT INTO website.permission_per_role
  SELECT role_code, 'MANAGE_OWN_PROVIDER'
  FROM website.role
  WHERE role_label IN ('Développeur', 'Administrateur', 'Pétitionnaire');
  
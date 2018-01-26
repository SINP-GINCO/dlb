INSERT INTO website.permission_per_role(role_code, permission_code)
  (select r.role_code, 'VIEW_PUBLISHED_DATASETS' from website.role r
  where not exists (
      select 1
      from website.permission_per_role pr
      where r.role_code = pr.role_code and pr.permission_code = 'VIEW_PUBLISHED_DATASETS'
  ));
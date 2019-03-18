INSERT INTO website.permission_per_role (
	SELECT r.role_code, 'VIEW_PRIVATE'
	FROM website."role" r
	WHERE r.role_code NOT IN (
		SELECT r.role_code 
		FROM website."role" 
		JOIN website.permission_per_role ppr ON r.role_code = ppr.role_code
		WHERE ppr.permission_code = 'VIEW_PRIVATE'
	)	
)


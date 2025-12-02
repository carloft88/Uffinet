
-- 1. Crear el nuevo rol de solo lectura
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Readonly_role' AND type = 'R')
BEGIN
    CREATE ROLE Readonly_role;
END
GO


-- 2. Asignar el rol fijo db_datareader al nuevo rol
-- Esto otorga permisos de solo lectura sobre todas las tablas del esquema
EXEC sp_addrolemember 'db_datareader', 'Readonly_role';
GRANT SELECT ON DATABASE::[bd-aqs-dev] TO Readonly_role;

-- 3. Otorgar permiso para crear vistas (asumiendo que 'Readonly_role' es un rol válido)
GRANT CREATE VIEW TO Readonly_role;
GRANT VIEW DEFINITION TO Readonly_role;
--4. Denegar acceso a esquemas sensibles (si aplica)

DENY ALTER ON SCHEMA::[dbo] TO Readonly_role;
DENY delete ON SCHEMA::[dbo] TO Readonly_role;
DENY update ON SCHEMA::[dbo] TO Readonly_role;
DENY select ON SCHEMA::[dbo] TO Readonly_role;
DENY insert ON SCHEMA::[dbo] TO Readonly_role;


-- Agregar el usuario al rol de solo lectura
ALTER ROLE [ReadOnly_Role] ADD MEMBER [Readonly_role];


SELECT  dp.create_Date,
    dr.name,dp.name AS UserName,
    dp.type_desc AS UserType
FROM sys.database_role_members drm
JOIN sys.database_principals dp 
    ON drm.member_principal_id = dp.principal_id
JOIN sys.database_principals dr 
    ON drm.role_principal_id = dr.principal_id
WHERE dr.name = 'Readonly_role'
order by dp.create_DAte;

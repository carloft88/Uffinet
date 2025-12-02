--Cambio
-- 1. Crear el rol si aún no existe.
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Dev_role' AND type = 'R')
BEGIN
    CREATE ROLE Dev_role;
END
GO


-- 2.  Asignar permisos 
    -- Permisos de CREATE de objetos (CREATE FUNCTION, CREATE PROCEDURE, etc.)
    -- Estos permisos son a nivel de base de datos, no por esquema.
    GRANT CREATE FUNCTION TO Dev_role;
    GRANT CREATE PROCEDURE TO Dev_role;
    GRANT CREATE SCHEMA TO Dev_role;
    GRANT CREATE TABLE TO Dev_role;
    GRANT CREATE VIEW TO Dev_role;
    GRANT ALTER TO Dev_role;
    GRANT DELETE  TO Dev_role;
    GRANT INSERT TO Dev_role;
    GRANT SELECT TO Dev_role;
    GRANT UPDATE TO Dev_role;
    GRANT CREATE VIEW TO Dev_role;
    GRANT EXECUTE TO Dev_role;
    GRANT CREATE TYPE TO Dev_role;
    GRANT REFERENCES TO Dev_role; 
    GRANT VIEW DEFINITION  TO Dev_role; 
-- ===========================================
-- 5. Restricción: Denegar alteración en esquema dbo
-- ===========================================
    DENY ALTER ON SCHEMA::[dbo] TO Dev_role;
    DENY delete ON SCHEMA::[dbo] TO Dev_role;
    DENY update ON SCHEMA::[dbo] TO Dev_role;
    DENY insert ON SCHEMA::[dbo] TO Dev_role;
  GO

    SELECT  dp.create_Date,
    dr.name,dp.name AS UserName,
    dp.type_desc AS UserType
FROM sys.database_role_members drm
JOIN sys.database_principals dp 
    ON drm.member_principal_id = dp.principal_id
JOIN sys.database_principals dr 
    ON drm.role_principal_id = dr.principal_id
WHERE dr.name = 'Dev_role'
order by dp.create_DAte;
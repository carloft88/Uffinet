-- 1. Crear el rol ExportBackup_Role si no existe
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'ExportBackup_Role' AND type = 'R')
BEGIN
    CREATE ROLE ExportBackup_Role;
END
GO

-- 2. Otorgar permisos necesarios al rol
-- Permite ver estructura y datos (requerido para exportar .bacpac)
GRANT SELECT TO ExportBackup_Role;
GRANT VIEW DEFINITION TO ExportBackup_Role;
GRANT EXECUTE TO ExportBackup_Role;

-- 3. Agregar el rol a db_owner (recomendado para exportación completa)
EXEC sp_addrolemember 'db_owner', 'ExportBackup_Role';
GO

--ALTER ROLE ExportBackup_Role ADD MEMBER [marc.next@ufinet.com];
--GO

SELECT  dp.create_Date,
    dr.name,dp.name AS UserName,
    dp.type_desc AS UserType
FROM sys.database_role_members drm
JOIN sys.database_principals dp 
    ON drm.member_principal_id = dp.principal_id
JOIN sys.database_principals dr 
    ON drm.role_principal_id = dr.principal_id
WHERE dr.name = 'ExportBackup_Role'
order by dp.create_DAte;



USE master;
GO

CREATE LOGIN export_backup_user  WITH PASSWORD = ',D7FD$7ZM9a2';
GO

--EN BD app_aut_qa12


CREATE USER export_backup_user FOR LOGIN export_backup_user;
EXEC sp_addrolemember 'ExportBackup_Role', 'export_backup_user';
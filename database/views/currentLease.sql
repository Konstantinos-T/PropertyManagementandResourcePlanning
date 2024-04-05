CREATE VIEW infoSysGruppe3_currentLease AS
SELECT * FROM infoSysGruppe3_lease
WHERE
    endDate > GETDATE() OR endDate IS NULL
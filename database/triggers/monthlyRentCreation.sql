-- This trigger checks at CSV import if the rent already has been booked, if not it will book the rent for the
-- month(s) in which it has not been booked yet.

CREATE TRIGGER infoSysGruppe3_monthlyRentCreation ON infoSysGruppe3_transaction
AFTER INSERT
AS
-- If the monthly lease costs aren't created yet, create them for each tenant
IF (SELECT COUNT(*) FROM infoSysGruppe3_monthlyTargetCreated WHERE MONTH(creationTime) = MONTH(GETDATE())) = 0
BEGIN
    -- set this month as done
    INSERT INTO infoSysGruppe3_monthlyTargetCreated (creationTime) VALUES ((SELECT GETDATE()));
    
    DECLARE TriggerMonthlyRentCreationCursor CURSOR FOR
    SELECT tenantId, rent, paymentPeriod FROM infoSysGruppe3_currentLease
    DECLARE @tenantId int, @rent float, @paymentPeriod int
    OPEN TriggerMonthlyRentCreationCursor;
    FETCH NEXT FROM TriggerMonthlyRentCreationCursor INTO @tenantId,  @rent, @paymentPeriod 
    
    -- if paymentPeriod of tenant is matched, e.g. eacht 3 months, create the lease cost centers
    IF MONTH(GETDATE()) % @paymentPeriod = 0
    WHILE @@FETCH_STATUS = 0
        BEGIN
            INSERT INTO infoSysGruppe3_mappedTransaction (tenantId, amount, transactionReason, transactionDate) 
            VALUES (
                @tenantId, 
                @rent * -1,
                'Rent for ' + (SELECT FORMAT(GETDATE(), 'MMMM yyyy')),
                GETDATE()
            );
            FETCH NEXT FROM TriggerMonthlyRentCreationCursor INTO @tenantId,  @rent, @paymentPeriod 
        END;
    CLOSE TriggerMonthlyRentCreationCursor;
    DEALLOCATE TriggerMonthlyRentCreationCursor;
END
-- This trigger maps the transactional data to the tenants by going through a set of rules (IF queries)
-- It is triggered as soon as CSV data is imported. This way the transactions of the systems are automatically up to
-- date


CREATE TRIGGER infoSysGruppe3_mapTransactionTrigger ON infoSysGruppe3_transaction
AFTER INSERT
AS
DECLARE TriggerMapTransactionCursor CURSOR FOR

SELECT amount, beneficialPayee, bookingText, purpose, transactionId, created FROM Inserted
DECLARE @amount float, @beneficialPayee varchar(45), @bookingText varchar(45), @purpose varchar(45), @transactionId int, @created DATE
OPEN TriggerMapTransactionCursor;
FETCH NEXT FROM TriggerMapTransactionCursor INTO @amount, @beneficialPayee, @bookingText, @purpose, @transactionId, @created 
WHILE @@FETCH_STATUS = 0
    BEGIN

        -- IF last name is in purpose
        IF 
            1 = (SELECT COUNT(*) FROM infoSysGruppe3_person WHERE CHARINDEX(lastName, @purpose) > 0)
        AND
            0 = (SELECT COUNT (*) FROM infoSysGruppe3_mappedTransaction WHERE transactionId = @transactionId)
        AND
            @amount > 0
        INSERT INTO infoSysGruppe3_mappedTransaction (tenantId, transactionTypeId, transactionId, amount, transactionReason, transactionDate) 
        VALUES (
            (SELECT personId FROM infoSysGruppe3_person WHERE CHARINDEX(lastName, @purpose) >0), 
            (SELECT transactionTypeId FROM infoSysGruppe3_transactionType WHERE transactionName like '%' + @bookingText + '%'),
            @transactionId,
            @amount,
            'Rent by last name in purpose',
            @created);

        -- IF benificial Payee name is in purpose
        IF 
            1 = (SELECT COUNT(*) FROM infoSysGruppe3_person WHERE CHARINDEX(lastName, @beneficialPayee) > 0)
        AND
            0 = (SELECT COUNT (*) FROM infoSysGruppe3_mappedTransaction WHERE transactionId = @transactionId)
        AND 
            @amount > 0
        INSERT INTO infoSysGruppe3_mappedTransaction (tenantId, transactionTypeId, transactionId, amount, transactionReason, transactionDate) 
        VALUES (
            (SELECT personId FROM infoSysGruppe3_person WHERE CHARINDEX(lastName, @beneficialPayee) > 0), 
            (SELECT transactionTypeId FROM infoSysGruppe3_transactionType WHERE transactionName like '%' + @bookingText + '%'),
            @transactionId,
            @amount,
            'Rent by last name in benificial payee',
            @created);

        -- if address is matched -> divide amount
        IF
            @amount < 0
        AND
            (SELECT COUNT(*) FROM infoSysGruppe3_property WHERE CHARINDEX(street, @purpose) > 0) > 0
        BEGIN
            DECLARE @totalPersonsOfAddress INT;
            SET @totalPersonsOfAddress = (SELECT SUM(numberOfResidents) FROM infoSysGruppe3_currentLease JOIN infoSysGruppe3_property ON infoSysGruppe3_currentLease.propertyId = infoSysGruppe3_property.propertyId WHERE CHARINDEX(street, @purpose) > 0); 

            DECLARE @totalSquareMeterOfAddress FLOAT;
            SET @totalSquareMeterOfAddress = (SELECT SUM(squareMeter) FROM infoSysGruppe3_currentLease JOIN infoSysGruppe3_property ON infoSysGruppe3_currentLease.propertyId = infoSysGruppe3_property.propertyId WHERE CHARINDEX(street, @purpose) > 0); 

            DECLARE @amountPerPerson FLOAT;
            SET @amountPerPerson = @amount / @totalPersonsOfAddress;

            DECLARE @calculationTypeId INT;
            SET @calculationTypeId = (SELECT calculationTypeId FROM infoSysGruppe3_calculationBase WHERE CHARINDEX(creditorName, @beneficialPayee) > 0);

            DECLARE FlatCursor CURSOR FOR
                SELECT tenantId, leaseId, squareMeter
                    FROM infoSysGruppe3_property JOIN infoSysGruppe3_currentLease ON infoSysGruppe3_currentLease.propertyId = infoSysGruppe3_property.propertyId 
                WHERE 
                    CHARINDEX(street, @purpose) > 0

                DECLARE @tenantId INT, @leaseId INT, @squareMeter FLOAT
                OPEN FlatCursor;
                FETCH NEXT FROM FlatCursor INTO @tenantId, @leaseId, @squareMeter
                WHILE @@FETCH_STATUS = 0
                    BEGIN

                        DECLARE @amountToPay FLOAT;

                        IF @calculationTypeId = 1 -- divide by amount of person
                            SET @amountToPay = @amountPerPerson * (SELECT numberOfResidents FROM infoSysGruppe3_currentLease WHERE leaseId = @leaseId);
                        ELSE -- divide by squareMeter
                            SET @amountToPay = @amount * (@squareMeter/@totalSquareMeterOfAddress);

                        INSERT INTO 
                            infoSysGruppe3_mappedTransaction (tenantId, transactionTypeId, transactionId, calculationBaseId, amount, transactionReason, transactionDate) 
                        VALUES (
                            @tenantId, 
                            (SELECT transactionTypeId FROM infoSysGruppe3_transactionType WHERE transactionName like '%' + @bookingText + '%'),
                            @transactionId,
                            (SELECT calculationBaseId FROM infoSysGruppe3_calculationBase WHERE CHARINDEX(creditorName, @beneficialPayee) > 0),
                            ROUND(@amountToPay, 2),
                            'share of ' +  @beneficialPayee,
                            @created);
                    
                    FETCH NEXT FROM FlatCursor INTO @tenantId, @leaseId, @squareMeter
                END;
            CLOSE FlatCursor;
            DEALLOCATE FlatCursor;
        END
        FETCH NEXT FROM TriggerMapTransactionCursor INTO @amount, @beneficialPayee, @bookingText, @purpose, @transactionId, @created
    END;
CLOSE TriggerMapTransactionCursor;
DEALLOCATE TriggerMapTransactionCursor;
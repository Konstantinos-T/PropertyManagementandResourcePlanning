-- Procedure to import transactions from the import CSV into the database.

CREATE PROCEDURE infoSysGruppe3_importTransaction(@_created AS  DATE, @_bookingText VARCHAR(45), @_purpose VARCHAR(45), @_beneficialPayee VARCHAR(45), @_amount FLOAT)
AS
BEGIN 

IF NOT EXISTS
	(SELECT * FROM infoSysGruppe3_transaction 
		   WHERE created = @_created
		   AND bookingText = @_bookingText
		   AND purpose = @_purpose
		   AND beneficialPayee = @_beneficialPayee
		   AND amount = @_amount
	)

	INSERT INTO infoSysGruppe3_transaction
		(created, bookingText, purpose, beneficialPayee, amount)
	VALUES
        (@_created, @_bookingText, @_purpose, @_beneficialPayee, @_amount);

END
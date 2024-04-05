-- Procedure to insert a new property in the GUI

CREATE procedure infoSysGruppe3_insertProperty(@squareMeter float,
                                               @ownerID int,
                                               @propertyTypeId int,
                                               @street varchar(45),
                                               @zipCode int,
                                               @city varchar(45),
                                               @country varchar(45),
                                               @description varchar(45),
                                               @streetNo varchar(10))
AS
BEGIN
    INSERT INTO infoSysGruppe3_property (squareMeter,
                                         ownerId,
                                         propertyTypeId,
                                         street,
                                         zipCode,
                                         city,
                                         country,
                                         description,
                                         streetNo)
    VALUES (@squareMeter,
            @ownerID,
            @propertyTypeId,
            @street,
            @zipCode,
            @city,
            @country,
            @description,
            @streetNo);
end
go


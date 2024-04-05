-- Procedure to update a property in the GUI

CREATE PROCEDURE infoSysGruppe3_propertyUpdate(
    @propertyId int,
    @squareMeter float,
    @ownerId int,
    @managerId int,
    @propertyTypeId int,
    @street varchar(45),
    @zipCode int,
    @city varchar(45),
    @country varchar(45),
    @description varchar(45),
    @streetNo varchar(10)
)
    AS
BEGIN

UPDATE infoSysGruppe3_property
SET squareMeter    = @squareMeter,
    ownerId        = @ownerId,
    managerId      = @managerId,
    propertyTypeId = @propertyTypeId,
    street         = @street,
    zipCode        = @zipCode,
    city           = @city,
    country        = @country,
    description    = @description,
    streetNo       = @streetNo
WHERE propertyId = @propertyId;

end
go


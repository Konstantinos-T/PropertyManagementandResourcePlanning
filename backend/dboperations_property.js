var config = require("./dbconfig");
const sql = require("mssql");

//GET all Propertys
const getProperties = async () => {
    let pool = await sql.connect(config);
    let properties = await pool.request().query("SELECT * FROM infosysGruppe3_property");
    return properties.recordsets;
};

//GET one specific property
const getProperty = async (propertyId) => {
    let pool = await sql.connect(config);
    let property = await pool
        .request()
        .input("input_paramater", sql.Int, propertyId)
        .query("SELECT * FROM infosysGruppe3_property WHERE propertyId = @input_paramater");
    return property.recordsets;
};

//Add a property to the list of properties
//Here with a Stored procedure Named insertProperty
const addProperty = async (property) => {
    //create connection to database
    let pool = await sql.connect(config);

    await pool
        .request()
        //create a new property with this parameters.
        .input("ownerId", sql.Int, property.ownerId)
        .input("propertyTypeId", sql.Int, 1)
        .input("description", sql.VarChar(300), property.description)
        .input("squareMeter", sql.Float, property.squareMeter)
        .input("street", sql.VarChar(45), property.street)
        .input("streetNo", sql.VarChar(10), property.streetNo)
        .input("zipCode", sql.Int, property.zipCode)
        .input("city", sql.VarChar(45), property.city)
        .input("country", sql.VarChar(45), property.country)
        //With .execute we execute the Stored procedure
        .execute("infoSysGruppe3_insertProperty");
};

//Update a Property by ID
const updateProperty = async (propertyId, property) => {
    //create connection to database
    let pool = await sql.connect(config);

    let updateProperty = await pool
        .request()
        //update a property with this parameters.
        .input("propertyId", sql.Int, propertyId)
        .input("squareMeter", sql.Float, property.squareMeter)
        .input("ownerId", sql.Int, property.ownerId)
        .input("managerId", sql.Int, property.managerId)
        .input("propertyTypeId", sql.Int, property.propertyTypeId)
        .input("street", sql.VarChar(45), property.street)
        .input("zipCode", sql.Int, property.zipCode)
        .input("city", sql.VarChar(45), property.city)
        .input("country", sql.VarChar(45), property.country)
        .input("description", sql.VarChar(300), property.description)
        .input("streetNo", sql.VarChar(10), property.streetNo)
        //With .execute we execute the Stored procedure
        .execute("infoSysGruppe3_propertyUpdate");
    return updateProperty.recordsets;
};

//Delete property from database with given parameters id
const deleteProperty = async (propertyId) => {
    let pool = await sql.connect(config);
    let deleteProperty = await pool
        .request()
        .input("input_paramater", sql.Int, propertyId)
        .query("DELETE FROM infosysGruppe3_property WHERE propertyId = @input_paramater");
    return deleteProperty.recordsets;
};


//Export all functions
module.exports = {
    getProperties: getProperties,
    getProperty: getProperty,
    addProperty: addProperty,
    updateProperty: updateProperty,
    deleteProperty: deleteProperty,
};

var config = require("./dbconfig");
const sql = require("mssql");

//GET all Propertys
const getOwners = async () => {
    let pool = await sql.connect(config);
    let properties = await pool.request().query("SELECT DISTINCT ownerId, firstname, lastname, dateOfBirth FROM infosysGruppe3_person JOIN infosysGruppe3_property ON personId=ownerId");
    return properties.recordsets;
};

//Export all functions
module.exports = {
    getOwners: getOwners,
};

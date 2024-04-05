var config = require("./dbconfig");
const sql = require("mssql");

//GET all Propertys
const getManagers = async () => {
    let pool = await sql.connect(config);
    let properties = await pool.request().query("SELECT DISTINCT firstname, lastname, dateOfBirth FROM infosysGruppe3_person JOIN infosysGruppe3_property ON personId=managerId");
    return properties.recordsets;
};

//Export all functions
module.exports = {
  getManagers: getManagers,
};
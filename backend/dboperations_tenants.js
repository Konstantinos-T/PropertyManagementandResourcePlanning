var config = require("./dbconfig");
const sql = require("mssql");

//GET all Propertys
const getTenants = async () => {
  let pool = await sql.connect(config);
  let properties = await pool.request().query("SELECT DISTINCT infosysGruppe3_lease.tenantId, firstname, lastname, dateOfBirth, ROUND(balance, 2) AS balance FROM infosysGruppe3_person JOIN infosysGruppe3_lease ON personId=tenantId LEFT JOIN (SELECT tenantId, SUM(amount) AS balance FROM infoSysGruppe3_mappedTransaction GROUP BY tenantId) AS t1 ON t1.tenantId = personId");
  return properties.recordsets;
};

//Export all functions
module.exports = {
  getTenants: getTenants,
};

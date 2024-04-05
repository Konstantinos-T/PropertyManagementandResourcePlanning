var config = require("./dbconfig");
const sql = require("mssql");

//GET all Propertys
const getTransactions = async () => {
    let pool = await sql.connect(config);
    let properties = await pool.request().query("SELECT * FROM infosysGruppe3_transaction");
    return properties.recordsets;
};

const getTransactionsOfTenant = async (tenantId) => {
    let pool = await sql.connect(config);
    let transactions = await pool.request().query("SELECT * FROM infosysGruppe3_mappedTransaction WHERE tenantId=" + tenantId);
    return transactions.recordsets;
};

const getTransactionsOfTenantMonthYear = async (tenantId, month, year) => {
    let pool = await sql.connect(config);
    let transactions = await pool.request().query(`
SELECT 
    firstName,
    lastName,
    dateOfBirth,
    city,
    zipCode,
    country,
    street,
    streetNo,
    amount,
    transactionReason,
    transactionDate
FROM 
    infoSysGruppe3_mappedTransaction 
JOIN 
    infoSysGruppe3_person ON personId = infoSysGruppe3_mappedTransaction.tenantId 
LEFT JOIN -- get the rented property of the selected month, as the rented property can change over time
    (
        SELECT infoSysGruppe3_lease.tenantId, city, zipCode, country, street, streetNo FROM
            infoSysGruppe3_lease
        LEFT JOIN
            infoSysGruppe3_property ON infoSysGruppe3_lease.propertyId = infoSysGruppe3_property.propertyId
        WHERE
            (MONTH(startDate) <= ${month} AND YEAR(startDate) <= ${year})
            AND
            (endDate IS NULL OR (MONTH(endDate) >= ${month} AND YEAR(startDate) >= ${year}))

    ) AS t1 ON t1.tenantId =  infoSysGruppe3_mappedTransaction.tenantId
WHERE MONTH(transactionDate) = ${month} AND YEAR(transactionDate) = ${year} AND infoSysGruppe3_mappedTransaction.tenantId = ${tenantId}
    `);
    return transactions.recordsets;
};

const addTransactions = async (csvData) => {
    try {
        const transactions = Object.keys(csvData)[0].split("\n");
        transactions.shift();

        let csvEntrys = 0;
        let rowsAffected = 0;

        for (const transaction of transactions) {
            let transactionParams = transaction.split(";");

            if (transactionParams.length != 6)
                continue;

            csvEntrys++;
            let pool = await sql.connect(config);

            let updateProperty = await pool
                .request()
                //create a new property with this parameters.
                .input("_created", sql.Date, transactionParams[0])
                .input("_bookingText", sql.VarChar(45), transactionParams[2])
                .input("_purpose", sql.VarChar(45), transactionParams[3])
                .input("_beneficialPayee", sql.VarChar(45), transactionParams[4])
                .input("_amount", sql.Float, transactionParams[5].replace(',', '.'))
                //With .execute we execute the Stored procedure
                .execute("infoSysGruppe3_importTransaction");

            if (updateProperty["rowsAffected"].length > 0)
                rowsAffected++;
        }

        let responseMessage = `${rowsAffected} of ${csvEntrys} csv rows imported.`;

        return responseMessage;
    } catch (e) {
        console.log(e);
        return e;
    }
}

//Export all functions
module.exports = {
    getTransactions: getTransactions,
    getTransactionsOfTenant: getTransactionsOfTenant,
    addTransactions: addTransactions,
    getTransactionsOfTenantMonthYear,
};

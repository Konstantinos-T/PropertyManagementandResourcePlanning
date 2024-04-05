//Configuration for mssql
const config = {
    user : 'wkb4',
    password : 'wkb4',
    database : 'WKB4_DB2_Projekt',
    server : 'ITNT0005',
    port : 1433,
    options: {
        encrypt: false, // for azure
        trustServerCertificate: true // change to true for local dev / self-signed certs
      }
}

module.exports = config;
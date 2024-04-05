//Use Dotenv to create an configuration file with environment variables.
require('dotenv').config()
var dboperations_property = require('./dboperations_property');
var dboperations_tenant = require('./dboperations_tenants');
var dboperations_manager = require('./dboperations_manager');
var dboperations_owners = require('./dboperations_owners');
var dboperations_transactions = require('./dboperations_transactions');
var property = require('./property');

//API Dependencies.
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');

//instantiate middleware.
var app = express();
var router = express.Router();

//Define the middleware.
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(cors());
app.use('/api', router);

//Define port from config file or if not defined get the default port.
var port = process.env.APIPORT || 5005;


//Create middleware they get called everytime, just to be able to handle authentication.
router.get('/', (req, res, next) => {
    console.log('middleware');
    next();
})

//Create route to get all properties.
router.route('/property').get((request, response) => {

    dboperations_property.getProperties().then((result) => {
        response.json(result[0]);
    }).catch(() => response.status(500).send())
})

router.route('/property/:id').get((request, response) => {

    dboperations_property.getProperty(request.params.id).then((result) => {
        response.json(result[0]);
    }).catch(() => response.status(500).send())
})

router.route('/property').post((request, response) => {

    let propertyData = { ...request.body } //destructure the movies object

    dboperations_property.addProperty(propertyData)
        .then(() => response.status(201).send())
        .catch(() => response.status(500).send())
})

router.route('/property/:id').put((request, response) => {

    let id = request.params.id      //get id from params 
    let propertyData = { ...request.body }  //destructure the movies object

    dboperations_property.updateProperty(id, propertyData)
        .then(() => response.status(201).send())
        .catch(() => response.status(500).send())
})

router.route('/property/:id').delete((request, response) => {

    let id = request.params.id //get id from params

    dboperations_property.deleteProperty(id)
        .then(() => response.status(204).send())
        .catch(() => response.status(500).send())
})

router.route('/tenants').get((request, response) => {

    try {
        dboperations_tenant.getTenants().then((result) => {
            response.json(result[0]);
        })
    } catch (error) {
        response.status(500).send()
    }

})

router.route('/manager').get((request, response) => {

    try {
        dboperations_manager.getManagers().then((result) => {
            response.json(result[0]);
        })
    } catch (error) {
        response.status(500).send()
    }
})

router.route('/owners').get((request, response) => {

    try {
        dboperations_owners.getOwners().then((result) => {
            response.json(result[0]);
        })
    } catch (error) {
        response.status(500).send()
    }
})

router.route('/transactions').get((request, response) => {

    try {
        dboperations_transactions.getTransactions().then((result) => {
            response.json(result[0]);
        })
    } catch (error) {
        response.status(500).send()
    }
})

router.route('/transactions/:tenantId').get((request, response) => {

    try {
        dboperations_transactions.getTransactionsOfTenant(request.params.tenantId).then((result) => {
            response.json(result[0]);
        })
    } catch (error) {
        response.status(500).send()
    }
})

router.route('/transactions/:tenantId/:month/:year').get((request, response) => {

    try {
        dboperations_transactions.getTransactionsOfTenantMonthYear(request.params.tenantId, request.params.month, request.params.year).then((result) => {
            response.json(result[0]);
        })
    } catch (error) {
        console.log(error)
        response.status(500).send()
    }
})

router.route('/importCSV').post((request, response) => {

    let csvData = request.body

    dboperations_transactions.addTransactions(csvData).then((result) => {
        response.status(201).json(result);
    })
})

router.route('/getPdf/:tenantId').get((request, response) => {

    dboperations_transactions.getPdfOfTenant(request.params.tenantId).then((link) => {
        response.json(link);
    }).catch((error) => {
        response.status(500).send()
    })
})


app.listen(port);
console.log('listening on port ' + port);

class Property {
    constructor(propertyId, description, squaremeter, street, streetNo, zipCode, city, country){
        this.propertyId = propertyId;
        this.description = description;
        this.squaremeter = squaremeter;
        this.street = street;
        this.streetNo = streetNo;
        this.zipCode = zipCode;
        this.city = city;
        this.country = country;
    }
}

module.exports = Property;
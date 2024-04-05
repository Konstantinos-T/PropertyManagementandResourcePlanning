-- inserting sample data into the database tables
INSERT INTO infoSysGruppe3_calculationType(name) VALUES ('per Head');
INSERT INTO infoSysGruppe3_calculationType(name) VALUES ('per Squaremeter');

INSERT INTO infoSysGruppe3_propertyType (propertyName) VALUES ('house');
INSERT INTO infoSysGruppe3_propertyType (propertyName) VALUES ('moreFamilyHouse');

INSERT INTO infoSysGruppe3_transactionType (transactionName) VALUES ('Lastschrift');
INSERT INTO infoSysGruppe3_transactionType (transactionName) VALUES ('Ueberweisungsgutschrift');
INSERT INTO infoSysGruppe3_transactionType (transactionName) VALUES ('Dauerauftrag');
INSERT INTO infoSysGruppe3_transactionType (transactionName) VALUES ('SDIREKT-Ueberweisung');

INSERT INTO infoSysGruppe3_person (firstName, lastName, dateOfBirth) VALUES ('Max', 'Mustermann', '1970-11-02');
INSERT INTO infoSysGruppe3_person (firstName, lastName, dateOfBirth) VALUES ('Beate', 'Raiber', '1994-01-07');
INSERT INTO infoSysGruppe3_person (firstName, lastName, dateOfBirth) VALUES ('Michaela', 'Braun', '1952-05-12');
INSERT INTO infoSysGruppe3_person (firstName, lastName, dateOfBirth) VALUES ('Christoph', 'Metzacker', '1915-04-19');
INSERT INTO infoSysGruppe3_person (firstName, lastName, dateOfBirth) VALUES ('Markus', 'Mueller', '1979-04-06');
INSERT INTO infoSysGruppe3_person (firstName, lastName, dateOfBirth) VALUES ('Edgar', 'Haefele', '1955-10-30');
INSERT INTO infoSysGruppe3_person (firstName, lastName, dateOfBirth) VALUES ('Ben', 'Haug', '1980-12-27');
INSERT INTO infoSysGruppe3_person (firstName, lastName, dateOfBirth) VALUES ('Paul', 'Koslowski', '1967-03-07');
INSERT INTO infoSysGruppe3_person (firstName, lastName, dateOfBirth) VALUES ('Bernd', 'Barni', '1979-09-19');
INSERT INTO infoSysGruppe3_person (firstName, lastName, dateOfBirth) VALUES ('Dieter', 'Mann', '1966-08-20');
INSERT INTO infoSysGruppe3_person (firstName, lastName, dateOfBirth) VALUES ('Peter', 'Riester', '1970-04-03');
INSERT INTO infoSysGruppe3_person (firstName, lastName, dateOfBirth) VALUES ('Moritz', 'Gruner', '1990-07-09');
INSERT INTO infoSysGruppe3_person (firstName, lastName, dateOfBirth) VALUES ('Angelika', 'Stich', '1994-03-04');

INSERT INTO infoSysGruppe3_calculationBase(creditorName, calculationTypeId) VALUES ('ENBW', 1);
INSERT INTO infoSysGruppe3_calculationBase(creditorName, calculationTypeId) VALUES ('COSMOSDIREKT', 1);
INSERT INTO infoSysGruppe3_calculationBase(creditorName, calculationTypeId) VALUES ('STADT ESSLINGEN', 1);
INSERT INTO infoSysGruppe3_calculationBase(creditorName, calculationTypeId) VALUES ('HAUS UND GRUND E.V.', 1);
INSERT INTO infoSysGruppe3_calculationBase(creditorName, calculationTypeId) VALUES ('FA ESSLINGEN', 2);
INSERT INTO infoSysGruppe3_calculationBase(creditorName, calculationTypeId) VALUES ('HAUG GAS WASSER SCHUTT', 1);

INSERT INTO infoSysGruppe3_property (squareMeter, ownerId, managerId, propertyTypeId, street, streetNo, zipCode, city, country, description) VALUES ('534.67', '1', '4', '2', 'Flandernstreet', '11', '73013', 'Esslingen', 'Germany', 'Big House');
INSERT INTO infoSysGruppe3_property (squareMeter, ownerId, managerId, propertyTypeId, street, streetNo, zipCode, city, country, description) VALUES ('50', '1', '4', '1', 'Kanalstreet','23', '73013', 'Esslingen', 'Germany', 'Tiny House');
INSERT INTO infoSysGruppe3_property (squareMeter, ownerId, managerId, propertyTypeId, street, streetNo, zipCode, city, country, description) VALUES ('35', '1', '4', '2', 'Birkelweg','3/2', '89555', 'Steinheim am Albuch', 'Germany', 'Tiny House');
INSERT INTO infoSysGruppe3_property (squareMeter, ownerId, managerId, propertyTypeId, street, streetNo, zipCode, city, country, description) VALUES ('35', '2', '3', '2', 'Birkelweg', '3/2','89555', 'Steinheim am Albuch', 'Germany', 'Tiny House');
INSERT INTO infoSysGruppe3_property (squareMeter, ownerId, managerId, propertyTypeId, street, streetNo, zipCode, city, country, description) VALUES ('120', '2', '3', '1', 'Effnerplatz', '34','81679', 'München', 'Germany', 'Big House');
INSERT INTO infoSysGruppe3_property (squareMeter, ownerId, managerId, propertyTypeId, street, streetNo, zipCode, city, country, description) VALUES ('15', '2', '3', '2', 'Kantstraße', '3','91126', 'Rednitzhembach', 'Germany', 'Tiny House');

INSERT INTO infoSysGruppe3_lease (startDate, tenantId, propertyId, rent, paymentPeriod, deposit, numberOfResidents) VALUES ('2022-05-04', '5', '1', '750', '1', '5000', '1');
INSERT INTO infoSysGruppe3_lease (startDate, tenantId, propertyId, rent, paymentPeriod, deposit, numberOfResidents) VALUES ('2022-05-06', '6', '2', '350', '1', '4000', '2');
INSERT INTO infoSysGruppe3_lease (startDate, tenantId, propertyId, rent, paymentPeriod, deposit, numberOfResidents) VALUES ('2022-05-08', '7', '3', '400', '1', '6000', '3');
INSERT INTO infoSysGruppe3_lease (startDate, tenantId, propertyId, rent, paymentPeriod, deposit, numberOfResidents) VALUES ('2022-05-10', '8', '4', '1200', '1', '7000', '6');
INSERT INTO infoSysGruppe3_lease (startDate, tenantId, propertyId, rent, paymentPeriod, deposit, numberOfResidents) VALUES ('2022-05-12', '9', '5', '450', '1', '8000', '4');
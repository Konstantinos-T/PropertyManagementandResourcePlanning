-- creates all needed tables in the correct order (dependencies otherwise throw errors)

CREATE TABLE infoSysGruppe3_person (
    personId INT IDENTITY NOT NULL,
    firstName VARCHAR(45) NOT NULL,
    lastName VARCHAR(45) NOT NULL,
    dateOfBirth DATE NOT NULL,
    PRIMARY KEY (personId)
);

CREATE TABLE infoSysGruppe3_transactionType (
    transactionTypeId INT IDENTITY NOT NULL,
    transactionName VARCHAR(45) NOT NULL,
    PRIMARY KEY (transactionTypeId)
);

CREATE TABLE infoSysGruppe3_transaction (
    transactionId INT IDENTITY NOT NULL,
    created DATE NOT NULL,
    imported DATETIME2 NOT NULL DEFAULT GETDATE(),
    bookingText VARCHAR(45) NOT NULL,
    purpose VARCHAR(45) NOT NULL,
    beneficialPayee VARCHAR(45) NOT NULL,
    amount FLOAT NOT NULL,
    PRIMARY KEY (transactionId)
);

CREATE TABLE infoSysGruppe3_propertyType (
    propertyTypeId INT IDENTITY NOT NULL,
    propertyName VARCHAR(45) NOT NULL,
    PRIMARY KEY (propertyTypeId)
);

CREATE TABLE infoSysGruppe3_property (
    propertyId INT IDENTITY NOT NULL,
    squareMeter FLOAT NOT NULL,
    ownerId INT NOT NULL,
    managerId INT NULL,
    propertyTypeId INT NOT NULL,
    street VARCHAR(45) NOT NULL,
    streetNo VARCHAR(10) NOT NULL,
    zipCode INT NOT NULL,
    city VARCHAR(45) NOT NULL,
    country VARCHAR(45) NOT NULL,
    description VARCHAR(45) NOT NULL,
    PRIMARY KEY (propertyId),
    CONSTRAINT FK_124 FOREIGN KEY (propertyTypeId)
        REFERENCES infoSysGruppe3_propertyType (propertyTypeId),
    CONSTRAINT FK_162 FOREIGN KEY (managerId)
        REFERENCES infoSysGruppe3_person (personId),
    CONSTRAINT FK_165 FOREIGN KEY (ownerId)
        REFERENCES infoSysGruppe3_person (personId)
);

CREATE TABLE infoSysGruppe3_calculationType
(
    calculationTypeId INT IDENTITY NOT NULL ,
    name              VARCHAR(45) NOT NULL ,
    PRIMARY KEY (calculationTypeId)
);

CREATE TABLE infoSysGruppe3_calculationBase
(
    calculationBaseId INT IDENTITY NOT NULL ,
    creditorName      VARCHAR(45) NOT NULL ,
    calculationTypeId INT NOT NULL ,
    PRIMARY KEY (calculationBaseId),
    CONSTRAINT FK_183 FOREIGN KEY (calculationTypeId) 
        REFERENCES infoSysGruppe3_calculationType (calculationTypeId)
);

CREATE TABLE infoSysGruppe3_mappedTransaction (
    mappedTransactionId INT IDENTITY NOT NULL,
    tenantId INT NOT NULL,
    calculationBaseId INT NULL,
    transactionTypeId INT NULL,
    transactionId INT NULL,
    amount FLOAT NOT NULL,
    transactionReason VARCHAR(45) NOT NULL,
    transactionDate DATE NOT NULL,
    PRIMARY KEY (mappedTransactionId),
    CONSTRAINT FK_171 FOREIGN KEY (tenantId)
        REFERENCES infoSysGruppe3_person (personId),
    CONSTRAINT FK_186 FOREIGN KEY (calculationBaseId) 
        REFERENCES infoSysGruppe3_calculationBase (calculationBaseId),
    CONSTRAINT FK_84 FOREIGN KEY (transactionId)
        REFERENCES infoSysGruppe3_transaction (transactionId),
    CONSTRAINT FK_97 FOREIGN KEY (transactionTypeId)
        REFERENCES infoSysGruppe3_transactionType (transactionTypeId)
);

CREATE TABLE infoSysGruppe3_lease (
    leaseId INT IDENTITY NOT NULL,
    startDate DATETIME2 NOT NULL,
    tenantId INT NOT NULL,
    propertyId INT NOT NULL,
    endDate DATETIME2 NULL,
    rent FLOAT NOT NULL,
    paymentPeriod INT NOT NULL,
    deposit FLOAT NOT NULL,
    numberOfResidents INT NOT NULL,
    creationDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (leaseId),
    CONSTRAINT FK_168 FOREIGN KEY (tenantId)
        REFERENCES infoSysGruppe3_person (personId),
    CONSTRAINT FK_56 FOREIGN KEY (propertyId)
        REFERENCES infoSysGruppe3_property (propertyId)
);

CREATE TABLE infoSysGruppe3_monthlyTargetCreated
(
    monthlyTargetCreatedId INT IDENTITY NOT NULL,
    creationTime           DATETIME2 NOT NULL ,
    PRIMARY KEY (monthlyTargetCreatedId)
);


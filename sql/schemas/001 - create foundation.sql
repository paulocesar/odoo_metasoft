USE metasoft;

/* BASE */

CREATE TABLE login (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    login VARCHAR(20) NOT NULL,
    password VARCHAR(20) NOT NULL,
    name VARCHAR(45) NOT NULL
);

CREATE TABLE business (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    businessIdentifier VARCHAR(30), -- CNPJ
    company VARCHAR(255) NOT NULL,
    tradingName VARCHAR(255) NOT NULL,
    stateId INT NOT NULL,
    city VARCHAR(50) NOT NULL,
    address VARCHAR(255) NOT NULL,

    defaultAccountId INT UNSIGNED
);

CREATE TABLE businessCenter (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    businessId INT UNSIGNED NOT NULL,
    name VARCHAR(128) NOT NULL,
    FOREIGN KEY (businessId) REFERENCES business(id),

    defaultAccountId INT UNSIGNED
);

CREATE TABLE loginInBusiness (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    businessId INT UNSIGNED NOT NULL,
    loginId INT UNSIGNED NOT NULL,
    FOREIGN KEY (businessId) REFERENCES business(id),
    FOREIGN KEY (loginId) REFERENCES login(id)
);

CREATE TABLE client (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    businessId INT UNSIGNED NOT NULL,
    name VARCHAR(45) NOT NULL,
    typeId TINYINT(1) NOT NULL,
    FOREIGN KEY (businessId) REFERENCES business(id)
);

/* FINANCEIRO */

CREATE TABLE account (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    businessId INT UNSIGNED NOT NULL,
    balance DECIMAL(10,2) NOT NULL,
    bank VARCHAR(10) NOT NULL,
    number VARCHAR(20) NOT NULL,
    name VARCHAR(40) NOT NULL,
    FOREIGN KEY (businessId) REFERENCES business(id)
);

CREATE TABLE financeCategory (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(45) NOT NULL
);

/*
    um lancamento (entry) nunca pode ser apagado.
    se houver algum erro, deve ser criado um novo lancamento
    com informacoes da retificacao no campo de description
    deve-se armazenar 'RET-(entryId)'.
    apenas administradores devem poder apagar a entrada
*/
CREATE TABLE entry (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    businessId INT UNSIGNED NOT NULL,
    loginId INT UNSIGNED NOT NULL,
    isIncome BOOLEAN NOT NULL,
    paymentMethodId TINYINT(1) UNSIGNED NOT NULL,
    invoiceId INT UNSIGNED DEFAULT NULL,
    financeCategory INT NOT NULL,
    createdOn DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    description VARCHAR(255),
    FOREIGN KEY (businessId) REFERENCES business(id),
    FOREIGN KEY (loginId) REFERENCES login(id)
);

CREATE TABLE periodicEntry (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    businessId INT UNSIGNED NOT NULL,
    entryId INT UNSIGNED NOT NULL,
    periodicityId TINYINT(1) UNSIGNED,
    createdOn DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (businessId) REFERENCES business(id),
    FOREIGN KEY (entryId) REFERENCES entry(id)
);

CREATE TABLE put (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    entryId INT UNSIGNED NOT NULL,
    delivery DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL
);

/* INVOICE (maybe remove for now) */

CREATE TABLE invoice (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
    -- adicionar taxas de notas fiscais
);

CREATE TABLE defaultInvoiceTax (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    loginId INT UNSIGNED NOT NULL,
    businessId INT UNSIGNED NOT NULL,
    createdOn DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (businessId) REFERENCES business(id),
    FOREIGN KEY (loginId) REFERENCES login(id)
);

/* CONTABILIDADE */

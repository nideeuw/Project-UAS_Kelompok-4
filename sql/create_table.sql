-- DDL Script - Data Warehouse Star Schema
-- Dataset: Sales Data Sample

CREATE DATABASE IF NOT EXISTS dw_sales;
USE dw_sales;

-- DIMENSION TABLES

-- Tabel Dimensi: dimcustomer
CREATE TABLE IF NOT EXISTS dimcustomer (
    id_dimCustomer   INT           NOT NULL AUTO_INCREMENT,
    customerName     VARCHAR(50)   NOT NULL,
    contactFirstName VARCHAR(50)   NOT NULL,
    contactLastName  VARCHAR(50)   NOT NULL,
    phone            VARCHAR(20)   NOT NULL,
    PRIMARY KEY (id_dimCustomer)
);

-- Tabel Dimensi: dimproducts
CREATE TABLE IF NOT EXISTS dimproducts (
    id_dimProduct  INT           NOT NULL AUTO_INCREMENT,
    productCode    VARCHAR(15)   NOT NULL,
    productLine    VARCHAR(50)   NOT NULL,
    msrp           DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_dimProduct)
);

-- Tabel Dimensi: dimdate
CREATE TABLE IF NOT EXISTS dimdate (
    id_dimDate  INT  NOT NULL AUTO_INCREMENT,
    date        DATE NOT NULL,
    month       INT  NOT NULL,
    quarter     INT  NOT NULL,
    year        INT  NOT NULL,
    PRIMARY KEY (id_dimDate)
);

-- Tabel Dimensi: dimlocation
CREATE TABLE IF NOT EXISTS dimlocation (
    id_dimLocation  INT           NOT NULL AUTO_INCREMENT,
    addressLine1    VARCHAR(100)  NOT NULL,
    addressLine2    VARCHAR(100),
    city            VARCHAR(50)   NOT NULL,
    state           VARCHAR(50),
    postalCode      VARCHAR(15),
    country         VARCHAR(50)   NOT NULL,
    territory       VARCHAR(50),
    PRIMARY KEY (id_dimLocation)
);

-- FACT TABLE

-- Tabel Fakta: fact_orders
CREATE TABLE IF NOT EXISTS fact_orders (
    id_factOrder    INT           NOT NULL AUTO_INCREMENT,
    orderNumber     INT           NOT NULL,
    id_dimProduct   INT           NOT NULL,
    id_dimCustomer  INT           NOT NULL,
    id_dimDate      INT           NOT NULL,
    id_dimLocation  INT           NOT NULL,
    quantityOrdered INT           NOT NULL,
    priceEach       DECIMAL(10,2) NOT NULL,
    orderLineNumber INT           NOT NULL,
    sales           DECIMAL(10,2) NOT NULL,
    status          VARCHAR(15)   NOT NULL,
    dealSize        VARCHAR(10)   NOT NULL,
    PRIMARY KEY (id_factOrder),
    FOREIGN KEY (id_dimProduct)  REFERENCES dimproducts(id_dimProduct),
    FOREIGN KEY (id_dimCustomer) REFERENCES dimcustomer(id_dimCustomer),
    FOREIGN KEY (id_dimDate)     REFERENCES dimdate(id_dimDate),
    FOREIGN KEY (id_dimLocation) REFERENCES dimlocation(id_dimLocation)
);
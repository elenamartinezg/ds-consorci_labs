DROP DATABASE IF EXISTS coches;
CREATE DATABASE coches; 
USE coches;

-- -----------------------------------------------------
-- Tabla coches.coches
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS coches (
  ID_COCHE INT NOT NULL,
  VIN VARCHAR(20) NOT NULL,
  FABRICANTE VARCHAR(20) NOT NULL,
  MODELO VARCHAR(20) NOT NULL,
  ANO INT NOT NULL,
  COLOR VARCHAR(20) NOT NULL,
  PRIMARY KEY (ID_COCHE));


-- -----------------------------------------------------
-- Tabla coches.clientes
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS clientes (
  ID INT NOT NULL,
  ID_CLIENTE INT NOT NULL,
  NOMBRE VARCHAR(20) NOT NULL,
  TELEFONO VARCHAR(20) NULL DEFAULT NULL,
  CORREO VARCHAR(20) NULL DEFAULT NULL,
  DIRECCION VARCHAR(40) NULL DEFAULT NULL,
  CIUDAD VARCHAR(20) NULL DEFAULT NULL,
  PROVINCIA VARCHAR(20) NULL DEFAULT NULL,
  PAIS VARCHAR(20) NULL DEFAULT NULL,
  POSTAL VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (ID));


  
-- -----------------------------------------------------
-- Tabla coches.vendedores
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS vendedores (
  ID INT NOT NULL,
  ID_VENDEDOR INT NOT NULL,
  NOMBRE VARCHAR(40) NOT NULL,
  TIENDA VARCHAR(30) NOT NULL,
  PRIMARY KEY (ID_VENDEDOR));


-- -----------------------------------------------------
-- Tabla coches.facturas
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS facturas (
  ID INT NOT NULL,
  ID_FACTURA INT NOT NULL,
  FECHA DATE NULL DEFAULT NULL,
  COCHE INT NOT NULL,
  CLIENTE INT NOT NULL,
  VENDEDOR INT NOT NULL,
  PRIMARY KEY (ID_FACTURA),
  FOREIGN KEY (VENDEDOR) REFERENCES vendedores (ID_VENDEDOR),
  FOREIGN KEY (COCHE) REFERENCES coches (ID_COCHE),
  FOREIGN KEY (CLIENTE) REFERENCES clientes (ID)
);
--- A)

CREATE TABLE Combustible(
	tipo varchar(8)
);

CREATE TABLE Deposito(
	id varchar(4),
	dimension varchar(10),
	capacidad_galones int,
	abastecido_galones int,
	Combustible_tipo varchar(10)
);

CREATE TABLE Proveedor(
	placa_camion varchar(6),
	nro_licencia varchar(10)
);

CREATE TABLE persona_natural(
	nro_documento varchar(8)
);



CREATE TABLE DespachadorCombustible (
	nro_documento varchar(8),
	sueldo int
);

CREATE TABLE Cliente (
	nro_documento varchar(8)
);


CREATE TABLE Abastecimiento(
    nro BIGINT, 
    fecha DATE, 
    Deposito_Id VARCHAR(15), 
    Proveedor_Placa_Camion VARCHAR(6),
    Proveedor_Nro_licencia VARCHAR(10), 
    cantidad_galones DOUBLE PRECISION, 
    precio DOUBLE PRECISION
);

CREATE TABLE SurtidorCombustible(
    nroserie VARCHAR(12), 
    lado VARCHAR(1), 
    marca VARCHAR(15), 
    Deposito_Id VARCHAR(4)
); 

CREATE TABLE Venta(
    nro BIGINT, 
    Cliente_nro_documento VARCHAR(8)
    Despachador_nro_documento VARCHAR(8),
    SurtidorCombustible_nroserie VARCHAR(12), 
    SurtidorCombustible_lado VARCHAR(1),
    fecha DATE, 
    cantidad_galones DOUBLE PRECISION,
    preciounitario DOUBLE PRECISION, 
    monto_total DOUBLE PRECISION, 
);

--- b)


ALTER TABLE combustible ADD CONSTRAINT pk_combustible PRIMARY KEY (tipo);
ALTER TABLE deposito ADD CONSTRAINT pk_deposito PRIMARY KEY (id);
ALTER TABLE proveedor ADD CONSTRAINT pk_proveedor PRIMARY KEY (placa_camion,nro_licencia);
ALTER TABLE abastecimiento ADD CONSTRAINT pk_abastecimiento PRIMARY KEY (nro);
ALTER TABLE despachadorcombustible ADD CONSTRAINT pk_despachador PRIMARY KEY (nro_documento);
ALTER TABLE cliente ADD CONSTRAINT pk_cliente PRIMARY KEY (nro_documento);
ALTER TABLE surtidorcombustible ADD CONSTRAINT pk_surtidor PRIMARY KEY (nroserie,lado);
ALTER TABLE venta ADD CONSTRAINT pk_venta PRIMARY KEY (nro);


ALTER TABLE deposito ADD CONSTRAINT fk_deposito_combustible FOREIGN KEY (Combustible_tipo)
	REFERENCES combustible(tipo);
ALTER TABLE abastecimiento ADD CONSTRAINT fk_abastece_deposito FOREIGN KEY (Deposito_Id)
	REFERENCES deposito(id);
ALTER TABLE abastecimiento ADD CONSTRAINT fk_abastece_proveedor FOREIGN KEY (Proveedor_Placa_Camion,Proveedor_Nro_licencia)
	REFERENCES proveedor(placa_camion,nro_licencia);
ALTER TABLE surtidorcombustible ADD CONSTRAINT fk_surtidor_deposito FOREIGN KEY (Deposito_Id)
	REFERENCES deposito(id);
ALTER TABLE venta ADD CONSTRAINT fk_venta_surtidor FOREIGN KEY (SurtidorCombustible_nroserie,SurtidorCombustible_lado)
	REFERENCES surtidorcombustible(nroserie,lado);
ALTER TABLE venta ADD CONSTRAINT fk_venta_cliente FOREIGN KEY (Cliente_nro_documento)
	REFERENCES cliente(nro_documento);
ALTER TABLE venta ADD CONSTRAINT fk_venta_despachador FOREIGN KEY (Despachador_nro_documento)
	REFERENCES despachadorCombustible(nro_documento);
  
----- c)

-- Requerimiento añadir columnas a tabla persona natural
ALTER TABLE persona_natural
ADD COLUMN nombres VARCHAR(50), 
ADD COLUMN apellidos  VARCHAR(50), 
ADD COLUMN fecha_nacimiento VARCHAR(9),
ADD COLUMN email VARCHAR(100),
ADD COLUMN ciudad VARCHAR(50);

--- Requerimiento email unico
ALTER TABLE persona_natural
ADD CONSTRAINT email_unico UNIQUE(email);

--- Requerimiento edad
ALTER TABLE persona_natural 
ADD CONSTRAINT edad_check 
CHECK ( EXTRACT(YEAR FROM AGE(CURRENT_DATE,fecha_nacimiento))>= 12 
       AND  EXTRACT(YEAR FROM AGE(CURRENT_DATE,fecha_nacimiento))<= 12);

--- Capacidad del tanque no puede ser negativo

ALTER TABLE deposito
ADD CONSTRAINT capacidad_tanque_check
CHECK (capacidad_galones > 0);
------ d)
  
INSERT INTO combustible VALUES('GASOLINA');
INSERT INTO combustible VALUES('GAS');
INSERT INTO combustible VALUES('PETROLEO');

INSERT INTO proveedor VALUES ('P00111','11111111');
INSERT INTO proveedor VALUES ('P00222','22222222');
  
INSERT INTO deposito VALUES ('1','10x52x30',10000,0,'GASOLINA');
INSERT INTO deposito VALUES ('2','10x52x30',3000,0,'GAS');
INSERT INTO deposito VALUES ('3','10x52x30',5000,0,'PETROLEO');

INSERT INTO abastecimiento VALUES (1,(SELECT now()),'1','AAA111','11111111',1000, 12);
INSERT INTO abastecimiento VALUES (2,(SELECT now()),'2','AAA111','11111111',500, 12);
INSERT INTO abastecimiento VALUES (3,(SELECT now()),'3','AAA111','11111111',50, 12);
INSERT INTO abastecimiento VALUES (4,(SELECT now()),'1','BBB222','22222222',200, 12.0);
INSERT INTO abastecimiento VALUES (5,(SELECT now()),'2','BBB222','22222222',70, 12.2);
INSERT INTO abastecimiento VALUES (6,(SELECT now()),'3','BBB222','22222222',60, 12.5);

INSERT INTO despachador VALUES ('7070707', 2000);
INSERT INTO despachador VALUES ('6060606', 2700);

INSERT INTO cliente VALUES ('010101');

INSERT INTO surtidor VALUES('S001','A','DESCONOCIDO','1');
INSERT INTO surtidor VALUES('S001','B','DESCONOCIDO','1');
INSERT INTO surtidor VALUES('S002','A','DESCONOCIDO','1');
INSERT INTO surtidor VALUES('S002','B','DESCONOCIDO','1');

INSERT INTO venta VALUES (1,'010101', '7070707','S001','A',(SELECT now()),10,12,120);
INSERT INTO venta VALUES (2,'010101', '7070707','S001','A',(SELECT now()),15,20,300);
INSERT INTO venta VALUES (3,'010101', '6060606','S001','A',(SELECT now()),3,12,36);
INSERT INTO venta VALUES (4,'010101', '6060606','S001','A',(SELECT now()),4,12,48);

------ e)
create user usr_group2_petrogas1;
create user usr_group2_petrogas2;
create user usr_group2_petrogas3;
-- create user usr_group2_petrogas4;
grant select on table abastecimiento to usr_group2_petrogas1;
grant select, update, delete, insert on table venta to usr_group2_petrogas2;

------ f)
ALTER TABLE venta ADD COLUMN igv  DOUBLE PRECISION;
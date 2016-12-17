/* Relaciones. */
/* Relación Armadoras (de autos). */
CREATE TABLE Armadora
(
	id int identity NOT NULL,
	calle varchar(32) NOT NULL,
	numero varchar(8),
	colonia varchar(64) NOT NULL,
	cp char(5) NOT NULL,
	estado varchar(32) NOT NULL,
	marca varchar(64) NULL,
	CONSTRAINT pk_armadora PRIMARY KEY (id)
);
GO

/* Relación Marca (de autos). */
CREATE TABLE Marca
(
	marca varchar(64) NOT NULL,
	CONSTRAINT pk_marca PRIMARY KEY (marca)
);
GO

/* Relación Auto. */
CREATE TABLE Auto
(
	noseriemotor char(17) NOT NULL,
	transmision char(1),
	color varchar(32) NOT NULL,
	lugarFabricacion varchar(64),
	marca varchar(64) NOT NULL,
	modelo varchar(64) NOT NULL,
	CONSTRAINT pk_auto PRIMARY KEY (noSerieMotor)
);
GO

/* Relación Modelo (de auto). */
CREATE TABLE Modelo
(
	modelo varchar(64) NOT NULL,
	capTanque tinyint NOT NULL,
	espEquipaje tinyint, --si suponemos que son m^3
	pasajeros tinyint NOT NULL,
	cilindros tinyint NOT NULL,
	litros real NOT NULL,
	tipo varchar(16) NOT NULL,
	CONSTRAINT pk_modelo PRIMARY KEY (modelo)
);
GO

/* Relación Vender (marcas venden modelos). */
CREATE TABLE Vender
(
	marca varchar(64) NOT NULL,
	modelo varchar(64) NOT NULL,
	CONSTRAINT pk_vender PRIMARY KEY (marca, modelo)
);
GO

/* Relación PropiedadDe (personas tienen autos). */
CREATE TABLE PropiedadDe
(
	noseriemotor char(17) NOT NULL,
	rfc char(13) NOT NULL,
	actual bit NOT NULL,
	fechaInicio date NOT NULL,
	fechaFin date,
	CONSTRAINT pk_propiedadde PRIMARY KEY (noSerieMotor, RFC)
);
GO

/* Relación Persona. */
CREATE TABLE Persona
(
	rfc char(13) NOT NULL,
	nombres varchar(128) NOT NULL,
	aPaterno varchar(128) NOT NULL,
	aMaterno varchar(128) NOT NULL,
	fechaNac date NOT NULL,
	calle varchar(32) NOT NULL,
	numero varchar(8),
	colonia varchar(64) NOT NULL,
	cp char(5) NOT NULL,
	estado varchar(32) NOT NULL,
	telefono varchar(16),
	correo varchar(64),
	CONSTRAINT pk_persona PRIMARY KEY (RFC)
);
GO

/* Relación AgenteTransito. */
CREATE TABLE AgenteTransito
(
	numRegistroPersonal varchar(64) NOT NULL,
	rfc char(13) NOT NULL UNIQUE,
	CONSTRAINT pk_agentetransito PRIMARY KEY (numRegistroPersonal)
);
GO

/* Relación Placa. */
CREATE TABLE Placa
(
	numeroPlaca varchar(16) NOT NULL,
	estado varchar(32) NOT NULL,
	fechaFin date,
	actual bit NOT NULL,
	fechaOtorgacion date NOT NULL,
	rfc char(13) NOT NULL,
	noseriemotor char(17) NOT NULL,
	CONSTRAINT pk_placa PRIMARY KEY (numeroPlaca)
);
GO

/* Relación Licencia. */
CREATE TABLE Licencia
(
	numLicencia int identity,
	tipo char(1) NOT NULL,
	vigencia tinyint NOT NULL,
	vencimiento date NOT NULL,
	fechaSusp date,
	rfc char(13) NOT NULL UNIQUE,
	CONSTRAINT pk_licencia PRIMARY KEY (numLicencia)
);
GO

/* Relación MultaAgente. */
CREATE TABLE MultaAgente
(
	numExpediente int NOT NULL,
	fecha date NOT NULL,
	hora time NOT NULL,
	articuloInfringido tinyint NOT NULL,
	importe money NOT NULL,
	calle varchar(32) NOT NULL,
	numero varchar(8),
	colonia varchar(64) NOT NULL,
	cp char(5) NOT NULL,
	numRegistroPersonal varchar(64) NULL,
	numLicencia int NOT NULL,
	numTarjeta int NOT NULL,
	CONSTRAINT pk_multaagente PRIMARY KEY (numExpediente)
);
GO

/* Relación FotoMulta. */
CREATE TABLE FotoMulta
(
	numExpediente int NOT NULL,
	fecha date NOT NULL,
	hora time NOT NULL,
	velocidad smallint,
	color varchar(16) NOT NULL,
	idCamara int NULL,
	numeroPlaca varchar(16) NOT NULL,
	CONSTRAINT pk_fotomulta PRIMARY KEY (numExpediente)
);
GO

/* Relación TarjetaCirculacion. */
CREATE TABLE TarjetaCirculacion
(
	numTarjeta int identity,
	vigencia tinyint NOT NULL,
	fechaVencimiento date NOT NULL,
	numeroPlaca varchar(16) NOT NULL,
	rfc char(13) NOT NULL,
	CONSTRAINT pk_tarjetacirculacion PRIMARY KEY (numTarjeta)
);
GO

/* Relación Camara. */
CREATE TABLE Camara
(
	idCamara int identity,
	coordenadas geography NOT NULL,
	CONSTRAINT pk_camara PRIMARY KEY (idCamara)
);
GO

/* Llaves foráneas. */
ALTER TABLE Armadora ADD CONSTRAINT fk_col_mar FOREIGN KEY (marca) REFERENCES Marca (marca) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Auto ADD CONSTRAINT fk_aut_mar FOREIGN KEY (marca) REFERENCES Marca (marca) ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE Auto ADD CONSTRAINT fk_aut_mod FOREIGN KEY (modelo) REFERENCES Modelo (modelo) ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE Vender ADD CONSTRAINT fk_ved_mar FOREIGN KEY (marca) REFERENCES Marca (marca) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Vender ADD CONSTRAINT fk_ved_mod FOREIGN KEY (modelo) REFERENCES Modelo (modelo) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE PropiedadDe ADD CONSTRAINT fk_pro_aut FOREIGN KEY (noSerieMotor) REFERENCES Auto (noSerieMotor) ON DELETE CASCADE;
ALTER TABLE PropiedadDe ADD CONSTRAINT fk_pro_per FOREIGN KEY (RFC) REFERENCES Persona (RFC) ON DELETE NO ACTION;
ALTER TABLE AgenteTransito ADD CONSTRAINT fk_age_per FOREIGN KEY (RFC) REFERENCES Persona (RFC) ON DELETE CASCADE;
ALTER TABLE Placa ADD CONSTRAINT fk_pla_per FOREIGN KEY (RFC) REFERENCES Persona (RFC) ON DELETE NO ACTION;
ALTER TABLE Placa ADD CONSTRAINT fk_pla_aut FOREIGN KEY (noSerieMotor) REFERENCES Auto (noSerieMotor) ON DELETE NO ACTION;
ALTER TABLE Licencia ADD CONSTRAINT fk_lic_per FOREIGN KEY (RFC) REFERENCES Persona (RFC) ON DELETE CASCADE;
ALTER TABLE MultaAgente ADD CONSTRAINT fk_mul_age FOREIGN KEY (numRegistroPersonal) REFERENCES AgenteTransito (numRegistroPersonal) ON DELETE SET NULL;
ALTER TABLE MultaAgente ADD CONSTRAINT fk_mul_lic FOREIGN KEY (numLicencia) REFERENCES Licencia (numLicencia);
ALTER TABLE MultaAgente ADD CONSTRAINT fk_mul_tar FOREIGN KEY (numTarjeta) REFERENCES TarjetaCirculacion (numTarjeta);
ALTER TABLE FotoMulta ADD CONSTRAINT fk_fot_cam FOREIGN KEY (idCamara) REFERENCES Camara (idCamara) ON DELETE SET NULL;
ALTER TABLE TarjetaCirculacion ADD CONSTRAINT fk_tar_pla FOREIGN KEY (numeroPlaca) REFERENCES Placa (numeroPlaca) ON DELETE NO ACTION;
ALTER TABLE TarjetaCirculacion ADD CONSTRAINT fk_tar_per FOREIGN KEY (RFC) REFERENCES Persona (RFC) ON DELETE NO ACTION;
GO

/* Otras restricciones. */
--Velocidad positiva
ALTER TABLE FotoMulta ADD CONSTRAINT check_vel_pos CHECK(velocidad > 0);
--Tipos de licencia válidos
ALTER TABLE Licencia ADD CONSTRAINT check_lic_val CHECK(tipo IN ('A','B','C','D','E'));
--Tipos de transmisión válidos
ALTER TABLE Auto ADD CONSTRAINT check_aut_tra CHECK(transmision IN ('A','M'));
--Número de artículo válido
ALTER TABLE MultaAgente ADD CONSTRAINT check_mul_val CHECK(articuloInfringido >= 1 AND articuloInfringido <= 70);
--Campos tinyint no necesitan un CHECK para > 0 pues solo manejan números no negativos.
GO

/* Tabla auxiliar con los puntos de licencia de los infracciones más comunes. */
create table infp (articulo tinyint not null, puntos tinyint not null, constraint pk_infp primary key (articulo));
GO

insert into infp (articulo,puntos) values (1,0);
insert into infp (articulo,puntos) values (2,0);
insert into infp (articulo,puntos) values (3,0);
insert into infp (articulo,puntos) values (4,0);
insert into infp (articulo,puntos) values (5,0);
insert into infp (articulo,puntos) values (6,0);
insert into infp (articulo,puntos) values (7,1);
insert into infp (articulo,puntos) values (8,0);
insert into infp (articulo,puntos) values (9,6);
insert into infp (articulo,puntos) values (10,3);
insert into infp (articulo,puntos) values (11,6);
insert into infp (articulo,puntos) values (12,3);
insert into infp (articulo,puntos) values (13,0);
insert into infp (articulo,puntos) values (14,0);
insert into infp (articulo,puntos) values (15,0);
insert into infp (articulo,puntos) values (16,0);
insert into infp (articulo,puntos) values (17,0);
insert into infp (articulo,puntos) values (18,0);
insert into infp (articulo,puntos) values (19,0);
insert into infp (articulo,puntos) values (20,0);
insert into infp (articulo,puntos) values (21,6);
insert into infp (articulo,puntos) values (22,0);
insert into infp (articulo,puntos) values (23,0);
insert into infp (articulo,puntos) values (24,0);
insert into infp (articulo,puntos) values (25,0);
insert into infp (articulo,puntos) values (26,0);
insert into infp (articulo,puntos) values (27,0);
insert into infp (articulo,puntos) values (28,0);
insert into infp (articulo,puntos) values (29,0);
insert into infp (articulo,puntos) values (30,6);
insert into infp (articulo,puntos) values (31,0);
insert into infp (articulo,puntos) values (32,0);
insert into infp (articulo,puntos) values (33,0);
insert into infp (articulo,puntos) values (34,6);
insert into infp (articulo,puntos) values (35,0);
insert into infp (articulo,puntos) values (36,0);
insert into infp (articulo,puntos) values (37,1);
insert into infp (articulo,puntos) values (38,0);
insert into infp (articulo,puntos) values (39,0);
insert into infp (articulo,puntos) values (40,0);
insert into infp (articulo,puntos) values (41,0);
insert into infp (articulo,puntos) values (42,0);
insert into infp (articulo,puntos) values (43,0);
insert into infp (articulo,puntos) values (44,0);
insert into infp (articulo,puntos) values (45,0);
insert into infp (articulo,puntos) values (46,0);
insert into infp (articulo,puntos) values (47,0);
insert into infp (articulo,puntos) values (48,0);
insert into infp (articulo,puntos) values (49,0);
insert into infp (articulo,puntos) values (50,6);
insert into infp (articulo,puntos) values (51,0);
insert into infp (articulo,puntos) values (52,0);
insert into infp (articulo,puntos) values (53,0);
insert into infp (articulo,puntos) values (54,0);
insert into infp (articulo,puntos) values (55,0);
insert into infp (articulo,puntos) values (56,0);
insert into infp (articulo,puntos) values (57,0);
insert into infp (articulo,puntos) values (58,0);
insert into infp (articulo,puntos) values (59,0);
insert into infp (articulo,puntos) values (60,0);
insert into infp (articulo,puntos) values (61,0);
insert into infp (articulo,puntos) values (62,0);
insert into infp (articulo,puntos) values (63,0);
insert into infp (articulo,puntos) values (64,0);
insert into infp (articulo,puntos) values (65,0);
insert into infp (articulo,puntos) values (66,0);
insert into infp (articulo,puntos) values (67,0);
insert into infp (articulo,puntos) values (68,0);
insert into infp (articulo,puntos) values (69,0);
insert into infp (articulo,puntos) values (70,0);
GO

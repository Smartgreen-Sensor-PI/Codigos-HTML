-- SENSOR SMARTGREEN

CREATE DATABASE smartgreen;
USE smartgreen;

CREATE TABLE Empresa( 
idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
CNPJ CHAR(14) UNIQUE NOT NULL,
nomeFantasia VARCHAR(45)
);

CREATE TABLE usuario(
idUsuario INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(40) NOT NULL,
email VARCHAR(40) UNIQUE NOT NULL,
senha VARCHAR(40) NOT NULL,
fkEmpresa INT NOT NULL,
	CONSTRAINT fkUsuarioEmpresa
		FOREIGN KEY (fkEmpresa) 
			REFERENCES empresa (idEmpresa)
);


CREATE TABLE endereco(
idEndereco INT PRIMARY KEY AUTO_INCREMENT,
cep CHAR(8) NOT NULL,
complemento VARCHAR(20),
numero INT,
UF CHAR(2)
);

CREATE TABLE estufa(
idEstufa INT PRIMARY KEY auto_increment,
comprimento DECIMAL(5,2),
largura DECIMAL(5,2),
altura DECIMAL(5,2),
fkEmpresa INT NOT NULL,
fkEndereco INT NOT NULL,
FOREIGN KEY(fkEmpresa) REFERENCES Empresa(idEmpresa),
FOREIGN KEY (fkEndereco) REFERENCES endereco(idEndereco)
);



CREATE TABLE sensor(
idSensor INT PRIMARY KEY auto_increment,
estado VARCHAR(20) NOT NULL, 
CONSTRAINT chk_estado_fisico_sensor 
	CHECK (estado IN('reparo necessario', 'inativo', 'em funcionamento')),
localizacao VARCHAR(45) NOT NULL,
dtInstalacao DATETIME DEFAULT CURRENT_TIMESTAMP,
fkEstufa INT NOT NULL,
	CONSTRAINT fkSensorEstufa
		FOREIGN KEY (fkEstufa)
			REFERENCES estufa (idEstufa)
);



CREATE TABLE registro_sensor(
idRegistro INT auto_increment,
temperatura DECIMAL(3,1) NOT NULL,
umidade DECIMAL(3,1) NOT NULL,
momento_registro DATETIME DEFAULT current_timestamp,
fkSensor INT NOT NULL, 
PRIMARY KEY (idRegistro,fkSensor),
CONSTRAINT fkRegistro_sensor
	FOREIGN KEY (fkSensor) REFERENCES sensor(idSensor) 	
);
		
    

INSERT INTO Empresa (CNPJ, nomeFantasia) 
VALUES ('12345678901234', 'Fazenda Top');

INSERT INTO usuario (nome, email, senha, fkEmpresa) 
VALUES ('Kauã', 'kaua.aaa@fazenda.com', 'senhaTop123', 1);

INSERT INTO endereco (cep, complemento, numero, UF)
VALUES ('10000000', 'Galpão Principal', 101, 'SP');

INSERT INTO estufa (comprimento, largura, altura, fkEmpresa, fkEndereco)
VALUES (50.0, 10.0, 3.5, 1, 1);

INSERT INTO sensor (estado, localizacao, fkEstufa) 
VALUES ('em funcionamento', 'Setor Norte', 1);

INSERT INTO registro_sensor (umidade, temperatura, fkSensor) VALUES (60.0, 25.5, 1);
INSERT INTO registro_sensor (umidade, temperatura, fkSensor) VALUES (50.0, 26.2, 1);
INSERT INTO registro_sensor (umidade, temperatura, fkSensor) VALUES (99.0, 27.0, 1);


SELECT 
    u.nome AS 'Produtor',
    emp.nomeFantasia AS 'Empresa',
    est.idEstufa AS 'Numero da Estufa',
    sen.localizacao AS 'Local do Sensor',
    reg.temperatura AS 'Temperatura Registrada (°C)',
    reg.umidade AS 'Umidade Registrada (%)',
    reg.momento_registro AS 'Data e Hora'
FROM usuario u
JOIN Empresa emp ON u.fkEmpresa = emp.idEmpresa
JOIN estufa est ON est.fkEmpresa = emp.idEmpresa
JOIN sensor sen ON sen.fkEstufa = est.idEstufa
JOIN registro_sensor reg ON reg.fkSensor = sen.idSensor;
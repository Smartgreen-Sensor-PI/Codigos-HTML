-- SENSOR SMARTGREEN

CREATE DATABASE smartgreen;
USE smartgreen;

CREATE TABLE Empresa( 
idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
codigoEmpresa VARCHAR(10) UNIQUE,
CNPJ CHAR(14) UNIQUE NOT NULL,
nomeFantasia VARCHAR(45)
);

INSERT INTO Empresa (codigoEmpresa, CNPJ, nomeFantasia) VALUES
('TOM123', '12345678000101', 'Tomate Nobre'),
('VER456', '23456789000102', 'VerdeVita Estufas'),
('AGR789', '34567890000103', 'AgroTom Prime'),
('COL321', '45678901000104', 'Colheita Vermelha'),
('EST654', '56789012000105', 'Estufa Dourada');

-- para usuários do suporte
INSERT INTO Empresa (codigoEmpresa, CNPJ, nomeFantasia) VALUES
('SUP190', '11368546757764', 'Suporte');

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

CREATE VIEW vw_status_estufa AS
SELECT
    e.idEstufa,
    s.idSensor,
    r.temperatura,
    r.umidade,

    CASE
        WHEN r.temperatura > 30 THEN 'Alerta Temperatura Alta'
        WHEN r.temperatura < 20 THEN 'Alerta Temperatura Baixa'
        ELSE 'Temperatura OK'
    END AS statusTemperatura,

    CASE
        WHEN r.umidade > 80 THEN 'Alerta Umidade Alta'
        WHEN r.umidade < 50 THEN 'Alerta Umidade Baixa'
        ELSE 'Umidade OK'
    END AS statusUmidade

FROM registro_sensor r
JOIN sensor s ON r.fkSensor = s.idSensor
JOIN estufa e ON s.fkEstufa = e.idEstufa;
		
-- Para conferir se o usuário foi associado corretamente:        
    SELECT
u.idUsuario,
u.nome,
u.email,
e.nomeFantasia,
e.codigoEmpresa
FROM usuario u
JOIN Empresa e
ON u.fkEmpresa = e.idEmpresa;

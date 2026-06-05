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
    e.fkEmpresa,
    en.complemento AS nomeEstufa,

    r.temperatura,
    r.umidade,
    r.momento_registro,

    CASE
        WHEN r.temperatura > 28 THEN 'Alerta Temperatura Alta'
        WHEN r.temperatura < 15 THEN 'Alerta Temperatura Baixa'
        ELSE 'Temperatura OK'
    END AS statusTemperatura,

    CASE
        WHEN r.umidade > 70 THEN 'Alerta Umidade Alta'
        WHEN r.umidade < 50 THEN 'Alerta Umidade Baixa'
        ELSE 'Umidade OK'
    END AS statusUmidade

FROM estufa e

JOIN endereco en
    ON e.fkEndereco = en.idEndereco

JOIN sensor s
    ON s.fkEstufa = e.idEstufa

JOIN registro_sensor r
    ON r.fkSensor = s.idSensor

WHERE r.idRegistro = (
    SELECT MAX(r2.idRegistro)
    FROM registro_sensor r2
    WHERE r2.fkSensor = s.idSensor
);
		
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

-- para teste dos gráficos

INSERT INTO usuario (nome, email, senha, fkEmpresa)
VALUES (
    'Teste SmartGreen',
    'teste@smartgreen.com',
    '123456',
    1
);

INSERT INTO endereco (
    cep,
    complemento,
    numero,
    UF
)
VALUES (
    '09000000',
    'Estufa Norte',
    100,
    'SP'
);

INSERT INTO endereco (
    cep,
    complemento,
    numero,
    UF
)
VALUES (
    '09000001',
    'Estufa Sul',
    200,
    'SP'
);

INSERT INTO estufa (
    comprimento,
    largura,
    altura,
    fkEmpresa,
    fkEndereco
)
VALUES (
    60.00,
    25.00,
    4.50,
    1,
    2
);

INSERT INTO estufa (
    comprimento,
    largura,
    altura,
    fkEmpresa,
    fkEndereco
)
VALUES (
    50.00,
    20.00,
    4.00,
    1,
    1
);

INSERT INTO sensor (
    estado,
    localizacao,
    fkEstufa
)
VALUES (
    'em funcionamento',
    'Centro da Estufa',
    1
);

INSERT INTO sensor (
    estado,
    localizacao,
    fkEstufa
)
VALUES (
    'em funcionamento',
    'Lado Sul',
    2
);

INSERT INTO registro_sensor (
    temperatura,
    umidade,
    momento_registro,
    fkSensor
)
VALUES
(22.0, 65.0, '2026-06-05 08:00:00', 1),
(22.8, 66.0, '2026-06-05 09:00:00', 1),
(23.5, 67.0, '2026-06-05 10:00:00', 1),
(24.2, 68.0, '2026-06-05 11:00:00', 1),
(25.0, 69.0, '2026-06-05 12:00:00', 1),
(25.8, 70.0, '2026-06-05 13:00:00', 1),
(26.5, 72.0, '2026-06-05 14:00:00', 1),
(27.1, 73.0, '2026-06-05 15:00:00', 1);

INSERT INTO registro_sensor (
    temperatura,
    umidade,
    momento_registro,
    fkSensor
)
VALUES
(31.0, 82.0, '2026-06-05 08:00:00', 2),
(31.5, 83.0, '2026-06-05 09:00:00', 2),
(32.0, 84.0, '2026-06-05 10:00:00', 2),
(32.5, 85.0, '2026-06-05 11:00:00', 2),
(33.0, 86.0, '2026-06-05 12:00:00', 2),
(33.5, 87.0, '2026-06-05 13:00:00', 2),
(34.0, 88.0, '2026-06-05 14:00:00', 2);

SELECT
r.temperatura,
r.umidade,
DATE_FORMAT(
    r.momento_registro,
    '%H:%i:%s'
) AS momento_grafico
FROM registro_sensor r
JOIN sensor s
    ON r.fkSensor = s.idSensor
WHERE s.fkEstufa = 1
ORDER BY r.momento_registro DESC
LIMIT 7;

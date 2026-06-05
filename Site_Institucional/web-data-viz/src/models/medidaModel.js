var database = require("../database/config");

function buscarUltimasMedidas(idEstufa, limite_linhas) {

    var instrucaoSql = `
        SELECT
            r.temperatura,
            r.umidade,
            r.momento_registro,
            DATE_FORMAT(
                r.momento_registro,
                '%H:%i:%s'
            ) AS momento_grafico

        FROM registro_sensor r

        JOIN sensor s
            ON r.fkSensor = s.idSensor

        WHERE s.fkEstufa = ${idEstufa}

        ORDER BY r.momento_registro DESC

        LIMIT ${limite_linhas};
    `;

    console.log(instrucaoSql);

    return database.executar(instrucaoSql);
}

function buscarMedidasEmTempoReal(idEstufa) {

    var instrucaoSql = `
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

        WHERE s.fkEstufa = ${idEstufa}

        ORDER BY r.momento_registro DESC

        LIMIT 1;
    `;

    console.log(instrucaoSql);

    return database.executar(instrucaoSql);
}

module.exports = {
    buscarUltimasMedidas,
    buscarMedidasEmTempoReal
}

var database = require("../database/config");

function listar(fkEmpresa){

    var instrucaoSql = `
        SELECT *
        FROM vw_status_estufa
        WHERE fkEmpresa = ${fkEmpresa};
    `;

    return database.executar(instrucaoSql);
}

module.exports = {
    listar
}
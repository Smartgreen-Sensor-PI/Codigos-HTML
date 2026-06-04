var database = require("../database/config");

function buscarEstufasPorEmpresa(empresaId) {

    var instrucaoSql = `
        SELECT
            e.idEstufa AS id,
            en.complemento AS descricao
        FROM estufa e
        JOIN endereco en
            ON e.fkEndereco = en.idEndereco
        WHERE e.fkEmpresa = ${empresaId};
    `;

    return database.executar(instrucaoSql);
}

module.exports = {
  buscarEstufasPorEmpresa,
}

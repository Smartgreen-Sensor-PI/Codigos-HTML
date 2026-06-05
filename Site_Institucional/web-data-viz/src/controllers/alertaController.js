var alertaModel = require("../models/alertaModel");

function listar(req,res){

    var fkEmpresa = req.params.fkEmpresa;

    alertaModel.listar(fkEmpresa)
    .then(resultado => {
        res.json(resultado);
    })
    .catch(erro => {
        res.status(500).json(erro);
    });
}

module.exports = {
    listar
}
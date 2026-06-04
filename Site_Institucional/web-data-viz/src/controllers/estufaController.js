var estufaModel = require("../models/estufaModel");

function buscarEstufasPorEmpresa(req, res) {

    var empresaId = req.params.empresaId;

    estufaModel.buscarEstufasPorEmpresa(empresaId)
        .then(function(resultado) {
            res.json(resultado);
        })
        .catch(function(erro) {
            console.log(erro);
            res.status(500).json(erro);
        });

}


module.exports = {
  buscarEstufasPorEmpresa,
}
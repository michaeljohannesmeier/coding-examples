var express = require('express');
var router = express.Router();

router.get('/', function(req, res, next) {
    res.render('./budgetcalc/budgetcalc', { layout: false });
});

module.exports = router;
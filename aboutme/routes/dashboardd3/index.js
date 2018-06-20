var express = require('express');
var router = express.Router();

router.get('/', function(req, res, next) {
    res.render('./dashboardd3/dashboardd3', { layout: false });
});

module.exports = router;
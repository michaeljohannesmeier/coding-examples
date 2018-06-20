var express = require('express');
var router = express.Router();

router.get('/', function(req, res, next) {
    res.render('./thegym/thegym', { layout: false });
});

module.exports = router;
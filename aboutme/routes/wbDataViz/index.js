var express = require('express');
var router = express.Router();

router.get('/', function(req, res, next) {
    res.render('./wbdataviz/wbdataviz', { layout: false });
});

module.exports = router;
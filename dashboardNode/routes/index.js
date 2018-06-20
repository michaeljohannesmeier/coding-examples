var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('humans');
});
router.get('/poverty', function(req, res, next) {
    res.render('poverty');
});

module.exports = router;

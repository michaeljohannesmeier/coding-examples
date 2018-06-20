var express = require('express');
var router = express.Router();

router.get('/', function(req, res, next) {
    res.render('./piggame/piggame', { layout: false });
});
router.get('/rules', function(req, res, next) {
    res.render('./piggame/rules', { layout: false });
});

module.exports = router;
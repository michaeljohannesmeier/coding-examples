var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('./aboutme/index', { title: 'About MM' });
});

router.get('/cv', function(req, res, next) {
    res.render('./aboutme/cv', { title: 'About MM' });
});

router.get('/skills', function(req, res, next) {
    res.render('./aboutme/skills', { title: 'About MM' });
});

router.get('/projects', function(req, res, next) {
    res.render('./aboutme/projects', { title: 'About MM' });
});

router.get('/contact', function(req, res, next) {
    res.render('./aboutme/contact', { title: 'About MM' });
});

router.get('/examples', function(req, res, next) {
    res.render('./aboutme/examples', { title: 'About MM' });
});

module.exports = router;

var express = require('express');
var router = express.Router();
var csrf = require('csurf');
var passport = require('passport');


var csrfProtection = csrf();
router.use(csrfProtection);

router.get('/profile', isLoggedIn, function(req, res, next){
    res.render('shoppingcart/user/profile', {layout: 'layoutshoppingcart'});
});

router.get('/logout', function(req, res, next){
    req.logout();
    res.redirect('/shoppingcart/');
});

router.use('/', notLoggedIn, function(req, res, next) {
    console.log("when i am inside here?????????");
    next();
});

router.get('/signup', function(req, res, next) {
    var messages = req.flash('error');
    console.log("here in sign up part");
    res.render('shoppingcart/user/signup', {csrfToken: req.csrfToken(), messages: messages, hasErrors: messages.length > 0, layout: 'layoutshoppingcart'});

});

router.post('/signup', passport.authenticate('local.signup', {
    successRedirect: '/shoppingcart/user/profile',
    failureRedirect: '/shoppingcart/user/signup',
    failureFlash: true
}));


router.get('/signin', function(req, res, next) {
    var messages = req.flash('error');
    console.log("here in sign in part");
    res.render('shoppingcart/user/signin', {csrfToken: req.csrfToken(), messages: messages, hasErrors: messages.length > 0, layout: 'layoutshoppingcart'});
});

router.post('/signin', passport.authenticate('local.signin', {
    successRedirect: '/shoppingcart/user/profile',
    failureRedirect: '/shoppingcart/user/signin',
    failureFlash: true
}));

module.exports = router;

function isLoggedIn(req, res, next) {
    if (req.isAuthenticated()) {
       return next();
    }
    res.redirect('/shoppingcart/');
};

function notLoggedIn(req, res, next) {
    console.log("isAuthenticated:  " + req.isAuthenticated());
    if (!req.isAuthenticated()) {
        return next();
    }
    res.redirect('/shoppingcart/');
};



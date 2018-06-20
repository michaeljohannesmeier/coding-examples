var express = require('express');
var router = express.Router();
var Cart = require('../../models/cart');

var Product = require('../../models/product');

/* GET home page. */
router.get('/', function(req, res, next) {
  Product.find(function(err, docs) {
      var productChunks = [];
      var chunkSize = 4;
      for (var i = 0; i < docs.length; i += chunkSize){
          productChunks.push(docs.slice(i, i + chunkSize));
      }
      res.render('shoppingcart/shop/index', {title: 'Shopping Cart', products: productChunks, layout: 'layoutshoppingcart'});
  });
});

router.get('/add-to-cart/:id', function(req, res, next) {
    var productId = req.params.id;
    var cart = new Cart(req.session.cart ? req.session.cart : {});

    Product.findById(productId, function(err, product) {
        if (err) {
            return res.redirect('/shoppingcart/');
        }
        cart.add(product, product.id);
        req.session.cart = cart;
        res.redirect('/shoppingcart/');
    });
});

router.get('/add-to-cart-from-details/:id', function(req, res, next) {
    var productId = req.params.id;
    var cart = new Cart(req.session.cart ? req.session.cart : {});

    Product.findById(productId, function(err, product) {
        if (err) {
            return res.redirect('/shoppingcart/datails/' + productId);
        }
        cart.add(product, product.id);
        req.session.cart = cart;
        res.redirect('/shoppingcart/details/' + productId);
    });
});




router.get('/shopping-cart', function(req, res, next) {
    if (!req.session.cart) {
        return res.render('shoppingcart/shop/shopping-cart', {products: null, layout: 'layoutshoppingcart'});
    }
    var cart = new Cart(req.session.cart);
    res.render('shoppingcart/shop/shopping-cart', {products: cart.generateArray(), totalPrice: cart.totalPrice, layout: 'layoutshoppingcart'})
});

router.get('/increase/:id', function(req, res, next) {
    var productId = req.params.id;
    var cart = new Cart(req.session.cart ? req.session.cart : {});
    cart.increaseByOne(productId);
    req.session.cart = cart;
    res.redirect('/shoppingcart/shopping-cart');
});


router.get('/reduce/:id', function(req, res, next) {
    var productId = req.params.id;
    var cart = new Cart(req.session.cart ? req.session.cart : {});
    cart.reduceByOne(productId);
    req.session.cart = cart;
    res.redirect('/shoppingcart/shopping-cart');
});


router.get('/remove/:id', function(req, res, next) {
    var productId = req.params.id;
    var cart = new Cart(req.session.cart ? req.session.cart : {});
    cart.removeItem(productId);
    req.session.cart = cart;
    res.redirect('/shoppingcart/shopping-cart');
});

router.get('/checkout', function(req, res, next){
    if (!req.session.cart) {
        return res.redirect('/shoppingcart/shop/shopping-cart');
    }
    var cart = new Cart(req.session.cart);
    var messages = req.flash('error');
    console.log(messages.length);
    res.render('shoppingcart/shop/checkout', {total: cart.totalPrice, errMsg: messages, noError: messages.length == 0,  layout: 'layoutshoppingcart'});
});


router.get('/details/:id', function(req, res, next) {
    var productId = req.params.id;
    Product.findById(productId, function(err, product) {
        var productChunks = [];
        res.render('shoppingcart/shop/detail', {title: 'Details', products: product, layout: 'layoutshoppingcart'});
    });

});


module.exports = router;



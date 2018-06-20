var express = require('express');
var router = express.Router();
var expressValidator = require('express-validator');
var passport = require('passport');
var http        = require('http');
var querystring = require('querystring');
var bcrypt = require('bcrypt');
const saltRounds = 10;
var flash = require('connect-flash');


router.get('/', function(req, res) {
	var sql = "select * from products";
	var myData = [];

	const db = require('../db.js');
	db.query(sql, function (err, result) {
	    if (err) throw err;
	    for (var i in result){
	    	var row = {
	    		productId: result[i].productId,
	    		names: result[i].name,
	    		description: result[i].description,
	    		images: result[i].image
	    	};
			myData.push(row);
	    }
	    res.render('home', { title: 'Home', myData: myData});
	});
});


router.get('/login/flash', function(req, res){
  req.flash('info', 'Das angegebene Passwort stimmt nicht mit der Email adresse überein')
  res.redirect('/login');
});

router.get('/login', function(req, res) {
	res.render('login', {title: "Login", message: req.flash('info')});
});


router.post('/login/submit', passport.authenticate('local', {
	successRedirect: '/',
	failureRedirect: '/login/flash',
	failureFlash: true
}));



router.get('/logout', function(req, res) {
	req.logout();
	req.session.destroy();
	res.redirect('/');
});


/* GET home page. */
router.get('/registration', function(req, res, next) {
  res.render('registration', { title: 'Registration' });
});

router.post('/registration/submit', function(req, res, next) {

	const errors = req.validationErrors();
debugger;
	if (errors) {
		console.log('errors: ${JSON.stringify(errors)}');
		res.render('register', {
			title:'Registration error',
			errors: errors
		});
	} else {
		const db = require('../db.js');
		const regKey = req.body.regKey
		const email = req.body.email

		db.query('SELECT id, used FROM regKeys WHERE regkeys = ?', [regKey],
			function(err, results, fields) {
			console.log(results);
				if (results.length === 0 || results[0].used === 1) {
	              res.redirect('/notValidKey');
	          	} else {
	          		timestamp = new Date();
	          		timestamp = timestamp.toLocaleDateString() + " " + timestamp.toLocaleTimeString(); 
	          		const id = results[0].id;
	          		db.query("UPDATE regkeys SET used = ?, dateUsed = ?, emailUsed = ? WHERE id = ?", [1, timestamp, email, id]);
					const password = req.body.password;
					const firstName = req.body.firstName;
					const lastName = req.body.lastName;
					const street = req.body.street;
					const numberHouse = req.body.numberHouse;
					const zip = req.body.zip;
					const city = req.body.city;		
					bcrypt.hash(password, saltRounds, function(err, hash) {
						db.query("INSERT INTO registration (email, password, firstName, lastName, street, numberHouse, zip, city) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", [email, hash, firstName, lastName, street, numberHouse, zip, city], function(
							error, results, fields) {
							if (error) throw error;
							db.query('SELECT LAST_INSERT_ID() as user_id', function(error, results, fields) {
								if (error) throw error;
								const user_id = results[0];
								const user_email = "testEamilFromHand";
								req.login(user_id, function(err) {
									res.redirect('/');
								});
							});
						});
					});
				}
			});
	}
});

function accountExists (emailInput, callback) {
	
	var sql = "SELECT * FROM registration WHERE email = '" + emailInput + "'";
	const db = require('../db.js');
	db.query(sql, function(err, result) {
		var emailAlready = [];
	  	for (var i in result){
			emailAlready[i] =  result[i].email;
		}
		callback(emailAlready.length >=1);
		
	});
};

function accountExistsWithoutCurrent (emailInput, id,  callback) {
	const db = require('../db.js');
	console.log("inside accountExistsWithoutCurrent");
	db.query("SELECT * FROM registration WHERE email = ? AND id NOT IN(?)", [emailInput, id], function(err, result) {
		var emailAlready = [];
	  	for (var i in result){
			emailAlready[i] =  result[i].email;
		}
		callback(emailAlready.length >=1);
		
	});
};

router.get('/registration/emailInUseValidator', function(req, res, next){
    console.log("inside emailInUseValidator");

    var params = req.url.split('?')[1];
	var data   = querystring.parse(params);
	var emailInput  = data.email;

	res.statusCode = 200
	res.setHeader("Content-Type", "application/json");
	res.setHeader("Access-Control-Allow-Origin", "*");
	res.setHeader("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
	accountExists(emailInput, function(result){
		if (result)
			res.write('""');
		else
			res.write('"true"');
		res.end();
	  });

})

router.get('/registration/regKeyValidator', function(req, res, next){
	var params = req.url.split('?')[1];
	var data   = querystring.parse(params);
	var regKey  = data.regKey;
	res.statusCode = 200
	res.setHeader("Content-Type", "application/json");
	res.setHeader("Access-Control-Allow-Origin", "*");
	res.setHeader("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
	const db = require('../db.js');
	console.log("inside regkeyssssss");
	db.query('SELECT id, used FROM regKeys WHERE regkeys = ?', [regKey],
		function(err, results, fields) { 
			if (results.length === 0 || results[0].used === 1) {
				res.write('""');
			} else {
				res.write('"true"');
			}
			res.end();
		});
})




passport.serializeUser(function(user_id, done) {
	done(null, user_id);
});

passport.deserializeUser(function(user_id, done) {
	console.log("inside deserializer"+ user_id);
	done(null, user_id);
});

function authenticationMiddleware () {  
	return (req, res, next) => {
		console.log(`req.session.passport.user: ${JSON.stringify(req.session.passport)}`);
	    if (req.isAuthenticated()) return next();
	    res.redirect('/login')
	}
}



router.get('/profile/settings', authenticationMiddleware(), function(req, res) {
	const id = req.session.passport.user.user_id
	const db = require('../db.js');
	db.query('SELECT * FROM registration WHERE id = ?', [id],
		function(err, results, fields) { 
			res.render('settings', { title: 'Einstellungen', results: results[0] });
	});
});

router.get('/profile/settings/changeprofile', function(req, res, next) {
  	const id = req.session.passport.user.user_id
  	const db = require('../db.js');
  	db.query('SELECT * FROM registration WHERE id = ?', [id],
		function(err, results, fields) { 
			res.render('changeprofile', { title: 'Benutzerdaten ändern', results: results[0]});
	});
});

router.post('/profile/settings/changeprofile', function(req, res, next) {
	const db = require('../db.js');
	const email = req.body.email;
  	const id = req.session.passport.user.user_id
  	const firstName = req.body.firstName;
  	const lastName = req.body.lastName;
  	const street = req.body.street;
  	const numberHouse = req.body.numberHouse;
  	const zip = req.body.zip;
  	const city = req.body.city;
  	if(email === null) {
  			db.query('SELECT * FROM registration WHERE id = ?', [id],
				function(err, results, fields) { 
					res.render('settings', { title: 'Einstellungen', results: results[0] });
			});
  	} else {
		db.query("UPDATE registration SET email = ?, firstName = ?, lastName = ?, street = ?, numberHouse = ?, zip = ?, city = ? WHERE id = ?", [email, firstName, lastName, street, numberHouse, zip, city, id], function(error, result){
			db.query('SELECT * FROM registration WHERE id = ?', [id],
				function(err, results, fields) { 
					res.render('settings', { title: 'Einstellungen', results: results[0] });
			});
		});
	}
});

router.get('/registration/emailInUseChangeProfileValidator', function(req, res, next){
	var params = req.url.split('?')[1];
	var data   = querystring.parse(params);
	var emailInput  = data.email;
	res.statusCode = 200
	res.setHeader("Content-Type", "application/json");
	res.setHeader("Access-Control-Allow-Origin", "*");
	res.setHeader("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
	const id = req.session.passport.user.user_id;
	console.log("here with id?");
	console.log(id);
	accountExistsWithoutCurrent(emailInput, id, function(result){
		if (result)
			res.write('""');
		else
			res.write('"true"');
		res.end();
	  });
})

router.get('/details/:id', authenticationMiddleware(), function(req, res) {
	const db = require('../db.js');
		db.query('SELECT * FROM products WHERE productId = ?', [req.params.id],
			function(err, results, fields) { 
				res.render('details', { title: 'Details', results: results[0] });
		});
});


router.get('/orderconfirmation/:id', authenticationMiddleware(), function(req, res) {
	const db = require('../db.js');
		db.query('SELECT * FROM products WHERE productId = ?', [req.params.id],
			function(err, results, fields) { 
				res.render('orderconfirmation', { title: 'Bestellungsbestätigung', results: results[0] });
		});
});

router.get('/orderconfirmed/:id', authenticationMiddleware(), function(req, res) {
	const db = require('../db.js');
	db.query('SELECT * FROM products WHERE productId = ?', [req.params.id],
		function(err, results, fields) {
			const productId = results[0].productId
			const name = results[0].name
			const description = results[0].description
			timestamp = new Date();
          	timestamp = timestamp.toLocaleDateString() + " " + timestamp.toLocaleTimeString(); 
          	const status = "bestellt"
          	const customerId = req.session.passport.user.user_id
          	db.query('SELECT email FROM registration WHERE id = ?', [customerId],
				function(err, results, fields) { 
					var customerEmail = results[0].email;
					db.query("INSERT INTO orders (customerId, customerEmail, productId, name, description, orderedDate, status) VALUES (?, ?, ?, ?, ?, ?, ?)", [customerId, customerEmail, productId, name, description, timestamp, status], 
						function(error, results, fields) {
								if (error) throw error;
							  	res.redirect('/profile/orders');

							});
					});
	});
});


router.get('/profile/orders', function(req, res, next) {
	const db = require('../db.js');
	const customerId = req.session.passport.user.user_id
	db.query('SELECT * FROM orders WHERE status = "bestellt" AND customerId = ?', [customerId],
		function(err, results, fields) {
			if(results.length === 0) {
				var currentOrder = null;
				var diffTimes = null;
				var diffTimeToWait = null;
				var orderPossible = true;
				var everOrdered = false;
			} else {
				var currentOrder = results;
				var allDates = [];
				for(var i = 0; i < results.length; i++) {
					allDates.push(results[i].orderedDate);
				}
				var maxDate = new Date(Math.max.apply(null, allDates));
				timestamp = new Date();
	          	timestamp = new Date(timestamp.toLocaleDateString() + " " + timestamp.toLocaleTimeString());
	          	var difference = (timestamp - maxDate) / 1000;
		        var timeToWait = (60*60*24*30) - difference
		        var everOrdered = true;
		        var orderPossible = false;
		        if(timeToWait < 0) {
		        	orderPossible = true;
		        }
		       	var days = Math.floor(timeToWait / 86400); // 86400 = 24 hours * 60 minutes * 60 seconds per day
		        var hours = Math.floor((timeToWait % 86400) / 3600); // 3600 = 60 minutes * 60 seconds per day
		        var minutes = Math.floor((timeToWait % 3600) / 60); // 60 = 60 seconds per minute
		        var diffTimeToWait = {days: days, hours: hours, minutes: minutes }
		        console.log("time now: " + timestamp);
		        console.log("last order: " + maxDate);
	          	console.log("days: " + days + " hours: " + hours + " minutes: " + minutes);
	         }
  			res.render('orders', { title: 'Bestellungen', currentOrder: currentOrder, everOrdered: everOrdered, orderPossible: orderPossible, maxDate: maxDate, diffTimeToWait: diffTimeToWait});
  		});
});


module.exports = router;

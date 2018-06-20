var express = require('express');
var router = express.Router();
var expressValidator = require('express-validator');
var passport = require('passport');
var http        = require('http');
var querystring = require('querystring');
var bcrypt = require('bcrypt');
const saltRounds = 10;
var flash = require('connect-flash');
var sql = require("mssql");
//const db = require('../dbazure.js');
var config = {
    options: {
        encrypt: true
    },
    user: 'HelperPageRoot',
    password: 'Password123',
    server: 'helperpage.database.windows.net',
    database: 'helperpage',
    dateStrings: true
};

var myPersonalMessageObjektLogin = {
    message: undefined,
    color: undefined,
    redirect: false,
    redirectFrom: undefined
    };
var myPersonalMessageObjektHome = {
    message: undefined,
    color: undefined,
    redirect: false,
    redirectFrom: undefined
};
var myPersonalMessageObjektOrder = {
    message: undefined,
    color: undefined,
    redirect: false,
    redirectFrom: undefined
};


router.get('/', function(req, res) {
    if (!myPersonalMessageObjektHome.redirect) {
        myPersonalMessageObjektHome.message = undefined;
        myPersonalMessageObjektHome.color = undefined;
        myPersonalMessageObjektHome.redirect = false;
        myPersonalMessageObjektHome.redirectFrom= undefined;
    }
    myPersonalMessageObjektHome.redirect = false;
    const db = new sql.Connection(config);
	var sqlquery = "select * from products";
	var myData = [];
    db.connect().then(function () {
        var request = new sql.Request(db);
        request.query(sqlquery).then(function (result) {
            for (var i in result) {
                var row = {
                    productId: result[i].productId,
                    names: result[i].name,
                    description: result[i].description,
                    images: result[i].image
                };
                myData.push(row);
            }
            console.log("before close");
			db.close();
            res.render('home', {title: 'Produkte', myData: myData, myPersonalMessageObjektHome: myPersonalMessageObjektHome});
        }).catch(function(err) {
        	console.log(err);

		});
	}).catch(function(err){
		console.log(err)
	});
});

router.get('/flash', function (req, res) {
    console.log(req);

    if(myPersonalMessageObjektHome.redirectFrom === "logout") {
        myPersonalMessageObjektHome.message = "Logout erfoglreich";
        myPersonalMessageObjektHome.color = "success";
        myPersonalMessageObjektHome.redirect = true;
    } else {
        myPersonalMessageObjektHome.message = "Login erfoglreich";
        myPersonalMessageObjektHome.color = "success";
        myPersonalMessageObjektHome.redirect = true;
    }
    res.redirect('/');
});

router.get('/login/flash', function (req, res) {
    if (myPersonalMessageObjektLogin.redirectFrom === "details"){
            myPersonalMessageObjektLogin.message = "Sie sind nicht eingeloggt. Bitte loggen Sie sich ein oder registrieren Sie sich.";
            myPersonalMessageObjektLogin.color= "danger";
            myPersonalMessageObjektLogin.redirect = true;
            myPersonalMessageObjektLogin.redirectFrom = undefined;
    } else {
        myPersonalMessageObjektLogin.message = "Die Email Adresse und das Passwort stimmen nicht überein. Bitte versuchen Sie es nochmal oder registrieren Sie sich.";
        myPersonalMessageObjektLogin.color = "danger";
        myPersonalMessageObjektLogin.redirect = true;
        myPersonalMessageObjektLogin.redirectFrom = undefined;
    }
    res.redirect('/login');
});


router.get('/login', function (req, res) {
    if (!myPersonalMessageObjektLogin.redirect){
        myPersonalMessageObjektLogin.message= undefined;
        myPersonalMessageObjektLogin.color= undefined;
        myPersonalMessageObjektLogin.redirect = false;
        myPersonalMessageObjektLogin.redirectFrom= undefined;
    }
    myPersonalMessageObjektLogin.redirect = false
    console.log("color");
    res.render('login', {title: "Login", myPersonalMessageObjektLogin: myPersonalMessageObjektLogin});
});

router.post('/login/submit', passport.authenticate('local', {
	successRedirect: '/flash',
	failureRedirect: '/login/flash',
	failureFlash: true
}));


passport.serializeUser(function(user_id, done) {
    console.log("inside serializer passportjs"+ JSON.stringify(user_id));
    done(null, user_id);
});

passport.deserializeUser(function(user_id, done) {
    console.log("inside deserializer"+ JSON.stringify(user_id));
    done(null, user_id);
});



router.get('/logout', function(req, res) {
	req.logout();
	req.session.destroy();
    myPersonalMessageObjektHome.redirectFrom = "logout";
	res.redirect('/flash');
});


// GET home page..
router.get('/registration', function(req, res, next) {
    var sqlquery = "SELECT regkeys, used FROM regkeys WHERE used = 0";
    const db = new sql.Connection(config);
    db.connect().then(function () {
        var request = new sql.Request(db);
        console.log(sqlquery);
        request.query(sqlquery).then(function (result) {
            console.log(result);
            res.render('registration', { title: 'Registration', regkeys: result});
        }).catch(function(e){
            console.log(e);
        });
    }).catch(function(e) {
        console.log(e);
    });
});

router.post('/registration/submit', function(req, res, next) {

    const errors = req.validationErrors();

    if (errors) {
        console.log('errors: ${JSON.stringify(errors)}');
        res.render('register', {
            title: 'Registration error',
            errors: errors
        });
    } else {

        const regKey = req.body.regKey
        const email = req.body.email
        const db = new sql.Connection(config);
        db.connect().then(function () {
            var request = new sql.Request(db);
            request.query('SELECT id, used FROM regKeys WHERE regkeys =' + regKey).then(function (results) {
                console.log(results);
                if (results.length === 0 || results[0].used === 1) {
                    res.redirect('/notValidKey');
                } else {
                    timestamp = new Date();
                    timestamp.setHours(timestamp.getHours() + 1);
                    timestamp = timestamp.toLocaleDateString() + " " + timestamp.toLocaleTimeString();
                    const id = results[0].id;
                    console.log(timestamp);
                    var sqlquery = "UPDATE regkeys SET used = 1, dateUsed = '" + timestamp + "', emailUsed ='" + email + "' WHERE id =" + id;
                    console.log(sqlquery);
                    request.query(sqlquery).then(function (results) {
                        const password = req.body.password;
                        const firstName = req.body.firstName;
                        const lastName = req.body.lastName;
                        const street = req.body.street;
                        const numberHouse = req.body.numberHouse;
                        const zip = req.body.zip;
                        const city = req.body.city;
                        bcrypt.hash(password, saltRounds, function (err, hash) {
                            const sqlquery2 = "INSERT INTO registration (email, password, firstName, lastName, street, numberHouse, zip, city, orderedStatus) VALUES ('" + email + "','" + hash + "','" + firstName + "','" + lastName + "','" + street + "','" + numberHouse + "','" + zip + "','" + city + "','" + 0 + "')";
                            console.log(sqlquery2);
                            //var request = new sql.Request(db);
                            request.query(sqlquery2).then(function (results) {
                                request.query('SELECT SCOPE_IDENTITY() as user_id').then(function (results) {
                                    const user_id = results[0];
                                    //req.login(user_id, function (err) {
                                    myPersonalMessageObjektLogin.message = "Registrierung erfoglreich. Bitte loggen Sie sich ein.";
                                    myPersonalMessageObjektLogin.color = "success";
                                    myPersonalMessageObjektLogin.redirect = true;
                                        res.redirect('/login');
                                    //});
                                }).catch(function (err) {
                                    console.log("cath 1");
                                    console.log(err);
                                });
                            }).catch(function (err) {
                                console.log("cath 2");
                                console.log(err);
                            });
                        });
                    }).catch(function (err) {
                        console.log("cath 3");
                        console.log(err);

                    });
                }
            }).catch(function (err) {
                console.log("cath 4");
                console.log(err);
                db.close();
            });
        }).catch(function (err) {
            console.log("cath 5");
            console.log(err);
        });
    }
});

function accountExists (emailInput, callback) {
	
	var sqlquery = "SELECT * FROM registration WHERE email = '" + emailInput + "'";
    const db = new sql.Connection(config);
    console.log("inside accountExists");
    db.connect().then(function () {
        var request = new sql.Request(db);
        console.log(sqlquery);
        request.query(sqlquery).then(function (result) {
            var emailAlready = [];
            for (var i in result) {
                emailAlready[i] = result[i].email;
            }
            if (emailAlready.length >=1) {
                callback(true)
            } else {
                callback(false)
            }
            db.close();
        }).catch(function (err) {
            console.log("here??");
            //console.log(err);
            callback(true)
            db.close();
        });
    }).catch(function(err){
        console.log(err)
    });

};

function accountExistsWithoutCurrent (emailInput, id,  callback) {
    const db = new sql.Connection(config);
	console.log("inside accountExistsWithoutCurrent");
    db.connect().then(function () {
        var request = new sql.Request(db);
        console.log("iddddd" + id);
		request.query("SELECT * FROM registration WHERE email ='" + emailInput + "' AND id NOT IN('" + id + "')").then(function(result) {
			var emailAlready = [];
			for (var i in result){
				emailAlready[i] =  result[i].email;
			}
			callback(emailAlready.length >=1);
            db.close();
		}).catch(function (err) {
			console.log(err);
            db.close();
		});
    }).catch(function(err){
        console.log(err)
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
    const db = new sql.Connection(config);
    db.connect().then(function () {
        var request = new sql.Request(db);
        var sqlquery = "SELECT id, used FROM regKeys WHERE regkeys = " + regKey;
        request.query(sqlquery).then(function(results) {
			if (results[0].used === true) {
                res.statusCode = 200;
                res.setHeader("Content-Type", "application/json");
                res.setHeader("Access-Control-Allow-Origin", "*");
                res.setHeader("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
				res.write('""');
			} else {
                res.statusCode = 200;
                res.setHeader("Content-Type", "application/json");
                res.setHeader("Access-Control-Allow-Origin", "*");
                res.setHeader("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
				res.write('"true"');
			}
			res.end();
            db.close();
		}).catch(function(err) {
			console.log(err)
            db.close();
		});
    }).catch(function(err){
        console.log(err)
    });

});


function authenticationMiddleware () {  
	return (req, res, next) => {
		console.log(`req.session.passport.user: ${JSON.stringify(req.session.passport)}`);
	    if (req.isAuthenticated()) return next();
        myPersonalMessageObjektLogin.redirectFrom = "details";
        res.redirect('/login/flash');
	}
}



router.get('/profile/settings', authenticationMiddleware(), function(req, res) {
	const id = req.session.passport.user.user_id;
    const db = new sql.Connection(config);
    db.connect().then(function () {
        var request = new sql.Request(db);
        console.log("before request error here?");
        request.query('SELECT * FROM registration WHERE id =' + id).then(function(results) {
        	res.render('settings', { title: 'Einstellungen', results: results[0] });
            db.close();
		}).catch(function(err){
			console.log(err);
            db.close();
		});
    }).catch(function(err){
        console.log(err)
    });
});

router.get('/profile/settings/changeprofile', function(req, res, next) {
  	const id = req.session.passport.user.user_id;
    const db = new sql.Connection(config);
    db.connect().then(function () {
        var request = new sql.Request(db);
        request.query('SELECT * FROM registration WHERE id =' + id).then(function(results) {
        	res.render('changeprofile', { title: 'Benutzerdaten ändern', results: results[0]});
            db.close();
		}).catch(function(err){
			console.log(err)
            db.close();
		});
    }).catch(function(err){
        console.log(err)
    });
});

router.post('/profile/settings/changeprofile', function(req, res, next) {
    const db = new sql.Connection(config);
	const email = req.body.email;
  	const id = req.session.passport.user.user_id
  	const firstName = req.body.firstName;
  	const lastName = req.body.lastName;
  	const street = req.body.street;
  	const numberHouse = req.body.numberHouse;
  	const zip = req.body.zip;
  	const city = req.body.city;
  	if(email === null) {
        db.connect().then(function () {
            var request = new sql.Request(db);
            console.log("here in settingschangeprofile");
            request.query('SELECT * FROM registration WHERE id =' + id).then(function(results) {
            	res.render('settings', { title: 'Einstellungen', results: results[0] });
                db.close();
			}).catch(function(err){
				console.log(err)
                db.close();
			});
        }).catch(function(err){
            console.log(err)
        });
  	} else {
        db.connect().then(function () {
            var request = new sql.Request(db);
            request.query("UPDATE registration SET email ='" + email + "', firstName ='" + firstName + "', lastName ='" + lastName + "', street ='" + street + "', numberHouse ='" + numberHouse + "', zip ='" + zip + "', city ='" + city + "' WHERE id =" + id ).then(function (result) {
                request.query('SELECT * FROM registration WHERE id =' + id).then(function (results) {
                    res.render('settings', {title: 'Einstellungen', results: results[0]});
                }).catch(function (err) {
                    console.log(err)
                });
                db.close();
            }).catch(function (err) {
                console.log(err)
                db.close();
            });
        }).catch(function(err){
            console.log(err)
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

router.get('/details/:id', function(req, res) {
    const db = new sql.Connection(config);
    console.log(req.params.id);
    db.connect().then(function () {
        var request = new sql.Request(db);
        request.query('SELECT * FROM products WHERE productId =' + req.params.id).then(function(results) {
        	res.render('details', { title: 'Details', results: results[0] });
            db.close();
		}).catch(function(err) {
            console.log(err)
            db.close();
        });
    }).catch(function(err){
        console.log(err)
    });
});


router.get('/orderconfirmation/:id', authenticationMiddleware(), function(req, res) {
    const db = new sql.Connection(config);
    db.connect().then(function () {
        var request = new sql.Request(db);
        request.query('SELECT * FROM products WHERE productId =' + req.params.id).then(function(results) {
        	res.render('orderconfirmation', { title: 'Bestellungsbestätigung', results: results[0] });
            db.close();
		}).catch(function(err){
        	console.log(err)
            db.close();
        });
    }).catch(function(err){
        console.log(err)
    });
});

router.get('/orderconfirmed/:id', authenticationMiddleware(), function(req, res) {
    const db = new sql.Connection(config);
    db.connect().then(function () {
        const customerId = req.session.passport.user.user_id;
        var request = new sql.Request(db);
        request.query("SELECT * FROM orders WHERE status = 'bestellt' AND customerId = " + customerId).then(function(results) {
            var timeToWait = -1;
            if(results.length !== 0) {
                var allDates = [];
                for (var i = 0; i < results.length; i++) {
                    //allDates.push(results[i].orderedDate);
                    allDates.push(new Date(results[i].orderedDate));
                }
                var maxDate = new Date(Math.max.apply(null, allDates));
                var timestamp = new Date();
                timestamp.setHours(timestamp.getHours() + 1);
                timestamp = new Date(timestamp.toLocaleDateString() + " " + timestamp.toLocaleTimeString());
                var difference = (timestamp - maxDate) / 1000;
                var timeToWait = (60 * 5) - difference;
            }
            if (timeToWait > 0 ) {
                console.log("inside check if already ordered");
                myPersonalMessageObjektOrder.message = "Bestellung nicht möglich. Sie haben bereits eine Bestellung vorgenommen.";
                myPersonalMessageObjektOrder.color = "danger";
                myPersonalMessageObjektOrder.redirectFrom = "ordernotpossible";
                myPersonalMessageObjektOrder.redirect = true;
                res.redirect('/profile/orders');
                db.close();
            } else {
                var request = new sql.Request(db);
                request.query('SELECT * FROM products WHERE productId =' + req.params.id).then(function(results) {
                        const productId = results[0].productId;
                        const name = results[0].name;
                        const description = results[0].description;
                        timestamp = new Date();
                        timestamp.setHours(timestamp.getHours() + 1);
                        timestamp = timestamp.toLocaleDateString() + " " + timestamp.toLocaleTimeString();
                        const status = "bestellt";
                        const customerId = req.session.passport.user.user_id;
                        request.query('SELECT email FROM registration WHERE id = ' + customerId).then(function(results) {
                                var customerEmail = results[0].email;
                                console.log("so far?");
                                var sqlquery = "INSERT INTO orders (customerId, customerEmail, productId, name, description, orderedDate, status) VALUES ('" + customerId + "','" + customerEmail + "','" + productId + "','" + name + "','" + description + "','" + timestamp + "','" + status + "')";
                                console.log(sqlquery);
                                request.query(sqlquery).then(function (results) {
                                    var request = new sql.Request(db);
                                    request.query('UPDATE registration SET orderedStatus = 1 WHERE id = ' + customerId).then(function (results) {
                                        myPersonalMessageObjektOrder.message = "Bestellung erfolgreich aufgenommen.";
                                        myPersonalMessageObjektOrder.color = "success";
                                        myPersonalMessageObjektOrder.redirectFrom = "ordersuccess";
                                        myPersonalMessageObjektOrder.redirect = true;
                                        res.redirect('/profile/orders');
                                        db.close();
                                    }).catch(function (err) {
                                        console.log(err);
                                        db.close();
                                    });
                                }).catch(function (err) {
                                    console.log(err);
                                    db.close();
                                });

                        }).catch(function(err){
                            console.log(err)
                            db.close();
                        });
                }).catch(function(err){
                    console.log(err)
                    db.close();
                });
            }
        }).catch(function(err){
                console.log(err)
                db.close();
        });
    }).catch(function(err){
        console.log(err)
    });
});


router.get('/profile/orders', function(req, res, next) {
    const db = new sql.Connection(config);
    db.connect().then(function () {
        var request = new sql.Request(db);
        console.log("here inside /profiles/orders?");
		const customerId = req.session.passport.user.user_id;
        request.query("SELECT * FROM orders WHERE status = 'bestellt' AND customerId = " + customerId).then(function(results) {
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
                    //allDates.push(results[i].orderedDate);
					allDates.push(new Date(results[i].orderedDate));
				}
				var maxDate = new Date(Math.max.apply(null, allDates));
				var timestamp = new Date();
				timestamp.setHours(timestamp.getHours() + 1);
				timestamp = new Date(timestamp.toLocaleDateString() + " " + timestamp.toLocaleTimeString());
				var difference = (timestamp - maxDate) / 1000;
				var timeToWait = (60*5) - difference; //(60*60*24*30) - difference
                console.log(timeToWait);
				var everOrdered = true;
				var orderPossible = false;
				if(timeToWait < 0) {
					orderPossible = true;
				}
				var days = Math.floor(timeToWait / 86400); // 86400 = 24 hours * 60 minutes * 60 seconds per day
				var hours = Math.floor((timeToWait % 86400) / 3600); // 3600 = 60 minutes * 60 seconds per day
				var minutes = Math.floor((timeToWait % 3600) / 60); // 60 = 60 seconds per minute
                var seconds = Math.floor((timeToWait % 60));
				var diffTimeToWait = {days: days, hours: hours, minutes: minutes, seconds:seconds }
				console.log("time now: " + timestamp);
				console.log("last order: " + maxDate);
				console.log("days: " + days + " hours: " + hours + " minutes: " + minutes);
			 }

            if (!myPersonalMessageObjektOrder.redirect) {
                myPersonalMessageObjektOrder.message = undefined;
                myPersonalMessageObjektOrder.color = undefined;
                myPersonalMessageObjektOrder.redirect = false;
                myPersonalMessageObjektOrder.redirectFrom = undefined;
            }
            myPersonalMessageObjektOrder.redirect = false
			res.render('orders', { title: 'Bestellungen', currentOrder: currentOrder, everOrdered: everOrdered, orderPossible: orderPossible, maxDate: maxDate, diffTimeToWait: diffTimeToWait, myPersonalMessageObjektOrder: myPersonalMessageObjektOrder});
            db.close();
        }).catch(function(err) {
            console.log(err)
            db.close();
        });
    }).catch(function(err) {
        console.log(err)
    });
});

router.get('/about', function(req, res) {
    res.render('about');
});


module.exports = router;

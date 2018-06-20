var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var hbs = require('express-handlebars');
var ProgressBar = require('progressbar.js');

//shoppin cart imports modules
var mongoose = require('mongoose');
var mongoClient = require("mongodb").MongoClient;
var session = require('express-session');
var passport = require('passport');
var flash = require('connect-flash');
var validator = require('express-validator');
var MongoStore = require('connect-mongo')(session);


var index = require('./routes/aboutme/index');
var thegym = require('./routes/thegym/index');
var piggame = require('./routes/piggame/index');
var budgetcalc = require('./routes/budgetcalc/index');
var wbdataviz = require('./routes/wbDataViz/index');
var dashboardd3 = require('./routes/dashboardd3/index');


//shopping cart imports references
var shoppingCartIndex = require('./routes/shoppingcart/index');
var shoppingCartuserRoutes = require('./routes/shoppingcart/user');

/*
var fs = require('fs');
var Schema = mongoose.Schema;
var imgPath = path.join(__dirname, '/public/fahrrad/assets/img/rad1.jpg');
var schema = new Schema({
    img: { data: Buffer, contentType: String }
});
var A = mongoose.model('A', schema);
var a = new A;
a.img.data = fs.readFileSync(imgPath);
a.img.contentType = 'jpg';
a.save(function (err,a) {
    console.log(a);

});
*/


//shopping cart connect mongodb
mongoose.connect('mongodb://localhost/shopping');

//shopping cart part passport
require('./config/passport');



var app = express();

// view engine setup
app.engine('hbs', hbs({
    extname: 'hbs',
    defaultLayout: 'layout',
    layoutsDir: __dirname + '/views/layouts/',
    partialsDir: __dirname + '/views/partials'
}));
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'hbs');

// uncomment after placing your favicon in /public
//app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(logger('dev'));
app.use(bodyParser.json({limit: '50mb'}));
app.use(bodyParser.urlencoded({ limit: '50mb', extended: false }));


app.use(function (req, res, next) {
    res.setHeader('Access-Control-Allow-Origin', 'http://localhost:8081');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');
    res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');
    res.setHeader('Access-Control-Allow-Credentials', true);
    next();
});


app.use(validator());
app.use(cookieParser());
app.use(session({
    secret: 'mysupersecret',
    resave: false,
    saveUninitialized: false,
    store: new MongoStore({ mongooseConnection: mongoose.connection }),
    cookie: { maxAge: 180 * 60 * 1000 }
}));
app.use(flash());
app.use(passport.initialize());
app.use(passport.session());
app.use(express.static(path.join(__dirname, 'public')));

//shopping cart locals
app.use(function(req, res, next) {
    res.locals.login = req.isAuthenticated();
    res.locals.session = req.session;
    next();
});


app.use('/', index);
app.use('/thegym', thegym);
app.use('/piggame', piggame);
app.use('/budgetcalc', budgetcalc);
app.use('/wbdataviz', wbdataviz);
app.use('/shoppingcart/', shoppingCartIndex);
app.use('/shoppingcart/user', shoppingCartuserRoutes);
app.use('/dashboardD3', dashboardd3);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;

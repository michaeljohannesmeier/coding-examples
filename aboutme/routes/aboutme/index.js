var express = require('express');
var router = express.Router();
var path = require('path');
var mongoose = require('mongoose');

var { Recipe } = require('../../models/recipe');
var { Bike } = require('../../models/fahrrad');



/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('./aboutme/index', { title: 'About MM', page:'index'  });
});

router.get('/cv', function(req, res, next) {
    res.render('./aboutme/cvEng', { title: 'About MM', page:'cv'  });
});

router.get('/skills', function(req, res, next) {
    res.render('./aboutme/skills', { title: 'About MM', page:'skills' });
});

router.get('/projects', function(req, res, next) {
    res.render('./aboutme/projectsEng', { title: 'About MM',  page:'projects'  });
});

router.get('/contact', function(req, res, next) {
    res.render('./aboutme/contact', { title: 'About MM' });
});

router.get('/examples', function(req, res, next) {
    res.render('./aboutme/examples', { title: 'About MM' });
});

router.get('/certificates', function(req, res, next) {
    res.render('./aboutme/certificates', { title: 'About MM' });
});
router.get('/bbyyo', function(req, res, next) {
    res.render('./aboutme/bbyyo', { title: 'About MM' });
});




/*----------------ANGULAR FRUITS------------------*/
router.get('/fruits', function(req, res, next) {
    res.sendFile(path.join(__dirname, '../../public/fruits/index.html'));
});
router.get('/fruits/bananas', function(req, res, next) {
    res.sendFile(path.join(__dirname, '../../public/fruits/index.html'));
});
router.get('/fruits/strawberries', function(req, res, next) {
    res.sendFile(path.join(__dirname, '../../public/fruits/index.html'));
});


/*----------------ANGULAR RECIPE------------------*/
router.get('/recipe', function(req, res, next) {
    res.sendFile(path.join(__dirname, '../../public/recipe/index.html'));
});



router.get('/restangulargetallrecipes',(req, res) => {
    Recipe.find({}).then((recipes) => {
        console.log(recipes);
    res.send({recipes})
    }, (err) => {
        res.status(400).send(err)
    });
});

router.post('/restangularaddnewrecipe', function(req, res, next) {
    console.log('GET request add new recipe');
    console.log(req.body);
    var recipe = new Recipe({
        name: req.body.name,
        description: req.body.description,
        imagePath: req.body.imagePath,
        ingredients: req.body.ingredients
    });

    recipe.save().then((doc) => {
        res.send(doc);
    }, (err) =>  {
            res.status(400).send(err);
    });
});



router.post('/restangulardeleterecipe',(req, res) => {
    Recipe.deleteOne({'_id': req.body.index}).then((recipe) => {
        res.send({recipe})
        }, (err) => {
            res.status(400).send(err)
    });
});

router.post('/restangularupdaterecipe',(req, res) => {
    Recipe.findOneAndUpdate({'_id': req.body._id}, {$set: req.body}, {new: true}).then((recipe) => {
        res.send({recipe})
        }, (err) => {
            res.status(400).send(err)
    });
});



/*----------------ANGULAR BIKES------------------*/
router.get('/bikes', function(req, res, next) {
    res.sendFile(path.join(__dirname, '../../public/bikes/index.html'));
});

router.get('/getallfahrrads', (req, res) => {
    console.log('GET Fahrrad -------');
    Bike.find({}).then((fahrrads) => {
        res.send(fahrrads);
    }, (err) => {
        res.status(400).send(err)
    });
});


router.post('/postnewfahrrad', (req, res) => {
    console.log("POST post new fahrrad ----------- ");
var fahrrad;
const myPromise = new Promise(function(resolve, reject) {
    resolve(
        new Bike({
            name: req.body.name,
            price: req.body.price,
            descriptionShort: req.body.descriptionShort,
            descriptionLong: req.body.descriptionLong,
            image: {
                data: req.body.image,
                contentType: 'jpg'
            }
        })
    )
});

myPromise.then(function(fahrrad) {
    console.log('how much ---------');
    fahrrad.save().then((doc) => {
    res.sendStatus(200)
});
}).catch(function(err){
    console.log(err)
});

});



router.get('/fahrradadmin', function(req, res, next) {
    res.sendFile(path.join(__dirname, '../../public/bikeadmin/index.html'));
});

router.post('/editfahrrad', (req, res) => {
    console.log("POST edit fahrrad ----------- ");
var fahrrad;
const myPromise = new Promise(function(resolve, reject) {


    resolve(
        new Bike({
            _id: req.body._id,
            name: req.body.name,
            price: req.body.price,
            descriptionShort: req.body.descriptionShort,
            descriptionLong: req.body.descriptionLong,
            image: {
                data: req.body.image,
                contentType: 'jpg'
            }
        })
    )
});

myPromise.then(function(fahrrad) {
    Bike.findOneAndUpdate({'_id': req.body._id}, {$set: fahrrad}, {new: true}).then((doc) => {
        res.send({doc})

    }).catch(function (err) {
            console.log(err)
        });
    });
});

router.post('/fahrraddelete/',(req, res) => {
    Bike.deleteOne({'_id': req.body.id}).then((fahrrad) => {
    res.send({fahrrad})
    }, (err) => {
        res.status(400).send(err)
    });
});



module.exports = router;

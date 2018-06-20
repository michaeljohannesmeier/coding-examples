var express = require('express');
var router = express.Router();
var path = require('path');
var { Fahrrad } = require('../models/fahrrad');

router.get('/', function(req, res, next) {
    res.sendFile(path.join(__dirname, '/../public/fahrrad/index.html'));
});

router.get('/getallfahrrads', (req, res) => {
    console.log('GET Fahrrad -------');
Fahrrad.find({}).then((fahrrads) => {
    res.send(fahrrads);
}, (err) => {
    res.status(400).send(err)
});
});

/*
router.get('/getallfahrrads', (req, res) => {
    console.log('GET Fahrrad -------');
Fahrrad.find({}).then((fahrrad) => {
    const base64 = picture[0].img.data.toString('base64');
res.send({base64});
console.log(base64);
}, (err) => {
    res.status(400).send(err)
});
});
*/


router.post('/postnewfahrrad', (req, res) => {
    console.log("POST post new fahrrad ----------- ");
var fahrrad;
const myPromise = new Promise(function(resolve, reject) {
    console.log('promiiiieseeee');

    resolve(
        new Fahrrad({
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
        console.log('doooooc');
    res.sendStatus(200)
});
}).catch(function(err){
    console.log(err)
});

});




/*    upload(req, res, function(err) {
        if (err) {

        }
});
console.log("all done and uploaded easily");*/
/*    var form = new formidable.IncomingForm();
    form.parse(req, function (err, fields, files) {
        fs.writeFile('./public/fahrrad/assets/img/newImage2.jpg', function (err) {
            if (err) throw err;
            res.write('File uploaded and moved!');
            res.end();
        });
    });*/


/*    fs.writeFile('./public/fahrrad/assets/img/newImage.jpg', req.body.avatar.value, function(err){
        if (err) throw err;
        console.log('It is saved');
    });
    console.log(req.files);
    console.log("here i am in fahrrad upload file, POST req");
    res.sendStatus(200);*/

/*
    var fstream;
    req.pipe(req.busboy);
    req.busboy.on('file', function (fieldname, file, filename) {
        console.log("Uploading: " + filename);
        fstream = fs.createWriteStream('./public/fahrrad/assets/img/newImage.jpg');
        file.pipe(fstream);
        fstream.on('close', function () {
            res.sendStatus(200);
        });
    });
*/


/*----------------FAHRRAD ADMIN------------------*/
router.get('/fahrradadmin', function(req, res, next) {
    res.sendFile(path.join(__dirname, '../../public/fahrradadmin/index.html'));
});

router.post('/editfahrrad', (req, res) => {
    console.log("POST edit fahrrad ----------- ");
var fahrrad;
const myPromise = new Promise(function(resolve, reject) {


    resolve(
        new Fahrrad({
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
    Fahrrad.findOneAndUpdate({'_id': req.body._id}, {$set: fahrrad}, {new: true}).then((doc) => {
        res.send({doc})

}).catch(function (err) {
        console.log(err)
    });
});
});

router.post('/fahrraddelete/',(req, res) => {
    Fahrrad.deleteOne({'_id': req.body.id}).then((fahrrad) => {
    res.send({fahrrad})
}, (err) => {
    res.status(400).send(err)
});
});




module.exports = router;


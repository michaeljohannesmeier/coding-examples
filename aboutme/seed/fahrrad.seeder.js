var mongoose = require('mongoose');
var fs = require('fs');
var path = require('path');

mongoose.promise = global.Promise;
mongoose.connect('mongodb://localhost:27017/shopping');

var imgPath1 = path.join(__dirname, '../public/bikes/assets/img/rad1.jpg');
var imgPath2 = path.join(__dirname, '../public/bikes/assets/img/rad2.jpg');
var imgPath3 = path.join(__dirname, '../public/bikes/assets/img/rad3.jpg');

var Bike = mongoose.model('Bike', {
    name: {
        type: String,
        required: true,
        minLength: 1,
        trim: true
    }
    ,
    price: {
        type: Number,
        required: true,
        minLength: 1,
        trim: true
    },
    descriptionShort: {
        type: String,
        required: true,
        minLength:1,
        trim: true
    },
    descriptionLong: {
        type: String,
        required: true,
        minLenght: 1,
        trim: true
    },
    image: {
        type: { data: Buffer, contentType: String },
        requred: true
    }
});

var bikes = [
    new Bike ({
        name: 'Name Fahrrad 1',
        price: 30,
        descriptionShort: 'Beschreibung kurz kurz kurz kurz',
        descriptionLong: 'Beschreibung lang Beschreibung lang Beschreibung lang Beschreibung lang Beschreibung lang Beschreibung lang Beschreibung lang ',
        image: {
            data: fs.readFileSync(imgPath1),
            contentType: 'jpg'
        }
    }),
    new Bike ({
        name: 'Name Fahrrad 2',
        price: 30,
        descriptionShort: 'Beschreibung kurz kurz kurz kurz',
        descriptionLong: 'Beschreibung lang Beschreibung lang Beschreibung lang Beschreibung lang Beschreibung lang Beschreibung lang Beschreibung lang ',
        image: {
            data: fs.readFileSync(imgPath2),
            contentType: 'jpg'
        }
    }),
    new Bike ({
        name: 'Name Fahrrad 3',
        price: 30,
        descriptionShort: 'Beschreibung kurz kurz kurz kurz',
        descriptionLong: 'Beschreibung lang Beschreibung lang Beschreibung lang Beschreibung lang Beschreibung lang Beschreibung lang Beschreibung lang ',
        image: {
            data: fs.readFileSync(imgPath3),
            contentType: 'jpg'
        }
    })
];


var done=0;

for (var i=0; i < bikes.length; i++) {
    bikes[i].save(function(err, result){
        done++;
        if (done === bikes.length){
            exit();
        }
    });
}
function exit() {
    mongoose.disconnect();
}
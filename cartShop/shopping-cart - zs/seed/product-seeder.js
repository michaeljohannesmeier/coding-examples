var Product = require('../models/product');

var mongoose = require('mongoose');

//mongoose.connect('localhost:27017/shopping');
mongoose.connect('mongodb://cosmosmongo:1MBcScBX6uEfafJEMF1CwJ8klKEIrvneeMzMBbmUhWoAUfphgUHF1oeUTVwmLLUfgA0RrsgBJjVFCcIaxIWQdw==@cosmosmongo.documents.azure.com:10255/?ssl=true',
    { useMongoClient: true });


var products = [
    new Product({
        imagePath:'http://www.wigglestatic.com/product-media/5360108808/Wiggle-Road-Bike-Road-Bikes-Black-1WGMY16R7048UK0001-6.jpg?w=2000&h=2000&a=7g',
        title: "Wiggle Bike",
        description: "A brand new Wiggle bike!!",
        price: 699
    }),
    new Product({
        imagePath:'http://www.svetmobilne.cz/svetmobilne/media.nsf/v/BEF390973F69EB10C1257CFA004B33F2/$file/star-n9500-170.jpg',
        title: "Samsung Galaxy S4",
        description: "The brand new Samsung Galaxy S4!!",
        price: 219
    }),
    new Product({
        imagePath:'https://www.teelicious.de/wp-content/uploads/Teelicious-Dresden-Neustadt.jpg',
        title: "Chinese Tea Set",
        description: "Complete Chinese Tea Set!!",
        price: 48
    }),
    new Product({
        imagePath:'http://www.lynnmaudlin.com/images/dragon-teapot.png',
        title: "Chinese Tea Cup",
        description: "A beautiful chinese tee cup!!",
        price: 12
    }),

];

var done=0;

for (var i=0; i < products.length; i++) {
    products[i].save(function(err, result){
        done++;
        if (done === products.length){
            exit();
        }
    });
}

function exit() {
    mongoose.disconnect();
}







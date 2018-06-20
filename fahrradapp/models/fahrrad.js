var mongoose = require('mongoose');

var Fahrrad = mongoose.model('Fahrrad', {
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

module.exports = { Fahrrad };
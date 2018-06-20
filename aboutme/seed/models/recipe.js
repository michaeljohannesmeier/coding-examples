var mongoose = require('mongoose');

var Recipe = mongoose.model('Recipe', {
    name: {
        type: String,
        required: true,
        minLength: 1,
        trim: true
    }
    ,
    description: {
        type: String,
        required: true,
        minLength: 1,
        trim: true
    },
    imagePath: {
        type: String,
        required: true,
        minLength:1,
        trim: true
    },
    ingredients: {
        type: {name: String, amount: Number},
        default: []
    }
});

module.exports = { Recipe };

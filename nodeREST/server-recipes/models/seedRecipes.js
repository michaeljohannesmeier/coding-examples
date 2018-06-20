var {mongoose} = require('../db/mongoose');
var {Recipe} = require('./recipe');


var recipe = new Recipe({
    name: 'Tasty Burger',
    description: 'Wonderful tasty xxxl burger with onion and tomatos',
    imagePath: 'https://photos.bigoven.com/recipe/hero/vampire-spagetti.jpg',
    ingredients: [
        {name: 'Tomatoes', amount: 10},
        {name: 'Onions', amount: 5},
        {name: 'Cheese', amount: 2}
        ]
});

recipe.save().then((doc) => {
    console.log("hat is wrong");
    console.log('Recipes added', doc);
}, (err) =>  {
    console.log('Recipes not added', err);
});


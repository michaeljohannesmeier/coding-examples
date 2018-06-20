var express = require('express');
var bodyParser = require('body-parser');

var {mongoose} = require('./db/mongoose');
var {Recipe} = require('./models/recipe');
var {ObjectID} = require('mongodb');


var app = express();

app.use(bodyParser.json());

app.post('/addnewrecipe', (req, res) => {
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

app.get('/getallrecipes',(req, res) => {
    Recipe.find().then((recipes) => {
        res.send({recipes})
    }, (err) => {
        res.status(400).send(err)
    });
});

app.get('/getrecipe/:id', (req, res) => {
    var id = req.params.id;
    if(!ObjectID.isValid(id)) {
        console.log("id not valid");
        return res.status(404).send();
    }

    Recipe.findById(id).then((recipe) => {
        if(!recipe) {
            return res.status(404).send();
        }
        res.send({recipe});
    }).catch((err) => {
        res.status(400).send(err)
    });
});


app.listen(4000, () => {
   console.log('Recipe REST started on port 4000')
});


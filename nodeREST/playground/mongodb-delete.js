
const {MongoClient, ObjectID} = require('mongodb');



// connecto to mongodb
MongoClient.connect('mongodb://localhost:27017/TodoApp', (err, db) => {
    if (err) {
        return console.log('Unable to connect to mongodb server');
    }
    console.log('Connected to mongodb server');

    // deleteMany
/*    db.collection('Todos').deleteMany({text: 'Eat Lunch'}).then((result) => {
       console.log(result);
    });*/

    // deleteOne
/*    db.collection('Todos').deleteOne({text: 'Clean room'}).then((result) => {
        console.log(result);
    });*/

    // findOneAndDelte
     db.collection('Todos').findOneAndDelete({complete:true}).then((result) =>{
         console.log(result);
     });


    db.close();
});
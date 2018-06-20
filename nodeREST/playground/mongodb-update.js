
const {MongoClient, ObjectID} = require('mongodb');



// connecto to mongodb
MongoClient.connect('mongodb://localhost:27017/TodoApp', (err, db) => {
    if (err) {
        return console.log('Unable to connect to mongodb server');
    }
    console.log('Connected to mongodb server');

    db.collection('Todos').findOneAndUpdate({
        _id: new ObjectID('5ac26be368c1962f14b4495d')
    }, {
        $set: {
            complete: true
        }
    }, {
        returnOriginal: false
    }).then((result) => {
        console.log(result);
    });

    db.close();
});
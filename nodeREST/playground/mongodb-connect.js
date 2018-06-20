//const MongoClient = require('mongodb').MongoClient;
const {MongoClient, ObjectID} = require('mongodb');

/*  create random _id:
var obj = new ObjectID();
console.log(obj);
*/


// connecto to mongodb
MongoClient.connect('mongodb://localhost:27017/TodoApp', (err, db) => {
    if (err) {
        return console.log('Unable to connect to mongodb server');
    }
    console.log('Connected to mongodb server');

    // necessary for mongo v3:
    // also db changes to client in (err, db), now (err, client)
    // const db = client.db('TodoApp');



//--------- insert one -------------


    db.collection('Todos').insertOne({
       text: 'Something to do 2',
       completed: true
    }, (err, result) => {
        if (err) {
            console.log('Unablt to insert todo', err)
        }
        console.log(JSON.stringify(result.ops, undefined, 2));

    });

/*    db.collection('Users').insertOne({
        _id: 1,
        name: 'Andrew',
        age: 25,
        location: 'Philadelphia'
    }, (err, result) => {
        if (err) {
            console.log('Unablt to insert todo', err)
        }
        console.log(JSON.stringify(result.ops, undefined, 2));
        console.log(result.ops[0]);

    });*/

    db.close();
});
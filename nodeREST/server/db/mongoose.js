var mongoose = require('mongoose');

mongoose.promise = global.Promise;
mongoose.connect('mongodb://localhost:27017/Todos');

module.exports={mongoose};


/*
newTodo.save().then((doc) => {
    console.log('Saved todo', doc)
}, (err) => {
    console.log('Could not save todo', err)
});



var user = new User({
    email: 'example@email.com',

});

user.save().then((doc) => {
    console.log('User saved', doc)
}, (err) => {
    console.log('Could not save todo', err)
});

*/

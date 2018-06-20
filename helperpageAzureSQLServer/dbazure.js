var sql = require("mssql");

// config for your database
var config = {
    options: {
        encrypt: true
    },
    user: 'HelperPageRoot',
    password: 'Password123',
    server: 'helperpage.database.windows.net',
    database: 'helperpage'
};

connection = new sql.Connection(config);

module.exports = connection;

//    var sqlquery = "select * from products";

const db = new sql.Connection(config);
db.connect().then(function () {
    var request = new sql.Request(db);
    var sqlquery = 'SELECT id, used FROM regKeys WHERE regkeys = ${111111}';
    request.query(sqlquery).then(function(results) {
        console.log("inside regkeyssssss");
        console.log(results);
        db.close();
    }).catch(function(err) {
        console.log(err)
        db.close();
    });
}).catch(function(err){
    console.log(err)
});

/*
var sqlquery = "select * from products";
var myData = [];



db.connect().then(function () {

    var request = new sql.Request(db);

    request.query(sqlquery).then(function (result) {
        for (var i in result){
            var row = {
                productId: result[i].productId,
                names: result[i].name,
                description: result[i].description,
                images: result[i].image
            };
            myData.push(row);
        }
        console.log(myData);
        db.close();
    }).catch(function (err) {

        console.log(err);
        db.close();
    });
}).catch(function (err) {

    console.log(err);
});

/*
db.query(sql, function (err, result) {
    if (err) throw err;
    for (var i in result){
        var row = {
            productId: result[i].productId,
            names: result[i].name,
            description: result[i].description,
            images: result[i].image
        };
        myData.push(row);
    }
    console.log(myData);
});
*/

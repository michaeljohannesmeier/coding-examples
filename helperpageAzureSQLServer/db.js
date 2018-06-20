var mysql = require('mysql')
var connection = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database : process.env.DB_NAME

})

connection.connect();

module.exports = connection;
/*
var config = {
    options: {
        encrypt: true
    },
    user: 'HelperPageRoot',
    password: 'Password123',
    server: 'helperpage.database.windows.net',
    database: 'helperpage'
};

sql.connect();
*/
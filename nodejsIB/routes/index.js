var express = require('express');
var router = express.Router();


var _ = require('lodash');
var chalk = require('chalk');

var ib = new (require('ib'))({
    // clientId: 0,
    // host: '127.0.0.1',
    // port: 7496
}).on('error', function (err) {
    console.error(chalk.red(err.message));
}).on('historicalData', function (reqId, date, open, high, low, close, volume, barCount, WAP, hasGaps) {
    if (_.includes([-1], open)) {
        console.log('endhistoricalData');
    } else {
        console.log("sau gaiiil: this is close: " + date + " " + close)
    }
});


ib.connect();

// tickerId, contract, endDateTime, durationStr, barSizeSetting, whatToShow, useRTH, formatDate, keepUpToDate
ib.reqHistoricalData(1, ib.contract.stock('SPY'), '20160308 12:00:00', '3 D', '15 mins', 'TRADES', 1, 1, false);

router.get('/', function(req, res, next) {

// tickerId, contract, endDateTime, durationStr, barSizeSetting, whatToShow, useRTH, formatDate, keepUpToDate
    ib.reqHistoricalData(1, ib.contract.stock('SPY'), '20180117 12:00:00', '1800 S', '1 secs', 'TRADES', 1, 1, false);


  res.render('index', { title: 'Express' });
});

module.exports = router;

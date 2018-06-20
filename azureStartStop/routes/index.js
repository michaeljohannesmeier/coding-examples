var express = require('express');
var router = express.Router();
var request = require('request');

/* GET home page. */
router.get('/', function(req, res, next) {
    res.render('index', { title: 'FS CMAAS RPA' });
});

router.post('/savedata', function(req, res, next) {
    console.log("here in get data");
    console.log(req.method +  req.body);
    res.end("OK");
});

/*
router.get('/startvm1', function(req, res, next) {

    console.log("now send it here");
/!*    request({
        headers: {
            'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IlNTUWRoSTFjS3ZoUUVEU0p4RTJnR1lzNDBRMCIsImtpZCI6IlNTUWRoSTFjS3ZoUUVEU0p4RTJnR1lzNDBRMCJ9.eyJhdWQiOiJodHRwczovL21hbmFnZW1lbnQuYXp1cmUuY29tLyIsImlzcyI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0LzQ5NWYyNDUwLTE5OTQtNGM4Yy1hOTliLTdlM2VkMTE0NGRlYi8iLCJpYXQiOjE1MjA5NzkxMDMsIm5iZiI6MTUyMDk3OTEwMywiZXhwIjoxNTIwOTgzMDAzLCJhaW8iOiJZMk5nWU9pZjhIM2h2ZG1iNVp0K21NbjdkcjI1QkFBPSIsImFwcGlkIjoiM2FjZGE1YTMtYzQ2My00MTgwLWFjZDktODkzOTQzYzBlZGEyIiwiYXBwaWRhY3IiOiIxIiwiaWRwIjoiaHR0cHM6Ly9zdHMud2luZG93cy5uZXQvNDk1ZjI0NTAtMTk5NC00YzhjLWE5OWItN2UzZWQxMTQ0ZGViLyIsIm9pZCI6Ijk5NzYyZDc3LTZjZTktNDlhOC05NmE2LTExMzA2MTU2M2M1NyIsInN1YiI6Ijk5NzYyZDc3LTZjZTktNDlhOC05NmE2LTExMzA2MTU2M2M1NyIsInRpZCI6IjQ5NWYyNDUwLTE5OTQtNGM4Yy1hOTliLTdlM2VkMTE0NGRlYiIsInV0aSI6IlQ3MnpaZFlmZkVhSXNqVnJZS1lzQUEiLCJ2ZXIiOiIxLjAifQ.al-RFOvei-hdhOXWtlPA-BxYReuBRUBjV3xwb-7ey-kbV419ZwK42lbKUx2_pSurJz58onsGmdjzZtiyfAe5PMDFzgUbGRmklEUSxKazvr9dtgcS8mqqTyoj60MM84U96kvACqdjG6PSjfYZLT5TvxML_4gn3UNDIkUwigVKeb6Twbp2hS5hhgAzwZcaejfg92X6flD7pSuj4X1BG76fcV01AF052dcC5N0uNT74_KreX2VCsK8ILo4YxewSO-6atFFeBR7artKBgUP7xfSJeyQeian1qIt5EJlhUYOD3T0qNjI9kHT1mNLkyTVDbPvCxNPjcpx-x3Sp2Bf7RwGscA',
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        uri: 'https://management.azure.com/subscriptions/b3509b4a-399b-4cb8-b2eb-cead07182b5d/resourceGroups/cmaasrpa/providers/Microsoft.Compute/virtualMachines/cmaasrpa1/start?api-version=2017-12-01',
        body: '',
        method: 'POST'
    }, function (err, res, body) {
        console.log("This is error");
        console.log(err);
        console.log("this is resp");
        console.log(res);
    });*!/

    request({
        headers: {
            'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IlNTUWRoSTFjS3ZoUUVEU0p4RTJnR1lzNDBRMCIsImtpZCI6IlNTUWRoSTFjS3ZoUUVEU0p4RTJnR1lzNDBRMCJ9.eyJhdWQiOiJodHRwczovL21hbmFnZW1lbnQuYXp1cmUuY29tLyIsImlzcyI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0LzQ5NWYyNDUwLTE5OTQtNGM4Yy1hOTliLTdlM2VkMTE0NGRlYi8iLCJpYXQiOjE1MjA5NzkxMDMsIm5iZiI6MTUyMDk3OTEwMywiZXhwIjoxNTIwOTgzMDAzLCJhaW8iOiJZMk5nWU9pZjhIM2h2ZG1iNVp0K21NbjdkcjI1QkFBPSIsImFwcGlkIjoiM2FjZGE1YTMtYzQ2My00MTgwLWFjZDktODkzOTQzYzBlZGEyIiwiYXBwaWRhY3IiOiIxIiwiaWRwIjoiaHR0cHM6Ly9zdHMud2luZG93cy5uZXQvNDk1ZjI0NTAtMTk5NC00YzhjLWE5OWItN2UzZWQxMTQ0ZGViLyIsIm9pZCI6Ijk5NzYyZDc3LTZjZTktNDlhOC05NmE2LTExMzA2MTU2M2M1NyIsInN1YiI6Ijk5NzYyZDc3LTZjZTktNDlhOC05NmE2LTExMzA2MTU2M2M1NyIsInRpZCI6IjQ5NWYyNDUwLTE5OTQtNGM4Yy1hOTliLTdlM2VkMTE0NGRlYiIsInV0aSI6IlQ3MnpaZFlmZkVhSXNqVnJZS1lzQUEiLCJ2ZXIiOiIxLjAifQ.al-RFOvei-hdhOXWtlPA-BxYReuBRUBjV3xwb-7ey-kbV419ZwK42lbKUx2_pSurJz58onsGmdjzZtiyfAe5PMDFzgUbGRmklEUSxKazvr9dtgcS8mqqTyoj60MM84U96kvACqdjG6PSjfYZLT5TvxML_4gn3UNDIkUwigVKeb6Twbp2hS5hhgAzwZcaejfg92X6flD7pSuj4X1BG76fcV01AF052dcC5N0uNT74_KreX2VCsK8ILo4YxewSO-6atFFeBR7artKBgUP7xfSJeyQeian1qIt5EJlhUYOD3T0qNjI9kHT1mNLkyTVDbPvCxNPjcpx-x3Sp2Bf7RwGscA',
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        uri: 'https://management.azure.com/subscriptions/b3509b4a-399b-4cb8-b2eb-cead07182b5d/resourceGroups/cmaasrpa/providers/Microsoft.Compute/virtualMachines/cmaasrpa1/instanceView?api-version=2017-12-01',
        body: '',
        method: 'GET'
    }, function (err, res, body) {
        console.log("This is error");
        console.log(err);
        var response = JSON.parse(res.body);
        console.log("this is response.statuses");
        console.log(response.statuses.displayStatus);
    });


    res.redirect('/');
});

router.get('/startvm2', function(req, res, next) {
    res.render('index', { title: 'FS CMAAS RPA' });
});
*/


/*
router.get('/getbearer', function(req, res, next) {
    res.status(200).json({
        message:'It works!'
    });
    var tenantId = "495f2450-1994-4c8c-a99b-7e3ed1144deb";
    var clientId = "3acda5a3-c463-4180-acd9-893943c0eda2";
    var clientSecret = "C8pn5xjXK3GrlScXUjgJvvgkzUCaMTDvvuyFtG5zeLU=";
    request({
        headers: '',
        uri: 'https://login.microsoftonline.com/' + tenantId + '/oauth2/token',
        body: "grant_type=client_credentials&client_id="+ clientId + "&resource=https://management.azure.com/&client_secret=" + clientSecret,
        method: 'POST'
    }, function (error, response, body) {
        if (!error) {
            console.log("no error");
            var bodyJson = JSON.parse(body);
            console.log(bodyJson.access_token);
        } else {
            //response.end(error);
            console.log("error");
            console.log(error);
        }
    });


});
*/

/*
router.get('/getstatus', function(req, res, next) {

    var vmStatuses = [1,2,3];
    var counter = 0;
    var bearer = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IlNTUWRoSTFjS3ZoUUVEU0p4RTJnR1lzNDBRMCIsImtpZCI6IlNTUWRoSTFjS3ZoUUVEU0p4RTJnR1lzNDBRMCJ9.eyJhdWQiOiJodHRwczovL21hbmFnZW1lbnQuYXp1cmUuY29tLyIsImlzcyI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0LzQ5NWYyNDUwLTE5OTQtNGM4Yy1hOTliLTdlM2VkMTE0NGRlYi8iLCJpYXQiOjE1MjEwNjg1OTAsIm5iZiI6MTUyMTA2ODU5MCwiZXhwIjoxNTIxMDcyNDkwLCJhaW8iOiJZMk5nWUZqSTNsdDNLY0ZkZlpMbXF5OVZ0ZXNYQUFBPSIsImFwcGlkIjoiM2FjZGE1YTMtYzQ2My00MTgwLWFjZDktODkzOTQzYzBlZGEyIiwiYXBwaWRhY3IiOiIxIiwiaWRwIjoiaHR0cHM6Ly9zdHMud2luZG93cy5uZXQvNDk1ZjI0NTAtMTk5NC00YzhjLWE5OWItN2UzZWQxMTQ0ZGViLyIsIm9pZCI6Ijk5NzYyZDc3LTZjZTktNDlhOC05NmE2LTExMzA2MTU2M2M1NyIsInN1YiI6Ijk5NzYyZDc3LTZjZTktNDlhOC05NmE2LTExMzA2MTU2M2M1NyIsInRpZCI6IjQ5NWYyNDUwLTE5OTQtNGM4Yy1hOTliLTdlM2VkMTE0NGRlYiIsInV0aSI6IkR5amxqcnluLTBtRk1WRUlHRmNwQUEiLCJ2ZXIiOiIxLjAifQ.EsyIaELF_Ugi7Y-Jq5KlHLepZkKsqiEujLmlgwBDWiaFbfIBkca65rIlIS2tGJ-oQzp5PLXf8ePC2jBV0FqFeihDa_a7ChbTAsFwqWN3lyvf4I8oZD9mSjVVtVlqJpHkReWvUZTCpHirRoODiRDEQhnR-6ZHEdncMMmW1NvD-3wbTtPUCfo7EvMcksIBZbDdY6KwdSzdBFD5Gh90UpEX1VpSIu2KNJYgeJ_0BLWREm-4KvQBZEVCW_2Gr0T51YGpO_hhxaIoIhFY2ssGlzkRP16ztRao5TQ6sXs2SrWtQu1-Pc7_SJzy_QWrPxxDgi3i9EsHhky0Pf2QRMrum6s6Zg";

function func1() {
    request({
        headers: {
            'Authorization': 'Bearer ' + bearer,
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        uri: 'https://management.azure.com/subscriptions/b3509b4a-399b-4cb8-b2eb-cead07182b5d/resourceGroups/cmaasrpa/providers/Microsoft.Compute/virtualMachines/cmaasrpa' + 1 + '/instanceView?api-version=2017-12-01',
        body: '',
        method: 'GET'
    }, function (err, respo, body) {
        console.log(err);
        var response = JSON.parse(body);
        vmStatuses[0] = response.statuses[1].displayStatus;
        counter = counter + 1;
    });
};
function func2() {
    request({
        headers: {
            'Authorization': 'Bearer ' + bearer,
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        uri: 'https://management.azure.com/subscriptions/b3509b4a-399b-4cb8-b2eb-cead07182b5d/resourceGroups/cmaasrpa/providers/Microsoft.Compute/virtualMachines/cmaasrpa' + 2 + '/instanceView?api-version=2017-12-01',
        body: '',
        method: 'GET'
    }, function (err, respo, body) {
        console.log(err);
        var response = JSON.parse(body);
        vmStatuses[1] = response.statuses[1].displayStatus;
        counter = counter + 1;
    });
};
function func3() {
    request({
        headers: {
            'Authorization': 'Bearer ' + bearer,
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        uri: 'https://management.azure.com/subscriptions/b3509b4a-399b-4cb8-b2eb-cead07182b5d/resourceGroups/cmaasrpa/providers/Microsoft.Compute/virtualMachines/cmaasrpa' + 3 + '/instanceView?api-version=2017-12-01',
        body: '',
        method: 'GET'
    }, function (err, respo, body) {
        console.log(err);
        var response = JSON.parse(body);
        vmStatuses[2] = response.statuses[1].displayStatus;
        counter = counter + 1;
    });

};
function printSomething() {
    console.log("printSomething");
}

async function executeall() {
    await printSomething();
    await func1();
    await printSomething();
    await func2();
    await printSomething();
    await func3();
};
executeall();




});
*/


module.exports = router;

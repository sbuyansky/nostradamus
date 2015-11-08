var express = require('express');
var router = express.Router();
var pg = require('pg');
var path= require('path');
var connectionString = process.env.DATABASE_URL || 'postgres://sbuyansky:test_password@localhost:5432/nostradamus';

/*
//
// AtlasElect API v0.1 
// Supports: Results
// DBMS: PostgreSQL
//
*/

router.get('/quiz', function(req,res){
    return queryResults("SELECT * FROM quiz", res); 
});

router.get('/question/:question_id', function(req,res){
    return queryResults("SELECT * FROM questions WHERE question_id = " + req.params.question_id, res); 
});

var queryResults = function(querySQL, res){
    var results = [];
    pg.connect(connectionString, function(err, client, done) {
        var query = client.query(querySQL);

        query.on('row', function(row) {
            results.push(row);
        });

        query.on('end', function() {
            client.end();
            return res.json(results);
        });

        if(err) {
          console.log(err);
        }
    });
}

router.get('/category/:category', function(req,res){
    return queryResults("SELECT unnest(enum_range(NULL::" + req.params.category + "))", res);
});

module.exports = router;


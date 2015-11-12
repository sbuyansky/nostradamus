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

router.post('/quiz', function(req, res) {	
	var results = [];
	var quiz = req.body;
	var questionNum = 1;
	// post data to the server
	pg.connect(connectionString, function(err, client, done) {

		//create quiz
		var query  = client.query("INSERT INTO quiz(title, for_date) values($1,$2) RETURNING quiz_id", [quiz.title, quiz.date]);

		query.on('row', function(row) {
			results.push(row);
		});

		query.on('end', function() {
			quiz_id = results[0].quiz_id;	
		});

		//create questions
		var questions = [];
		console.log(quiz);
		for(var i = 0; i < quiz.questions.length; i++){
			var questionResults = [];
			var question = quiz.questions[i];
			query  = client.query("INSERT INTO question(type, text) values($1,$2) RETURNING question_id", [question.type, question.text]);

			query.on('row', function(row) {
				questionResults.push(row);
			});

			query.on('end', function() {
				question_id = questionResults[0].question_id;
				//link quiz and questions
				client.query("INSERT INTO quiz_questions(quiz_id, question_id, gui_order) values($1, $2, $3)", [quiz_id, question_id, questionNum]);
			});
			
			questionNum++;
			
			var choices = [];
			if(question.type == 'multiple_select'){
				for(var j = 0; j < question.choices.length; j++){
					choiceResults = [];
					var choice = question.choices[j];
					console.log(choice);
					//create choices if they don't exist
					var choiceQuery = "with s as (" +
						"select choice_id, text " + 
						"from choices " +
						"where text = $1 " + 
					"), i as (" +
						"insert into choices (text) " +
						"select $2 " +
						"where not exists (select text from s) " +
						"returning choice_id " +
					")" +
					"select choice_id " +
					"from i " +
					"union all " +
					"select choice_id " +
					"from s";

					query = client.query(choiceQuery, [choice, choice]);

					query.on('row', function(row){
						choiceResults.push(row)
					});

					query.on('end', function(){
						choice_id = choiceResults[0].choice_id;
						console.log(choice_id);	
						//link question and choices
						client.query("INSERT INTO q_to_a(question_id, choice_id) values($1,$2)", [question_id, choice_id]);
					});
				}
			}	
		}

		if(err) {
		    console.log(err);
		}
	});
});

var queryResults = function(querySQL, res){
    var results = [];
    pg.connect(connectionString, function(err, client, done) {
		console.log(err);
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


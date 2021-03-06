var express = require('express');
var router = express.Router();
var pg = require('pg');
var path= require('path');
var connectionString = process.env.DATABASE_URL || 'postgres://sbuyansky:test_password@localhost:5432/nostradamus';
var async = require('async');

/*
//
// Nostradamus API v0.1 
// DBMS: PostgreSQL
//
*/

router.get('/quiz', function(req,res){
    queryResults("SELECT * FROM quiz", function(results){
		return res.json(results);
	}); 
});

router.get('/question/:question_id', function(req,res){
	queryResults("SELECT * FROM questions WHERE question_id = " + req.params.question_id, function(results){
		return res.json(results);
	}); 
});

router.get('/quiz/:quiz_id', function(req, res){
	var unformattedResults =  queryResults("SELECT q.*, qu.question_id AS question_id, qu.text AS question_text, qu.type AS question_type, c.text AS choice_text FROM quiz q FULL OUTER JOIN quiz_questions qq ON q.quiz_id = qq.quiz_id FULL OUTER JOIN question qu ON qq.question_id = qu.question_id FULL OUTER JOIN q_to_a qa ON qq.question_id = qa.question_id FULL OUTER JOIN choices c ON qa.choice_id = c.choice_id WHERE q.quiz_id = '" +  req.params.quiz_id + "' ORDER BY qq.gui_order ASC", 

	function(unformattedResults){

		//format results

		var results = {};
		results.title = unformattedResults[0].title;
		results.date = unformattedResults[0].for_date;
		
		results.questions = [];
		var questionNum = 0;
		var prevQuestionId = -1;
		unformattedResults.forEach(
			function(questionIter){
				if(prevQuestionId != questionIter.question_id){
					question = {};
					question.type = questionIter.question_type;
					question.text = questionIter.question_text;
					prevQuestionId = questionIter.question_id;
					if(question.type == 'multiple_select'){
						question.choices = [];
						question.choices.push(questionIter.choice_text);
					}
					results.questions[questionNum] = question;
					questionNum++;
				}
				else{
					results.questions[questionNum - 1].choices.push(questionIter.choice_text);
				}		
			}
		);

		return res.json(results);
	});
});

router.post('/quiz', function(req, res) {
	console.log("quiz post");	
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

			//create questions
			var questionResults = [];
			async.eachSeries(quiz.questions, function(question, callback){
				console.log("creating question: " + question);
				query  = client.query("INSERT INTO question(type, text) values($1,$2) RETURNING question_id", [question.type, question.text]);

				query.on('row', function(row) {
					questionResults = [];
					questionResults.push(row);
				});

				query.on('end', function() {
					question_id = questionResults[0].question_id;
					//link quiz and questions
					console.log("associating quiz and question " + question_id);
					client.query("INSERT INTO quiz_questions(quiz_id, question_id, gui_order) values($1, $2, $3)", [quiz_id, question_id, questionNum]);
				
					questionNum++;
					console.log(question);	
					if(question.type == 'multiple_select'){
						var choiceResults = [];
						async.eachSeries(question.choices, function(choice, callback2){
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
							console.log("creating choice: " + choice);
							query = client.query(choiceQuery, [choice, choice]);

							query.on('row', function(row){
								choiceResults = [];
								choiceResults.push(row)
							});

							query.on('end', function(){
								choice_id = choiceResults[0].choice_id;
								console.log("associating question " + question_id + " and choice " + choice_id);

								//link question and choices
								client.query("INSERT INTO q_to_a(question_id, choice_id) values($1,$2)", [question_id, choice_id]);
							console.log("callback2");
							callback2(null,choice);
							});
						}, 
						function(err){
							console.log("callback/choice done");
							callback(null, question);	
						});
					}
					else{
						console.log("callback");
						callback(null,question);
					}	
				});
			},function(err){
				console.log("done");
				done();
				return res.send("success");
			});
		});

		if(err) {
		    console.log(err);
		}
	});


});

var queryResults = function(querySQL, callback){
    var results = [];
    pg.connect(connectionString, function(err, client, done) {
		console.log(err);
        var query = client.query(querySQL);

        query.on('row', function(row) {
            results.push(row);
        });

        query.on('end', function() {
            client.end();
            callback(results);
        });

        if(err) {
          console.log(err);
        }
    });
}

router.get('/category/:category', function(req,res){
    queryResults("SELECT unnest(enum_range(NULL::" + req.params.category + "))", function(results){
		return res.json(results);
	});
});

module.exports = router;


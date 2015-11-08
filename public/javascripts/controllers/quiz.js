/* result controller */

angular.module('nostradamus').controller('quizController', function($scope, $http){
    $scope.formData = {};
    $scope.quiz = {};

    String.prototype.capitalize = function() {
        return this.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
    }

    getCategoryValues = function(category){
        return $http.get('/api/category/' + category)
            .then(function(response) {
                var vals = []; 
                var data = response.data;
                 
                for (var i = 0; i < data.length; i++){
                    vals[data[i].unnest] = data[i].unnest.replace("_"," ").capitalize();
                }
                $scope[category + "Vals"] = vals;
            });
    };

    $scope.addChoice = function(){
        if($scope.question.choices == null){
            $scope.question.choices = [];
        }
        if($scope.question.choices.indexOf($scope.formData.choiceToAdd) > -1){
            $scope.formData.choiceToAdd = "Duplicates are not allowed";
            return;
        }
        $scope.question.choices.push($scope.formData.choiceToAdd);
    }

    $scope.addQuestion = function(){
        if($scope.quiz.questions == null){
            $scope.quiz.questions = [];
        }

        $scope.quiz.questions.push($scope.question);
        $scope.question = {};
    }

    function init(){
        //initialize category values
        getCategoryValues("question_type");
    }

    init();
});

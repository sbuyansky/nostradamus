angular.module('nostradamus').controller('predictionController', function($scope, $http, $routeParams){

    $scope.quizData = {};
    $scope.formData = {};
    $scope.quiz_id = $routeParams.quiz_id;

    var init = function(){
        $http.get("/api/quiz/" + $scope.quiz_id)
            .then(function(response){
                $scope.quizData = response.data;
            });
    }

    init();
});


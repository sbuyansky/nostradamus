/*Main App File for scoober.io */

//events angular application
var app = angular.module('nostradamus', ["ngResource","ngRoute","ngAnimate"]).
  config(['$routeProvider', '$locationProvider',
    function($routeProvider, $locationProvider) {
      $locationProvider.html5Mode(true); //get rid of hashtags, will have to test with older browsers
      $routeProvider
        .when("/quiz/:quiz_id", {
          templateUrl: "/views/templates/quiz.html",
          controller: "predictionController",
          activetab: 'Quiz'})
        .when("/create", {
          templateUrl: "/views/templates/quiz_create.html",
          controller: "quizController",
          activetab: 'Create'})
        .otherwise({ redirectTo: "/create" });
    }
  ]
)
    .filter('percentage', ['$filter', function ($filter) {
        return function (input, decimals) {
            return $filter('number')(input * 100, decimals) + '%';
        };
    }])
;


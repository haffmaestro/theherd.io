app = angular.module('app')

app.config(['$stateProvider','$locationProvider','$urlRouterProvider', ($stateProvider,$locationProvider, $urlRouterProvider)->
  $locationProvider.html5Mode(true)
  
  $stateProvider.state "home",
    url: ""
    templateUrl: "herd/show.html"
    controller: 'HomeController'
  
  $stateProvider.state "weeklyReport",
    url: "/herd_weeklies/:herdWeeklyId?user"
    templateUrl: 'weeklyReport/show.html'
    controller: 'WeeklyReportCtrl'
  
  $stateProvider.state "goals",
    url: "/goals"
    templateUrl: 'goals/index.html'
    controller: 'GoalsCtrl'
    
  $urlRouterProvider.otherwise("herd_weeklies/current")
  ]
)

# app.config(['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider)->
#   $routeProvider
#   .when('/herd_weeklies/:herdId', {
#     controller: "WeeklyReportCtrl"
#     })
#   ])
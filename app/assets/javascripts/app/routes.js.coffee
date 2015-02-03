app = angular.module('app')

app.config(['$stateProvider','$locationProvider','$urlRouterProvider', ($stateProvider,$locationProvider, $urlRouterProvider)->
  $locationProvider.html5Mode(true)
  $stateProvider.state "weeklyReport",
    url: "/herd_weeklies/:herdWeeklyId?user"
    templateUrl: 'weeklyReport/show.html'
    controller: 'WeeklyReportCtrl'
  $urlRouterProvider.otherwise('herd_weeklies/1')
  ]
)

# app.config(['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider)->
#   $routeProvider
#   .when('/herd_weeklies/:herdId', {
#     controller: "WeeklyReportCtrl"
#     })
#   ])
app = angular.module('app')

app.factory('WeeklyReportGetter', ['$http', ($http)->
  return {
    get: (id) ->
      $http.get("/api/herd_weeklies/#{id}").then((response) ->
        console.log 'Success'
        response.data
        ).catch((data)->
          console.log 'Error getting data!')
  }
  ])

app.controller('WeeklyReportCtrl', ['WeeklyReportGetter','currentUser','$scope', (WeeklyReportGetter,currentUser, $scope) ->
  vm = $scope
  vm.currentUser = currentUser

  WeeklyReportGetter.get('current').then((response)->
    vm.herdWeekly = response.herd_weekly
    vm.users = _.map(vm.herdWeekly.user_weeklies, (user_weekly) ->
      user_weekly.first_name)
    vm.countUsers = (num for num in [0..vm.users.length-1])
    )

  vm.data = {
    selectedIndex : 0,
  }

  vm.next = -> 
    vm.data.selectedIndex = Math.min(vm.data.selectedIndex + 1, 2)

  vm.previous = ->
    vm.data.selectedIndex = Math.max(vm.data.selectedIndex - 1, 0)
    ])

app.controller('UserWeeklyCtrl', ['$scope', ($scope)->

  ])
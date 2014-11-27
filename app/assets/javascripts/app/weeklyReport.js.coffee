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

app.controller('WeeklyReportCtrl', ['Users', 'WeeklyReportGetter', '$scope', (Users, WeeklyReportGetter, $scope) ->
  vm = $scope

  WeeklyReportGetter.get('current').then((response)->
    vm.herdWeekly = response.herd_weekly
    vm.users1 = _.map(vm.herdWeekly.user_weeklies, (user_weekly) ->
      user_weekly.first_name)
    vm.countUsers = (num for num in [0..vm.users.length-1])
    )
  vm.users = Users.get()
  vm.data = {
    selectedIndex : 0,
  }
  vm.countUsers = 4  

 

  vm.next = -> 
    vm.data.selectedIndex = Math.min(vm.data.selectedIndex + 1, 2)

  vm.previous = ->
    vm.data.selectedIndex = Math.max(vm.data.selectedIndex - 1, 0)
    ])

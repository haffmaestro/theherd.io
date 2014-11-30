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

app.controller('WeeklyReportCtrl', ['WeeklyReportGetter','WeeklyTask', 'currentUser','$scope', (WeeklyReportGetter,WeeklyTask,currentUser, $scope) ->
  vm = $scope
  vm.currentUser = currentUser
  vm.newWeeklyTask = ""

  WeeklyReportGetter.get('current').then((response)->
    vm.herdWeekly = response.herd_weekly
    vm.users = _.map(vm.herdWeekly.user_weeklies, (user_weekly) ->
      user_weekly.first_name)
    vm.countUsers = (num for num in [0..vm.users.length-1])
    )

  vm.data = {
    selectedIndex : 0,
  }

  vm.owner = (userWeekly) ->
    userWeekly.user_id == currentUser.id
  vm.friend = (userWeekly) ->
    userWeekly.user_id != currentUser.id

  vm.toggleTaskDone = (task) ->
    task.done = !task.done
    WeeklyTask.update(task).then((response) ->
      console.log(response))

  vm.submitTask = (section)->
    task = {body: vm.newWeeklyTask, section_id: section.id}
    console.log vm.newWeeklyTask
    WeeklyTask.post(task).then((response)->
      console.log(response))


  vm.next = -> 
    vm.data.selectedIndex = Math.min(vm.data.selectedIndex + 1, 2)

  vm.previous = ->
    vm.data.selectedIndex = Math.max(vm.data.selectedIndex - 1, 0)
    ])

app.controller('UserWeeklyCtrl', ['$scope', ($scope)->

  ])
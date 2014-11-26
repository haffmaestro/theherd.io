app = angular.module('app')
app.controller('WeeklyReportCtrl', ['Users', '$scope', (Users, $scope) ->
  vm = $scope
  vm.users = Users.get()
  vm.countUsers = (num for num in [0..vm.users.length-1])
  vm.data = {
    selectedIndex : 0,
    notSelected : 9,
  }

  vm.next = -> 
    vm.data.selectedIndex = Math.min(vm.data.selectedIndex + 1, 2)

  vm.previous = ->
    vm.data.selectedIndex = Math.max(vm.data.selectedIndex - 1, 0)
    ])
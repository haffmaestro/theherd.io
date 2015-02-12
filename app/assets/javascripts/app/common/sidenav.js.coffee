app = angular.module('app')

app.controller('SidenavCtrl', ['$scope', '$mdSidenav','$state','HerdStore', ($scope, $mdSidenav, $state,HerdStore)->
  vm = $scope
  vm.user = HerdStore.getCurrentUser()
  vm.openLeftMenu = ->
    $mdSidenav('left').toggle()

  vm.goHome = ->
    $state.go('home')
    .then((response)->)
    .catch((response)->)

  vm.goWeekly = ->
    $state.go('weeklyReport', {herdWeeklyId: 'current', user: vm.user.first_name})
    .then((response)->)
    .catch((response)->)

  vm.goGoals = ->
    $state.go('goals', {user: vm.user.first_name})
    .then((response)->)
    .catch((response)->)

    ])
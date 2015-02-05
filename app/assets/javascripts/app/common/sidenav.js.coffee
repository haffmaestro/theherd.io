app = angular.module('app')

app.controller('SidenavCtrl', ['$scope', '$mdSidenav','$state', ($scope, $mdSidenav, $state)->
  vm = $scope
  vm.openLeftMenu = ->
    $mdSidenav('left').toggle()

  vm.goPrevious = ->
    console.log vm.data.user
    if reportExists(vm.data.previous)
      $state.go('weeklyReport', {herdWeeklyId: vm.data.previous, user: vm.data.user})
      .then((response)->)
      .catch((response)->
        messageCenterService.add('warning', 'Please try again.', {timeout: 3000}))
    else
      messageCenterService.add('warning', 'This week does not exist.', {timeout: 3000})

  vm.goHome = ->
    $state.go('home')
    .then((response)->)
    .catch((response)->)

  vm.goWeekly = ->
    $state.go('weeklyReport', {herdWeeklyId: 'current'})
    .then((response)->)
    .catch((response)->)

  vm.goGoals = ->
    $state.go('goals')
    .then((response)->)
    .catch((response)->)

    ])
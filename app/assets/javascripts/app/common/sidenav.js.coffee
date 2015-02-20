app = angular.module('app')

app.controller('SidenavCtrl', ['$scope', '$mdSidenav','$state','HerdStore','Feedback', ($scope, $mdSidenav, $state,HerdStore,Feedback)->
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
  vm.openFeedback = (event) ->
    Feedback.show(event)
    setTimeout( ->
      edit = angular.element(".feedback")
      edit.focus()
    , 15
    )

    ])
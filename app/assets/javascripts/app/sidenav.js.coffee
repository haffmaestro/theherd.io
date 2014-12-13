app = angular.module('app')

app.controller('SidenavCtrl', ['$scope', '$mdSidenav', ($scope, $mdSidenav)->
  vm = $scope
  vm.openLeftMenu = ->
    $mdSidenav('left').toggle()
    ])
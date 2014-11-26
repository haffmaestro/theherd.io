app = angular.module('app')

app.controller('SidenavCtrl', ['$scope', '$mdSidenav', ($scope, $mdSidenav)->
  vm = $scope
  vm.openRightMenu = ->
    $mdSidenav('right').toggle()
    ])
(function() {
  var app;

  app = angular.module('app');

  app.controller('SidenavCtrl', [
    '$scope', '$mdSidenav', function($scope, $mdSidenav) {
      var vm;
      vm = $scope;
      return vm.openLeftMenu = function() {
        return $mdSidenav('left').toggle();
      };
    }
  ]);

}).call(this);

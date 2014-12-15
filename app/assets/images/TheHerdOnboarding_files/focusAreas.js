(function() {
  var FocusAreaController, app;

  app = angular.module('app');

  FocusAreaController = function($scope, $mdDialog) {
    var vm;
    vm = $scope;
    vm.hide = function() {
      return $mdDialog.hide();
    };
    vm.cancel = function() {
      return $mdDialog.cancel();
    };
    return vm.answer = function() {
      return $mdDialog.hide(answer);
    };
  };

  app.directive('editFocusAreas', function() {
    return {
      restrict: 'E',
      replace: true,
      template: "<a class=\"focus-areas\" ng-click=\"showDialog()\">\n  <i class=\"fa fa-pencil\"></i></a>",
      controller: function($scope, $mdDialog) {
        var vm;
        vm = $scope;
        return vm.showDialog = function(ev) {
          return $mdDialog.show({
            controller: FocusAreaController,
            templateUrl: './focusAreas.html',
            targetEvent: ev
          });
        };
      }
    };
  });

}).call(this);

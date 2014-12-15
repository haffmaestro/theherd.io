(function() {
  var app;

  app = angular.module('app');

  app.factory('Goals', [
    '$http', function($http) {
      return {
        get: function() {
          return $http.get('/api/goals').then(function(response) {
            return response.data;
          })["catch"](function(response) {
            return console.log("Error at Goals factory");
          });
        },
        update: function(goal) {
          return $http.put("/api/goals/" + goal.id, {
            goal: goal
          }).then(function(response) {
            return response.data;
          })["catch"](function(data) {
            return console.log('Error updating!');
          });
        },
        post: function(goal) {
          return $http.post("/api/goals", {
            goal: goal
          }).then(function(response) {
            return response.data;
          })["catch"](function(data) {
            console.log('Error creating!');
            return data;
          });
        },
        "delete": function(goal) {
          return $http["delete"]("/api/goals/" + goal.id).then(function(response) {
            return response.data;
          })["catch"](function(data) {
            console.log('Error deleting!');
            return data;
          });
        }
      };
    }
  ]);

  app.controller('GoalsCtrl', [
    '$scope', 'Goals', 'currentUser', '$rootScope', function($scope, Goals, currentUser, $rootScope) {
      var vm;
      vm = $scope;
      vm.currentUser = currentUser;
      console.log(currentUser);
      vm.users = [];
      vm.newGoal = "Pease";
      vm.data = {
        selectedIndex: 0,
        goalIndex: 0
      };
      Goals.get().then(function(response) {
        var goal, _i, _len, _ref;
        console.log(response);
        _ref = response.goals;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          goal = _ref[_i];
          vm.users.push(goal.first_name);
        }
        return vm.goals = response.goals;
      });
      $rootScope.$on('nextGoals', function(args) {
        return vm.data.goalIndex = Math.min(vm.data.goalIndex + 1, 3);
      });
      return $rootScope.$on('previousGoals', function(args) {
        return vm.data.goalIndex = Math.max(vm.data.goalIndex - 1, 0);
      });
    }
  ]);

  app.directive('previousGoals', function() {
    return {
      restrict: 'E',
      replace: true,
      template: "<a>\n  <i class=\"fa fa-chevron-left fa-2x\" ng-click=\"previousGoals()\"></i></a>",
      controller: function($rootScope, $scope) {
        var vm;
        vm = $scope;
        return vm.previousGoals = function() {
          console.log("previousGoals called");
          return $rootScope.$emit('previousGoals', {
            change: true
          });
        };
      }
    };
  });

  app.directive('nextGoals', function() {
    return {
      restrict: 'E',
      replace: true,
      template: "<a>\n  <i class=\"fa fa-chevron-right fa-2x\" ng-click=\"nextGoals()\"></i></a>",
      controller: function($rootScope, $scope) {
        var vm;
        vm = $scope;
        return vm.nextGoals = function() {
          console.log("nextGoals called");
          return $rootScope.$emit('nextGoals', {
            change: true
          });
        };
      }
    };
  });

  app.directive('goalHeadlines', function() {
    return {
      restrict: 'E',
      replace: true,
      scope: {
        headlines: '='
      },
      template: "<div class=\"row\" flex=\"100\" layout=\"horizontal\"><div flex=\"50\"><h2 class=\"goals\">{{headlines[0]}}</h2></div><div flex=\"50\"><h2 class=\"goals\">{{headlines[1]}}</h2></div></div>"
    };
  });

  app.directive('goalsDisplay', [
    'Goals', function(Goals) {
      return {
        restrict: 'E',
        replace: true,
        scope: {
          curruser: '=',
          user: '=',
          goals: '=',
          months: '=',
          focus: '='
        },
        template: "<div>\n  <div class=\"row\" layout=\"horizontal\" ng-repeat=\"goal in goals\">\n    <md-checkbox ng-disabled=\"friend()\" md-no-ink ng-model=\"goal.done\" aria-label=\"{{goal.body}}\" ng-change=\"toggleGoalDone(goal)\">\n      {{goal.body}}\n    </md-checkbox>\n    <delete-button-goal ng-hide=\"friend()\" goal=\"goal\" list=\"goals\"/>\n  </div>\n  <form ng-submit=\"submitGoal(focus_area)\" ng-hide=\"friend()\" >\n    <md-text-float label=\"New Goal\" type=\"text\" name=\"newGoal\" ng-model=\"data.newGoal\">\n    </md-text-float>\n  </form>\n</div>",
        controller: function($scope) {
          var vm;
          vm = $scope;
          console.log(vm.user);
          console.log(vm.curruser);
          vm.data = {
            newGoal: ""
          };
          vm.friend = function() {
            var isFriend;
            if (vm.user == null) {
              return false;
            }
            return isFriend = vm.user !== vm.curruser;
          };
          vm.toggleGoalDone = function(goal) {
            console.log("From Angular " + goal.done);
            return Goals.update(goal).then(function(response) {
              return console.log("From Rails " + response);
            });
          };
          return vm.submitGoal = function(focus_area) {
            var goal;
            goal = {
              body: vm.data.newGoal,
              focus_area_id: vm.focus.id,
              done: false,
              months: vm.months
            };
            vm.goals.push(goal);
            vm.data.newGoal = "";
            return Goals.post(goal).then(function(response) {
              return console.log(response);
            });
          };
        }
      };
    }
  ]);

  app.directive('deleteButtonGoal', [
    'Goals', function(Goals) {
      return {
        restrict: 'E',
        replace: true,
        scope: {
          goal: '=',
          list: '='
        },
        template: "<a ng-click=\"deleteTask(goal)\" class=\"delete-goal\">\n  <i class=\"fa fa-remove \"></i>\n</a>",
        controller: function($scope) {
          var vm;
          vm = $scope;
          return vm.deleteTask = function(goal) {
            var index;
            Goals['delete'](goal).then(function(response) {
              return console.log(response);
            })["catch"](function(data) {
              return console.log(data);
            });
            index = vm.list.indexOf(goal);
            return vm.list.splice(index, 1);
          };
        }
      };
    }
  ]);

}).call(this);

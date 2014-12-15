(function() {
  var app;

  app = angular.module("app");

  app.factory('WeeklyTask', [
    '$http', function($http) {
      return {
        update: function(task) {
          return $http.put("/api/weekly_tasks/" + task.id, {
            weekly_task: task
          }).then(function(response) {
            return response.data;
          })["catch"](function(data) {
            return console.log('Error updating!');
          });
        },
        post: function(task) {
          return $http.post("/api/weekly_tasks", {
            weekly_task: task
          }).then(function(response) {
            return response.data;
          })["catch"](function(data) {
            console.log('Error creating!');
            return data;
          });
        },
        "delete": function(task) {
          return $http["delete"]("/api/weekly_tasks/" + task.id).then(function(response) {
            return response.data;
          })["catch"](function(data) {
            console.log('Error deleting!');
            return data;
          });
        }
      };
    }
  ]);

  app.directive('deleteButton', [
    'WeeklyTask', function(WeeklyTask) {
      return {
        restrict: 'E',
        replace: true,
        scope: {
          task: '=',
          list: '='
        },
        template: "<a ng-click=\"deleteTask(task)\" class=\"delete-task\">\n  <i class=\"fa fa-remove \"></i>\n</a>",
        controller: function($scope) {
          var vm;
          vm = $scope;
          return vm.deleteTask = function(task) {
            var index;
            WeeklyTask['delete'](task).then(function(response) {
              return console.log(response);
            })["catch"](function(data) {
              return console.log(data);
            });
            index = vm.list.weekly_tasks.indexOf(task);
            return vm.list.weekly_tasks.splice(index, 1);
          };
        }
      };
    }
  ]);

  app.directive('weeklyTasks', [
    'WeeklyTask', function(WeeklyTask) {
      return {
        restrict: 'E',
        replace: true,
        scope: {
          tasks: '=',
          section: '='
        },
        template: "<div>\n  <div class=\"row\" layout=\"horizontal\" ng-repeat=\"task in tasks\">\n    <md-checkbox md-no-ink ng-model=\"task.done\" aria-label=\"{{task.body}}\" ng-change=\"toggleTaskDone(task)\">\n      {{task.body}}\n    </md-checkbox>\n    <delete-button task=\"task\" list=\"section\"/>\n  </div>\n  <form ng-submit=\"submitTask(section)\">\n    <md-text-float label=\"New Task\" type=\"text\" name=\"newWeeklyTask\" ng-model=\"data.newWeeklyTask\">\n    </md-text-float>\n  </form>\n</div>",
        controller: function($scope) {
          var vm;
          vm = $scope;
          vm.data = {
            newWeeklyTask: ""
          };
          vm.toggleTaskDone = function(task) {
            console.log(task.done);
            return WeeklyTask.update(task).then(function(response) {
              return console.log(response);
            });
          };
          return vm.submitTask = function(section) {
            var task;
            task = {
              body: vm.data.newWeeklyTask,
              section_id: section.id,
              done: false
            };
            section.weekly_tasks.push(task);
            vm.data.newWeeklyTask = "";
            return WeeklyTask.post(task).then(function(response) {
              return console.log(response);
            });
          };
        }
      };
    }
  ]);

  app.directive('weeklyTasksFriend', [
    'WeeklyTask', function(WeeklyTask) {
      return {
        restrict: 'E',
        replace: true,
        scope: {
          tasks: '=',
          section: '='
        },
        template: "<div>\n  <div class=\"row\" layout=\"horizontal\" ng-repeat=\"task in tasks\">\n    <md-checkbox ng-disabled=\"true\"  md-no-ink ng-model=\"task.done\" aria-label=\"{{task.body}}\" ng-change=\"toggleTaskDone(task)\">\n      {{task.body}}\n    </md-checkbox>\n  </div>\n</div>"
      };
    }
  ]);

}).call(this);

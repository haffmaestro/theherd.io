(function() {
  var app;

  app = angular.module('app');

  app.factory('Sections', [
    '$http', function($http) {
      return {
        update: function(section) {
          return $http.put("/api/sections/" + section.id, {
            section: section,
            section_id: section.id
          }).then(function(response) {
            return response.data;
          })["catch"](function(data) {
            return console.log('Error updating!');
          });
        }
      };
    }
  ]);

  app.factory('WeeklyReportGetter', [
    '$http', function($http) {
      return {
        get: function(id) {
          return $http.get("/api/herd_weeklies/" + id).then(function(response) {
            console.log('Success');
            return response.data;
          })["catch"](function(data) {
            return console.log('Error getting data!');
          });
        }
      };
    }
  ]);

  app.controller('WeeklyReportCtrl', [
    'WeeklyReportGetter', 'WeeklyTask', 'currentUser', '$scope', function(WeeklyReportGetter, WeeklyTask, currentUser, $scope) {
      var id, id_regex, num_regex, url, vm, year_week_regex;
      vm = $scope;
      vm.currentUser = currentUser;
      id = null;
      year_week_regex = /(201[0-9]-[0-5]\d)/;
      id_regex = /\/\d+/;
      num_regex = url = document.URL;
      vm.herdWeekly = null;
      if (url.match(year_week_regex)) {
        id = year_week_regex.exec(url)[0];
      } else {
        id = id_regex.exec(url)[0].match(/\d+/)[0];
      }
      setTimeout(function() {
        return WeeklyReportGetter.get(id).then(function(response) {
          var num;
          vm.herdWeekly = response.herd_weekly;
          vm.users = _.map(vm.herdWeekly.user_weeklies, function(user_weekly) {
            return user_weekly.first_name;
          });
          return vm.countUsers = (function() {
            var _i, _ref, _results;
            _results = [];
            for (num = _i = 0, _ref = vm.users.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; num = 0 <= _ref ? ++_i : --_i) {
              _results.push(num);
            }
            return _results;
          })();
        });
      }, 750);
      vm.data = {
        selectedIndex: 0
      };
      vm.owner = function(userWeekly) {
        if ((userWeekly != null ? userWeekly.user_id : void 0) == null) {
          return false;
        }
        return userWeekly.user_id === currentUser.id;
      };
      vm.friend = function(userWeekly) {
        if ((userWeekly != null ? userWeekly.user_id : void 0) == null) {
          return false;
        }
        return userWeekly.user_id !== currentUser.id;
      };
      vm.next = function() {
        return vm.data.selectedIndex = Math.min(vm.data.selectedIndex + 1, 2);
      };
      return vm.previous = function() {
        return vm.data.selectedIndex = Math.max(vm.data.selectedIndex - 1, 0);
      };
    }
  ]);

  app.directive('ownerSection', [
    'Sections', function(Sections) {
      return {
        restrict: 'E',
        replace: true,
        scope: {
          section: '='
        },
        template: "<div>\n  <md-card id=\"{{section.name.toLowerCase()}}\">\n    <md-content flex layout=\"vertical\">\n      <div flex=\"70\" ng-dblclick=\"showEdit($event)\">\n        <h4>\n          {{section.name}} This Week\n        </h4>\n        <div class=\"view\" ng-show=\"data.showView\" marked=\"section.body\">\n          \n        </div>\n        <div class=\"edit\" ng-show=\"data.showForm\" flex>\n          <form flex ng-submit=\"saveForm(section)\">\n            <textarea class=\"section\" style=\"width:99%\" msd-elastic ng-model=\"section.body\" ng-blur=\"saveForm(section)\"></textarea>\n        </div>\n        <a class=\"comments-toggle\" ng-click=\"toggleComments()\">\n          <i class=\"fa fa-comments fa-2x\"></i></a>\n      </div>\n      <div flex=\"30\">\n        <h4> \n          Goals Next Week\n        </h4>\n        <weekly-tasks tasks=\"section.weekly_tasks\" section=\"section\"/>\n      </div>\n    </md-content>\n  </md-card>\n  <comments-section section=\"section\"/>\n</div> ",
        controller: function($scope, $rootScope) {
          var vm;
          vm = $scope;
          vm.data = {
            showView: true,
            showForm: false
          };
          vm.toggleComments = function() {
            var channel;
            channel = "showComments-" + vm.section.id;
            return $rootScope.$emit(channel, {
              show: true
            });
          };
          vm.toggleEdit = function() {
            vm.data.showView = !vm.data.showView;
            return vm.data.showForm = !vm.data.showForm;
          };
          vm.showEdit = function($event) {
            vm.toggleEdit();
            setTimeout(function() {
              var edit, view;
              view = angular.element($event.target).parent();
              edit = angular.element(angular.element('textarea', view.parent()).get(0));
              return edit.focus();
            }, 10);
            return true;
          };
          return vm.saveForm = function(section) {
            vm.toggleEdit();
            return Sections.update(section).then(function(data) {
              return console.log(data);
            })["catch"](function(data) {
              return console.log(data);
            });
          };
        }
      };
    }
  ]);

  app.config([
    "markedProvider", function(markedProvider) {
      return markedProvider.setOptions({
        gfm: true,
        tables: true,
        highlight: function(code) {
          return hljs.highlightAuto(code).value;
        }
      });
    }
  ]);

  app.directive('friendSection', [
    'Sections', function(Sections) {
      return {
        restrict: 'E',
        replace: true,
        scope: {
          section: '='
        },
        template: "<div>\n  <md-card id=\"{{section.name.toLowerCase()}}\">\n    <md-content flex layout=\"vertical\">\n      <div flex=\"70\">\n        <h4>\n          {{section.name}} This Week\n        </h4>\n        <div class=\"view\" ng-show=\"data.showView\" marked=\"section.body\">\n          \n        </div>          \n        <a class=\"comments-toggle\" ng-click=\"toggleComments()\">\n          <i class=\"fa fa-comments fa-2x\"></i></a>\n      </div>\n      <div flex=\"30\">\n        <h4> \n          Goals Next Week\n        </h4>\n        <weekly-tasks-friend tasks=\"section.weekly_tasks\" section=\"section\"/>\n      </div>\n    </md-content>\n  </md-card>\n  <comments-section section=\"section\"/>\n</div> ",
        controller: function($scope, $rootScope) {
          var vm;
          vm = $scope;
          vm.data = {
            showView: true,
            showForm: false
          };
          return vm.toggleComments = function() {
            var channel;
            channel = "showComments-" + vm.section.id;
            return $rootScope.$emit(channel, {
              show: true
            });
          };
        }
      };
    }
  ]);

}).call(this);

(function() {
  var app;

  app = angular.module('app');

  app.factory('Comments', [
    '$http', function($http) {
      return {
        get: function(section) {
          return $http.get("/api/sections/" + section.id + "/comments").then(function(response) {
            return response.data;
          })["catch"](function(data) {
            console.log('Error getting comments!');
            return data;
          });
        },
        post: function(comment, section_id) {
          return $http.post("/api/sections/" + section_id + "/comments", {
            comment: comment
          }).then(function(response) {
            return response.data;
          })["catch"](function(data) {
            console.log('Error posting comment!');
            return data;
          });
        }
      };
    }
  ]);

  app.directive('commentsSection', [
    'Comments', '$preloaded', function(Comments, $preloaded) {
      return {
        restrict: 'E',
        replace: true,
        scope: {
          section: '='
        },
        template: "<md-card class=\"comments\" ng-show=\"data.showComments\" flex=\"90\" offset=\"5\">   \n  <div flex class=\"loading\" ng-show=\"data.comments === null\">\n    <br>\n    <md-progress-circular offset=\"45\" md-mode=\"indeterminate\"></md-progress-circular>\n  </div>\n  <div flex class=\"comments\" ng-hide=\"data.comments === null\" >\n    <h4 class=\"comments\">\n      Comments\n    </h4>\n    <div ng-repeat=\"comment in data.comments\">\n      <hr>\n      <h6>\n        {{comment.first_name}} on {{comment.date}}\n      </h6>\n      <p>\n        {{comment.body}}\n      </p>\n    </div>\n    <a class=\"add-comments-toggle\" ng-click=\"newComment()\">\n      <i class=\"fa fa-plus fa-2x\"></i></a>\n    <div class=\"edit\" ng-show=\"data.addComment\" flex>\n      <form flex ng-submit=\"createComment()\">\n        <textarea class=\"section\" style=\"width:50%\" msd-elastic ng-model=\"data.newComment\" ></textarea>\n        <md-button type=\"submit\">Add</md-button>\n    </div>\n  </div>  \n</md-card>",
        controller: function($scope, $rootScope) {
          var vm;
          vm = $scope;
          vm.currentUser = $preloaded.user.user;
          vm.data = {
            showComments: false,
            addComment: false,
            newComment: "",
            channel: "showComments-" + vm.section.id,
            comments: null
          };
          $rootScope.$on(vm.data.channel, function(args) {
            return vm.toggleComments();
          });
          vm.newComment = function() {
            return vm.data.addComment = !vm.data.addComment;
          };
          vm.createComment = function() {
            var comment, today;
            today = new Date(Date.now());
            today = today.toDateString();
            console.log(today);
            comment = {
              section_id: vm.section.id,
              user_id: vm.currentUser.id,
              first_name: vm.currentUser.first_name,
              body: vm.data.newComment,
              date: today
            };
            vm.data.newComment = "";
            vm.data.comments.push(comment);
            vm.data.addComment = false;
            return Comments.post(comment, vm.section.id).then(function(response) {
              return console.log(response);
            });
          };
          return vm.toggleComments = function() {
            vm.data.showComments = !vm.data.showComments;
            if (vm.data.comments === null) {
              setTimeout(function() {
                return Comments.get(vm.section).then(function(response) {
                  console.log(response.comments);
                  return vm.data.comments = response.comments;
                });
              }, 750);
            }
            return true;
          };
        }
      };
    }
  ]);

}).call(this);

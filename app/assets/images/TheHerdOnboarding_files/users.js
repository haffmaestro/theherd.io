(function() {
  var app;

  app = angular.module('app');

  app.factory('Users', [
    '$http', function($http) {
      var users;
      users = ['Halfdan', 'Gareth', 'Jonah', 'Gray'];
      return {
        get: function() {
          return users;
        }
      };
    }
  ]);

  app.factory('currentUser', [
    '$preloaded', function($preloaded) {
      var currentUser;
      currentUser = $preloaded.user;
      return currentUser.user;
    }
  ]);

}).call(this);

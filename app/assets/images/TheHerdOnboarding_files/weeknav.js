(function() {
  var app;

  app = angular.module('app');

  app.directive('previousWeek', function() {
    return {
      restrict: 'E',
      replace: true,
      scope: {
        year: '=',
        week: '='
      },
      template: "<a class=\"week-nav\" href=\"/herd_weeklies/{{year}}-{{week-1}}\">\n  <i class=\"fa fa-chevron-left\"></i></a>"
    };
  });

  app.directive('nextWeek', function() {
    return {
      restrict: 'E',
      replace: true,
      scope: {
        year: '=',
        week: '='
      },
      template: "<a class=\"week-nav\" href=\"/herd_weeklies/{{year}}-{{week+1}}\">\n  <i class=\"fa fa-chevron-right\"></i></a>"
    };
  });

  app.directive('reportArchive', function() {
    return {
      restrict: 'E',
      replace: true,
      template: "<a class=\"week-nav\">\n  <i class=\"fa fa-archive archive\"></i></a>"
    };
  });

  app.directive('weeklyHeader', function() {
    return {
      restrict: 'E',
      replace: true,
      scope: {
        year: "=",
        week: "="
      },
      template: "<a class=\"week-nav\">\n  <h4 ng-cloak class=\"subheader-title\">Weekly Report - Week {{week}}, {{year}}</h4></a>"
    };
  });

}).call(this);

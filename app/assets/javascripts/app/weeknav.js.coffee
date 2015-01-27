app = angular.module('app')


app.directive('previousWeek', ->
  restrict: 'E'
  replace: true
  scope:
    year: '='
    week: '='
  template: """
    <a class="week-nav" href="/herd_weeklies/{{year}}-{{(week < 11 ? '0'+(week-1) : week-1)}}">
      <i class="fa fa-chevron-left"></i></a>
  """
  controller: ['$scope', ($scope)->
    vm = $scope
    console.log vm.year
    vm.data = {
    }
    vm.changeWeek= (year, week) ->

  ]
)

app.directive('nextWeek', ->
  restrict: 'E'
  replace: true
  scope:
    year: '='
    week: '='
  template: """
    <a class="week-nav" href="/herd_weeklies/{{year}}-{{(week < 9 ? '0'+(week+1) : week+1)}}">
      <i class="fa fa-chevron-right"></i></a>
  """
)

app.directive('reportArchive', ->
  restrict: 'E'
  replace: true
  template: """
    <a class="week-nav">
      <i class="fa fa-archive archive"></i></a>
  """
)

app.directive('weeklyHeader', ->
  restrict: 'E'
  replace: true
  scope:
    year: "="
    week: "="
  template: """
    <a class="week-nav">
      <h4 ng-cloak class="subheader-title">Weekly Report - Week {{week}}, {{year}}</h4></a>
  """
)

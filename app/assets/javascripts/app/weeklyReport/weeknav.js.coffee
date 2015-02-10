app = angular.module('app')

app.directive('weekNavigation', ['messageCenterService','HerdActions','HerdStore', ( messageCenterService,HerdActions, HerdStore)->
  restrict: 'E'
  replace: true
  transclude: true
  scope:
    next: '='
    previous: '='
  template: """
    <div ng-cloak>
      <a class="week-nav" ng-click="goPrevious()">
        <i class="fa fa-chevron-left"></i></a>
      <a class="week-nav" ng-click="goNext()">
        <i class="fa fa-chevron-right"></i></a>
    </div>
  """
  controller: ['$scope','$rootScope','$state', ($scope, $rootScope, $state)->
    vm = $scope
    vm.data = {

    }
    $rootScope.$on('navigationData', (event, data)->
      vm.data.previous = data.previous
      vm.data.next = data.next
      vm.data.user = data.user
      )
    HerdActions.fetchWeeklyReports()
    HerdStore.on('change',->
      vm.data.reports = _.map(HerdStore.getWeeklyReports(), (herdWeekly)->
        herdWeekly.year_week_id))

    vm.goPrevious = ->
      console.log vm.data.user
      if reportExists(vm.data.previous)
        $state.go('weeklyReport', {herdWeeklyId: vm.data.previous, user: vm.data.user})
        .then((response)->)
        .catch((response)->
          messageCenterService.add('warning', 'Please try again.', {timeout: 3000}))
      else
        messageCenterService.add('warning', 'This week does not exist.', {timeout: 3000})

    vm.goNext = ->
      console.log vm.data.user
      if reportExists(vm.data.next)
        $state.go('weeklyReport', {herdWeeklyId: vm.data.next, user: vm.data.user})
        .then((response)->
          messageCenterService.add('warning', 'Plase try again.', {timeout: 3000}))
        .catch((response)->)
      else
        messageCenterService.add('warning', 'This week does not exist.', {timeout: 3000})

    reportExists = (report) ->
      index = vm.data.reports.indexOf(report)
      if index >= 0
        return true
      else
        return false
    ]
  ])


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

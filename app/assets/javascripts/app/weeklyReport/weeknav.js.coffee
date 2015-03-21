app = angular.module('app')

app.directive('weekNavigation', ['Notification','HerdActions','HerdStore','NavigationStore', (Notification, HerdActions, HerdStore,NavigationStore)->
  restrict: 'E'
  replace: true
  transclude: true
  scope:
    next: '='
    previous: '='
  template: """
    <div ng-cloak>
      <a class="week-nav hover-hand" ng-click="goPrevious()">
        <i class="fa fa-chevron-left"></i></a>
      <a class="week-nav hover-hand" ng-click="goNext()">
        <i class="fa fa-chevron-right"></i></a>
    </div>
  """
  controller: ['$scope','$rootScope','$state', ($scope, $rootScope, $state)->
    vm = $scope
    vm.data = {
      current: NavigationStore.getCurrentWeeklyReport()
      reports: NavigationStore.getWeeklyReports()
      nav: NavigationStore.getWeeklyReportRoutingData()
    }
    HerdActions.fetchWeeklyReports() if vm.data.reports.length == 0
    NavigationStore.bindState($scope, ->
      vm.data.reports = _.map(NavigationStore.getWeeklyReports(), (herdWeekly)->
        herdWeekly.year_week_id)
      vm.data.nav = NavigationStore.getWeeklyReportRoutingData()
      vm.data.current = NavigationStore.getCurrentWeeklyReport())
    vm.goPrevious = ->
      index = vm.data.reports.indexOf(vm.data.current.year_week_id)
      if index > 0
        $state.go('weeklyReport', {herdWeeklyId: vm.data.reports[index-1], user: vm.data.nav.user}).
          catch((response)->
            Notification.show('Please try again', 2000)
          )
      else
        Notification.show('There are no more reports', 2000)

    vm.goNext = ->
      index = vm.data.reports.indexOf(vm.data.current.year_week_id)
      if index < vm.data.reports.length - 1
        $state.go('weeklyReport', {herdWeeklyId: vm.data.reports[index+1], user: vm.data.nav.user}).
          catch((response)->
            Notification.show('Please try again', 2000))
      else
        Notification.show('There are no more reports', 2000)

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

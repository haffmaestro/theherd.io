app = angular.module('app')

app.directive('weekNavigation', ->
  restrict: 'E'
  replace: true
  template: """
    <p> Hello </p>
  """
)

app.directive('previousWeek', ->
  restrict: 'E'
  replace: true
  template: """
    <a>
      <i class="fa fa-chevron-left"></i></a>
  """
)

app.directive('nextWeek', ->
  restrict: 'E'
  replace: true
  template: """
    <a>
      <i class="fa fa-chevron-right"></i></a>
  """
)

app.directive('reportArchive', ->
  restrict: 'E'
  replace: true
  template: """
    <a>
      <i class="fa fa-archive"></i></a>
  """
)

app.directive('weeklyHeader', ->
  restrict: 'E'
  replace: true
  scope:
    year: "="
    week: "="
  template: """
    <a>
      <h4 class="subheader-title">Weekly Report - Week {{week}}, {{year}}</h4></a>
  """
)

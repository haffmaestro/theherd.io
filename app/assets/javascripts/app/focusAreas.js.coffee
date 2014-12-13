app = angular.module('app')

app.directive('editFocusAreas', ->
  restrict: 'E'
  replace: true
  template: """
    <a class="focus-areas">
      <i class="fa fa-pencil"></i></a>
  """
)
app = angular.module('app')

app.directive('fileInput', ['$parse','HerdActions', ($parse , HerdActions) ->
  restrict: 'A'
  link: (scope, elm, attrs) ->
    elm.bind 'change', ->
      $parse(attrs.fileInput).assign scope, elm[0].files
      HerdActions.uploadPicture(scope.files)
])
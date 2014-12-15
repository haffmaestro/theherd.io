app = angular.module('app')

FocusAreaController = ($scope, $mdDialog) ->
	vm = $scope
	vm.hide = -> 
		$mdDialog.hide()
	vm.cancel = ->
	  $mdDialog.cancel()
	vm.answer = ->
	  $mdDialog.hide(answer)


app.directive('editFocusAreas', ->
  restrict: 'E'
  replace: true
  template: """
    <a class="focus-areas" ng-click="showDialog()">
      <i class="fa fa-pencil"></i></a>
  """
  controller: ($scope, $mdDialog) ->
  	vm = $scope
  	vm.showDialog = (ev) ->
  		$mdDialog.show({
	      controller: FocusAreaController,
	      templateUrl: './focusAreas.html',
	      targetEvent: ev,
	    })

)
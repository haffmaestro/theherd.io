app = angular.module('app')

app.factory('Goals', ['$http', ($http)->
	return {
		get: ->
			$http.get('/api/goals').then((response)->
				response.data
				).catch((response)->
					console.log "Error at Goals factory")
		}])

app.controller('GoalsCtrl', ['$scope', 'Goals','currentUser','$rootScope', ($scope, Goals, currentUser, $rootScope)->
	vm = $scope
	vm.currentUser
	vm.users = []
	vm.newGoal = "Pease"
	vm.data = {
		selectedIndex: 0,
		goalIndex: 1
	}
	Goals.get().then((response) ->
		console.log response
		for goal in response.goals
			vm.users.push(goal.first_name)
		vm.goals = response.goals
		debugger
		)
	$rootScope.$on('nextGoals', (args)->
		vm.data.goalIndex = Math.min(vm.data.goalIndex + 1, 3))
	$rootScope.$on('previousGoals', (args)->
		vm.data.goalIndex = Math.max(vm.data.goalIndex - 1, 0))
	])

app.directive('previousGoals', ->
  restrict: 'E'
  replace: true
  template: """
    <a>
      <i class="fa fa-chevron-left" ng-click="previousGoals()"></i></a>
  """
  controller: ($rootScope, $scope) ->
  	vm = $scope
  	vm.previousGoals = ->
  		console.log "previousGoals called"
  		$rootScope.$emit('previousGoals', {change: true})
)

app.directive('nextGoals', ->
  restrict: 'E'
  replace: true
  template: """
    <a>
      <i class="fa fa-chevron-right" ng-click="nextGoals()"></i></a>
  """
  controller: ($rootScope, $scope) ->
  	vm = $scope
  	vm.nextGoals = ->
  		console.log "nextGoals called"
  		$rootScope.$emit('nextGoals', {change: true})
)
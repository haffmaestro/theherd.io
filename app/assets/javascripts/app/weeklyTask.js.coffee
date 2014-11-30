app = angular.module("app")

app.factory('WeeklyTaskHttp', ['$http', ($http)->
  return {
    update: (task) ->
      $http.put("/api/weekly_tasks/#{task.id}", {weekly_task: task}).then((response) ->
        console.log 'Success'
        response.data
        ).catch((data)->
          console.log 'Error updating!')
  }
  ])

app.factory('WeeklyTask', ['$http', ($http)->
  return {
    update: (task) ->
      $http.put("/api/weekly_tasks/#{task.id}", {weekly_task: task}).then((response) ->
        response.data
        ).catch((data)->
          console.log 'Error updating!')
    post: (task) ->
    	$http.post("/api/weekly_tasks", {weekly_task: task}).then((response)->
    		response.data
    		).catch((data)->
    			console.log 'Error creating!')
  }
  ])

app.directive('weeklyTasks', ['WeeklyTaskHttp', (WeeklyTaskHttp)->
	restrict: 'E'
	replace: true
	scope:
	  tasks: '='
	template: """
		<div>
			<div ng-repeat="task in tasks">
				<md-checkbox md-no-ink md-no-ink ng-model="task.done" aria-label="{{task.body}}" ng-click="console.log('Fuck')">
					{{task.body}}
				</md-checkbox>
			</div>
		</div>
	"""

	controller: ($scope) ->
		vm = $scope
		$scope.toggleTaskDone = (task) ->
		  task.done = !task.done
		  console.log "Cunts!"
		  WeeklyTaskHttp.update(task).then((response) ->
		  console.log response
		  )
	])
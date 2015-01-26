app = angular.module('app')

app.factory('Users', ['$http', ($http) ->
  {
    get: ->
      $http.get("api/users").then((response)->
        console.log response
        response.data.users)
  }
  ])

app.factory('currentUser', ['$preloaded', ($preloaded)->
	currentUser = $preloaded.user
	currentUser.user
	])

app.directive('members', ['Users', (Users)->
  restrict: 'E'
  replace: true
  template: """
    <md-card ng-repeat="user in data.users">
      <h3>{{user.first_name}} {{user.last_name}}<h4>
      <h4> Weekly Reports Completed: {{user.weekly_reports_count}} </h4>
      <h4> Goals Completed: {{user.goals_count}} </h4>
      <h4> Comments Made: {{user.comment_count}} </h4>
      <h4> Weekly Tasks Completed: {{user.weekly_tasks_count}}  </h4>
    </md-card>
  """
  controller: ['$scope', ($scope)->
    vm = $scope
    vm.data = {
      users: []
    }
    Users.get().then((data)->
      vm.data.users = data)
  ]
])

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
    <md-card ng-repeat="user in data.users" layout="row">
      <div flex="30" offset="5">
      <h3>{{user.first_name}} {{user.last_name}}<h4>
      <h4> Weekly Reports Completed: {{user.weekly_reports_count}} </h4>
      <h4> Goals Completed: {{user.goals_count}} </h4>
      <h4> Comments Made: {{user.comment_count}} </h4>
      <h4> Weekly Tasks Completed: {{user.weekly_tasks_count}}  </h4>
      </div>
      <div flex="60">
        <h3>Focus Areas</h3>
        <div ng-repeat="focusArea in user.focus_areas">
          <div class="display" ng-hide="data.showEdit">
            <p>{{focusArea.name}}</p>
          </div>
          <div class="edit">
            <form ng-submit="" ng-show="data.showEdit">
              <md-text-float type="text" name="newWeeklyTask" ng-model="focusArea.name">
              </md-text-float>
            </form>
          </div>
        </div>
      </div>
    </md-card>
  """
  controller: ['$scope', ($scope)->
    vm = $scope
    vm.data = {
      users: []
      showEdit: false
    }
    Users.get().then((data)->
      vm.data.users = data)
  ]
])

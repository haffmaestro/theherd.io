app = angular.module('app')

app.factory('Users', ['$http', ($http) ->
  {
    get: ->
      $http.get("api/users").then((response)->
        response.data.users)
  }
  ])

app.factory('currentUser', ['$preloaded', ($preloaded)->
	currentUser = $preloaded.user
	currentUser.user
	])

app.directive('members', ['Users','FocusAreas','messageCenterService', (Users, FocusAreas, messageCenterService)->
  restrict: 'E'
  replace: true
  template: """
    <member ng-repeat="user in data.users" user="user"/>
  """
  controller: ['$scope','$rootScope', ($scope,$rootScope)->
    vm = $scope
    vm.data = {
      users: []
      newFocusArea: ""
    }
    Users.get().then((data)->
      vm.data.users = data)


  ]
])

app.directive('member', ['FocusAreas','messageCenterService', (FocusAreas, messageCenterService)->
  restrict: 'E'
  replace: true
  scope:
    user: '='
  template: """
    <md-card layout="row">
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
          <focus-area focus="focusArea" user="user"/>
        </div>
        <form ng-submit="addFocusArea(user)">
          <md-text-float type="text" label="New Focus Area" name="newWeeklyTask" ng-model="data.newFocusArea">
          </md-text-float>
        </form>
      </div>
    </md-card>
  """
  controller: ['$scope','$rootScope', ($scope, $rootScope)->
    vm = $scope
    vm.data = {
      newFocusArea: ""
    }
    $rootScope.$on('deleteFocusArea', (event, data)->
      vm.deleteFocusArea(data.focusArea, data.user)
      )
    vm.addFocusArea = (user)->
      newFocusArea = {name: vm.data.newFocusArea, id: null}
      user.focus_areas.push(newFocusArea)
      vm.data.newFocusArea = ""
      FocusAreas.new(newFocusArea)
      .then((response)->
        if response
          console.log response
          user.focus_areas[user.focus_areas.length-1].id = response.focus_area.id
          messageCenterService.add('success', 'New Focus Area added!', {timeout: 3000})
        else
          messageCenterService.add('warning', 'New Focus Area did not get saved, please try again.', {timeout: 3000})
          user.focus_areas.pop()
        )

    vm.deleteFocusArea = (focusArea, user) ->
      index = vm.user.focus_areas.indexOf(focusArea)
      vm.user.focus_areas.splice(index, 1)
      debugger
      FocusAreas.destroy(focusArea)
      .then((response) ->
        if response
          messageCenterService.add('success', 'Deleted!', {timeout: 3000})
        else
          messageCenterService.add('warning', 'Error, please try again.', {timeout: 3000})
          vm.user.focus_areas.splice(index, 0, focusArea)
        )
      return true

      
      
  ]
])

app = angular.module('app')

app.factory('Users', ['$http', ($http) ->
  {
    get: ->
      $http.get("api/users").then((response)->
        response.data.users)
    updateReport:(id) ->
      $http.patch("api/user_weeklies/#{id}")
      .then((response)->
        response.data)
      .catch((response)->
        false)
  }
  ])

app.factory('currentUser', ['$preloaded', ($preloaded)->
	currentUser = $preloaded.user
	currentUser.user
	])

app.directive('members', ['Users','FocusAreas','HerdActions','HerdStore','messageCenterService', (Users, FocusAreas, HerdActions, HerdStore, messageCenterService)->
  restrict: 'E'
  replace: true
  template: """
    <member user="user" ng-repeat="user in data.users"></member>
  """
  controller: ['$scope','$rootScope', ($scope,$rootScope)->
    vm = $scope
    vm.data = {
      users: HerdStore.getUsers()
      newFocusArea: ""
    }
    HerdActions.fetchUsers()
    HerdStore.on('change', ->
      vm.data.users = HerdStore.getUsers())


  ]
])

app.directive('member', ['FocusAreas','Users','messageCenterService','HerdStore','HerdActions', (FocusAreas,Users, messageCenterService, HerdStore, HerdActions)->
  restrict: 'E'
  replace: true
  scope:
    user: "="
  template: """
    <md-card layout="row">
      <div flex="50 offset="10">
      <h3>{{user.first_name}} {{user.last_name}}<h4>
      <h4> Weekly Reports Completed: {{user.weekly_reports_count}} </h4>
      <h4> Goals Completed: {{user.goals_count}} </h4>
      <h4> Comments Made: {{user.comment_count}} </h4>
      <h4> Weekly Tasks Completed: {{user.weekly_tasks_count}}  </h4>
      </div>
      <div flex="40">
        <h3>Focus Areas  </h3>
          <focus-area focus-area="focusArea" ng-repeat="focusArea in user.focus_areas"></focus-area>
        <form ng-submit="addFocusArea(user)" ng-hide="friend()">
          <md-text-float type="text" label="New Focus Area" name="newWeeklyTask" ng-model="data.newFocusArea">
          </md-text-float>
        </form>
      </div>
      <md-button class="md-primary md-raised upper-right-corner" ng-click="updateReport()" ng-show="data.showUpdateReport">Update Weekly Report</md-button>
    </md-card>
  """
  controller: ['$scope','$rootScope', ($scope, $rootScope)->
    vm = $scope
    vm.data = {
      newFocusArea: ""
      currentUser: HerdStore.getCurrentUser()
      showUpdateReport: false
    }    
    $rootScope.$on('deleteFocusArea', (event, data)->
      if vm.user.id == data.user.id
        vm.deleteFocusArea(data.focusArea, data.user)
      )
    $rootScope.$on('showUpdateReport', (event, data)->
      if vm.user.id == data.user.id
        vm.showUpdateReport()
      )
    vm.addFocusArea = (user)->
      newFocusArea = {name: vm.data.newFocusArea, id: null}
      HerdActions.addFocusArea(newFocusArea)
      vm.data.newFocusArea = ""

    vm.deleteFocusArea = (focusArea, user) ->
      HerdActions.deleteFocusArea(focusArea)

    vm.friend = ->
      return false unless vm.user?
      isFriend = vm.user.id != vm.data.currentUser.id  

    vm.showUpdateReport = ->
      vm.data.showUpdateReport = true

    vm.updateReport = ->
      vm.data.showUpdateReport = false
      Users.updateReport(vm.data.currentUser.id)
      .then((response)->
        if response
        else
          vm.data.showUpdateReport = true
      )



      
      
  ]
])

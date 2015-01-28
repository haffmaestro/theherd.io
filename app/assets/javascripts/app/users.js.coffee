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

app.directive('member', ['FocusAreas','Users','messageCenterService','$preloaded', (FocusAreas,Users, messageCenterService, $preloaded)->
  restrict: 'E'
  replace: true
  scope:
    user: '='
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
        <div ng-repeat="focusArea in user.focus_areas">
          <focus-area focus="focusArea" user="user" isfriend="friend()"/>
        </div>
        <form ng-submit="addFocusArea(user)" ng-hide="friend()">
          <md-text-float type="text" label="New Focus Area" name="newWeeklyTask" ng-model="data.newFocusArea">
          </md-text-float>
        </form>
      </div>
      <md-button class="s md-primary md-raised upper-right-corner" ng-click="updateReport()" ng-show="data.showUpdateReport">Update Weekly Report</md-button>
    </md-card>
  """
  controller: ['$scope','$rootScope', ($scope, $rootScope)->
    vm = $scope
    vm.data = {
      newFocusArea: ""
      currentUser: $preloaded.user.user
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
      user.focus_areas.push(newFocusArea)
      vm.data.newFocusArea = ""
      FocusAreas.new(newFocusArea)
      .then((response)->
        if response
          user.focus_areas[user.focus_areas.length-1].id = response.focus_area.id
          messageCenterService.add('success', 'New Focus Area added!', {timeout: 3000})
          vm.showUpdateReport()
        else
          messageCenterService.add('warning', 'New Focus Area did not get saved, please try again.', {timeout: 3000})
          user.focus_areas.pop()
        )

    vm.deleteFocusArea = (focusArea, user) ->
      index = vm.user.focus_areas.indexOf(focusArea)
      vm.user.focus_areas.splice(index, 1)
      FocusAreas.destroy(focusArea)
      .then((response) ->
        if response
          messageCenterService.add('success', 'Deleted!', {timeout: 3000})
          vm.showUpdateReport()
        else
          messageCenterService.add('warning', 'Error, please try again.', {timeout: 3000})
          vm.user.focus_areas.splice(index, 0, focusArea)
        )
      return true

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

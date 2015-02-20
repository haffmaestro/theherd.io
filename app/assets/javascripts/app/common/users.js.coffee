app = angular.module('app')

app.factory('currentUser', ['$preloaded', ($preloaded)->
	currentUser = $preloaded.user
	currentUser.user
	])

app.directive('members', ['HerdActions','HerdStore', (HerdActions, HerdStore)->
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

app.directive('homeGrid', ['HerdActions', 'HerdStore', (HerdActions, HerdStore)->
  restrict: 'E'
  replace: true
  template: """
    <md-grid-list md-cols-lg="4" md-cols-md="2" md-row-height="200px">
      <md-grid-tile md-rowspan="2" md-colspan="1">
        <md-grid-tile-footer>
          <h3>This is a footer</h3>
        </md-grid-tile-footer>
      </md-grid-tile>
      <md-grid-tile>
        <md-grid-tile-footer>
          <h3>This is a footer</h3>
        </md-grid-tile-footer>
      </md-grid-tile>
      <md-grid-tile>
        <md-grid-tile-footer>
          <h3>This is a footer</h3>
        </md-grid-tile-footer>
      </md-grid-tile>
      <md-grid-tile>
        <md-grid-tile-footer>
          <h3>This is a footer</h3>
        </md-grid-tile-footer>
      </md-grid-tile>
    </md-grid-list>
  """
  controller: controller: ['$scope', ($scope)->
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

app.directive('member', ['HerdStore', 'SettingsStore','Settings','HerdActions','Notification', (HerdStore, SettingsStore,Settings, HerdActions,Notification)->
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
      <md-button class="md-primary md-raised upper-right-corner" ng-click="updateReport()" ng-show="data.showUpdateReport" ng-if="isOwner()">Update Weekly Report</md-button>
    </md-card>
  """
  controller: ['$scope','$rootScope', ($scope, $rootScope)->
    vm = $scope
    vm.data = {
      newFocusArea: ""
      currentUser: HerdStore.getCurrentUser()
      showUpdateReport: HerdStore.canUpdateCurrentReport()
    } 

    HerdStore.bindState($scope, ->
      vm.data.showUpdateReport = HerdStore.canUpdateCurrentReport()
      )

    vm.friend = ->
      return false unless vm.user?
      isFriend = vm.user.id != vm.data.currentUser.id
    vm.isOwner = ->
      return !vm.friend()

    vm.showUpdateReport = ->
      vm.data.showUpdateReport = true
    vm.showSettingsDialog = (event) ->
      HerdActions.toggleSettingsDialog()
      Settings.show(event) 

    vm.updateReport = ->
      HerdActions.updateCurrentWeeklyReport(vm.data.currentUser.id)
  ]
])

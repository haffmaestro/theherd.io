app = angular.module('app')

app.factory('Settings', ['SettingsStore','HerdActions', '$mdDialog', (SettingsStore,HerdActions, $mdDialog)->
  return {
    show: (event)->
      $mdDialog.show({
        template: """
          <md-dialog aria-label="Settings Dialog">
            <md-content>
              <md-subheader class="md-sticky md-primary">
                <h2>Todoist Integration</h2>
              </md-subheader>
              <div class="edit" ng-hide="hasTodoist() && data.showForm">
                <form ng-submit="submitTodoist()" >
                  <md-text-float type="text" name="todoistEmail" ng-model="data.todoistEmail" label="Todoist Email">
                  </md-text-float>
                  <md-text-float type="password" name="todoistPassword" ng-model="data.todoistPassword" label="Todoist Password">
                  </md-text-float>
                </form>
              </div>
              <div class="show" ng-show="hasTodoist() && data.showForm">
                <h1>You've already enabled Todoist!</h1>
              </div>
              <div class="md-actions" layout="row">
                <md-button aria-label="close dialog" ng-click="hide()">Close</md-button>
                <md-button aria-label="submit form" ng-click="submitTodoist()">Submit</md-button>
                <md-button aria-label="update todoist info" ng-show="hasTodoist()" ng-click="data.showForm= !data.showForm">Update Todoist</md-button>
              </div>
            </md-content>
          </md-dialog>
        """
        controller: ['$scope', '$mdDialog', ($scope, $mdDialog)->
          vm = $scope
          vm.data = {
            currentUser: SettingsStore.getCurrentUser()
            todoistEmail: ""
            todoistPassword: ""
          }
          SettingsStore.bindState($scope, ->
            vm.data.currentUser = SettingsStore.getCurrentUser())
          vm.submitTodoist = ->
            console.log vm.data
            HerdActions.loginTodoist(vm.data.currentUser, vm.data.todoistEmail, vm.data.todoistPassword)
          vm.hasTodoist = ->
            vm.data.currentUser.has_todoist
          vm.data.showForm = vm.hasTodoist()
          vm.hide = ->
            $mdDialog.hide()
        ]
        targetEvent: event
      }).
        then(()->

          )
    }
  ])
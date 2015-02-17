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
              <form ng-submit="submitTodoist()" >
                <md-text-float type="text" name="todoistEmail" ng-model="data.todoistEmail" label="Todoist Email">
                </md-text-float>
                <md-text-float type="password" name="todoistPassword" ng-model="data.todoistPassword" label="Todoist Password">
                </md-text-float>
              </form>
              <div class="md-actions" layout="row">
                <md-button aria-label="close dialog" ng-click="hide()">Close</md-button>
                <md-button aria-label="submit form" ng-click="submitTodoist()">Submit</md-button>
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
          vm.submitTodoist= ->
            console.log vm.data
            HerdActions.loginTodoist(vm.data.currentUser, vm.data.todoistEmail, vm.data.todoistPassword)

          vm.hide = ->
            $mdDialog.hide()
        ]
        targetEvent: event
      }).
        then(()->

          )
    }
  ])
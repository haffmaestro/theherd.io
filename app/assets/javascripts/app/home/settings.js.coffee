app = angular.module('app')

app.directive('settingsButton', ['Settings',(Settings)->
  restrict: 'E'
  replace: true
  template: """
    <div>
      <md-button class="md-primary md-raised upper-right-corner settings" ng-click="showSettingsDialog($event)">Preferences</md-button>
    </div>
  """
  controller: ['$scope', ($scope)->
    vm = $scope
    vm.showSettingsDialog = (event) ->
      Settings.show(event)
  ]
])

app.factory('Settings', ['SettingsStore','HerdStore','HerdActions', '$mdDialog', (SettingsStore,HerdStore,HerdActions, $mdDialog)->
  return {
    show: (event)->
      $mdDialog.show({
        template: """
          <md-dialog aria-label="Settings Dialog">
            <md-content>
              <md-subheader class="md-primary">
                <h2>Focus Areas</h2>
              </md-subheader>
                <br>
                <focus-area focus-area="focusArea" ng-repeat="focusArea in data.currentUser.focus_areas"></focus-area>
                <form ng-submit="addFocusArea(user)" ng-hide="friend()">
                  <md-text-float type="text" label="New Focus Area" name="newWeeklyTask" ng-model="data.newFocusArea">
                  </md-text-float>
                </form>
              <md-subheader class="md-primary">
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
                <h3>Todoist is connected.</h3>
              </div>
              <div class="md-actions" layout="row">
                <md-button aria-label="close dialog" ng-click="hide()">Close</md-button>
                <md-button aria-label="submit form" ng-click="submitTodoist()">Save</md-button>
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
            vm.hide()
          vm.hasTodoist = ->
            vm.data.currentUser.has_todoist
          vm.data.showForm = vm.hasTodoist()
          vm.hide = ->
            $mdDialog.hide()
          vm.addFocusArea = (user)->
            newFocusArea = {name: vm.data.newFocusArea, id: null}
            HerdActions.addFocusArea(newFocusArea)
            vm.data.newFocusArea = ""
        ]
        targetEvent: event
      }).
        then(()->

          )
    }
  ])
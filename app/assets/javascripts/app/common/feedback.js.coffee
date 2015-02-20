app = angular.module('app')

app.factory('Feedback', ['HerdActions','SettingsStore', '$mdDialog', (HerdActions,SettingsStore, $mdDialog)->
  return {
    show: (event)->
      $mdDialog.show({
        template: """
          <md-dialog aria-label="Feedback Dialog">
            <md-content>
              <md-subheader class="md-sticky md-primary">
                <h2>Feedback</h2>
              </md-subheader>
              <br>
              <form flex ng-submit="sendFeedback()">
                <textarea class="feedback" style="width:99%" msd-elastic ng-model="data.feedback"></textarea>
              </form>
              <div class="md-actions" layout="row">
                <md-button aria-label="close dialog" ng-click="hide()">Close</md-button>
                <md-button aria-label="submit form" ng-click="sendFeedback()">Submit Feedback</md-button>
              </div>
            </md-content>
          </md-dialog>
        """
        controller: ['$scope', '$mdDialog', ($scope, $mdDialog)->
          vm = $scope
          vm.data = {
            currentUser: SettingsStore.getCurrentUser()
            feedback: ""
          }
          SettingsStore.bindState($scope, ->
            vm.data.currentUser = SettingsStore.getCurrentUser())
          vm.sendFeedback = ->
            console.log vm.data
            HerdActions.sendFeedback(vm.data.currentUser, vm.data.feedback)
            vm.data.feedback = ""
            vm.hide()
          vm.hide = ->
            $mdDialog.hide()
        ]
        targetEvent: event
      }).
        then(()->

          )
    }
  ])
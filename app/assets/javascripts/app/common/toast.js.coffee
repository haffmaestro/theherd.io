app = angular.module('app')

app.factory('Notification', ['$mdToast', ($mdToast)->
  toastPosition = {
    bottom: true
    top: false
    left: true
    right: false
  }
  getToastPosition = ()->
    return Object.keys(toastPosition)
      .filter((pos)-> return toastPosition[pos]).join(' ')
  return {
    show: (message, timeout)->
      $mdToast.show({
        template: """
          <md-toast>
            <span flex>{{message}}</span>
            <md-button ng-click="closeToast()">
              Close
            </md-button>
          </md-toast>
        """
        controller: ['$scope', ($scope)->
          vm = $scope
          vm.message = message
          vm.closeToast = ->
            $mdToast.hide()
        ]
        hideDelay: timeout
        position: getToastPosition()
      })
    }
])
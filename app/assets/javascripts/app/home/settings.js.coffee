app = angular.module('app')

app.factory('Settings', ['SettingsStore', '$mdDialog', (SettingsStore, $mdDialog)->
  return {
    show: (event)->
      $mdDialog.show({
        controller: ['$scope', '$mdDialog', ($scope, $mdDialog)->
          vm = $scope
          vm.hide = ->
            $mdDialog.hide()
        ]
        template: """
          
        """
        targetEvent: event
      }).
        then(()->

          )
    }
  ])
app = angular.module('app')

app.factory('FocusAreas', ['$http', ($http)->
  return {
    new: (focusArea) ->
      $http.post("api/focus_areas", {focus_area: focusArea})
      .then((response)->
        response.data)
      .catch((response)->
        return false)
    update:(focusArea) ->
      $http.put("api/focus_areas/#{focusArea.id}", {focus_area: focusArea})
      .then((response)->
        response.data)
      .catch((response)->
        return false)
    destroy:(focusArea)->
      $http['delete']("api/focus_areas/#{focusArea.id}", {focus_area: focusArea})
      .then((response)->
        response.data)
      .catch((response)->
        return false)

  }
])

app.directive('focusArea', ['FocusAreas','HerdActions',(FocusAreas, HerdActions)->
  restrict: 'E'
  replace: true
  scope:
    focusArea: "="
  template: """
    <div class="focus-areas" layout-align="space-around">
      <div class="display" ng-hide="data.showEdit"  layout="row">
        <div flex="70" layout="column">
          <p ng-dblClick="showEdit()">{{focusArea.name}}  </p>
        </div>
        <div flex layout="center">
        <delete-focus-area-button focus-area="focusArea" ng-hide="!focusArea.is_owner"/>
        </div>
      </div>
      <div class="edit" ng-show="data.showEdit" ng-if="focusArea.is_owner">
        <form ng-submit="updateFocusArea(focusArea)" >
          <md-text-float type="text" name="updateFocusArea" ng-model="focusArea.name">
          </md-text-float>
        </form>
      </div>
    </div>
  """
  controller: ['$scope','$rootScope',($scope, $rootScope)->
    vm = $scope
    vm.data = {
      edit: false
    }
    vm.showEdit = ->
      if vm.focusArea.is_owner
        vm.data.showEdit = !vm.data.showEdit
    vm.updateFocusArea = (focusArea)->
      HerdActions.updateFocusArea(focusArea)
      vm.showEdit()
  ]
])

app.directive('deleteFocusAreaButton', ['FocusAreas','HerdActions', (FocusAreas, HerdActions) ->
  restrict: 'E'
  replace: true
  scope:
    focusArea: "="
  template: """
    <a ng-click="deleteFocusArea(focusArea)" class="delete-task">
      <i class="fa fa-remove "></i>
    </a>
  """
  controller: [ '$scope','$rootScope',($scope, $rootScope) ->
    vm = $scope
    vm.deleteFocusArea = (focusArea) ->
      HerdActions.deleteFocusArea(focusArea)

  ]
])
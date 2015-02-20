app = angular.module('app')

app.directive('focusArea', ['HerdActions',( HerdActions)->
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
          <md-input-container 
            <input type="text" name="updateFocusArea" ng-model="focusArea.name">
          </md-input-container>
        </form>
      </div>
    </div>
  """
  controller: ['$scope',($scope)->
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

app.directive('deleteFocusAreaButton', ['HerdActions', ( HerdActions) ->
  restrict: 'E'
  replace: true
  scope:
    focusArea: "="
  template: """
    <a ng-click="deleteFocusArea(focusArea)" class="delete-task">
      <i class="fa fa-remove "></i>
    </a>
  """
  controller: [ '$scope',($scope) ->
    vm = $scope
    vm.deleteFocusArea = (focusArea) ->
      HerdActions.deleteFocusArea(focusArea)

  ]
])
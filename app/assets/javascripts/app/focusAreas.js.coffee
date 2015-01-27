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

app.directive('focusArea', ['FocusAreas','messageCenterService',(FocusAreas, messageCenterService)->
  restrict: 'E'
  replace: true
  scope:
    focus: "="
    user: "="
  template: """
    <div class="focus-areas">
      <div class="display" ng-hide="data.showEdit"  layout="row">
        <p ng-dblClick="showEdit()">{{focus.name}}</p>
        <delete-focus-area-button focus="focus" user="user"/>
      </div>
      <div class="edit">
        <form ng-submit="updateFocusArea(focus)" ng-show="data.showEdit">
          <md-text-float type="text" name="updateFocusArea" ng-model="focus.name">
          </md-text-float>
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
      vm.data.showEdit = !vm.data.showEdit
    vm.updateFocusArea = (focus)->
      FocusAreas.update(focus)
      .then((response)->
        if response
          messageCenterService.add('success', 'Focus Area updated!', {timeout: 3000})
        else
          messageCenterService.add('warning', 'Focus Area failed to update, please try again', {timeout: 3000}))
      .catch((response)->
        messageCenterService.add('warning', 'Focus Area failed', {timeout: 3000}))
      vm.showEdit()
  ]
])

app.directive('deleteFocusAreaButton', ['FocusAreas', (FocusAreas) ->
  restrict: 'E'
  replace: true
  scope:
    focus: '='
    user: '='
  template: """
    <a ng-click="deleteFocusArea(focus, user)" class="delete-task">
      <i class="fa fa-remove "></i>
    </a>
  """
  controller: [ '$scope','$rootScope',($scope, $rootScope) ->
    vm = $scope
    vm.deleteFocusArea = (focusArea, user) ->
      console.log "Click"
      $rootScope.$emit('deleteFocusArea', {focusArea: focusArea, user: user})
      true

  ]
])
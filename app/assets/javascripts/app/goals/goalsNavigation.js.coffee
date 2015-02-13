app = angular.module('app')

app.directive('goalsNavigation',['NavigationStore','Notification', (NavigationStore, Notification) ->
  restrict: 'E'
  replace: true
  template: """
    <div>
      <a class="hand-hover"><i class="hand-hover fa fa-chevron-left fa-2x" ng-click="previousGoalRange()"></i></a>
      <a class="hand-hover"><i class="hand-hover fa fa-chevron-right fa-2x" ng-click="nextGoalRange()"></i></a>
    </div>
  """
  controller: ['$rootScope', '$scope','$state', ($rootScope, $scope, $state) ->
    vm = $scope
    data = NavigationStore.getGoalsRoutingData()
    NavigationStore.bindState(vm, ->
      data = NavigationStore.getGoalsRoutingData())
    vm.previousGoalRange = ->
      if data.range > 0
        goRange = data.range-1
        $state.go('goals', {user: data.user, range: goRange })
      else if data.range == 0
        $state.go('goals', {user: data.user, range: 3 })
    vm.nextGoalRange = ->
      if data.range < 3
        goRange = data.range+1
        $state.go('goals', {user: data.user, range: goRange})
      else if data.range == 3
        $state.go('goals', {user: data.user, range: 0})

    ]
  ]
)
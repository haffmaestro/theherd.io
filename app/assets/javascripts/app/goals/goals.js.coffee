app = angular.module('app')

app.controller('GoalsCtrl', ['$scope','HerdActions','HerdStore','$rootScope','$stateParams','$state', ($scope, HerdActions, HerdStore, $rootScope,$stateParams,$state)->
  vm = $scope
  vm.data = {
    users: []
    currentUser: HerdStore.getCurrentUser()
    user: $stateParams.user || HerdStore.getCurrentUser().first_name
    goals: HerdStore.getGoals()
    selectedIndex: 0,
    goalIndex: $stateParams.range || 0
  }
  if $stateParams.user == undefined
    $state.go('goals', {user: vm.data.user})
  HerdActions.fetchGoals() if vm.data.goals.length == 0
  HerdStore.bindState($scope, ->
    vm.data.goals = HerdStore.getGoals()
    if vm.data.users.length == 0
      vm.data.users = _.map(vm.data.goals, (user)->
        user.first_name)
    vm.data.selectedIndex = vm.data.users.indexOf(vm.data.user)
  )

  vm.onTabSelected = (user)->
    params = {range: vm.data.goalIndex, user: user}
    $state.go('goals', params)
    HerdActions.setGoalsRoutingData(params)
  ]
)

app.directive('goalHeadlines', ->
  restrict: 'E'
  replace: true
  scope:
    headlines: '='
  template: """
    <div class="row" flex="100" layout="horizontal"><div flex="50"><h2 class="goals">{{headlines[0]}}</h2></div><div flex="50"><h2 class="goals">{{headlines[1]}}</h2></div></div>
  """
  )

app.directive('goalsDisplay', ['HerdActions', (HerdActions)->
  restrict: 'E'
  replace: true
  scope:
    curruser: '='
    user: '='
    goals: '='
    months: '='
    focus: '='
  template: """
    <div>
      <div class="row" layout="horizontal" ng-repeat="goal in goals">
        <md-checkbox ng-disabled="friend()" md-no-ink ng-model="goal.done" aria-label="{{goal.body}}" ng-change="toggleGoalDone(goal)">
          {{goal.body}}
        </md-checkbox>
        <delete-button-goal ng-hide="friend()" goal="goal"></delete-button-goal>
      </div>
      <form ng-submit="submitGoal(focus_area)" ng-hide="friend()" >
        <md-text-float label="New Goal" type="text" name="newGoal" ng-model="data.newGoal">
        </md-text-float>
      </form>
    </div>
  """
  controller: ['$scope', ($scope) ->
    vm = $scope
    vm.data = {
      newGoal: ""
    }

    vm.friend = ->
      return false unless vm.user?
      isFriend = vm.user != vm.curruser

    vm.toggleGoalDone = (goal) ->
      HerdActions.markGoalAsDone(goal)

    vm.submitGoal = (focus_area)->
      goal = {body: vm.data.newGoal, focus_area_id: vm.focus.id, done: false, months: vm.months, id: null}
      vm.data.newGoal = ""
      HerdActions.addGoal(goal)
    ]
    ])

app.directive('deleteButtonGoal', ['HerdActions', (HerdActions) ->
  restrict: 'E'
  replace: true
  scope:
    goal: '='
  template: """
    <a ng-click="deleteGoal(goal)" class="delete-goal">
      <i class="fa fa-remove "></i>
    </a>
  """
  controller: ['$scope', ($scope) ->
    vm = $scope
    vm.deleteGoal = (goal) ->
      HerdActions.deleteGoal(goal)
    ]

])
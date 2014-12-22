app = angular.module('app')

app.factory('Goals', ['$http', ($http)->
  return {
    get: ->
      $http.get('/api/goals').then((response)->
        response.data
        ).catch((response)->
          console.log "Error at Goals factory")
    update: (goal) ->
      $http.put("/api/goals/#{goal.id}", {goal: goal}).then((response) ->
        response.data
        ).catch((data)->
          console.log 'Error updating!')
    post: (goal) ->
      $http.post("/api/goals", {goal: goal}).then((response)->
        response.data
        ).catch((data)->
          console.log 'Error creating!'
          data)
    delete: (goal) ->
      $http.delete("/api/goals/#{goal.id}").then((response)->
        response.data
        ).catch((data)->
          console.log 'Error deleting!'
          data)
    }])

app.controller('GoalsCtrl', ['$scope', 'Goals','currentUser','$rootScope', ($scope, Goals, currentUser, $rootScope)->
  vm = $scope
  vm.currentUser = currentUser
  console.log currentUser
  vm.users = []
  vm.newGoal = "Pease"
  vm.data = {
    selectedIndex: 0,
    goalIndex: 0
  }

  Goals.get().then((response) ->
    console.log response
    for goal in response.goals
      vm.users.push(goal.first_name)
    vm.goals = response.goals
    )

  $rootScope.$on('nextGoals', (args)->
    vm.data.goalIndex = Math.min(vm.data.goalIndex + 1, 3))
  $rootScope.$on('previousGoals', (args)->
    vm.data.goalIndex = Math.max(vm.data.goalIndex - 1, 0))
  ])

app.directive('previousGoals', ->
  restrict: 'E'
  replace: true
  template: """
    <a>
      <i class="fa fa-chevron-left fa-2x" ng-click="previousGoals()"></i></a>
  """
  controller: ($rootScope, $scope) ->
    vm = $scope
    vm.previousGoals = ->
      console.log "previousGoals called"
      $rootScope.$emit('previousGoals', {change: true})
)

app.directive('nextGoals', ->
  restrict: 'E'
  replace: true
  template: """
    <a>
      <i class="fa fa-chevron-right fa-2x" ng-click="nextGoals()"></i></a>
  """
  controller: ['$rootScope', '$scope', ($rootScope, $scope) ->
    vm = $scope
    vm.nextGoals = ->
      console.log "nextGoals called"
      $rootScope.$emit('nextGoals', {change: true})
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

app.directive('goalsDisplay', ['Goals', (Goals)->
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
        <delete-button-goal ng-hide="friend()" goal="goal" list="goals"/>
      </div>
      <form ng-submit="submitGoal(focus_area)" ng-hide="friend()" >
        <md-text-float label="New Goal" type="text" name="newGoal" ng-model="data.newGoal">
        </md-text-float>
      </form>
    </div>
  """
  controller: ['$scope', ($scope) ->
    vm = $scope
    console.log vm.user
    console.log vm.curruser
    vm.data = {
      newGoal: ""
    }

    vm.friend = ->
      return false unless vm.user?
      isFriend = vm.user != vm.curruser

    vm.toggleGoalDone = (goal) ->
      console.log("From Angular #{goal.done}")
      Goals.update(goal).then((response) ->
        console.log("From Rails #{response}"))

    vm.submitGoal = (focus_area)->
      goal = {body: vm.data.newGoal, focus_area_id: vm.focus.id, done: false, months: vm.months}
      vm.goals.push(goal)
      vm.data.newGoal = ""
      Goals.post(goal).then((response)->
        console.log(response))
    ]
    ])

app.directive('deleteButtonGoal', ['Goals', (Goals) ->
  restrict: 'E'
  replace: true
  scope:
    goal: '='
    list: '='
  template: """
    <a ng-click="deleteTask(goal)" class="delete-goal">
      <i class="fa fa-remove "></i>
    </a>
  """
  controller: ['$scope', ($scope) ->
    vm = $scope
    vm.deleteTask = (goal) ->
      Goals['delete'](goal).
        then((response) -> console.log response).
        catch((data) -> console.log data)
      index = vm.list.indexOf(goal)
      vm.list.splice(index, 1)
    ]

])
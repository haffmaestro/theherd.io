app = angular.module("app")

app.directive('deleteButton', ['HerdActions', (HerdActions) ->
  restrict: 'E'
  replace: true
  scope:
    task: '='
    list: '='
  template: """
    <a ng-click="deleteTask(task)" class="delete-task">
      <i class="fa fa-remove "></i>
    </a>
  """
  controller: [ '$scope', ($scope) ->
    vm = $scope
    vm.deleteTask = (task) ->
      HerdActions.deleteWeeklyTask(task)
  ]
])

app.directive('weeklyTasks', ['HerdActions', (HerdActions)->
  restrict: 'E'
  replace: true
  scope:
    tasks: '='
    section: '='
  template: """
    <div>
      <div class="row" layout="horizontal" ng-repeat="task in tasks">
        <md-checkbox md-no-ink ng-model="task.done" aria-label="{{task.body}}" ng-change="toggleTaskDone(task)">
          {{task.body}}
        </md-checkbox>
        <delete-button task="task" list="section"/>
      </div>
      <form ng-submit="submitTask(section)">
        <md-text-float label="New Task" type="text" name="newWeeklyTask" ng-model="data.newWeeklyTask">
        </md-text-float>
      </form>
    </div>
  """

  controller: ['$scope', ($scope) ->
    vm = $scope
    vm.data = {
      newWeeklyTask: ""
    }
    vm.toggleTaskDone = (task) ->
      HerdActions.completeWeeklyTask(task)

    vm.submitTask = (section)->
      task = {body: vm.data.newWeeklyTask, section_id: section.id, done: false, id: null}
      vm.data.newWeeklyTask = ""
      HerdActions.addWeeklyTask(task)
    ]
  ])


app.directive('weeklyTasksFriend', [ ()->
  restrict: 'E'
  replace: true
  scope:
    tasks: '='
    section: '='
  template: """
    <div>
      <div class="row" layout="horizontal" ng-repeat="task in tasks">
        <md-checkbox ng-disabled="true"  md-no-ink ng-model="task.done" aria-label="{{task.body}}" ng-change="toggleTaskDone(task)">
          {{task.body}}
        </md-checkbox>
      </div>
    </div>
  """
  ])
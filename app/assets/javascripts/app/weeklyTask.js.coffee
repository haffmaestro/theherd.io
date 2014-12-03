app = angular.module("app")

app.factory('WeeklyTask', ['$http', ($http)->
  return {
    update: (task) ->
      $http.put("/api/weekly_tasks/#{task.id}", {weekly_task: task}).then((response) ->
        response.data
        ).catch((data)->
          console.log 'Error updating!')
    post: (task) ->
      $http.post("/api/weekly_tasks", {weekly_task: task}).then((response)->
        response.data
        ).catch((data)->
          console.log 'Error creating!'
          data)
    delete: (task) ->
      $http.delete("/api/weekly_tasks/#{task.id}").then((response)->
        response.data
        ).catch((data)->
          console.log 'Error deleting!'
          data)
  }
  ])

app.directive('deleteButton', ['WeeklyTask', (WeeklyTask) ->
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
  controller: ($scope) ->
    vm = $scope
    vm.deleteTask = (task) ->
      WeeklyTask['delete'](task).
        then((response) -> console.log response).
        catch((data) -> console.log data)
      index = vm.list.weekly_tasks.indexOf(task)
      vm.list.weekly_tasks.splice(index, 1)

])

app.directive('weeklyTasks', ['WeeklyTask', (WeeklyTask)->
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

  controller: ($scope) ->
    vm = $scope
    vm.data = {
      newWeeklyTask: ""
    }
    vm.toggleTaskDone = (task) ->
      # task.done = !task.done
      console.log(task.done)
      WeeklyTask.update(task).then((response) ->
        console.log(response))

    vm.submitTask = (section)->
      task = {body: vm.data.newWeeklyTask, section_id: section.id, done: false}
      section.weekly_tasks.push(task)
      vm.data.newWeeklyTask = ""
      WeeklyTask.post(task).then((response)->
        console.log(response))
    ])
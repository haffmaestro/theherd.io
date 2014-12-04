app = angular.module('app')

app.factory('Sections', ['$http', ($http)->
  return {
    update: (section)->
      $http.put("/api/sections/#{section.id}", {section: section, section_id: section.id}).then((response)->
        response.data
        ).catch((data)->
          console.log 'Error updating!')
    }])

app.factory('WeeklyReportGetter', ['$http', ($http)->
  return {
    get: (id) ->
      $http.get("/api/herd_weeklies/#{id}").then((response) ->
        console.log 'Success'
        response.data
        ).catch((data)->
          console.log 'Error getting data!')
  }
  ])

app.controller('WeeklyReportCtrl', ['WeeklyReportGetter','WeeklyTask', 'currentUser','$scope', (WeeklyReportGetter,WeeklyTask,currentUser, $scope) ->
  vm = $scope
  vm.currentUser = currentUser
  regex = /(201[0-9]-[0-5]\d)/
  url = document.URL
  id = regex.exec(url)[0]
  WeeklyReportGetter.get(id).then((response)->
    vm.herdWeekly = response.herd_weekly
    vm.users = _.map(vm.herdWeekly.user_weeklies, (user_weekly) ->
      user_weekly.first_name)
    vm.countUsers = (num for num in [0..vm.users.length-1])
    )

  vm.data = {
    selectedIndex : 0,
  }

  vm.owner = (userWeekly) ->
    return false unless userWeekly?.user_id?
    userWeekly.user_id == currentUser.id
  vm.friend = (userWeekly) ->
    return false unless userWeekly?.user_id?
    userWeekly.user_id != currentUser.id

  vm.next = -> 
    vm.data.selectedIndex = Math.min(vm.data.selectedIndex + 1, 2)

  vm.previous = ->
    vm.data.selectedIndex = Math.max(vm.data.selectedIndex - 1, 0)
    ])

app.directive('ownerSection', ['Sections', (Sections) ->
  restrict: 'E'
  replace: true
  scope: 
    section: '='
  template: """
  <div>
    <md-card id="{{section.name.toLowerCase()}}">
      <md-content flex layout="vertical">
        <div flex="70" ng-dblclick="showEdit($event)">
          <h4>
            {{section.name}} This Week
          </h4>
          <div class="view" ng-show="data.showView" marked="section.body">
            
          </div>
          <div class="edit" ng-show="data.showForm" flex>
            <form flex ng-submit="saveForm(section)">
              <textarea class="section" style="width:99%" msd-elastic ng-model="section.body" ng-blur="saveForm(section)"></textarea>
          </div>
          <a class="comments-toggle" ng-click="toggleComments()">
            <i class="fa fa-comments fa-2x"></i></a>
        </div>
        <div flex="30">
          <h4> 
            Goals Next Week
          </h4>
          <weekly-tasks tasks="section.weekly_tasks" section="section"/>
        </div>
      </md-content>
    </md-card>
    <comments-section section="section"/>
  </div> 
  """

  controller: ($scope, $rootScope) ->
    vm = $scope
    vm.data = {
      showView: true
      showForm: false
    }
    vm.toggleComments = ->
      channel = "showComments-#{vm.section.id}"
      $rootScope.$emit(channel, {show: true})
    vm.toggleEdit = ->
      vm.data.showView =! vm.data.showView
      vm.data.showForm =! vm.data.showForm

    vm.showEdit = ($event) ->
      vm.toggleEdit()
      setTimeout( ->
        view = angular.element($event.target).parent()
        edit = angular.element(angular.element('textarea', view.parent()).get(0))
        edit.focus()
      , 10
      )
      true

    vm.saveForm =(section) ->
      vm.toggleEdit()
      Sections.update(section).then((data)->
        console.log data).
        catch((data)->
          console.log data
          )

  ])

app.config ["markedProvider", (markedProvider) ->
    markedProvider.setOptions
      gfm: true
      tables: true
      highlight: (code) ->
        hljs.highlightAuto(code).value
]

app.directive('friendSection', ['Sections', (Sections) ->
  restrict: 'E'
  replace: true
  scope: 
    section: '='
  template: """
    <md-card id="{{section.name.toLowerCase()}}">
      <md-content flex layout="vertical">
        <div flex="70">
          <h4>
            {{section.name}} This Week
          </h4>
          <div class="view" marked="section.body">
            
          </div>
        </div>
        <div flex="30">
          <h4> 
            Goals Next Week
          </h4>
          <weekly-tasks tasks="section.weekly_tasks" section="section"/>
        <div class="comments" ng-show="False">
          Comments
        </div>
      </md-content>
    <md-card>      
  """
  ])
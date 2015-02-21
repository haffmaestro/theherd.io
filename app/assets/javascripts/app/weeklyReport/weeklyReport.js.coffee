app = angular.module('app')

app.controller('WeeklyReportCtrl', ['HerdStore','NavigationStore','HerdActions','Notification','$scope','$rootScope','$stateParams','$state', (HerdStore,NavigationStore,HerdActions,Notification, $scope,$rootScope, $stateParams, $state) ->
  vm = $scope
  vm.data = {
    herdWeeklyId: $stateParams.herdWeeklyId
    currentUser: HerdStore.getCurrentUser()
    user: $stateParams.user || HerdStore.getCurrentUser().first_name
    users: []
    selectedIndex : 0
    herdWeekly: HerdStore.getWeeklyReport()
    year_week_regex: /(201[0-9]-[0-5]\d)/
    id_regex: /\/\d+/
  }
  HerdActions.fetchWeeklyReport(vm.data.herdWeeklyId) if vm.data.herdWeekly == undefined || vm.data.herdWeekly != vm.data.herdWeeklyId
  #Will redirect to use the currently Logged in user
  if $stateParams.user == undefined
    $state.go('weeklyReport', {herdWeeklyId: vm.data.herdWeeklyId, user: vm.data.user})

  HerdStore.bindState($scope, ->
    if HerdStore.getWeeklyReport()
      vm.data.herdWeekly = HerdStore.getWeeklyReport()
      vm.data.users = _.map(vm.data.herdWeekly.user_weeklies, (user_weekly) ->
        user_weekly.first_name)
      vm.data.countUsers = (num for num in [0..vm.data.users.length-1])
      vm.data.selectedIndex = vm.data.users.indexOf(vm.data.user)
    )

  vm.onTabSelected = (user)->
    $state.go('weeklyReport', {herdWeeklyId: vm.data.herdWeeklyId, user: user})
    HerdActions.setWeeklyReportRoutingData({user: user})


  vm.owner = (userWeekly) ->
    return false unless userWeekly?.user_id?
    userWeekly.user_id == vm.data.currentUser.id
  vm.friend = (userWeekly) ->
    return false unless userWeekly?.user_id?
    userWeekly.user_id != vm.data.currentUser.id

  vm.next = -> 
    vm.data.selectedIndex = Math.min(vm.data.selectedIndex + 1, 2)

  vm.previous = ->
    vm.data.selectedIndex = Math.max(vm.data.selectedIndex - 1, 0)
    ])

app.directive('ownerSection', ['HerdActions', (HerdActions) ->
  restrict: 'E'
  replace: true
  scope: 
    section: '='
  template: """
  <div layout="column" layout-align="start">
    <md-card id="{{section.name.toLowerCase()}}">
      <div flex layout="column" layout-gt-md="row" layout-padding>
        <div flex="70" ng-dblclick="showEdit($event)">
          <h4>
            {{section.name}} This Week
          </h4>
          <div class="view" ng-show="data.showView" marked="section.body">
          </div>
          <div class="edit" ng-show="data.showForm" flex>
            <form flex ng-submit="saveForm(section)">
              <textarea class="section" style="width:99%" msd-elastic ng-model="section.body" ng-blur="saveForm(section)"></textarea>
            </form>
          </div>
          <a class="comments-toggle" ng-click="toggleComments()">
            <i class="fa fa-comments fa-2x"></i></a>
        </div>
        <div flex="30">
          <h4> 
            {{section.name}} Next Week
          </h4>
          <weekly-tasks tasks="section.weekly_tasks" section="section"/>
        </div>
      </div>
    </md-card>
    <comments-section section="section"/>
  </div> 
  """

  controller: ['$scope', '$rootScope', ($scope, $rootScope) ->
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
      HerdActions.updateSection(section)
      ]

  ])

app.directive('friendSection', [ () ->
  restrict: 'E'
  replace: true
  scope: 
    section: '='
  template: """
  <div>
    <md-card id="{{section.name.toLowerCase()}}">
      <md-content flex layout="column" layout-gt-md="row" layout-padding>
        <div flex="70">
          <h4>
            {{section.name}} This Week
          </h4>
          <div class="view" ng-show="data.showView" marked="section.body">
            
          </div>          
          <a class="comments-toggle" ng-click="toggleComments()">
            <i class="fa fa-comments fa-2x"></i></a>
        </div>
        <div flex="30">
          <h4> 
            {{section.name}} Next Week
          </h4>
          <weekly-tasks-friend tasks="section.weekly_tasks" section="section"/>
        </div>
      </md-content>
    </md-card>
    <comments-section section="section"/>
  </div> 
  """

  controller: ['$scope', '$rootScope', ($scope, $rootScope) ->
    vm = $scope
    vm.data = {
      showView: true
      showForm: false
    }
    vm.toggleComments = ->
      channel = "showComments-#{vm.section.id}"
      $rootScope.$emit(channel, {show: true})
    ]

  ])
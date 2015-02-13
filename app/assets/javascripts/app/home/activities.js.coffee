app = angular.module('app')

app.controller('HomeController', ['$stateParams', ($stateParams)->
  console.log $stateParams
  ])

app.directive('newsfeed', ['HerdActions', 'HerdStore', (HerdActions,HerdStore)->
  restrict: 'E'
  replace: true
  template: """
    <md-card>
      <div ng-if="data.newsfeed.length === 0">
        <p>Nothing has happened yet!</p>
      </div>
      <div ng-hide="data.newsfeed.length === 0" ng-repeat="activity in data.newsfeed">
        <goal-activity ng-if="activity.trackable_type === 'Goal'" activity="activity"></goal-activity>
        <comment-activity activity="activity" ng-if="activity.trackable_type === 'Comment'"></comment-activity>
        <weekly-report-activity activity="activity" ng-if="activity.trackable_type === 'UserWeekly'"></weekly-report-activity>
      </div>
    </md-card>
  """
  controller: ['$scope', ($scope)->
    vm = $scope
    vm.data = {
      newsfeed: HerdStore.getNewsFeed()
    }
    HerdActions.fetchActivity()
    HerdStore.bindState(vm, ->
      vm.data.newsfeed = HerdStore.getNewsFeed())
  ]
])

app.directive('commentActivity', ['Notification','HerdActions',(Notification,HerdActions)->
  restrict: 'E'
  replace: true
  scope: 
    activity: "="
  template: """
      <p><b>{{data.date.getDate()}}/{{data.date.getMonth()+1}}:</b> <a ng-click="goToTarget()" class="hover-hand black-link">{{activity.owner.first_name}} commented on {{(activity.owner.id === activity.recipient.id ? "their own" : activity.recipient.first_name.concat("'s"))}} {{activity.target.section.name}} section.</a></p>
  """
  controller: ['$scope','$state', ($scope,$state)->
    vm = $scope
    vm.data = {
      date: new Date(Date.parse(vm.activity.created_at))
    }
    vm.goToTarget = ->
      HerdActions.addCommentToOpenQueue(vm.activity.target.section.id)
      if vm.activity.target
        HerdActions.fetchComments(vm.activity.target.section.id)
        $state.go('weeklyReport', {herdWeeklyId: vm.activity.target.section.year_week_id, user: vm.activity.recipient.first_name}).
          catch((response)->
            Notification.show('Please try again', 2000))
      else
        Notification.show('Sorry, target is gone.', 2000)
    ]
  ])

app.directive('goalActivity', ['Notification',(Notification)->
  restrict: 'E'
  replace: true
  scope: 
    activity: '='
  template: """
    <p><b>{{data.date.getDate()}}/{{data.date.getMonth()+1}}:</b> <a ng-click="goToTarget()" class="hover-hand black-link">{{activity.owner.first_name}} {{text()}} goal in their {{activity.target.focus_area}} focus.</a></p>
  """
  controller: ['$scope','$state', ($scope,$state)->
    vm = $scope
    vm.data = {
      date: new Date(Date.parse(vm.activity.created_at))
    }
    vm.goToTarget = ->
      if vm.activity.target
        $state.go('goals', {user: vm.activity.owner.first_name, range: vm.activity.target.range}).
          catch((response)->
            Notification.show('Please try again', 2000))
      else
        Notification.show('Sorry, target is gone.', 2000)
    vm.text = ->
      if vm.activity.key == 'goal.completed'
        "completed a"
      else if vm.activity.key == 'goal.create'
        "created a new"
    ]
  ])

app.directive('weeklyReportActivity', ['Notification',(Notification)->
  restrict: 'E'
  replace: true
  scope:
    activity: '='
  template: """
    <p><b>{{data.date.getDate()}}/{{data.date.getMonth()+1}}:</b><a ng-click="goToTarget()" class="hover-hand black-link"> {{activity.owner.first_name}} completed Weekly Report {{activity.target.year_week_id}}</a></p>
  """
  controller: ['$scope','$state', ($scope,$state)->
    vm = $scope
    vm.data = {
      date: new Date(Date.parse(vm.activity.created_at))
    }
    vm.goToTarget = ->
      if vm.activity.target
        $state.go('weeklyReport', {herdWeeklyId: vm.activity.target.year_week_id, user: vm.activity.owner.first_name}).
          catch((response)->
            Notification.show('Please try again', 2000))
      else
        Notification.show('Sorry, target is gone.', 2000)
    ]
  ])
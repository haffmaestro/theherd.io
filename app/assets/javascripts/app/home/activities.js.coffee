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
      </div>
    </md-card>
  """
  controller: ['$scope', ($scope)->
    vm = $scope
    vm.data = {
      newsfeed: HerdStore.getNewsFeed()
    }
    HerdActions.fetchActivity()
    HerdStore.on('change', ->
      vm.data.newsfeed = HerdStore.getNewsFeed())
  ]
])

app.directive('commentActivity', [()->
  restrict: 'E'
  replace: true
  scope: 
    activity: "="
  template: """
      <p><b>{{data.date.getDate()}}/{{data.date.getMonth()+1}}:</b> {{activity.owner.first_name}} commented on {{(activity.owner.id === activity.recipient.id ? "their own" : activity.recipient.first_name.concat("'s"))}} {{activity.target.section.name}} section.</p>
  """
  controller: ['$scope', ($scope)->
    vm = $scope
    vm.data = {
      date: new Date(Date.parse(vm.activity.created_at))
    }
    ]
  ])

app.directive('goalActivity', [()->
  restrict: 'E'
  replace: true
  scope: 
    activity: '='
  template: """
    <p><b>{{data.date.getDate()}}/{{data.date.getMonth()+1}}:</b> {{activity.owner.first_name}} created a new goal in their {{activity.target.focus_area}} focus.</p>
  """
  controller: ['$scope', ($scope)->
    vm = $scope
    vm.data = {
      date: new Date(Date.parse(vm.activity.created_at))
    }
    ]
  ])
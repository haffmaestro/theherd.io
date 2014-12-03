app = angular.module('app')

app.factory('Comments', ['$http', ($http)->
  return {
    get:(section) ->
      $http.get("/api/sections/#{section.id}/comments").then((response)->
        response.data
      ).catch((data)->
        console.log 'Error getting comments!'
        data)

  }
  ])

app.directive('commentsSection', ['Comments', (Comments)->
  restrict: 'E'
  replace: true
  scope:
    section: '='
  template: """
    <md-card class="comments" ng-show="data.showComments" flex="90" offset="5">   
      <div flex class="loading" ng-show="data.comments === null">
        <br>
        <md-progress-circular offset="45" md-mode="indeterminate"></md-progress-circular>
      </div>
      <div flex class="comments" ng-hide="data.comments === null" >
        <h4 class="comments">
          Comments
        </h4>
        <div ng-repeat="comment in data.comments">
          <h6>
            {{comment.first_name}} on {{comment.date}}
          </h6>
          <p>
            {{comment.body}}
          </p>
          <hr>
        </div>
      </div>  
    </md-card>
  """
  controller: ($scope, $rootScope, $filter)->
    vm = $scope
    vm.data = {
      showComments: false
      channel: "showComments-#{vm.section.id}"
      comments: null
    }

    $rootScope.$on(vm.data.channel, (args)->
      vm.toggleComments()
      )

    vm.toggleComments = ->
      vm.data.showComments =! vm.data.showComments
      if vm.data.comments == null
        setTimeout( ->
          Comments.get(vm.section).then((response)->
            console.log response.comments
            vm.data.comments = response.comments
            )
        , 1000
        )
      true
  ])
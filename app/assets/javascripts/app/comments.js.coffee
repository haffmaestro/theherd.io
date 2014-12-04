app = angular.module('app')

app.factory('Comments', ['$http', ($http)->
  return {
    get:(section) ->
      $http.get("/api/sections/#{section.id}/comments").then((response)->
        response.data
      ).catch((data)->
        console.log 'Error getting comments!'
        data)
    post:(comment, section_id)->
      $http.post("/api/sections/#{section_id}/comments", {comment: comment}).then((response)->
        response.data
      ).catch((data)->
        console.log 'Error posting comment!'
        data)

  }
  ])

app.directive('commentsSection', ['Comments','$preloaded', (Comments, $preloaded)->
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
          <hr>
          <h6>
            {{comment.first_name}} on {{comment.date}}
          </h6>
          <p>
            {{comment.body}}
          </p>
          <a class="add-comments-toggle" ng-click="newComment()">
            <i class="fa fa-plus fa-2x"></i></a>
        </div>
        <div class="edit" ng-show="data.addComment" flex>
          <form flex ng-submit="createComment()">
            <textarea class="section" style="width:50%" msd-elastic ng-model="data.newComment" ></textarea>
            <md-button type="submit">Add</md-button>
        </div>
      </div>  
    </md-card>
  """
  controller: ($scope, $rootScope)->
    vm = $scope
    vm.currentUser = $preloaded.user.user
    vm.data = {
      showComments: false
      addComment: false
      newComment: ""
      channel: "showComments-#{vm.section.id}"
      comments: null
    }

    $rootScope.$on(vm.data.channel, (args)->
      vm.toggleComments()
      )

    vm.newComment = ->
      vm.data.addComment =! vm.data.addComment


    vm.createComment = ->
      today = new Date(Date.now())
      today = today.toDateString()
      console.log today
      comment = {section_id: vm.section.id, user_id: vm.currentUser.id, first_name: vm.currentUser.first_name, body: vm.data.newComment, date: today}
      vm.data.newComment = ""
      vm.data.comments.push(comment)
      vm.data.addComment = false
      Comments.post(comment, vm.section.id).then((response)->
        console.log response)


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
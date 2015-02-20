app = angular.module('app')

app.directive('commentsSection', ['HerdActions','HerdStore','CommentsStore', (HerdActions, HerdStore, CommentsStore)->
  restrict: 'E'
  replace: true
  scope:
    section: '='
  template: """
    <md-card class="comments" ng-show="data.showComments" flex="80" layout-padding>   
      <div flex class="loading" ng-show="data.comments === null" layout="column" layout-align="center start">
        <br>
        <md-progress-linear md-mode="indeterminate"></md-progress-linear>
      </div>
      <div flex class="comments" ng-hide="data.comments === undefined" layout="column" layout-align="start">
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
        </div>
        <div class="edit" ng-hide="data.comments === undefined" flex>
          <form flex ng-submit="createComment()">
            <textarea class="section" style="width:30%" msd-elastic ng-model="data.newComment" ></textarea>
            <md-button class="md-accent md-raised" type="submit">Add</md-button>
        </div>
      </div>  
    </md-card>
  """
  controller: ['$scope', '$rootScope', ($scope, $rootScope)->
    vm = $scope
    vm.currentUser = HerdStore.getCurrentUser()
    vm.data = {
      showComments: false
      addComment: false
      newComment: ""
      channel: "showComments-#{vm.section.id}"
      comments: null
    }
    vm.toggleComments = ->
      if vm.data.comments == null
        setTimeout(->
          HerdActions.fetchComments(vm.section)
        , 200
        )
      vm.data.showComments =! vm.data.showComments
    $rootScope.$on(vm.data.channel, (args)->
      vm.toggleComments()
      )
    if vm.section.id == CommentsStore.getCommentToOpen()
      vm.toggleComments()
      # HerdActions.commentShown()  
    CommentsStore.bindState($scope, ->
      vm.data.comments = CommentsStore.getComments(vm.section))

    vm.newComment = ->
      vm.data.addComment =! vm.data.addComment

    vm.createComment = ->
      today = new Date(Date.now())
      today = today.toDateString()
      comment = {section_id: vm.section.id, user_id: vm.currentUser.id, first_name: vm.currentUser.first_name, body: vm.data.newComment, date: today}
      vm.data.newComment = ""
      vm.data.addComment = false
      HerdActions.addComment(comment, vm.section)
    ]
  ])
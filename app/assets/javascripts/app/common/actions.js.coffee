app = angular.module('app')
app.factory('HerdActions', ['HerdConstants', 'HerdApi', 'HerdDispatcher', (HerdConstants, HerdApi, HerdDispatcher)->
  ### Private Methods ###
  dispatch = (key, item) ->
    payload =
      actionType: key
      item: item
    HerdDispatcher.handleViewAction payload
  return {
    addFocusArea: (newFocusArea)->
      HerdApi.addFocusArea(newFocusArea)
    updateFocusArea: (focusArea)->
      HerdApi.updateFocusArea(focusArea)
    deleteFocusArea: (focusArea)->
      HerdApi.deleteFocusArea(focusArea)
    fetchUsers: ->
      HerdApi.fetchUsers()
    addGoal: (newGoal)->
      dispatch(HerdConstants.ADD_GOAL_INTERNAL, newGoal)
      HerdApi.addGoal(newGoal)
    deleteGoal: (goal)->
      HerdApi.deleteGoal(goal)
    markGoalAsDone: (goal)->
      HerdApi.markGoalAsDone(goal)
    fetchGoals: ->
      HerdApi.fetchGoals()
    fetchWeeklyReport: (id)->
      HerdApi.fetchWeeklyReport(id)
    fetchWeeklyReports: ->
      HerdApi.fetchWeeklyReports()
    updateCurrentWeeklyReport: (userId) ->
      HerdApi.updateCurrentWeeklyReport(userId)
    updateSection: (section)->
      HerdApi.updateSection(section)
    addWeeklyTask: (newWeeklyTask)->
      HerdApi.addWeeklyTask(newWeeklyTask)
    completeWeeklyTask: (weeklyTask)->
      HerdApi.completeWeeklyTask(weeklyTask)
    deleteWeeklyTask: (weeklyTask)->
      HerdApi.deleteWeeklyTask(weeklyTask)
    fetchActivity: ->
      HerdApi.fetchActivity()
    setWeeklyReportRoutingData: (data)->
      dispatch(HerdConstants.SET_WEEKLY_REPORT_ROUTING_DATA, data)
    setGoalsRoutingData: (data)->
      dispatch(HerdConstants.SET_GOALS_ROUTING_DATA, data)
    fetchComments: (section)->
      HerdApi.fetchComments(section)
    addComment: (comment, section)->
      HerdApi.addComment(comment, section)
    addCommentToOpenQueue: (sectionId)->
      dispatch(HerdConstants.ADD_COMMENT_OPEN_QUEUE, sectionId)
    commentShown: ->
      dispatch(HerdConstants.COMMENT_SHOWN)
    loginTodoist:(user, email, password) ->
      HerdApi.loginTodoist(user, email, password)
    sendFeedback: (user, feedback)->
      HerdApi.sendFeedback(user, feedback)
    uploadPicture: (files)->
      HerdApi.uploadPicture(files)

  }
])
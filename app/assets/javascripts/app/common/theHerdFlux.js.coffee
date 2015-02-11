app = angular.module('app')

app.factory('HerdDispatcher', ['FluxUtil', (FluxUtil)->
  FluxUtil.createDispatcher()
])

app.factory('HerdConstants', ['FluxUtil', (FluxUtil)->
  return FluxUtil.defineConstants(['FETCH_GOALS','ADD_GOAL','ADD_GOAL_INTERNAL', 'DELETE_GOAL',
    'COMPLETE_GOAL', 'ADD_FOCUS_AREA', 'UPDATE_FOCUS_AREA', 'DELETE_FOCUS_AREA', 'FETCH_USERS',
    'FETCH_WEEKLY_REPORT','FETCH_WEEKLY_REPORTS','UPDATE_WEEKLY_REPORT', 'UPDATE_SECTION','ADD_WEEKLY_TASK',
    'DELETE_WEEKLY_TASK', 'COMPLETE_WEEKLY_TASK', 'FETCH_ACTIVITY'])
])

app.factory('ApiConstants', ['FluxUtil', (FluxUtil)->
  return FluxUtil.defineConstants(['PENDING', 'ERROR'])])

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
  }
])

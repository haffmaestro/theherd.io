app = angular.module('app')

app.factory('HerdApi', ['$http','HerdDispatcher','HerdConstants','ApiConstants', ($http, HerdDispatcher, HerdConstants, ApiConstants)->
  BASE_URL = ''
  
  ### Private Methods ###
  handleResponse = (key, params) ->
    (response) ->
      if response.data.error
        dispatch key, ApiConstants.ERROR, params
      else
        dispatch key, response.data, params

  dispatch = (key, response, params) ->
    payload =
      actionType: key
      response: response
      queryParams: params
    HerdDispatcher.handleServerAction payload

  ### Public Interface ###
  return {
    addFocusArea: (newFocusArea)->
      key = HerdConstants.ADD_FOCUS_AREA
      params = {focusArea: newFocusArea}
      dispatch(key, ApiConstants.PENDING, params)
      $http.post("api/focus_areas", params).
        then(handleResponse(key, params))
    updateFocusArea: (focusArea)->
      key = HerdConstants.UPDATE_FOCUS_AREA
      params = {focusArea: focusArea}
      dispatch(key, ApiConstants.PENDING, params)
      $http.put("api/focus_areas/#{focusArea.id}", {focus_area: focusArea}).
        then(handleResponse(key, params))
    deleteFocusArea: (focusArea)->
      key = HerdConstants.DELETE_FOCUS_AREA
      params = {focusArea: focusArea}
      dispatch(key, ApiConstants.PENDING, params)
      $http['delete']("api/focus_areas/#{focusArea.id}", params).
        then(handleResponse(key, params))
    fetchUsers:->
      key = HerdConstants.FETCH_USERS
      params = {}
      dispatch(key, ApiConstants.PENDING, params)
      $http.get("api/users").
        then(handleResponse(key, params))
    addGoal: (newGoal)->
      key = HerdConstants.ADD_GOAL
      params = {goal: newGoal}
      dispatch(key, ApiConstants.PENDING, params)
      $http.post("/api/goals", params).
        then(handleResponse(key, params))
    markGoalAsDone: (goal)->
      key = HerdConstants.COMPLETE_GOAL
      params = {goal: goal}
      dispatch(key, ApiConstants.PENDING, params)
      $http.put("/api/goals/#{goal.id}", params).
        then(handleResponse(key, params))
    deleteGoal: (goal)->
      key = HerdConstants.DELETE_GOAL
      params = {goal: goal}
      dispatch(key, ApiConstants.PENDING, params)
      $http['delete']("/api/goals/#{goal.id}").
        then(handleResponse(key, params))
    fetchGoals: ->
      key = HerdConstants.FETCH_GOALS
      params = {}
      dispatch(key, ApiConstants.PENDING, params)
      $http.get('/api/goals').
        then(handleResponse(key, params))
    fetchWeeklyReport: (id)->
      key = HerdConstants.FETCH_WEEKLY_REPORT
      params = {id: id}
      dispatch(key, ApiConstants.PENDING, params)
      $http.get("/api/herd_weeklies/#{id}").
        then(handleResponse(key, params))
    fetchWeeklyReports: ->
      key = HerdConstants.FETCH_WEEKLY_REPORTS
      params = {}
      dispatch(key, ApiConstants.PENDING, params)
      $http.get('/api/herd_weeklies').
        then(handleResponse(key, params))
    updateCurrentWeeklyReport: (userId) ->
      key = HerdConstants.UPDATE_WEEKLY_REPORT
      params = {userId: userId}
      dispatch(key, ApiConstants.PENDING, params)
      $http.patch("api/user_weeklies/#{userId}").
        then(handleResponse(key, params))
    updateSection: (section)->
      key = HerdConstants.UPDATE_SECTION
      params = {section: section, section_id: section.id}
      dispatch(key, ApiConstants.PENDING, params)
      $http.put("/api/sections/#{section.id}", params).
        then(handleResponse(key, params))
    addWeeklyTask: (newWeeklyTask)->
      key = HerdConstants.ADD_WEEKLY_TASK
      params = {weekly_task: newWeeklyTask}
      dispatch(key, ApiConstants.PENDING, params)
      $http.post("/api/weekly_tasks", params).
        then(handleResponse(key, params))
    completeWeeklyTask: (weeklyTask)->
      key = HerdConstants.COMPLETE_WEEKLY_TASK
      params = {weekly_task: weeklyTask}
      dispatch(key, ApiConstants.PENDING, params)
      $http.put("/api/weekly_tasks/#{weeklyTask.id}", params).
        then(handleResponse(key, params))
    deleteWeeklyTask: (weeklyTask)->
      key = HerdConstants.DELETE_WEEKLY_TASK
      params = {weekly_task: weeklyTask}
      dispatch(key, ApiConstants.PENDING, params)
      $http.delete("/api/weekly_tasks/#{weeklyTask.id}").
        then(handleResponse(key,params))
    fetchActivity: ->
      key = HerdConstants.FETCH_ACTIVITY
      params = {}
      dispatch(key, ApiConstants.PENDING, params)
      $http.get('/api/activities').
        then(handleResponse(key, params))
    fetchComments: (section)->
      key = HerdConstants.FETCH_COMMENTS
      params = {section: section}
      dispatch(key, ApiConstants.PENDING, params)
      $http.get("/api/sections/#{section.id}/comments").
        then(handleResponse(key, params))
    addComment: (comment, section)->
      key = HerdConstants.ADD_COMMENT
      params = {comment: comment, section: section}
      dispatch(key, ApiConstants.PENDING, params)
      $http.post("/api/sections/#{section.id}/comments", params).
        then(handleResponse(key, params))
    loginTodoist: (user, email, password)->
      key = HerdConstants.LOGIN_TODOIST
      params = {todoistEmail: email, todoistPassword: password}
      dispatch(key, ApiConstants.PENDING, params)
      $http.post("/api/users/#{user.id}/login_todoist", params).
        then(handleResponse(key, params))
    sendFeedback: (user, feedback)->
      key = HerdConstants.SEND_FEEDBACK
      params = {user: user, feedback, feedback}
      dispatch(key, ApiConstants.PENDING, params)
      $http.post("/api/users/feedback", params).
        then(handleResponse(key, params))
    uploadPicture: (files)->
      key = HerdConstants.UPLOAD_PICTURE
      fd = new FormData()
      angular.forEach(files, (file)->
        fd.append('file',file))
      params = {pictures: fd}
      headers = {
                  transformRequest:angular.identity,
                  headers:{'Content-Type':undefined}
                }
      dispatch(key, ApiConstants.PENDING, params)
      debugger
      $http.post("/api/uploads/profile", fd,
        {
          transformRequest:angular.identity,
          headers:{'Content-Type':undefined}
        }).
        then(handleResponse(key, params))
  }
])
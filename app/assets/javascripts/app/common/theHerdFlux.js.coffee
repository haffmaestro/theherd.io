app = angular.module('app')

app.factory('HerdDispatcher', ['FluxUtil', (FluxUtil)->
  FluxUtil.createDispatcher()
])

app.factory('HerdConstants', ['FluxUtil', (FluxUtil)->
  return FluxUtil.defineConstants(['FETCH_GOALS','ADD_GOAL','ADD_GOAL_INTERNAL', 'DELETE_GOAL', 'COMPLETE_GOAL', 'ADD_FOCUS_AREA', 'UPDATE_FOCUS_AREA', 
    'DELETE_FOCUS_AREA', 'FETCH_USERS'])
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
    fetchGoals: ->
      HerdApi.fetchGoals()


  }
])

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
    fetchGoals: ->
      key = HerdConstants.FETCH_GOALS
      params = {}
      dispatch(key, ApiConstants.PENDING, params)
      $http.get('/api/goals').
        then(handleResponse(key, params))
  }
])
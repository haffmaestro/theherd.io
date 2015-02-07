app = angular.module('app')

app.factory('HerdDispatcher', ['FluxUtil', (FluxUtil)->
  FluxUtil.createDispatcher()
])

app.factory('HerdConstants', ['FluxUtil', (FluxUtil)->
  return FluxUtil.defineConstants(['ADD_GOAL', 'DELETE_GOAL', 'COMPLETE_GOAL', 'ADD_FOCUS_AREA', 'UPDATE_FOCUS_AREA', 
    'DELETE_FOCUS_AREA', 'FETCH_USERS'])
])

app.factory('ApiConstants', ['FluxUtil', (FluxUtil)->
  return FluxUtil.defineConstants(['PENDING', 'ERROR'])])

app.factory('HerdActions', ['HerdConstants', 'HerdApi', 'HerdDispatcher', (HerdConstants, HerdApi, HerdDispatcher)->
  return {
    addFocusArea: (newFocusArea)->
      HerdApi.addFocusArea(newFocusArea)
    updateFocusArea: (focusArea)->
      HerdApi.updateFocusArea(focusArea)
    deleteFocusArea: (focusArea)->
      HerdApi.deleteFocusArea(focusArea)
    fetchUsers: ->
      HerdApi.fetchUsers()

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

  #Public Interface
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
  }
])

app.factory('HerdStore', ['HerdDispatcher', 'HerdConstants','ApiConstants','FluxUtil','HerdApi','$preloaded', (HerdDispatcher, HerdConstants, ApiConstants, FluxUtil, HerdApi, $preloaded)->
  _currentUser = $preloaded.user.user
  _users = []

  _addFocusArea = (newFocusArea)->
    user = _findUser(newFocusArea.user_id)
    user.focus_areas.push(newFocusArea)

  _updateFocusArea = (focusArea)->
    user = _findUser(focusArea.user_id)
    index = _findIndexOfById(user.focus_areas, focusArea)
    user.focus_areas[index] = focusArea

  _deleteFocusArea = (focusArea)->
    user = _findUser(focusArea.user_id)
    index = _findIndexOfById(user.focus_areas, focusArea)
    user.focus_areas.splice(index, 1)

  _findIndexOfById = (list, element)->
    index = null
    angular.forEach(list, (current)->
      if current.id == element.id
        index = list.indexOf(current)
      )
    index

  _findUser = (id)->
    result = null
    angular.forEach(_users, (current)->
      if (id == current.id)
        result = current
      )
    result

  store = FluxUtil.createStore({
    getUsers: ()->
      return _users
    getCurrentUser: ->
      return _currentUser
    dispatcherIndex: HerdDispatcher.register((payload)->
      action = payload.action

      if action.response == ApiConstants.PENDING
        if action.actionType == HerdConstants.ADD_FOCUS_AREA
          store.emitChange action
      else if action.response == ApiConstants.ERROR
        console.log action.actionType
        console.log 'Error received from dispatcher'
      else
        switch action.actionType
          when HerdConstants.ADD_FOCUS_AREA
            _addFocusArea(action.response.focus_area)
            store.emitChange action
          when HerdConstants.UPDATE_FOCUS_AREA
            _updateFocusArea(action.response.focus_area)
            store.emitChange action
          when HerdConstants.DELETE_FOCUS_AREA
            _deleteFocusArea(action.response.focus_area)
            store.emitChange action
          when HerdConstants.FETCH_USERS
            _users = action.response.users
            store.emitChange action
      
      )
    })


])
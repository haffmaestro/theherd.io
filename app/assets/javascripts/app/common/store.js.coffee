app = angular.module('app')
app.factory('HerdStore', ['HerdDispatcher', 'HerdConstants','ApiConstants','FluxUtil','HerdApi','$preloaded', (HerdDispatcher, HerdConstants, ApiConstants, FluxUtil, HerdApi, $preloaded)->
  _currentUser = $preloaded.user.user
  _users = []
  _goals = []
  _nextGoal = []

  _addFocusArea = (newFocusArea)->
    user = _findUser(newFocusArea.user_id)
    user.focus_areas.push(newFocusArea)

  _updateFocusArea = (focusArea)->
    user = _findUser(focusArea.user_id)
    index = _findIndexOfById(user.focus_areas, 'id', focusArea)
    user.focus_areas[index] = focusArea

  _deleteFocusArea = (focusArea)->
    user = _findUser(focusArea.user_id)
    index = _findIndexOfById(user.focus_areas, 'id', focusArea.id)
    user.focus_areas.splice(index, 1)

  _addGoal = (newGoal)->
    index = _findIndexOfById(_goals, 'user_id', newGoal.user_id)
    time_stamp = _nextGoal.shift()
    user = _goals[index]

  _findIndexOfById = (list, key, idOfElement)->
    index = null
    angular.forEach(list, (current)->
      if current[key] == idOfElement
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
    getGoals: ->
      return _goals

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
          when HerdConstants.ADD_GOAL
            console.log payload
            _addGoal(action.response.goal)
            store.emitChange action
          when HerdConstants.ADD_GOAL_INTERNAL
            _nextGoal.push(action.item.months)
          when HerdConstants.FETCH_GOALS
            _goals = action.response.goals
            store.emitChange action
      )
    })


])
app = angular.module('app')
app.factory('SettingsStore', ['HerdDispatcher', 'HerdStore', 'HerdConstants','ApiConstants','FluxUtil','HerdApi','$preloaded','Notification', (HerdDispatcher, HerdStore, HerdConstants, ApiConstants, FluxUtil, HerdApi, $preloaded,Notification)->
  _currentUser = HerdStore.getCurrentUser()
  _showSettingsDialog = false

  _addFocusArea = (newFocusArea)->
    _currentUser.focus_areas.push(newFocusArea)
    _canUpdateCurrentReport = true

  _updateFocusArea = (focusArea)->
    index = _findIndexOfById(_currentUser.focus_areas, 'id', focusArea)
    _currentUser.focus_areas[index] = focusArea
    _canUpdateCurrentReport = true

  _deleteFocusArea = (focusArea)->
    index = _findIndexOfById(_currentUser.focus_areas, 'id', focusArea.id)
    _currentUser.focus_areas.splice(index, 1)
    _canUpdateCurrentReport = true

  _findIndexOfById = (list, key, idOfElement)->
    index = null
    angular.forEach(list, (current)->
      if current[key] == idOfElement
        index = list.indexOf(current)
      )
    index

  store = FluxUtil.createStore({
    getCurrentUser: ->
      return _currentUser
    showSettingsDialog: ->
      return _showSettingsDialog

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
            console.log action
            _addFocusArea(action.response.focus_area)
            store.emitChange action
            Notification.show('Updated!', 2000)
          when HerdConstants.UPDATE_FOCUS_AREA
            console.log action
            _updateFocusArea(action.response.focus_area)
            store.emitChange action
            Notification.show('Updated!', 2000)
          when HerdConstants.DELETE_FOCUS_AREA
            console.log action
            _deleteFocusArea(action.response.focus_area)
            store.emitChange action
            Notification.show('Deleted!', 2000)
          when HerdConstants.LOGIN_TODOIST
            if action.response.hasOwnProperty("user")
              _currentUser = action.response.user
              Notification.show("Todoist Integration added.", 2000)
            else
              Notification.show(action.response.msg, 3000)
            console.log action
            store.emitChange action
    )
  })
])
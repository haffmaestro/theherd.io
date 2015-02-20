app = angular.module('app')
app.factory('SettingsStore', ['HerdDispatcher', 'HerdStore', 'HerdConstants','ApiConstants','FluxUtil','HerdApi','$preloaded','Notification', (HerdDispatcher, HerdStore, HerdConstants, ApiConstants, FluxUtil, HerdApi, $preloaded,Notification)->
  _currentUser = HerdStore.getCurrentUser()
  _showSettingsDialog = false

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
          when HerdConstants.TOGGLE_SETTINGS_DIALOG
            _showSettingsDialog = !_showSettingsDialog
            console.log _showSettingsDialog
            store.emitChange action
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
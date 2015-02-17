app = angular.module('app')
app.factory('SettingsStore', ['HerdDispatcher', 'HerdConstants','ApiConstants','FluxUtil','HerdApi','$preloaded','Notification', (HerdDispatcher, HerdConstants, ApiConstants, FluxUtil, HerdApi, $preloaded,Notification)->
  _showSettingsDialog = false

  store = FluxUtil.createStore({
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
    )
  })
])
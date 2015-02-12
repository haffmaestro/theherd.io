app = angular.module('app')

app.factory('NavigationStore', ['HerdDispatcher', 'HerdConstants','ApiConstants','FluxUtil','HerdApi','$preloaded', (HerdDispatcher, HerdConstants, ApiConstants, FluxUtil, HerdApi, $preloaded)->
  _weeklyReport = null
  _weeklyReports = []
  _weeklyReportNavigationData = {
    next: ""
    previous: ""
    user: ""
  }
  _goalsNavigationData = {
    range: 0
    user: ""
  }

  _setWeeklyReportNavigationData = ->
    previousWeek = if _weeklyReport.week < 11 then ('0'+(_weeklyReport.week-1)) else _weeklyReport.week-1
    nextWeek = if _weeklyReport.week < 9 then ('0'+(_weeklyReport.week+1)) else _weeklyReport.week+1
    _weeklyReportNavigationData.previous = "#{_weeklyReport.year}-#{previousWeek}"
    _weeklyReportNavigationData.next = "#{_weeklyReport.year}-#{nextWeek}"

  _setGoalsNavigationData = ->



  store = FluxUtil.createStore({
    getWeeklyReportRoutingData: ->
      return _weeklyReportNavigationData
    getGoalsRoutingData: ->
      return _goalsNavigationData
    getWeeklyReports: ->
      return _weeklyReports

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
          when HerdConstants.FETCH_WEEKLY_REPORT
            console.log action
            _weeklyReport = action.response.herd_weekly
            _setWeeklyReportNavigationData()
            store.emitChange action
          when HerdConstants.FETCH_WEEKLY_REPORTS
            console.log action
            _weeklyReports = action.response.herd_weeklies
            store.emitChange action
          when HerdConstants.SET_WEEKLY_REPORT_ROUTING_DATA
            console.log action
            angular.extend(_weeklyReportNavigationData, action.item)
            store.emitChange action
          when HerdConstants.SET_GOALS_ROUTING_DATA
            console.log action
            action.item.range = parseInt(action.item.range)
            angular.extend(_goalsNavigationData, action.item)
            store.emitChange action
    )
  })
])
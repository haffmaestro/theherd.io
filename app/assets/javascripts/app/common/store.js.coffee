app = angular.module('app')
app.factory('HerdStore', ['HerdDispatcher', 'HerdConstants','ApiConstants','FluxUtil','HerdApi','$preloaded', (HerdDispatcher, HerdConstants, ApiConstants, FluxUtil, HerdApi, $preloaded)->
  _currentUser = $preloaded.user.user
  _users = []
  _goals = []
  _nextGoal = []
  _weeklyReports = []
  _weeklyReport = null
  _canUpdateCurrentReport = false
  _newsFeed = []

  _addFocusArea = (newFocusArea)->
    user = _findUser(newFocusArea.user_id)
    user.focus_areas.push(newFocusArea)
    _canUpdateCurrentReport = true

  _updateFocusArea = (focusArea)->
    user = _findUser(focusArea.user_id)
    index = _findIndexOfById(user.focus_areas, 'id', focusArea)
    user.focus_areas[index] = focusArea
    _canUpdateCurrentReport = true

  _deleteFocusArea = (focusArea)->
    user = _findUser(focusArea.user_id)
    index = _findIndexOfById(user.focus_areas, 'id', focusArea.id)
    user.focus_areas.splice(index, 1)
    _canUpdateCurrentReport = true

  _addGoal = (newGoal)->
    index = _findIndexOfById(_goals, 'user_id', newGoal.user_id)
    time_stamp = _nextGoal.shift()
    user = _goals[index]
    focusArea = user.focus_areas[_findIndexOfById(user.focus_areas, 'id', newGoal.focus_area_id)]
    switch time_stamp
      when 1
        focusArea.one_month_goals.push(newGoal)
      when 3
        focusArea.three_month_goals.push(newGoal)
      when 12
        focusArea.one_year_goals.push(newGoal)
      when 36
        focusArea.three_year_goals.push(newGoal)
      when 120
        focusArea.ten_year_goals.push(newGoal)
  
  _markGoalAsDone = (updated, queryGoal)->
    if updated
      locationInfo = {list: null, id: null}
      user = _goals[_findIndexOfById(_goals, 'user_id', queryGoal.user_id)]
      focusArea = user.focus_areas[_findIndexOfById(user.focus_areas, 'id', queryGoal.focus_area_id)]
      time_stamps = ['one_month_goals', 'three_month_goals', 'one_year_goals', 'three_year_goals', 'ten_year_goals']
      angular.forEach(time_stamps, (current)->
        if focusArea[current].indexOf(queryGoal) >= 0
          locationInfo.list = current
          locationInfo.index = focusArea[current].indexOf(queryGoal)
        )
      focusArea[locationInfo.list][locationInfo.index].done = true

  _deleteGoal = (goal, oldGoal)->
    deleteInfo = {list: null, id: null}
    user = _findInListByKey(_goals, 'user_id', goal.user_id)
    focusArea = user.focus_areas[_findIndexOfById(user.focus_areas, 'id', goal.focus_area_id)]
    time_stamps = ['one_month_goals', 'three_month_goals', 'one_year_goals', 'three_year_goals', 'ten_year_goals']
    angular.forEach(time_stamps, (current)->
      if focusArea[current].indexOf(oldGoal) >= 0
        deleteInfo.list = current
        deleteInfo.id = focusArea[current].indexOf(oldGoal)
      )
    focusArea[deleteInfo.list].splice(deleteInfo.id, 1)

  _addWeeklyTask = (newWeeklyTask)->
    user = _findInListByKey(_weeklyReport.user_weeklies, 'user_id', newWeeklyTask.user_id)
    section = _findInListByKey(user.sections, 'id', newWeeklyTask.section_id)
    section.weekly_tasks.push(newWeeklyTask)

  _completeWeeklyTask = (weeklyTask)->
    user = _findInListByKey(_weeklyReport.user_weeklies, 'user_id', weeklyTask.user_id)
    section = _findInListByKey(user.sections, 'id', weeklyTask.section_id)
    index = _findIndexOfById(section.weekly_tasks, 'id', weeklyTask.id)
    section.weekly_tasks[index].done = true
  
  _deleteWeeklyTask = (weeklyTask)->
    user = _findInListByKey(_weeklyReport.user_weeklies, 'user_id', weeklyTask.user_id)
    section = _findInListByKey(user.sections, 'id', weeklyTask.section_id)
    index = _findIndexOfById(section.weekly_tasks, 'id', weeklyTask.id)
    section.weekly_tasks.splice(index, 1)

  _findIndexOfById = (list, key, idOfElement)->
    index = null
    angular.forEach(list, (current)->
      if current[key] == idOfElement
        index = list.indexOf(current)
      )
    index

  _findInListByKey = (list, key, idOfElement)->
    index = _findIndexOfById(list, key, idOfElement)
    result = null
    if index || index == 0
      result = list[index]
    result


  _findUser = (id)->
    result = null
    angular.forEach(_users, (current)->
      if (id == current.id)
        result = current
      )
    result

  store = FluxUtil.createStore({
    getUsers: ->
      return _users
    getCurrentUser: ->
      return _currentUser
    getGoals: ->
      return _goals
    getWeeklyReport: ->
      return _weeklyReport
    getWeeklyReports: ->
      return _weeklyReports
    canUpdateCurrentReport: ->
      return _canUpdateCurrentReport
    getNewsFeed: ->
      return _newsFeed

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
            _addGoal(action.response.goal)
            store.emitChange action
          when HerdConstants.COMPLETE_GOAL
            _markGoalAsDone(action.response, action.queryParams.goal)
            store.emitChange action
          when HerdConstants.DELETE_GOAL
            _deleteGoal(action.response.goal, action.queryParams.goal)
            store.emitChange action
          when HerdConstants.ADD_GOAL_INTERNAL
            _nextGoal.push(action.item.months)
          when HerdConstants.FETCH_GOALS
            _goals = action.response.goals
            store.emitChange action
          when HerdConstants.FETCH_WEEKLY_REPORT
            _weeklyReport = action.response.herd_weekly
            store.emitChange action
          when HerdConstants.UPDATE_SECTION
            #TODO: Update section in weeklyReport in Store
            store
          when HerdConstants.FETCH_WEEKLY_REPORTS
            _weeklyReports = action.response.herd_weeklies
            store.emitChange action
          when HerdConstants.UPDATE_WEEKLY_REPORT
            _canUpdateCurrentReport = false
            store.emitChange action
          when HerdConstants.ADD_WEEKLY_TASK
            _addWeeklyTask(action.response.weekly_task)
            store.emitChange action
          when HerdConstants.COMPLETE_WEEKLY_TASK
            _completeWeeklyTask(action.response.weekly_task)
            store.emitChange action
          when HerdConstants.DELETE_WEEKLY_TASK
            _deleteWeeklyTask(action.response.weekly_task)
            store.emitChange action
          when HerdConstants.FETCH_ACTIVITY
            _newsFeed = action.response.activities
            store.emitChange action
      )
    })


])
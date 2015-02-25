app = angular.module('app')
app.factory('HerdStore', ['HerdDispatcher', 'HerdConstants','ApiConstants','FluxUtil','HerdApi','$preloaded','Notification', (HerdDispatcher, HerdConstants, ApiConstants, FluxUtil, HerdApi, $preloaded,Notification)->
  _currentUser = $preloaded.user.user
  _users = []
  _usersByFirstName = []
  _goals = []
  _nextGoal = []
  _weeklyReport = undefined
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
    locationInfo = {list: null, id: null}
    user = _goals[_findIndexOfById(_goals, 'user_id', queryGoal.user_id)]
    focusArea = user.focus_areas[_findIndexOfById(user.focus_areas, 'id', queryGoal.focus_area_id)]
    time_stamps = ['one_month_goals', 'three_month_goals', 'one_year_goals', 'three_year_goals', 'ten_year_goals']
    angular.forEach(time_stamps, (current)->
      if focusArea[current].indexOf(queryGoal) >= 0
        locationInfo.list = current
        locationInfo.index = focusArea[current].indexOf(queryGoal)
      )
    focusArea[locationInfo.list][locationInfo.index].done = updated

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
    section.weekly_tasks[index].done = weeklyTask.done
  
  _deleteWeeklyTask = (weeklyTask)->
    user = _findInListByKey(_weeklyReport.user_weeklies, 'user_id', weeklyTask.user_id)
    section = _findInListByKey(user.sections, 'id', weeklyTask.section_id)
    index = _findIndexOfById(section.weekly_tasks, 'id', weeklyTask.id)
    section.weekly_tasks.splice(index, 1)

  _setNewsFeed = (activities)->
    activitiesWithTarget = []
    angular.forEach(activities, (current)->
      if current.target == null
      else if current.target.focus_area == null
      else
        activitiesWithTarget.push(current)
      )
    _newsFeed = activitiesWithTarget

  _updateUser = (user)->
    indexOfUser = _findIndexOfById(_users, "id", user.id)
    _users[indexOfUser] = user

  ########HELPER METHODS###########
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
    getUsersByFirstName: ->
      return _usersByFirstName
    getCurrentUser: ->
      return _currentUser
    getGoals: ->
      return _goals
    getWeeklyReport: ->
      return _weeklyReport
    canUpdateCurrentReport: ->
      return _canUpdateCurrentReport
    getNewsFeed: ->
      return _newsFeed
    

    dispatcherIndex: HerdDispatcher.register((payload)->
      action = payload.action

      if action.response == ApiConstants.PENDING
        switch action.actionType
          when HerdConstants.ADD_FOCUS_AREA
            store.emitChange action
          when HerdConstants.UPLOAD_PICTURE
            Notification.show("Uploading...", 2000)
      else if action.response == ApiConstants.ERROR
        console.log action.actionType
        console.log 'Error received from dispatcher'
      else
        switch action.actionType
          when HerdConstants.FETCH_USERS
            console.log action
            _users = action.response.users
            store.emitChange action
          when HerdConstants.ADD_GOAL
            console.log action
            _addGoal(action.response.goal)
            store.emitChange action
            Notification.show('Updated!', 2000)
          when HerdConstants.COMPLETE_GOAL
            console.log action
            _markGoalAsDone(action.response, action.queryParams.goal)
            store.emitChange action
            if action.response
              Notification.show('Well done!', 2000)
            else
              Notification.show('Ok.', 2000)
          when HerdConstants.DELETE_GOAL
            console.log action
            _deleteGoal(action.response.goal, action.queryParams.goal)
            store.emitChange action
            Notification.show('Deleted!', 2000)
          when HerdConstants.ADD_GOAL_INTERNAL
            console.log action
            _nextGoal.push(action.item.months)
          when HerdConstants.FETCH_GOALS
            console.log action
            _goals = action.response.goals
            store.emitChange action
          when HerdConstants.FETCH_WEEKLY_REPORT
            console.log action
            _weeklyReport = action.response.herd_weekly
            store.emitChange action
          when HerdConstants.UPDATE_SECTION
            console.log action
            Notification.show('Saved.', 2000)
            #TODO: Update section in weeklyReport in Store
            store
          when HerdConstants.UPDATE_WEEKLY_REPORT
            console.log action
            _canUpdateCurrentReport = false
            store.emitChange action
            Notification.show('Updated!', 2000)
          when HerdConstants.ADD_WEEKLY_TASK
            console.log action
            _addWeeklyTask(action.response.weekly_task)
            store.emitChange action
            Notification.show('Added!', 2000)
          when HerdConstants.COMPLETE_WEEKLY_TASK
            console.log action
            _completeWeeklyTask(action.response.weekly_task)
            store.emitChange action
            if action.response.weekly_task.done
              Notification.show('Well done!', 2000)
            else
              Notification.show('Ok.', 2000)
          when HerdConstants.DELETE_WEEKLY_TASK
            console.log action
            _deleteWeeklyTask(action.response.weekly_task)
            store.emitChange action
            Notification.show('Deleted!', 2000)
          when HerdConstants.FETCH_ACTIVITY
            console.log action
            _setNewsFeed(action.response.activities)
            store.emitChange action
          when HerdConstants.SEND_FEEDBACK
            console.log action
            Notification.show("Feedback sent.", 2000)
          when HerdConstants.UPLOAD_PICTURE
            console.log action
            Notification.show('Picture uploaded.', 2000)
            _updateUser(action.response.user)
            store.emitChange action
      )
    })


])
app = angular.module('app')

app.factory('HerdDispatcher', ['FluxUtil', (FluxUtil)->
  FluxUtil.createDispatcher()
])

app.factory('HerdConstants', ['FluxUtil', (FluxUtil)->
  return FluxUtil.defineConstants(['FETCH_GOALS','ADD_GOAL','ADD_GOAL_INTERNAL', 'DELETE_GOAL',
    'COMPLETE_GOAL', 'ADD_FOCUS_AREA', 'UPDATE_FOCUS_AREA', 'DELETE_FOCUS_AREA', 'FETCH_USERS',
    'FETCH_WEEKLY_REPORT','FETCH_WEEKLY_REPORTS','UPDATE_WEEKLY_REPORT', 'UPDATE_SECTION','ADD_WEEKLY_TASK',
    'DELETE_WEEKLY_TASK', 'COMPLETE_WEEKLY_TASK', 'FETCH_ACTIVITY', 'SET_WEEKLY_REPORT_ROUTING_DATA',
    'SET_GOALS_ROUTING_DATA','FETCH_COMMENTS', 'ADD_COMMENT', 'ADD_COMMENT_OPEN_QUEUE', 'COMMENT_SHOWN',
    'LOGIN_TODOIST','TOGGLE_SETTINGS_DIALOG','SEND_FEEDBACK', 'UPLOAD_PICTURE'])
])

app.factory('ApiConstants', ['FluxUtil', (FluxUtil)->
  return FluxUtil.defineConstants(['PENDING', 'ERROR'])])


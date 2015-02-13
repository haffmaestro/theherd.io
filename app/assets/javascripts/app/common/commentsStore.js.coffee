app = angular.module('app')

app.factory('CommentsStore', ['HerdDispatcher', 'HerdConstants','ApiConstants','FluxUtil','HerdApi', (HerdDispatcher, HerdConstants, ApiConstants, FluxUtil, HerdApi)->
  _comments = {}

  _setComments = (comments, section)->
    _comments[section.id] = comments
  _addComment = (comment) ->
    _comments[comment.section_id].push(comment)


  store = FluxUtil.createStore({
    getComments: (section)->
      if _comments[section.id]
        _comments[section.id]
      else
        null 

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
          when HerdConstants.FETCH_COMMENTS
            console.log action
            _setComments(action.response.comments, action.queryParams.section)
            store.emitChange(action)
          when HerdConstants.ADD_COMMENT
            console.log action
            _addComment(action.response.comment)
            store.emitChange(action)

    )
  })
])
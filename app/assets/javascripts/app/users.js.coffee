app = angular.module('app')

app.factory('Users', ['$http', ($http) ->
  users = ['Halfdan', 'Gareth', 'Jonah', 'Gray']
  {
    get: ->
      return users
  }
  ])

app.factory('currentUser', ['$preloaded', ($preloaded)->
	currentUser = $preloaded.user
	currentUser.user
	])

###
A simple example service that returns some data.
###
angular.module("songaday")

.factory "AccountService",($rootScope,$firebaseObject,Auth,FBURL) ->

  # Might use a resource here that returns a JSON array
  ref = new Firebase(FBURL)
  loading = true
  promise_auth = Auth.$waitForAuth()
  me={}
  loggedIn: ->
    console.log(auth)
  refresh:(cb) ->
    promise_auth.then (authObject)->
      if authObject==null|| typeof authObject.google == 'undefined'
        cb({})
        return
      my_id = CryptoJS.SHA1(authObject.google.email).toString().substring 0,11
      me=$firebaseObject(ref.child('artists/'+my_id))
      me.$loaded ()->
        cb(me)
  mySelf:->
    me


  login: ->
    provider='google'
    Auth.$authWithOAuthPopup(provider, scope: "email").then ((authObject) ->
      # Handle success
      my_id = CryptoJS.SHA1(authObject.google.email).toString().substring(0,11)
      me = $firebaseObject(ref.child('artists/'+my_id))
      return
    ), (error) ->
      console.log(errer)
      # Handle error
      return

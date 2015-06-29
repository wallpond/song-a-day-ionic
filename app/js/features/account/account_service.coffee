###
A simple example service that returns some data.
###
angular.module("songaday")

.factory "AccountService",($rootScope,$firebaseArray,$firebaseObject,Auth,FBURL) ->

  # Might use a resource here that returns a JSON array
  ref = new Firebase(FBURL)
  loading = true
  me={}
  loggedIn: ->
    console.log(auth)
  refresh:(cb) ->
    Auth.$waitForAuth().then (authObject) ->
      if authObject==null|| typeof authObject.google == 'undefined'
        console.log("NOT LOGGED IN")
        return
      my_id = CryptoJS.SHA1(authObject.google.email).toString().substring 0,11
      me=$firebaseObject(ref.child('artists/'+my_id))
      $rootScope.notifications=$firebaseArray(ref.child('notices/'+my_id))
      $rootScope.notifications.$loaded ()->
        console.log($rootScope.notifications)
      me.$loaded ()->
        console.log(me)
        cb(me)
  mySelf:->
    me
  remove_song:(song,cb)->
    song_uri=FBURL+'/artists/'+me.$id+'/songs/' + song.$id
    last_song_uri=FBURL+'/artists/'+me.$id+'/last_transmission/'
    song_ref=new Firebase(song_uri)
    last_song_ref=new Firebase(last_song_uri)
    song_ref.remove()
    last_song_ref.remove()
    song.$remove()
    cb()
  logout: ->
    Auth.$unauth()
  login: ->
    provider='google'
    Auth.$authWithOAuthPopup(provider, scope: "email").then ((authObject) ->
      # Handle success
      my_id = CryptoJS.SHA1(authObject.google.email).toString().substring(0,11)
      me = $firebaseObject(ref.child('artists/'+my_id))
      return
    ), (error) ->
      console.log(error)
      # Handle error
      return

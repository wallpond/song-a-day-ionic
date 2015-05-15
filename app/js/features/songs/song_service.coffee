###
A simple example service that returns some data.
###
angular.module("songaday")

.factory "SongService",($firebaseObject,$firebaseArray,FBURL) ->

  # Might use a resource here that returns a JSON array
  limit =17
  ref = new Firebase(FBURL+'songs')
    .orderByChild("timestamp")
    .limitToLast(limit)
  console.log(FBURL)
  # Some fake testing data
  songs = $firebaseArray(ref)
  songs.$loaded ()->
    console.log(songs)
  all: ->
    console.log(songs)
    songs

  get: (songId) ->
    ref = new Firebase(FBURL+'/songs/'+songId)

    $firebaseObject(ref)

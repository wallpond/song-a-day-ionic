###
A simple example service that returns some data.
###
angular.module("songaday")

.factory "PlaylistService",($firebaseObject,$firebaseArray,SongService,FBURL) ->

  # Might use a resource here that returns a JSON array
  limit=7
  ref = new Firebase(FBURL+'/playlists')
  # Some fake testing data
  playlists = $firebaseArray(ref)
  some: ->
    playlists
  get: (playlistId) ->
    ref = new Firebase(FBURL+'/playlists/'+playlistId)
    $firebaseObject(ref)
  new: (playlist) ->
    playlists.$add(playlist)

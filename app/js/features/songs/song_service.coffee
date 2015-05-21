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
  # Some fake testing data
  songs = $firebaseArray(ref)
  all: ->
    songs
  comment: (song,comment)->
    commentsRef=new Firebase(FBURL+'songs/'+song.$id+'/comments')
    comments=$firebaseArray(commentsRef)
    comments.$add(comment)
  get: (songId) ->
    ref = new Firebase(FBURL+'/songs/'+songId)

    $firebaseObject(ref)
  getList:(songList) ->
    playlist = []
    for songId of songList
      playlist.push(this.get(songId))
    playlist

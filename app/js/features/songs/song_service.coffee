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
  all: ->
    songs

  get: (songId) ->
    ref = new Firebase(FBURL+'/songs/'+songId)

    $firebaseObject(ref)
  getList:(songList) ->
    playlist = []
    console.log(songList)
    for songId of songList
      playlist.push(this.get(songId))
    playlist

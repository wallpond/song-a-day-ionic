###
A simple example service that returns some data.
###
angular.module("songaday")

.factory "PlayerService",() ->

  # Might use a resource here that returns a JSON array
  playlist =[]
  currentIndex = 0

  nowPlaying: () ->
    playlist[currentIndex]
  listen:(song)->
    playlist.push(song.media)
  getPlaylist:()->
    playlist

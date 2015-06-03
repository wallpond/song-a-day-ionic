###
A simple example service that returns some data.
###
angular.module("songaday")

.factory "SongService",($firebaseObject,$firebaseArray,FBURL) ->

  # Might use a resource here that returns a JSON array
  limit=7
  ref = new Firebase(FBURL+'songs')
  # Some fake testing data
  scrollRef = new Firebase.util.Scroll(ref, '$priority')
  scroll = scrollRef.scroll
  songs = $firebaseArray(scrollRef)
  some: ->
    @more()
    songs
  more: ->
    scroll.next(limit)
  comment: (song,comment)->
    commentsRef=new Firebase(FBURL+'songs/'+song.$id+'/comments')
    comments=$firebaseArray(commentsRef)
    comments.$add(comment)
    comment={}
  get: (songId) ->
    ref = new Firebase(FBURL+'/songs/'+songId)

    $firebaseObject(ref)
  getList:(songList) ->
    playlist = []
    for songId of songList
      playlist.push(this.get(songId))
    playlist

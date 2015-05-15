###
A simple example service that returns some data.
###
angular.module("songaday")

.factory "ArtistService",($firebaseObject,$firebaseArray,FBURL) ->

  # Might use a resource here that returns a JSON array
  ref = new Firebase(FBURL+'artists')
    .orderByChild("songs")
  console.log(FBURL)
  # Some fake testing data
  artists = $firebaseArray(ref)
  all: ->
    artists

  get: (artistId) ->
    ref = new Firebase(FBURL+'/artists/'+artistId)
    artist=$firebaseObject(ref)
    console.log(artist)
    return artist

###
A simple example service that returns some data.
###
angular.module("songaday")

.factory "ArtistService",($firebaseObject,$firebaseArray,FBURL) ->

  # Might use a resource here that returns a JSON array
  ref = new Firebase(FBURL+'artists')
  this.loading = true
  artists = $firebaseArray(ref)
  some: ->
    artists.$loaded( ()->
      this.loading=false
    )
    artists


  get: (artistId) ->
    ref = new Firebase(FBURL+'/artists/'+artistId)
    artist=$firebaseObject(ref)
    return artist

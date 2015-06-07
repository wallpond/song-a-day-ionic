###
A simple example service that returns some data.
###
angular.module("songaday")

.factory "MultiTrackService",() ->

  # Might use a resource here that returns a JSON array
  limit=7
  # Some fake testing data
  tracks = []
  mix: () ->
    mixDown = ""
    for track in tracks
      mixDown += track
    return tracks

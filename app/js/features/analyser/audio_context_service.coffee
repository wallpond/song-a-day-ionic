###
A simple example service that returns some data.
###
angular.module("songaday")

.factory "AudioContextService", ($window)->
  nodes={}
  context = new ($window.AudioContext || $window.webkitAudioContext)()

  getContext: () ->
    return context
  getAudioContext: () ->
    return context

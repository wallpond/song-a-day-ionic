###
A simple example service that returns some data.
###
angular.module("songaday")

.factory "VisualizerService",($rootScope,$window) ->

  initialize:() ->
    ctx = new AudioContext
    audio = document.getElementsByTagName('audio')[0]
    console.log audio
    audioSrc = ctx.createMediaElementSource(audio)
    analyser = ctx.createAnalyser()
    console.log('render the fram',audioSrc)
    $window.renderFrame = ->
      requestAnimationFrame renderFrame
      frequencyData = new Uint8Array(analyser.frequencyBinCount)
      # update data in frequencyData
      analyser.getByteFrequencyData frequencyData
      # render frame based on values in frequencyData
      for d in frequencyData
        if d!=0
          console.log(frequencyData)
      return

    audioSrc.connect analyser
    analyser.connect ctx.destination
    console.log(audioSrc)
    console.log(analyser)
    $window.renderFrame()

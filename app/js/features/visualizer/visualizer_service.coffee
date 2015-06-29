###
A simple example service that returns some data.
###
angular.module("songaday")

.factory "AudioVisualizerService",($window,AudioContextService) ->

  # Might use a resource here that returns a JSON array
  context=AudioContextService.getContext()
  analyser=context.createAnalyser()
  $window.analyser=analyser
  getAnalyser : ()->
    analyser

  $destroy:()->
    canvas=document.getElementById('visualizer')
    WIDTH=canvas.clientWidth
    HEIGHT=canvas.clientHeight
    canvasCtx = canvas.getContext('2d')
    canvasCtx.clearRect 0, 0, WIDTH, HEIGHT
    window.cancelAnimationFrame($window.drawVisual)
  initialize: ()->
    canvas=document.getElementById('visualizer')
    WIDTH=canvas.clientWidth
    HEIGHT=canvas.clientHeight
    canvasCtx = canvas.getContext('2d')
    $window.drawVisualizer = ->
      $window.drawVisual = requestAnimationFrame(window.drawVisualizer)
      bufferLength = $window.analyser.frequencyBinCount

      timeBuffer = new Uint8Array(bufferLength)
      $window.analyser.getByteTimeDomainData timeBuffer
      canvasCtx.fillStyle = 'rgba(200, 200, 200,0)'
      canvasCtx.clearRect 0, 0, WIDTH, HEIGHT
      canvasCtx.lineWidth = 1
      canvasCtx.strokeStyle = 'rgb(0, 0, 0)'
      canvasCtx.beginPath()
      sliceWidth = WIDTH * 1.0 / bufferLength
      x = 0
      i = 0
      while i < bufferLength
        v = timeBuffer[i] / 128.0
        y = v * HEIGHT / 2
        if i == 0
          canvasCtx.moveTo x, y
        else
          canvasCtx.lineTo x, y
        x += sliceWidth
        i++
      canvasCtx.lineTo canvas.width, canvas.height / 2
      canvasCtx.stroke()
      return
    $window.drawVisualizer()
window.requestAnimFrame = do ->
  window.requestAnimationFrame or window.webkitRequestAnimationFrame or
   window.mozRequestAnimationFrame or (callback) ->
    window.setTimeout callback, 1000 / 60
    return

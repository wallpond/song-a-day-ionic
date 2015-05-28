angular.module("songaday")

# A simple controller that shows a tapped item's data
.controller "RecordCtrl", ($rootScope,$scope,$window, $stateParams,TransmitService, RecordService) ->
  rec_ctrl = this
  audio_context={}

  recorder = {}
  $scope.recording = false
  $rootScope.recording_file_uri=false
  $scope.upload = ()->
  $rootScope.onCompleteEncode = (e)->
    __log 'encoded.'
    mp3Blob = new Blob([ new Uint8Array(e.data.buf) ], type: 'audio/mp3')
    $scope.readyToTransmit = true
    TransmitService.uploadBlob(mp3Blob)
    $scope.$apply()

  fetchFile = (fs)->
    console.log(fs)
  captureSuccess = (mediaFiles) ->
    $window.file=mediaFiles[0]
    file_protocol= "file://"
    #if $ionic.isAndroid()
    #  file_protocol= "content://"
    $window.resolveLocalFileSystemURI file_protocol + file.fullPath, (obj) ->
      window.file_obj = obj
      __log obj
      $scope.file=obj
  captureError = (error) ->
    navigator.notification.alert 'Error: ' + error.code, null, 'Capture Error'
    __log error
    return


  __log = (msg) ->
    console.log(msg)
    $scope.message = (msg)
  $scope.startNativeRecording = () ->
    # start audio capture
    navigator.device.capture.captureAudio captureSuccess, captureError, limit: 1

  $scope.tryHTML5Recording = () ->
    __log 'init html5 recording'
    window.AudioContext = window.AudioContext or window.webkitAudioContext
    navigator.getUserMedia = navigator.getUserMedia or
      navigator.webkitGetUserMedia or
      navigator.mozGetUserMedia or
      navigator.msGetUserMedia
    window.URL = window.URL or window.webkitURL
    audio_context = new AudioContext
    __log 'Audio context...'
    __log if navigator.getUserMedia then 'ready.' else ':( sad browser!'
    navigator.getUserMedia { audio: true }, startUserMedia, (e) ->
      __log 'No live audio input: ' + e
      return
  startUserMedia = (stream) ->
    input = audio_context.createMediaStreamSource(stream)
    __log 'Media stream created.'
    __log 'input sample rate ' + input.context.sampleRate
    recorder = new RecordService.Recorder(input)
    __log recorder
    __log 'Recorder initialised.'
    return

  export_wav = ()->
    recorder && recorder.exportWAV (blob)->
      fileReader = new FileReader
      fileReader.onload = ->
        arrayBuffer = @result
        buffer = new Uint8Array(arrayBuffer)
        binary = ''
        bytes = new Uint8Array(buffer)
        len = bytes.byteLength
        i = 0
        while i < len
          binary += String.fromCharCode(bytes[i])
          i++
        data = window.btoa binary
        $rootScope.wav_file_uri = 'data:audio/wav;base64,' + data
        $scope.$apply()
      fileReader.readAsArrayBuffer blob
      recorder.clear()


  $scope.startRecording = (button) ->
    recorder and recorder.record()
    $scope.recording = yes
    __log 'Recording...'
    return

  $scope.stopRecording = (button) ->
    $scope.recording = no
    recorder and recorder.stop()
    __log 'Stopped recording.'
    # create WAV download link using audio data blob
    export_wav()
    __log 'encoding media...'
    return



  if _(ionic.Platform.platforms).contains('browser')
    $scope.tryHTML5Recording()
  else
    $scope.startNativeRecording()

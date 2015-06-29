angular.module("songaday")

# A simple controller that shows a tapped item's data
.controller "RecordCtrl", ($rootScope,$scope,$state,SongService,
$window, AccountService, $stateParams,TransmitService,AudioContextService
 RecordService,MultiTrackService,AudioVisualizerService) ->
  rec_ctrl = this
  audio_context={}
  $scope.transmission={}
  $rootScope.file_type="audio/mp3"
  $rootScope.file_ext="mp3"
  $scope.transmitting=false
  try
    $rootScope.stop()
  recorder = {}
  $rootScope.recording = false

  $rootScope.recording_file_uri=false
  TransmitService.lastTransmission (song)->
    console.log(song,'ssss')
    latest_date=new Date(song.timestamp)
    today=new Date()
    if today.getDay() == latest_date.getDay()
      $scope.song=song
      $scope.transmitted = yes
  $scope.transmit = () ->
    __log('Uploading Compressed Audio')
    AccountService.refresh (myself) ->
      TransmitService.uploadBlob $rootScope.file_blob,$rootScope.file_ext, (file_uri) ->
        __log 'Audio uploaded'
        song = {}
        file_type=$rootScope.file_type
        song['media'] = {'src':file_uri,type:file_type}
        song['info'] = $scope.transmission.info or '~'
        song['title'] = $scope.transmission.title or 'untitled'
        song['user_id'] = myself.user_id
        song['timestamp'] = (new Date()).toISOString()
        song['$priority'] = -1 * Date.parse(song.timestamp)
        song['artist'] =
          'alias': myself.alias or ''
          'key': myself.$id
          'avatar': myself.avatar or ''
        TransmitService.transmit song, (new_id) ->
          __log 'complete'
          sng=SongService.get(new_id)
          sng.$loaded ()->
            $scope.song=sng

          $scope.latestTransmission = song
          $scope.transmitted = yes
          $scope.transmitting= no




  $rootScope.onCompleteEncode = (e)->
    if $rootScope.recording
      return

    __log 'encoded.'
    $rootScope.file_blob = new Blob([ new Uint8Array(e.data.buf) ], type: 'audio/mp3')
    $scope.readyToTransmit = true
    $rootScope.file_blob.name=$scope.title+'.mp3'

    $scope.$apply()


  reset=()->
    $scope.transmitted=false
    $scope.readyToTransmit=false
    $scope.song=false
    $rootScope.file_blob=null
    $rootScope.wav_file_uri=null
    __log 'reset'
    if not _(ionic.Platform.platforms).contains('browser')
      $scope.startNativeRecording()


  $scope.revoke= ()->
    if $scope.song
      AccountService.remove_song $scope.song ,()->
        reset()

  fetchFile = (fs)->
    console.log(fs)
  captureSuccess = (mediaFiles) ->
    $window.file=mediaFiles[0]
    file_protocol = "file://"
    $window.resolveLocalFileSystemURI file_protocol + file.fullPath, (obj) ->
      $rootScope.native = true
      file_URI=obj.nativeURL
      console.log(obj,'file object')

      obj.file (file_obj) ->
        console.log(obj,'file')
        $rootScope.wav_file_uri=file_URI
        $rootScope.file_blob =file_obj
        console.log(file_obj)
        $rootScope.file_type = "audio/m4a"
        $rootScope.readyToTransmit = true
        $scope.$apply()




  captureError = (error) ->
    navigator.notification.alert 'Error: ' + error.code, null, 'Capture Error'
    __log error
    return


  __log = (msg) ->
    $scope.message = (msg)
  $scope.startNativeRecording = () ->
    # start audio capture
    navigator.device.capture.captureAudio captureSuccess, captureError, limit: 1

  $scope.tryHTML5Recording = () ->
    __log 'init html5 recording'
    navigator.getUserMedia = navigator.getUserMedia ||
      navigator.webkitGetUserMedia
    window.URL = window.URL or window.webkitURL
    audio_context = AudioContextService.getContext()
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
    AudioVisualizerService.initialize()

    recorder and recorder.record()
    $rootScope.recording = yes
    __log 'Recording...'
    $scope.readyToTransmit = no
    return

  $scope.stopRecording = (button) ->
    AudioVisualizerService.$destroy()

    $rootScope.recording = no
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
    $rootScope.file_blob=undefined
    $rootScope.wav_file_uri=undefined
    $rootScope.file_ext="m4a"

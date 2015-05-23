angular.module("songaday")

# A simple controller that shows a tapped item's data
.controller "RecordCtrl", ($scope,$window, $stateParams, RecordService) ->
  fetchFile = (fs)->
    console.log(fs)
  captureSuccess = (mediaFiles) ->
    $window.file=mediaFiles[0]
    file_protocol= "file://"
    #if $ionic.isAndroid()
    #  file_protocol= "content://"
    $window.resolveLocalFileSystemURI file_protocol + file.fullPath, (obj) ->
      $scope.file=obj
  captureError = (error) ->
    navigator.notification.alert 'Error: ' + error.code, null, 'Capture Error'
    console.log(error)
    return



  $scope.startRecording = ->
    # start audio capture
    navigator.device.capture.captureAudio captureSuccess, captureError, limit: 1
  $scope.startRecording()

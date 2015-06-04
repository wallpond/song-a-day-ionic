angular.module("songaday")

# A simple controller that shows a tapped item's data
.controller "TransmitCtrl", ($scope,TransmitService,$state,$timeout,AccountService) ->
  $scope.awsParamsURI = TransmitService.awsParamsURI()
  $scope.awsFolder = TransmitService.awsFolder()
  $scope.s3Bucket = TransmitService.s3Bucket()
  $scope.transmission = {media:{}}
  TransmitService.lastTransmission (last_song)->
    AccountService.refresh (myself)->
      $scope.lastTransmission = last_song
  $scope.$on 's3upload:success', (e) ->
    $scope.ready=true
    $timeout (()->
      $scope.transmission.media.src = e.targetScope['filename']
      $scope.transmission.media.type = e.targetScope['filetype']),100
    return
  $scope.transmit= (song)->
    AccountService.refresh (myself)->
      song = {}
      song['info'] = $scope.transmission.info or ''
      song['title'] = $scope.transmission.title or '~untitled'
      song['media'] = $scope.transmission.media
      song['user_id'] = myself.user_id
      song['timestamp'] = (new Date()).toISOString()
      song['$priority'] = -1 * Math.floor(new Date().getTime()/1000)
      song['artist'] =
        'alias': myself.alias or ''
        'key': myself.$id
        'avatar': myself.avatar or ''
      TransmitService.transmit song,(new_id)->
        myself.songs[new_id]=true
        myself.$save()
        $state.go 'app.song-index'

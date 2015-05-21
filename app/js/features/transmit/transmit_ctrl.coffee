angular.module("songaday")

# A simple controller that shows a tapped item's data
.controller "TransmitCtrl", ($scope,TransmitService,$timeout,AccountService) ->
  $scope.awsParamsURI = TransmitService.awsParamsURI()
  $scope.awsFolder = TransmitService.awsFolder()
  $scope.s3Bucket = TransmitService.s3Bucket()
  $scope.transmission = {media:{}}
  AccountService.refresh (myself)->
    TransmitService.lastTransmission myself,(last_song)->
      $scope.lastTransmission = last_song
      console.log(last_song)
  $scope.$on 's3upload:success', (e) ->
    $scope.ready=true
    console.log($scope.media)
    $timeout (()->

      console.log(e)
      $scope.transmission.media.src = e.targetScope['filename']

      $scope.transmission.media.type = e.targetScope['filetype']),100

    return
  $scope.transmit= (song)->
    AccountService.refresh (myself)->
      song = {}
      song['info'] = $scope.transmission.info or ''
      song['title'] = $scope.transmission.title or 'untitled'
      song['timestamp'] = (new Date).toISOString()
      song['media'] = $scope.transmission.media
      song['user_id'] = myself.user_id
      song['artist'] =
        'alias': myself.alias or ''
        'key': myself.$id
        'avatar': myself.avatar or ''
      console.log(song,myself)
      TransmitService.transmit song,(new_id)->
        myself.songs[new_id]=true
        myself.$save()

angular.module("songaday")

# A simple controller that shows a tapped item's data
.controller "TransmitCtrl", ($scope,
  SongService,TransmitService,$state,$timeout,AccountService) ->
  $scope.awsParamsURI = TransmitService.awsParamsURI()
  $scope.awsFolder = TransmitService.awsFolder()
  $scope.s3Bucket = TransmitService.s3Bucket()
  $scope.transmission = {media:{}}

  reset = ()->
    $scope.transmitted=false
    $scope.ready=false
    $scope.song=false

  $scope.revoke= ()->
    if $scope.song
      AccountService.remove_song $scope.song ,()->
        reset()

  reset()
  TransmitService.lastTransmission (song)->
    latest_date=new Date(song.timestamp)
    today=new Date()
    if today.getDay() == latest_date.getDay()
      $scope.song=song
      $scope.transmitted = yes

  $scope.$on 's3upload:success', (e) ->
    $scope.ready=true
    $timeout (()->
      $scope.transmission.media.src = e.targetScope['filename']
      $scope.transmission.media.type = e.targetScope['filetype']),100
    return
  $scope.transmit= (song)->
    $scope.transmitting=true
    AccountService.refresh (myself)->
      song = {}
      song['info'] = $scope.transmission.info or ''
      song['title'] = $scope.transmission.title or '~untitled'
      song['media'] = $scope.transmission.media
      song['user_id'] = myself.user_id
      song['timestamp'] = (new Date()).toISOString()
      song['$priority'] = -1 * Date.parse(song.timestamp)
      song['artist'] =
        'alias': myself.alias or ''
        'key': myself.$id
        'avatar': myself.avatar or ''
      console.log song
      TransmitService.transmit song, (new_id) ->
        $scope.transmitted=yes
        sng=SongService.get(new_id)
        sng.$loaded ()->
          $scope.song=sng

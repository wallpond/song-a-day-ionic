angular.module("songaday")

# A simple controller that shows a tapped item's data
.controller "AccountCtrl", ($scope, $stateParams,AccountService,SongService, TransmitService) ->
  console.log 'ACCOUNT'
  $scope.awsParamsURI = TransmitService.awsParamsURI()
  $scope.awsFolder = TransmitService.awsFolder()
  $scope.s3Bucket = TransmitService.s3Bucket()

  AccountService.refresh (myself)->
    $scope.me=myself
    myself.$bindTo($scope,'me')
    $scope.songs=SongService.getList $scope.me.songs
  $scope.propogate = ->
    for song in $scope.songs
      song.artist.alias = $scope.me.alias
      song.artist.avatar = $scope.me.avatar
      song.$save()

angular.module("songaday")

# A simple controller that shows a tapped item's data
.controller "SongDetailCtrl", ($scope, $stateParams,
  SongService,$ionicLoading) ->
  $ionicLoading.show template: 'Loading...'
  $scope.song = SongService.get($stateParams.songId)
  $scope.song.$loaded ()->
    $ionicLoading.hide()

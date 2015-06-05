angular.module("songaday")

# A simple controller that shows a tapped item's data
.controller "PlaylistDetailCtrl", ($rootScope,$scope, $stateParams,SongService, PlaylistService) ->
  $scope.loading=true
  $scope.playlist = PlaylistService.get($stateParams.playlistId)
  $scope.playlist.$loaded ()->
    $scope.loading = false
    $scope.songs=SongService.getList($scope.playlist.songs)
  $scope.playAll=()->
    for song in $scope.songs
      $rootScope.queue(song)

angular.module("songaday")

# A simple controller that shows a tapped item's data
.controller "ArtistDetailCtrl", ($scope, $stateParams,SongService, ArtistService) ->
  $scope.artist = ArtistService.get($stateParams.artistId)
  $scope.loading=true
  $scope.artist.$loaded ()->
    $scope.songs = SongService.getList($scope.artist.songs)
    console.log $scope.songs[0]
    $scope.songs[0].$loaded ()->
      console.log ($scope.songs[0])
    $scope.loading=false

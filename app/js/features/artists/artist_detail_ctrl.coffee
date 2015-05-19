angular.module("songaday")

# A simple controller that shows a tapped item's data
.controller "ArtistDetailCtrl", ($scope, $stateParams,SongService, ArtistService) ->
  $scope.artist = ArtistService.get($stateParams.artistId)
  $scope.loading=true
  $scope.artist.$loaded ()->
    $scope.loading=false
    $scope.songs = SongService.getList($scope.artist.songs)

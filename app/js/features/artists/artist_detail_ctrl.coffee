angular.module("songaday")

# A simple controller that shows a tapped item's data
.controller "ArtistDetailCtrl", ($scope, $stateParams,SongService, ArtistService) ->
  $scope.artist = ArtistService.get($stateParams.artistId)
  $scope.artist.$loaded ()->
    $scope.songs = SongService.getList($scope.artist.songs)

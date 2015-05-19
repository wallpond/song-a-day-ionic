angular.module("songaday")

# A simple controller that fetches a list of data from a service
.controller "ArtistIndexCtrl", ($scope,$state, ArtistService) ->
  $scope.artists = ArtistService.all()
  $scope.loading=true
  $scope.artists.$loaded(()->
    $scope.loading=false
  )
  $scope.navigate = (artist) ->
    $state.go 'app.artist-detail', artistId: artist.$id

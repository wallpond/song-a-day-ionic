angular.module("songaday")

# A simple controller that fetches a list of data from a service
.controller "ArtistIndexCtrl", ($scope,$state, ArtistService) ->
  $scope.artists = ArtistService.some()
  $scope.loading=true
  $scope.artists.$loaded(()->
    $scope.loading=false
  )

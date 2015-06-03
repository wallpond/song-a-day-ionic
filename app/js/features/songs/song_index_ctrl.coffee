angular.module("songaday")

# A simple controller that fetches a list of data from a service
.controller "SongIndexCtrl", ($state,$scope, SongService) ->
  $scope.songs = SongService.some()
  $scope.loading=true
  $scope.songs.$loaded(()->
    $scope.loading=false
  )
  $scope.loadMore = ()->
    console.log('loading more')
    $scope.loading=true
    SongService.more ()->
      $scope.loading=false

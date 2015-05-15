angular.module("songaday")

# A simple controller that fetches a list of data from a service
.controller "SongIndexCtrl", (,$state,$scope, SongService) ->
  $scope.songs = SongService.all()
  $scope.listen = (song) ->
    $state.go 'app.song-detail', songId: song.$id

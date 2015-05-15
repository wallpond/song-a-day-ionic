angular.module("songaday")

# A simple controller that shows a tapped item's data
.controller "SongDetailCtrl", ($scope, $stateParams, SongService) ->
  $scope.song = SongService.get($stateParams.songId)

angular.module("songaday")

# A simple controller that shows a tapped item's data
.controller "PlayerCtrl", ($scope, $stateParams, SongService) ->
  $scope.next ()->
    console.log("next")
  $scope.previous ()->
    console.log("prev")
  $scope.stop ()->
    console.log("stop")
  $scope.pause ()->
    console.log("pause")
  $scope.play ()->
    console.log("play")

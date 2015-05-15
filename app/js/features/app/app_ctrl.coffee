angular.module("songaday")

# A simple controller that shows a tapped item's data
.controller "AppCtrl", ($rootScope,$scope, $stateParams,PlayerService) ->
  $rootScope.playlist = PlayerService.getPlaylist()

  $rootScope.listen= (song)->
    console.log('listen')
    $rootScope.player.sources.add(song.media.src)
  $rootScope.next= ()->
    console.log("next")
  $rootScope.previous= ()->
    console.log("prev")
  $rootScope.stop= ()->
    console.log(PlayerService.playlist)
    console.log("stop")
  $rootScope.pause= ()->
    console.log("pause")
  $rootScope.play= ()->
    console.log("play")

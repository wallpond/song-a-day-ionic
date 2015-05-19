angular.module("songaday")

# A simple controller that shows a tapped item's data
.controller "AppCtrl", ($sce,$rootScope,$scope, $stateParams,$timeout) ->
  ctrl=this
  ctrl.state = null
  ctrl.API = null
  ctrl.currentSong= 0
  ctrl.currentMediaType="audio"
  $rootScope.queue = (song)->
    if _(ctrl.playlist).includes(song)
      ctrl.setNowPlaying _.indexOf(ctrl.playlist,song)
      return
    ctrl.playlist.push(song)
    if (ctrl.playlist.length==1)
      ctrl.setNowPlaying 0

  ctrl.onPlayerReady = (API) ->
    ctrl.API = API
    console.log(API)
    return

  ctrl.onCompleteVideo = ->
    ctrl.isCompleted = true
    ctrl.currentSong++
    if ctrl.currentSong >= ctrl.playlist.length
      ctrl.currentSong = 0
    ctrl.setNowPlaying ctrl.currentSong
    return

  ctrl.playlist = []
  ctrl.config =
    preload: 'none'
    sources:[]
  ctrl.setNowPlaying = (index) ->
    ctrl.API.stop()
    ctrl.currentSong = index
    m = ctrl.playlist[index].media
    ctrl.config.sources = [{src:$sce.trustAsResourceUrl(m.src),type:m.type}]
    $timeout (()->
      ctrl.API.play() ),200
    return

  return

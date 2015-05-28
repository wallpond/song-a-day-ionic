angular.module("songaday")

# A simple controller that shows a tapped item's data
.controller "AppCtrl", ($sce,SongService,AccountService,$state,$rootScope,$scope, $stateParams,$timeout) ->
  ctrl = this
  ctrl.state = null
  ctrl.API = null
  ctrl.currentSong= 0
  ctrl.currentMediaType="audio"
  ctrl.playlist = []
  $timeout (()->
    ionic.trigger('resize')),100

  $rootScope.comment= (song,comment_text)->
    AccountService.refresh (myself) ->
      console.log(myself)
      comment={comment:comment_text,author:{alias:myself.alias,avatar:myself.avatar,key:myself.$id}}
      console.log(comment)
      SongService.comment(song,comment)
  $rootScope.login = ()->
    console.log('login')
    AccountService.login()
  $rootScope.showArtist = (artist) ->
    if typeof artist == 'string'
      $state.go 'app.artist-detail', artistId: artist
      return
    $state.go 'app.artist-detail', artistId: artist.$id
  $scope.showSong = (song) ->
    $state.go 'app.song-detail', songId: song.$id
  $scope.showNowPlaying = () ->
    $state.go 'app.song-detail', songId: ctrl.nowPlaying().$id
    

  ctrl.nowPlaying = ()->
    if ctrl.currentSong < ctrl.playlist.length
      return ctrl.playlist[ctrl.currentSong]
    else
      return {artist:{"alias":"","avatar":""},$id:""}
  ctrl.next= ()->
    ctrl.currentSong++
    if ctrl.currentSong >= ctrl.playlist.length
      ctrl.currentSong = 0
    ctrl.setNowPlaying ctrl.currentSong
  ctrl.previous= ()->
    ctrl.currentSong--
    if ctrl.currentSong < 0
      ctrl.currentSong = ctrl.playlist.length
    ctrl.setNowPlaying ctrl.currentSong


  $rootScope.play = (song)->
    if !_(ctrl.playlist).includes(song)
      ctrl.playlist.push(song)
    else
      ctrl.setNowPlaying _.indexOf(ctrl.playlist,song)

  $rootScope.queue = (song)->
    if _(ctrl.playlist).includes(song)
      ctrl.setNowPlaying _.indexOf(ctrl.playlist,song)
      return
    ctrl.playlist.push(song)
    if (ctrl.playlist.length==1)
      ctrl.setNowPlaying 0

  ctrl.onPlayerReady = (API) ->
    ctrl.API = API
    return

  ctrl.onCompleteVideo = ->
    ctrl.isCompleted = true
    console.log('COMPLETED')
    ctrl.next()
    return

  ctrl.config =
    preload: 'none'
    sources:[{media:"/audio/startup.mp3",type:"audio/mp3"}]


  ctrl.setNowPlaying = (index) ->
    ctrl.API.stop()
    ctrl.currentSong = index
    m = ctrl.playlist[index].media
    ctrl.config.sources = [{src:$sce.trustAsResourceUrl(m.src),type:m.type}]
    console.log(ctrl.API)
    $timeout (()->
      ctrl.API.play()
      if _(m.type).contains('video')
        if !ctrl.API.isFullScreen
          ctrl.API.toggleFullScreen()
      ),200
    return

  return

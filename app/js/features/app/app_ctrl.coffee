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
      comment_text=""
  $rootScope.showNotification = (notice)->
    $state.go 'app.song-detail',songId:notice.link
    $rootScope.notifications.$remove(notice)

  $rootScope.login = ()->
    console.log('login')
    AccountService.login()
  $rootScope.logout = ()->
    console.log('login')
    AccountService.logout()
  $rootScope.showArtist = (artist) ->
    if typeof artist == 'string'
      $state.go 'app.artist-detail', artistId: artist
      return
    $state.go 'app.artist-detail', artistId: artist.$id
  $rootScope.showSong = (song) ->
    $state.go 'app.song-detail', songId: song.$id
  $rootScope.showPlaylist = (playlist) ->
    $state.go 'app.playlist-detail', playlistId: playlist.$id
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
      ctrl.setNowPlaying _.indexOf(ctrl.playlist,song)
    else
      ctrl.setNowPlaying _.indexOf(ctrl.playlist,song)
  $rootScope.stop = ->
    ctrl.API.stop()
  $rootScope.currentQueue = ()->
    return ctrl.playlist
  $rootScope.clearQueue = ()->
    ctrl.API.stop()
    ctrl.playlist = []
  $rootScope.enQueue = (song)->
    if _(ctrl.playlist).includes(song)
      return
    ctrl.playlist.push(song)
    if (ctrl.playlist.length==1)
      ctrl.setNowPlaying 0
  $rootScope.queue = (song)->
    if _(ctrl.playlist).includes(song)
      ctrl.setNowPlaying _.indexOf(ctrl.playlist,song)
      return
    ctrl.playlist.push(song)
    if (ctrl.playlist.length==1)
      ctrl.setNowPlaying 0

  ctrl.onPlayerReady = (API) ->
    console.log(API)
    ctrl.API = API
    return

  ctrl.config =
    preload: 'none'
    sources:[{media:"/audio/startup.mp3",type:"audio/mp3"}]


  ctrl.setNowPlaying = (index) ->
    console.log(ctrl.API)
    ctrl.API.stop()
    ctrl.currentSong = index
    m = ctrl.playlist[index].media
    ctrl.config.sources = [{src:$sce.trustAsResourceUrl(m.src),type:m.type}]
    $timeout (()->
      ctrl.API.play()
      if _(m.type).contains('video')
        if !ctrl.API.isFullScreen
          ctrl.API.toggleFullScreen()
      ),200
    return

  return

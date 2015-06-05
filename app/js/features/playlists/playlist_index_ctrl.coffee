angular.module("songaday")

# A simple controller that fetches a list of data from a service
.controller "PlaylistIndexCtrl", ($state,$rootScope,$ionicModal,$scope, PlaylistService,SongService) ->
  $scope.playlists = PlaylistService.some()
  $scope.loading=true
  $scope.playlists.$loaded(()->
    $scope.loading=false
    console.log($scope.playlists)
  )
  $ionicModal.fromTemplateUrl('templates/playlist-new-modal.html', {
  scope: $scope,
  animation: 'slide-in-up'
  }).then (modal) ->
    $scope.modal = modal

  $scope.loadMore = ()->
    $scope.loading=true
    SongService.more ()->
      $scope.loading=false
  $scope.playlist
  $scope.savePlaylist = (newTitle) ->
    $scope.modal.hide()
    playlist={title:newTitle}
    playlist['timestamp'] = (new Date()).toISOString()
    playlist.songs = {}
    playlist.count = 0
    for song in $rootScope.currentQueue()
      playlist.songs[song.$id]=true
      playlist.count += 1
    PlaylistService.new(playlist)

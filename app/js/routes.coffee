angular.module("songaday")

.config ($stateProvider, $urlRouterProvider) ->

  # Ionic uses AngularUI Router which uses the concept of states
  # Learn more here: https://github.com/angular-ui/ui-router
  # Set up the various states which the app can be in.

  # the song tab has its own child nav-view and history
  $stateProvider

  .state "app",
    url: "/app"
    abstract: true
    templateUrl: "templates/menu.html"

  .state "app.songs",
    url: "/songs"
    views:
      "main-content":
        templateUrl: "templates/song-index.html"
        controller: "SongIndexCtrl"

  .state "app.song-detail",
    url: "/song/:songId"
    views:
      "main-content":
        templateUrl: "templates/song-detail.html"
        controller: "SongDetailCtrl"

  .state "app.artists",
    url: "/songwriters"
    views:
      "main-content":
        templateUrl: "templates/artist-index.html"
        controller: "ArtistIndexCtrl"

  .state "app.artist-detail",
    url: "/songwriter/:artistId"
    views:
      "main-content":
        templateUrl: "templates/artist-detail.html"
        controller: "ArtistDetailCtrl"


  .state "app.account",
    url: "/account"
    views:
      "main-content":
        templateUrl: "templates/account.html"
        controller: "AccountCtrl"

  .state "app.transmit",
    url: "/transmit"
    views:
      "main-content":
        templateUrl: "templates/transmit.html"
        controller: "TransmitCtrl"

  .state "app.now-playing",
    url: "/playing"
    views:
      "main-content":
        templateUrl: "templates/now-playing.html"
        controller: "PlayerCtrl"
  .state "app.record",
    url: "/record"
    views:
      "main-content":
        templateUrl: "templates/record.html"
        controller: "RecordCtrl"

  .state "app.mission",
    url: "/mission"
    views:
      "main-content":
        templateUrl: "templates/mission.html"
  .state "app.notifications",
    url: "/notifications"
    views:
      "main-content":
        templateUrl: "templates/notifications.html"
  .state "app.playlists",
    url: "/playlists"
    views:
      "main-content":
        templateUrl: "templates/playlist-index.html"
        controller: "PlaylistIndexCtrl"
  .state "app.playlist-detail",
    url: "/playlist/:playlistId"
    views:
      "main-content":
        templateUrl: "templates/playlist-detail.html"
        controller: "PlaylistDetailCtrl"

  $urlRouterProvider.otherwise "/app/songs"


  # if none of the above states are matched, use this as the fallback

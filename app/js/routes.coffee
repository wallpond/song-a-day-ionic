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

  .state "apps.mission",
    url: "/mission"
    views:
      "main-content":
        templateUrl: "templates/mission.html"
  $urlRouterProvider.otherwise "/app/songs"


  # if none of the above states are matched, use this as the fallback

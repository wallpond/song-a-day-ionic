# Initialize angular's app.

app = angular.module(GLOBALS.ANGULAR_APP_NAME, [
  "#{GLOBALS.ANGULAR_APP_NAME}.templates"
  "ionic"
  "angulartics.google.analytics"
  "angulartics.google.analytics.cordova"
  "firebase"
  "ngVideo"
])

.constant('FBURL', 'https://song-a-day.firebaseio.com/')

.filter('trust', ($sce) ->
  (url) ->
    $sce.trustAsResourceUrl url
).filter('reverse', ->
  (items) ->
    items.slice().reverse()
).filter('length', ->
  (item) ->
    Object.keys(item or {}).length
).filter 'startsWith', ->
  (array, search) ->
    matches = []
    i = 0
    while i < array.length
      if array[i].indexOf(search) == 0 and search.length < array[i].length
        matches.push array[i]
      i++
    matches

# Initialize angular's app.

app = angular.module(GLOBALS.ANGULAR_APP_NAME, [
  "#{GLOBALS.ANGULAR_APP_NAME}.templates"
  "ionic"
  "angulartics.google.analytics"
  "angulartics.google.analytics.cordova"
  "firebase"
  "angularMoment"
  "ngS3upload"
  "com.2fdevs.videogular"
  "com.2fdevs.videogular.plugins.buffering",
  "angular-scroll-complete"
])

.constant('FBURL', 'https://song-a-day.firebaseio.com/')

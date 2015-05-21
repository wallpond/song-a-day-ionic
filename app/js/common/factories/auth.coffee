###
A simple example service that returns some data.
###
angular.module("songaday")

.factory "Auth",($firebaseAuth,FBURL) ->
  return $firebaseAuth(new Firebase(FBURL))

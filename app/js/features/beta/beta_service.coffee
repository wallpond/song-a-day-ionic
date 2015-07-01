###
A simple example service that returns some data.
###
angular.module("songaday")

.factory "BetaService", ($firebaseArray,Auth,FBURL) ->
  ref = new Firebase(FBURL+'beta')
  addMe:()->
    console.log('MASD')
    Auth.$waitForAuth().then (authObject) ->
      if typeof authObject.google.email != 'undefined'
        betas = $firebaseArray(ref)
        console.log('MASD')
        betas.$add(authObject.google.email)
        betas.$save()
        alert('Check your' + authObject.google.email + ' email tommorow ;)')

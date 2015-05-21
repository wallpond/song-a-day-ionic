###
A simple example service that returns some data.
###
angular.module("songaday")

.factory "TransmitService",($firebaseObject,$firebaseArray,FBURL) ->

  # Might use a resource here that returns a JSON array
  ref = new Firebase(FBURL)

  cloudFrontURI:() ->
    'd1hmps6uc7xmb3.cloudfront.net'
  awsParamsURI: () ->
    '/config/aws.json'
  awsFolder: () ->
    'songs/'
  s3Bucket:()->
    'songadays'
  transmit:(t) ->
    console.log(t)

###
A simple example service that returns some data.
###
angular.module("songaday")

.factory "TransmitService",($firebaseObject,
    $firebaseArray,FBURL,S3Uploader, ngS3Config) ->

  # Might use a resource here that returns a JSON array
  ref = new Firebase(FBURL+'/songs')

  cloudFrontURI:() ->
    'd1hmps6uc7xmb3.cloudfront.net'
  awsParamsURI: () ->
    '/config/aws.json'
  awsFolder: () ->
    'songs/'
  s3Bucket:()->
    'songadays'
  transmit:(song,callback) ->
    ref.push song,(complete)->
      my_songs = new Firebase(FBURL+'/artists/'+artist.$id+'/songs')
      my_songs.child(song.$id).set(true)
      callback(song.$id)
  lastTransmission:(artist,callback) ->
    console.log(artist)
    ref = new Firebase(FBURL+'/artists/'+artist.$id+'/songs')
    last_transmission=$firebaseObject(ref)
    last_transmission.$loaded (err) ->
      callback(last_transmission)
  uploadBlob:(blob)->
    s3Uri = 'https://' + @s3Bucket() + '.s3.amazonaws.com/'

    S3Uploader.getUploadOptions(@awsParamsURI()).then (s3Options) ->
      key = s3Options.folder + (new Date()).getTime() + '-' +
        S3Uploader.randomString(16) + ".mp3"
      opts = angular.extend({
        submitOnChange: true
        getOptionsUri: '/getS3Options'
        getManualOptions: null
        acl: 'private'
        uploadingKey: 'uploading'
        folder: 'songs/'
        enableValidation: true
        targetFilename: null
      }, opts)
      S3Uploader.upload(@, s3Uri,
        key, opts.acl, blob.type,
        s3Options.key, s3Options.policy,
        s3Options.signature, blob ).then (->
        file_URL= s3Uri + key
        scope.filename = ngModel.$viewValue
        console.log file_URL
        if opts.enableValidation
          ngModel.$setValidity 'uploading', true
          ngModel.$setValidity 'succeeded', true
        return
      ), ->
        scope.filename = ngModel.$viewValue
        if opts.enableValidation
          ngModel.$setValidity 'uploading', true
          ngModel.$setValidity 'succeeded', false
        return

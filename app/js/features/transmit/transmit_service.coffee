###
A simple example service that returns some data.
###
angular.module("songaday")

.factory "TransmitService",($rootScope,$firebaseObject,
    $firebaseArray,FBURL,S3Uploader, ngS3Config,SongService,AccountService) ->

  # Might use a resource here that returns a JSON array
  ref = new Firebase(FBURL+'songs').limit(4)
  cloudFrontURI:() ->
    'd1hmps6uc7xmb3.cloudfront.net'
  awsParamsURI: () ->
    '/config/aws.json'
  awsFolder: () ->
    'songs/'
  s3Bucket:()->
    'songadays'
  transmit:(song,callback) ->
    songs = SongService.some()
    songs.$loaded ()->
      songs.$add(song).then (new_ref) ->
        console.log(new_ref)
        callback(new_ref.key())
    return
  lastTransmission:(callback) ->
    AccountService.refresh (myself) ->
      ref = new Firebase (FBURL+'/artists/'+myself.$id + '/songs')
      SongServervice.getList(myself.songs)

      last_transmission=$firebaseObject(ref)
      last_transmission.$loaded (err) ->
        if callback
          callback last_transmission
  uploadBlob:(blob,callback)->
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
      S3Uploader.upload($rootScope, s3Uri,
        key, opts.acl, blob.type,
        s3Options.key, s3Options.policy,
        s3Options.signature, blob ).then (->
        file_URL= s3Uri + key
        callback(file_URL)
        return
      )

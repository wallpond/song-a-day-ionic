###
A simple example service that returns some data.
###
angular.module("songaday")

.factory "TransmitService",($rootScope,$firebaseObject,
    $firebaseArray,FBURL,S3Uploader, ngS3Config,SongService,AccountService) ->

  # Might use a resource here that returns a JSON array
  ref = new Firebase(FBURL+'songs').limit(4)
  cloudFrontURI:() ->
    'http://media.songadays.com/'
  awsParamsURI: () ->
    '/config/aws.json'
  awsFolder: () ->
    'songs/'
  s3Bucket:()->
    'songadays'
  transmit:(song,callback) ->
    songs = SongService.some()
    songs.$loaded () ->
      AccountService.refresh (me) ->
        songs.$add(song).then (new_ref) ->
          new_id = new_ref.key()
          if (typeof me.songs == 'undefined')
            me.songs = {}
          me.songs[new_id]=true
          me.last_transmission = new_id
          me.$save()
          callback(new_id)

    return
  lastTransmission:(callback) ->
    AccountService.refresh (myself) ->
      ref = new Firebase (FBURL+'/songs/' + myself.last_transmission)
      last_transmission=$firebaseObject(ref)
      last_transmission.$loaded (err) ->
        if callback
          callback last_transmission
  uploadBlob:(blob,file_ext,callback)->
    cloudFront = @cloudFrontURI()
    s3Uri = 'https://' + @s3Bucket() + '.s3.amazonaws.com/'
    awsParams=@awsParamsURI()
    s3Options=
      'policy': 'ewogICJleHBpcmF0aW9uIjogIjIwMjAtMDEtMDFUMDA6MDA6MDBaIiwKICAiY29uZGl0aW9ucyI6IFsKICAgIHsiYnVja2V0IjogInNvbmdhZGF5cyJ9LAogICAgWyJzdGFydHMtd2l0aCIsICIka2V5IiwgIiJdLAogICAgeyJhY2wiOiAicHJpdmF0ZSJ9LAogICAgWyJzdGFydHMtd2l0aCIsICIkQ29udGVudC1UeXBlIiwgIiJdLAogICAgWyJzdGFydHMtd2l0aCIsICIkZmlsZW5hbWUiLCAiIl0sCiAgICBbImNvbnRlbnQtbGVuZ3RoLXJhbmdlIiwgMCwgNTI0Mjg4MDAwXQogIF0KfQ=='
      'signature': 'r+Ci1HbYn4fkyFB0pxwRWx5m0Ss='
      'key': 'AKIAJ7K34ZKXEV72GYRQ'

    key = s3Options.folder + (new Date()).getTime() + '-' +
      S3Uploader.randomString(16) + '.' +file_ext
    opts = angular.extend({
      submitOnChange: true
      getOptionsUri: awsParams
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
      s3Options.signature, blob ).then (obj) ->
        callback(cloudFront+key)
        return

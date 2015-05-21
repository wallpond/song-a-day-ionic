angular.module("songaday")

# A simple controller that shows a tapped item's data
.controller "TransmitCtrl", ($scope,TransmitService,$timeout,AccountService) ->
  $scope.awsParamsURI = TransmitService.awsParamsURI()
  $scope.awsFolder = TransmitService.awsFolder()
  $scope.s3Bucket = TransmitService.s3Bucket()
  $scope.transmission = {media:{}}
  $scope.$on 's3upload:success', (e) ->
    $scope.ready=true
    console.log($scope.media)
    $timeout (()->

      console.log(e)
      $scope.transmission.media.src = e.targetScope['filename']

      $scope.transmission.media.type = e.targetScope['filetype']),100

    return
  $scope.transmit= (song)->

    TransmitService.transmit(song)

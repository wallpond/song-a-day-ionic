angular.module("songaday")

# A simple controller that shows a tapped item's data
.controller "AccountCtrl", ($scope, $stateParams,AccountService, TransmitService) ->
  console.log 'ACCOUNT'
  $scope.awsParamsURI = TransmitService.awsParamsURI()
  $scope.awsFolder = TransmitService.awsFolder()
  $scope.s3Bucket = TransmitService.s3Bucket()

  AccountService.refresh (myself)->
    myself.$bindTo($scope,'me')

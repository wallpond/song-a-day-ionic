angular.module('songaday').filter('trust', ($sce) ->
  (url) ->
  if (url)
    $sce.trustAsResourceUrl url
)

angular.module('songaday').filter('length', ->
  (item) ->
    Object.keys(item or {}).length
)

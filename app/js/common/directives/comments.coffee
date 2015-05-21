angular.module('songaday').directive  'comments', ->
  { compile: (tElem, tAttrs) ->
    tElem.append '<div another-directive></div>'
    (scope, iElem, iAttrs) ->
      iElem.append '<div another-directive></div>'
      return
 }

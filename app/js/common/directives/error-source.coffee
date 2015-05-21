angular.module('songaday').directive 'errSrc', ->
  { link: (scope, element, attrs) ->
    element.bind 'error', ->
      if attrs.src != attrs.errSrc
        attrs.$set 'src', attrs.errSrc
      return
    return
 }

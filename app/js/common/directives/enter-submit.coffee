angular.module('songaday').directive 'enterSubmit', ->
  {
    restrict: 'A'
    link: (scope, elem, attrs) ->
      elem.bind 'keyup', (event) ->
        code = event.keyCode or event.which
        if code == 13
          if !event.shiftKey
            event.preventDefault()
            scope.$apply attrs.enterSubmit
        return
      if ionic.Platform.isIOS()
        elem.bind 'blur', (event) ->
          scope.$apply attrs.enterSubmit
          return
      return

  }

angular.module('songaday').directive 'showWhen',  ($window) ->
    {
      restrict: 'A'
      link: ($scope, $element, $attr) ->
        debouncedCheck = ionic.debounce((->
          $scope.$apply ->
            checkExpose()
            return
          return
        ), 300, false)

        checkExpose = ->
          mq = if $attr.showWhen == 'large' then '(min-width:768px)' else '(max-width:768px)'
          if $window.matchMedia(mq).matches
            $element.removeClass 'ng-hide'
          else
            $element.addClass 'ng-hide'
          return

        onResize = ->
          debouncedCheck()
          return

        checkExpose()
        ionic.on 'resize', onResize, $window
        $scope.$on '$destroy', ->
          ionic.off 'resize', onResize, $window
          return
        return

    }

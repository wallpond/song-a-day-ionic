###*
# Wraps ng-cloak so that, instead of simply waiting for Angular to compile, it waits until
# Auth resolves with the remote Firebase services.
#
# <code>
#    <div ng-cloak>Authentication has resolved.</div>
# </code>
###

angular.module('songaday').config [
  '$provide'
  ($provide) ->
    # adapt ng-cloak to wait for auth before it does its magic
    $provide.decorator 'ngCloakDirective', [
      '$delegate'
      'Auth'
      ($delegate, Auth) ->
        directive = $delegate[0]
        # make a copy of the old directive
        _compile = directive.compile

        directive.compile = (element, attr) ->
          Auth.$waitForAuth().then ->
            # after auth, run the original ng-cloak directive
            _compile.call directive, element, attr
            return
          return

        # return the modified directive
        $delegate
    ]
    return
]

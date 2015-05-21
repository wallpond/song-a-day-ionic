(function() {
  window.addElement = function(container, tagName, attrs) {
    var fjs, k, tag, v;
    if (attrs == null) {
      attrs = {};
    }
    if (attrs.id && container.getElementById(attrs.id)) {
      return container.getElementById(attrs.id);
    }
    fjs = container.getElementsByTagName(tagName)[0];
    tag = container.createElement(tagName);
    for (k in attrs) {
      v = attrs[k];
      tag[k] = v;
    }
    fjs.parentNode.insertBefore(tag, fjs);
    return tag;
  };

  window.log = function() {
    return console.log(arguments);
  };

  Storage.prototype.setObject = function(key, value) {
    return this.setItem(key, JSON.stringify(value));
  };

  Storage.prototype.getObject = function(key) {
    var value;
    if (!(value = this.getItem(key))) {
      return;
    }
    return JSON.parse(value);
  };

}).call(this);

(function() {
  if (GLOBALS.WEINRE_ADDRESS && (ionic.Platform.isAndroid() || ionic.Platform.isIOS()) && !navigator.platform.match(/MacIntel/i)) {
    window.addElement(document, "script", {
      id: "weinre-js",
      src: "http://" + GLOBALS.WEINRE_ADDRESS + "/target/target-script-min.js#anonymous"
    });
  }

}).call(this);

(function() {
  var app;

  app = angular.module(GLOBALS.ANGULAR_APP_NAME, [GLOBALS.ANGULAR_APP_NAME + ".templates", "ionic", "angulartics.google.analytics", "angulartics.google.analytics.cordova", "firebase", "angularMoment", "ngS3upload", "com.2fdevs.videogular", "com.2fdevs.videogular.plugins.controls", "com.2fdevs.videogular.plugins.poster"]).constant('FBURL', 'https://song-a-day.firebaseio.com/');

}).call(this);

(function() {
  var app, k, v;

  app = angular.module(GLOBALS.ANGULAR_APP_NAME);

  GLOBALS.APP_ROOT = location.href.replace(location.hash, "").replace("index.html", "");

  for (k in GLOBALS) {
    v = GLOBALS[k];
    app.constant(k, v);
  }

  app.run(function($rootScope) {
    return $rootScope.GLOBALS = GLOBALS;
  });

}).call(this);

(function() {
  var app;

  app = angular.module(GLOBALS.ANGULAR_APP_NAME);

  ionic.Platform.ready(function() {
    if (GLOBALS.ENV !== "test") {
      console.log('ionic.Platform is ready! Running `angular.bootstrap()`...');
    }
    return angular.bootstrap(document, [GLOBALS.ANGULAR_APP_NAME]);
  });

  app.run(function($log, $timeout, $rootScope, Auth, AccountService) {
    if (GLOBALS.ENV !== "test") {
      $log.debug("Ionic app \"" + GLOBALS.ANGULAR_APP_NAME + "\" has just started (app.run)!");
    }
    Auth.$onAuth(function(user) {
      return $rootScope.loggedIn = !!user;
    });
    AccountService.refresh(function(myself) {
      return $rootScope.myself = myself;
    });
    return $timeout(function() {
      var ref;
      return (ref = navigator.splashscreen) != null ? ref.hide() : void 0;
    });
  });

}).call(this);

(function() {
  var app;

  if (!GLOBALS.CORDOVA_GOOGLE_ANALYTICS_ID) {
    return;
  }

  app = angular.module(GLOBALS.ANGULAR_APP_NAME);

  ionic.Platform.ready(function() {
    return app.config(function(googleAnalyticsCordovaProvider) {
      googleAnalyticsCordovaProvider.debug = GLOBALS.ENV !== 'production';
      return googleAnalyticsCordovaProvider.trackingId = GLOBALS.CORDOVA_GOOGLE_ANALYTICS_ID;
    });
  });

}).call(this);

(function() {
  var app;

  app = angular.module(GLOBALS.ANGULAR_APP_NAME);

  app.config(function($httpProvider) {
    var base;
    $httpProvider.useApplyAsync(true);
    (base = $httpProvider.defaults.headers).patch || (base.patch = {});
    $httpProvider.defaults.headers.patch['Content-Type'] = 'application/json';
    $httpProvider.defaults.headers.common["X-Api-Version"] = "1.0";
    return $httpProvider.interceptors.push(function($injector, $q, $log, $location) {
      return {
        responseError: function(response) {
          if (GLOBALS.ENV !== "test") {
            $log.debug("httperror: ", response.status);
          }
          if (response.status === 401) {
            $injector.invoke(function(Auth) {
              Auth.setAuthToken(null, null);
              return $location.path("/");
            });
          }
          return $q.reject(response);
        }
      };
    });
  });

}).call(this);

(function() {
  var app;

  app = angular.module(GLOBALS.ANGULAR_APP_NAME);

  app.config(function($ionicConfigProvider) {
    $ionicConfigProvider.views.maxCache(4);
    $ionicConfigProvider.templates.maxPrefetch(false);
    if (ionic.Platform.grade !== "a") {
      $ionicConfigProvider.views.transition("none");
      return $ionicConfigProvider.views.maxCache(2);
    }
  });

}).call(this);

(function() {
  var app;

  app = angular.module(GLOBALS.ANGULAR_APP_NAME);

  app.config(function($logProvider, $compileProvider) {
    if (GLOBALS.ENV === "production") {
      $logProvider.debugEnabled(false);
      return $compileProvider.debugInfoEnabled(false);
    }
  });

}).call(this);

(function() {
  var app;

  if (window.Rollbar == null) {
    return;
  }

  app = angular.module(GLOBALS.ANGULAR_APP_NAME);

  app.factory('$exceptionHandler', function($log) {
    return function(e, cause) {
      $log.error(e.message);
      return Rollbar.error(e);
    };
  });

  Rollbar.configure({
    payload: {
      deploy_time: GLOBALS.DEPLOY_TIME,
      deploy_date: moment(GLOBALS.DEPLOY_TIME).format(),
      bundle_name: GLOBALS.BUNDLE_NAME,
      bundle_version: GLOBALS.BUNDLE_VERSION
    },
    transform: function(payload) {
      var frame, frames, i, len, ref, ref1, ref2, results;
      if (frames = (ref = payload.data) != null ? (ref1 = ref.body) != null ? (ref2 = ref1.trace) != null ? ref2.frames : void 0 : void 0 : void 0) {
        results = [];
        for (i = 0, len = frames.length; i < len; i++) {
          frame = frames[i];
          results.push(frame.filename = frame.filename.replace(GLOBALS.APP_ROOT, GLOBALS.ROLLBAR_SOURCEMAPS_URL_PREFIX + "/"));
        }
        return results;
      }
    }
  });

  app.run(function(Auth) {
    return Auth.on("user.updated", function(user) {
      return Rollbar.configure({
        payload: {
          person: (user ? {
            id: user.id,
            email: user.email
          } : void 0)
        }
      });
    });
  });

  app.run(function(onRouteChangeCallback) {
    return onRouteChangeCallback(function(state) {
      return Rollbar.configure({
        payload: {
          context: state.name
        }
      });
    });
  });

}).call(this);

(function() {
  if (GLOBALS.WEINRE_ADDRESS && (ionic.Platform.isAndroid() || ionic.Platform.isIOS()) && !navigator.platform.match(/MacIntel/i)) {
    window.addElement(document, "script", {
      id: "weinre-js",
      src: "http://" + GLOBALS.WEINRE_ADDRESS + "/target/target-script-min.js#anonymous"
    });
  }

}).call(this);

(function() {
  var app;

  app = angular.module(GLOBALS.ANGULAR_APP_NAME);

  app.run(function($window, $injector) {
    return $window.$a = $injector.get;
  });

}).call(this);


/**
 * Wraps ng-cloak so that, instead of simply waiting for Angular to compile, it waits until
 * Auth resolves with the remote Firebase services.
#
 * <code>
 *    <div ng-cloak>Authentication has resolved.</div>
 * </code>
 */

(function() {
  angular.module('songaday').config([
    '$provide', function($provide) {
      $provide.decorator('ngCloakDirective', [
        '$delegate', 'Auth', function($delegate, Auth) {
          var _compile, directive;
          directive = $delegate[0];
          _compile = directive.compile;
          directive.compile = function(element, attr) {
            Auth.$waitForAuth().then(function() {
              _compile.call(directive, element, attr);
            });
          };
          return $delegate;
        }
      ]);
    }
  ]);

}).call(this);

(function() {
  angular.module('songaday').directive('comments', function() {
    return {
      compile: function(tElem, tAttrs) {
        tElem.append('<div another-directive></div>');
        return function(scope, iElem, iAttrs) {
          iElem.append('<div another-directive></div>');
        };
      }
    };
  });

}).call(this);

(function() {
  angular.module('songaday').directive('enterSubmit', function() {
    return {
      restrict: 'A',
      link: function(scope, elem, attrs) {
        elem.bind('keyup', function(event) {
          var code;
          code = event.keyCode || event.which;
          if (code === 13) {
            if (!event.shiftKey) {
              event.preventDefault();
              scope.$apply(attrs.enterSubmit);
            }
          }
        });
        if (ionic.Platform.isIOS()) {
          elem.bind('blur', function(event) {
            scope.$apply(attrs.enterSubmit);
          });
        }
      }
    };
  });

}).call(this);

(function() {
  angular.module('songaday').directive('errSrc', function() {
    return {
      link: function(scope, element, attrs) {
        element.bind('error', function() {
          if (attrs.src !== attrs.errSrc) {
            attrs.$set('src', attrs.errSrc);
          }
        });
      }
    };
  });

}).call(this);

(function() {
  angular.module('songaday').directive('loader', function() {
    return {
      template: '{{loading?"☕":""}}'
    };
  });

}).call(this);

(function() {
  angular.module('songaday').directive('showWhen', function($window) {
    return {
      restrict: 'A',
      link: function($scope, $element, $attr) {
        var checkExpose, debouncedCheck, onResize;
        debouncedCheck = ionic.debounce((function() {
          $scope.$apply(function() {
            checkExpose();
          });
        }), 300, false);
        checkExpose = function() {
          var mq;
          mq = $attr.showWhen === 'large' ? '(min-width:768px)' : '(max-width:768px)';
          if ($window.matchMedia(mq).matches) {
            $element.removeClass('ng-hide');
          } else {
            $element.addClass('ng-hide');
          }
        };
        onResize = function() {
          debouncedCheck();
        };
        checkExpose();
        ionic.on('resize', onResize, $window);
        $scope.$on('$destroy', function() {
          ionic.off('resize', onResize, $window);
        });
      }
    };
  });

}).call(this);


/*
A simple example service that returns some data.
 */

(function() {
  angular.module("songaday").factory("Auth", function($firebaseAuth, FBURL) {
    return $firebaseAuth(new Firebase(FBURL));
  });

}).call(this);

(function() {
  angular.module("songaday").factory('FormFactory', function($q) {

    /*
    Basic form class that you can extend in your actual forms.
    
    Object attributes:
    - loading[Boolean] - is the request waiting for response?
    - message[String] - after response, success message
    - errors[String[]] - after response, error messages
    
    Options:
      - submitPromise[function] (REQUIRED) - creates a form request promise
      - onSuccess[function] - will be called on succeded promise
      - onFailure[function] - will be called on failed promise
     */
    var FormFactory;
    return FormFactory = (function() {
      function FormFactory(options) {
        this.options = options != null ? options : {};
        this.loading = false;
      }

      FormFactory.prototype.submit = function() {
        if (!this.loading) {
          return this._handleRequestPromise(this._createSubmitPromise());
        }
      };

      FormFactory.prototype._onSuccess = function(response) {
        this.message = response.message || response.success;
        return response;
      };

      FormFactory.prototype._onFailure = function(response) {
        var ref, ref1, ref2, ref3, ref4;
        this.errors = ((ref = response.data) != null ? (ref1 = ref.data) != null ? ref1.errors : void 0 : void 0) || ((ref2 = response.data) != null ? ref2.errors : void 0) || [((ref3 = response.data) != null ? ref3.error : void 0) || response.error || ((ref4 = response.data) != null ? ref4.message : void 0) || response.message || "Something has failed. Try again."];
        return $q.reject(response);
      };

      FormFactory.prototype._createSubmitPromise = function() {
        return this.options.submitPromise();
      };

      FormFactory.prototype._handleRequestPromise = function($promise, onSuccess, onFailure) {
        this.$promise = $promise;
        this.loading = true;
        this.submitted = false;
        this.message = null;
        this.errors = [];
        this.$promise.then((function(_this) {
          return function(response) {
            _this.errors = [];
            _this.submitted = true;
            return response;
          };
        })(this)).then(_.bind(this._onSuccess, this)).then(onSuccess || this.options.onSuccess)["catch"](_.bind(this._onFailure, this))["catch"](onFailure || this.options.onFailure)["finally"]((function(_this) {
          return function() {
            return _this.loading = false;
          };
        })(this));
        return this.$promise;
      };

      return FormFactory;

    })();
  });

}).call(this);

(function() {
  var slice = [].slice;

  angular.module("songaday").factory('ObserverFactory', function($rootScope) {
    var ObserverFactory;
    return ObserverFactory = (function() {
      function ObserverFactory() {}

      ObserverFactory.prototype.on = function(eventName, listener) {
        var base;
        if (this.listeners == null) {
          this.listeners = {};
        }
        if ((base = this.listeners)[eventName] == null) {
          base[eventName] = [];
        }
        return this.listeners[eventName].push(listener);
      };

      ObserverFactory.prototype.once = function(eventName, listener) {
        listener.__once__ = true;
        return this.on(eventName, listener);
      };

      ObserverFactory.prototype.off = function(eventName, listener) {
        var i, j, len, ref, ref1, results, v;
        if (!((ref = this.listeners) != null ? ref[eventName] : void 0)) {
          return;
        }
        if (!listener) {
          return delete this.listeners[eventName];
        }
        ref1 = this.listeners[eventName];
        results = [];
        for (v = j = 0, len = ref1.length; j < len; v = ++j) {
          i = ref1[v];
          if (this.listeners[eventName] === listener) {
            this.listeners.splice(i, 1);
            break;
          } else {
            results.push(void 0);
          }
        }
        return results;
      };

      ObserverFactory.prototype.fireEvent = function() {
        var eventName, j, len, params, ref, ref1, ref2, v;
        eventName = arguments[0], params = 2 <= arguments.length ? slice.call(arguments, 1) : [];
        if (!((ref = this.listeners) != null ? (ref1 = ref[eventName]) != null ? ref1.length : void 0 : void 0)) {
          return;
        }
        ref2 = this.listeners[eventName];
        for (j = 0, len = ref2.length; j < len; j++) {
          v = ref2[j];
          v.apply(this, params);
          if (v.__once__) {
            this.off(eventName, v);
          }
        }
        if (!$rootScope.$$phase) {
          return $rootScope.$apply();
        }
      };

      return ObserverFactory;

    })();
  });

}).call(this);

(function() {
  angular.module("songaday").factory('PromiseFactory', function($q) {
    var constructor;
    return constructor = function(value, resolve) {
      var deferred;
      if (resolve == null) {
        resolve = true;
      }
      if ((value != null) && typeof (value != null ? value.then : void 0) === 'function') {
        return value;
      } else {
        deferred = $q.defer();
        if (resolve) {
          deferred.resolve(value);
        } else {
          deferred.reject(value);
        }
        return deferred.promise;
      }
    };
  });

}).call(this);

(function() {
  angular.module('songaday').filter('length', function() {
    return function(item) {
      return Object.keys(item || {}).length;
    };
  });

}).call(this);

(function() {
  angular.module('songaday').filter('trust', function($sce) {
    (function(url) {});
    if (url) {
      return $sce.trustAsResourceUrl(url);
    }
  });

}).call(this);

(function() {


}).call(this);

(function() {
  angular.module("songaday").controller("AccountCtrl", function($scope, $stateParams, AccountService, TransmitService) {
    console.log('ACCOUNT');
    $scope.awsParamsURI = TransmitService.awsParamsURI();
    $scope.awsFolder = TransmitService.awsFolder();
    $scope.s3Bucket = TransmitService.s3Bucket();
    return AccountService.refresh(function(myself) {
      return myself.$bindTo($scope, 'me');
    });
  });

}).call(this);


/*
A simple example service that returns some data.
 */

(function() {
  angular.module("songaday").factory("AccountService", function($rootScope, $firebaseObject, Auth, FBURL) {
    var loading, me, promise_auth, ref;
    ref = new Firebase(FBURL);
    loading = true;
    promise_auth = Auth.$waitForAuth();
    me = {};
    return {
      loggedIn: function() {
        return console.log(auth);
      },
      refresh: function(cb) {
        return promise_auth.then(function(authObject) {
          var my_id;
          my_id = CryptoJS.SHA1(authObject.google.email).toString().substring(0, 11);
          me = $firebaseObject(ref.child('artists/' + my_id));
          return me.$loaded(function() {
            return cb(me);
          });
        });
      },
      mySelf: function() {
        return me;
      },
      login: function() {
        var provider;
        provider = 'google';
        return Auth.$authWithOAuthPopup(provider, {
          scope: "email"
        }).then((function(authObject) {
          var my_id;
          my_id = CryptoJS.SHA1(authObject.google.email).toString().substring(0, 11);
          me = $firebaseObject(ref.child('artists/' + my_id));
        }), function(error) {
          console.log(errer);
        });
      }
    };
  });

}).call(this);

(function() {
  angular.module("songaday").controller("AppCtrl", function($sce, SongService, AccountService, $state, $rootScope, $scope, $stateParams, $timeout) {
    var ctrl;
    ctrl = this;
    ctrl.state = null;
    ctrl.API = null;
    ctrl.currentSong = 0;
    ctrl.currentMediaType = "audio";
    ctrl.playlist = [];
    $timeout((function() {
      return ionic.trigger('resize');
    }), 100);
    $rootScope.comment = function(song, comment_text) {
      var comment, myself;
      myself = $rootScope.myself;
      comment = {
        comment: comment_text,
        author: {
          alias: myself.alias,
          avatar: myself.avatar,
          key: myself.$id
        }
      };
      return SongService.comment(song, comment);
    };
    $rootScope.login = function() {
      console.log('login');
      return AccountService.login();
    };
    $rootScope.showArtist = function(artist) {
      if (typeof artist === 'string') {
        $state.go('app.artist-detail', {
          artistId: artist
        });
        return;
      }
      return $state.go('app.artist-detail', {
        artistId: artist.$id
      });
    };
    $scope.showSong = function(song) {
      return $state.go('app.song-detail', {
        songId: song.$id
      });
    };
    ctrl.nowPlaying = function() {
      if (ctrl.currentSong < ctrl.playlist.length) {
        return ctrl.playlist[ctrl.currentSong];
      } else {
        return {
          "artist": {
            "avatar": ""
          }
        };
      }
    };
    ctrl.next = function() {
      ctrl.currentSong++;
      if (ctrl.currentSong >= ctrl.playlist.length) {
        ctrl.currentSong = 0;
      }
      return ctrl.setNowPlaying(ctrl.currentSong);
    };
    ctrl.previous = function() {
      ctrl.currentSong--;
      if (ctrl.currentSong <= 0) {
        ctrl.currentSong = ctrl.playlist.length;
      }
      return ctrl.setNowPlaying(ctrl.currentSong);
    };
    $rootScope.playNow = function(song) {
      if (!_(ctrl.playlist).includes(song)) {
        return ctrl.playlist.push(song);
      } else {
        return ctrl.setNowPlaying(_.indexOf(ctrl.playlist, song));
      }
    };
    $rootScope.queue = function(song) {
      if (_(ctrl.playlist).includes(song)) {
        ctrl.setNowPlaying(_.indexOf(ctrl.playlist, song));
        return;
      }
      ctrl.playlist.push(song);
      if (ctrl.playlist.length === 1) {
        return ctrl.setNowPlaying(0);
      }
    };
    ctrl.onPlayerReady = function(API) {
      ctrl.API = API;
    };
    ctrl.onCompleteVideo = function() {
      ctrl.isCompleted = true;
      ctrl.next();
    };
    ctrl.config = {
      preload: 'none',
      sources: [],
      theme: {
        url: 'http://www.videogular.com/styles/themes/default/latest/videogular.css'
      }
    };
    ctrl.setNowPlaying = function(index) {
      var m;
      ctrl.API.stop();
      ctrl.currentSong = index;
      m = ctrl.playlist[index].media;
      console.log(m);
      ctrl.config.sources = [
        {
          src: $sce.trustAsResourceUrl(m.src),
          type: m.type
        }
      ];
      console.log(ctrl.config);
      $timeout((function() {
        return ctrl.API.play();
      }), 200);
    };
  });

}).call(this);

(function() {
  angular.module("songaday").controller("ArtistDetailCtrl", function($scope, $stateParams, SongService, ArtistService) {
    $scope.artist = ArtistService.get($stateParams.artistId);
    $scope.loading = true;
    return $scope.artist.$loaded(function() {
      $scope.loading = false;
      return $scope.songs = SongService.getList($scope.artist.songs);
    });
  });

}).call(this);

(function() {
  angular.module("songaday").controller("ArtistIndexCtrl", function($scope, $state, ArtistService) {
    $scope.artists = ArtistService.all();
    $scope.loading = true;
    return $scope.artists.$loaded(function() {
      return $scope.loading = false;
    });
  });

}).call(this);


/*
A simple example service that returns some data.
 */

(function() {
  angular.module("songaday").factory("ArtistService", function($firebaseObject, $firebaseArray, FBURL) {
    var artists, ref;
    ref = new Firebase(FBURL + 'artists').orderByChild("songs");
    this.loading = true;
    artists = $firebaseArray(ref);
    return {
      all: function() {
        artists.$loaded(function() {
          return this.loading = false;
        });
        return artists;
      },
      get: function(artistId) {
        var artist;
        ref = new Firebase(FBURL + '/artists/' + artistId);
        artist = $firebaseObject(ref);
        return artist;
      }
    };
  });

}).call(this);

(function() {
  angular.module("songaday").controller("PlayerCtrl", function($scope, $stateParams, SongService) {
    $scope.next(function() {
      return console.log("next");
    });
    $scope.previous(function() {
      return console.log("prev");
    });
    $scope.stop(function() {
      return console.log("stop");
    });
    $scope.pause(function() {
      return console.log("pause");
    });
    return $scope.play(function() {
      return console.log("play");
    });
  });

}).call(this);


/*
A simple example service that returns some data.
 */

(function() {
  angular.module("songaday").factory("PlayerService", function() {
    var currentIndex, playlist;
    playlist = [];
    currentIndex = 0;
    return {
      nowPlaying: function() {
        return playlist[currentIndex];
      },
      listen: function(song) {
        return playlist.push(song.media);
      },
      getPlaylist: function() {
        return playlist;
      }
    };
  });

}).call(this);

(function() {
  angular.module("songaday").controller("SongDetailCtrl", function($scope, $stateParams, SongService) {
    $scope.loading = false;
    $scope.song = SongService.get($stateParams.songId);
    return $scope.song.$loaded(function() {
      return $scope.loading = true;
    });
  });

}).call(this);

(function() {
  angular.module("songaday").controller("SongIndexCtrl", function($state, $scope, SongService) {
    $scope.songs = SongService.all();
    $scope.loading = true;
    return $scope.songs.$loaded(function() {
      return $scope.loading = false;
    });
  });

}).call(this);


/*
A simple example service that returns some data.
 */

(function() {
  angular.module("songaday").factory("SongService", function($firebaseObject, $firebaseArray, FBURL) {
    var limit, ref, songs;
    limit = 17;
    ref = new Firebase(FBURL + 'songs').orderByChild("timestamp").limitToLast(limit);
    songs = $firebaseArray(ref);
    return {
      all: function() {
        return songs;
      },
      comment: function(song, comment) {
        var comments, commentsRef;
        commentsRef = new Firebase(FBURL + 'songs/' + song.$id + '/comments');
        comments = $firebaseArray(commentsRef);
        return comments.$add(comment);
      },
      get: function(songId) {
        ref = new Firebase(FBURL + '/songs/' + songId);
        return $firebaseObject(ref);
      },
      getList: function(songList) {
        var playlist, songId;
        playlist = [];
        for (songId in songList) {
          playlist.push(this.get(songId));
        }
        return playlist;
      }
    };
  });

}).call(this);

(function() {
  angular.module("songaday").controller("TransmitCtrl", function($scope, TransmitService, $timeout, AccountService) {
    $scope.awsParamsURI = TransmitService.awsParamsURI();
    $scope.awsFolder = TransmitService.awsFolder();
    $scope.s3Bucket = TransmitService.s3Bucket();
    $scope.transmission = {
      media: {}
    };
    AccountService.refresh(function(myself) {
      return TransmitService.lastTransmission(myself, function(last_song) {
        $scope.lastTransmission = last_song;
        return console.log(last_song);
      });
    });
    $scope.$on('s3upload:success', function(e) {
      $scope.ready = true;
      console.log($scope.media);
      $timeout((function() {
        console.log(e);
        $scope.transmission.media.src = e.targetScope['filename'];
        return $scope.transmission.media.type = e.targetScope['filetype'];
      }), 100);
    });
    return $scope.transmit = function(song) {
      return AccountService.refresh(function(myself) {
        song = {};
        song['info'] = $scope.transmission.info || '';
        song['title'] = $scope.transmission.title || 'untitled';
        song['timestamp'] = (new Date).toISOString();
        song['media'] = $scope.transmission.media;
        song['user_id'] = myself.user_id;
        song['artist'] = {
          'alias': myself.alias || '',
          'key': myself.$id,
          'avatar': myself.avatar || ''
        };
        console.log(song, myself);
        return TransmitService.transmit(song, function(new_id) {
          myself.songs[new_id] = true;
          return myself.$save();
        });
      });
    };
  });

}).call(this);


/*
A simple example service that returns some data.
 */

(function() {
  angular.module("songaday").factory("TransmitService", function($firebaseObject, $firebaseArray, FBURL) {
    var ref;
    ref = new Firebase(FBURL + '/songs');
    return {
      cloudFrontURI: function() {
        return 'd1hmps6uc7xmb3.cloudfront.net';
      },
      awsParamsURI: function() {
        return '/config/aws.json';
      },
      awsFolder: function() {
        return 'songs/';
      },
      s3Bucket: function() {
        return 'songadays';
      },
      transmit: function(song, callback) {
        return ref.push(song, function(complete) {
          var my_songs;
          my_songs = new Firebase(FBURL + '/artists/' + artist.$id + '/songs');
          my_songs.child(song.$id).set(true);
          return callback(song.$id);
        });
      },
      lastTransmission: function(artist, callback) {
        var last_transmission;
        console.log(artist);
        ref = new Firebase(FBURL + '/artists/' + artist.$id + '/songs');
        last_transmission = $firebaseObject(ref);
        last_transmission.$loaded(function(err) {
          return callback(last_transmission);
        });
      }
    };
  });

}).call(this);

(function() {
  angular.module("songaday").config(function($stateProvider, $urlRouterProvider) {
    $stateProvider.state("app", {
      url: "/app",
      abstract: true,
      templateUrl: "templates/menu.html"
    }).state("app.songs", {
      url: "/songs",
      views: {
        "main-content": {
          templateUrl: "templates/song-index.html",
          controller: "SongIndexCtrl"
        }
      }
    }).state("app.song-detail", {
      url: "/song/:songId",
      views: {
        "main-content": {
          templateUrl: "templates/song-detail.html",
          controller: "SongDetailCtrl"
        }
      }
    }).state("app.artists", {
      url: "/songwriters",
      views: {
        "main-content": {
          templateUrl: "templates/artist-index.html",
          controller: "ArtistIndexCtrl"
        }
      }
    }).state("app.artist-detail", {
      url: "/songwriter/:artistId",
      views: {
        "main-content": {
          templateUrl: "templates/artist-detail.html",
          controller: "ArtistDetailCtrl"
        }
      }
    }).state("app.account", {
      url: "/account",
      views: {
        "main-content": {
          templateUrl: "templates/account.html",
          controller: "AccountCtrl"
        }
      }
    }).state("app.transmit", {
      url: "/transmit",
      views: {
        "main-content": {
          templateUrl: "templates/transmit.html",
          controller: "TransmitCtrl"
        }
      }
    }).state("app.mission", {
      url: "/mission",
      views: {
        "main-content": {
          templateUrl: "templates/mission.html"
        }
      }
    });
    return $urlRouterProvider.otherwise("/app/songs");
  });

}).call(this);

//# sourceMappingURL=app.js.map
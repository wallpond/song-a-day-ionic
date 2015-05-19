angular.module('songaday').directive 'loader',() ->
  { template: '{{loading?"☕":""}}' }

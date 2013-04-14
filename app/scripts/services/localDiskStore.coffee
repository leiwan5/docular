'use strict';

angular.module('docularApp')
  .factory 'localDiskStore', [() ->
    # Service logic
    # ...

    meaningOfLife = 42

    # Public API here
    {
      someMethod: () ->
        return meaningOfLife;
    }
  ]

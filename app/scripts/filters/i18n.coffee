'use strict'

userLang = if navigator.language then navigator.language else navigator.userLanguage

angular.module('docularApp')
  .filter 'i18n', ['$locales', ($locales) ->
    (input) ->
      try
        $locales[userLang][input] or input
      catch error
        input
  ]

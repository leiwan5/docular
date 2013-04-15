'use strict'

angular.module('docularAppLocales', []).config [
  '$provide', 
  ($provide) ->
    $provide.value '$locales',
      'zh-CN':
        _open_: '打开'
        _save_: '保存'
        _preview_: '预览'
      'en-US':
        _open_: 'Open'
        _save_: 'Save'
        _preview_: 'Preview'
]

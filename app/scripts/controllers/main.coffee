'use strict'

angular.module('docularApp')
  .controller 'MainCtrl', ['$scope', ($scope) ->
    $scope.$watch 'docHtml', (docHtml) ->

    $scope.$watch 'editor', (editor) ->
      if editor
        editor.getSession().setMode 'ace/mode/markdown'
        editor.setTheme 'ace/theme/textmate'
        editor.on 'change', () ->
          $scope.$apply ->
            $scope.docSrc = editor.getValue()
            $scope.docHtml = marked.parse($scope.docSrc)
  ]

'use strict'

angular.module('docularApp')
  .controller 'MainCtrl', ['$scope', ($scope) ->
    $scope.$watch 'docSrc', (docSrc) ->

    $scope.$watch 'editor', (editor) ->
      if editor
        editor.on 'change', () ->
          $scope.$apply ->
            $scope.docSrc = editor.getValue()
            $scope.docHtml = marked.parse($scope.docSrc)
  ]

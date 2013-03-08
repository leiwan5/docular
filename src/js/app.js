(function() {

  angular.module('$docular', []);

  angular.module('$docular').directive('docularEditor', function() {
    return {
      link: function(scope, element, attrs) {
        var editor;
        if (!ace) {
          return;
        }
        editor = window.editor = ace.edit(attrs.id);
        editor.getSession().setMode('ace/mode/markdown');
        return scope.$on('resized', function() {
          return editor.resize();
        });
      }
    };
  });

  angular.module('$docular').directive('docularSplitView', function() {
    return {
      scope: {
        secondSize: '=secondSize',
        secondVisible: '=secondVisible',
        mode: '=mode'
      },
      link: function(scope, element, attrs) {
        var first, mode, second, self, update;
        self = $(element[0]);
        first = self.find('.first');
        second = self.find('.second');
        if (!(first.size() > 0 && second.size() > 0)) {
          return;
        }
        mode = attrs.mode !== 'vertical' && 'horizontal' || 'vertical';
        self.addClass(mode);
        first.css({
          position: 'absolute'
        });
        second.css({
          position: 'absolute'
        });
        update = function() {
          if (scope.secondSize === void 0) {
            return;
          }
          if (scope.secondVisible) {
            second.show();
            if (scope.mode !== 'vertical') {
              first.css({
                top: 0,
                bottom: 0,
                left: 0,
                right: (scope.secondSize + 1) + 'px',
                borderRight: '1px solid #dbdbdb',
                borderBottom: 0
              });
              second.css({
                top: 0,
                bottom: 0,
                right: 0,
                left: 'auto',
                width: (scope.secondSize - 4) + 'px',
                borderLeft: '6px solid transparent'
              });
            } else {
              first.css({
                top: 0,
                bottom: (scope.secondSize + 1) + 'px',
                left: 0,
                right: 0,
                borderBottom: '1px solid #dbdbdb',
                borderRight: 0
              });
              second.css({
                top: 'auto',
                bottom: 0,
                right: 0,
                left: 0,
                height: (scope.secondSize - 4) + 'px',
                borderTop: '6px solid transparent'
              });
            }
          } else {
            first.css({
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              borderRight: 0,
              borderBottom: 0
            });
            second.hide();
          }
          return scope.$broadcast('resized');
        };
        scope.$watch('secondSize', function(n, o) {
          if (!(n === o && n !== void 0)) {
            return update();
          }
        });
        scope.$watch('secondVisible', function(n, o) {
          if (!(n === o && n !== void 0)) {
            return update();
          }
        });
        return scope.$watch('mode', function(n, o) {
          if (!(n === o && n !== void 0)) {
            return update();
          }
        });
      }
    };
  });

}).call(this);

(function() {

  window.app = window.app || angular.module('app', ['$docular']);

}).call(this);

(function() {

  window.app = window.app || angular.module('app', ['$docular']);

}).call(this);

(function() {

  window.app = window.app || angular.module('app', ['$docular']);

  app.controller('app', [
    '$scope', function($scope) {
      $scope.appName = 'Docular!';
      $scope.previewSize = 300;
      $scope.previewVisible = false;
      return $scope.preview = function() {
        if (!$scope.previewVisible) {
          $scope.previewMode = 'horizontal';
          $scope.previewVisible = true;
        } else {
          if ($scope.previewMode === 'horizontal') {
            $scope.previewMode = 'vertical';
          } else {
            $scope.previewVisible = false;
          }
        }
        return console.log($scope.previewVisible, $scope.previewMode);
      };
    }
  ]);

}).call(this);

(function() {

  window.app = window.app || angular.module('app', []);

  $(function() {
    return angular.bootstrap($('html'), ['app']);
  });

}).call(this);

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
        var body, first, resizerSize, second, self, update;
        resizerSize = 7;
        self = $(element[0]);
        first = self.find('.first');
        second = self.find('.second');
        if (!(first.size() > 0 && second.size() > 0)) {
          return;
        }
        first.css({
          position: 'absolute'
        });
        second.css({
          position: 'absolute'
        });
        second.on('mousemove', function(evt) {
          var cursor;
          cursor = 'auto';
          if (scope.secondVisible) {
            if (scope.mode !== 'vertical') {
              cursor = evt.offsetX < resizerSize && 'w-resize' || 'auto';
            } else {
              cursor = evt.offsetY < resizerSize && 'n-resize' || 'auto';
            }
          }
          return second.css({
            cursor: cursor
          });
        });
        body = $('body');
        body.on('mousedown', function(evt) {
          var offset, originPos, originSecondSize;
          if (scope.secondVisible) {
            originSecondSize = scope.secondSize;
            if (scope.mode !== 'vertical') {
              offset = evt.offsetX;
              originPos = evt.x;
              body.css({
                cursor: 'w-resize'
              });
            } else {
              offset = evt.offsetY;
              originPos = evt.y;
              body.css({
                cursor: 'n-resize'
              });
            }
            if (offset < resizerSize) {
              body.on('mousemove', function(evt) {
                var currentPos, newSecondSize;
                currentPos = scope.mode !== 'vertical' && evt.x || evt.y;
                newSecondSize = originSecondSize - currentPos + originPos;
                if (newSecondSize > 50 && (scope.mode !== 'vertical' && self.width() || self.height()) - newSecondSize > 50) {
                  return scope.$apply(function() {
                    return scope.secondSize = newSecondSize;
                  });
                }
              });
              return body.one('mouseup', function(evt) {
                body.off('mousemove');
                return body.css({
                  cursor: 'auto'
                });
              });
            }
          }
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
                height: 'auto',
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
                height: scope.secondSize + 'px',
                width: 'auto'
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
      $scope.previewSize = 350;
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

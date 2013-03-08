(function() {

  angular.module('$docular', []);

  angular.module('$docular').directive('docularEditor', function() {
    return {
      link: function(scope, element, attrs) {
        var editor;
        if (!ace) {
          return;
        }
        editor = ace.edit(attrs.id);
        return editor.getSession().setMode('ace/mode/markdown');
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
      return $scope.appName = 'Docular!';
    }
  ]);

}).call(this);

(function() {

  window.app = window.app || angular.module('app', []);

  $(function() {
    return angular.bootstrap($('html'), ['app']);
  });

}).call(this);

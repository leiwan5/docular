(function() {

  window.app = window.app || angular.module('app', []);

}).call(this);

(function() {

  window.app = window.app || angular.module('app', []);

  app.controller('app', function($scope) {
    return $scope.appName = 'Docular!';
  });

}).call(this);

(function() {

  window.app = window.app || angular.module('app', []);

  $(function() {
    return angular.bootstrap($('html'), ['app']);
  });

}).call(this);

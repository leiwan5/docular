window.app = window.app || angular.module 'app', []

app.controller 'app', ($scope) ->
	$scope.appName = 'Docular!'

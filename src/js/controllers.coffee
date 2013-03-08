window.app = window.app || angular.module 'app', ['$docular']

app.controller 'app', ['$scope', ($scope) ->
	$scope.appName = 'Docular!'
]

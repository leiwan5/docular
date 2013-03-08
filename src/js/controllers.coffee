window.app = window.app || angular.module 'app', ['$docular']

app.controller 'app', ['$scope', ($scope) ->
	$scope.appName = 'Docular!'
	$scope.previewSize = 300
	$scope.previewVisible = false
	$scope.preview = ->
		unless $scope.previewVisible
			$scope.previewMode = 'horizontal'
			$scope.previewVisible = true
		else
			if $scope.previewMode == 'horizontal'
				$scope.previewMode = 'vertical'
			else
				$scope.previewVisible = false

		console.log $scope.previewVisible, $scope.previewMode

]

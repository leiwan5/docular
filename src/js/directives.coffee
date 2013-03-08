angular.module '$docular', []

angular.module('$docular').directive 'docularEditor', ->
	link: (scope, element, attrs) ->
		return unless ace
		editor = ace.edit attrs.id
		editor.getSession().setMode 'ace/mode/markdown'
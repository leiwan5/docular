angular.module '$docular', []

angular.module('$docular').directive 'docularEditor', ->
	link: (scope, element, attrs) ->
		return unless ace
		editor = window.editor = ace.edit attrs.id
		editor.getSession().setMode 'ace/mode/markdown'
		scope.$on 'resized', ->
			editor.resize()

angular.module('$docular').directive 'docularSplitView', ->
	scope:
		secondSize: '=secondSize'
		secondVisible: '=secondVisible'
		mode: '=mode'
	link: (scope, element, attrs) ->
		self = $(element[0])
		first = self.find('.first')
		second = self.find('.second')
		return unless first.size() > 0 and second.size() > 0

		mode = attrs.mode != 'vertical' and 'horizontal' or 'vertical'
		self.addClass mode
		first.css position: 'absolute'
		second.css position: 'absolute'

		update = ->
			return if scope.secondSize == undefined
			if scope.secondVisible
				second.show()
				if scope.mode != 'vertical'
					first.css
						top: 0
						bottom: 0
						left: 0
						right: (scope.secondSize + 1) + 'px'
						borderRight: '1px solid #dbdbdb';
						borderBottom: 0
					second.css
						top: 0
						bottom: 0
						right: 0
						left: 'auto'
						width: (scope.secondSize - 4) + 'px'
						borderLeft: '6px solid transparent';
				else
					first.css
						top: 0
						bottom: (scope.secondSize + 1) + 'px'
						left: 0
						right: 0
						borderBottom: '1px solid #dbdbdb';
						borderRight: 0
					second.css
						top: 'auto'
						bottom: 0
						right: 0
						left: 0
						height: (scope.secondSize - 4) + 'px'
						borderTop: '6px solid transparent';
			else
				first.css
					top: 0
					bottom: 0
					left: 0
					right: 0
					borderRight: 0
					borderBottom: 0
				second.hide()
			scope.$broadcast 'resized'

		scope.$watch 'secondSize', (n, o) ->
			update() unless n == o and n != undefined

		scope.$watch 'secondVisible', (n, o) ->
			update() unless n == o and n != undefined

		scope.$watch 'mode', (n, o) ->
			update() unless n == o and n != undefined


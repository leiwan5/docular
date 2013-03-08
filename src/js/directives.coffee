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
		resizerSize = 7

		self = $(element[0])
		first = self.find('.first')
		second = self.find('.second')
		return unless first.size() > 0 and second.size() > 0

		first.css position: 'absolute'
		second.css position: 'absolute'

		second.on 'mousemove', (evt) ->
			cursor = 'auto'
			if scope.secondVisible
				if scope.mode != 'vertical'
					cursor = evt.offsetX < resizerSize and 'w-resize' or 'auto'
				else
					cursor = evt.offsetY < resizerSize and 'n-resize' or 'auto'
			second.css
				cursor: cursor

		body = $('body')

		body.on 'mousedown', (evt) ->
			if scope.secondVisible
				originSecondSize = scope.secondSize
				if scope.mode != 'vertical'
					offset = evt.offsetX
					originPos = evt.x
					body.css cursor: 'w-resize'
				else
					offset = evt.offsetY
					originPos = evt.y
					body.css cursor: 'n-resize'
				if offset < resizerSize

					body.on 'mousemove', (evt) ->
						currentPos = scope.mode != 'vertical' and evt.x or evt.y
						newSecondSize = originSecondSize - currentPos + originPos
						if newSecondSize > 50 and (scope.mode != 'vertical' and self.width() or self.height()) - newSecondSize > 50
							scope.$apply ->
								scope.secondSize = newSecondSize

					body.one 'mouseup', (evt) ->
						body.off 'mousemove'
						body.css cursor: 'auto'

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
						height: 'auto'
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
						height: scope.secondSize + 'px'
						width: 'auto'
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


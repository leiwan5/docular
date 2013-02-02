Sequelize = require 'sequelize'
marked = require 'marked'
async = require 'async'
path = require 'path'
gui = require 'nw.gui'

new_document_title = 'New Doc'

appPath = process.cwd()
db = new Sequelize 'db', null, null,
	dialect: 'sqlite'
	storage: path.join appPath, 'documents.db'

Document = db.define 'Document',
	title:
		type: Sequelize.STRING
		validate:
			isNew: (value) ->
				if value == new_document_title
					throw new Error 'Assgin the document title please!'
	description: Sequelize.TEXT
	content: Sequelize.TEXT

window.app = angular.module 'app', []
toastr.options = 
	positionClass: 'toast-bottom-left'

app.controller 'app', ($scope) ->
	$scope.win = gui.Window.get()
	if localStorage['height']
		$scope.win.height = localStorage['height']
	if localStorage['width']
		$scope.win.width = localStorage['width']
	if localStorage['x']
		$scope.win.x = localStorage['x']
	if localStorage['y']
		$scope.win.y = localStorage['y']

	window.editor = ace.edit 'editor'
	editor.getSession().setMode 'ace/mode/markdown'

	$scope.documents = []
	$scope.editing = 
		dirty: false
		content: ''
		doc: null
	$scope.previewPaneDocked = true
	$scope.themes = [
		{name: 'github', label: 'Github'},
		{name: 'textmate', label: 'Textmate'},
		{name: 'dreamweaver', label: 'Dreamweaver'},
		{name: 'monokai', label: 'Monokai'},
		{name: 'vibrant_ink', label: 'Vibrant Ink'}
	]
	theme = if localStorage['theme']
		res = $scope.themes.filter (t) -> t.name == localStorage['theme']
		if res.length > 0 then res[0] else null
	else
		null
	$scope.currentTheme = theme || $scope.themes[1]
	$scope.currentFontSize = localStorage['font_size'] || 14
	$scope.changeTheme = (theme) ->
		editor.setTheme "ace/theme/#{theme.name}"
		$scope.currentTheme = theme
		localStorage['theme'] = theme.name
	$scope.changeFontSize = (size) ->
		editor.setFontSize "#{size}px"
		$scope.currentFontSize = size
		localStorage['font_size'] = size
	$scope.changeTheme $scope.currentTheme
	$scope.changeFontSize $scope.currentFontSize


	reloadDocuments = ->
		Document.findAll(order: 'createdAt DESC').success (documents) ->
			$scope.documents = documents
			$scope.$digest()

	openDocument = (doc, reopen) ->
		if doc and doc.id and reopen
			Document.find(doc.id).success((_doc) ->
					openDocument _doc
				)
		else
			$scope.previewMode = false
			$scope.editing.dirty = false
			$scope.editing.content = doc.content
			$scope.editing.doc = doc
			editor.setValue doc.content
			editor.clearSelection()
			localStorage['editing_id'] = doc.id
			process.nextTick ->
				$scope.$digest()


	$scope.selectDocument = (doc) ->
		if doc
			if $scope.deleteMode
				doc.checked = !doc.checked
			else
				$('#doc-selector').modal 'hide'
				if $scope.editing.dirty
					bootbox.dialog 'Your document isn\'t saved!', [
							{label: 'Discard', class: 'btn-danger', callback: -> openDocument doc},
							{label: 'Save', callback: -> $scope.saveDocument(-> openDocument(doc, true))},
							{label: 'Cancel'}
						]
				else
					openDocument doc

		else
			reloadDocuments()
			unless $scope.previewPaneDocked
				$scope.previewMode = false
			$('#doc-selector').modal 'show'


	$scope.setProperties = () ->
		$('#doc-properties').modal 'show'

	$scope.preview = () ->
		$scope.previewMode = !$scope.previewMode

	$scope.dockPreviewPane = () ->
		$scope.previewPaneDocked = !$scope.previewPaneDocked

	$scope.newDocument = () ->
		doc = Document.build title: new_document_title
		$scope.selectDocument doc
			
	$scope.saveDocument = (cb) ->
		if $scope.editing.doc
			$scope.editing.doc.content = $scope.editing.content
			if errors = $scope.editing.doc.validate()
				toastr.error errors.title
			else
				$scope.editing.doc.save().success (doc) ->
					$scope.editing.dirty = false
					$scope.$digest()
					localStorage['editing_id'] = doc.id
					toastr.success 'Document saved!'
					cb() if cb

	$scope.enterDeleteMode = ->
		$scope.deleteMode = !$scope.deleteMode
		if $scope.deleteMode
			toastr.info 'Select documents to delete!'

	$scope.deleteSelected = ->
		checkedDocuments = []
		for doc in $scope.documents
			checkedDocuments.push doc if doc.checked
		async.reduce checkedDocuments, 0, (count, doc, cb) ->
				console.log checkedDocuments, doc
				process.nextTick ->
					doc
						.destroy()
						.success -> cb(null, count + 1)
						.failure -> cb(1, doc)
			, (err, result) ->
				console.log err, 33
				if err == 1
					toastr.error 'Document "' + doc.title + '" was failed to delete!'
				else
					toastr.success 'All selected documents are deleted!'
					$scope.deleteMode = false
					process.nextTick ->
						reloadDocuments()
						console.log $scope.documents

	$scope.export = () ->
		toastr.error 'Not implemented!'

	$scope.syncToGist = () ->
		toastr.error 'Not implemented!'

	$scope.exit = () ->
		if $scope.editing.dirty
			bootbox.confirm 'Are you sure? Your document is not saved!', (sure) ->
				if sure
					gui.App.closeAllWindows()
		else
			gui.App.closeAllWindows()

	updatePreview = ->
		try
			doc = marked $scope.editing.content
			$('#preview > .container > .content').html doc

	editor.on 'change', () ->
		process.nextTick ->
			$scope.editing.dirty = ($scope.editing.doc.content != editor.getValue())
			$scope.editing.content = editor.getValue()
			$scope.$digest()
			updatePreview() if $scope.previewMode and $scope.previewPaneDocked

	$scope.$watch 'previewMode', (previewMode) ->
		updatePreview() if previewMode
		process.nextTick ->
			editor.resize()
	
	$scope.$watch 'editing.doc.title', (title, oldTitle) ->
		if title and title != oldTitle
			$scope.editing.dirty = true

	$scope.$watch 'editing.description', (description, oldDescription) ->
		if description and description != oldDescription
			$scope.editing.dirty = true

	$(window).on 'getwindowsize', ->
		localStorage['height'] = $scope.win.height
		localStorage['width'] = $scope.win.width
		localStorage['x'] = $scope.win.x
		localStorage['y'] = $scope.win.y


	id = parseInt localStorage['editing_id']
	newDoc = Document.build title: new_document_title

	unless isNaN id
		Document.find(localStorage['editing_id']).success((doc) ->
				openDocument doc || newDoc
			).failure ->
				openDocument newDoc
	else
		openDocument newDoc

$ ->
	db.sync().success ->
		angular.bootstrap $('html'), ['app']

	$('#preview > .container > .content').on 'click', 'a', ->
		url = $(this).attr 'href'
		gui.Shell.openExternal url if url
		false

	$(window).on 'getwindowsize', ->
		setTimeout ->
				$(window).trigger 'getwindowsize'
			, 500

	$(window).trigger 'getwindowsize'
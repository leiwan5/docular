Sequelize = require 'sequelize'
marked = require 'marked'
async = require 'async'
path = require 'path'
gui = require 'nw.gui'

new_document_title = 'New Doc'
alert process.cwd()
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
	editor = ace.edit 'editor'
	editor.getSession().setMode 'ace/mode/markdown'

	$scope.documents = []
	# $scope.previewDocument = ''

	reloadDocuments = ->
		Document.findAll(order: 'createdAt DESC').success (documents) ->
			$scope.documents = documents
			$scope.$digest()

	$scope.selectDocument = (doc) ->
		if doc
			if $scope.deleteMode
				doc.checked = !doc.checked
			else
				$scope.previewMode = false
				$scope.editing = null
				$scope.editing = doc
				editor.setValue doc.content
				editor.clearSelection()
				$('#doc-selector').modal 'hide'
				localStorage['editing_id'] = doc.id
				process.nextTick ->
					$scope.$digest()
		else
			reloadDocuments()
			$scope.previewMode = false
			$('#doc-selector').modal 'show'

	$scope.setProperties = () ->
		$('#doc-properties').modal 'show'

	$scope.preview = () ->
		$scope.previewMode = !$scope.previewMode

	$scope.newDocument = () ->
		doc = Document.build title: new_document_title
		$scope.selectDocument doc
			
	$scope.saveDocument = () ->
		if errors = $scope.editing.validate()
			toastr.error errors.title
		else
			$scope.editing.save().success (doc) ->
				localStorage['editing_id'] = doc.id
				toastr.success 'Document saved!'

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

	editor.on 'change', () ->
		$scope.editing.content = editor.getValue()

	$scope.$watch 'previewMode', (previewMode) ->
		if previewMode
			try
				doc = marked $scope.editing.content
				$('.preview > .content').html doc


	id = parseInt localStorage['editing_id']
	newDoc = Document.build title: new_document_title
	process.nextTick ->
		unless isNaN id
			Document.find(localStorage['editing_id']).success((doc) ->
					$scope.selectDocument doc || newDoc
					$scope.$digest()
				).failure ->
					$scope.selectDocument newDoc
					$scope.$digest()
		else
			$scope.selectDocument newDoc
			$scope.$digest()

$ ->
	db.sync().success ->
		angular.bootstrap $('html'), ['app']

	$('.preview > .content').on 'click', 'a', ->
		url = $(this).attr 'href'
		gui.Shell.openExternal url if url
		false

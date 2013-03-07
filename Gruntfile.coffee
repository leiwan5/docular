module.exports = (grunt) ->
	grunt.initConfig
		pkg: grunt.file.readJSON('package.json')
		# uglify:
		# 	scripts:
		# 		files:
		# 			'release': 'build'

		coffee:
			js:
				files:
					'src/js/app.js': 'src/js/*.coffee'

		less:
			css:
				files: 'src/css/app.css': 'src/css/app.less'

		watch:
			js:
				files: 'src/js/*.coffee'
				tasks: ['coffee:js']
			css:
				files: 'src/css/*.less'
				tasks: ['less:css']

		copy:
			rel:
				files:
					'release/': ['src/**/*.!(coffee|less)']


	grunt.loadNpmTasks 'grunt-contrib-uglify'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-contrib-copy'
	grunt.loadNpmTasks 'grunt-contrib-less'

	grunt.registerTask 'default', ['watch']

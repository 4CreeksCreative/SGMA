axis         = require 'axis'
rupture      = require 'rupture'
autoprefixer = require 'autoprefixer-stylus'
js_pipeline  = require 'js-pipeline'
css_pipeline = require 'css-pipeline'
contentful   = require 'roots-contentful'
slugify      = require 'slugify'
howToSteps = {}

sortHowToSection = (entry) ->
	howToSteps[entry.id] = []

sortHowTo = (entry) ->
	howToSteps[entry.section.fields.id].push(entry)

getDateVars = (entry) ->
	if entry.date != undefined
		days = ["","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
		months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
		date = new Date(entry.date)
		entry.dateFormatted = {}
		entry.dateFormatted.day = date.getDate()
		entry.dateFormatted.dayName = days[date.getDay()]
		entry.dateFormatted.month = months[date.getMonth()]
		entry.dateFormatted.year = date.getFullYear()
		entry.dateFormatted.minutes = if date.getMinutes() < 10 then '0' + date.getMinutes() else date.getMinutes()

module.exports =
	ignores: ['readme.md', '**/layout.*', '**/_*', '.gitignore', 'ship.*conf']

	extensions: [
		js_pipeline(files: ['assets/js/*.coffee', 'assets/js/*.js']),
		css_pipeline(files: ['assets/css/*.css','assets/css/*.styl'])
		contentful
			access_token:'f4d0139ed5119dad9049a54ad1aa64bd78518ddd4504676b39d1ac73f352a11c'
			space_id:'fpoxei0h1wzw'
			content_types:
				projects:
					id:'project'
					template:'/views/partials/_project.jade'
					path: (e) -> "project/#{e.id}"
					filters:{
						'order':'sys.createdAt'
					}
				subpage:
					id:'subPage'
					template:'/views/partials/_subPage.jade'
					path: (e) -> "/#{slugify(e.pageName)}"
				categories:
					id:'categories'
					filters:{
						'order':'fields.title'
					}
				howTo:
					id:"howToSection"
					transform: sortHowToSection
				howToStep:
					id:"howToStep"
					template:'/views/partials/_step.jade'
					path: (e) -> "info/#{slugify(e.title)}"
					transform: sortHowTo
				meetings:
					id:"meetings"
					template:'/views/partials/_meeting.jade'
					path: (e) -> "meeting/#{slugify(e.title)}"
					filters:{
						'order':'fields.date'
					}
					transform: getDateVars
	]

	stylus:
		use: [axis(), rupture(), autoprefixer()]
		sourcemap: true

	'coffee-script':
		sourcemap: true

	jade:
		pretty: true
	server:
		clean_urls:true
	locals:
		basedir: 'views'
		md: require 'marked'
		slugify: require 'slugify'
		howToSteps: howToSteps

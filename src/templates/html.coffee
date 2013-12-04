###
Basic HTML template.
###

jade = require 'jade'
fs = require 'fs'
mkdirp = require 'mkdirp'
md = require 'github-flavored-markdown'

rmdir = (path, self) ->
	if fs.existsSync path
		files = fs.readdirSync path
		
		for file in files
			f = "#{path}/#{file}"
			
			if fs.statSync(f).isDirectory()
				rmdir f, true
				
			else
				fs.unlinkSync f
		
		if self then fs.rmdirSync path

module.exports = (doc, options, callback) ->
	setupMethods = (modules) ->
		html = methodsTemplate
			title: "Methods | #{options.title}"
			modules: modules
			level: ""
			badge: options.badge
			project: options.title
			md: md.parse
	
		fs.writeFileSync "#{options.target}/docs/methods.html", html
	
	setupNamespace = (ns) ->
		# dont render docs for default ns when we have index as configured option
		if not ns.name and options.index then return
		
		html = nsTemplate
			title: "Namespace #{ns.name} | #{options.title}"
			namespace: ns
			classes: classes
			namespaces: namespaces
			level: if ns.path.length then ("../" for i in [1..ns.path.length]).join('') else ""
			badge: options.badge
			project: options.title
			md: md.parse
	
		mkdirp.sync "#{options.target}/docs/#{ns.path.join '/'}"
		fs.writeFileSync "#{options.target}/docs/#{ns.url}", html
	
	setupClass = (klass) ->
		html = classTemplate
			title: "Class #{klass.name} | #{options.title}"
			klass: klass
			classes: classes
			namespaces: namespaces
			subclasses: (k for name, k of classes when k.extends is klass).sort (a, b) -> a.name.localeCompare b.name
			level: if klass.namespace.length then ("../" for i in [1..klass.namespace.length]).join('') else ""
			badge: options.badge
			project: options.title
			md: md.parse
	
		fs.writeFileSync "#{options.target}/docs/#{klass.url}", html
	
	setupIndex = (text) ->
		html = indexTemplate
			title: options.title
			text: text
			namespaces: namespaces
			level: ""
			badge: options.badge
			project: options.title
			md: md.parse
	
		fs.writeFileSync "#{options.target}/docs/index.html", html
	
	# --- HTML Generator ---
	
	unless fs.existsSync "#{options.target}/docs"
		fs.mkdirSync "#{options.target}/docs"
	else
		rmdir "#{options.target}/docs"

	# prepare class template
	jadeTemplate = fs.readFileSync "#{__dirname}/html/class.jade", 'utf8'
	classTemplate = jade.compile jadeTemplate,
		filename: "#{__dirname}/html/class.jade"

	# prepare namespace template
	jadeTemplate = fs.readFileSync "#{__dirname}/html/namespace.jade", 'utf8'
	nsTemplate = jade.compile jadeTemplate,
		filename: "#{__dirname}/html/namespace.jade"

	# prepare namespace template
	jadeTemplate = fs.readFileSync "#{__dirname}/html/methods.jade", 'utf8'
	methodsTemplate = jade.compile jadeTemplate,
		filename: "#{__dirname}/html/methods.jade"

	# prepare index template
	jadeTemplate = fs.readFileSync "#{__dirname}/html/index.jade", 'utf8'
	indexTemplate = jade.compile jadeTemplate,
		filename: "#{__dirname}/html/index.jade"
	
	classes = []
	namespaces = []
	nsbuilder =
		global:
			name: 'global'
			path: ['global']
			url: "global/index.html"
			classes: []
		
		'':
			name: ''
			path: []
			url: "index.html"
			classes: []
	
	for name, klass of doc.global.classes when klass.namespace.length is 0
		klass.set 'namespace', ['global']
	
	for module in [doc.global].concat doc.modules
		for name, klass of module.classes
			klass.set 'url', "#{klass.namespace.join '/'}#{if klass.namespace.length then "/" else ""}#{klass.name}.html"
			
			nsp = []
			for ns in klass.namespace
				nsp.push ns
				nsbuilder[nsp.join('.')] ?=
					name: nsp.join('.')
					path: nsp.slice 0 # clone
					url: "#{nsp.join '/'}#{if nsp.length then "/" else ""}index.html"
					classes: []

			nsbuilder[nsp.join('.')].classes.push klass
			classes.push klass
	
	# --- Prepare ns, sort ---
	
	for name, ns of nsbuilder
		namespaces.push ns
	
		ns.classes.sort (a, b) ->
			a.name.localeCompare b.name
	
	namespaces.sort (a, b) ->
		a.name.localeCompare b.name
	
	# --- Generate docs ---
	
	for path, ns of namespaces
		setupNamespace ns

	for klass in classes
		setupClass klass
	
	setupMethods [doc.global].concat doc.modules
	if options.index then setupIndex options.index
		
	# copy css (this should be done with cp)
	css = fs.readFileSync "#{__dirname}/html/csdoc.css", 'utf8'
	fs.writeFileSync "#{options.target}/docs/csdoc.css", css
	
	callback null, "Documentation was successfuly created in '#{options.target}/docs'\n"
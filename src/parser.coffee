###
CSDoc Parser

Inspired by https://github.com/omarkhan/coffeedoc
###

coffeescript = require('coffee-script')
util = require 'util'

Module = require './elements/module.js'
Class = require './elements/class.js'
Method = require './elements/method.js'
Parameter = require './elements/parameter.js'
Property = require './elements/property.js'
Event = require './elements/event.js'
Description = require './elements/description.js'

###
Sort key-value object by key names.

@param {Object} object Object to sort.
@returns {Object} Sorted object.
###

sort = (object) ->
	keys = Object.keys(object).sort()
	out = {}
	out[key] = object[key] for key in keys
	out

###
Return type of AST object.

@param {Object} object Coffee-Script AST object.
@returns {String} Object type.
###

typeOf = (object) ->
	object?.constructor.name

module.exports = (files, options, callback) ->
	globals = new Module
	globals.name = "global"
	
	# --- Functions ---

	###
	Import built-in objects.
	
	@param {Module} module Module to load library into.
	@base {String} lib Library name.
	@returns {void}
	###
	
	importLibrary = (module, lib) ->
		try
			{classes, methods} = require "#{__dirname}/../dependencies/#{lib}.json"
		catch ex
			throw new Error "Failed to load dependency '#{lib}': #{ex.message}"
		
		for klass in classes ? []
			k = new Class
			for key, value of klass
				k.set key, value
			
			if k.global
				globals.classes[k.path] = k
			else
				module.classes[k.path] = k
	
		for method in methods ? []
			m = new Method
			for key, value of method
				m.set key, value
			
			if m.global
				globals.methods[m.path] = m
			else
				module.methods[m.path] = m
		
		null

	###
	Parse object name.
	
	@param {Object} variable Coffee-Script AST variable.
	@returns {String} Object name.
	###
	
	parseName = (variable) ->
		name = variable.base.value
		
		if variable.properties.length > 0
			name += ".#{(p.name.value for p in variable.properties).join "."}"
		
		name
	
	###
	Parse comment.
	
	@param {String} comment Comment.
	@returns {String} Updated comment.
	###
	
	parseComment = (comment) ->
		# Replaces `\\#` with `#` to allow for the use of multiple `#` characters in markup languages (e.g. Markdown headers)
		lines = comment.replace(/\\#/g, '#').split '\n'
		
		# Remove leading blank lines
		while /^\s*$/.test lines[0]
			lines.shift()
			
			if lines.length is 0
				return null
		
		# Get least indented non-blank line
		indentation = for line in lines
			if /^\s*$/.test line then continue
			line.match(/^\s*/)[0].length
			
		indentation = Math.min indentation...
		whitespace = new RegExp "^\\s{#{indentation}}"
		
		(line.replace(whitespace, '') for line in lines).join '\n'
	
	###
	Parse method and it's arguments.
	
	@param {Object} node Coffee-Script AST node.
	@param {String} [comment] Comment.
	@param {Class} [defined] Parent Class that owns this method.
	@param {Boolean} [statik] True if method is meant to be static.
	@returns {Method} Parsed method.
	###
	
	parseMethod = (node, comment = null, module = null, defined = null, statik = false) ->
		me = new Method
		
		if options.inner
			if typeOf(node.value.body.expressions[0]) is 'Comment'
				comment = parseComment node.value.body.expressions[0].comment
			else
				comment = null
		
		path = parseName node.variable
		if path.match(/^global\./)
			path = path.replace(/^global\./, '')
			
			unless defined
				me.set 'global', true
			
		if statik then path = path.replace(/^this\./, '')
		me.set 'path', path
	
		me.set 'description', comment
		me.set 'line', node.variable.locationData.first_line + 1
		me.set 'defined', defined
		if module then me.set 'script', module
		
		for param in node.value.params ? []
			p = new Parameter
	
			if param.name.base?.value is 'this'
				p.set 'name', param.name.properties[0].name.value
			
			else
				p.set 'name', param.name.value
				if param.splat then p.set 'n', true
			
			me.params.push p
		
		me = Description me
		
		# method was transformet to class via @class
		if me instanceof Class
			me = Description me
		
		me
	
	###
	Parse class and it's methods and properties.
	
	@param {Object} node Coffee-Script AST node.
	@param {String} [comment] Comment.
	@returns {Class} Parsed class.
	###
	
	parseClass = (node, comment = null, module = null) ->
		me = new Class
	
		if typeOf(node) is 'Assign' then node = node.value
		
		if options.inner
			if typeOf(node.body.expressions[0]?.base) is 'Obj'
				if typeOf(node.body.expressions[0].base.objects[0]) is 'Comment'
					comment = parseComment(node.body.expressions[0].base.objects[0].comment)
				else
					comment = null
			
			else
				if typeOf(node.body.expressions[0]) is 'Comment'
					comment = parseComment(node.body.expressions[0].comment)
				else
					comment = null
	
		path = parseName node.variable
		if path.match(/^global\./)
			path = path.replace(/^global\./, '')
			me.set 'global', true
				
		me.set 'path', path
		me.set 'extends', if node.parent? then parseName(node.parent) else "Object"
		me.set 'description', comment ? null
		me.set 'line', node.variable.locationData.first_line + 1
		if module then me.set 'script', module
		
		for exp in node.body.expressions
			if typeOf(exp) is 'Value' and exp.base.objects
				for obj in exp.base.objects
					if typeOf(obj) is 'Assign' and typeOf(obj.value) is 'Code'
						method = obj
						
						if method.variable.this
							m = parseMethod method, comment, module, me, true
							if m then me.static[m.name] = m
						
						else
							if method.variable.base.value?.charAt(0) is '_'
								m = parseMethod method, comment, module, me
								if m then me.private[m.name] = m
								
							else
								m = parseMethod method, comment, module, me
								if m then me.public[m.name] = m
					
					else if typeOf(obj) is 'Comment'
						comment = parseComment obj.comment
						
					else
						comment = null
			
			else if typeOf(exp) is 'Assign' and typeOf(exp.value) is 'Code'
				if exp.variable.this
					m = parseMethod exp, comment, module, me, true
					if m then me.static[m.name] = m
		
		Description me
	
	###
	Parse module and it's classes and methods.
	
	@param {Object} root Coffee-Script AST root node.
	@param {Object} [file] Loaded file.
	@returns {Module} Parsed module.
	###
	
	parseModule = (root, file = null) ->
		me = new Module
		
		if file?.path
			me.set 'name', if file then require('path').relative(options.source, file.path) else null
			me.set 'file', file.path
		
		for exp in root.expressions
			if typeOf(exp) is 'Class' or typeOf(exp) is 'Assign' and typeOf(exp.value) is 'Class'
				c = parseClass exp, comment, me
				comment = null
				
				if c
					if c.global
						globals.classes[c.path] = c
					else
						me.classes[c.path] = c
					
			else if typeOf(exp) is 'Comment'
				comment = parseComment exp.comment
				
			else
				# orphaned comment
				if comment then Description me, comment
				comment = null
		
		for exp in root.expressions
			if typeOf(exp) is 'Assign' and typeOf(exp.value) is 'Code'
				m = parseMethod exp, comment, me
				comment = null
				
				# method was transformet to class via @class
				if m instanceof Class
					if m.global
						globals.classes[m.path] = m
					else
						me.classes[m.path] = m
				
				else
					if m
						if m.global
							globals.methods[m.path] = m
						else
							me.methods[m.path] = m
	
			else if typeOf(exp) is 'Comment'
				comment = parseComment exp.comment
				
			else
				# orphaned comment
				if comment then Description me, comment
				comment = null
		
		me
	
	# --- Default global.Object ---
	
	globals.classes.Object = new Class
	globals.classes.Object.set 'path', 'Object'
	globals.classes.Object.set 'extends', null
	globals.classes.Object.set 'builtin', true
	globals.classes.Object.set 'global', true
	globals.classes.Object.set 'docs', 'https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object'
	globals.classes.Object.set 'public', [
		name: "constructor"
		description: "Create instance of the class."
		returns: "Object"
	]

	# --- Load dependencies ---

	try
		for dep in options.deps
			importLibrary globals, dep
	
	catch ex
		return callback ex
		
	try
		doc =
			global: globals
			modules: (parseModule(coffeescript.nodes(file.script), file) for file in files)
	
	catch ex
		return callback new Error "Coffee-Script parsing failed: #{ex.message}"
	
	if options.type is 'merge' or options.template is 'html' # always merge with html template (temporarily)
		for module in doc.modules
			for name, klass of module.classes
				doc.global.classes[name] = klass
				
			for name, method of module.methods
				doc.global.methods[name] = method
			
			module.classes = {}
			module.methods = {}
	
	# --- Process classes ---
	
	for module in [doc.global].concat doc.modules
		classes = {}
		processed = {}
		
		if module isnt doc.global
			# globals are processed via module.classes on first iteration
			for name, klass of doc.global.classes
				classes[name] = klass
				processed[name] = true
	
		for name, klass of module.classes
			classes[name] = klass
			
			if not klass.extends or typeof klass.extends isnt 'string'
				processed[name] = true

		# --- Process functions ---
		
		for name, method of module.methods
			if /(.*)\.prototype\.([^\.]*)/.exec(method.path)
				if classes[RegExp.$1]
					classes[RegExp.$1].public[RegExp.$2] = method
					method.set 'namespace', []
					method.set 'defined', classes[RegExp.$1]
					delete module.methods[name]
				
			else if /(.*)\.([^\.]*)/.exec(method.path)
				if classes[RegExp.$1]
					classes[RegExp.$1].static[RegExp.$2] = method
					method.set 'namespace', []
					method.set 'defined', classes[RegExp.$1]
					delete module.methods[name]
		
		# --- Inheritance ---
			
		# we need to make sure we inherit in same order as classes inertits in runtime
		queue = []
		for name, klass of module.classes when klass.extends and typeof klass.extends is 'string'
			unless classes[klass.extends] then processed[klass.extends] = true
			queue.push klass

		while queue.length
			antioverflow = 0
			for klass, index in queue by -1
				if processed[klass.extends]
					antioverflow++
					
					klass.inherit classes[klass.extends]

					queue.splice index, 1
					processed[klass.path] = true
			
			if antioverflow is 0
				for klass in queue when not classes[klass.extends]
					return callback new Error "Class '#{if klass.global then "global." else ""}#{klass.path}' extends unspecified class '#{klass.extends}'"

				return callback new Error "Overflow in parser."

		# --- Final Update ---
		
		for name, klass of module.classes
			if klass.public.constructor
				klass.public.constructor.ctor = true
			
			klass.public = sort klass.public
			klass.static = sort klass.static
			klass.private = sort klass.private
			klass.properties = sort klass.properties
			klass.events = sort klass.events
			
			for coll in [klass.public, klass.private, klass.static]
				for name, method of coll
					if typeof method.returns is 'string' and classes[method.returns] and classes[method.returns] isnt klass
						method.returns = classes[method.returns]
							
					for param in method.params
						if typeof param.type is 'string' and classes[param.type] and classes[method.returns] isnt klass
							param.type = classes[param.type]
	
			for name, prop of klass.properties
				if typeof prop.type is 'string' and classes[prop.type] and classes[method.returns] isnt klass
					prop.type = classes[prop.type]

	callback null, doc
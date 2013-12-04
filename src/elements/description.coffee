Parameter = require './parameter.js'
Property = require './property.js'
Event = require './event.js'
Class = require './class.js'

parseParam = (me, arg, def = "Object") ->
	optional = false
	n = false
	found = false
	
	if arg[0]?.charAt(0) is '{'
		type = arg.shift()
		type = type.substr(1, type.length - 2)
	else
		type = def
	
	name = arg.shift()
	if name.charAt(0) is '['
		name = name.substr(1, name.length - 2)
		optional = true
	if name.substr(0, 3) is '...'
		n = true
		name = name.substr 3
	
	for p in me.params when p.name is name
		found = p
	
	unless found
		found = new Parameter
		found.set 'name', name
		me.params.push found
		
	found.set 'type', type
	found.set 'description', arg.join ' '
	found.set 'optional', optional
	if n then found.set 'n', n
	
	found
	
module.exports = (me) ->
	unless me.description then return me
	unless typeof me.description is 'string' then return me
	
	lines = me.description.split '\n'

	if me.constructor.name is 'Method'
		for line, index in lines when (/^@([^ ]+)[ ]?(.*)$/).exec line
			lines[index] = ''
			arg = RegExp.$2.split ' '

			switch RegExp.$1
				when 'ignore'
					return null
					
				when 'param'
					parseParam me, arg
					
				when 'callback'
					param = parseParam me, arg, "Function"
					
					# Parse callback params
					
					param.set 'params', []
					
					while (/^\s@(param) (.*)$/).exec lines[++index]
						lines[index] = ''
						arg = RegExp.$2.split ' '
						
						parseParam param, arg

				when 'returns'
					type = arg.shift()
					if type.charAt(0) is '{' then type = type.substr(1, type.length - 2)
					
					me.set 'returns', type
				
				when 'version', 'todo', 'see'
					me.set RegExp.$1, arg.join ' '
				
				when 'deprecated'
					me.set 'deprecated', true
				
				when 'path'
					if arg[0] then me.set 'path', arg.shift()
				
				when 'class'
					transform = true
		
		# was method transformed to class via @class ?
		if transform
			klass = new Class
			klass.set 'path', me.path
			klass.set 'line', me.line
			klass.set 'description', me.description
			if me.script then klass.set 'script', me.script
			
			# transform me to constructor
			me.set 'path', 'constructor'
			me.set 'defined', klass
			me.set 'description', null
			klass.set 'public', [me]
			
			return klass
		
		me.set 'description', lines.join '\n'

	else if me.constructor.name is 'Class'
		for line, index in lines when (/^@([^ ]+)[ ]?(.*)$/).exec line
			lines[index] = ''
			arg = RegExp.$2.split ' '

			switch RegExp.$1
				when 'ignore'
					return null
					
				when 'prop', 'property'
					if arg[0]?.charAt(0) is '{'
						type = arg.shift()
						type = type.substr(1, type.length - 2)
					else
						type = "Object"
					
					name = arg.shift()

					prop = me.properties[name] = new Property
					prop.set 'name', name
					prop.set 'type', type
					prop.set 'description', arg.join ' '
					prop.set 'defined', me
					
				when 'event'
					name = arg.shift()

					event = me.events[name] = new Event
					event.set 'name', name
					event.set 'description', arg.join ' '
					event.set 'defined', me
					
				when 'version', 'todo', 'see'
					me.set RegExp.$1, arg.join ' '
				
				when 'path'
					if arg[0] then me.set 'path', arg.shift()
				
				when 'extends'
					if arg[0]?.charAt(0) is '{'
						type = arg.shift()
						type = type.substr(1, type.length - 2)
					else
						type = "Object"
						
					me.set 'extends', type
	
		me.set 'description', lines.join '\n'

	else if me.constructor.name is 'Module'
		for line, index in lines when (/^@([^ ]+)[ ]?(.*)$/).exec line
			lines[index] = ''
			arg = RegExp.$2.split ' '

			switch RegExp.$1
				when 'ignore'
					return null
					
				when 'version', 'todo', 'see'
					me.set RegExp.$1, arg.join ' '
	
		me.set 'description', lines.join '\n'
	
	me
Parameter = require './parameter.js'

###
Base class for all CSDoc methods.

@see Parameter
###

class Method
	constructor: ->
		@params = []
		@namespace = []
		@returns = null
		@line = 0
	
	###
	Property setter.
	
	@param {String} name Property name.
	@param {*} value Property value.	
	###
	
	set: (name, value) ->
		switch name
			when 'path'
				@path = value
				@namespace = @path.split '.'
				@name = @namespace.pop()
			
			when 'name'
				@name = value
				@path = if @namespace.length then "#{@namespace.join '.'}.#{@name}" else @name
			
			when 'namespace'
				@namespace = value
				@path = if value.length then "#{value.join '.'}.#{@name}" else @name
			
			when 'params'
				@params = []
				for param in value
					p = new Parameter
					for k, v of param
						p.set k, v
					
					@params.push p
			
			else
				@[name] = value

module.exports = Method
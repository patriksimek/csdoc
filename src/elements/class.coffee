Method = require './method.js'
Parameter = require './parameter.js'
Property = require './property.js'
Event = require './event.js'

###
Base class for all CSDoc classes.

@see Property
###

class Class
	constructor: ->
		@public = {}
		@private = {}
		@properties = {}
		@events = {}
		@static = {}
		@namespace = []
		@extends = "Object"
		@builtin = false

	###
	Inherit from source class.

	@param {Class} source Source class.
	@returns {Class}
	###
	inherit: (source) ->
		unless source then return

		@extends = source
		
		for name, method of source.public when not @public.hasOwnProperty name
			@public[name] = method

		for name, property of source.properties when not @properties.hasOwnProperty name
			@properties[name] = property
		
		@
	
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
			
			when 'description'
				# remove blank spaces
				@description = if value then value.replace(/^\s+|\s+$/g, '') else value
			
			when 'public', 'private', 'static'
				@[name] = {}
				for method in value
					m = new Method
					m.defined = @
					for k, v of method
						m.set k, v
					
					@[name][m.name] = m
			
			else
				@[name] = value

module.exports = Class
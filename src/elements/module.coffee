class Module
	constructor: ->
		@classes = {}
		@methods = {}
	
	###
	Property setter.
	
	@param {String} name Property name.
	@param {*} value Property value.	
	###
	
	set: (name, value) ->
		@[name] = value

module.exports = Module
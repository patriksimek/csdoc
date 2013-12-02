class Parameter
	constructor: ->
		@n = false
	
	###
	Property setter.
	
	@param {String} name Property name.
	@param {*} value Property value.	
	###
	
	set: (name, value) ->
		switch name
			when 'type'
				if value is '*' then value = "Object"
				if value and typeof value is 'string' and value isnt 'void' then value = value.charAt(0).toUpperCase() + value.substr(1)
				@type = value
			
			else
				@[name] = value
				
module.exports = Parameter
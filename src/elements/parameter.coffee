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
				@type = value
			
			else
				@[name] = value
				
module.exports = Parameter
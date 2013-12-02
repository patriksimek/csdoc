###
Sample file description.
###

fs = require 'fs'

###
Sample class description.
###

class Model
	###
	Sample constructor.
	###
	
	constructor: (type) ->
	
	###
	Sample function.

	@param {*} arg1 Argument1.
	@param {*} arg2 Argument2.
	@param {*} arg3 Argument3.
	###
	
	test: (@arg1, arg2 = {}, arg3...) ->

	###
	Private method.
	###
	
	_priv: (arg) ->
	
	###
	Static method.
	###
	
	@static: ->

###
SuperModel class.
###
class SuperModel extends Model
	###
	SuperModel test.

	@param {*} arg Argument.
	###
	
	test: (arg1) ->

###
Attached method.

@param {*} arg Argument.
###

Model::attached = (arg) ->

###
Attached static method.

@param {String} x Argument.
@param {String} str ArgumentN.
###
Model.staticAttached = (x = "asdf", str...) ->

###
Class created from method.

@class
@param {*} argx Argument of constructor.
###

ExtraModel = (argx) ->
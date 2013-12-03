fs = require 'fs'
csdoc = require '../'
assert = require "assert"

doc = null

describe 'csdoc test suite', ->
	before (done) ->
		fs.readFile "#{__dirname}/../examples/sample.coffee", "utf8", (err, data) ->
			if err then return done err
			
			options =
				template: (parsed, options, callback) -> callback null, parsed
				deps: ['mdn']
			
			csdoc data, options, (err, parsed) ->
				doc = parsed
				done err
		
	it 'core structure', (done) ->
		globals = doc.global
		module = doc.modules[0]
		
		assert.equal globals.classes.Object.builtin, true
		assert.equal globals.classes.Object.public.constructor.returns, globals.classes.Object
		assert.equal module.classes.Model.extends, globals.classes.Object
		assert.equal module.classes.Model.public.constructor.params[0].name, 'type'
		assert.equal module.classes.Model.public.constructor.description, 'Sample constructor.'
		assert.equal module.classes.Model.private._priv.params.length, 1
		assert.equal module.classes.Model.static.static.params.length, 0
		assert.equal module.classes.Model.public.attached.description, 'Attached method.'
		assert.equal module.classes.Model.public.attached.description, 'Attached method.'
		assert.equal module.classes.Model.static.staticAttached.params[1].n, true
		assert.equal module.classes.ExtraModel.public.constructor.params[0].name, 'argx'
		
		done()
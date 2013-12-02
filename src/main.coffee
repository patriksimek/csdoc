fs = require 'fs'
parser = require './parser.js'

module.exports =
	parse: (files, options) ->
		if typeof options.deps is 'string' then options.deps = [options.deps]
		options.source ?= process.cwd()
		options.target ?= process.cwd()
		
		parsed = parser.parse files, options
		require("./templates/#{options.template}.js") parsed, options
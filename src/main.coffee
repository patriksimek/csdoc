fs = require 'fs'
parser = require './parser.js'

module.exports = (files, options, callback) ->
	options.source ?= process.cwd()
	options.target ?= process.cwd()
	
	options.deps ?= []
	if typeof options.deps is 'string'
		options.deps = [options.deps]
		
	if typeof files is 'string'
		files = [{script: files}]
	
	parser files, options, (err, parsed) ->
		if err then return callback err
		
		options.title ?= "CSDoc"
		
		# Custom badge
		
		options.badge ?= ""
		
		# Custom index
		
		if options.index
			options.index = fs.readFileSync require('path').resolve(options.index), 'utf8'
		
		# Custom template
		
		if options.template instanceof Function
			try
				options.template parsed, options, callback
			
			catch ex
				return callback new Error "Error in custom template: #{ex.message}"
		
		else
			try
				require("#{__dirname}/templates/#{options.template}.js") parsed, options, callback
				
			catch ex
				return callback new Error "Failed to load template: #{ex.message}"
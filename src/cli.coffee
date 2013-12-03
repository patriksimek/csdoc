csdoc = require "#{__dirname}/main.js"
fs = require 'fs'
util = require 'util'

readdir = (path, ignore, coll = []) ->
	if fs.existsSync path
		files = fs.readdirSync path
		
		for file in files
			f = require('path').resolve("#{path}/#{file}")
			
			unless f in ignore
				if fs.statSync(f).isDirectory()
					readdir f, ignore, coll
					
				else
					if f.match /\.coffee$/
						coll.push
							path: f
							script: fs.readFileSync f, 'utf8'
	
	coll

optimist = require('optimist')
	.usage('Usage: $0 [script]')
	.describe('d', 'Add dependency (mdn, node)')
	.alias('d', 'dep')
	.describe('i', 'Use inner comments.')
	.alias('i', 'inner')
	.boolean('i')
	.default('i', false)
	.describe('t', 'Use template (json, html)')
	.alias('t', 'template')
	.default('t', 'json')
	.describe('h', 'Show this help')
	.alias('h', 'help')

if optimist.argv.h
	optimist.showHelp()
	console.log "Examples:"
	console.log "  $ csdoc ."
	console.log "  $ csdoc <script.coffee"
	console.log "  $ csdoc <script.coffee >doc.json"
	console.log ""
	return

options =
	template: optimist.argv.t
	join: optimist.argv.j
	source: process.cwd()
	target: process.cwd()
	deps: optimist.argv.d
	inner: optimist.argv.i

fsdoc = (path, ignore = []) ->
	for ig, index in ignore
		ignore[index] = require('path').resolve(ig)
			
	fs.stat path, (err, stat) ->
		if err then return console.error err
		
		if stat.isDirectory()
			options.source = path
			files = readdir path, ignore
			csdoc files, options, (err, docs) ->
				if err
					if optimist.argv.debug
						console.error err.stack
					else
						console.error err.message
						
					process.exit 1
					
				process.stdout.write docs ? "Documentation was successfuly created.\n"
			
		else
			options.source = require('path').dirname path
			data = fs.readFileSync path, 'utf8'
			csdoc [{path: path, script: data}], options, (err, docs) ->
				if err
					if optimist.argv.debug
						console.error err.stack
					else
						console.error err.message
						
					process.exit 1
				
				process.stdout.write docs ? "Documentation was successfuly created.\n"

# --- parse from cli ---

if optimist.argv._.length
	fsdoc require('path').resolve(optimist.argv._[0])
	return

# --- parse from cfg ---

if fs.existsSync "#{process.cwd()}/.csdoc.json"
	options = require "#{process.cwd()}/.csdoc.json"

	fsdoc require('path').resolve(options.source ? process.cwd())
	return

# --- parse from stdio ---

buffer = ''
process.stdin.setEncoding 'utf8'
process.stdin.on 'data', (chunk) ->
	buffer += chunk
	
process.stdin.on 'end', ->
	csdoc buffer, options, (err, docs) ->
		if err
			if optimist.argv.debug
				console.error err.stack
			else
				console.error err.message
				
			process.exit 1
		
		process.stdout.write docs ? "Documentation was successfuly created.\n"
		
.resume()
###
Basic JSON template.
###

util = require 'util'

setupParam = (doc) ->
	name: doc.name
	type: if typeof doc.type is 'object' then doc.type.name else doc.type
	description: doc.description

setupMethod = (doc) ->
	name: if doc.defined then doc.name else doc.path
	params: (setupParam(p) for p in doc.params)
	description: doc.description

setupClass = (doc) ->
	name: doc.path
	extends: doc.extends?.path
	description: doc.description
	builtin: doc.builtin ? false
	public: (setupMethod(m) for n, m of doc.public)
	private: (setupMethod(m) for n, m of doc.private)
	static: (setupMethod(m) for n, m of doc.static)

setupModule = (doc) ->
	name: doc.name
	filename: doc.file
	classes: (setupClass(c) for n, c of doc.classes)
	methods: (setupMethod(m) for n, m of doc.methods)

module.exports = (doc, options) ->
	object =
		global:
			classes: (setupClass(c) for n, c of doc.global.classes)
			methods: (setupMethod(m) for n, m of doc.global.methods)
		modules: (setupModule(m) for m in doc.modules)

	JSON.stringify object
###
Basic JSON template.
###

util = require 'util'

setupParam = (doc) ->
	name: doc.name
	type: if typeof doc.type is 'object' then doc.type.name else doc.type
	description: doc.description
	n: doc.n

setupMethod = (doc, global = false) ->
	name: if doc.defined then doc.name else doc.path
	params: (setupParam(p) for p in doc.params)
	description: doc.description
	global: global

setupClass = (doc, global = false) ->
	name: doc.path
	extends: doc.extends?.path
	description: doc.description
	global: global
	builtin: true
	public: (setupMethod(m) for n, m of doc.public when not m.defined or (m.defined and not m.defined.builtin))
	private: (setupMethod(m) for n, m of doc.private when not m.defined or (m.defined and not m.defined.builtin))
	static: (setupMethod(m) for n, m of doc.static when not m.defined or (m.defined and not m.defined.builtin))

setupModule = (doc) ->
	name: doc.name
	filename: doc.file
	classes: (setupClass(c) for n, c of doc.classes when not c.builtin)
	methods: (setupMethod(m) for n, m of doc.methods when not m.builtin)

module.exports = (doc, options, callback) ->
	dep =
		classes: (setupClass(c, true) for n, c of doc.global.classes when not c.builtin)
		methods: (setupMethod(m, true) for n, m of doc.global.methods when not m.builtin)
	
	for module in doc.modules
		for n, c of module.classes when not c.builtin
			dep.classes.push setupClass c
		
		for n, m of module.methods when not m.builtin
			dep.methods.push setupMethod m

	callback null, JSON.stringify dep
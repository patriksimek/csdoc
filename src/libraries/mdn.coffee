module.exports =
	builtin: true
	classes: [
		name: "Object"
		builtin: true
		global: true
		extends: null
		docs: "https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object"
		public: [
			name: "constructor"
			description: "Create instance of the class."
			returns: "Object"
		]
		static: [
			name: "keys"
			params: [
				name: "obj"
				type: "Object"
				description: "The object whose enumerable own properties are to be returned."
			]
			description: "Returns an array containing the names of all of the given object's own enumerable properties."
			returns: "Array"
		]
	,
		name: "Array"
		builtin: true
		global: true
		extends: "Object"
		docs: "https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array"
		public: [
			name: "slice"
			params: [
				name: "begin"
				type: "Number"
				description: "Zero-based index at which to begin extraction."
			,
				name: "end"
				type: "Number"
				description: "Zero-based index at which to end extraction."
				optional: true
			]
			description: "Extracts a section of an array and returns a new array."
			returns: "Array"
		]
	,
		name: "Number"
		builtin: true
		global: true
		extends: "Object"
		docs: 'https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number'
		
	,
		name: "String"
		builtin: true
		global: true
		extends: "Object"
		docs: 'https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String'
		static: [
			name: "fromCharCode",
			params: [
				name: "num"
				type: "Number"
				description: "A sequence of numbers that are Unicode values."
				n: true
			]
			description: "Returns a string created by using the specified sequence of Unicode values."
			returns: 'String'
		]
	,
		name: "Boolean"
		builtin: true
		global: true
		extends: "Object"
		docs: 'https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Boolean'
	,
		name: "Date"
		builtin: true
		global: true
		extends: "Object"
		docs: 'https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date'
	,
		name: "RegExp"
		builtin: true
		global: true
		extends: "Object"
		docs: 'https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp'
	,
		name: "Function"
		builtin: true
		global: true
		extends: "Object"
		docs: 'https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function'
	,
		name: "Error"
		builtin: true
		global: true
		extends: "Object"
		docs: 'https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error'
	]
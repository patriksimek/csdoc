module.exports =
	builtin: true
	classes: [
		name: "EventEmitter"
		builtin: true
		url: "http://nodejs.org/api/events.html#events_class_events_eventemitter"
		extends: "Object"
		public: [
			name: "addListener"
			params: [
				name: 'event'
				type: 'String'
				description: "Event name."
			,
				name: 'listener'
				type: 'Function'
				description: "Event listener."
			]
			description: "Adds a listener to the end of the listeners array for the specified event. Returns emitter, so calls can be chained."
			returns: "EventEmitter"
		]
		static: [
			name: "listenerCount"
			params: [
				name: 'emitter'
				type: 'EventEmitter'
			,
				name: 'event'
				type: 'String'
			]
			description: "Return the number of listeners for a given event."
			returns: "Number"
		]
	]
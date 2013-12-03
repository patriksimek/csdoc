var csdoc = require('../');

var myCustomTemplate = function(parsed, options, callback) {
	classes = parsed.modules[0].classes
	output = 'Classes found: '+ Object.keys(classes).join(', ')
	
	callback(null, output);
};

var options = {
	template: myCustomTemplate
};

docs = csdoc("###\nMy favorite model.\n###\nclass Model", options, function(err, docs) {
	console.log(docs);
});
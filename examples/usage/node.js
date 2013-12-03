var csdoc = require('../../');

var options = {
	template: "json"
};

docs = csdoc("###\nMy favorite model.\n###\nclass Model", options, function(err, docs) {
	console.log(docs);
});
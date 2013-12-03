var cp = require('child_process');

var csdoc = cp.spawn('csdoc', ['--template', 'json']);

csdoc.stdout.on('data', function(data) {
	console.log('stdout', data.toString());
});
	
csdoc.stderr.on('data', function(data) {
	console.log('stderr', data.toString());
});

csdoc.on('close', function(code) {
	console.log('csdoc process exited with code ' + code);
});

csdoc.stdin.end("###\nMy favorite model.\n###\nclass Model");
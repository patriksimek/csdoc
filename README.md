# CSDoc [![Dependency Status](https://david-dm.org/patriksimek/csdoc.png)](https://david-dm.org/patriksimek/csdoc) [![NPM version](https://badge.fury.io/js/csdoc.png)](http://badge.fury.io/js/csdoc) [![Build Status](https://secure.travis-ci.org/patriksimek/csdoc.png)](http://travis-ci.org/patriksimek/csdoc)

An API documentation generator for CoffeeScript based on JSDoc for JavaScript. Project is work in intensive progress.

Contribution is welcome.

[Live Example](http://csdoc.org) of [examples/sample.coffee](https://github.com/patriksimek/csdoc/blob/master/examples/sample.coffee)

## Installation

    sudo npm install -g csdoc

## Quick Examples

```
$ csdoc ./src
$ csdoc <script.coffee
$ csdoc <script.coffee >docs.json
$ csdoc --template html --dep mdn ./src
```

## Usage

* [Using CSDoc from CLI](https://github.com/patriksimek/csdoc/wiki/Using-CSDoc-from-CLI)
* [Using CSDoc from Node](https://github.com/patriksimek/csdoc/wiki/Using-CSDoc-from-Node)
* [JSON Template](https://github.com/patriksimek/csdoc/wiki/JSON-Template)
* [HTML Template](https://github.com/patriksimek/csdoc/wiki/HTML-Template)
* [CoffeeDoc compatibility](https://github.com/patriksimek/csdoc/wiki/CoffeeDoc-compatibility)

```coffeescript
###
This is a class description.

@property {String} hair Model's hair.
###

class Model extends Object
	hair: "blonde"
	
	###
	This is a constructor description.
	
	@param {String} name Model name.
	###
	
	constructor: (name) ->
```

## Documentation

Complete documentation can be found on [CSDoc wiki](https://github.com/patriksimek/csdoc/wiki)!

<a name="license" />
## License

Copyright (c) 2013 Patrik Simek

The MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

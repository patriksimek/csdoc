# CSDoc [![Dependency Status](https://david-dm.org/patriksimek/csdoc.png)](https://david-dm.org/patriksimek/csdoc) [![NPM version](https://badge.fury.io/js/csdoc.png)](http://badge.fury.io/js/csdoc)

An API documentation generator for CoffeeScript based on JSDoc for JavaScript. Project is work in intensive progress, any serious usage is not recomended!

## Installation

    sudo npm install -g csdoc

## Live Example
[Live Example](http://csdoc.org) of parsed: examples/sample.coffee

## Examples

To create doumentation for one file only:
```
$ csdoc ./src/sample.coffe
```

To create doumentation for all `.coffee` files in folder (recursively):
```
$ csdoc ./src
```

It also operates over stdio.
```
$ csdoc <script.coffee
```

script.coffee:
```coffeescript
###
Class comment.
###
class Model
    ###
    Function comment.
    ###
	test: ->
```
output:
```json
{
  "global": {
    "classes": [
      {
        "builtin": true,
        "name": "Object",
        "private": [],
        "public": [
          {
            "description": "Create instance of the class.",
            "name": "constructor",
            "params": [
              
            ]
          }
        ],
        "static": []
      }
    ],
    "methods": []
  },
  "modules": [
    {
      "classes": [
        {
          "builtin": false,
          "description": "Class comment.\n",
          "extends": "Object",
          "name": "Model",
          "private": [],
          "public": [
            {
              "description": "Create instance of the class.",
              "name": "constructor",
              "params": []
            },
            {
              "description": "Function comment.\n",
              "name": "test",
              "params": []
            }
          ],
          "static": []
        }
      ],
      "methods": []
    }
  ]
}
```

## Documentation

### CSDoc Tags
```
@class										- Create class from method
@event <name> <description>					- Add event to class
@extends <type>								- Override default "extends" directive
@ignore										- Ignore class/method
@param [<type>] <name> <description>		- Add parameter to method
@property [<type>] <name> <description>		- Add property to class
@returns <type>								- Add return value to method
@see <message> 								- TODO: linking
@todo <message>								- Just a todo message
@version <version>							- Version
```

### Base libraries

```
$ csdoc --dep mdn
```

Add JS built-in classes (like String, Function, Number, ...) to docs so data types are linked directly and classes inherits methods from them. More libraries will come soon.

### Output templates

```
$ csdoc --template html
```

There are two templates atm - json (default - stdout only) and html (no stdout). html template create html documentation in `docs` subdirectory of your cwd. All data in `docs` subdirectory are deleted during the process!

### Support for CoffeeDoc style comments

```
$ csdoc --inner
```

```coffeescript
###
Module comment.
###

class Model
    ###
    Class comment.
    ###
    
    test: ->
        ###
        Function comment.
        ###
```

### .csdoc.json

If there is a `.csdoc.json` in cwd, it starts with options loaded from this file.

```
$ csdoc
```

```json
{
    "source": "./src",
    "deps": ["mdn"],
    "template": "html",
    "ignore": [
        "./src/config.coffee",
        "./src/database.coffee"
    ]
}
```

<a name="license" />
## License

Copyright (c) 2013 Patrik Simek

The MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

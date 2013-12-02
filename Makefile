compile:
	@coffee --compile --output ./lib ./src

watch:
	@coffee --compile --watch --output ./lib ./src

test:
	@csdoc --dep mdn -t html <./test/sample.json

test.cfg:
	@csdoc

.PHONY: test
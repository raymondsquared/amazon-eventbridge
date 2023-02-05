.PHONY: clean
clean:
	echo "Cleaning..."
	npm run clean

.PHONY: lint
lint:
	echo "Linting..."
	npm run lint

.PHONY: start
start:
	npm start

.PHONY: start-publisher
 start-publisher:
	npm run start:publisher

.PHONY: test
test:
	npm test

.PHONY: build
build:
	echo "Building..."
	npm run build

.PHONY: package
package:
	echo "Packaging..."
	npm run package

.PHONY: publish
publish:
	echo "Publishing..."

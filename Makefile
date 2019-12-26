.PHONY: public serve static/style.css

node_image = node:12.14.0-alpine

public: static/style.css
	rm -rf public/
	docker run --rm \
		-v $$(pwd):/app \
		-w /app \
		jojomi/hugo:0.30 \
		hugo

serve: static/style.css
	docker run --rm \
		-v $$(pwd):/app \
		-p 1313:1313 \
		-w /app \
		jojomi/hugo:0.30 \
		hugo server --bind=0.0.0.0 --buildDrafts --ignoreCache

static/style.css: node_modules
	docker run --rm \
		-v $$(pwd):/app \
		-w /app \
		$(node_image) \
		./node_modules/.bin/node-sass \
			--output-style \
			compressed \
			./layouts/index.scss > ./static/style.css

node_modules: package.json package-lock.json
	mkdir -p node_modules
	docker run --rm \
		-v $$(pwd):/app \
		-w /app \
		$(node_image) \
		npm install
	touch -m node_modules

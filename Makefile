.PHONY: public serve static/style.css

node_image = node:12.14.0-alpine
hugo_image = jojomi/hugo:0.30.2

public: static/style.css
	rm -rf public/
	docker run --rm \
		-v $$(pwd):/app \
		-w /app \
		$(hugo_image) \
		hugo

serve: static/style.css
	docker run --rm \
		-v $$(pwd):/app \
		-p 1313:1313 \
		-w /app \
		$(hugo_image) \
		hugo server --bind=0.0.0.0 \
			--buildDrafts --ignoreCache --verbose

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

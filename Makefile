.PHONY: public serve static/style.css

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
		hugo server --bind=0.0.0.0 --buildDrafts

static/style.css: node_modules
	docker run --rm \
		-v $$(pwd):/app \
		-w /app \
		node:9.3.0-alpine \
		./node_modules/.bin/node-sass \
			--output-style \
			compressed \
			./layouts/index.scss > ./static/style.css

node_modules: package.json package-lock.json
	mkdir -p node_modules
	docker run --rm \
		-v $$(pwd):/app \
		-w /app \
		node:9.3.0-alpine \
		npm install
	touch -m node_modules

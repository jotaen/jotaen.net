.PHONY: serve clean

public: static/style.css
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

clean:
	rm -rf public/
	rm -f ./static/style.css

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
	docker run --rm \
		-v $$(pwd):/app \
		-w /app \
		node:9.3.0-alpine \
		npm install

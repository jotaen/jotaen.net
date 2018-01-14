.PHONY: serve hugo css css-install

serve:
	docker run --rm \
		-v $$(pwd):/app \
		-p 1313:1313 \
		-w /app \
		jojomi/hugo:0.30 \
		hugo server --bind=0.0.0.0 --buildDrafts

hugo:
	rm -rf public/
	docker run --rm \
		-v $$(pwd):/app \
		-w /app \
		jojomi/hugo:0.30 \
		hugo

css:
	rm -f ./static/style.css
	docker run --rm \
		-v $$(pwd):/app \
		-w /app \
		node:9.3.0-alpine \
		./node_modules/.bin/node-sass \
			--output-style \
			compressed \
			./layouts/index.scss > ./static/style.css

css-install:
	docker run --rm \
		-v $$(pwd):/app \
		-w /app \
		node:9.3.0-alpine \
		npm install

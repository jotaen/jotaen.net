#! /bin/bash

docker run --rm -v $(pwd):/app -p 1313:1313 -w /app jojomi/hugo hugo server --bind=0.0.0.0 --buildDrafts

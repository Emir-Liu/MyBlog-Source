title=tmp

.PHONY: new deploy 

new:
	hexo new "$(title)"
	vim $(title).md

deploy:
	hexo g
	hexo d
	git add -A
	git commit -m"1"
	git push

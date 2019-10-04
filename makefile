title=tmp

.PHONY: new 

new:
	hexo new "$(title)"
	vim $(title).md

deploy:
	hexo g
	hexo d

tf = terraform

functions.zip: http_headers.js
	zip $@ $<

init:
	$(tf) init

create update: init
	$(tf) apply --auto-approve

delete:
	$(tf) destroy --auto-approve

plan:
	$(tf) plan

clean:
	rm -f functions.zip

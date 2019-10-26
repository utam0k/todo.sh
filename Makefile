.PHONY: init test concat clean

init:
	 wget https://raw.githubusercontent.com/kward/shunit2/master/shunit2 -O test/shunit2

install: concat
	cp tmp.sh /usr/local/bin/todo.sh

test: concat
	./test/test.sh

check:
	git ls-files *.sh | xargs shellcheck

plugin:
	./gen_plugins.sh

concat: plugin
	./concat.sh

clean:
	rm tmp.sh test/shunit2

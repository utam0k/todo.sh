.PHONY: init test concat clean

init:
	 wget https://raw.githubusercontent.com/kward/shunit2/master/shunit2 -O test/shunit2

install: concat
	cp build/todo.sh /usr/local/bin/todo.sh

test: concat
	./test/test.sh

check:
	git ls-files *.sh | xargs shellcheck

plugin:
	./gen_plugins.sh build plugins.sh

concat: plugin
	./concat.sh build/todo.sh

clean:
	rm build/todo.sh test/shunit2

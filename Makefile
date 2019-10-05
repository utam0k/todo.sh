.PHONY: init test concat clean

init:
	 wget https://raw.githubusercontent.com/kward/shunit2/master/shunit2 -O test/shunit2

test:
	./test/test.sh \ 
	shellcheck *.sh

concat:
	./concat.sh

clean:
	rm tmp.sh test/shunit2

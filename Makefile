.PHONY: init test concat clean

init:
	 wget https://raw.githubusercontent.com/kward/shunit2/master/shunit2 -O test/shunit2

test: concat
	./test/test.sh

concat:
	./concat.sh

clean:
	rm tmp.sh test/shunit2

test: check
	PATH=".:${PATH}" bats --recursive .

check:
	shellcheck bashcore lib/*.bash

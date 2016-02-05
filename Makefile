all: build

build:
	go build -x

test:
	go test -v && cd yum && go test -v

get-deps:
	go get github.com/mattn/go-sqlite3
	go get golang.org/x/crypto/openpgp
	go get github.com/dvyukov/go-fuzz/go-fuzz
	go get github.com/dvyukov/go-fuzz/go-fuzz-build

rpm-fuzz.zip: *.go
	go-fuzz-build github.com/cavaliercoder/go-rpm

fuzz: rpm-fuzz.zip
	go-fuzz -bin=./rpm-fuzz.zip -workdir=.fuzz/

clean-fuzz:
	rm -rf rpm-fuzz.zip .fuzz/crashers/* .fuzz/suppressions/*

clean: clean-fuzz

.PHONY: all build test get-deps fuzz clean-fuzz clean

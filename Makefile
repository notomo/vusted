ifeq ($(OS),Windows_NT)
	VUSTED := bin\vusted
else
	VUSTED := bin/vusted
endif

test:
	${VUSTED} --shuffle
.PHONY: test

VERSION :=
ROCKSPEC_FILE := rockspec/vusted-${VERSION}-1.rockspec

release: new_rockspec
	luarocks install dkjson
	luarocks upload ${ROCKSPEC_FILE} --temp-key=${LUAROCKS_API_KEY}
.PHONY: release

new_rockspec:
	luarocks new_version rockspec/vusted-x.x.x-1.rockspec --dir rockspec --tag=v${VERSION}
	cat ${ROCKSPEC_FILE}
	luarocks make ${ROCKSPEC_FILE}
.PHONY: new_rockspec

install:
	luarocks make
.PHONY: install

_init:
	luarocks write_rockspec --lua-versions=5.1
.PHONY: _init

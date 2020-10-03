ifeq ($(OS),Windows_NT)
	VUSTED := bin\vusted
else
	VUSTED := bin/vusted
endif

test:
	${VUSTED}
.PHONY: test

TARGET_VERSION := x.x.x
TARGET_FILE := rockspec/vusted-${TARGET_VERSION}-1.rockspec

try:
	$(MAKE) new_rockspec
.PHONY: try

release:
	$(MAKE) new_rockspec
	luarocks install dkjson
	luarocks upload ${TARGET_FILE} --temp-key=${LUAROCKS_API_KEY}
.PHONY: release

new_rockspec:
	luarocks new_version rockspec/vusted-x.x.x-1.rockspec --dir rockspec --tag=v${TARGET_VERSION}
	cat ${TARGET_FILE}
	luarocks make ${TARGET_FILE}
.PHONY: new_rockspec

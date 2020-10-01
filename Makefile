test:
	vusted
.PHONY: test

TARGET_VERSION := x.x.x
release:
	LUAROCKS_API_KEY=${LUAROCKS_API_KEY} lua release.lua ${TARGET_VERSION}
.PHONY: release

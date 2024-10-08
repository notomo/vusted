# vusted

[busted](https://github.com/lunarmodules/busted) wrapper for testing neovim plugin

## Requirements
- neovim

## Installation

```
luarocks --lua-version=5.1 install vusted
```

## Usage

vusted usage is almost the same as busted.

```console
$ vusted
ok 1 - vusted can use vim module
printed
ok 2 - vusted can print
1..2
```

### Helper functions

See [vusted.helper](https://github.com/notomo/vusted/blob/master/lua/vusted/helper.lua)'s function comments.

### Environment variables

- `VUSTED_NVIM`
    - vusted uses this command to execute neovim.
    - default: `nvim`
- `VUSTED_ARGS`
    - vusted uses this arguments to execute neovim.
    - default: `--headless --clean`
- `VUSTED_SLOW`
    - For example if you set 1000, output handler adds summary about the tests that elapsed 1000ms or more.
    - can use only if the output handler is `vusted.default`.
- `VUSTED_USE_LOCAL`
    - Set this flag to true or 1 if vusted was installed locally, e.g., with `luarocks install --local vusted`.
    - default: nil
- `VUSTED_DISABLE_EXIT`
    - vusted does not exit if `VUSTED_DISABLE_EXIT` exists. Use to check neovim state interactively after test execution.
    - example: `VUSTED_DISABLE_EXIT=1 VUSTED_DISABLE_CLEANUP=1 VUSTED_ARGS=--clean vusted --filter 'vusted can print'`
    - default: nil
- `VUSTED_DISABLE_CLEANUP`
    - `vusted.helper.cleanup()` and `vusted.helper.cleanup_loaded_modules()` do nothing if `VUSTED_DISABLE_CLEANUP` exists.
    - default: nil

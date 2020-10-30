@echo off
setlocal

if "%VUSTED_NVIM%"== "" set VUSTED_NVIM=nvim

%VUSTED_NVIM% --headless -u NONE -i NONE -n ^
    --cmd "execute 'source ' .. fnamemodify(resolve('%~dp0'), ':h') .. '/vusted_entry.vim'" ^
    -- %*

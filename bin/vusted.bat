@echo off
setlocal

if "%VUSTED_NVIM%"== "" set VUSTED_NVIM=nvim
if "%VUSTED_ARGS%"== "" set VUSTED_ARGS=--headless -u NONE -i NONE -n

%VUSTED_NVIM% %VUSTED_ARGS% ^
    --cmd "execute 'source ' .. fnamemodify(resolve('%~dp0'), ':h') .. '/vusted_entry.vim'" ^
    -- %*

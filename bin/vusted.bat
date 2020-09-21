
if "%VUSTED_NVIM%"== "" set VUSTED_NVIM=nvim

%VUSTED_NVIM% --headless -u NONE -i NONE -n ^
    --cmd "let &runtimepath = getcwd() .. ',' .. &runtimepath" ^
    --cmd "let &runtimepath = fnamemodify(resolve('%~dp0'), ':h:h') .. ',' .. &runtimepath" ^
    --cmd "call vusted#run()" -- %*

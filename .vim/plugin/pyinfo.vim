if exists("g:loaded_pyinfo")
    finish
endif
let g:loaded_pyinfo = 1

set runtimepath+=~/.vim/plugin/pyinfo
python3 import pyinfo

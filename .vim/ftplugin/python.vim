
setlocal tabstop=4
setlocal shiftwidth=4

" 1 - kwargs and dict  {'key': 'value'} => {key='value'}
" 2 - kwargs and dict  {key='value'}    => {'key': 'value'}
" 3 - import \k+ => from \k import
" 4 - from \k import => import \k+
let b:switch_custom_definitions =
    \ [
    \   {
    \       '\(\k\+\)=\([^),]\+\)': '''\1'': \2',
    \       '[''"]\(\k\+\)[''"]:\s*\([^},]\+\)': '\1=\2',
    \       'import\s\+\(\k\+\)': 'from \1 import ',
    \       'from\s\+\(\k\+\)\s\+import\s.*$': 'import \1',
    \       '"\@<!\<\(\w*\)\>': '_\1',
    \       '"\@<!\<_\(\w*\)\>': '\1',
    \   }
    \ ]

" \dp = remove pdb
nnoremap <buffer> <Leader>dp :%g/set_trace\(\)/d<cr>

function s:pyinfo_find_symbol_clip(return_as)
    let result = pyinfo#find_symbol(a:return_as)
    call file#clip(result, 1)
endfunction

function s:pytest_for_function_clip()
    if FugitiveWorkTree() == ''
        return
    endif
    let filepath = FugitivePath(@%, '')
    let func = expand("<cword>")
    let result = "pytest " . filepath . " -k " . func
    call file#clip(result, 1)
endfunction

" \cy = copy python path of current symbol
nnoremap <buffer> <Leader>cy :call <SID>pyinfo_find_symbol_clip("import")<cr>

" \cp = copy file path of current symbol
nnoremap <buffer> <Leader>cp :call <SID>pyinfo_find_symbol_clip("path")<cr>

" \ct = copy test spec of current symbol
" pytest <filename> -k func
nnoremap <buffer> <Leader>ct :call <SID>pytest_for_function_clip()<cr>

abbr <buffer> true True
abbr <buffer> false False

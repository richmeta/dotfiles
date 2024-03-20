
function! pyinfo#find_symbol(return_as)
    let current = expand('<cword>')
    let proj_root = fnamemodify(FugitiveGitDir(), ':h')
    let buffer_path = expand("%:p")
    let pyinfo_result = ""
    python3 pyinfo.find_symbol(vim.eval('proj_root'), vim.eval('buffer_path'), vim.eval('current'), vim.eval('a:return_as'))
    return pyinfo_result
endfunction

function! pyinfo#find_symbol_pypath()
    return pyinfo#find_symbol("pypath")
endfunction

function! pyinfo#find_symbol_path()
    return pyinfo#find_symbol("path")
endfunction

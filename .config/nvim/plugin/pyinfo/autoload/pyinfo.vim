
function! pyinfo#find_symbol(return_as)
    " TODO: cWORD support
    let current = expand('<cword>')
    if exists("g:pyinfo_project_root")
        " override project root
        " where python modules are not in git root
        let proj_root = g:pyinfo_project_root
    else
        let proj_root = FugitiveWorkTree()
    endif
    let buffer_path = expand("%:p")
    let pyinfo_result = ""
    let extra_imports = exists('g:pyinfo_extra_imports') ? g:pyinfo_extra_imports : ""
    python3 pyinfo.find_symbol(vim.eval('proj_root'), vim.eval('buffer_path'), vim.eval('current'), vim.eval('a:return_as'), vim.eval('extra_imports'))
    return pyinfo_result
endfunction

function! pyinfo#find_symbol_pypath()
    return pyinfo#find_symbol("pypath")
endfunction

function! pyinfo#find_symbol_path()
    return pyinfo#find_symbol("path")
endfunction

function! pyinfo#find_symbol_as_import()
    return pyinfo#find_symbol("import")
endfunction


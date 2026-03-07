
function! pyinfo#find_symbol(return_as)
    " <cword> dotted symbols, eg some_module.some_func
    " needs . in iskeyword
    let iskw = &iskeyword
    set iskeyword+=.

    " setup vars
    if exists("g:project_root")
        let proj_root = g:project_root
    else
        let proj_root = FugitiveWorkTree()
    endif
    let buffer_path = expand("%:p")
    let pyinfo_result = ""
    let extra_imports = exists('g:pyinfo_extra_imports') ? g:pyinfo_extra_imports : ""

    " always logs to /tmp/pyinfo.log
    " use g:pyinfo_debug=1 for more
    if exists("g:pyinfo_debug")
        python3 pyinfo.enable_debug_logging(vim.eval('g:pyinfo_debug'))
    endif

    " get the symbol and call
    let current = expand('<cword>')
    python3 pyinfo.find_symbol(vim.eval('proj_root'), vim.eval('buffer_path'), vim.eval('current'), vim.eval('a:return_as'), vim.eval('extra_imports'))

    " restore iskeyword
    let &iskeyword = iskw
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

function! pyinfo#find_symbol_as_starimport()
    return pyinfo#find_symbol("starimport")
endfunction



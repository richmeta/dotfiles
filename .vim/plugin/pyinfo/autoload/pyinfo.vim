
function! pyinfo#find_symbol(return_as)
    let current = expand('<cword>')
    let proj_root = <SID>find_project_root()
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

function! s:find_project_root()
    " use this in preference to FugitiveGitDir()
    " because under git worktree its a different directory
    " (in this case .git is a file in the worktree)
    let dir = expand('%:p:h')

    while 1
        if filereadable(dir . "/.git") || filereadable(dir . '/pyproject.toml')
            return dir
        endif
        let dir = fnamemodify(dir, ':h') " Move up one directory
        if dir ==# ''
            echo 'Project root not found.'
            return ''
        endif
    endwhile
endfunction

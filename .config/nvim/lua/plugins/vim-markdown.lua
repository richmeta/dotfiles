
return {
    "preservim/vim-markdown",
    
    config = function()
        vim.g.vim_markdown_folding_disabled = 1
        vim.g.vim_markdown_no_default_key_mappings = 1
        vim.g.vim_markdown_conceal = 0
        vim.g.vim_markdown_conceal_code_blocks = 0 
        vim.g.vim_markdown_math = 0
        vim.g.vim_markdown_frontmatter = 1
    end,
}

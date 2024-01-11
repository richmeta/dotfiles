return {
	"nvim-lualine/lualine.nvim",

	dependencies = { "kyazdani42/nvim-web-devicons" },

    opts = {}

}

-- TODO:  lightline OR lualine OR galaxyline?
--  glepnir/galaxyline.nvim
-- OR 'itchyny/lightline.vim'


-- TODO:  from lightline 
-- let g:lightline = {
--     \   'active': {
--     \       'left': [ [ 'mode', 'paste' ],
--     \               [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
--     \       'right': [ [ 'percent', 'lineinfo' ],
--     \                  [ 'fileformat', 'filetype', 'ALEenabled' ] ]
--     \   },
--     \   'component_function': {
--     \       'gitbranch': 'FugitiveHead',
--     \       'ALEenabled': 'LightLineALEEnabled',
--     \   },
--     \ }

-- function! LightLineALEEnabled() abort
--     if getbufvar('', 'ale_enabled', get(g:, 'ale_enabled', 0))
--         return 'lint'
--     else
--         return ''
--     endif
-- endfunction



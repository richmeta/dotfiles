local plugins = {
    -- essential
    { "nvim-lua/plenary.nvim" },

    -- treesitter
    { "nvim-treesitter/nvim-treesitter" },                      -- yes
    { "nvim-treesitter/playground" },

    -- lsp
    { "williamboman/mason.nvim", opts = {}, build = ":MasonUpdate" },
    { "williamboman/mason-lspconfig.nvim" },                    -- yes
    { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },    -- yes
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/nvim-cmp" },                                     -- yes
    { "saadparwaiz1/cmp_luasnip" },
    { "lvimuser/lsp-inlayhints.nvim" },                         -- yes
    { "ray-x/lsp_signature.nvim" },                             -- yes
    { "folke/trouble.nvim" },

    -- linters
    { "mfussenegger/nvim-lint" },                               -- yes

    -- TODO: configure
    -- { "ThePrimeagen/harpoon" },

    -- git
    { "tpope/vim-fugitive" },                                   -- yes

    -- commenting
    { "numToStr/Comment.nvim", opts = {} },

    -- files, buffers
    { "justinmk/vim-dirvish" },                                 -- yes
    { "nvim-telescope/telescope.nvim" },                        -- yes
    { "nvim-telescope/telescope-ui-select.nvim" },
    { "tpope/vim-projectionist" },                              -- yes

    -- highlighting
    { "t9md/vim-quickhl" },                                     -- yes

    -- status line
    { "nvim-lualine/lualine.nvim" },                            -- yes

    -- edits
    { "kylechui/nvim-surround", opts = {} },
    { "AndrewRadev/switch.vim" },                               -- yes
    { "godlygeek/tabular" },

    -- python
    { "Vimjas/vim-python-pep8-indent", ft = "python" },

    -- terminal
    { "akinsho/toggleterm.nvim" },                              -- yes

    -- markdown
    { "preservim/vim-markdown" },

    -- tmux
    { "christoomey/vim-tmux-navigator" },

    -- TEXT OBJECTS

    -- al = whole line (motion)
    -- il = line without leading ws (motion)
    { "kana/vim-textobj-line", dependencies = { "kana/vim-textobj-user" } },

    -- i, = parameter only (motion)
    -- a, = parameter with comma (motion)
    { "sgur/vim-textobj-parameter", dependencies = { "kana/vim-textobj-user" } },

    -- ae = whole file (motion)
    -- ie = whole file without leading/trailing ws (motion)
    { "kana/vim-textobj-entire", dependencies = { "kana/vim-textobj-user" } },

    -- ac = column on word (motion)
    -- aC = column on WORD (motion)
    -- ic = inner column on word (motion)
    -- iC = inner column on WORD (motion)
    { "coderifous/textobj-word-column.vim", dependencies = { "kana/vim-textobj-user" } },

    -- ai = indentation level and line above  (motion)
    -- ii = inner indentation level no line above (motion)
    -- aI = indentation level and above/below lines (motion)
    -- iI = inner indentation level no lines above/below (motion)
    { "michaeljsmith/vim-indent-object", dependencies = { "kana/vim-textobj-user" } },

    -- iv = inner variable segment (motion)
    -- av = inner variable segment (motion)
    { "Julian/vim-textobj-variable-segment",  dependencies = { "kana/vim-textobj-user" } },
}

-- load any local plugins, from user/localplugins.lua
-- eg return {   { "another-plugin", config = {..} } }
local ok, localplugins = pcall(require, 'user.localplugins')
if not ok then
    localplugins = {}
end

vim.list_extend(plugins, localplugins)
return plugins

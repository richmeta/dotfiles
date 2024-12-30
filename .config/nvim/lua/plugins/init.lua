local plugins = {
    -- essential
    { "nvim-lua/plenary.nvim" },

    -- vim localrc
    { "marcweber/vim-addon-local-vimrc" },

    -- treesitter
    { "nvim-treesitter/nvim-treesitter" },                      -- yes

    -- lsp
    { "williamboman/mason.nvim", opts = {}, build = ":MasonUpdate" },
    { "williamboman/mason-lspconfig.nvim" },                    -- yes
    { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },    -- yes
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-nvim-lsp-signature-help" },
    { "hrsh7th/nvim-cmp" },                                     -- yes
    { "saadparwaiz1/cmp_luasnip" },
    { "lvimuser/lsp-inlayhints.nvim" },                         -- yes
    { "folke/trouble.nvim" },                                   -- yes

    -- linters
    { "mfussenegger/nvim-lint" },                               -- yes

    -- git
    { "tpope/vim-fugitive" },                                   -- yes

    -- commenting
    { "numToStr/Comment.nvim", opts = {} },

    -- files, buffers
    { "justinmk/vim-dirvish" },                                 -- yes
    { "nvim-telescope/telescope.nvim" },                        -- yes
    { "nvim-telescope/telescope-ui-select.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" }
    },
    { "nvim-telescope/telescope-frecency.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" }
    },
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

    -- af = function including definition
    -- if = function without definition
    -- ac = A class
    -- ic = inner class
    -- TODO: clashes with vim-indent-object, see
    -- https://github.com/bps/vim-textobj-python?tab=readme-ov-file#configuration
    { "bps/vim-textobj-python", dependencies = { "kana/vim-textobj-user" } },
}


local los = require("user.os")
if los.tmux_enabled then
    -- tmux (yes)
    table.insert(plugins, { "christoomey/vim-tmux-navigator" })
else
    -- kitty (yes)
    table.insert(plugins, {
        "knubie/vim-kitty-navigator",

        build = "cp *.py ~/.config/kitty",
    })
end

-- load any local plugins, from user/localplugins.lua
-- eg return {   { "another-plugin", config = {..} } }
local ok, localplugins = pcall(require, 'user.localplugins')
if not ok then
    localplugins = {}
end

vim.list_extend(plugins, localplugins)
return plugins

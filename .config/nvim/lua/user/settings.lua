local los = require("user.os")

local o   = vim.o       -- set: options
local opt = vim.opt     -- lua api for options, lists etc

-- if vim.loader then
--     vim.loader.enable()
-- end

o.hidden = true
o.backup = false
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.wrap = false
o.visualbell = false
o.errorbells = false
o.expandtab = true
o.ignorecase = true
o.smartcase = true
o.hlsearch = false
o.autowrite = true
o.modelines = 5
o.backspace="indent,eol,start"
o.background = "dark"
o.history = 10000
o.ruler = true
o.incsearch = true
o.autoindent = true
o.smartindent = true
o.smarttab = true
o.report = 0
o.whichwrap = "b,s,h,l,<,>,~,[,]"
o.startofline = false
o.sidescroll = 5
o.sidescrolloff = 10
o.scrolloff = 2
o.statusline = '%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]'
o.winminheight = 0
o.shiftround = true
o.showcmd = true
opt.matchpairs:append("<:>")
opt.iskeyword:append("-")
o.wildmenu = true
opt.wildignore:append { "*.sw*", "*.pyc", "node_modules", "tags", "__pycache__", ".DS_Store", ".git" }
o.shellslash = true
o.laststatus = 2
o.keymodel = "startsel"
opt.listchars = {
    tab = "→ ",
    trail = "␣",
    extends = "❯",
    precedes = "❮",
    nbsp = "⍽",
    conceal = "~",
    eol = "$"
}
o.splitbelow = true
o.splitright = true
o.joinspaces = false
o.shada = "!,'1000,<50,s20,h"
o.tags = "./tags,tags;"
o.shortmess = o.shortmess .. "I"        -- no intro message
o.showmatch = true
o.matchtime = 1
o.isfname = o.isfname .. ",32"          -- allow space in filenames
o.tabpagemax = 50
o.tagbsearch = true
o.fixendofline = false
o.mouse = "a"
o.selection = "inclusive"
o.dictionary = los.nvim_config_dir .. "/dict/dict.txt"
o.pastetoggle = "<Leader>ps"
o.autoread = false
opt.diffopt:append("algorithm:patience")

if vim.fn.executable('rg') then
    o.grepprg = "rg --vimgrep --no-heading"
end

-- aliases under terminal
vim.env.BASH_ENV = '~/.bash_aliases'

vim.cmd.filetype("plugin indent on")
vim.cmd.colorscheme("iceberg")

if los.is_neovide then
    vim.g.neovide_remember_window_size = true

    -- enables <M-x> mappings
    vim.g.neovide_input_macos_alt_is_meta = true

    --  disable IME, eg <m-n>
    vim.g.neovide_input_ime = false
end

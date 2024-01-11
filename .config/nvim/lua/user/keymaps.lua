local mp = require("user.map")
local util = require("user.util")
local file = require("user.file")
local buffer = require("user.buffer")
local los = require("user.os")
local tg = require("user.toggler")

-- local setup
local silent = { silent = true }
local noremap = mp.noremap
local cnoremap = mp.cnoremap
local inoremap = mp.inoremap
local nnoremap = mp.nnoremap
local onoremap = mp.onoremap
local snoremap = mp.snoremap
local tnoremap = mp.tnoremap
local vnoremap = mp.vnoremap
local xnoremap = mp.xnoremap
local map = mp.map
local cmap = mp.cmap
local imap = mp.imap
local nmap = mp.nmap
local tmap = mp.tmap

-- is X os executable
local executable = vim.fn.executable

--
-- MAPPINGS
--

-- ctrl-c = clipboard copy
vnoremap("<C-C>", [["+y]])

-- ctrl-x = clipboard cut
vnoremap("<C-X>", [["+x]])

-- ctrl-v = clipboard paste
map("<C-V>", [["+gP]])
cmap("<C-V>", "<C-R>+")

-- Use CTRL-Q to do what CTRL-V used to do
-- ctrl-q = blockwise visual select
noremap("<C-Q>", "<C-V>")

local paste_i = "<C-g>u" .. vim.g["paste#paste_cmd"]["i"]
local paste_v = vim.g["paste#paste_cmd"]["v"]
inoremap("<C-V>", paste_i, { script = true })
vnoremap("<C-V>", paste_v, { script = true })

-- Use CTRL-S for saving, also in Insert mode (<C-O> doesn't work well when using completions).
-- ctrl-s = save
noremap("<C-S>", ":update<CR>")
vnoremap("<C-S>", "<C-C>:update<CR>")
inoremap("<C-S>", "<Esc>:update<CR>gi")

-- ctrl-a = select all
noremap("<C-A>", "gggH<C-O>G")
onoremap("<C-A>", "<C-C>gggH<C-O>G")
snoremap("<C-A>", "<C-C>gggH<C-O>G")
xnoremap("<C-A>", "<C-C>ggVG")

-- \tt = new tab
nnoremap("<Leader>tt", ":tabnew<cr>")

-- \td = duplicate tab
nnoremap("<Leader>td", ":tab split<cr>")

-- \T = new scratch
nnoremap("<Leader>T", ":tabnew<bar>setlocal buftype=nofile<cr>")

-- alt-x = tabclose
nnoremap("<Leader>tc", ":tabclose<cr>")

-- \to = only this tab
nnoremap("<Leader>to", ":tabonly<cr>")

-- \o = tabedit file
nnoremap("<Leader>o", ":tabedit<space>")

-- \wn = split window search cword
nnoremap("<Leader>wn", ":let @/=expand('<cword>')<bar>split<bar>normal n<cr>")

-- \wN = split window search cword + boundary
nnoremap("<Leader>wN", [[:let @/='\<'.expand('<cword>').'\>'<bar>split<bar>normal n<cr>]])

-- \sw = start search/replace word under cursor
nnoremap("<Leader>sw", [[:%s/<c-r><c-w>/]])

-- \xf = format xml
if executable("xml_pp") then
    -- xml_pp = xml pretty print from XML::Twig
    nnoremap("<Leader>xf", ":silent %!xml_pp - <cr>")
    vnoremap("<Leader>xf", ":!xml_pp - <cr>")
end

-- \hf = format html
if executable("html_pp") then
    -- html_pp = html pretty print using Beautiful Soup
    nnoremap("<Leader>hf", ":silent %!html_pp - <cr>")
    vnoremap("<Leader>hf", ":!html_pp - <cr>")
end

if executable("python3") then
    -- \jf = format json
    nnoremap(
        "<Leader>jf",
        ":silent %!python3 -c 'import sys,json;print(json.dumps(json.loads(sys.stdin.read()),sort_keys=False,indent=4))' - <cr><cr>:setf json<cr>"
    )
    vnoremap(
        "<Leader>jf",
        ":!python3 -c 'import sys,json;print(json.dumps(json.loads(sys.stdin.read()),sort_keys=False,indent=4))' - <cr><cr>"
    )

    -- \pF = format pprint
    nnoremap(
        "<Leader>pF",
        ":silent %!python3 -c 'import sys, pprint; pprint.PrettyPrinter(indent=2, compact=True).pprint(eval(sys.stdin.read()))' - <cr><cr>"
    )
    vnoremap(
        "<Leader>pF",
        ":!python3 -c 'import sys, pprint; pprint.PrettyPrinter(indent=2).pprint(eval(sys.stdin.read()))' - <cr><cr>"
    )
end

if executable("base64") then
    -- \bf = format base64
    vnoremap("<Leader>bf", [[y:let @"=system('base64 -d', @")<cr>gvP]])
end

if executable("erlfmtx") then
    -- \ef = format with erlfmt
    nnoremap("<Leader>ef", ":silent %!erlfmtx --print-width 120 - <cr><cr>")
    vnoremap("<Leader>ef", ":!erlfmtx --print-width 120 - <cr><cr>")
elseif executable("erlfmt") then
    -- fallback
    nnoremap("<Leader>ef", ":silent %!erlfmt --print-width 120 - <cr><cr>")
    vnoremap("<Leader>ef", ":!erlfmt --print-width 120 - <cr><cr>")
end

if executable("black") then
    -- \pf = format black
    nnoremap("<Leader>pf", ":%!black -q - <cr><cr>")
    vnoremap("<Leader>pf", ":!black -q - <cr><cr!")
end

-- shift-F1 - help current word
nnoremap("<S-F1>", function()
    local cmd = "help " .. util.expand("<cword>")
    util.execute(cmd)
end)

vnoremap("<S-F1>", [[:<C-U>execute 'help '.getline("'<")[getpos("'<")[2]-1:getpos("'>")[2]-2]<cr>]])

-- \ye = copy EOL into clipboard
nnoremap("<Leader>ye", '"+y$')

-- \yy = copy whole line into clipboard
nnoremap("<Leader>yy", 'm`^"+y$``')

-- alt-v = select whole line excl newline
nnoremap("<m-v>", "^vg_")

-- \yp = copy inner paragraph into clipboard
nnoremap("<Leader>yp", '"+yip')

-- \y = copy into clipboard
vnoremap("<Leader>y", '"+y')

-- \lf = Location open
noremap("<Leader>lf", ":lopen<cr>")

-- \lc = Location close
noremap("<Leader>lc", ":lclose<cr>")

-- \dw = remove trailing whitespace
nnoremap("<Leader>dw", [[:%s/\s\+$//g<cr>``]])
vnoremap("<Leader>dw", [[:s/\s\+$//g<cr>``]])

-- \- = ruler
nnoremap("<Leader>-", "o<Esc>80a-<Esc>")

-- \= ruler
nnoremap("<Leader>=", "o<Esc>80a=<Esc>")

-- \rm = Remove file + confirm
nnoremap("<Leader>rm", function()
    file.delete("%")
end)

-- \pw = Pwd
nnoremap("<Leader>pw", ":pwd<cr>")

-- \pb = print directory of current buffer
nnoremap("<Leader>pb", ':echo expand("%:h")<cr>')

-- \wd = set working dir to buffer
nnoremap("<Leader>wd", function()
    util.execute("cd ", buffer.dir())
    util.execute("pwd")
end)

-- \ss - save all
nnoremap("<Leader>ss", ":wa<cr>")

-- \us = Unique sort whole file
nnoremap("<Leader>us", ":%!sort -u<cr>")
vnoremap("<Leader>us", ":!sort -u<cr>")

-- \vs = Visual sort
vnoremap("<Leader>vs", ":sort<cr>")

-- \vrc - open vimrc
nnoremap("<Leader>vrc", function()
    local fn = los.nvim_config_dir .. "/lua/user/init.lua"
    vim.cmd.tabedit(fn)
end)

-- \vso = reload vimrc manually
nnoremap("<Leader>vso", function()
    for name, _ in pairs(package.loaded) do
        if name:match("^user") and not name:match("nvim-tree") then
            package.loaded[name] = nil
        end
    end

    -- reloads init.lua
    vim.api.nvim_command(":luafile ~/.config/nvim/init.lua")
    vim.notify("Nvim configuration reloaded!", vim.log.levels.INFO)
end)

-- \db = toggle show debug
nnoremap("<leader>db", tg.toggle({
    source = "g:show_debug"
}))

-- \ms = messages
nnoremap("<Leader>ms", ":messages<cr>")

-- \mc = messages clear
nnoremap("<Leader>mc", ":messages clear<cr>")

-- \sc = scratch buffer
nnoremap("<Leader>sc", ":setlocal buftype=nofile<cr>")

-- operator i/ and a/ around slashes
onoremap("i/", ":<C-U>normal! T/vt/<cr>", silent)
onoremap("a/", ":<C-U>normal! F/vf/<cr>", silent)
xnoremap("i/", ":<C-U>normal! T/vt/<cr>", silent)
xnoremap("a/", ":<C-U>normal! F/vf/<cr>", silent)

-- ctrl-a = emacs begin of line (commandmode)
cnoremap("<C-A>", "<Home>")

-- ctrl-e = emacs begin of line (commandmode)
cnoremap("<C-E>", "<End>")

-- ctrl-k = emacs delete to eol (commandmode)
cnoremap("<c-k>", "<C-\\>estrpart(getcmdline(),0,getcmdpos()-1)<cr>")

-- ctrl-e = eol (ins)
imap("<c-e>", "<c-o>$")

-- ctrl-a = home (ins)
imap("<c-a>", "<c-o>^")

-- w!! = sudo write
cnoremap("w!!", "w !sudo tee > /dev/null %")

-- Y = yank to EOL
nmap("Y", "y$")

-- forward/back to space
nmap("gw", "f<space>")
nmap("gb", "F<space>")

-- Ctrl-E/Ctrl-Y scroll up/down
nmap("<C-up>", "<C-y>")
imap("<C-up>", "<C-o><C-y>")
nmap("<C-down>", "<C-e>")
imap("<C-down>", "<C-o><C-e>")

-- CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
-- so that you can undo CTRL-U after inserting a line break.
inoremap("<C-U>", "<C-G>u<C-U>")

-- Next/Previous file
-- ctrl-n = next file
-- ctrl-p = prev file
nnoremap("<c-n>", util.ex("next"))
nnoremap("<c-p>", util.ex("prev"))

-- Buffer switching
nmap("L", util.ex("bn"))
nmap("H", util.ex("bp"))

-- Buffer delete
-- Q = delete buffer unless modified
nmap("Q", util.ex("bd"), silent)

-- alt-q = delete buffer unconditionally
nmap("<M-q>", util.ex("bd!"), silent)

-- ctrl-alt-q = delete buffer unconditionally + close tab
nmap("<C-M-q>", util.ex({ ":bd!", "tabclose" }), silent)

-- ctrl-bs (ins) = delete word back
imap("<C-BS>", "<C-O>diw")

-- alt-p (ins) put from " register
-- alt-P (ins) PUT from " register
inoremap("<m-p>", '<C-R><C-R>"')
inoremap("<m-P>", '<C-O>h<C-R><C-R>"')

-- alt-p (cmd) put from " register
cnoremap("<m-p>", '<C-R><C-R>"')

-- Window switching

-- ctrl-k = move to window
-- ctrl-j = move to window
-- ctrl-h = move to window
-- ctrl-l = move to window
-- under tmux-navigator

-- copypath
-- \cd = copy directory/path (and "f)
-- \cf = copy fullpath (and "f)
-- \cv = copy filename only (and "f)
-- \cs = copy stem (and "f)
nmap("<Leader>cd", function()
    file.clip({ typ = "dir", showmsg = true })
end, silent)

nmap("<Leader>cf", function()
    file.clip({ typ = "full", showmsg = true })
end, silent)

nmap("<Leader>cv", function()
    -- filename only
    file.clip({ typ = "filename", showmsg = true })
end, silent)

nmap("<Leader>cs", function()
    file.clip({ typ = "stem", showmsg = true })
end, silent)

-- <ctrl-c><ctrl-d> (ins) = insert directory/path
-- <ctrl-c><ctrl-f> (ins) = insert fullpath
-- <ctrl-c><ctrl-v> (ins) = insert filename only
-- <ctrl-c><ctrl-s> (ins) = insert stem
imap("<C-C><C-D>", function()
    if buffer.has_filetype() then
        util.insert_text(buffer.dir())
    end
end, silent)
imap("<C-C><C-F>", function()
    if buffer.has_filetype() then
        util.insert_text(buffer.full())
    end
end, silent)
imap("<C-C><C-V>", function()
    if buffer.has_filetype() then
        util.insert_text(buffer.filename())
    end
end, silent)
imap("<C-C><C-S>", function()
    if buffer.has_filetype() then
        util.insert_text(buffer.stem())
    end
end, silent)

-- Ctrl-\ = (terminal) exit insertmode
-- <esc> interferes with terminal
tnoremap("<C-\\>", [[<C-\><C-n>]])

-- prevent Ctrl-S freeze
tmap("<C-S>", "<Nop>")

-- \mt = open terminal at this dir
map("<Leader>mt", [[:let $VIM_DIR=expand('%:p:h')<cr>:terminal<cr>cd $VIM_DIR<cr>]])

-- \dt = diffthis
nnoremap("<Leader>dt", tg.toggle({
    setting = "diff",
    handler = function(current)
        local cmd = current and "diffoff" or "diffthis"
        vim.cmd[cmd]()
        vim.notify(cmd, vim.log.levels.INFO)
    end
}))

--
-- map toggles
--

-- F2 = toggle spell
nnoremap("<F2>", tg.toggle("spell"))

-- \ws = toggle wrapscan
nnoremap("<Leader>ws", tg.toggle("wrapscan"))

-- F6 = syntax on/off
nnoremap("<F6>", tg.toggle({
    source = function()
        return vim.fn.exists("syntax_on") == 1
    end,
    handler = function(syntax_on)
        util.debug("enabled = ", syntax_on)
        if syntax_on == true then
            util.execute("syntax off")
        else
            util.execute("syntax enable")
        end
    end
}))

-- F7 = toggle hlsearch
nnoremap("<F7>", tg.toggle("hlsearch"))

-- F8 = toggle wrap
nnoremap("<F8>", tg.toggle("wrap"))

-- F9 = toggle list
nnoremap("<F9>", tg.toggle("list"))

-- shift-F8 = toggle number
nnoremap("<S-F8>", tg.toggle("number"))

-- shift-F9 = toggle relativenumber
nnoremap("<S-F9>", tg.toggle("relativenumber"))

-- F10 = toggle scrollbind
nnoremap("<F10>", tg.toggle("scrollbind"))

-- F11 = toggle ignorecase
nnoremap("<F11>", tg.toggle("ignorecase"))

-- F12 = toggle quickfix
nnoremap("<F12>", tg.toggle({
    source = function()
        local ids = vim.fn.getqflist({ winid = 1 })
        return ids.winid
    end,
    handler = function(winid)
        if winid ~= 0 then
            vim.cmd.cclose()
        else
            vim.cmd(":botright copen")
        end
    end
}))

-- \ps = toggle paste
nnoremap("<Leader>ps", tg.toggle("paste"))

-- \cc = toggle cursorcolumn
nnoremap("<Leader>cc", tg.toggle("cursorcolumn"))

-- \sl = toggle selection (exclusive/inclusive)
nnoremap("<Leader>sl", tg.toggle({
    setting = "selection",
    choices = { "inclusive", "exclusive" }
}))

-- \ar = toggle autoread
nnoremap("<Leader>ar", tg.toggle("autoread"))

-- \kd = toggle '.' in `iskeyword`
-- or vim.b.lang_dot to override
nnoremap("<Leader>kd", tg.toggle({
    setting = "iskeyword",
    choices = function()
        local dot = vim.b.lang_dot or "."
        return { dot, "" }
    end,
}))

nnoremap("<Leader><C-]>", function()
    local word = util.expand("<cWORD>")
    util.execute("tab tjump " .. word)
end, silent)

nnoremap("<m-1>", "1gt")
nnoremap("<m-2>", "2gt")
nnoremap("<m-3>", "3gt")
nnoremap("<m-4>", "4gt")
nnoremap("<m-5>", "5gt")
nnoremap("<m-6>", "6gt")
nnoremap("<m-7>", "7gt")
nnoremap("<m-8>", "8gt")
nnoremap("<m-9>", "9gt")

if los.is_mac then
    -- support Cmd+C/V
    map("<D-v>", "<C-v>", { remap = true } )
    imap("<D-v>", "<C-v>", { remap = true } )
    cmap("<D-v>", "<C-v>", { remap = true } )
    map("<D-c>", "<C-c>", { remap = true } )
    imap("<D-c>", "<C-c>", { remap = true } )
end

-- \no = Nopen current filetype
nnoremap("<leader>no", function()
    local cmd = string.format("Nopen %s", vim.bo.filetype)
    util.execute(cmd)
end)

-- \ne = enew buffer
nnoremap("<leader>ne", ":enew<cr>")

-- \nv = vnew buffer vertical
nnoremap("<leader>nv", ":vnew<cr>")

-- \ns = new buffer split
nnoremap("<leader>ns", ":new<cr>")

-- resize windows
nnoremap("<S-Up>", "<cmd>resize +2<CR>")
nnoremap("<S-Down>", "<cmd>resize -2<CR>")
nnoremap("<S-Left>", "<cmd>vertical resize -2<CR>")
nnoremap("<S-Right>", "<cmd>vertical resize +2<CR>")

-- quickfix
nnoremap("[q", ":cprevious<cr>")
nnoremap("]q", ":cnext<cr>")
nnoremap("[Q", ":cfirst<cr>")
nnoremap("]Q", ":clast<cr>")


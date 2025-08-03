-- TODO: not working, terminal?
-- local highlightListChars = vim.api.nvim_create_augroup("HighlightListChars", { clear = true })
-- vim.api.nvim_create_autocmd("ColorScheme", {
--     vim.api.nvim_set_hl(0, "InputHighlight", { fg = "#ffffff", ctermfg = 255, bg = "#00ff00", ctermbg = 14 }),
--     command = "highlight Specialkey guibg=lightgreen",
--     group = highlightListChars
-- })


-- set default formatoptions for all buffers
--    -ro = dont insert comment leader for newlines
local group = vim.api.nvim_create_augroup("AutoCommands", { clear = true })
vim.api.nvim_create_autocmd({"BufNewFile", "BufReadPost"}, {
    pattern = "*",
    group = group,
    callback = function()
        vim.opt_local.formatoptions:remove { "r", "o" }
    end,
})

local function check_leave_snippet()
    -- Check if the mode changed from insert to normal or vice versa
    if (vim.v.event.old_mode == 'i' and vim.v.event.new_mode == 'n') or (vim.v.event.old_mode == 'n' and vim.v.event.new_mode == 'i') then
        local ls = require("luasnip")
        -- Check if LuaSnip is currently active in a jump session
        if ls.session.current_nodes[vim.api.nvim_get_current_buf()] and not ls.session.jump_active then
            -- Unlink the current snippet
            ls.unlink_current()
        end
    end
end

vim.api.nvim_create_autocmd({"ModeChanged"}, {
    pattern = "*",
    group = group,
    callback = function()
        check_leave_snippet()
    end,
})

-- TODO: noswap for WIKI

        -- autocmd BufWinEnter,BufRead * :call <SID>check_sync_dir()
-- function! s:check_sync_dir()
--     if strlen($WIKIDIR)
--         let buff_dir = fnamemodify(expand('%:p:h'), ":p") " with trailing slash
--         let dirs = map(split($WIKIDIR, "[,:]"), {_, fnam -> fnamemodify(fnam, ":p")})
--         for d in dirs
--             if match(buff_dir, d) > -1
--                 setlocal noswapfile
--             endif
--         endfor
--     endif
-- endfunction
--

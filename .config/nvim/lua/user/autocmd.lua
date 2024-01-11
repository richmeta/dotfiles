local api = vim.api


-- TODO: not working, terminal?
-- local highlightListChars = api.nvim_create_augroup("HighlightListChars", { clear = true })
-- api.nvim_create_autocmd("ColorScheme", {
--     vim.api.nvim_set_hl(0, "InputHighlight", { fg = "#ffffff", ctermfg = 255, bg = "#00ff00", ctermbg = 14 }),
--     command = "highlight Specialkey guibg=lightgreen",
--     group = highlightListChars
-- })


-- set default formatoptions for all buffers
-- -ro dont insert comment leader for newlines
local group_format_opts = api.nvim_create_augroup("FormatOpts", { clear = true })
api.nvim_create_autocmd({"BufNewFile", "BufReadPost"}, {
    pattern = "*",
    group = group_format_opts,
    callback = function()
        vim.opt_local.formatoptions:remove { "r", "o" }
    end,
})

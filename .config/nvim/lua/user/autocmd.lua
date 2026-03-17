

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

-- Snippets: check if the mode changed from insert to normal or vice versa
vim.api.nvim_create_autocmd({"ModeChanged"}, {
    pattern = "*",
    group = group,
    callback = function()
        if (vim.v.event.old_mode == 'i' and vim.v.event.new_mode == 'n') or (vim.v.event.old_mode == 'n' and vim.v.event.new_mode == 'i') then
            local ls = require("luasnip")
            -- Check if LuaSnip is currently active in a jump session
            if ls.session.current_nodes[vim.api.nvim_get_current_buf()] and not ls.session.jump_active then
                -- Unlink the current snippet
                ls.unlink_current()
            end
        end
    end
})

-- disable swapfiles in .wiki files
vim.api.nvim_create_autocmd({"BufWinEnter", "BufRead"}, {
    pattern = "*",
    group = group,
    callback = function()
        local file = require("user.file")
        local los = require("user.os")
        local buffer_fn = vim.fn.expand("%")
        if file.is_child_of(buffer_fn, los.wiki_dir) then
            vim.bo.swapfile = false
        end
    end
})

-- disable folding in diffs
vim.api.nvim_create_autocmd({"OptionSet"}, {
    pattern = "diff",
    group = group,
    callback = function()
        vim.wo.foldenable = false
    end
})

-- mark whitespace on `set list`
vim.api.nvim_create_autocmd({"ColorScheme"}, {
    pattern = "*",
    command = "highlight Whitespace guibg=green",
    group = group,
})

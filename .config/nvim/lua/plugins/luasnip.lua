local los = require("user.os")

local function snippet_load()
    require("luasnip.loaders.from_lua").lazy_load()
    vim.notify("reloaded snippets", vim.log.levels.INFO)
end

local function snippet_edit()
    local fn = string.format("%s/luasnippets/%s.lua", los.nvim_config_dir, vim.bo.filetype)
    vim.cmd.tabedit(fn)
end

return {
    "L3MON4D3/LuaSnip",

    config = function()
        local ls = require("luasnip")

        ls.config.setup({
            history = true,
            update_events = { "TextChanged", "TextChangedI" },
            enable_autosnippets = true,
            store_selection_keys = "<Tab>",
        })
        require("luasnip.loaders.from_lua").lazy_load()
    end,

    keys = {
        { "<leader>sr", snippet_load, mode = "n" },
        { "<leader>se", snippet_edit, mode = "n" },
    },
}

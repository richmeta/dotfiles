
local function lint_enabled()
    local lint = 0
    if vim.b.lint_enabled == true then
        local linters = require("lint").get_running()
        if #linters ~= 0 then
            return "…"
        else
            lint = 1
        end
    end

    if vim.diagnostic.is_enabled() then
        lint = lint + 1
    end

    if lint == 1 then
        return "†"
    elseif lint == 2 then
        return "‡"
    end
    return ""
end

return {
    "nvim-lualine/lualine.nvim",

    dependencies = { "kyazdani42/nvim-web-devicons" },

    config = function()
        local lualine = require('lualine')
        local opts = lualine.get_config()
        opts.options.theme = 'iceberg'
        table.insert(opts.sections.lualine_z, lint_enabled)
        lualine.setup(opts)
    end
}


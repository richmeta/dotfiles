local cmp = require("cmp")

local function has_words_before()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return {
    "hrsh7th/nvim-cmp",

    opts = {
        completion = {
            autocomplete = false,
        },
        snippet = {
            expand = function(args)
                local ls = require("luasnip")
                ls.lsp_expand(args.body)
            end,
        },
        window = {
            -- completion = cmp.config.window.bordered(),
            -- documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
            ["<C-p>"] = cmp.mapping.scroll_docs(-4),
            ["<C-n>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<cr>"] = cmp.mapping.confirm({ select = false }),

            ["<Tab>"] = cmp.mapping(function(fallback)
                local ls = require("luasnip")
                if ls.expand_or_jumpable() then
                    ls.expand_or_jump()
                elseif cmp.visible() then
                    cmp.select_next_item()
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end, { "i", "s" }),

            ["<S-Tab>"] = cmp.mapping(function(fallback)
                local ls = require("luasnip")
                    if ls.jumpable(-1) then
                        ls.jump(-1)
                    elseif cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
            end, { "i", "s" }),

            ["<C-j>"] = cmp.mapping(function(fallback)
                local ls = require("luasnip")
                if ls.choice_active() then
                    ls.change_choice(1)
                else
                    fallback()
                end
            end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
        }, {
            { name = "buffer" },
        }),
    },
}


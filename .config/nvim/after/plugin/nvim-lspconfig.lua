local lsp = require("lspconfig")
local mp = require("user.map")
local buffer = require("user.buffer")
local tg = require("user.toggler")
-- local util = require("user.util")

-- capabilities
-- ['textDocument/hover'] = { 'hoverProvider' },
-- ['textDocument/signatureHelp'] = { 'signatureHelpProvider' },
-- ['textDocument/definition'] = { 'definitionProvider' },
-- ['textDocument/implementation'] = { 'implementationProvider' },
-- ['textDocument/declaration'] = { 'declarationProvider' },
-- ['textDocument/typeDefinition'] = { 'typeDefinitionProvider' },
-- ['textDocument/documentSymbol'] = { 'documentSymbolProvider' },
-- ['textDocument/prepareCallHierarchy'] = { 'callHierarchyProvider' },
-- ['callHierarchy/incomingCalls'] = { 'callHierarchyProvider' },
-- ['callHierarchy/outgoingCalls'] = { 'callHierarchyProvider' },
-- ['textDocument/rename'] = { 'renameProvider' },
-- ['textDocument/prepareRename'] = { 'renameProvider', 'prepareProvider' },
-- ['textDocument/codeAction'] = { 'codeActionProvider' },
-- ['textDocument/codeLens'] = { 'codeLensProvider' },
-- ['codeLens/resolve'] = { 'codeLensProvider', 'resolveProvider' },
-- ['workspace/executeCommand'] = { 'executeCommandProvider' },
-- ['workspace/symbol'] = { 'workspaceSymbolProvider' },
-- ['textDocument/references'] = { 'referencesProvider' },
-- ['textDocument/rangeFormatting'] = { 'documentRangeFormattingProvider' },
-- ['textDocument/formatting'] = { 'documentFormattingProvider' },
-- ['textDocument/completion'] = { 'completionProvider' },
-- ['textDocument/documentHighlight'] = { 'documentHighlightProvider' },
-- ['textDocument/semanticTokens/full'] = { 'semanticTokensProvider' },
-- ['textDocument/semanticTokens/full/delta'] = { 'semanticTokensProvider' },

--------------------------------------------------------------------------------
local group = vim.api.nvim_create_augroup("LSPAutoCmd", {})

local function with_tab(mapfn, mapping, action)
    mapfn(mapping, function()
        vim.cmd("tab split")
        if type(action) == "function" then
            action()
        elseif type(action) == "string" then
            vim.cmd.execute(action)
        end
    end)
end


local function on_attach(client, bufnr)
    if client.supports_method("textDocument/inlayHint") then
        require("lsp-inlayhints").on_attach(client, bufnr)
    end

    if client.supports_method("textDocument/definition") then
        -- gd = goto definition (lsp)
        mp.nmap_b("gd", vim.lsp.buf.definition)
        mp.vmap_b("gd", vim.lsp.buf.definition)
        with_tab(mp.nmap_b, "tgd", vim.lsp.buf.definition)
    end

    if client.supports_method("textDocument/declaration") then
        -- gD = goto declaration (lsp)
        mp.nmap_b("gD", vim.lsp.buf.declaration)
        mp.vmap_b("gD", vim.lsp.buf.declaration)
        with_tab(mp.nmap_b, "tgD", vim.lsp.buf.declaration)
    end

    if client.supports_method("textDocument/hover") then
        -- K = hover signature (lsp)
        mp.nmap_b("K", vim.lsp.buf.hover)
    end

    if client.supports_method("textDocument/typeDefinition") then
        -- td = goto type declaration (lsp)
        mp.nmap_b("td", vim.lsp.buf.type_definition)
        mp.vmap_b("td", vim.lsp.buf.type_definition)
        with_tab(mp.nmap_b, "ttd", vim.lsp.buf.type_definition)
    end

    if client.supports_method("textDocument/implementation") then
        -- gi = goto implementation (lsp)
        mp.nmap_b("gi", vim.lsp.buf.implementation)
        mp.vmap_b("gi", vim.lsp.buf.implementation)
        with_tab(mp.nmap_b, "tgi", vim.lsp.buf.implementation)
    end

    if client.supports_method("textDocument/references") then
        -- gr = show references (lsp)
        mp.nmap_b("gr", vim.lsp.buf.references)
    end

    if client.supports_method("textDocument/rename") then
        -- \rn = goto declaration (lsp)
        mp.nmap_b("<leader>rn", vim.lsp.buf.rename)
    end

    if client.supports_method("textDocument/codeLens") then
        -- \ca = run code action (lsp)
        mp.nmap_b("<leader>ca", function()
            vim.lsp.codelens.run()
        end)

        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "CursorHold", "InsertLeave" }, {
            group = group,
            pattern = "<buffer>",
            callback = function()
                vim.lsp.codelens.refresh()
            end,
        })
    end

    if client.supports_method("textDocument/signatureHelp") then
        -- ctrl-k = signature help (lsp)
        mp.nmap_b("<Leader>sh", vim.lsp.buf.signature_help)
    end

    if client.supports_method("textDocument/rangeFormatting") then
        -- ctrl-F5 = format code (lsp)
        mp.vmap_b("<C-f5>", vim.lsp.buf.format)
    end

    if client.supports_method("textDocument/formatting") then
        -- ctrl-F5 = format code (lsp)
        mp.nmap_b("<C-f5>", vim.lsp.buf.format)
    end

    -- gF = diagnostics float (lsp)
    mp.nmap_b("gF", vim.diagnostic.open_float)

    -- \gq = errors to quickfix (lsp)
    mp.nmap_b("<leader>gq", vim.diagnostic.setqflist)

    -- [g = prev error (lsp)
    mp.nmap_b("[g", vim.diagnostic.goto_prev)

    -- ]g = next error (lsp)
    mp.nmap_b("]g", vim.diagnostic.goto_next)
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

lsp.pyright.setup({
    capabilities = capabilities,
    on_attach = on_attach,
})

lsp.rust_analyzer.setup({
    on_attach = on_attach,
    settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true
            },
        }
    }
})

lsp.tsserver.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    single_file_support = true,
    init_options = {
        preferences = {
            includeCompletionsWithSnippetText = true,
            includeCompletionsWithInsertText = true,
        },
    },
    settings = {
        completions = {
            completeFunctionCalls = true,
        },
        typescript = {
            inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            },
        },
        javascript = {
            inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            },
        },
    },
})

lsp.lua_ls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            telemetry = {
                enable = false,
            },
        },
    },
})

lsp.clangd.setup({
    capabilities = capabilities,
    on_attach = on_attach,
})

-- Ctrl-F5 - toggle LSP errors
local toggle_diagnostics = tg.toggle({
    source = function()
        return vim.diagnostic.is_disabled()
    end,
    handler = function(is_disabled)
        local buffer_id = buffer.id()
        if is_disabled then
            vim.diagnostic.enable(buffer_id)
        else
            vim.diagnostic.disable(buffer_id)
        end
    end
})

mp.nnoremap("<F5>", toggle_diagnostics)
mp.inoremap("<F5>", toggle_diagnostics)

-- lsp uses tagfunc = vim.lsp.tagfunc
vim.o.tags = ""

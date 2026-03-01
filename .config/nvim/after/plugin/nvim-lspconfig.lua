local ts = require("telescope.builtin")
local mp = require("user.map")
local tg = require("user.toggler")
local fn = mp.fn_term

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
local lspgroup = vim.api.nvim_create_augroup("LSPAutoCmd", { clear = true })
local handlers =  {
  ["textDocument/hover"] =  vim.lsp.buf.hover({border = "single"}),
  ["textDocument/signatureHelp"] =  vim.lsp.buf.signature_help({border = "single" }),
}

local function with_view(view, mapfn, mapping, action)
    mapfn(mapping, function()
        if view == 't' then
            vim.cmd("tab split")
        elseif view == 'v' then
            vim.cmd("vsplit")
        elseif view == 's' then
            vim.cmd("split")
        end
        if type(action) == "function" then
            action()
        elseif type(action) == "string" then
            vim.cmd.execute(action)
        end
    end)
end

-- called from LspAttach below
local function on_attach(client, bufnr)
    -- by default disable diagnostics
    vim.diagnostic.enable(false)
    vim.lsp.inlay_hint.enable(false)

    if vim.lsp.codelens.enable then
        -- comes in v12
        vim.lsp.codelens.enable(false)
    end

    if client:supports_method("textDocument/definition") then
        -- gd = goto definition (lsp)
        mp.nmap_b("gd", ts.lsp_definitions)
        mp.vmap_b("gd", ts.lsp_definitions)

        -- tgd = tab goto definition (lsp)
        with_view('t', mp.nmap_b, "tgd", ts.lsp_definitions)

        -- vgd = vsplit goto definition (lsp)
        with_view('v', mp.nmap_b, "vgd", ts.lsp_definitions)

        -- sgd = split goto definition (lsp)
        with_view('s', mp.nmap_b, "sgd", ts.lsp_definitions)
    end

    if client:supports_method("textDocument/declaration") then
        -- gD = goto declaration (lsp)
        mp.nmap_b("gD", vim.lsp.buf.declaration)
        mp.vmap_b("gD", vim.lsp.buf.declaration)

        -- tgD = tab goto declaration (lsp)
        with_view('t', mp.nmap_b, "tgD", vim.lsp.buf.declaration)

        -- vgD = vsplit goto declaration (lsp)
        with_view('v', mp.nmap_b, "vgD", vim.lsp.buf.declaration)

        -- sgD = split goto declaration (lsp)
        with_view('s', mp.nmap_b, "sgD", vim.lsp.buf.declaration)
    end

    if client:supports_method("textDocument/hover") then
        -- K = hover signature (lsp)
        mp.nmap_b("K", vim.lsp.buf.hover)
        mp.imap_b("<c-k>", vim.lsp.buf.hover)
    end

    if client:supports_method("textDocument/typeDefinition") then
        -- td = goto type declaration (lsp)
        mp.nmap_b("td", ts.lsp_type_definitions)
        mp.vmap_b("td", ts.lsp_type_definitions)

        -- ttd = tab type declaration (lsp)
        with_view('t', mp.nmap_b, "ttd", ts.lsp_type_definitions)

        -- vtd = vsplit type declaration (lsp)
        with_view('v', mp.nmap_b, "vtd", ts.lsp_type_definitions)

        -- std = split type declaration (lsp)
        with_view('s', mp.nmap_b, "std", ts.lsp_type_definitions)
    end

    if client:supports_method("textDocument/implementation") then
        -- gi = goto implementation (lsp)
        mp.nmap_b("gi", ts.lsp_implementations)
        mp.vmap_b("gi", ts.lsp_implementations)

        -- tgi = tab goto implementation (lsp)
        with_view('t', mp.nmap_b, "tgi", ts.lsp_implementations)

        -- vgi = vsplit goto implementation (lsp)
        with_view('v', mp.nmap_b, "vgi", ts.lsp_implementations)

        -- sgi = split goto implementation (lsp)
        with_view('s', mp.nmap_b, "sgi", ts.lsp_implementations)
    end

    if client:supports_method("textDocument/references") then
        -- gr = show references (lsp)
        mp.nmap_b("gr", ts.lsp_references)
    end

    if client:supports_method("textDocument/rename") then
        -- \rn = goto declaration (lsp)
        mp.nmap_b("<leader>rn", vim.lsp.buf.rename)
    end

    if client:supports_method("textDocument/signatureHelp") then
        -- \m-k = signature help (lsp)
        mp.nmap_b("<m-k>", vim.lsp.buf.signature_help)
        mp.imap_b("<m-k>", vim.lsp.buf.signature_help)
    end

    if client:supports_method("textDocument/rangeFormatting") then
        -- ctrl-F5 = format code (lsp)
        mp.vmap_b(fn("<C-f5>"), vim.lsp.buf.format)
    end

    if client:supports_method("textDocument/formatting") then
        -- ctrl-F5 = format code (lsp)
        mp.nmap_b(fn("<C-f5>"), vim.lsp.buf.format)
    end

    if client:supports_method("textDocument/prepareCallHierarchy") then
        -- \lic = lsp incoming references (telescope)
        mp.nmap("<Leader>lic", "<cmd>Telescope lsp_incoming_calls<CR>")

        -- \loc = lsp outgoing references (telescope)
        mp.nmap("<Leader>loc", "<cmd>Telescope lsp_outgoing_calls<CR>")
    end

    -- \lrf = lsp references (telescope)
    mp.nmap("<Leader>lrf", "<cmd>Telescope lsp_references<CR>")

    -- \ds = document symbols (buffer)
    mp.nmap("<leader>ds", ts.lsp_document_symbols)

    -- \dS = document symbols (global)
    mp.nmap("<leader>dS", ts.lsp_dynamic_workspace_symbols)

    -- gF = diagnostics float (lsp)
    mp.nmap_b("gF", vim.diagnostic.open_float)

    -- \gq = errors to quickfix (lsp)
    mp.nmap_b("<leader>gq", vim.diagnostic.setqflist)

end

local toggle_diagnostics = tg.toggle({
    source = function()
        return vim.diagnostic.is_enabled()
    end,
    handler = function(is_enabled)
        vim.diagnostic.enable(not is_enabled)
    end
})

vim.lsp.config('clangd', {handlers = handlers})
vim.lsp.enable('clangd')

vim.lsp.config('gopls', {handlers = handlers})
vim.lsp.enable('gopls')

vim.lsp.config('jedi_language_server', {
    init_options = {
        completion = {
            disableSnippets = true,
        },
    }
})
vim.lsp.enable('jedi_language_server')

vim.lsp.config('lua_ls', {
    handlers = handlers,
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
vim.lsp.enable('lua_ls')

vim.lsp.config('ruff', {
    handlers = handlers,
    init_options = {
        settings = {
            lint = {enable = true},
            format = {enable = true},
            logLevel = "info",
        },
    },
})
vim.lsp.enable('ruff')

vim.lsp.config('rust_analyzer', {
    handlers = handlers,
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
vim.lsp.enable('rust_analyzer')


vim.lsp.config('ts_ls', {
    handlers = handlers,
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
vim.lsp.enable('ts_ls')

vim.lsp.config('zls', {
    handlers = handlers,
})
vim.lsp.enable('zls')

-- F5 = toggle LSP errors
mp.nnoremap("<F5>", toggle_diagnostics)
mp.inoremap("<F5>", toggle_diagnostics)

-- lsp uses tagfunc (see vim.lsp.tagfunc)
vim.o.tags = ""

vim.api.nvim_create_autocmd("LspAttach", {
    group = lspgroup,
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        on_attach(client, bufnr)
    end,
})

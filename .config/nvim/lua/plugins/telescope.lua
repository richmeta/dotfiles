return {
    "nvim-telescope/telescope.nvim",

    config = function()
        local telescope = require('telescope')
        local actions = require('telescope.actions')

        telescope.setup{
            defaults = {
                path_display = { "absolute" },
                preview = false,
                layout_strategy = "bottom_pane",
                layout_config = {
                    bottom_pane = {
                        height = 15,
                        prompt_position = "bottom"
                    }
                },
                selection_strategy = "reset",
                sorting_strategy = "descending",
                dynamic_preview_title = true,
                border = true,
                color_devicons = true,
                -- file_ignore_patterns = {},
                mappings = {
                    i = {
                        -- tab = Toggle selection and move to next selection (telescope)
                        -- ctrl-tab = Toggle selection and move to prev selection (telescope)

                        -- ctrl-h = help mappings (telescope)
                        ["<C-h>"] = "which_key",
                        ["<esc>"] = actions.close,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,

                        -- ctrl-t = Go to a file in a new tab (telescope)
                        ["<C-t>"] = actions.select_tab,

                        -- ctrl-v = Go to file selection as a vsplit (telescope)
                        ["<C-v>"] = actions.select_vertical,

                        -- ctrl-x = Go to file selection as a split (telescope)
                        ["<C-x>"] = actions.select_horizontal,

                        -- ctrl-w = send selected results to quick fix (telescope)
                        ["<C-w>"] = actions.send_selected_to_qflist,

                        -- ctrl-q = send all results to quick fix (telescope)
                        ["<C-q>"] = actions.send_to_qflist,
                        ["<F7>"] = actions.delete_buffer
                    }
                }
            },
            pickers = {
                buffers = {
                    sort_mru = true,
                    ignore_current_buffer = false,
                    show_all_buffers = true,
                },
                git_commits = {
                    preview = true,
                },
                help_tags = {
                    preview = true,
                }
            },
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_cursor(),
                },
            }
        }

        telescope.load_extension("ui-select")

        -- workaround purple
        -- https://github.com/nvim-telescope/telescope.nvim/issues/2145
        vim.cmd([[:hi NormalFloat ctermfg=LightGrey]])
    end,

    keys = {
        -- see also: after/plugin/telescope.lua

        -- \f = mru files (telescope)
        { "<leader>f", "<cmd>Telescope oldfiles<cr>", desc = "mru files" },

        -- \z = buffers (telescope)
        { "<leader>z", "<cmd>Telescope buffers<cr>", desc = "buffers" },

        -- \lrf = lsp references (telescope)
        { "<Leader>lrf", "<cmd>Telescope lsp_references<CR>", desc = "Lsp references" },

        -- \lic = lsp incoming references (telescope)
        { "<Leader>lic", "<cmd>Telescope lsp_incoming_calls<CR>", desc = "Lsp Incoming references" },

        -- \loc = lsp outgoing references (telescope)
        { "<Leader>loc", "<cmd>Telescope lsp_outgoing_calls<CR>", desc = "Lsp Outgoing references" },

        -- \dg = diagnostics
        { "<Leader>dg", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },

        -- \cs = colorscheme (telescope)
        { "<Leader>cs", "<cmd>Telescope colorscheme<CR>", desc = "Switch colorscheme", },

        -- \hl = help tags (telescope)
        { "<Leader>hl", "<cmd>Telescope help_tags<CR>", desc = "Search help", },
    },
}


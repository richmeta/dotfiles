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
                        ["<C-q>"] = function(...)
                            local args = {...}
                            actions.send_to_qflist(unpack(args))
                            vim.cmd("copen")
                        end,
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
                    require("telescope.themes").get_dropdown(),
                },
                frecency = {
                    auto_validate = true,
                    db_safe_mode = false,
                    hide_current_buffer = true,
                    ignore_patterns = { "*/.git", "*/.git/*", "*/.DS_Store", "fugitive:*" },
                },
            }
        }

        telescope.load_extension("ui-select")
        telescope.load_extension("frecency")

        -- workaround purple
        -- https://github.com/nvim-telescope/telescope.nvim/issues/2145
        vim.cmd([[:hi NormalFloat ctermfg=LightGrey]])
    end,

    keys = {
        -- see also: after/plugin/telescope.lua

        -- \f = mru files (telescope)
        { "<leader>f", "<cmd>Telescope frecency<cr>", desc = "mru files" },

        -- \F = mru files CWD (telescope)
        { "<leader>F", "<cmd>Telescope frecency workspace=CWD<cr>", desc = "mru files from cwd" },

        -- \z = buffers (telescope)
        { "<leader>z", "<cmd>Telescope buffers<cr>", desc = "buffers" },


        -- \dg = diagnostics
        { "<Leader>dg", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },

        -- \cs = colorscheme (telescope)
        { "<Leader>cs", "<cmd>Telescope colorscheme<CR>", desc = "Switch colorscheme", },

        -- \hl = help tags (telescope)
        { "<Leader>hl", "<cmd>Telescope help_tags<CR>", desc = "Search help", },
    },
}


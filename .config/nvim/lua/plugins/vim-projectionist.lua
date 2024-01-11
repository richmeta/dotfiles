return {
    "tpope/vim-projectionist",

    lazy = false,

    config = function()
        vim.g.projectionist_heuristics = {
            ["src/*.cpp"] = {
                ["*.cpp"] = {
                    alternate = {
                        "include/{basename}.hpp",
                        "include/{basename}.h",
                    },
                    type = "source"
                },
            },
            ["include/*.hpp"] = {
                ["*.hpp"] = {
                    alternate = {
                        "src/{basename}.cpp",
                    },
                    type = "source"
                },
            },

            ["src/*.c"] = {
                ["*.c"] = {
                    alternate = {
                        "include/{basename}.h",
                    },
                    type = "source"
                },
            },
            ["include/*.h"] = {
                ["*.h"] = {
                    alternate = {
                        "src/{basename}.c",
                    },
                    type = "source"
                },
            },

            ["*"] = {
                ["*.c"] = {
                    alternate = "{}.h",
                    type = "source"
                },
                ["*.h"] = {
                    alternate = "{}.c",
                    type = "source"
                },
                ["*.cpp"] = {
                    alternate = "{}.hpp",
                    type = "source"
                },
                ["*.hpp"] = {
                    alternate = "{}.cpp",
                    type = "source"
                },
            }
        }
    end,

    keys = {
        {"<Leader>al", ":A<cr>", mode = "n", noremap = true},
    }
}

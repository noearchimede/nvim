return {

    'nvim-telescope/telescope.nvim',

    branch = '0.1.x',

    dependencies = { 'nvim-lua/plenary.nvim' },


    keys = function()

        local builtin = require('telescope.builtin')

        return {

            { '<leader>ff', builtin.find_files, desc = "Telescope: find files in CWD" },
            { '<leader>fa', function()
                -- note: the autocompletion for input() seems to be breoken by nvim-cmp, see https://github.com/hrsh7th/nvim-cmp/issues/1794
                builtin.find_files({ search_dirs = { vim.fn.input("Search in: ", vim.fn.getcwd(), "file") } })
            end, desc = "Telescope: find files in selected directory" },
            { '<leader>fg', builtin.live_grep, desc = "Telescope: live grep" },
            { '<leader>fw', builtin.grep_string, desc = "Telescope: live grep" },
            { '<leader>fb', builtin.buffers, desc = "Telescope: buffers" },
            { '<leader>fh', builtin.help_tags, desc = "Telescope: help tags" },
            { '<leader>fo', builtin.oldfiles, desc = "Telescope: old files" },
            { '<leader>fm', builtin.marks, desc = "Telescope: marks" },

            -- LSP related mappings
            { "<leader>fr", builtin.lsp_references, desc = "Telescope: LSP references" },
            { "<leader>fd", builtin.lsp_definitions, desc = "Telescope: LSP definitions" },
            { "<leader>fi", builtin.lsp_implementations, desc = "Telescope: LSP implementations" },
            { "<leader>ft", builtin.lsp_type_definitions, desc = "Telescope: LSP type definitions" },
            { "<leader>fl", function() builtin.diagnostics({bufnr = 0}) end, desc = "Telescope: LSP document diagnostics" },
            { "<leader>fe", builtin.diagnostics, desc = "Telescope: LSP workspace diagnostics" },
        }


    end,


    config = function()

        -- configure
        require('telescope').setup({

            -- defaults for telescope
            defaults = {
                -- layout
                layout_strategy = 'flex',
                layout_config = {
                    flex = {
                        flip_columns = 130 -- same as horizontal.preview_cutoff
                    },
                    horizontal = {
                        preview_cutoff = 130 -- same as flex.flip_columns
                    }
                },
                -- mappings within the telescope window
                mappings = {
                    i = {
                        -- actions.which_key shows the mappings for your picker,
                        -- Note: here "name" is a shortcut for telescope.actions.name
                        ["<C-h>"] = "select_horizontal",  -- default: show help
                        ["<C-x>"] = false, -- default: select horizontal
                        ["<C-?>"] = "which_key",  -- default: show help

                        ["<C-j>"] = "move_selection_next",
                        ["<C-k>"] = "move_selection_previous",

                        ["<C-n>"] = "cycle_history_next",
                        ["<C-p>"] = "cycle_history_prev",
                    },
                    n = {
                        -- actions.which_key shows the mappings for your picker,
                        -- Note: here "name" is a shortcut for telescope.actions.name
                        ["<C-h>"] = "select_horizontal",
                        ["<C-x>"] = false, -- default: select horizontal

                        ["<C-j>"] = "move_selection_next",
                        ["<C-k>"] = "move_selection_previous",

                        ["<C-n>"] = "cycle_history_next",
                        ["<C-p>"] = "cycle_history_prev",
                    }
                },
            },

            -- vimgrep options
            vimgrep_arguments = {
                -- the following arguments are required (see docs)
                "rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column",
                -- options
                "--smart-case",
                "--hidden", -- include results from hidden files
                "--glob !**/.git/*" -- exclude .git folder
            },

            -- settings for individual pickers
            pickers = {
                -- file selection
                find_files = {
                    -- follow symlinks
                    follow = true,
                    -- show hidden files
                    hidden = true
                }
            },

            -- extensions
            extensions = {
            }

        })

    end
}

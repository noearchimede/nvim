return {

    'nvim-telescope/telescope.nvim',

    dependencies = {
        'nvim-lua/plenary.nvim', -- required
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }, -- use fzf algorithm
        'nvim-telescope/telescope-ui-select.nvim', -- extension to replace the vim.ui.select interface
        -- note: other extensions might be added in dedicated plugin files
    },

    keys = {

        { '<leader>ff', function() require('telescope.builtin').find_files() end, desc = "Telescope: find files in CWD" },
        {
            '<leader>fa',
            function()
                -- note: the autocompletion for input() seems to be breoken by nvim-cmp, see https://github.com/hrsh7th/nvim-cmp/issues/1794
                require('telescope.builtin').find_files({ search_dirs = { vim.fn.input("Search in: ", vim.fn.getcwd(), "file") } })
            end,
            desc = "Telescope: find files in selected directory"
        },
        { '<leader>fg', function() require('telescope.builtin').live_grep() end, desc = "Telescope: live grep" },
        { '<leader>fw', function() require('telescope.builtin').grep_string() end, desc = "Telescope: live grep" },
        { '<leader>fh', function() require('telescope.builtin').help_tags() end, desc = "Telescope: help tags" },
        { '<leader>fk', function() require('telescope.builtin').keymaps() end, desc = "Telescope: keymaps" },
        { '<leader>fo', function() require('telescope.builtin').oldfiles() end, desc = "Telescope: old files" },
        { '<leader>fm', function() require('telescope.builtin').marks() end, desc = "Telescope: marks" },

        -- LSP related mappings
        { "<leader>fr", function() require('telescope.builtin').lsp_references() end, desc = "Telescope: LSP references" },
        { "<leader>fd", function() require('telescope.builtin').lsp_definitions() end, desc = "Telescope: LSP definitions" },
        { "<leader>fi", function() require('telescope.builtin').lsp_implementations() end, desc = "Telescope: LSP implementations" },
        { "<leader>ft", function() require('telescope.builtin').lsp_type_definitions() end, desc = "Telescope: LSP type definitions" },
        { "<leader>fl", function() require('telescope.builtin').diagnostics({ bufnr = 0 }) end, desc = "Telescope: LSP document diagnostics" },
        { "<leader>fe", function() require('telescope.builtin').diagnostics() end, desc = "Telescope: LSP workspace diagnostics" },

        -- buffers: use bb (insead of fb) for consistency with other buffer navigation mappings
        { '<leader>bb', function() require('telescope.builtin').buffers({ sort_lastused = true }) end, desc = "Telescope: buffers" },
    },

    cmd = { "Telescope" },

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
                        ["<C-h>"] = "which_key",
                        -- by default, n/p move selection and there is no history scroll
                        ["<C-j>"] = "move_selection_next",
                        ["<C-k>"] = "move_selection_previous",
                        ["<C-n>"] = "cycle_history_next",
                        ["<C-p>"] = "cycle_history_prev",
                    },
                    n = {
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
                },
                -- buffer selection
                buffers = {
                    -- custom mappings for this picker
                    mappings = {
                        n = {
                            ['<C-d>'] = require('telescope.actions').delete_buffer
                        },
                        i = {
                            ['<C-d>'] = require('telescope.actions').delete_buffer
                        }
                    }
                }
            },

            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown({})
                }
            }

        })

        -- load extensions (must come after setup function)
        require('telescope').load_extension('fzf')
        require("telescope").load_extension("ui-select")

    end
}

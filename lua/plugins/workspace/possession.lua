return {

    'jedrzejboczar/possession.nvim',

    requires = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim', -- optional
    },

    keys = {
        { "<leader>wr", "<cmd>PSLoad<cr>",
            desc = "Possession: load latest session" },
        { "<leader>ww", "<cmd>PSLoadCwd<cr>",
            desc = "Possession: load latest session for CWD" },
        { "<leader>wl", "<cmd>Telescope possession<cr>",
            desc = "Possession: open telescope picker for sessions" },
        { "<leader>ws", function() vim.cmd("PSSave " .. vim.fn.input("Save session as: ")) end,
            desc = "Possession: save session" },
        { "<leader>wu", function() vim.cmd("PSSave " .. require('possession.session').get_session_name()) end,
            desc = "Possession: update session" },
        { "<leader>wi", function() vim.notify("Session: " .. (require('possession.session').get_session_name() or "–"), vim.log.levels.INFO) end,
            desc = "Possession: get session info" },
    },

    opts = {
        silent = false,
        prompt_no_cr = true,
        autosave = {
            current = true,
            cwd = true,
            tmp = false,
            tmp_name = 'tmp',
            on_load = true,
            on_quit = true,
        },
        autoload = false,
        commands = {
            save = 'PSSave',
            load = 'PSLoad',
            save_cwd = 'PSSaveCwd',
            load_cwd = 'PSLoadCwd',
            rename = 'PSRename',
            close = 'PSClose',
            delete = 'PSDelete',
            show = 'PSShow',
            list = 'PSList',
            list_cwd = 'PSListCwd',
            migrate = 'PSMigrate',
        },
        plugins = {
            close_windows = false,
            delete_hidden_buffers = false,
            -- possession has integrations for many third party plugins (full list in the help page)
            nvim_tree = true,
            tabby = true,
            stop_lsp_clients = false,
        },
        telescope = {
            previewer = {
                enabled = true,
            },
            list = {
                default_action = 'load',
                mappings = {
                    save = nil,
                    load = nil,
                    delete = '<c-x>',
                    rename = '<c-r>',
                },
            },
        },
    },

    config = function(_, opts)

        require('possession').setup(opts)

        -- attach telescope extension
        require('telescope').load_extension('possession')

    end

}

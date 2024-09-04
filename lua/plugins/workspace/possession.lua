return {

    'jedrzejboczar/possession.nvim',

    requires = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim', -- optional
    },

    events = "DirChangedPre",

    cmd = {
        "PSSave",
        "PSSaveCwd",
        "PSLoad",
        "PSLoadCwd",
        "PSList",
        "PSShow"
    },

    keys = {
        { "<leader>wl", "<cmd>PSLoad<cr>",
            desc = "Possession: load latest session" },
        { "<leader>wd", "<cmd>PSLoadCwd<cr>",
            desc = "Possession: load latest session for directory" },
        { "<leader>ws", "<cmd>Telescope possession<cr>",
            desc = "Possession: show all saved sessions" },
        { "<leader>wm", function() vim.cmd("PSSave " .. vim.fn.input("Save session as: ")) end,
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
            close_windows = {
                preserve_layout = false,
                match = {
                    floating = true,
                    filetype = {
                        'qf',
                        'aerial',
                        'trouble',
                        'undotree',
                    },
                    buftype = {}
                }
            },
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
                    save = '<c-s>',
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

    end,

    init = function()

        -- Create autocommand to save a session named after the cwd when vim is
        -- closed.
        -- The autosave.cwd settings doesn't appear to do this in all cases,
        -- e.g. when cwd is a directory that already has an associated session
        -- but that session is not explicitly loaded, the cwd session is not
        -- updated
        vim.api.nvim_create_autocmd('ExitPre', {
            callback = function()
                vim.cmd("PSSave! " .. vim.fn.getcwd(-1, -1))
            end
        })

    end

}

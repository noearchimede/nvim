return {

    'jedrzejboczar/possession.nvim',

    requires = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim', -- optional
    },

    events = "DirChangedPre",

    cmd = {
        "PossessionSave",
        "PossessionSaveCwd",
        "PossessionLoad",
        "PossessionLoadCwd",
        "PossessionList",
        "PossessionShow"
    },

    keys = {
        { "<leader>wl", "<cmd>PossessionLoad<cr>",
            desc = "Possession: load latest session" },
        { "<leader>wd", "<cmd>PossessionLoadCwd<cr>",
            desc = "Possession: load latest session for directory" },
        { "<leader>ws", "<cmd>Telescope possession<cr>",
            desc = "Possession: show all saved sessions" },
        { "<leader>wm", function() vim.cmd("PossessionSave " .. vim.fn.input("Save session as: ")) end,
            desc = "Possession: save session" },
        { "<leader>wu", function() vim.cmd("PossessionSave " .. require('possession.session').get_session_name()) end,
            desc = "Possession: update session" },
        { "<leader>wi", function() vim.notify("Session: " .. (require('possession.session').get_session_name() or "–"), vim.log.levels.INFO) end,
            desc = "Possession: get session info" },
        { "<leader>wq", function()
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].modified then
                    vim.notify("At least one buffer has unsaved changes. Save or use :qa!.", vim.log.levels.WARN)
                    return
                end
            end
            vim.cmd("qa")
        end,
            desc = ":qa (preserve window layout)" }
    },

    opts = {
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
                        'help',
                        'oil',
                        'iron',
                        'OverseerList',
                        'OverseerOutput'
                    },
                    buftype = {}
                }
            },
            delete_hidden_buffers = false,
            -- possession has integrations for many third party plugins (full list in the help page)
            nvim_tree = true,
            tabby = true,
        },
        telescope = {
            list = {
                default_action = 'load',
                mappings = {
                    save = '<c-s>',
                    load = nil,
                    delete = '<c-d>',
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
                vim.cmd("PossessionSaveCwd!")
            end
        })

    end

}

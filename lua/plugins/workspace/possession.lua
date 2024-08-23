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
            desc = "Possession: save session" },
    },

    opts = {
        silent = false,
        prompt_no_cr = true,
        autosave = {
            current = true,
            cwd = true,
            tmp = false,
            tmp_name = 'tmp',
            on_load = false,
            on_quit = true,
        },
        hooks = {
            --[[ I tried to implement this hook to always have a CWD session saved but it never worked.
            before_save = function(name)
                local cwd_name = require('possession.paths').cwd_session_name()
                if cwd_name ~= name then
                    require('possession.session').save(cwd_name, { no_confirm = true })
                end
                return {}
            end, --]]
            -- after_save = function(name, user_data, aborted) end,
            -- before_load = function(name, user_data) return user_data end,
            -- after_load = function(name, user_data) end,
        },
        autoload = false, --'last_cwd', -- or 'last' or 'auto_cwd' or 'last_cwd' or fun(): string
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
                hooks = {
                    'before_load',
                },
                preserve_layout = true,
                match = {
                    floating = true,
                    buftype = {},
                    filetype = {},
                    custom = false,  -- or fun(win): boolean
                },
            },
            delete_hidden_buffers = {
                hooks = {
                    'before_load',
                },
                force = false,  -- or fun(buf): boolean
            },
            nvim_tree = true,
            neo_tree = false,
            symbols_outline = false,
            outline = false,
            tabby = true,
            dap = true,
            dapui = true,
            neotest = true,
            delete_buffers = false,
            stop_lsp_clients = false,
        },
        telescope = {
            previewer = {
                enabled = true,
                previewer = 'pretty', -- or 'raw' or fun(opts): Previewer
                wrap_lines = true,
                include_empty_plugin_data = true,
                cwd_colors = {
                    cwd = 'Comment',
                    tab_cwd = { '#cc241d', '#b16286', '#d79921', '#689d6a', '#d65d0e', '#458588' }
                }
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

    init = function()
        -- attach telescope extension
        require('telescope').load_extension('possession')
    end

}

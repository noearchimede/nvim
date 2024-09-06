return {

    'MagicDuck/grug-far.nvim',

    keys = function()

        -- function to create a window where search results can be inspected before launching Grug.
        -- this is a hack to circumvent the default behaviour, which is to open files in the last used window
        -- I did not find a setting to do this natively.
        -- NOTE: this function is copy-pasted in the nvim-tree 'open_grug' custom action (in tree.lua)
        local function preOpenGrug()
            vim.cmd('tabnew')
            vim.opt_local.buflisted = false
            vim.opt_local.buftype = "nofile"
            vim.opt_local.bufhidden = "wipe"
            vim.opt_local.swapfile = true
        end
        local winCmd = 'aboveleft vsplit'
        winCmd = winCmd .. ' | lua vim.api.nvim_win_set_width(0, math.floor(vim.api.nvim_win_get_width(0) * 4 / 3))'

        return {
            {
                "<leader>sg",
                function()
                    preOpenGrug()
                    require('grug-far').grug_far({
                        windowCreationCommand = winCmd,
                    })
                end,
                desc = "Grug-far: launch"
            },
            {
                "<leader>sg",
                function()
                    preOpenGrug()
                    require('grug-far').with_visual_selection({
                        windowCreationCommand = winCmd,
                    })
                end,
                mode = 'v',
                desc = "Grug-far: launch",
            },
            {
                "<leader>sf",
                function()
                    preOpenGrug()
                    require('grug-far').grug_far({
                        windowCreationCommand = winCmd,
                        prefills = { paths = vim.fn.expand("%") },
                    })
                end,
                desc = "Grug-far: launch on current file"
            },
            {
                "<leader>sf",
                function()
                    preOpenGrug()
                    require('grug-far').with_visual_selection({
                        windowCreationCommand = winCmd,
                        prefills = { paths = vim.fn.expand("%") },
                    })
                end,
                mode = 'v',
                desc = "Grug-far: launch on current file",
            },
        }
    end,


    config = function()
        require('grug-far').setup({

            -- see 'https://github.com/MagicDuck/grug-far.nvim/blob/main/lua/grug-far/opts.lua' for defaults

            -- debounce milliseconds for issuing search while user is typing
            -- prevents excessive searching
            debounceMs = 500,

            -- minimum number of chars which will cause a search to happen
            -- prevents performance issues in larger dirs
            minSearchChars = 2,

            -- stops search after this number of matches as getting millions of matches is most likely pointless
            -- and can even freeze the search buffer sometimes
            -- can help prevent performance issues when searching for very common strings or when slowly starting
            -- to type your search string
            -- note that it can overshoot a little bit, but should not really matter in practice
            -- set to nil to disable
            maxSearchMatches = 2000,

            -- disable automatic debounced search and trigger search when leaving insert mode instead
            searchOnInsertLeave = false,

            -- max number of parallel replacements tasks
            maxWorkers = 4,

            -- specifies the command to run (with `vim.cmd(...)`) in order to create
            -- the window in which the grug-far buffer will appear
            -- ex (horizontal bottom right split): 'botright split'
            -- ex (open new tab): 'tabnew %'
            windowCreationCommand = 'vsplit',

            -- whether to start in insert mode,
            -- set to false for normal mode
            startInInsertMode = true,

            -- whether to wrap text in the grug-far buffer
            wrap = true,

            -- whether or not to make a transient buffer which is both unlisted and fully deletes itself when not in use
            transient = false,
            --
            -- shortcuts for the actions you see at the top of the buffer
            -- set to '' or false to unset. Mappings with no normal mode value will be removed from the help header
            -- you can specify either a string which is then used as the mapping for both normal and insert mode
            -- or you can specify a table of the form { [mode] = <lhs> } (ex: { i = '<C-enter>', n = '<localleader>gr'})
            -- it is recommended to use <localleader> though as that is more vim-ish
            -- see https://learnvimscriptthehardway.stevelosh.com/chapters/11.html#local-leader
            keymaps = {

                openLocation = { n = 'o' }, -- default: <localleader>o
                gotoLocation = { n = '<enter>' },

                replace = { n = '<localleader>r' },

                syncLocations = { n = '<localleader>s' },
                syncLine = { n = '<localleader>l' },

                qflist = { n = '<localleader>c' },

                refresh = { n = '<localleader>f' },
                close = { n = '<localleader>q' },

                historyOpen = { n = '<localleader>t' },
                historyAdd = { n = '<localleader>a' },
                pickHistoryEntry = { n = '<enter>' },

                abort = { n = '<localleader>b' },

                toggleShowCommand = { n = '<localleader>p' },
                swapEngine = { n = '<localleader>e' },

                help = { n = 'g?' },
            },

            -- highlight the results with TreeSitter, if available
            resultsHighlight = true,

            -- folding related options
            folding = {
                -- whether to enable folding
                enabled = true,

                -- sets foldlevel, folds with higher level will be closed.
                -- result matche lines for each file have fold level 1
                -- set it to 0 if you would like to have the results initially collapsed
                -- See :h foldlevel
                foldlevel = 1,

                -- visual indicator of folds, see :h foldcolumn
                -- set to '0' to disable
                foldcolumn = '1',
            },

        })
    end

}

return {

    'MagicDuck/grug-far.nvim',

    keys = {
        {
            "<leader>sg",
            function() require('grug-far').grug_far() end,
            desc = "Grug-far: launch"
        },
        {
            "<leader>sg",
            function() require('grug-far').with_visual_selection() end,
            mode = 'v',
            desc = "Grug-far: launch",
        },
        {
            "<leader>sf",
            function() require('grug-far').grug_far({ prefills = { paths = vim.fn.expand("%") } }) end,
            desc = "Grug-far: launch on current file"
        },
        {
            "<leader>sf",
            function() require('grug-far').with_visual_selection({ prefills = { paths = vim.fn.expand("%") } }) end,
            mode = 'v',
            desc = "Grug-far: launch on current file",
        },
    },


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

                qflist = { n = '<localleader>q' },

                refresh = { n = '<localleader>f' },
                close = { n = '<localleader>c' },

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

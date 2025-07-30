return {

    'MagicDuck/grug-far.nvim',

    cmd = { "GrugFar" },

    keys = function()

        -- NOTE: when editing here, remember to also update the relevant section in the config file for nvim-tree!

        local function grug_opts(other_opts)
            table.unpack = table.unpack or unpack -- 5.1 compatibility
            return {
                windowCreationCommand = 'tab split',
                openTargetWindow = { preferredLocation = 'right' },
                table.unpack(other_opts or {})
            }
        end

        return {
            {
                "<leader>sg",
                function()
                    require('grug-far').open(grug_opts())
                end,
                desc = "Grug-far: launch"
            },
            {
                "<leader>sg",
                function()
                    require('grug-far').with_visual_selection(grug_opts())
                end,
                mode = 'v',
                desc = "Grug-far: launch",
            },
            {
                "<leader>sf",
                function()
                    require('grug-far').open(grug_opts( { prefills = { paths = vim.fn.expand("%") } }))
                end,
                desc = "Grug-far: launch on current file"
            },
            {
                "<leader>sf",
                function()
                    require('grug-far').open(grug_opts( { prefills = { paths = vim.fn.expand("%") } }))
                end,
                mode = 'v',
                desc = "Grug-far: launch on current file",
            },
        }
    end,


    config = function()
        require('grug-far').setup({

            -- see 'https://github.com/MagicDuck/grug-far.nvim/blob/main/lua/grug-far/opts.lua' for defaults

            -- whether to wrap text in the grug-far buffer
            wrap = false,

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
                previewLocation = { n = '<tab>' },

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

                applyNext = { n = '<localleader>j' },
                applyPrev = { n = '<localleader>k' },

                help = { n = 'g?' },
            },

        })
    end

}

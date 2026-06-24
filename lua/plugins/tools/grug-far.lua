return {

    'MagicDuck/grug-far.nvim',

    cmd = { "GrugFar" },

    keys = function()

        return {
            {
                "<leader>sg",
                function()
                    require('grug-far').open({
                        windowCreationCommand = 'split',
                        openTargetWindow = { preferredLocation = 'above' },
                    })
                end,
                desc = "Grug-far: open (split)"
            },
            {
                "<leader>sg",
                function()
                    require('grug-far').with_visual_selection({
                        windowCreationCommand = 'split',
                        openTargetWindow = { preferredLocation = 'above' },
                    })
                end,
                mode = 'v',
                desc = "Grug-far: open (split)",
            },
            {
                "<leader>st",
                function()
                    require('grug-far').open({
                        windowCreationCommand = 'tab split',
                        openTargetWindow = { preferredLocation = 'right' },
                    })
                end,
                desc = "Grug-far: open (tab)"
            },
            {
                "<leader>st",
                function()
                    require('grug-far').with_visual_selection({
                        windowCreationCommand = 'tab split',
                        openTargetWindow = { preferredLocation = 'right' },
                    })
                end,
                mode = 'v',
                desc = "Grug-far: open (tab)",
            },
            {
                "<leader>sf",
                function()
                    require('grug-far').open({
                        windowCreationCommand = 'split',
                        openTargetWindow = { preferredLocation = 'right' },
                        prefills = { paths = vim.fn.expand("%") }
                    })
                end,
                desc = "Grug-far: launch on current file"
            },
            {
                "<leader>sf",
                function()
                    require('grug-far').open({
                        windowCreationCommand = 'split',
                        openTargetWindow = { preferredLocation = 'right' },
                        prefills = { paths = vim.fn.expand("%") }
                    })
                end,
                mode = 'v',
                desc = "Grug-far: launch on current file",
            },
        }
    end,

    opts = {

        -- see '~/.local/share/nvim/lazy/grug-far.nvim/lua/grug-far/opts.lua' for defaults

        -- whether to wrap text in the grug-far buffer
        wrap = false,
        -- disable helpline because anyways it's cut to a few items only ('localleader' is too long)
        helpLine = { enabled = false },
        -- custom mappings, use defaults unless redefined or set to false
        keymaps = {
            qflist = { n = '<localleader>c' }, -- by default is <ll>q
            close = { n = '<localleader>q' }, -- for consistency with other plugins
        },

    }

}

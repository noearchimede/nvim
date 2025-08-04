return {

    'MagicDuck/grug-far.nvim',

    cmd = { "GrugFar" },

    keys = function()

        -- NOTE: when editing here, remember to also update the relevant section in the config file for nvim-tree and oil.nvim!

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
                    require('grug-far').open(grug_opts({ prefills = { paths = vim.fn.expand("%") } }))
                end,
                desc = "Grug-far: launch on current file"
            },
            {
                "<leader>sf",
                function()
                    require('grug-far').open(grug_opts({ prefills = { paths = vim.fn.expand("%") } }))
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

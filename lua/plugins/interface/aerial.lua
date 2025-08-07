return {

    'stevearc/aerial.nvim',

    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    },

    keys = {
        { '<leader>aa', '<cmd>AerialOpen<cr>', desc = "Aerial: open (no focus)" },
        { '<leader>af', '<cmd>AerialOpen<cr>', desc = "Aerial: open and focus" },
        { '<leader>aA', '<cmd>AerialClose<cr>', desc = "Aerial: close" },
        { '<leader>ag', '<cmd>AerialNavOpen<cr>', desc = "Aerial: open navigator" },
        { '<leader>an', '<cmd>AerialNext<cr>', desc = "Aerial: next" },
        { '[a', '<cmd>AerialNext<cr>', desc = "Aerial: next" },
        { '<leader>ap', '<cmd>AerialPrev<cr>', desc = "Aerial: prev" },
        { ']a', '<cmd>AerialPrev<cr>', desc = "Aerial: prev" },
    },

    opts = {

        layout = {
            -- make background same color as NvimTree
            win_opts = {
                winhighlight = 'Normal:NvimTreeNormal,EndOfBuffer:NvimTreeEndOfBuffer'
            },
        },
        keymaps = {
            ["<C-x>"] = "actions.jump_split",
            ["<C-s>"] = false
        },

        -- Options for the floating nav windows
        nav = {
            keymaps = {
                ["<C-x>"] = "actions.jump_split",
                ["<C-s>"] = false
            },
        },


    }

}

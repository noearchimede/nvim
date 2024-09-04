return {

    'sindrets/winshift.nvim',

    keys = {

        { '<C-W><C-M>', '<Cmd>WinShift<CR>', desc = "Winshift: move window" },
        { '<C-W>m', '<Cmd>WinShift<CR>', desc = "Winshift: move window" },

        { '<C-W><C-X>', '<Cmd>WinShift<CR>', desc = "Winshift: swap window" },
        { '<C-W>x', '<Cmd>WinShift<CR>', desc = "Winshift: swap window" },

    },

    opts = {
        keymaps = {
            disable_defaults = true, -- Disable the default keymaps
            win_move_mode = {

                ["h"] = "left",
                ["j"] = "down",
                ["k"] = "up",
                ["l"] = "right",

                ["H"] = "far_left",
                ["J"] = "far_down",
                ["K"] = "far_up",
                ["L"] = "far_right",

            },
        },
    }
}

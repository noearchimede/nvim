return {

    "folke/zen-mode.nvim",

    keys = {
        { '<leader>xx', "<cmd>ZenMode<cr>", desc = "Toggle Zen mode" }
    },

    opts = {
        window = {
            width = 0.96, -- width of the Zen window (0-1: percentage, >1: nr. of columns)
            height = 0.96, -- height of the Zen window (0-1: percentage, >1: nr. of rows)
            options = {
                signcolumn = "no", -- disable signcolumn
                number = false, -- disable number column
                relativenumber = false, -- disable relative numbers
                cursorline = false, -- disable cursorline
                cursorcolumn = false, -- disable cursorline
                foldcolumn = "0", -- disable fold column
                list = false, -- disable whitespace characters
            },
        },
    }

}

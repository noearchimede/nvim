return {

    "kylechui/nvim-surround",

    event = "VeryLazy",

    opts = {
        -- keep the cursor where it is
        move_cursor = "sticky",
    },

    aliases = {
        ["a"] = ">", -- Angle brackets
        ["p"] = ")", -- Parentheses -- default b
        ["b"] = "}", -- Braces -- default B
        ["r"] = "]", -- Rectangle brackets
        ["t"] = "`", -- BackTick
        ["q"] = { '"', "'", "`" }, -- Quotes
        ["s"] = { "}", "]", ")", ">", '"', "'", "`" }, -- Surround
    },

    init = function()

        vim.keymap.set("i", "<C-g>Z", "<Plug>(nvim-surround-insert)", {
            desc = "Surround cursor",
        })
        vim.keymap.set("i", "<C-g>Z", "<Plug>(nvim-surround-insert-line)", {
            desc = "Surround cursor (new line)",
        })
        vim.keymap.set("n", "gz", "<Plug>(nvim-surround-normal)", {
            desc = "Surround",
        })
        vim.keymap.set("n", "gzz", "<Plug>(nvim-surround-normal-cur)", {
            desc = "Surround line",
        })
        vim.keymap.set("n", "gZ", "<Plug>(nvim-surround-normal-line)", {
            desc = "Surround (new line)",
        })
        vim.keymap.set("n", "gZZ", "<Plug>(nvim-surround-normal-cur-line)", {
            desc = "Surround line (new line)",
        })
        vim.keymap.set("x", "Z", "<Plug>(nvim-surround-visual)", {
            desc = "Surround selection",
        })
        vim.keymap.set("x", "gZ", "<Plug>(nvim-surround-visual-line)", {
            desc = "Surround selection (new line)",
        })
        vim.keymap.set("n", "dz", "<Plug>(nvim-surround-delete)", {
            desc = "Delete surround",
        })
        vim.keymap.set("n", "cz", "<Plug>(nvim-surround-change)", {
            desc = "Change surround",
        })
        vim.keymap.set("n", "cZ", "<Plug>(nvim-surround-change-line)", {
            desc = "Change surround (new line)",
        })

    end

}

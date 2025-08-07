return {

    "kylechui/nvim-surround",

    event = "VeryLazy",

    opts = {

        -- custom keymappings to avoind using s, as that key is dedicated to leap.nvim
        -- NOTE: using the opening character of a pair will also insert a space, using the closing one won't
        keymaps = {

            insert = "<C-G>z",
            Winsert_line = "<C-G>Z",

            normal = "gz",
            normal_cur = "gzz",
            normal_line = "gZ",
            normal_cur_line = "gZZ",

            visual = "Z",
            visual_line = "gZ",

            delete = "dz",

            change = "cz",
            change_line = "cZ",

        },

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

}

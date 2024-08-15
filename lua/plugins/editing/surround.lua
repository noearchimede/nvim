return {

    "kylechui/nvim-surround",

    tag = "*",

    event = "VeryLazy",

    opts = {

        -- custom keymappings to avoind using s, as that key is dedicated to leap.nvim
        keymaps = {

            normal = "gz",
            normal_line = "gZ",

            normal_cur = "gzz",
            normal_cur_line = "gZZ",

            visual = "gz",
            visual_line = "gZ",

            insert = "<C-G>z",
            insert_line = "<C-G>Z",

            delete = "gzd",

            change = "gzc",
            change_line = "gZc",

        }
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

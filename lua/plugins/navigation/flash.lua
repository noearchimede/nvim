return {

    "folke/flash.nvim",

    event = "VeryLazy",

    opts = {
        modes = {
            char = {
                -- disable overriding default ftFT functionality
                enabled = false,
            },
        },
    },

    keys = {
        {
            "s", -- normal, visual, operator-pending modes
            mode = { "n", "x", "o" },
            function() require("flash").jump() end,
            desc = "Flash",
        },
        {
            "S", -- normal, visual, operator-pending modes
            mode = { "n", "x", "o" },
            function() require("flash").treesitter() end,
            desc = "Flash Treesitter",
        },
        {
            "r",
            mode = "o", -- only operator-pending mode
            function() require("flash").remote() end,
            desc = "Remote Flash",
        },
        {
            "R", -- operator-pending and visual (not select) modes
            mode = { "o", "x" },
            function() require("flash").treesitter_search() end,
            desc = "Treesitter Search",
        },
        {
            "<c-s>",
            mode = { "c" }, -- command-line mode
            function() require("flash").toggle() end,
            desc = "Toggle Flash Search",
        },
    },
}

return {

    "folke/which-key.nvim",

    event = "VeryLazy",

    keys = {
        { "<leader>'", function() require("which-key").show({ global = true }) end, desc = "Which key: global", },
        { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Which key: buffer", },
    },

    opts = {
        ---@type false | "classic" | "modern" | "helix"
        preset = "modern",
        -- Delay before showing the popup. Can be a number or a function that returns a number.
        delay = 1000,
        icons = {
            mappings = false
        }
    },

}

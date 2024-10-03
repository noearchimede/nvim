return {

    "folke/which-key.nvim",

    event = "VeryLazy",

    keys = {
        { "<leader>'", function() require("which-key").show({ global = true }) end, desc = "Which key: global", },
        { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Which key: buffer", },
    },

    opts = {
        ---@type false | "classic" | "modern" | "helix"
        preset = "classic",
        -- Delay before showing the popup. Can be a number or a function that returns a number.
        delay = 2000,
        plugins = {
            marks = false, -- shows a list of your marks on ' and `
            registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
            -- the presets plugin, adds help for a bunch of default keybindings in Neovim
            -- No actual key bindings are created
            spelling = {
                enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
                suggestions = 20, -- how many suggestions should be shown in the list?
            },
            presets = {
                operators = true, -- adds help for operators like d, y, ...
                motions = true, -- adds help for motions
                text_objects = true, -- help for text objects triggered after entering an operator
                windows = true, -- default bindings on <c-w>
                nav = true, -- misc bindings to work with windows
                z = true, -- bindings for folds, spelling and others prefixed with z
                g = true, -- bindings for prefixed with g
            },
        },
    },

}

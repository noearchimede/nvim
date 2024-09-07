return {

    'm4xshen/autoclose.nvim',

    event = { 'InsertEnter' },

    keys = {
        {
            "<leader>yp",
            function() require('autoclose').toggle() end,
            desc = "Autoclose: toggle"
        }
    },
    opts = {

        keys = {
            ["("] = { escape = false, close = true, pair = "()" },
            ["["] = { escape = false, close = true, pair = "[]" },
            ["{"] = { escape = false, close = true, pair = "{}" },
            ["<"] = { escape = false, close = true, pair = "<>" },

            [">"] = { escape = true, close = false, pair = "<>" },
            [")"] = { escape = true, close = false, pair = "()" },
            ["]"] = { escape = true, close = false, pair = "[]" },
            ["}"] = { escape = true, close = false, pair = "{}" },

            ['"'] = { escape = true, close = true, pair = '""' },
            ["'"] = { escape = true, close = true, pair = "''" },
            ["`"] = { escape = true, close = true, pair = "``" },
        },

        options = {
            disable_when_touch = true,
            touch_regex = [=[[%w(%[{<"'`]]=],
            pair_spaces = true,
            auto_indent = true,
            disable_command_mode = true,
        },

    }
}

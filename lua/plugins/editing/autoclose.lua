return {

    'm4xshen/autoclose.nvim',

    keys = {
        {
            "<leader>yp",
            function()
                require('autoclose').toggle()
                vim.notify("Autoclose toggled")
            end,
            desc = "Autoclose: toggle"
        },
        -- lazy-load on inserting the characters tracked by autoclose (obviously overkill...)
        { '(', mode = 'i' },
        { '[', mode = 'i' },
        { '{', mode = 'i' },
        { '<', mode = 'i' },
        { ')', mode = 'i' },
        { ']', mode = 'i' },
        { '}', mode = 'i' },
        { '>', mode = 'i' },
        { '"', mode = 'i' },
        -- { "'", mode = 'i' },
        { '`', mode = 'i' },
    },

    opts = {

        keys = {
            ["("] = { escape = false, close = true, pair = "()" },
            ["["] = { escape = false, close = true, pair = "[]" },
            ["{"] = { escape = false, close = true, pair = "{}" },
            -- ["<"] = { escape = false, close = true, pair = "<>" },

            [">"] = { escape = true, close = false, pair = "<>" }, -- keep the close sequence but not the open sequence for <>
            [")"] = { escape = true, close = false, pair = "()" },
            ["]"] = { escape = true, close = false, pair = "[]" },
            ["}"] = { escape = true, close = false, pair = "{}" },

            ['"'] = { escape = true, close = true, pair = '""' },
            -- single quote: 'close' disabled to provent pairing when used as apostrophe
            ["'"] = { escape = true, close = false, pair = "''" },
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

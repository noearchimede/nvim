return {

    "folke/flash.nvim",

    event = "VeryLazy",

    opts = {
        search = {
            exclude = {
                "notify",
                "cmp_menu",
                "noice",
                "flash_prompt",
                function(win)
                    -- exclude non-focusable windows
                    return not vim.api.nvim_win_get_config(win).focusable
                end,
                -- exclude quickfix because sometimes that leads to flash becoming stuck
                -- (first noticed in the latex compilation output provided by the vimtex plugin)
                "qf"
            },
        },
        modes = {
            char = {
                -- enhanced f F t T: highlight matches and repeat f/t to go to next
                enabled = true,
                multi_line = false
            },
            search = {
                -- jump label next to search results
                enabled = false
            }
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

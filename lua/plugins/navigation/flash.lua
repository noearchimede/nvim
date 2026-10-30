return {

    "folke/flash.nvim",

    event = "VeryLazy",

    keys = {
        -- normal, visual, operator-pending modes
        { "s", mode = { "n", "x" }, function() require("flash").jump() end, desc = "Flash" },
        -- normal and operator-pending modes (visual is taken for nvim-surround
        { "S", mode = { "n", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        -- only operator-pending mode
        { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
        -- operator-pending and visual (not select) modes
        { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    },

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
                enabled = false,
                multi_line = false
            },
            search = {
                -- jump label next to search results
                enabled = false
            }
        },
    },

}

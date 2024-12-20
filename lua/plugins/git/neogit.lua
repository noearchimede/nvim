return {

    "NeogitOrg/neogit",

    dependencies = {
        "nvim-lua/plenary.nvim",         -- required
        "sindrets/diffview.nvim",        -- optional - Diff integration

        "nvim-telescope/telescope.nvim", -- alternatively use fzf.lua
    },

    keys = {
        { "<leader>gg", function() require("neogit").open({ kind = "tab" }) end,
            desc = "Neogit: open status tab" },
        { "<leader>gc", function() require("neogit").open({ "commit" }) end,
            desc = "Neogit: commit staged changes" },
        { "<leader>gl", function() require("neogit").open({ "log" }) end,
            desc = "Neogit: show log" },

    },

    opts = {
        disable_hint = true,

        disable_context_highlighting = true,

        kind = "tab",

        status = {
            recent_commit_count = 30,
        },

        mappings = {

            status = {
                ["="] = "Toggle",
                ["o"] = "GoToFile",
                ["<cr>"] = "VSplitOpen",
                ["<localleader>q"] = "Close",
            },

            rebase_editor = {
                -- The following keys by default map to 'pick', 'reword', ecc.
                -- (see 'neogit_setup_mappings'), but they interfere with normal editing
                ["p"] = false,
                ["r"] = false,
                ["e"] = false,
                ["s"] = false,
                ["f"] = false,
                ["x"] = false,
                ["d"] = false,
                ["b"] = false,
                ["q"] = false,
            }

        }
    },

    init = function()
        vim.api.nvim_set_hl(0, "NeogitSectionHeader", { link = "WarningMsg" })
    end

}

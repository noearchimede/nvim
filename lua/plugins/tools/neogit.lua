return {

    "NeogitOrg/neogit",

    dependencies = {
        "nvim-lua/plenary.nvim",         -- required
        "sindrets/diffview.nvim",        -- optional - Diff integration

        "nvim-telescope/telescope.nvim", -- alternatively use fzf.lua
    },

    keys = {
        { "<leader>gg", function() require("neogit").open({ kind = "split" }) end,
            desc = "Neogit: open status tab" },
        { "<leader>gt", function() require("neogit").open({ kind = "tab" }) end,
            desc = "Neogit: open status tab" },
        { "<leader>gc", function() require("neogit").open({ "commit" }) end,
            desc = "Neogit: commit staged changes" },
        { "<leader>gl", function() require("neogit").open({ "log" }) end,
            desc = "Neogit: show log" },

    },

    opts = {
        -- hides the hints at the top of the status buffer
        disable_hint = true,
        -- settings for git status page
        status = {
            recent_commit_count = 30,
        },
        commit_editor = {
            -- "vsplit" if window would have 80 cols, otherwise "split"
            staged_diff_split_kind = "auto"
        },
        -- show absolute date in logs (by default uses relative date like everywhere else)
        log_date_format = "%Y-%m-%d %H:%M:%S",
        -- do not persist the values of switches/options within and across sessions
        remember_settings = false,
        integrations = {
            -- If enabled, use telescope for menu selection rather than vim.ui.select.
            -- Allows multi-select and some things that vim.ui.select doesn't.
            telescope = true,
            -- Neogit only provides inline diffs. If you want a more traditional way to look at diffs, you can use `diffview`.
            -- The diffview integration enables the diff popup.
            diffview = true
        },
        mappings = {
            status = {
                ["="] = "Toggle", -- synonim to <tab>
                ["o"] = "GoToFile", -- default is <cr>
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

}

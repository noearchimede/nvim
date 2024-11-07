return {

    "j-hui/fidget.nvim",

    event = "VeryLazy",

    keys = {
        { "<leader>nc", "<cmd>Fidget clear<cr>", desc = "Fidget: clear notifications" },
        { "<leader>nh", "<cmd>Fidget history<cr>", desc = "Fidget: show history" },
    },

    opts = {
        -- Options related to LSP progress subsystem
        progress = {
            display = {
                done_ttl = 5, -- How long a message should persist after completion
            },
            ignore = {
                function(msg)
                    return msg.lsp_client.name == "pylsp" and string.find(msg.title, "lint:")
                end,
            }
        },
        -- Options related to notification subsystem
        notification = {
            poll_rate = 10, -- How frequently to update and render notifications
            filter = vim.log.levels.INFO, -- Minimum notifications level
            history_size = 256, -- Number of removed messages to retain in history
            override_vim_notify = true, -- Automatically override vim.notify() with Fidget
            window = {
                winblend = 0, -- Background color opacity in the notification window
                normal_hl = 'Normal', -- default highlight for messages, unless another highlight is specified; this also sets the background.
                border = 'rounded', -- border of the notification window
                border_hl = 'Normal' -- highlight of the border
            },
        },
        integration = {
            -- the nvim-tree is useful to avoid pacing fidget notifications
            -- above the tree buffer, but that can't happen as I keep the tree
            -- on the left and fidged on the right hand side
            ["nvim-tree"] = { enable = false, },
        }
    },

}

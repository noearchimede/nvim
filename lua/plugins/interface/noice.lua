return {

    "folke/noice.nvim",

    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },

    event = "VeryLazy",

    keys = {
        {
            "<leader>yn",
            function()
                if require('noice.config')._running then
                    require('noice').disable()
                    vim.notify("Noice disabled")
                else
                    require('noice').enable()
                    vim.notify("Noice enabled")
                end
            end,
            desc = "Noice: toggle"
        },
        { "<leader>nh", "<cmd>Noice<cr>", desc = "Noice: show history" }
    },

    opts = {
        cmdline = {
            enabled = true,
            view = "cmdline_popup",
        },
        messages = {
            enabled = true,
            view = "mini",
            view_warn = "mini", -- view for errors
            view_error = "messages", -- view for errors
            view_search = false, -- view for search count messages
        },
        popupmenu = {
            enabled = false,
        },
        notify = {
            enabled = true,
            view = "mini"
        },
        lsp = {
            progress = {
                enabled = true,
                view = "mini",
            },
            message = {
                -- Messages shown by lsp servers
                enabled = true,
                view = "notify",
            },
            override = { -- overrides suggested in help page
                -- override the default lsp markdown formatter with Noice
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                -- override the lsp markdown formatter with Noice
                ["vim.lsp.util.stylize_markdown"] = true,
                -- override cmp documentation with Noice (needs the other options to work)
                ["cmp.entry.get_documentation"] = true,
            },
        },
        routes = {
            -- always route any messages with more than X lines to the split view
            {
                view = "split",
                filter = { event = "msg_show", min_height = 8 },
            },
        },
        presets = {
            command_palette = true,
        },
        views = {
            mini = {
                timeout = 5000,
                win_options = {
                    winblend = 0
                },
                position = {
                    row = -3,
                    col = -3
                },
                border = {
                    style = "rounded",
                },
            }
        }

    }
}

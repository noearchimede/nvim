return {

    "folke/noice.nvim",

    dependencies = {
        "MunifTanjim/nui.nvim",
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

    init = function()
        -- use the new experimental ui2 interface
        require('vim._core.ui2').enable()
        -- vim.o.cmdheight = 0
    end,

    opts = {
        -- disable message and notification handling; use the native interface for those
        -- if those are enabled again check the commit where this line was added for additional useful options!
        messages = {
            enabled = false,
        },
        notify = {
            enabled = false,
        },
        confirm = {
            enabled = false,
        },
        -- enable all other features
        cmdline = {
            enabled = true,
            view = "cmdline_popup",
        },
        popupmenu = {
            enabled = true,
        },
        lsp = {
            progress = {
                enabled = false,
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
        presets = {
            command_palette = true,
            lsp_doc_border = true,
        },
        views = {
            mini = {
                win_options = {
                    winblend = 0
                },
                border = {
                    style = "none",
                },
            },
        }

    }
}

return {

    "folke/noice.nvim",

    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },

    event = "VeryLazy",

    init = function()

        -- with S-enter redirect command output to the view selected as 'redirect' view below
        vim.keymap.set("c", "<S-Enter>", function()
            require("noice").redirect(vim.fn.getcmdline())
        end, { desc = "Redirect Cmdline" })

    end,

    opts = {
        cmdline = {
            enabled = true, -- enables the Noice cmdline UI
            view = "cmdline", -- 'cmdline_popup for a floating popup
        },
        messages = {
            -- NOTE: If you enable messages, then the cmdline is enabled automatically.
            -- This is a current Neovim limitation.
            enabled = true, -- enables the Noice messages UI
            view = "mini", -- default view for messages (less intrusive alternative: 'mini')
            view_error = "notify", -- view for errors
            view_warn = "notify", -- view for warnings
            view_history = "messages", -- view for :messages
            view_search = false -- view for search count. Set to "virtualtext" to get a virtual popup next to the current result
        },
        popupmenu = { -- note: doesn't seem to work properly with cmp, see https://github.com/folke/noice.nvim/discussions/241
            enabled = false, -- enables the Noice popupmenu UI
            backend = "cmp", -- backend to use to show regular cmdline completions
        },
        redirect = { -- redirection view used when running command with Shift-enter (mapping in 'init' above)
            view = "popup",
        },
        commands = { -- You can add any custom commands below that will be available with `:Noice command`
        },
        notify = { -- Noice can be used as `vim.notify` so you can route any notification like other messages
            enabled = true,
            view = "notify",
        },
        lsp = {
            progress = {
                enabled = true,
                view = "mini",
            },
            hover = {
                enabled = false,
            },
            signature = {
                enabled = false,
            },
            message = { -- Messages shown by lsp servers
                enabled = true,
                view = "notify",
            },
            documentation = { -- defaults for hover and signature help
                view = "hover",
                opts = {
                    lang = "markdown",
                    replace = true,
                    render = "plain",
                    format = { "{message}" },
                    win_options = { concealcursor = "n", conceallevel = 3 },
                },
            },
        },
        throttle = 1000 / 30, -- how frequently does Noice need to check for ui updates? This has no effect when in blocking mode.

        routes = {
            -- always route any messages with more than 5 lines to the popup view
            {
                filter = { event = "msg_show", min_height = 5 },
                view = "popup",
            },
            -- route 'search hit bottom' errors to the mini view
            {
                filter = {
                    event = "msg_show",
                    kind = "emsg",
                    find = "Search hit",
                },
                view = 'mini',
            },
        },
    },

}

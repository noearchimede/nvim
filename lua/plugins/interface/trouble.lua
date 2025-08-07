return {

    "folke/trouble.nvim",

    cmd = "Trouble",

    keys = {
        {
            "<leader>dD",
            function() require('trouble').close() end,
            desc = "Trouble: close",
        },
        {
            "<leader>dd",
            function() require('trouble').open { mode = 'diagnostics', focus = true, filter = { buf = 0 } } end,
            desc = "Trouble: buffer diagnostics",
        },
        {
            "<leader>dw",
            function() require('trouble').open { mode = 'diagnostics', focus = true } end,
            desc = "Trouble: workspace diagnostics",
        },

        {
            "<leader>dn",
            function()
                require('trouble').next()
                require('trouble').jump()
            end,
            desc = "Trouble: jump to next item",
        },
        {
            "<leader>dp",
            function()
                require('trouble').prev()
                require('trouble').jump()
            end,
            desc = "Trouble: jump to previous item",
        },
        {
            "<leader>dl",
            function() require('trouble').refresh() end,
            desc = "Trouble: reload",
        },
    },

    opts = {
        auto_preview = true, -- automatically open preview when on an item
        focus = false, -- Focus the window when opened
        warn_no_results = false, -- show a warning when there are no results
        open_no_results = true, -- open the trouble window when there are no results
        -- Key mappings can be set to the name of a builtin action,
        -- or you can define your own custom action.
        keys = {
            ["<C-r>"] = "refresh", -- default r
            r = false,
            o = {
                action = function()
                    local trouble = require('trouble')
                    trouble.jump()
                    trouble.focus()
                end,
                desc = "jump_keep_focus"
            }, -- default <cr>
            ["<cr>"] = "jump", -- default <o>
            ["<c-x>"] = "jump_split", -- default <c-s>
            ["<c-s>"] = false,
            J = "next",
            K = "prev",
            zf = { -- toggle the active view filter (default gb)
                action = function(view)
                    view:filter({ buf = 0 }, { toggle = true })
                end,
                desc = "toggle_view_filter",
            },
            S = { -- toggle the severity (default s)
                action = function(view)
                    local f = view:get_filter("severity")
                    local severity = ((f and f.filter.severity or 0) + 1) % 5
                    view:filter({ severity = severity }, {
                        id = "severity",
                        template = "{hl:Title}Filter:{hl} {severity}",
                        del = severity == 0,
                    })
                end,
                desc = "toggle_severity",
            },
            s = false, -- default: toggle severity
            ["<tab>"] = "fold_toggle", -- default: toggle severity
        },
        modes = {
            lsp_base = {
                params = {
                    include_current = true,
                },
            },
            -- more advanced example that extends the lsp_document_symbols
            symbols = {
                focus = true,
            },
        },
    },

    config = function(_, opts)

        require('trouble').setup(opts)

        -- change background color to use the same as NvimTree
        vim.api.nvim_set_hl(0, "TroubleNormal", { link = "NvimTreeNormal", force = true })
        vim.api.nvim_set_hl(0, "TroubleNormalNC", { link = "NvimTreeNormal", force = true })

    end

}

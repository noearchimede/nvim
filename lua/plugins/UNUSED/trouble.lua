return {

    "folke/trouble.nvim",

    cmd = "Trouble",

    -- as long as the autocmdn on BufRead to hijiack the quickfix list is
    -- defined (see the config function below), trouble needs to be loaded on
    -- all buffers. If that autocmd is removed this line can be deleted and
    -- trouble will load on its keymappings.
    event = "BufRead",

    keys = {
        {
            "<leader>dd",
            function()
                require('trouble').focus()
                -- it would be nice to have this reopen the last trouble view if there is none open
            end,
            desc = "Trouble: focus",
        },
        {
            "<leader>dD",
            function() require('trouble').close() end,
            desc = "Trouble: focus",
        },
        {
            "<leader>dr",
            function() require('trouble').refresh() end,
            desc = "Trouble: refresh",
        },
        {
            "<leader>dw",
            function()
                require('trouble').open({ mode = 'diagnostics', refresh = 'false' })
            end,
            desc = "Trouble: workspace diagnostics",
        },
        {
            "<leader>db",
            function()
                require('trouble').open({mode = 'diagnostics', refresh = 'false', filter = { buf = 0}})
            end,
            desc = "Trouble: buffer diagnostics",
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
    },

    opts = {

        auto_preview = false, -- automatically open preview when on an item
        auto_refresh = true, -- auto refresh when open
        focus = true, -- Focus the window when opened
        follow = true, -- Follow the current item
        multiline = false, -- render multi-line messages
        warn_no_results = false, -- show a warning when there are no results
        open_no_results = true, -- open the trouble window when there are no results
        -- Window options for the preview window
        preview = {
            type = "float", -- default: "main"; alternatives: "split", "float", ...
            border = "rounded",
            size = { width = 0.7, height = 0.8 },
        },

        keys = {
            -- most keys are left to the default value, here only the ones I changed are listed

            o = "jump",
            
            ["<cr>"] = {
                action = function()
                    local trouble = require('trouble')
                    trouble.jump()
                    trouble.focus()
                end,
                desc = "Jump but keep focus"
            },
            
            ["<c-h>"] = "jump_split", -- default: ["<c-s>"]

            B = { -- toggle the active view filter -- default: gb
                action = function(view)
                    view:filter({ buf = 0 }, { toggle = true })
                end,
                desc = "Toggle Current Buffer Filter",
            },
            L = { -- toggle severity -- default: s
                action = function(view)
                    local f = view:get_filter("severity")
                    local severity = ((f and f.filter.severity or 0) + 1) % 5
                    view:filter({ severity = severity }, {
                        id = "severity",
                        template = "{hl:Title}Filter:{hl} {severity}",
                        del = severity == 0,
                    })
                end,
                desc = "Toggle Severity Filter",
            },
            s = false

        },

        modes = {
            symbols = {
                focus = true
            }
        }
    },

    config = function(_, opts)

        require('trouble').setup(opts)

        -- change background color to use the same as NvimTree
        vim.api.nvim_set_hl(0, "TroubleNormal", { link = "NvimTreeNormal", force = true })
        vim.api.nvim_set_hl(0, "TroubleNormalNC", { link = "NvimTreeNormal", force = true })

    end

}

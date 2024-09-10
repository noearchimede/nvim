return {

    "folke/trouble.nvim",

    cmd = "Trouble",

    -- as long as the autocmdn on BufRead to hijiack the quickfix list is
    -- defined (see the config function below), trouble needs to be loaded on
    -- all buffers. If that autocmd is removed this line can be deleted and
    -- trouble will load on its keymappings.
    event = "BufRead",

    keys = {
        { "<leader>dd", "<cmd>Trouble diagnostics open<cr>", desc = "Trouble: diagnostics", },
        { "<leader>db", "<cmd>Trouble diagnostics open filter.buf=0<cr>", desc = "Trouble: buffer diagnostics" },
        { "<leader>ds", "<cmd>Trouble symbols open<cr>", desc = "Trouble: symbols" },
        { "<leader>dl", "<cmd>Trouble lsp open<cr>", desc = "Trouble: LSP content" },
        { "<leader>dv", "<cmd>Trouble loclist open<cr>", desc = "Trouble: location list" },
        { "<leader>dc", "<cmd>Trouble qflist open<cr>", desc = "Trouble: quickfix list" },
    },

    opts = {

        auto_preview = false, -- automatically open preview when on an item
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
        -- Key mappings can be set to the name of a builtin action, or you can define your own custom action.
        keys = {
            -- most keys are left to the default value, here only the ones I changed are listed
            ["<c-h>"] = "jump_split", -- default: ["<c-s>"]
            B = { -- toggle the active view filter -- default: gb
                action = function(view)
                    view:filter({ buf = 0 }, { toggle = true })
                end,
                desc = "Toggle Current Buffer Filter",
            },
            L = { -- example of a custom action that toggles the severity -- default: s
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

        -- completely replace the quickfix list (from readme, but not recommended!)
        vim.api.nvim_create_autocmd("BufRead", {
            callback = function(ev)
                if vim.bo[ev.buf].buftype == "quickfix" then
                    vim.schedule(function()
                        vim.cmd("cclose")
                        vim.cmd("Trouble qflist open")
                    end)
                end
            end,
        })

    end

}

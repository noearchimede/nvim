return {

    "folke/trouble.nvim",

    opts = {}, -- for default options, refer to the configuration section for custom setup.

    cmd = "Trouble",

    keys = {
        {
            "<leader>dd",
            "<cmd>Trouble diagnostics toggle<cr>",
            desc = "Trouble: diagnostics",
        },

        {
            "<leader>db",
            "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
            desc = "Trouble: buffer diagnostics",
        },

        {
            "<leader>ds",
            "<cmd>Trouble symbols toggle focus=false<cr>",
            desc = "Trouble: symbols",
        },

        {
            "<leader>di",
            "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
            desc = "Trouble: LSP content",
        },

        {
            "<leader>dl",
            "<cmd>Trouble loclist toggle<cr>",
            desc = "Trouble: location list",
        },

        {
            "<leader>dq",
            "<cmd>Trouble qflist toggle<cr>",
            desc = "Trouble: quickfix list",
        },
    },
}

return {

    "neovim/nvim-lspconfig",

    event = { "BufReadPre", "BufNewFile" },

    dependencies = {
        -- mason
        "williamboman/mason.nvim",
        -- interface with cmp-nvim
        "hrsh7th/cmp-nvim-lsp",
    },

    config = function()

        local lspconfig = require('lspconfig')

        -- language servers configuration
        local my_config = require('semantic_tools')
        my_config.lsp_settings(lspconfig)


        -- customise the way diagnostics are shown
        vim.diagnostic.config({
            virtual_text = false,
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = false
        })

        -- customise diagnostics symbols in the gutter
        local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end


    end,
}

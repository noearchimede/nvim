return {

    "neovim/nvim-lspconfig",

    event = { "BufReadPre", "BufNewFile" },

    dependencies = {
        -- mason
        "williamboman/mason.nvim",
    },

    config = function()

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

        -- Note: normally at this point there would be calls to the 'setup()'
        -- function of each server. In this Neovim config that's handled in the
        -- setup of mason-lspconfig. Doing it throug mason-lspconfig allows to
        -- provide a default trivial setup for servers installed with Mason
        -- that don't need a custom configuration.

    end,
}

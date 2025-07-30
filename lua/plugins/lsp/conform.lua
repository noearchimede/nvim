return {

    "stevearc/conform.nvim",

    keys = {
        { "<leader><leader>f", function() require("conform").format() end, desc = "Conform: format buffer" },
        { "<leader><leader>f", function() require("conform").format() end, mode = 'v', desc = "Conform: format selection" },
    },

    config = function()
        local conform = require("conform")
        local my_config = require("semantic_tools")

        -- conform options
        conform.setup({
            -- set list of formatters for each filetype
            formatters_by_ft = my_config.formatters_by_ft,
            -- always try to use 'vim.lsp.buf.format()' as a fallback
            default_format_opts = {
                lsp_format = "fallback", -- default is 'never'
            },
        })

        -- set options for individual formatters
        my_config.formatter_settings(conform.formatters)

    end,
}

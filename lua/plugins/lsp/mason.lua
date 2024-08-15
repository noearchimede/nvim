return {

    "williamboman/mason.nvim",

    dependencies = {
        -- interface with nvim-lspconfig
        "williamboman/mason-lspconfig.nvim",
        -- install or upgrade third-party tools
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },

    config = function()

        require("mason").setup()

        -- the configuration of language servers is outsourced to this file
        local my_config = require('semantic_tools')

        -- define a list of default tools
        require("mason-tool-installer").setup({
            ensure_installed = my_config.mason_tools,
        })

        -- define a list of default language servers
        require("mason-lspconfig").setup({
            -- list of servers for mason to install
            ensure_installed = my_config.mason_lsp,
        })

        -- setup individual language servers
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local lspconfig = require("lspconfig")
        require("mason-lspconfig").setup_handlers(my_config.lsp_settings(lspconfig, capabilities))

    end

}

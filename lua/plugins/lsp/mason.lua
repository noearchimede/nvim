return {

    "williamboman/mason.nvim",

    dependencies = {
        -- interface with nvim-lspconfig
        "williamboman/mason-lspconfig.nvim",
        -- install or upgrade third-party tools
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },

    config = function()

        -- language-specific LSP settings are defined in this file
        local my_config = require('semantic_tools')

        -- get capabilities from lsp protocol
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

        ---- set up mason (must come first!) ----

        require("mason").setup()

        ---- setup non-LSP tools ----

        require("mason-tool-installer").setup({
            -- list of non-lsp tools that mason will make sure are installed
            ensure_installed = my_config.mason_tools_ensure_installed,
        })

        ---- setup LSPs ----

        -- The lspconfig setup is done here (not directly in the setup function
        -- for lspconfig) because mason-lspconfig allows to define a default
        -- trivial installer for LSP installed via Mason that don't have a
        -- custom configuration

        -- prepare the 'handlers' table (see :h mason-lspconfig.setup_handlers) based on the settings in the custom semantic toos configuration file
        local handlers = {
            -- provide a default installer for servers that are not set up manually
            function(server_name)
                require("lspconfig")[server_name].setup({ capabilities = capabilities })
            end
        }
        -- programatically define setup functions for each LSP based on the settings table in the 'semantic_tools' file
        for name, settings in pairs(my_config.lsp_settings(capabilities)) do
            handlers[name] = function()
                require('lspconfig')[name].setup(settings)
            end
        end

        require("mason-lspconfig").setup({
            -- list of servers that mason will make sure are installed
            ensure_installed = my_config.mason_lsp_ensure_installed,
            -- setup of individual handlers
            handlers = handlers
        })

    end

}

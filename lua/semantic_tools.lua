local M = {}


-- Tools that mason-tool-installer will install automatically if missing
M.mason_tools = {
    "prettier", -- prettier formatter
    "stylua", -- lua formatter
    "pylint", -- python linter
}


-- Language servers that mason-lspconfig will install automatically if missing
M.mason_lsp = {
    "lua_ls",
    "pyright",
    "clangd",
}


-- Language server settings, for 'mason-lspconfig.setup_handlers()'
M.lsp_settings = function(lspconfig, capabilities)
    return {

        -- default handler

        function(server_name)
            lspconfig[server_name].setup({
                capabilities = capabilities,
            })
        end,


        -- define a special handler for each LS that requires something different than the default

        ["lua_ls"] = function()
            lspconfig["lua_ls"].setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
                        -- make the language server recognize "vim" global
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                }
            })
        end,


        ["clangd"] = function()
            lspconfig["clangd"].setup({
                capabilities = capabilities,
                settings = {}
            })
        end,

    }
end


return M

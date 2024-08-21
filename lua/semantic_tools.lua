local M = {}


-- Treesitter parsers
M.treesitter_parsers = {
    "regex",
    "c",
    "lua",
    "vim",
    "vimdoc",
    "bash",
    "query",
    "cpp",
    "python",
    "html",
    "markdown",
    "markdown_inline"
}


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
                        workspace = {
                            library = {
                                -- make the language server recognize "vim" global
                                vim.env.VIMRUNTIME
                            }
                        },
                        format = {
                            -- for defaults and a list of options see:
                            -- https://github.com/CppCXY/EmmyLuaCodeStyle/blob/master/lua.template.editorconfig
                            defaultConfig = {

                                -- disable most alignment settings that are enable by default
                                align_continuous_assign_statement = "false",
                                align_continuous_rect_table_field = "false",
                                align_array_table = "false",
                                align_continuous_inline_comment = "false",

                                -- always prevent the formatter from adding/removing blank lines
                                line_space_after_function_statement = "keep",
                                line_space_around_block = "keep",

                            }
                        }
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

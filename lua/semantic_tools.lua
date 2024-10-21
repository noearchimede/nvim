local M = {}


--------------------------------------------------------------------------------
-- Treesitter
--------------------------------------------------------------------------------

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



--------------------------------------------------------------------------------
-- Non-LSP tools
--------------------------------------------------------------------------------


-- Tools that mason-tool-installer will install automatically if missing
M.mason_tools_ensure_installed = {
    "prettier", -- prettier formatter
    "black", -- python formatter
    "shfmt" -- shell scripting formatter
}

-- Formatters used by Conform (they must also be added to to the 'mason_tools' list to enforce installation)
M.conform_formatters_by_ft = function()
    return {
        lua = { lsp_format = "prefer" }, -- use lua_ls (lsp)
        python = { "black" },
        sh = { "shfmt" },
    }
end


-- formatter settings for conform.nvim
M.formatter_settings = function(conform_formatters)

    -- example (from Conform README)
    --[[
    conform_formatters.yamlfix = {
        env = {
            YAMLFIX_SEQUENCE_STYLE = "block_style",
        },
    } ]]

end



--------------------------------------------------------------------------------
-- LSP
--------------------------------------------------------------------------------


-- Language servers that mason-lspconfig will install automatically if missing
M.mason_lsp_ensure_installed = {
    "lua_ls",
    "pyright",
    "clangd",
    "bashls"
}


-- Language server settings for lspconfig.
--  -  one entry per language server, with the name used in lspconfig (not mason)
--  -  if the default values are fine it is not necessary to write anything here
--  -  each entry contains a table; the table is passed to 'lspconfig.server.setup()'
--  -  this table is handled by mason-lspconfig in the setup_handlers method
--
-- For a list of available options see :lspconfig-setup
M.lsp_settings = function(capabilities)

    return {

        lua_ls = {
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

                            -- disable most alignment settings that are enabled by default
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
        },

        clangd = {
            capabilities = capabilities,
            cmd = {
                "clangd",
                -- use the WebKit format if there is no .clangd-format file in the project root
                "--fallback-style=WebKit",
            }
        }

    }

end



return M

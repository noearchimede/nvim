local M = {}


--------------------------------------------------------------------------------
-- Treesitter
--------------------------------------------------------------------------------


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



--------------------------------------------------------------------------------
-- Formatters
--------------------------------------------------------------------------------


-- Tools that mason-tool-installer will install automatically if missing
M.mason_tools = {
    "prettier", -- prettier formatter
    "black", -- python formatter
}

-- Formatters used by Conform (they must also be added to to the 'mason_tools' list to enforce installation)
M.conform_formatters_by_ft = function()
    return {
        lua = { }, -- use lua_ls (lsp)
        python = { "black" },
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
M.mason_lsp = {
    "lua_ls",
    "pyright",
    "clangd",
    "bashls"
}


-- Language server settings, executed in the config function of lspconfig
M.lsp_settings = function(lspconfig)

    lspconfig.lua_ls.setup({
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
    })

    lspconfig.clangd.setup({
        cmd = {
            "clangd",
            -- use the WebKit format if there is no .clangd-format file in the project root
            "--fallback-style=WebKit",
        }
    })

end



return M

return {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
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
}

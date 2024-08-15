return {

    'windwp/nvim-autopairs',

    event = "InsertEnter",

    opts = {
        disable_filetype = { "TelescopePrompt", "spectre_panel" },

        disable_in_macro = true, -- disable when recording or executing a macro
        disable_in_visualblock = true, -- disable when insert after visual block mode
        disable_in_replace_mode = true,

        ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=], --   all alphanumeric % ' [ " . ` $

        enable_moveright = true, -- ???
        enable_afterquote = true, -- add bracket pairs after quote
        enable_check_bracket_line = true, --- check bracket in same line
        enable_bracket_in_quote = false, --

        enable_abbr = false, -- trigger abbreviation

        break_undo = true, -- switch for basic rule break undo sequence

        map_cr = false, -- NOTE: before enabling this check docs about integration with nvim-cmp
        map_bs = true, -- map the <BS> key
        map_c_h = false, -- Map the <C-h> key to delete a pair
        map_c_w = false, -- map <c-w> to delete a pair if possible

        check_ts = true,
        ts_config = {
            --all = {'comment'},
            lua = { 'string', 'source' }, -- it will not add a pair on that treesitter node
        }
    },

    init = function()
        require('nvim-autopairs.rule')
        require('nvim-autopairs')
        require('nvim-autopairs.conds')
    end

}

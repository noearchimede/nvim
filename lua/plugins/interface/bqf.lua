return {

    "kevinhwang91/nvim-bqf",

    dependencies = {
        'junegunn/fzf', -- see https://github.com/junegunn/fzf/blob/master/README-VIM.md
    },

    -- Note: I use two plugins that provide quickfix features, nvim-bqf and quicker.
    -- In the current config, nvim-bqf provides:
    --  * preview
    --  * fzf filter
    --  * ability to mark ('sign') items and create quickfix lists based on signs
    --  * mappings to open in split
    
    ft = "qf",

    opts = {
        auto_resize_height = true,
        preview = {
            auto_preview = false
        },
        -- Note: many quickfix-related mappings are defined in mappings.lua
        -- Some of those could also be defined here, but when given the choice use mappings.lua
        func_map = {
            -- Refer to :h map_quickfix for a full list of mappings (and keep it up to date!)
            open = '', -- mappings.lua
            openc = '', -- mappings.lua
            drop = '', -- mappings.lua
            tabdrop = '', -- mappings.lua
            split = '<C-x>',
            vsplit = '<C-v>',
            tab = '<C-t>',
            tabb = '', -- not used
            tabc = '', -- not used
            prevfile = ']f',
            nextfile = '[f',
            prevhist = '', -- mappings.lua
            nexthist = '', -- mappings.lua
            lastleave = [['"]],
            stoggleup = '',
            stoggledown = 'm',
            stogglevm = 'm',
            stogglebuf = 'M',
            sclear = '<localleader>m',
            pscrollup = '<C-b>',
            pscrolldown = '<C-f>',
            pscrollorig = '<localleader>r',
            ptogglemode = '<localleader>p',
            ptoggleitem = '',
            ptoggleauto = '<Tab>',
            filter = '<localleader>f',
            filterr = '<localleader>F',
            fzffilter = '<localleader>s'
        },
    },

}

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
        func_map = {
            open = '', -- defined in mappings.lua
            openc = '', -- defined in mappings.lua
            drop = '', -- not used
            tabdrop = '', -- not used
            split = '<C-x>',
            vsplit = '<C-v>',
            tab = '<C-t>',
            tabb = '', -- not used
            tabc = '', -- not used
            prevfile = 'K',
            nextfile = 'J',
            prevhist = '', -- defined in mappings.lua
            nexthist = ' ', -- defined in mappings.lua
            lastleave = [['"]],
            stoggleup = '<S-Tab>',
            stoggledown = '<Tab>',
            stogglevm = '<Tab>',
            stogglebuf = [['<Tab>]],
            sclear = 'z<Tab>',
            pscrollup = '<C-b>',
            pscrolldown = '<C-f>',
            pscrollorig = 'zo',
            ptogglemode = 'zp',
            ptoggleitem = 'p',
            ptoggleauto = 'P',
            filter = 'zn',
            filterr = 'zN',
            fzffilter = 'zf'
        },
    },

}

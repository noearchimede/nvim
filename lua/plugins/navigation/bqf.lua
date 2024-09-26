return {

    "kevinhwang91/nvim-bqf",

    event = "FileType qf",

    opts = {
        preview = {
            auto_preview = false,
            auto_resize_height = true,
            win_height = 15,
            win_vheight = 15,
            winblend = 0
        },
        func_map = {
            -- copied all default mappings. Must be explicitly set to '' to disable.
            open = '<CR>',
            openc = 'o',
            drop = '',
            tabdrop = '',
            tab = '',
            tabb = '<c-t>', -- tab background
            tabc = '',
            split = '<c-x>',
            vsplit = '<c-v>',
            prevfile = 'K',
            nextfile = 'J',
            prevhist = '<c-p>',
            nexthist = '<c-n>',
            lastleave = '"',
            stoggleup = '<s-Tab>',
            stoggledown = '<Tab>',
            stogglevm = '<Tab>',
            stogglebuf = "'<Tab>",
            sclear = 'z<Tab>',
            pscrollup = '<c-b>',
            pscrolldown = '<c-f>',
            pscrollorig = 'zz',
            ptogglemode = 'P',
            ptoggleitem = '',
            ptoggleauto = 'p',
            filter = 'zn',
            filterr = 'zN',
            fzffilter = '',
        }
    }
}

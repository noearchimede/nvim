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
            -- must be explicitly set to '' to disable

            open = '', -- handled externally
            openc = '', -- handled externally
            drop = '', -- not used
            tabdrop = '', -- not used
            tab = '', -- not used
            tabb = '', -- handled externally
            tabc = '', -- not used
            split = '', -- handled externally
            vsplit = '', -- handled externally

            prevfile = 'K',
            nextfile = 'J',

            prevhist = '', -- handled externally
            nexthist = '', -- handled externally

            lastleave = '<localleader>l',

            stoggleup = '',
            stoggledown = '<Tab>',
            stogglevm = '<Tab>',
            stogglebuf = '<s-Tab>',
            sclear = '<localleader>c',
            filter = '<localleader>f',
            filterr = '<localleader>F',

            pscrollup = '<c-b>',
            pscrolldown = '<c-f>',
            pscrollorig = '<localleader>r',
            ptogglemode = '<localleader>z',
            ptoggleitem = '<localleader>p',
            ptoggleauto = 'p',

            fzffilter = '', -- fzf not installed
        }
    }
}

return {

    'Wansmer/treesj',

    keys = {
        { '<leader>ij', function() require('treesj').toggle() end, desc = "TreeSJ: toggle" },
    },

    opts = {
        use_default_keymaps = false,
        check_syntax_error = true, -- do not act on nodes with errors
        max_join_length = 150, -- do not join if resulting line is wider than this
        cursor_behavior = 'hold', -- cursor stays where it was
        notify = true,
        dot_repeat = true,
        on_error = nil,
    }
}

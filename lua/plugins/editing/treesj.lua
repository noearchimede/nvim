return {

    'Wansmer/treesj',

    keys = {
        { '<leader>ij', function() require('treesj').toggle() end, desc = "TreeSJ: toggle" },
    },

    opts = {
        use_default_keymaps = false,
        max_join_length = 150, -- do not join if resulting line is wider than this
    }
}

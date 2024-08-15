return {

    "ggandor/leap.nvim",

    keys = { 's', 'S', 'gs' },

    config = function()
        -- those are the default mappings (s: forward, S: backward, gs: leap from window)
        vim.keymap.set({'n', 'x', 'o'}, 's',  '<Plug>(leap-forward)')
        vim.keymap.set({'n', 'x', 'o'}, 'S',  '<Plug>(leap-backward)')
        vim.keymap.set({'n', 'x', 'o'}, 'gs', '<Plug>(leap-from-window)')
    end

}

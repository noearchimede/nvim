return {

    'sindrets/diffview.nvim',

    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },

    keys = {
        { '<leader>gdd', '<cmd>DiffviewOpen<cr>', desc = "Diffview: open" },
        { '<leader>gdc', function()
            -- use feedkeys to start the autocompletion menu with <tab>
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":Diffview<Tab>", true, true, true), 'tn', false)
        end, desc = "Diffview: enter command" },
    },

    cmd = { 'DiffviewOpen' },

    opts = {
        diff_binaries = false, -- Show diffs for binaries
        enhanced_diff_hl = true, -- See |diffview-config-enhanced_diff_hl|
        use_icons = true, -- Requires nvim-web-devicons
        show_help_hints = true, -- Show hints for how to open the help panel
        watch_index = true, -- Update views and index buffers when the git index changes.
    }

}

return {

    "lukas-reineke/indent-blankline.nvim",

    main = "ibl",

    event = "VeryLazy",

    keys = {
        { '<leader>yi', '<cmd>IBLToggle<cr>', desc = "IBL: toggle indent guides" },
        { '<leader>ys', '<cmd>IBLToggleScope<cr>', desc = "IBL: toggle scope guides" },
    },

    opts = {
        scope = {
            show_start = false -- do not uderline start of scope
        },
        exclude = {
            filetypes = {
            }
        }
    },
}

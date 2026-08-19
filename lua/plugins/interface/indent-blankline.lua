return {

    "lukas-reineke/indent-blankline.nvim",

    main = "ibl",

    event = "VeryLazy",

    keys = {
        { '<leader>zi', '<cmd>IBLToggle<cr>', desc = "IBL: toggle indent guides" },
        { '<leader>zs', '<cmd>IBLToggleScope<cr>', desc = "IBL: toggle scope guides" },
    },

    opts = {},
}

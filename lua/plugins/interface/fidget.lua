return {

    "j-hui/fidget.nvim",

    event = "VeryLazy",

    keys = {
        { "<leader>nc", "<cmd>Fidget clear<cr>", desc = "Fidget: clear notifications" },
        { "<leader>nh", "<cmd>Fidget history<cr>", desc = "Fidget: show history" },
    },

    opts = {
        notification = {
            --override vim.notify()
            override_vim_notify = true
        }
    }

}

return {

    "debugloop/telescope-undo.nvim",

    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim"
    },

    keys = {
        { "<leader>fu", "<cmd>Telescope undo<cr>" }
    },

    cmd = { "Telescope undo" },

    config = function()
        require("telescope").load_extension("undo")
    end,

}

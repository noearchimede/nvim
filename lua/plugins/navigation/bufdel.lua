return {

    'ojroques/nvim-bufdel',

    keys = {
        { "<leader>bd", "<cmd>BufDel<cr>", desc = "Bbye: close buffer" },
    },

    opts = {
        next = 'alternate',
        quit = false
    }

}

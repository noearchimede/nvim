return {

    "ton/vim-bufsurf",

    -- bufsurf needs to keep track of buffer history, so it can not be lazy
    -- loaded
    lazy = false,

    keys = {
        { "<leader>bi", "<Plug>(buf-surf-forward)", noremap = false,
            desc = "Bufsurf: next buffer in window" },
        { "<leader>bo", "<Plug>(buf-surf-back)", noremap = false,
            desc = "Bufsurf: previous buffer in window" }
    }
}

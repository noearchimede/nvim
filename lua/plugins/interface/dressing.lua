return {

    "stevearc/dressing.nvim",

    opts = {
        input = {
            -- default is 'cursor' to have the input field next to the cursor,
            -- however this may cause issues in narrow windows (test e.g. on
            -- the "copy-paste node" action in nvim-tree)
            -- (see https://github.com/stevearc/dressing.nvim/discussions/81#discussioncomment-4715047)
            relative = "editor",
        }
    }

}

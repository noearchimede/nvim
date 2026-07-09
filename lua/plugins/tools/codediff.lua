return {

    "esmuellert/codediff.nvim",

    cmd = "CodeDiff",

    keys = {
        { '<leader>gd', '<cmd>CodeDiff<cr>', desc = "CodeDiff: open" },
        { '<leader>ga', ':<C-U>CodeDiff ', desc = "CodeDiff: select commit" },
        { '<leader>gf', '<cmd>CodeDiff file ', desc = "CodeDiff: open file diff" },
        { '<leader>gh', '<cmd>CodeDiff history<cr>', desc = "CodeDiff: history" },
    },

    opts = {

        -- Diff view behavior
        diff = {
            cycle_next_hunk = false, -- Wrap around when navigating hunks (]c/[c): false to stop at first/last
            cycle_next_file = false, -- Wrap around when navigating files (]f/[f): false to stop at first/last
            jump_to_first_change = false, -- Auto-scroll to first change when opening a diff: false to stay at same line
        },

        -- Keymaps in diff view
        keymaps = {
            view = {
                quit = "<localleader>q",
                toggle_explorer = "<localleader>b",
                focus_explorer = "<localleader>e",
                stage_hunk = "<localleader>hs",
                unstage_hunk = "<localleader>hu",
                discard_hunk = "<localleader>hr",
            },
            conflict = {
                accept_incoming = "<localleader>ct",
                accept_current = "<localleader>co",
                accept_both = "<localleader>cb",
                discard = "<localleader>cx",
            },
        },
    },
}

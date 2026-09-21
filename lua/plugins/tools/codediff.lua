return {

    "esmuellert/codediff.nvim",

    cmd = "CodeDiff",

    keys = {
        { '<leader>gd', '<cmd>CodeDiff<cr>', desc = "CodeDiff: open" },
        { '<leader>ga', ':<C-U>CodeDiff ', desc = "CodeDiff: select commit" },
        { '<leader>gh', '<cmd>CodeDiff history<cr>', desc = "CodeDiff: history" },
        { '<leader>gf', '<cmd>CodeDiff history %<cr>', desc = "CodeDiff: file history" },
    },

    opts = {

        -- Diff view behavior
        diff = {
            cycle_next_hunk = false, -- Wrap around when navigating hunks (]c/[c): false to stop at first/last
            cycle_next_file = false, -- Wrap around when navigating files (]f/[f): false to stop at first/last
            jump_to_first_change = false, -- Auto-scroll to first change when opening a diff: false to stay at same line
            compute_moves = true -- Detect blocks of code that moved within a file
        },

        -- Keymaps in diff view
        keymaps = {
            view = {
                quit = "<localleader>q",
                toggle_stage = "<localleader>S",
                toggle_explorer = "<localleader>b",
                focus_explorer = "<localleader>e",
                stage_hunk = "<localleader>s",
                unstage_hunk = "<localleader>u",
                discard_hunk = "<localleader>r",
                toggle_compact = "<localleader>c",
                toggle_layout = "<localleader>l",
                align_move = "<localleader>m",
            },
            explorer = {
                refresh = "<CTRL-R>",
                toggle_view_mode = "<localleader>v",
                toggle_changes = false,
                toggle_staged = false,
            },
            history = {
                toggle_view_mode = "<localleader>h",
            },
            conflict = {
                accept_incoming = "<localleader>t",
                accept_current = "<localleader>o",
                accept_both = "<localleader>a",
                discard = "<localleader>x",
            },
        },
    },

    config = function(_, opts)

        require('codediff').setup(opts)

        -- add additional custom mappings
        vim.api.nvim_create_autocmd("User", {
            pattern = "CodeDiffOpen",
            callback = function(args)
                -- in history mode: use J/K to go up/down and select immediately
                if args.data.mode == "history" then
                    local buf = vim.api.nvim_get_current_buf()
                    vim.keymap.set("n", "J", "j<CR>", { buffer = buf, remap = true })
                    vim.keymap.set("n", "K", "k<CR>", { buffer = buf, remap = true })
                end
            end,
        })
    end
}

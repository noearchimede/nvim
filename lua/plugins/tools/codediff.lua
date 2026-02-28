return {

    "esmuellert/codediff.nvim",

    cmd = "CodeDiff",

    keys = {
        { '<leader>gd', '<cmd>CodeDiff<cr>', desc = "CodeDiff: open" },
        { '<leader>ga', '<cmd>CodeDiff ', desc = "CodeDiff: select commit" },
        { '<leader>gf', '<cmd>CodeDiff file ', desc = "CodeDiff: open file diff" },
        { '<leader>gh', '<cmd>CodeDiff history<cr>', desc = "CodeDiff: history" },
    },

    opts = {

        -- Diff view behavior
        diff = {
            hide_merge_artifacts = false, -- Hide merge tool temp files (*.orig, *.BACKUP.*, *.BASE.*, *.LOCAL.*, *.REMOTE.*)
            cycle_next_hunk = false, -- Wrap around when navigating hunks (]c/[c): false to stop at first/last
            cycle_next_file = false, -- Wrap around when navigating files (]f/[f): false to stop at first/last
            jump_to_first_change = false, -- Auto-scroll to first change when opening a diff: false to stay at same line
        },

        -- Keymaps in diff view
        keymaps = {
            view = {
                quit = "q", -- Close diff tab
                toggle_explorer = "<localleader>b", -- Toggle explorer visibility (explorer mode only)
                focus_explorer = "<localleader>e", -- Focus explorer panel (explorer mode only)
                next_hunk = "]c", -- Jump to next change
                prev_hunk = "[c", -- Jump to previous change
                next_file = "]f", -- Next file in explorer/history mode
                prev_file = "[f", -- Previous file in explorer/history mode
                diff_get = "do", -- Get change from other buffer (like vimdiff)
                diff_put = "dp", -- Put change to other buffer (like vimdiff)
                open_in_prev_tab = "gf", -- Open current buffer in previous tab (or create one before)
                close_on_open_in_prev_tab = false, -- Close codediff tab after gf opens file in previous tab
                toggle_stage = "-", -- Stage/unstage current file (works in explorer and diff buffers)
                stage_hunk = "<localleader>hs", -- Stage hunk under cursor to git index
                unstage_hunk = "<localleader>hu", -- Unstage hunk under cursor from git index
                discard_hunk = "<localleader>hr", -- Discard hunk under cursor (working tree only)
                hunk_textobject = "ih", -- Textobject for hunk (vih to select, yih to yank, etc.)
                show_help = "g?", -- Show floating window with available keymaps
            },
            explorer = {
                select = "<CR>", -- Open diff for selected file
                hover = "K", -- Show file diff preview
                refresh = "R", -- Refresh git status
                toggle_view_mode = "i", -- Toggle between 'list' and 'tree' views
                stage_all = "S", -- Stage all files
                unstage_all = "U", -- Unstage all files
                restore = "X", -- Discard changes (restore file)
                toggle_changes = "gu", -- Toggle Changes (unstaged) group visibility
                toggle_staged = "gs", -- Toggle Staged Changes group visibility
            },
            history = {
                select = "<CR>", -- Select commit/file or toggle expand
                toggle_view_mode = "i", -- Toggle between 'list' and 'tree' views
            },
            conflict = {
                accept_incoming = "<localleader>ct", -- Accept incoming (theirs/left) change
                accept_current = "<localleader>co", -- Accept current (ours/right) change
                accept_both = "<localleader>cb", -- Accept both changes (incoming first)
                discard = "<localleader>cx", -- Discard both, keep base
                next_conflict = "]x", -- Jump to next conflict
                prev_conflict = "[x", -- Jump to previous conflict
                diffget_incoming = "2do", -- Get hunk from incoming (left/theirs) buffer
                diffget_current = "3do", -- Get hunk from current (right/ours) buffer
            },
        },
    },
}

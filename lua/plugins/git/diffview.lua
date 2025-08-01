return {

    'sindrets/diffview.nvim',

    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },

    keys = {
        { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = "Diffview: open" },
        { '<leader>gh', '<cmd>DiffviewFileHistory<cr>', desc = "Diffview: history" },
        { '<leader>gf', '<cmd>DiffviewFileHistory %<cr>', desc = "Diffview: file history" },
    },

    cmd = { 'DiffviewOpen' },

    config = function()

        local actions = require("diffview.actions")

        require("diffview").setup({

            enhanced_diff_hl = true, -- See |diffview-config-enhanced_diff_hl|
            keymaps = {
                -- The defaults are generally ok but have a few problems for my config:
                --  - leader is used instead of localleader
                --  - some mappings are not intuitive
                --  - some mappings are redundant (making the help page needlessly long to read)
                -- Instead of deleting and remapping individual defaults I overwrite all of them (easier to edit).
                disable_defaults = true, -- Disable the default keymaps
                view = {
                    -- The `view` bindings are active in the diff buffers, only when the current tabpage is a Diffview.
                    ["<localleader>q"] = "<cmd>DiffviewClose<cr>",
                    ["<c-p>"] = actions.select_prev_entry,
                    ["<c-n>"] = actions.select_next_entry,
                    ["<cr>"] = actions.goto_file_edit,
                    ["<C-x>"] = actions.goto_file_split,
                    ["<C-t>"] = actions.goto_file_tab,
                    ["<localleader>f"] = actions.focus_files,
                    ["<localleader>e"] = actions.toggle_files,
                    ["<localleader>l"] = actions.cycle_layout,
                    ["[x"] = actions.prev_conflict,
                    ["]x"] = actions.next_conflict,
                    ["<localleader>co"] = actions.conflict_choose("ours"),
                    ["<localleader>ct"] = actions.conflict_choose("theirs"),
                    ["<localleader>cb"] = actions.conflict_choose("base"),
                    ["<localleader>ca"] = actions.conflict_choose("all"),
                    ["<localleader>cn"] = actions.conflict_choose("none"),
                    ["<localleader>cO"] = actions.conflict_choose_all("ours"),
                    ["<localleader>cT"] = actions.conflict_choose_all("theirs"),
                    ["<localleader>cB"] = actions.conflict_choose_all("base"),
                    ["<localleader>cA"] = actions.conflict_choose_all("all"),
                    ["<localleader>cN"] = actions.conflict_choose_all("none"),
                },
                diff1 = {
                    -- Mappings in single window diff layouts
                    ["g?"] = actions.help({ "view", "diff1" }),
                },
                diff2 = {
                    -- Mappings in 2-way diff layouts
                    ["g?"] = actions.help({ "view", "diff2" }),
                },
                diff3 = {
                    -- Mappings in 3-way diff layouts
                    { { "n", "x" }, "2do", actions.diffget("ours"), { desc = "Obtain the diff hunk from the OURS version of the file" } },
                    { { "n", "x" }, "3do", actions.diffget("theirs"), { desc = "Obtain the diff hunk from the THEIRS version of the file" } },
                    ["g?"] = actions.help({ "view", "diff3" }),
                },
                diff4 = {
                    -- Mappings in 4-way diff layouts
                    { { "n", "x" }, "1do", actions.diffget("base"), { desc = "Obtain the diff hunk from the BASE version of the file" } },
                    { { "n", "x" }, "2do", actions.diffget("ours"), { desc = "Obtain the diff hunk from the OURS version of the file" } },
                    { { "n", "x" }, "3do", actions.diffget("theirs"), { desc = "Obtain the diff hunk from the THEIRS version of the file" } },
                    ["g?"] = actions.help({ "view", "diff4" }),
                },
                file_panel = {
                    ["<localleader>q"] = "<cmd>DiffviewClose<cr>",
                    ["j"] = actions.next_entry,
                    ["k"] = actions.prev_entry,
                    ["<cr>"] = actions.focus_entry,
                    ["o"] = actions.select_entry,
                    ["s"] = actions.toggle_stage_entry,
                    ["S"] = actions.stage_all,
                    ["U"] = actions.unstage_all,
                    ["X"] = actions.restore_entry,
                    ["L"] = actions.open_commit_log,
                    ["zo"] = actions.open_fold,
                    ["zc"] = actions.close_fold,
                    ["za"] = actions.toggle_fold,
                    ["zR"] = actions.open_all_folds,
                    ["zM"] = actions.close_all_folds,
                    ["<c-b>"] = actions.scroll_view(-0.25),
                    ["<c-f>"] = actions.scroll_view(0.25),
                    ["J"] = actions.select_next_entry,
                    ["K"] = actions.select_prev_entry,
                    ["h"] = actions.goto_file_split,
                    ["t"] = actions.goto_file_tab,
                    ["i"] = actions.listing_style,
                    ["F"] = actions.toggle_flatten_dirs,
                    ["<c-r>"] = actions.refresh_files,
                    ["<localleader>f"] = actions.focus_files,
                    ["<localleader>e"] = actions.toggle_files,
                    ["<localleader>l"] = actions.cycle_layout,
                    ["g?"] = actions.help("file_panel"),
                    ["<localleader>cO"] = actions.conflict_choose_all("ours"),
                    ["<localleader>cT"] = actions.conflict_choose_all("theirs"),
                    ["<localleader>cB"] = actions.conflict_choose_all("base"),
                    ["<localleader>cA"] = actions.conflict_choose_all("all"),
                    ["<localleader>cN"] = actions.conflict_choose_all("none"),
                },
                file_history_panel = {
                    ["<localleader>q"] = "<cmd>DiffviewClose<cr>",
                    ["<localleader>o"] = actions.options,
                    ["<localleader>d"] = actions.open_in_diffview,
                    ["y"] = actions.copy_hash,
                    ["L"] = actions.open_commit_log,
                    ["X"] = actions.restore_entry,
                    ["zo"] = actions.open_fold,
                    ["zc"] = actions.close_fold,
                    ["za"] = actions.toggle_fold,
                    ["zR"] = actions.open_all_folds,
                    ["zM"] = actions.close_all_folds,
                    ["j"] = actions.next_entry,
                    ["k"] = actions.prev_entry,
                    ["<cr>"] = actions.focus_entry,
                    ["o"] = actions.select_entry,
                    ["<c-b>"] = actions.scroll_view(-0.25),
                    ["<c-f>"] = actions.scroll_view(0.25),
                    ["J"] = actions.select_next_entry,
                    ["K"] = actions.select_prev_entry,
                    ["<c-x>"] = actions.goto_file_split,
                    ["<c-t>"] = actions.goto_file_tab,
                    ["<localleader>f"] = actions.focus_files,
                    ["<localleader>e"] = actions.toggle_files,
                    ["<localleader>l"] = actions.cycle_layout,
                    ["g?"] = actions.help("file_history_panel"),
                },
                option_panel = {
                    ["<tab>"] = actions.select_entry,
                    ["<cr>"] = actions.select_entry,
                    ["q"] = actions.close,
                    ["g?"] = actions.help("option_panel"),
                },
                help_panel = {
                    ["q"] = actions.close,
                    ["<esc>"] = actions.close,
                },
            }
        })
    end

}

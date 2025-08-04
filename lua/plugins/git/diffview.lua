return {

    'sindrets/diffview.nvim',

    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },

    keys = {
        { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = "Diffview: open" },
        { '<leader>gh', '<cmd>DiffviewFileHistory --base=LOCAL<cr>', desc = "Diffview: history" },
        { '<leader>gf', '<cmd>DiffviewFileHistory --base=LOCAL %<cr>', desc = "Diffview: file history" },
    },

    cmd = { 'DiffviewOpen' },

    config = function()

        local actions = require("diffview.actions")

        local function mappings_generator()
            local function unmap(key)
                return { "n", key, false }
            end
            local function map(key, action, desc)
                return { "n", key, action, { desc = desc } }
            end
            return {
                disable_defaults = false, -- Disable the default keymaps

                view = {
                    -- additional mappings
                    map("<localleader>q", "<cmd>DiffviewClose<cr>", "Close Diffview"),
                    -- remappings from leader to localleader
                    unmap("<C-w><C-f>"),
                    map("<C-x>", actions.goto_file_split, "Open the file in a new split"),
                    unmap("<C-w>gf"),
                    map("<C-t>", actions.goto_file_tab, "Open the file in a new tabpage"),
                    unmap("<leader>e"),
                    map("<localleader>e", actions.focus_files, "Bring focus to the file panel"),
                    unmap("<leader>b"),
                    map("<localleader>b", actions.toggle_files, "Toggle the file panel."),
                    unmap("<leader>co"),
                    map("<localleader>co", actions.conflict_choose("ours"), "Choose the OURS version of a conflict"),
                    unmap("<leader>ct"),
                    map("<localleader>ct", actions.conflict_choose("theirs"),
                        "Choose the THEIRS version of a conflict"),
                    unmap("<leader>cb"),
                    map("<localleader>cb", actions.conflict_choose("base"), "Choose the BASE version of a conflict"),
                    unmap("<leader>ca"),
                    map("<localleader>ca", actions.conflict_choose("all"), "Choose all the versions of a conflict"),
                    unmap("dx"),
                    map("<localleader>cn", actions.conflict_choose("none"), "Delete the conflict region"),
                    unmap("<leader>cO"),
                    map("<localleader>cO", actions.conflict_choose_all("ours"),
                        "Choose the OURS version of a conflict for the whole file"),
                    unmap("<leader>cT"),
                    map("<localleader>cT", actions.conflict_choose_all("theirs"),
                        "Choose the THEIRS version of a conflict for the whole file"),
                    unmap("<leader>cB"),
                    map("<localleader>cB", actions.conflict_choose_all("base"),
                        "Choose the BASE version of a conflict for the whole file"),
                    unmap("<leader>cA"),
                    map("<localleader>cA", actions.conflict_choose_all("all"),
                        "Choose all the versions of a conflict for the whole file"),
                    unmap("dX"),
                    map("<localleader>cN", actions.conflict_choose_all("none"),
                        "Delete the conflict region for the whole file"),
                },
                file_panel = {
                    -- removed mappings
                    unmap("-"),
                    -- additional mappings
                    map("<localleader>q", "<cmd>DiffviewClose<cr>", "Close Diffview"),
                    -- remappings
                    unmap("<C-w><C-f>"),
                    map("<C-x>", actions.goto_file_split, "Open the file in a new split"),
                    unmap("<C-w>gf"),
                    map("<C-t>", actions.goto_file_tab, "Open the file in a new tabpage"),
                    unmap("<localleader>e"),
                    map("<localleader>e", actions.focus_files, "Bring focus to the file panel"),
                    unmap("<leader>b"),
                    map("<localleader>b", actions.toggle_files, "Toggle the file panel"),
                    unmap("<leader>cO"),
                    map("<localleader>cO", actions.conflict_choose_all("ours"),
                        "Choose the OURS version of a conflict for the whole file"),
                    unmap("<leader>cT"),
                    map("<localleader>cT", actions.conflict_choose_all("theirs"),
                        "Choose the THEIRS version of a conflict for the whole file"),
                    unmap("<leader>cB"),
                    map("<localleader>cB", actions.conflict_choose_all("base"),
                        "Choose the BASE version of a conflict for the whole file"),
                    unmap("<leader>cA"),
                    map("<localleader>cA", actions.conflict_choose_all("all"),
                        "Choose all the versions of a conflict for the whole file"),
                    unmap("gX"),
                    map("<localleader>cN", actions.conflict_choose_all("none"),
                        "Delete the conflict region for the whole file"),
                },
                file_history_panel = {
                    -- additional mappings
                    map("<localleader>q", "<cmd>DiffviewClose<cr>", "Close Diffview"),
                    map("<localleader>d", actions.open_in_diffview, "Open the entry under the cursor in a diffview"),
                    -- remappings
                    unmap("<C-w><C-f>"),
                    map("<C-x>", actions.goto_file_split, "Open the file in a new split"),
                    unmap("<C-w>gf"),
                    map("<C-t>", actions.goto_file_tab, "Open the file in a new tabpage"),
                    unmap("<leader>e"),
                    map("<localleader>e", actions.focus_files, "Bring focus to the file panel"),
                    unmap("<leader>b"),
                    map("<localleader>b", actions.toggle_files, "Toggle the file panel"),
                },
            }
        end

        require("diffview").setup({

            enhanced_diff_hl = true, -- See |diffview-config-enhanced_diff_hl|
            keymaps = mappings_generator()
        })
    end

}

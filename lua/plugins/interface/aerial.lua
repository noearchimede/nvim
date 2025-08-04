return {

    'stevearc/aerial.nvim',

    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    },

    keys = {
        { '<leader>aa', '<cmd>AerialOpen<cr>', desc = "Aerial: open (no focus)" },
        { '<leader>af', '<cmd>AerialOpen<cr>', desc = "Aerial: open and focus" },
        { '<leader>aA', '<cmd>AerialClose<cr>', desc = "Aerial: close" },
        { '<leader>ag', '<cmd>AerialNavOpen<cr>', desc = "Aerial: open navigator" },
        { '<leader>an', '<cmd>AerialNext<cr>', desc = "Aerial: next" },
        { '[a', '<cmd>AerialNext<cr>', desc = "Aerial: next" },
        { '<leader>ap', '<cmd>AerialPrev<cr>', desc = "Aerial: prev" },
        { ']a', '<cmd>AerialPrev<cr>', desc = "Aerial: prev" },
    },

    opts = {

        layout = {
            -- max_width = {40, 0.2} means "the lesser of 40 columns or 20% of total"
            max_width = { 40, 0.2 },
            min_width = 15,
            -- key-value pairs of window-local options for aerial window (e.g. winhl)
            win_opts = {
                winhighlight = 'Normal:NvimTreeNormal,EndOfBuffer:NvimTreeEndOfBuffer'
            },
            -- Determines the default direction to open the aerial window. The 'prefer'
            -- options will open the window in the other direction *if* there is a
            -- different buffer in the way of the preferred direction
            default_direction = "prefer_right",
            -- Determines where the aerial window will be opened
            --   edge   - open aerial at the far right/left of the editor
            --   window - open aerial to the right/left of the current window
            placement = "edge",
            -- Preserve window size equality with (:help CTRL-W_=)
            preserve_equality = true,
        },

        -- Determines how the aerial window decides which buffer to display symbols for
        --   window - aerial window will display symbols for the buffer in the window from which it was opened
        --   global - aerial window will display symbols for the current window
        attach_mode = "global",
        -- Keymaps in aerial window. Can be any value that `vim.keymap.set` accepts OR a table of keymap
        -- options with a `callback` (e.g. { callback = function() ... end, desc = "", nowait = true })
        -- Additionally, if it is a string that matches "actions.<name>",
        -- it will use the mapping at require("aerial.actions").<name>
        -- Set to `false` to remove a keymap
        keymaps = {

            ["?"] = "actions.show_help",
            ["g?"] = "actions.show_help",

            ["<CR>"] = "actions.jump",
            ["<2-LeftMouse>"] = "actions.jump",
            ["<C-v>"] = "actions.jump_vsplit",
            ["<C-s>"] = "actions.jump_split",
            ["p"] = "actions.scroll",

            ["J"] = "actions.down_and_scroll",
            ["K"] = "actions.up_and_scroll",

            ["{"] = "actions.prev",
            ["}"] = "actions.next",
            ["[["] = "actions.prev_up",
            ["]]"] = "actions.next_up",

            ["q"] = "actions.close",
            ["<esc>"] = "actions.close",

            ["o"] = "actions.tree_toggle",
            ["O"] = "actions.tree_toggle_recursive",
            ["l"] = "actions.tree_open",
            ["L"] = "actions.tree_open_recursive",
            ["h"] = "actions.tree_close",
            ["H"] = "actions.tree_close_recursive",

            ["za"] = "actions.tree_toggle",
            ["zA"] = "actions.tree_toggle_recursive",
            ["zo"] = "actions.tree_open",
            ["zO"] = "actions.tree_open_recursive",
            ["zc"] = "actions.tree_close",
            ["zC"] = "actions.tree_close_recursive",

            ["zr"] = "actions.tree_increase_fold_level",
            ["zR"] = "actions.tree_open_all",
            ["zm"] = "actions.tree_decrease_fold_level",
            ["zM"] = "actions.tree_close_all",
            ["zx"] = "actions.tree_sync_folds",
            ["zX"] = "actions.tree_sync_folds",

        },

        -- Disable aerial on files with this many lines
        disable_max_lines = 10000,
        -- Disable aerial on files this size or larger (in bytes)
        disable_max_size = 2000000, -- Default 2MB

        -- A list of all symbols to display. Set to false to display all symbols.
        -- This can be a filetype map (see :help aerial-filetype-map)
        -- To see all available values, see :help SymbolKind
        filter_kind = {
            "Class",
            "Constructor",
            "Enum",
            "Function",
            "Interface",
            "Module",
            "Method",
            "Struct",
        },

        -- Determines line highlighting mode when multiple splits are visible.
        -- split_width   Each open window will have its cursor location marked in the
        --               aerial buffer. Each line will only be partially highlighted
        --               to indicate which window is at that location.
        -- full_width    Each open window will have its cursor location marked as a
        --               full-width highlight in the aerial buffer.
        -- last          Only the most-recently focused window will have its location
        --               marked in the aerial buffer.
        -- none          Do not show the cursor locations in the aerial window.
        highlight_mode = "split_width",
        -- Highlight the symbol in the source buffer when cursor is in the aerial win
        highlight_on_hover = false,
        -- When jumping to a symbol, highlight the line for this many ms.
        -- Set to false to disable
        highlight_on_jump = 600,
        -- Run this command after jumping to a symbol (false will disable)
        post_jump_cmd = "normal! zz",

        -- Use symbol tree for folding. Set to true or false to enable/disable
        -- Set to "auto" to manage folds if your previous foldmethod was 'manual'
        -- This can be a filetype map (see :help aerial-filetype-map)
        manage_folds = 'auto',
        -- When you fold code with za, zo, or zc, update the aerial tree as well.
        -- Only works when manage_folds = true
        link_folds_to_tree = true,
        -- Fold code when you open/collapse symbols in the tree.
        -- Only works when manage_folds = true
        link_tree_to_folds = false,

        -- Options for the floating nav windows
        nav = {
            -- Keymaps in the nav window
            keymaps = {

                ["?"] = "actions.show_help",
                ["g?"] = "actions.show_help",

                ["<CR>"] = "actions.jump",
                ["<2-LeftMouse>"] = "actions.jump",
                ["<C-v>"] = "actions.jump_vsplit",
                ["<C-s>"] = "actions.jump_split",

                ["h"] = "actions.left",
                ["l"] = "actions.right",

                ["<esc>"] = "actions.close",
                ["q"] = "actions.close",

            },
        },


    }

}

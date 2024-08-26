return {

    "Vigemus/iron.nvim",

    keys = {
        { '<leader>cs', '<cmd>IronRepl<cr>', desc = "Iron: start" },
        { '<leader>cr', '<cmd>IronRestart<cr>', desc = "Iron: restart" },
        { '<leader>cf', '<cmd>IronFocus<cr>', desc = "Iron: focus" },
        { '<leader>ch', '<cmd>IronHide<cr>', desc = "Iron: hide" },
    },

    config = function()

        require("iron.core").setup({
            config = {

                -- Set how iron deal with windows for the repl (see :h iron-extending)
                visibility = require("iron.visibility").single,

                -- Scope of the repl: one repl per tab (see :h iron-extending)
                scope = require("iron.scope").tab_based,

                -- Whether the repl buffer is a "throwaway" buffer or not
                scratch_repl = false,

                -- Automatically closes the repl window on process end
                close_window_on_exit = false,

                repl_definition = {
                    -- forcing a default
                    python = {
                        -- (from the README)
                        command = { "ipython", "--no-autoindent" },
                        format = require("iron.fts.common").bracketed_paste,
                    },

                },

                -- Repl position. Check `iron.view` for more options,
                repl_open_cmd = require("iron.view").split.vertical.botright(60),

                -- If the repl buffer is listed
                buflisted = false,
            },

            -- All the keymaps are set individually
            -- Below is a suggested default

            keymaps = {

                send_motion = "<leader>c",
                send_line = "<leader>cc",
                visual_send = "<leader>cc",
                -- 'send_file' not mapped; use a visual selection if really needed
                send_until_cursor = "<leader>ca", -- "a" as in "above"

                cr = "<leader>c<cr>",
                interrupt = "<leader>c.",
                exit = "<leader>cq",
                -- 'clear' not mapped to prevent accidental clearing

                -- marks: available but currently not used
                -- send_mark = "<leader>cm",
                -- mark_motion = "<leader>cn",
                -- mark_visual = "<leader>cn",
                -- remove_mark = "<leader>cd",
            },

            -- Highlights the last sent block with bold
            highlight_last = false,
            -- If the highlight is on, you can change how it looks (see nvim_set_hl)
            highlight = { } -- e.g. { bold = true }
        })
    end
}

return {

    "Vigemus/iron.nvim",

    keys = {
        { '<leader>cs', '<cmd>IronRepl<cr>', desc = "Iron: start" },
        { '<leader>cr', '<cmd>IronRestart<cr>', desc = "Iron: restart" },
        { '<leader>cj', '<cmd>IronFocus<cr>', desc = "Iron: jump to repl window" },
        { '<leader>ch', '<cmd>IronHide<cr>', desc = "Iron: hide" },
        { '<leader>ci', function()
            vim.ui.input({ prompt = "Enter command (" .. vim.bo.filetype .. ")" }, function(input)
                if input then
                    vim.cmd('IronSend ' .. input)
                end
            end)
        end, desc = "Iron: send arbitrary command" },
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

                    sh = {
                        command = function(meta)
                            local first_line = vim.api.nvim_buf_get_lines(meta.current_bufnr, 0, 2, false)[1]
                            if string.sub(first_line, 1, 2) == '#!' then
                                -- the first line is a shebang; try to use it
                                vim.notify("REPL started with " .. first_line)
                                return string.sub(first_line, 3, -1)
                            end
                            vim.notify("REPL started with default shell (no shebang found)")
                            -- if nothing is specified use zsh
                            return "$SHELL"
                        end
                    },

                    python = {
                        -- use a single ipython input for each input block (instead of an input for each line)
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
                send_file = "<leader>cf",
                send_until_cursor = "<leader>ca", -- "a" as in "above"

                cr = "<leader>c<cr>",
                interrupt = "<leader>cx",
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

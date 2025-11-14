-- definition of REPLs for each filetype
local function repls()
    return {
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
            block_dividers = { "# %%", "#%%" },
        },

        cpp = {
            command = { "cling" }
        }

    }
end




return {

    "Vigemus/iron.nvim",

    keys = function()
        local iron = require('iron.core')
        local ironll = require('iron.lowlevel')
        -- set of helper functions to make mapping definitions a bit less cluttered
        local function if_repl(func)
            -- execute function: only run function if a REPL is active
            local ft = vim.bo.filetype
            local meta = ironll.get(ft)
            if vim.bo.filetype == 'iron' or ironll.repl_exists(meta) then
                func()
            else
                vim.notify("No REPLs found for filetype " .. ft)
            end
        end
        local function wrap_with_ft(func)
            -- wrap functiont: return function wrapped with correct ft as first argument
            local ft
            if vim.bo.filetype == 'iron' then
                local bufnr = vim.api.nvim_get_current_buf()
                ft = require('iron.lowlevel').get_repl_ft_for_bufnr(bufnr)
            else
                ft = vim.bo.filetype
            end
            return function() func(ft) end
        end
        local function send_command()
            vim.ui.input({ prompt = "Enter command (" .. vim.bo.filetype .. "): " }, function(input)
                if input then
                    vim.cmd('IronSend ' .. input)
                end
            end)
        end
        local function jump_to_iron_and_back()
            if vim.bo.filetype == 'iron' then
                vim.cmd('wincmd p')
            else
                iron.focus_on(vim.bo.filetype)
                vim.cmd('startinsert')
            end
        end
        local function quit_iron()
            local bufnr, ft
            if vim.bo.filetype == 'iron' then
                bufnr = vim.api.nvim_get_current_buf()
                ft = require('iron.lowlevel').get_repl_ft_for_bufnr(bufnr)
            else
                ft = vim.bo.filetype
                iron.focus_on(ft)
                bufnr = vim.api.nvim_get_current_buf()
                vim.cmd('wincmd p')
            end
            iron.close_repl(ft)
            vim.api.nvim_buf_delete(bufnr, { force = true })
        end
        return {
            { '<leader>rs', '<cmd>IronRepl<cr><cmd>stopinsert<cr>', desc = "Iron: start" },
            { '<leader>rl', function() if_repl(function()
                    iron.repl_restart()
                    vim.cmd('stopinsert')
                end) end, desc = "Iron: restart" },
            { '<leader>rq', function() if_repl(quit_iron) end, desc = "Iron: close" },
            { '<leader>rj', function() if_repl(jump_to_iron_and_back) end, desc = "Iron: jump to repl window" },
            { '<leader>rh', function() if_repl(wrap_with_ft(iron.hide_repl)) end, desc = "Iron: hide" },

            { '<leader>rr', function() if_repl(iron.send_line) end, desc = "Iron: send line" },
            { '<leader>rr', mode = { 'v' }, function() if_repl(iron.visual_send) end, desc = "Iron: send selection" },
            { '<leader>rf', function() if_repl(iron.send_file) end, desc = "Iron: send file" },
            { '<leader>rn', function() if_repl(function() iron.send_code_block(true) end) end, desc = "Iron: send block (advance)" },
            { '<leader>rb', function() if_repl(function() iron.send_code_block(false) end) end, desc = "Iron: send block (stay)" },
            { '<leader>ra', function() if_repl(iron.send_until_cursor) end, desc = "Iron: send file up to cursor" },

            { '<leader>ri', function() if_repl(send_command) end, desc = "Iron: send arbitrary command" },
            { '<leader>rx', function() if_repl(wrap_with_ft(function(ft) iron.send(ft, string.char(03)) end)) end, desc = "Iron: interrupt" },
            { '<leader>rc', function() if_repl(wrap_with_ft(function(ft) iron.send(ft, string.char(12)) end)) end, desc = "Iron: clear" },
            { '<leader>r<cr>', function() if_repl(wrap_with_ft(function(ft) iron.send(ft, string.char(13)) end)) end, desc = "Iron: send CR" },
        }
    end,

    cmd = { "IronRepl" },

    config = function()


        require("iron.core").setup({

            config = {
                -- set how iron deal with windows for the repl (see :h iron-extending)
                visibility = require("iron.visibility").single,
                -- scope of the repl: one repl per tab (see :h iron-extending)
                scope = require("iron.scope").tab_based,
                -- whether the repl buffer is a "throwaway" buffer or not
                scratch_repl = true,
                -- set where to open a new repl
                repl_open_cmd = require("iron.view").split.vertical.botright(60),
                -- automatically closes the repl window on process end
                close_window_on_exit = false,
                -- definitions of REPLs per filetype
                repl_definition = repls(),
                -- if the repl buffer is listed
                buflisted = false,
                -- use nvim api, not <plug>
                should_map_plug = false,
            },
            -- mappings are set explicitly above
            keymaps = {},
            -- Highlights the last sent block with bold
            highlight_last = false,
            -- If the highlight is on, you can change how it looks (see nvim_set_hl)
            highlight = {} -- e.g. { bold = true }
        })

    end
}

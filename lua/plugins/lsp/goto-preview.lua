return {

    "rmagatti/goto-preview",

    keys = {
        {
            '<leader><leader>D',
            function() require('goto-preview').goto_preview_definition() end,
            desc = "Goto-preview: definition"
        },
        {
            '<leader><leader>L',
            function() require('goto-preview').goto_preview_declaration() end,
            desc = "Goto-preview: declaration"
        },
        {
            '<leader><leader>I',
            function() require('goto-preview').goto_preview_implementation() end,
            desc = "Goto-preview: implementation"
        },
        {
            '<leader><leader>T',
            function() require('goto-preview').goto_preview_type_definition() end,
            desc = "Goto-preview: type definition"
        },
        {
            '<leader><leader>R',
            function() require('goto-preview').goto_preview_references() end,
            desc = "Goto-preview: references"
        },
        {
            '<leader><leader>Q',
            function() require('goto-preview').close_all_win() end,
            desc = "Goto-preview: close all windows"
        },
    },

    opts = {

        width = 90, -- Width of the floating window
        height = 20, -- Height of the floating window

        default_mappings = false, -- Bind default mappings
        resizing_mappings = true, -- Binds arrow keys to resizing the floating window.

        focus_on_open = true, -- Focus the floating window when opening it.
        dismiss_on_move = false, -- Dismiss the floating window when moving the cursor.

        stack_floating_preview_windows = true, -- Whether to nest floating windows

        -- the open/close hooks below implement the following features:
        --  - define some mappings in the preview window
        --  - set the buffer in the preview as not modifiable, then reset its
        --    previous modifiable state
        post_open_hook = function(buf, win)
            -- create states register table if it does not already exist
            if vim.g.gotoprev_ma_state == nil then vim.g.gotoprev_ma_state = {} end
            -- write current modifiable status for current buffer, then set nomodifiable
            vim.g.gotoprev_ma_state[buf] = vim.api.nvim_get_option_value('modifiable', { buf = buf })
            vim.api.nvim_set_option_value('modifiable', false, { buf = buf })
            -- mappings
            local gtp = require('goto-preview')
            vim.keymap.set('n', 'q', function() gtp.close_all_win() end, { buffer = buf })
            vim.keymap.set('n', '<esc>', function() gtp.close_all_win() end, { buffer = buf })
            vim.keymap.set('n', '<C-v>', function() gtp.close_all_win(); vim.cmd('vs') end, { buffer = buf })
            vim.keymap.set('n', '<C-h>', function() gtp.close_all_win(); vim.cmd('sp') end, { buffer = buf })
            -- define autocmd for autoclose on focus lost
            --[[
            This works for a single popup, but fails if a second floating
            window is opened from the first. The error occurs when the second
            float is closed and seems to be due to another autocommand trying
            to close the first one, which was already closed by this autocmd
            when the second float was opened.
            vim.api.nvim_create_autocmd({ 'WinLeave' }, {
                buffer = buf,
                callback = function()
                    vim.notify("closed" .. win)
                    vim.api.nvim_win_close(win, false)
                    return true
                end,
            }) ]]
        end,
        post_close_hook = function(buf, win)
            -- reset modifiable state
            local ma_state = vim.g.gotoprev_ma_state[buf]
            vim.api.nvim_set_option_value('modifiable', ma_state, { buf = buf })
            -- remove mappings
            vim.keymap.del('n', 'q', { buffer = buf })
            vim.keymap.del('n', '<esc>', { buffer = buf })
            vim.keymap.del('n', '<C-v>', { buffer = buf })
            vim.keymap.del('n', '<C-h>', { buffer = buf })
        end

    }
}

return {

    'kwkarlwang/bufjump.nvim',

    keys = {
        { "<leader>bo", function() require('bufjump').backward() end, desc = "Bufjump: previous buffer in window" },
        { "<leader>bi", function() require('bufjump').forward() end, desc = "Bufjump: next buffer in window" },
    },

    opts = {
        on_success = function()
            -- jump to last cursor position (rather than last jumplist position)
            -- doesn't seem to work as expected...
            local row, col = table.unpack(vim.api.nvim_buf_get_mark(0, "\""))
            if { row, col } ~= { 0, 0 } then
                vim.api.nvim_win_set_cursor(0, { row, 0 })
            end
        end
    }

}

return {

    'kwkarlwang/bufjump.nvim',

    keys = {
        { "<leader>bo", function() require('bufjump').backward() end, desc = "Bufjump: previous buffer in window" },
        { "<leader>bi", function() require('bufjump').forward() end, desc = "Bufjump: next buffer in window" },
    },

    opts = {
        on_success = function()
            -- jump to last cursor position (rather than last jumplist position)
            -- NOTE: doesn't appear to work as expected, and neither does the way suggested in the docs...

            ---@diagnostic disable-next-line: deprecated
            table.unpack = table.unpack or unpack -- 5.1 compatibility
            local row, col = table.unpack(vim.api.nvim_buf_get_mark(0, "\""))
            if { row, col } ~= { 0, 0 } then
                vim.api.nvim_win_set_cursor(0, { row, 0 })
            end
        end
    }

}

return {

    "stevearc/quicker.nvim",

    event = "FileType qf",

    keys = {
        {
            '<leader>qq',
            function() require('quicker').toggle({ focus = true, }) end,
            desc = "Quicker: toggle quickfix list",
        },
        {
            '<leader>qw',
            function() require('quicker').toggle({ loclist = true, focus = true }) end,
            desc = "Quicker: toggle quickfix list",
        },
    },

    opts = {

        keys = {
            { ">", function() require("quicker").expand() end },
            { "<", function() require("quicker").collapse() end },
            { "<c-r>", function() require("quicker").refresh() end }
        },

        max_filename_width = function()
            return math.floor(math.min(80, vim.o.columns / 3))
        end,
    },

    init = function()

        -- create autocmd to force the quickfix list to be as wide as the screen
        -- adapted from: https://github.com/fatih/vim-go/issues/1757#issuecomment-565130503
        vim.api.nvim_create_autocmd("FileType", {
            pattern = 'qf',
            callback = function()
                if vim.fn.getwininfo(vim.fn.win_getid()).loclist ~= 1 then
                    vim.cmd('wincmd J')
                end
            end
        })

    end

}

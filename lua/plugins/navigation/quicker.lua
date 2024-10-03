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
    }

}

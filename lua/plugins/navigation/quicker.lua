return {

    "stevearc/quicker.nvim",

    event = "FileType qf",

    opts = {

        keys = {
            { "zr", function() require("quicker").expand() end },
            { "zm", function() require("quicker").collapse() end },
            { "<c-r>", function() require("quicker").refresh() end }
        },

        max_filename_width = function()
            return math.floor(math.min(80, vim.o.columns / 3))
        end,
    }

}

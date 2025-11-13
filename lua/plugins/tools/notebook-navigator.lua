return {

    "GCBallesteros/NotebookNavigator.nvim",

    dependencies = {
        "hkupty/iron.nvim",
        "numToStr/comment.nvim",
    },

    event = "VeryLazy",

    keys = {

        { "]j", function() require("notebook-navigator").move_cell("d") end, desc = "Notebook: move to next cell" },
        { "[j", function() require("notebook-navigator").move_cell("u") end, desc = "Notebook: move to previous cell" },
        { "<leader>jn", function() require("notebook-navigator").move_cell("d") end, desc = "Notebook: move to next cell" },
        { "<leader>jp", function() require("notebook-navigator").move_cell("u") end, desc = "Notebook: move to previous cell" },
        { "<leader>jj", function() require('notebook-navigator').run_and_move() end, desc = "Notebook: run and move" },
        { "<leader>jr", function() require('notebook-navigator').run_cell() end, desc = "Notebook: run (don't move)" },
        { "<leader>ju", function() require('notebook-navigator').swap_cell("u") end, desc = "Notebook: swap cell with previous" },
        { "<leader>jd", function() require('notebook-navigator').swap_cell("d") end, desc = "Notebook: swap cell with next" },
        { "<leader>jm", function() require('notebook-navigator').merge_cell("d") end, desc = "Notebook: merge with next cell" },
        { "<leader>js", function() require('notebook-navigator').split_cell() end, desc = "Notebook: split cell" },
        { "<leader>jc", function() require('notebook-navigator').comment_cell() end, desc = "Notebook: comment cell" },
        { "<leader>ja", function() require('notebook-navigator').add_cell_below() end, desc = "Notebook: add cell after" },
        { "<leader>jb", function() require('notebook-navigator').add_cell_above() end, desc = "Notebook: add cell before" },

    },

    opts = {
        syntax_highlight = true,
    }

}

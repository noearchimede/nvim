return {

    "famiu/bufdelete.nvim",

    keys = {
        { "<leader>bd", function() require('bufdelete').bufdelete() end,
            desc = "Bufdelete: delete buffer without closing window" },
        { "<leader>bw", function() require('bufdelete').bufwipeout() end,
            desc = "Bufdelete: wipe buffer without closing window" }
    }

}

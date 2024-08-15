return {

    "folke/persistence.nvim",

    event = "BufReadPre", -- this will only start session saving when an actual file was opened

    keys = {
        { "<leader>wd", function() require("persistence").load() end, desc = "Persistence: load last session for current directory" },
        { "<leader>wl", function() require("persistence").load({ last = true }) end, desc = "Persistence: load session" },
        { "<leader>ws", function() require("persistence").select() end, desc = "Persistence: select a session" },
        -- stopping presistence will prevent it from saving the current session on exit
        { "<leader>wq", function() require("persistence").stop() end, desc = "Persistence: stop" },
    },

    opts = {
        dir = vim.fn.stdpath("state") .. "/sessions/",
        need = 1, -- minimum number of file buffers that need to be open to save
    },


}

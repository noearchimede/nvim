-- NOTE: there are Grapple integrations in 'lualine.lua' and 'tabby.lua'

return {

    "cbochs/grapple.nvim",

    dependencies = { "nvim-tree/nvim-web-devicons" },

    cmd = "Grapple",

    keys = {

        { "<leader>ba", "<cmd>Grapple tag<cr>", desc = "Grapple: tag buffer" },
        { "<leader>br", "<cmd>Grapple untag<cr>", desc = "Grapple: untag buffer" },

        { "<leader>bg", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple: toggle tags menu" },

        -- quick buffer jump
        { "<leader>1", "<cmd>Grapple select index=1<cr>", desc = "Grapple: select first tag" },
        { "<leader>2", "<cmd>Grapple select index=2<cr>", desc = "Grapple: select second tag" },
        { "<leader>3", "<cmd>Grapple select index=3<cr>", desc = "Grapple: select third tag" },
        { "<leader>4", "<cmd>Grapple select index=4<cr>", desc = "Grapple: select fourth tag" },
        { "<leader>5", "<cmd>Grapple select index=5<cr>", desc = "Grapple: select fifth tag" },
        { "<leader>6", "<cmd>Grapple select index=6<cr>", desc = "Grapple: select sixth tag" },
        { "<leader>7", "<cmd>Grapple select index=7<cr>", desc = "Grapple: select seventh tag" },
        { "<leader>8", "<cmd>Grapple select index=8<cr>", desc = "Grapple: select eighth tag" },
        { "<leader>9", "<cmd>Grapple select index=9<cr>", desc = "Grapple: select ninth" },

        -- next/previous buffer (two options for each)
        { "<leader>0", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple: go to next tag" },
        { "<leader>bn", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple: go to next tag" },
        { "<leader>bp", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple: go to previous tag" },

        {
            "<leader>be",
            function()
                vim.ui.input({ prompt = "Grapple: erase all tags? [y/N]" }, function(input)
                    if input == 'y' then
                        require("grapple").reset()
                        vim.notify("Grapple: erased all tags")
                    else
                        vim.notify("Grapple: operation interrupted")
                    end
                end)
            end,
            desc = "Grapple: untag buffer"
        },

    },

    opts = {
        ---Default scope to use when managing Grapple tags
        ---For more information, please see the Scopes section
        scope = "git",
        ---Position a tag's name should be shown in Grapple windows
        name_pos = "end",
        ---How a tag's path should be rendered in Grapple windows
        ---  "relative": show tag path relative to the scope's resolved path
        ---  "basename": show tag path basename and directory hint
        style = "basename",
        ---A string of characters used for quick selecting in Grapple windows
        ---An empty string or false will disable quick select
        quick_select = "123456789",
        ---Default command to use when selecting a tag
        command = vim.cmd.edit,
    }

}

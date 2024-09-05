--[[ for config.txt
Harpoon ~
*mymap_leader_ba*  n  \ba   add current buffer to Harpoon
*mymap_leader_bl*  n  \bl   List harpoon buffers
*mymap_leader_bn*  n  \bn   go to Next harpoon buffer
*mymap_leader_bp*  n  \bp   go to Previous harpoon buffer
]]

return {

    "ThePrimeagen/harpoon",

    branch = "harpoon2",

    dependencies = { "nvim-lua/plenary.nvim" },

    keys = function()
        local harpoon = require('harpoon')
        return {
            { "<leader>ba", function() harpoon:list():add() end },
            { "<leader>bl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end },

            { "<leader>b1", function() harpoon:list():select(1) end },
            { "<leader>b2", function() harpoon:list():select(2) end },
            { "<leader>b3", function() harpoon:list():select(3) end },
            { "<leader>b4", function() harpoon:list():select(4) end },

            -- Toggle previous & next buffers stored within Harpoon list
            { "<leader>bp", function() harpoon:list():prev() end },
            { "<leader>bn", function() harpoon:list():next() end },
        }
    end
    ,

    config = function()
        local harpoon = require('harpoon')
        harpoon:setup()
        harpoon:extend({
            -- define mappings to open in a split or new tab
            -- (copied from the readme)
            UI_CREATE = function(cx)
                vim.keymap.set("n", "<C-v>", function()
                    harpoon.ui:select_menu_item({ vsplit = true })
                end, { buffer = cx.bufnr })

                vim.keymap.set("n", "<C-x>", function()
                    harpoon.ui:select_menu_item({ split = true })
                end, { buffer = cx.bufnr })

                vim.keymap.set("n", "<C-t>", function()
                    harpoon.ui:select_menu_item({ tabedit = true })
                end, { buffer = cx.bufnr })
            end,
        })
    end


}

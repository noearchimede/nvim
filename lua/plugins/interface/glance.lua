return {

    'dnlhc/glance.nvim',

    cmd = 'Glance',

    keys = {
        { "<leader><leader>r", "<cmd>Glance references<cr>", desc = "Glance: references" },
        { "<leader><leader>g", "<cmd>Glance resume<cr>", desc = "Glance: resume" },
    },

    opts = function()
        local actions = require('glance').actions
        return {
            border = {
                enable = true
            },
            mappings = {
                list = {
                    -- by default tab and shift-tab cycle locations, and j/k only navigate visible lines.
                    -- I use J/K for the "natural" jk behaviour and j/k to cycle locations
                    ['j'] = actions.next_location,
                    ['k'] = actions.previous_location,
                    ['n'] = actions.next_location, -- for consistency with preview window
                    ['p'] = actions.previous_location, -- for consistency with preview window
                    ['J'] = actions.next,
                    ['K'] = actions.previous,
                    ['<S-Tab>'] = false,
                    ['<Tab>'] = actions.enter_win('preview'),
                    ['<leader>l'] = false, -- by default leader-l enters preview
                },
                preview = {
                    ['n'] = actions.next_location,
                    ['p'] = actions.previous_location,
                    ['<S-Tab>'] = false, -- by default tab and shift-tab cycle locations
                    ['<Tab>'] = actions.enter_win('list'),
                    ['<leader>l'] = false, -- by default leader-l enters preview
                    ['q'] = actions.close,
                },
            }
        }
    end

}

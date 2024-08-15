return {

    "pocco81/true-zen.nvim",

    keys = {
        { '<leader>xx', ':TZAtaraxis<CR>', desc = 'TrueZen: toggle' }
    },

    opts = {
        modes = { -- configurations per mode
            ataraxis = {
                shade = "dark", -- if `dark` dim the padding windows, if `light` brighten it
                backdrop = 0, -- number between 0 and 1, set to 0 to keep the same background color
                minimum_writing_area = { -- minimum size of main window
                    width = 80,
                    height = 40,
                },
                quit_untoggles = true, -- type :q or :qa to quit Ataraxis mode
                padding = { -- padding windows
                    left = 52,
                    right = 52,
                    top = 4,
                    bottom = 4,
                },
                callbacks = { -- run functions when opening/closing Ataraxis mode
                    open_pre = nil,
                    open_pos = nil,
                    close_pre = nil,
                    close_pos = nil
                },
            },
            integrations = {
                lualine = true -- hide nvim-lualine (ataraxis)
            },
        }
    }

}

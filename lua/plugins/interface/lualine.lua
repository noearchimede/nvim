return {

    event = 'VeryLazy',
    'nvim-lualine/lualine.nvim',

    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },

    init = function()
        -- always display tabline, even with only one tab open
        vim.opt.showtabline = 2
    end,

    opts = {
        options = {
            icons_enabled = false,
            theme = 'auto',
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            disabled_filetypes = {
                statusline = { 'NvimTree' },
                winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = false,
            globalstatus = false,
            refresh = {
                statusline = 1000,
                tabline = 1000,
                winbar = 1000,
            }
        },

        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = { {
                'filename',
                path = 1,
                shorting_target = 40,
                symbols = { modified = '●' },
            } },
            lualine_x = { 'encoding', 'filetype' },
            lualine_y = { 'progress' },
            lualine_z = { 'searchcount', 'location' }
        },

        inactive_sections = {
            lualine_a = {},
            lualine_b = { {
                'filename',
                path = 1,
                shorting_target = 40,
                symbols = { modified = '●' },
            } },
            lualine_c = {},
            lualine_x = {},
            lualine_y = { 'progress' },
            lualine_z = {}
        },

        tabline = {},

        winbar = {},
        inactive_winbar = {},

        extensions = {}

    }

}

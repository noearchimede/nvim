return {

    'nvim-lualine/lualine.nvim',

    lazy = false,

    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },

    init = function()
        -- always display tabline, even with only one tab open
        vim.opt.showtabline = 2
    end,

    opts = function()

        -- define function to print show word count for word count custom compoment
        local function getWords()
            return '[' .. tostring(vim.fn.wordcount().words) ..' w]'
        end
        -- define function to decide whether to show word count
        local function showWords()
            local ft = vim.bo.filetype
            return ft == 'text' or ft == 'markdown' or ft == ''
        end

        return {
        options = {
            icons_enabled = false,
            theme = 'auto',
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            disabled_filetypes = {
                statusline = {
                    'NvimTree',
                    'alpha'
                },
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
                separator = '' -- disable separator between filename and grapple handle
            },
            { -- Grapple integration (1/2)
                padding = { left = 0 },
                function()
                    local grapple = require("grapple").name_or_index()
                    if grapple then return '' .. grapple .. '' else return '' end
                end,
                cond = function()
                    return package.loaded["grapple"] and require("grapple").exists()
                end
            } },
            lualine_x = { { getWords, cond = showWords }, 'encoding', 'filetype' },
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
                separator = '' -- disable separator between filename and grapple handle
            },
            { -- Grapple integration (2/2)
                function()
                    local grapple = require("grapple").name_or_index()
                    if grapple then return '' .. grapple .. '' else return '' end
                end,
                cond = function()
                    return package.loaded["grapple"] and require("grapple").exists()
                end
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
    end

}

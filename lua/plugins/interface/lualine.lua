return {

    'nvim-lualine/lualine.nvim',

    lazy = false,

    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },

    init = function()

        -- custom wordcount component: function to count words
        local function countWords()
            local ft = vim.bo.filetype
            local words = nil
            if ft == 'tex' then
                local ok
                ok, words = pcall(vim.fn['vimtex#misc#wordcount'])
                if not ok then
                    words = '???'
                end
            elseif ft == 'text' or ft == '' or ft == 'markdown' then
                words = tostring(vim.fn.wordcount().words)
            end
            return words
        end
        -- custom wordcount component: function to create display string
        local function refreshWordCountString()
            local words = countWords()
            local string = ''
            if words ~= nil then
                local ok, changed = pcall(function() return vim.fn.getbufinfo('%')[1].changed end)
                if not ok then return 'ERR' end
                string = '[' .. (changed == 1 and '~' or '') .. words .. ' w' .. ']'
            end
            vim.api.nvim_buf_set_var(0, 'lualine_word_count_string', string)
        end
        -- run word counting on save, on buffer enter, and on file modified status change
        -- the latter causes the addition of a marker to denote the fact that the count is not up to date
        vim.api.nvim_create_autocmd("BufWritePost", {
            callback = refreshWordCountString
        })
        vim.api.nvim_create_autocmd("BufEnter", {
            callback = refreshWordCountString
        })
        vim.api.nvim_create_autocmd("BufModifiedSet", {
            callback = refreshWordCountString
        })

    end,

    opts = {

        options = {
            icons_enabled = false,
            disabled_filetypes = {
                statusline = {
                    'NvimTree',
                    'alpha'
                },
                winbar = {},
            },
            always_divide_middle = false,
        },

        sections = {
            lualine_a = {
                {
                    function()
                        local reg = vim.fn.reg_recording()
                        if reg == "" then
                            return ""
                        else
                            return reg
                        end
                    end,
                    color = 'lualine_a_replace'
                },
                {
                    'mode',
                }
            },
            lualine_b = {
                'branch',
                'diff',
                'diagnostics',
            },
            lualine_c = {
                {
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
                }
            },
            lualine_x = {
                function() return vim.api.nvim_buf_get_var(0, 'lualine_word_count_string') end,
                'encoding',
                'filetype',
            },
            lualine_y = {
                'progress',
            },
            lualine_z = {
                'searchcount',
                'location',
            }
        },

        inactive_sections = {
            lualine_a = {},
            lualine_b = {
                {
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
                }
            },
            lualine_c = {},
            lualine_x = {},
            lualine_y = {
                'progress',
            },
            lualine_z = {}
        },

    }

}

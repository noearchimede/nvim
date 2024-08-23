return {

    'nanozuki/tabby.nvim',

    event = 'VeryLazy',

    keys = {
        { "<leader>tn", function() vim.cmd("Tabby rename_tab " .. vim.fn.input("Rename tab: ")) end, desc = "Tabby: rename tab" },
        { "<leader>tmp", "<cmd>-tabmove<cr>", desc = "Tabby: move tab right" },
        { "<leader>tmn", "<cmd>+tabmove<cr>", desc = "Tabby: move tab left" },
    },

    dependencies = 'nvim-tree/nvim-web-devicons',

    opts = {
        line = function(line)
            -- colors
            local theme = {
                -- use lualine highlightings for consistency
                fill = 'lualine_c_normal',
                head = 'lualine_a_visual',
                current_tab = 'lualine_a_insert',
                tab = 'lualine_b_normal',
                current_window = 'lualine_a_command',
                window = 'lualine_b_normal',
                tail_color = 'lualine_a_visual',
                tail_grey = 'lualine_b_normal',
            }

            ---shortens path by turning apple/orange -> a/orange
            ---[copied from lualine: https://github.com/nvim-lualine/lualine.nvim/blob/544dd1583f9bb27b393f598475c89809c4d5e86b/lua/lualine/components/filename.lua#L32]
            local function shorten_path(path, sep, max_len)
                local len = #path
                if len <= max_len then
                    return path
                end
                local segments = vim.split(path, sep)
                for idx = 1, #segments - 1 do
                    if len <= max_len then
                        break
                    end
                    local segment = segments[idx]
                    local shortened = segment:sub(1, vim.startswith(segment, '.') and 2 or 1)
                    segments[idx] = shortened
                    len = len - (#segment - #shortened)
                end
                return table.concat(segments, sep)
            end

            -- windows filter
            local function win_filter(win)
                if string.match(win.buf_name(), 'NvimTree') then
                    return false
                end
                return true
            end

            -- custom window renamer function
            local function win_rename(win_name)
                if string.match(win_name, '%[Scratch.+%]') then return '' end
                if string.match(win_name, '%[No Name%]') then return '' end
                if string.match(win_name, 'NvimTree_%d') then return '' end
                if string.match(win_name, 'NeogitStatus') then return 'NEOGIT' end
                if string.match(win_name, 'COMMIT_EDITMSG') then return 'COMMIT' end
                if string.match(win_name, 'DiffviewFilePanel') then return 'DIFF' end
                return win_name
            end

            -- custom tab renamer function
            -- local function tab_rename(tab_name)
            --     -- default name is "<focused buffer>[X+]", where X is the number of windows in the tab and the [] is only present if X > 1
            --     local tab_name_no_win_count = string.gsub(tab_name,"%[(..)%]","")
            --     return win_rename(tab_name_no_win_count)
            -- end

            -- tabs renderer: only display tabs if there are more than one
            local function display_tabs()
                if #line.api.get_tabs() == 1 then
                    return {}
                else
                    return line.tabs().foreach(function(tab)
                        local hl = tab.is_current() and theme.current_tab or theme.tab
                        return {
                            line.sep('', hl, theme.fill),
                            tab.number(),
                            -- tab_rename(tab.name()),
                            -- tab.close_btn(''),
                            line.sep('', hl, theme.fill),
                            hl = hl,
                            margin = ' ',
                        }
                    end)
                end
            end

            -- tabline layout
            return {
                hl = theme.fill,
                -- leftmost element: total number of open buffers
                {
                    { ' ' .. #vim.split(vim.fn.execute("ls"), "\n") - 1 .. ' ', hl = theme.head },
                    line.sep('', theme.head, theme.fill),
                },
                -- tabs
                display_tabs(),
                -- flexible spacer
                line.spacer(),
                -- windows in tab
                line.wins_in_tab(line.api.get_current_tab(), win_filter).foreach(function(win)
                    local hl = win.is_current() and theme.current_window or theme.window
                    return {
                        line.sep('', hl, theme.fill),
                        win_rename(win.buf_name()),
                        line.sep('', hl, theme.fill),
                        hl = hl,
                        margin = ' ',
                    }
                end),
                -- cwd
                {
                    (function()
                        local tcwd = vim.fn.getcwd(-1)
                        local lcwd = vim.fn.getcwd()
                        local print_cwd = shorten_path(vim.fn.fnamemodify(lcwd, ':~'), '/', 30)
                        if tcwd == lcwd then
                        return {
                            line.sep('█', theme.tail_color, theme.tail_grey),
                            { ' ' .. print_cwd .. ' ', hl = theme.tail_grey },
                            line.sep('█', theme.tail_color, theme.tail_grey),
                        }
                        else
                        return {
                            line.sep('██', theme.tail_color, theme.tail_grey),
                            { print_cwd, hl = theme.tail_color },
                            line.sep('██', theme.tail_color, theme.tail_grey),
                        }
                        end
                    end)(),
                }
            }
        end,
        -- option = {}, -- setup modules' option,
    }
}

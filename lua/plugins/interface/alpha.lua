return {
    "goolord/alpha-nvim",

    dependencies = {
        "RchrdAriza/nvim-web-devicons",
        'nvim-lualine/lualine.nvim',
    },

    config = function()

        local colors = {
            header = "ErrorMsg",
            icon = "Constant",
            action = "Normal",
            shortcut = "Special",
            footer_1 = "Number",
            footer_2 = "Delimiter",
        }
        local buttons_width = 35

        local function text(hl, text_table)
            return {
                type = "text",
                val = text_table,
                opts = {
                    position = "center",
                    hl = hl
                }
            }
        end

        local function button(key, icon, desc, command)
            local action = function() vim.cmd(command) end
            return {
                type = "button",
                val = icon .. "   " .. desc,
                on_press = action,
                opts = {
                    position = "center",
                    hl = {
                        { colors.icon, 0, 3 },
                        { colors.action, 4, -1 },
                    },
                    keymap = { "n", key, action, { silent = true } },
                    align_shortcut = "right",
                    shortcut = key,
                    hl_shortcut = colors.shortcut,
                    cursor = 2, -- place cursor on this column
                    width = buttons_width,
                    shrink_margin = true
                }
            }
        end

        local function padding(lines)
            return {
                type = "padding",
                val = lines
            }
        end

        local function group(spacing, items)
            return {
                type = "group",
                val = items,
                opts = {
                    spacing = spacing
                }
            }
        end

        -- alpha layout
        local layout = {
            padding(3),
            text(colors.header, {
                '',
                [[      __                _            ]],
                [[   /\ \ \___  ___/\   /(_)_ __ ___   ]],
                [[  /  \/ / _ \/ _ \ \ / | | '_ ` _ \  ]],
                [[ / /\  |  __| (_) \ V /| | | | | | | ]],
                [[ \_\ \/ \___|\___/ \_/ |_|_| |_| |_| ]],
                ''
            }),
            padding(1),
            text(colors.footer_1, {
                os.date("%A, %d %B %Y"),
                --os.date("%H:%M"),
            }),
            padding(3),
            group(1, {
                button("n", "", "New file", "enew"),
                button("w", "", "Workspaces", "Telescope workspaces"),
                button("s", "󰦖", "Sessions", "Telescope possession"),
                button("l", "", "Restore latest session", "PSLoad"),
                button("f", "󰮗", "Find file", "Telescope find_files"),
                button("r", "", "Recent files", "Telescope oldfiles"),
                button("t", "", "File tree", "NvimTreeOpen"),
                button("o", "󰍜", "Oil", "Oil"),
                button("c", "", "Configuration", "cd ~/.config/nvim | edit README.md"),
                button("h", "?", "Help", "vert help config.txt"),
                button("q", "󰗼", "Quit", "quit"),
            }),
            padding(4),
            text(colors.footer_2,
                "NVIM v" .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch)
        }

        -- alpha options
        local opts = {
            margin = 5,
            redraw_on_resize = true -- set to 'false' to remove an error raised on line 535 of alpha-nvim/lua/alpha.lua (not needed anymore?)
        }

        -- Send config to alpha
        require("alpha").setup({
            layout = layout,
            opts = opts,
        })

    end,

    init = function()

        -- create autocmd to set local settings
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "alpha",
            callback = function()
                vim.opt_local.foldenable = false
                vim.opt_local.wrap = false
            end
        })

    end
}

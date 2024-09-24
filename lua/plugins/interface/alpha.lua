return {
    "goolord/alpha-nvim",

    dependencies = {
        "RchrdAriza/nvim-web-devicons",
        'nvim-lualine/lualine.nvim',
    },

    config = function()

        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        -- Set header
        dashboard.section.header.val = {
            [[                               __                ]],
            [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
            [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
            [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
            [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
            [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
            '',
            '',
            '',
        }

        dashboard.section.buttons.val = {
            dashboard.button("n", "   New file", "<cmd>enew<CR>"),
            dashboard.button("w", "   Workspaces", "<cmd>Telescope workspaces<CR>"),
            dashboard.button("s", "   Sessions", "<cmd>Telescope possession<CR>"),
            dashboard.button("f", "󰮗   Find file", "<cmd>Telescope find_files<CR>"),
            dashboard.button("r", "   Recent files", "<cmd>Telescope oldfiles<CR>"),
            dashboard.button("o", "   Oil", "<cmd>Oil<CR>"),
            dashboard.button("c", "   Configuration", "<cmd>cd ~/.config/nvim <bar> edit README.md<CR>"),
            dashboard.button("q", "󰗼   Quit", "<cmd>quit<CR>"),
        }

        -- helper function to center-align multiple lines of text in the 'footer' section
        local function center_align(text_table)
            local max_length = 0
            for _, text in ipairs(text_table) do max_length = math.max(max_length, #text) end
            local ret = {}
            for _, text in ipairs(text_table) do
                local padding = math.floor((max_length - #text) / 2)
                table.insert(ret, string.rep(" ", padding) .. text)
            end
            return ret
        end

        local vers = vim.version()
        dashboard.section.footer.val = center_align({
            '',
            '',
            '',
            os.date("%A %d %B %Y"),
            os.date("%H:%M"),
            '',
            '',
            "NVIM v" .. vers.major .. "." .. vers.minor .. "." .. vers.patch,
        })

        -- create autocmd to hide statusline and tabline
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "alpha",
            callback = function()
                vim.opt_local.foldenable = false
            end
        })

        -- Send config to alpha
        alpha.setup(dashboard.opts)

    end,
}

return {

    "linux-cultist/venv-selector.nvim",

    ft = "python",

    cmd = { "VenvSelect" },

    -- note: lualine integration defined in lualine.lua config file

    init = function()
        if vim.fn.has("win32") == 1 then
            -- this is necessary to make conda accessible from within nvim if it is not run from the anaconda prompt
            local conda = vim.fn.expand("$LOCALAPPDATA") .. [[\miniconda3]]
            vim.env.PATH = table.concat({
                conda .. [[\condabin]],
                conda .. [[\Scripts]],
                conda .. [[\Library\bin]],
                vim.env.PATH,
            }, ";")
        end
    end,

    opts = {
        options = {
            cached_venv_automatic_activation = false,
            activate_venv_in_terminal = true,
            notify_user_on_venv_activation = true,
            log_level = "TRACE",
            -- If true, wait for LSP workspace detection before applying environment (helps avoid premature activation).
            require_lsp_activation = false,
            on_venv_activate_callback = function()
                vim.defer_fn(function()
                    if #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
                        vim.cmd("lsp restart")
                    end
                end, 100)
            end,
        },

        search = (function()
            if vim.fn.has("win32") then
                return {
                    miniconda_envs = {
                        command =
                        "$FD python.exe$ $HOME\\AppData\\Local\\miniconda3\\envs --no-ignore-vcs --full-path -a -E Lib",
                        type = "anaconda",
                    },
                    miniconda_base = {
                        command =
                        "$FD miniconda3\\\\python.exe$ $HOME\\AppData\\Local\\miniconda3 --no-ignore-vcs --full-path -a --color never",
                        type = "anaconda",
                    },
                }
            else
                return {}
            end
        end)()
    },

}

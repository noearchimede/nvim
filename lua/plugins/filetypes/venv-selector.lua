return {

    "linux-cultist/venv-selector.nvim",

    ft = "python",

    cmd = { "VenvSelect" },

    -- note: lualine integration defined in lualine.lua config file

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
        }
    }

}

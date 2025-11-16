return {

    "linux-cultist/venv-selector.nvim",

    ft = "python",

    cmd = { "VenvSelect" },

    -- note: lualine integration defined in lualine.lua config file

    opts = {
        picker = "native",
        notify_user_on_venv_activation = true,
        require_lsp_activation = false, -- enable venv selection even if no python file is open (and thus no lsp instance)
    },

}

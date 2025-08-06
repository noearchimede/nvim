return {

    "linux-cultist/venv-selector.nvim",

    -- use this branch for the newest version
    branch = "regexp",

    dependencies = {
        "nvim-telescope/telescope.nvim"
    },

    ft = 'py',

    cmd = { "VenvSelect" },

    opts = {
        options = {
            -- show shorter names in the telescope picker
            on_telescope_result_callback = function(filename)
                return filename:gsub(os.getenv("HOME"), "~"):gsub("/bin/python", "")
            end
        },
        -- notifies user on activation of the virtual env
        notify_user_on_venv_activation = true,
    },

}

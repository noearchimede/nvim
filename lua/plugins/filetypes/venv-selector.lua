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
        -- notifies user on activation of the virtual env
        notify_user_on_venv_activation = true,

        search = {
            -- disable the default cwd search. Re-enable it if existing envs are not found.
            cwd = false
        }
    },

}

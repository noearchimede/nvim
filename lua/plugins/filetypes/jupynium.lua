return {

    "kiyoon/jupynium.nvim",

    dependencies = {
        "stevearc/dressing.nvim", -- optional, UI for :JupyniumKernelSelect
    },

    ft = "python",

    opts = {
        -- downloading the ipynb file is still possible with :JupyniumDownloadIpynb
        auto_download_ipynb = false,

        -- all jupyter-related mappings are unified in the config for notebook-navigator
        use_default_keybindings = false,
        textobjects = {
            use_default_keybindings = false
        },
        -- use Notebook-navigator for cell highlighting
        syntax_highlight = {
            enable = false
        },
    },

}

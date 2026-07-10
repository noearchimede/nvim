return {

    "dangooddd/pyrepl.nvim",

    dependencies = { "nvim-treesitter/nvim-treesitter" },

    -- note: keymaps are defined in notebook-navigator.lua, inside the nn Hydra cluster of mappings

    config = function()
        local pyrepl = require("pyrepl")

        -- default config
        pyrepl.setup({
            split_horizontal = false,
            split_ratio = 0.5,
            style_treesitter = true,
            image_max_history = 50,
            image_width_ratio = 1,
            image_height_ratio = 1,
            -- built-in provider, works best for ghostty and kitty
            -- for other terminals use "image" instead of "placeholders"
            image_provider = "placeholders",
            cell_pattern = "^# %%%%.*$",
            -- Do not convert ipynb files on opening because that is handled by the goerz/jupytext plugin.
            -- I prefer that plugin over the jupytext integration here because it automatically writes
            -- changes back to the ipynb file (and manages the synchronization automatically without
            -- creating a py file in the same folder)
            jupytext_hook = false,
        })

    end,

}

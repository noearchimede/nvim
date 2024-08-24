return {

    "klen/nvim-config-local",

    event = "VeryLazy",

    opts = {
      config_files = { ".nvim.lua", ".nvimrc", ".exrc" }, -- these three filenames are supported natively by ':h exrc'
      lookup_parents = true, -- Lookup config files in parent directories
    }

}

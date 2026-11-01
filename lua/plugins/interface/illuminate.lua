return {

    "RRethy/vim-illuminate",

    keys = {
        { "<leader>zh", function()
            if not vim.g.config_illuminate_activated or vim.g.config_illuminate_activated == 'off' then
                vim.g.config_illuminate_activated = 'lsp'
                require("illuminate").resume()
                require("illuminate").configure({ providers = { 'lsp' }} )
                vim.notify("Illuminate: on (lsp provider only)")
            elseif vim.g.config_illuminate_activated == 'lsp' then
                vim.g.config_illuminate_activated = 'all'
                require("illuminate").configure({ providers = { 'lsp', 'treesitter', 'regex' }} )
                vim.notify("Illuminate: on (all providers)")
            elseif vim.g.config_illuminate_activated == 'all' then
                vim.g.config_illuminate_activated = 'off'
                require("illuminate").pause()
                vim.notify("Illuminate: off")
            end
        end, desc = "Toggle same word highlighting" },
        { "]i", function() require("illuminate").goto_next_reference() end, desc = "Illuminate: go to next word" },
        { "[i", function() require("illuminate").goto_prev_reference() end, desc = "Illuminate: go to previous word" },

    },

    cmd = { "IlluminateResume" },

    config = function()

        -- note: since the config function is not named 'setup', lazy's opts field can't be used
        require("illuminate").configure({
            disable_keymaps = true
        })

    end

}

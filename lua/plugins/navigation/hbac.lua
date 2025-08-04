return {

    'axkirillov/hbac.nvim',

    event = 'VeryLazy',

    keys = {
        {
            "<leader>bu",
            function()
                vim.ui.input({ prompt = "HBAC: close all untouched buffers? [y/N]" }, function(input)
                    if input == 'y' then
                        require("hbac").close_unpinned()
                        vim.notify("HBAC: closed untouched buffers")
                    end
                end)
            end,
            desc = "HBAC: close untouched buffers"
        },
    },

    opts = {
        autoclose = false, -- only close with keybinding
        close_buffers_with_windows = false, -- do not close buffers with winodws
    },

}

return {

    'axkirillov/hbac.nvim',

    lazy = false,

    keys = {
        {
            "<leader>bu",
            function()
                vim.ui.input({ prompt = "HBAC: close all unpinned buffers? [y/N]" }, function(input)
                    if input == 'y' then
                        require("hbac").close_unpinned()
                        vim.notify("HBAC: closed unpinned buffers")
                    else
                        vim.notify("HBAC: operation interrupted")
                    end
                end)
            end,
            desc = "HBAC: close all unpinned buffers"
        }
    },

    opts = {
        autoclose = false, -- only close with keybinding
        -- threshold = 10, -- for autoclose
        close_command = function(bufnr)
            -- skip terminal buffers. By default Hbac attempts to close them as they are not pinned automatically.
            if vim.bo[bufnr].buftype == 'terminal' then
                return
            end
            vim.api.nvim_buf_delete(bufnr, {})
        end,
        close_buffers_with_windows = false, -- do not close buffers with winodws
        telescope = {} -- do not use telescope integration
    },

}

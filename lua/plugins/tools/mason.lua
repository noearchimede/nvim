return {

    'mason-org/mason.nvim',

    dependencies = {
        -- use mason-tool-installer to install a predefined set of lsp servers and other tools
        'WhoIsSethDaniel/mason-tool-installer.nvim'
    },

    lazy = false, -- lazy loading is not recommended for mason

    config = function()

        -- first, setup mason
        require("mason").setup()

        -- get custom lists of servers and tools and merge them
        local semantic_tools = require('semantic_tools')
        local tools_list = {}
        if semantic_tools.lsp_servers_auto_install then
            for _, server_name in ipairs(semantic_tools.lsp_servers) do
                table.insert(tools_list, server_name)
            end
        end
        if semantic_tools.formatters_auto_install then
            for _, formatter_list in pairs(semantic_tools.formatters_by_ft) do
                for _, formatter_name in ipairs(formatter_list) do
                    -- additional key-value options that might be present in the
                    -- table for conform are automatically ingnored by ipairs
                table.insert(tools_list, formatter_name)
                end
            end
        end

        vim.print(tools_list)
        -- then, setup the tool installer to enforce installing selected tools and lsp servers
        require("mason-tool-installer").setup {
            ensure_installed = tools_list
        }

        vim.api.nvim_create_autocmd('User', {
            pattern = 'MasonToolsStartingInstall',
            callback = function() vim.cmd("Mason") end
        })
    end
}

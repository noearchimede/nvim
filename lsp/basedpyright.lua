-- from https://github.com/neovim/nvim-lspconfig/blob/master/lsp/basedpyright.lua
local function set_python_path(command)
    local path = command.args
    local clients = vim.lsp.get_clients {
        bufnr = vim.api.nvim_get_current_buf(),
        name = 'basedpyright',
    }
    for _, client in ipairs(clients) do
        if client.settings then
            ---@diagnostic disable-next-line: param-type-mismatch
            client.settings.python = vim.tbl_deep_extend('force', client.settings.python or {}, { pythonPath = path })
        else
            client.config.settings = vim.tbl_deep_extend('force', client.config.settings,
                { python = { pythonPath = path } })
        end
        client:notify('workspace/didChangeConfiguration', { settings = nil })
    end
end

---@type vim.lsp.Config
return {
    cmd = { 'basedpyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = {
        'pyrightconfig.json',
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        'Pipfile',
        '.git',
    },
    settings = {
        basedpyright = {
            analysis = {
                autoSearchPaths = true,
                -- diagnosticMode = 'workspace' does not appear to work. Adding init_options = { disablePullDiagnostics = true }
                -- below (same level as settings = {...}) appears to work at first, but diagnostics do not update after opening files.
                diagnosticMode = "openFilesOnly", -- 'openFilesOnly' (default) or 'workspace'  
                typeCheckingMode = "standard", -- match pyright defaults
                -- https://docs.basedpyright.com/latest/configuration/language-server-settings/
                -- Explicitly setting `basedpyright.analysis.useLibraryCodeForTypes` is **discouraged** by the official docs.
                -- Because it will override per-project configurations like `pyproject.toml`.
                -- If left unset, its default value is `true`, and it can be correctly overridden by project config files.
            },
        },
    },
    -- workaround to get workspace diagnostics to work, see https://github.com/neovim/neovim/issues/37150#issuecomment-4248816355
    init_options = {
        disablePullDiagnostics = true
    },
    on_attach = function(client, bufnr)
        vim.api.nvim_buf_create_user_command(bufnr, 'LspPyrightSetPythonPath', set_python_path, {
            desc = 'Reconfigure basedpyright with the provided python path',
            nargs = 1,
            complete = 'file',
        })
    end,
}

-- modified from https://github.com/neovim/nvim-lspconfig/blob/master/lsp/jedi_language_server.lua

-- I only use jedi for completions, and (based)pyright for the rest
return {
  cmd = { 'jedi-language-server' },
  filetypes = { 'python' },
  root_markers = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    '.git',
  },
  on_attach = function(client, bufnr)
    -- disable all non-completion features
    client.server_capabilities.hoverProvider = false
    client.server_capabilities.definitionProvider = false
    client.server_capabilities.referencesProvider = false
    client.server_capabilities.signatureHelpProvider = false
    client.server_capabilities.documentSymbolProvider = false
    client.server_capabilities.workspaceSymbolProvider = false
    client.server_capabilities.codeActionProvider = false
    client.server_capabilities.renameProvider = false
    client.server_capabilities.diagnosticProvider = false
  end,
}

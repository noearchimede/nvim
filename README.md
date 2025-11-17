# NeoVim

Configuration files for Neovim.

Written and mantained on macOS, used mainly in iTerm and Neovide.

A list of all custom mappings is available in the `:h config.txt` help page.


## Files

```
├── init.lua                      entry point for the Neovim configuration
│
├── lua                           main configuration folder
│   ├── settings.lua              vim settings
│   ├── mappings.lua              custom mappings
│   ├── commands.lua              custom commands
│   ├── utils.lua                 utilitiy functions written in lua
│   │
│   ├── semantic_tools.lua        list of external LSPs, linters, treesitter grammars, etc
│   │
│   ├── gui.lua                   settings for GUI neovim apps
│   │
│   └── plugins
│       ├── init.lua              spec for lazy.nvim that includes all subdirectories of 'plugins'
│       └── ...                   plugin specs, one per file, grouped in subdirectories
│
│
├── after                         configuration files loaded after everthing else
│   └── ftplugin                  "after ftplugins", one file per filetype
│
├── autoload                      vimscript functions
│
├── doc                           documentation and personal notes about this configuration and neovim
│
├── plugin                        custom plugins
│
└── snippets                      LuaSnip snippets
    ├── luasnip                   snippets written in lua, one file per filetype
    └── vscode                    snippets written in the vscode snippet format, one file per ft
```


## Dependencies


- **tree-sitter-cli** (for treesitter)
    - `brew install tree-sitter-cli` (NOT `tree-sitter`!)
    - NOTE: treesitter will not complain if it is missing (except in `:healthcheck`), but will not be able to install languages.

- **ripgrep** (for telescope)
    - `brew install ripgrep`

- **fd** (for telescope)
    - `brew install fd`


---

| *Noè Archimede Pezzoli* |
| ------------------------ |
| *June 2024 – present*   |

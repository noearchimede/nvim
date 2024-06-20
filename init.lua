--                          ┌──────────────────────┐
--                          │ Neovim Configuration │
--                          └──────────────────────┘



-- – Leader key –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

vim.g.mapleader = '\\'
vim.g.maplocalleader = '\\'



-- – Plugins ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

require("plugins")


-- – Main global settings –––––––––––––––––––––––––––––––––––––––––––––––––––––

require("mappings")
require("settings")



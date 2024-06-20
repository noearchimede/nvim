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


-- – Additional settings ––––––––––––––––––––––––––––––––––––––––––––––––––––––


-- custom keyboard standardization script
vim.g.vimrc_keyboard_remappings_path = vim.fn.stdpath("config") .. "/.vimrc_keyboard_standardization.vim"
if vim.fn.filereadable(vim.fn.expand(vim.g.vimrc_keyboard_remappings_path)) ~= 0 then
    vim.cmd('source ' ..  vim.g.vimrc_keyboard_remappings_path)
end

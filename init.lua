--                          ┌──────────────────────┐
--                          │ Neovim Configuration │
--                          └──────────────────────┘



-- – Leader key –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

vim.g.mapleader = '\\'
vim.g.maplocalleader = ','


-- – Plugins ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

-- Plugins managed by lazy-nvim. The actual plugin specs are defined in the
-- 'plugins' folder, where each plugin or group of plugins is defined in its
-- own file.
-- install lazy.nvim (code copied from lazy.nvim documentation)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then ---@diagnostic disable-line: undefined-field
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- load plugins
require("lazy").setup("plugins")


-- – Main settings files ––––––––––––––––––––––––––––––––––––––––––––––––––––––

require("mappings")
require("settings")
require("commands")

require("terminal")
require("gui")


-- – Additional settings ––––––––––––––––––––––––––––––––––––––––––––––––––––––

-- custom keyboard standardization script
vim.g.vimrc_keyboard_remappings_path = vim.fn.stdpath("config") .. "/.vimrc_keyboard_standardization.vim"
if vim.fn.filereadable(vim.fn.expand(vim.g.vimrc_keyboard_remappings_path)) ~= 0 then
    vim.cmd('source ' ..  vim.g.vimrc_keyboard_remappings_path)
end

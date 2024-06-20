--                             ┌─────────┐
--                             │ Plugins │
--                             └─────────┘
--
-- Plugins managed by lazy-nvim. The actual plugin specs are defined in the
-- 'plugins' folder, where each plugin or group of plugins is defined in its
-- own file.


-- install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


-- load plugins
require("lazy").setup("plugins")


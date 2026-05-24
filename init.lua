-- Detect omarchy
vim.g.omarchy = false
vim.g.omarchy_theme = vim.fn.expand("~/.config/omarchy/current/theme/neovim.lua")
if vim.fn.filereadable(vim.g.omarchy_theme) == 1 then
  vim.g.omarchy = true
end

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

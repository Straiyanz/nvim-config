require("test")
require("plugins")
require("remap")
require("lualine").setup {
    options = { theme = "material" }
}
require("nvim-web-devicons").setup()

-- Theme
vim.opt.termguicolors = true
vim.g.material_style = "deep ocean"
vim.cmd 'colorscheme material'

-- Line Numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Tab Width
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- Keep Cursor Centered
vim.opt.scrolloff = 15

vim.opt.wrap = false

-- LSP
require("mason").setup()
require("lsp")
vim.diagnostic.config({
    virtual_text = true,
    virtual_lines = false,
})

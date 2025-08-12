-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Telescope
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- Color schemes
    use "marko-cerovac/material.nvim"

    -- Lua line
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }
    use 'nvim-tree/nvim-web-devicons'

    -- Tree-Sitter
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate'})

    -- LSP
    use "neovim/nvim-lspconfig"

    -- Mason
    use "mason-org/mason.nvim"
    use "mason-org/mason-lspconfig.nvim"
end)

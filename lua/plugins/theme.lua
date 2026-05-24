if vim.fn.filereadable(vim.g.omarchy_theme) == 1 then
  return dofile(vim.g.omarchy_theme)
end

return {
  {
    "marko-cerovac/material.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      vim.g.material_style = "deep ocean"

      require("material").setup({
        plugins = {
          "harpoon",
          "neo-tree",
          "telescope",
          "which-key",
          -- "blink",
          -- "coc",
          -- "colorful-winsep",
          -- "dap",
          -- "dashboard",
          -- "eyeliner",
          -- "fidget",
          -- "flash",
          -- "gitsigns",
          -- "hop",
          -- "illuminate",
          -- "indent-blankline",
          -- "lspsaga",
          -- "mini",
          -- "neogit",
          -- "neorg",
          -- "neotest",
          -- "noice",
          -- "nvim-cmp",
          -- "nvim-navic",
          -- "nvim-notify",
          -- "nvim-tree",
          -- "nvim-web-devicons",
          -- "rainbow-delimiters",
          -- "sneak",
          -- "trouble",
        },
        lualine_style = "stealth",
        async_loading = true,
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "material",
    },
  },
}

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ruff = {
        cmd_env = { RUFF_TRACE = "messages" },
        init_options = {
          settings = {
            logLevel = "error",
            lint = {
              enable = false,
            },
          },
        },
      },
      ruff_lsp = {},
    },
    setup = {
      ["ruff"] = function()
        Snacks.util.lsp.on({ name = "ruff" }, function(_, client)
          -- Disable hover in favor of Pyright
          client.server_capabilities.hoverProvider = false
        end)
      end,
    },
  },
}

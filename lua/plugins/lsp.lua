return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      rust_analyzer = {
        mason = false,
      },
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
      vtsls = {
        settings = {
          typescript = {
            preferences = {
              quoteStyle = "single",
              importModuleSpecifier = "non-relative",
            },
          },
          javascript = {
            preferences = {
              quoteStyle = "single",
              importModuleSpecifier = "non-relative",
            },
          },
        },
      },
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

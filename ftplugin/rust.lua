vim.g.rustfmt_autosave = 1
vim.g.rustfmt_options = '--edition 2024'

local lsp = require("bsteffaniak.lsp")

-- Configure LSP through rust-tools.nvim plugin.
-- rust-tools will configure and enable certain LSP features for us.
-- See https://github.com/simrat39/rust-tools.nvim#configuration
vim.g.rustaceanvim = {
  tools = {
    runnables = {
      use_telescope = true,
    },
    inlay_hints = {
      auto = true,
      show_parameter_hints = false,
      parameter_hints_prefix = "",
      other_hints_prefix = "",
    },
  },

  -- all the opts to send to nvim-lspconfig
  -- these override the defaults set by rust-tools.nvim
  -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
  server = {
    cmd = {
      "ra-multiplex",
    },
    -- on_attach is a callback called when the language server attachs to the buffer
    on_attach = function(client, bufnr)
      -- you can also put keymaps in here
      lsp.lsp_on_attach(client, bufnr)
    end,
    settings = {
      -- to enable rust-analyzer settings visit:
      -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
      ["rust-analyzer"] = {
        rustfmt = {
          rangeFormatting = { enable = true },
        },
        cargo = {
          extraEnv = {
            TUNNEL_ACCESS_TOKEN = "123",
            STATIC_TOKEN = "123",
            ENABLE_ASSERT = "1",
          },
        },
      },
    },
  },
}

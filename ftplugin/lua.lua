if Lua_initialized then return end
Lua_initialized = true

local status, nvim_lsp = pcall(require, "lspconfig")

if (not status) then return end

local lsp = require("bsteffaniak/lsp")
local lsp_on_attach = lsp.lsp_on_attach

nvim_lsp.lua_ls.setup {
  on_attach = lsp_on_attach,
  filetypes = { "lua" },
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
}

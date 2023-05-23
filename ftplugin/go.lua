if Go_initialized then return end
Go_initialized = true

local status, nvim_lsp = pcall(require, "lspconfig")

if (not status) then return end

local lsp = require("bsteffaniak/lsp")
local lsp_on_attach = lsp.lsp_on_attach

nvim_lsp.gopls.setup {
  on_attach = lsp_on_attach,
}

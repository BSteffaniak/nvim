if Js_initialized then return end
Js_initialized = true

local status, nvim_lsp = pcall(require, "lspconfig")

if (not status) then return end

local lsp = require("bsteffaniak/lsp")
local lsp_on_attach = lsp.lsp_on_attach

nvim_lsp.eslint.setup {
  on_attach = lsp_on_attach,
}


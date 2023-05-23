vim.cmd('runtime! ftplugin/javascript.lua')

local status, nvim_lsp = pcall(require, "lspconfig")

if (not status) then return end

local lsp = require("bsteffaniak/lsp")
local lsp_on_attach = lsp.lsp_on_attach

nvim_lsp.tsserver.setup {
  on_attach = lsp_on_attach,
  cmd = { "typescript-language-server", "--stdio" },
}

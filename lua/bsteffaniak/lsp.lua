local M = {}

-- local protocol = require('vim.lsp.protocol')

local butil = require 'bsteffaniak.util'
local get_range = butil.get_range

function M.lsp_on_attach(client, bufnr)
  M.init_formatting(client, bufnr)

  vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "[e", "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "]e", "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "[w", "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.WARN})<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "]w", "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.WARN})<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "[i", "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.INFO})<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "]i", "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.INFO})<CR>", { noremap = true, silent = true })
  vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', 'K', "<cmp>lua require('lsp_signature').toggle_float_win()<CR>", { noremap = true, silent = true })
  vim.keymap.set('n', 'gr', "<cmd>lua require('goto-preview').goto_preview_references()<CR>", { noremap = true, silent = true })
  vim.keymap.set('n', 'gh', "<cmd>Telescope lsp_references<CR>", { noremap = true, silent = true })
  vim.keymap.set('i', '<C-m>', "<cmp>lua require('lsp_signature').toggle_float_win()<CR>", { noremap = true, silent = true })
  vim.keymap.set('n', 'gp', "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", { noremap = true, silent = true })
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', 'gL', '<cmd>Telescope diagnostics<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', 'gt', '<cmd>TroubleToggle<CR>', { noremap = true, silent = true })

 -- format on save
  -- if client.server_capabilities.documentFormattingProvider then
  --   vim.api.nvim_create_autocmd("BufWritePre", {
  --     group = vim.api.nvim_create_augroup("Format", { clear = true }),
  --     buffer = bufnr,
  --     callback = function() vim.lsp.buf.formatting_seq_sync() end
  --   })i
  -- end
end

function M.init_formatting(client, bufnr)
  if client.supports_method("textDocument/formatting") then
    vim.keymap.set("n", "<Leader>a", function()
      vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
    end, { buffer = bufnr, desc = "[lsp] format" })
  end

  if client.supports_method("textDocument/rangeFormatting") then
    vim.keymap.set("x", "<Leader>a", function()
      vim.lsp.buf.format({
        bufnr = vim.api.nvim_get_current_buf(),
        range = get_range(),
      })
    end, { buffer = bufnr, desc = "[lsp] format" })
  end
end

return M

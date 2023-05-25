local M = {}

-- local protocol = require('vim.lsp.protocol')

function M.lsp_on_attach(client, bufnr)
  M.init_formatting(client, bufnr)

  vim.keymap.set('n', 'g[', '<Cmd>Lspsaga diagnostic_jump_prev<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', 'g]', '<Cmd>Lspsaga diagnostic_jump_next<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', 'ga', '<Cmd>Lspsaga code_action<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', 'K', '<Cmd>Lspsaga hover_doc<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', 'gh', '<Cmd>Lspsaga lsp_finder<CR>', { noremap = true, silent = true })
  vim.keymap.set('i', '<C-k>', '<Cmd>Lspsaga signature_help<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', 'gp', '<Cmd>Lspsaga peek_definition<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', 'gd', '<Cmd>Lspsaga goto_definition<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', 'g<F2>', '<Cmd>Lspsaga rename<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', 'gl', '<Cmd>Lspsaga show_line_diagnostics<CR>', { noremap = true, silent = true })

 -- format on save
  -- if client.server_capabilities.documentFormattingProvider then
  --   vim.api.nvim_create_autocmd("BufWritePre", {
  --     group = vim.api.nvim_create_augroup("Format", { clear = true }),
  --     buffer = bufnr,
  --     callback = function() vim.lsp.buf.formatting_seq_sync() end
  --   })
  -- end
end

---@diagnostic disable-next-line: unused-local
function M.on_attach(client, buffer)
  -- This callback is called when the LSP is atttached/enabled for this buffer
  -- we could set keymaps related to LSP, etc here.
  local keymap_opts = { buffer = buffer }
  -- Code navigation and shortcuts
  vim.keymap.set("n", "<c-]>", vim.lsp.buf.definition, keymap_opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, keymap_opts)
  vim.keymap.set("n", "gD", vim.lsp.buf.implementation, keymap_opts)
  vim.keymap.set("n", "<c-k>", vim.lsp.buf.signature_help, keymap_opts)
  vim.keymap.set("n", "1gD", vim.lsp.buf.type_definition, keymap_opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, keymap_opts)
  vim.keymap.set("n", "g0", vim.lsp.buf.document_symbol, keymap_opts)
  vim.keymap.set("n", "gW", vim.lsp.buf.workspace_symbol, keymap_opts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, keymap_opts)
  vim.keymap.set("n", "<c-b>", vim.lsp.buf.definition, keymap_opts)
  vim.keymap.set("n", "ga", vim.lsp.buf.code_action, keymap_opts)
  vim.keymap.set("n", "<M-enter>", vim.lsp.buf.code_action, keymap_opts)

  -- Set updatetime for CursorHold
  -- 300ms of no cursor movement to trigger CursorHold
  vim.opt.updatetime = 100

  -- Show diagnostic popup on cursor hover
  local diag_float_grp = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true })
  vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
     vim.diagnostic.open_float(nil, { focusable = false })
    end,
    group = diag_float_grp,
  })

  -- Goto previous/next diagnostic warning/error
  vim.keymap.set("n", "g[", vim.diagnostic.goto_prev, keymap_opts)
  vim.keymap.set("n", "g]", vim.diagnostic.goto_next, keymap_opts)
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

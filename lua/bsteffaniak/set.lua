vim.keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.expandtab = true

vim.wo.signcolumn = "yes"

vim.opt.wrap = false
vim.o.setopt = "hidden"

-- Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not auto-select, nvim-cmp plugin will handle this for us.
vim.o.completeopt = "menuone,noinsert,noselect"

local util = require 'packer.util'
local cwd = vim.fn.getcwd()

local function get_session_file()
  local homeDir = os.getenv("HOME")

  if homeDir == nil or homeDir == "" then
    homeDir = os.getenv("userprofile")
  end

  local sessions_directory = util.join_paths(homeDir, ".nvim_sessions")

  if util.is_windows then
    os.execute("if not exist " .. sessions_directory .. " mkdir " .. sessions_directory)
  else
    os.execute("mkdir -p " .. sessions_directory)
  end

  local fileName = vim.fn.getcwd():gsub(":", "_"):gsub("/", "_"):gsub("\\", "_") .. "_session.vim"

  return util.join_paths(sessions_directory, fileName)
end

function handle_save_session()
  vim.cmd("mksession! " .. get_session_file())
end

function handle_load_session()
  vim.cmd("source " .. get_session_file())
end

function handle_save_and_quit()
  handle_save_session()
  vim.cmd("qa")
end

function handle_force_save_and_quit()
  handle_save_session()
  vim.cmd("qa!")
end

vim.keymap.set("n", "<Leader>o", "o<Esc>", {noremap = true})
vim.keymap.set("n", "<Leader>O", "O<Esc>", {noremap = true})
vim.keymap.set("n", "<Leader>e", ":GFiles<Enter>", {noremap = true})
vim.keymap.set("n", "<Leader><Leader>", ":Files<Enter>", {noremap = true})
vim.keymap.set("n", "<Leader>t", ":NvimTreeToggle<Enter>", {noremap = true})
vim.keymap.set("n", "<Leader>g", ":NvimTreeFindFile<Enter>", {noremap = true})
vim.keymap.set("n", "<Leader>c", ":NvimTreeCollapse<Enter>", {noremap = true})
vim.keymap.set("n", "<Leader>f", ":Rg<Enter>", {noremap = true})
vim.keymap.set("n", "<Leader>b", ":Telescope buffers<Enter>", {noremap = true})
vim.keymap.set("n", "<Leader>s", handle_save_session, {noremap = true})
vim.keymap.set("n", "<Leader>S", ":mksession! ~/", {noremap = true})
vim.keymap.set("n", "<Leader>q", handle_save_and_quit, {noremap = true})
vim.keymap.set("n", "<Leader>Q", handle_force_save_and_quit, {noremap = true})
vim.keymap.set("n", "<Leader>l", handle_load_session, {noremap = true})
vim.keymap.set("n", "<Leader>L", ":source ~/", {noremap = true})

local function on_attach(client, buffer)
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

-- Configure LSP through rust-tools.nvim plugin.
-- rust-tools will configure and enable certain LSP features for us.
-- See https://github.com/simrat39/rust-tools.nvim#configuration
local opts = {
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
    -- on_attach is a callback called when the language server attachs to the buffer
    on_attach = on_attach,
    settings = {
      -- to enable rust-analyzer settings visit:
      -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
      ["rust-analyzer"] = {
        -- enable clippy on save
        checkOnSave = {
          command = "clippy",
        },
      },
    },
  },
}

require("rust-tools").setup(opts)

-- Setup Completion
-- See https://github.com/hrsh7th/nvim-cmp#basic-configuration
local cmp = require("cmp")
cmp.setup({
  preselect = cmp.PreselectMode.None,
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    -- Add tab support
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
  },

  -- Installed sources
  sources = {
    { name = "nvim_lsp" },
    { name = "vsnip" },
    { name = "path" },
    { name = "buffer" },
  },
})

local elixir = require("elixir")

elixir.setup({
  -- on_attach is a callback called when the language server attachs to the buffer
  on_attach = on_attach,
})

require('telescope').setup({
	defaults = {
		path_display = {"smart"}
	}
})

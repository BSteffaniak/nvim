
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.o.nofixendofline = true

vim.wo.signcolumn = "yes"
vim.bo.fileformat = "unix"

vim.opt.wrap = false
vim.o.setopt = "hidden"

local wrapping_files = "*.md"

vim.api.nvim_create_autocmd(
  { "BufNewFile", "BufRead" },
  { pattern = "*.tsx", command = "runtime! ftplugin/typescriptreact.lua" }
)
vim.api.nvim_create_autocmd(
  { "BufNewFile", "BufRead" },
  { pattern = "*.flat", command = "set filetype=cs" }
)
vim.api.nvim_create_autocmd(
  { "BufNewFile", "BufRead" },
  { pattern = wrapping_files, command = "setlocal wrap" }
)
vim.api.nvim_create_autocmd(
  { "BufNewFile", "BufRead" },
  { pattern = wrapping_files, command = "setlocal linebreak" }
)
vim.api.nvim_create_autocmd(
  { "BufWrite" },
  { command = "GitGutter" }
)

-- Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not auto-select, nvim-cmp plugin will handle this for us.
vim.o.completeopt = "menuone,noinsert,noselect"

local util = require("packer/util")
local butil = require("bsteffaniak/util")

require("bsteffaniak/keymap")

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

local telescope = require('telescope')

telescope.setup({
	defaults = {
		path_display = {"smart"},
    vimgrep_arguments = {
      "rg",
      "--files",
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden',
      '--glob',
      '!.git',
      "--ignore-file",
      util.join_paths(butil.cwd, ".gitignore"),
    }
	}
})

require("nvim-lsp-installer").setup {}

local lsp = require("bsteffaniak/lsp")
local lsp_on_attach = lsp.lsp_on_attach

local null_ls = require("null-ls")

null_ls.setup {
  on_attach = lsp.init_formatting,
}

local prettier = require("prettier")

prettier.setup({
  bin = 'prettierd',
  filetypes = {
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "less",
    "markdown",
    "scss",
    "typescript",
    "typescriptreact",
    "yaml",
  },
  ["null-ls"] = {
    condition = function()
      return true
      -- return prettier.config_exists({
      --   -- if `false`, skips checking `package.json` for `"prettier"` key
      --   check_package_json = true,
      -- })
    end,
---@diagnostic disable-next-line: unused-local
    runtime_condition = function(params)
      -- return false to skip running prettier
      return true
    end,
    timeout = 5000,
  }
})

require "nvim-treesitter.configs".setup {
  ensure_installed = "all",
  highlight = {
    enable = true,
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25,
    persist_queries = false,
  },
}

require "lualine".setup {}

require "illuminate".configure {}

local status, nvim_lsp = pcall(require, "lspconfig")

if (not status) then return end

nvim_lsp.ccls.setup { on_attach = lsp_on_attach }
nvim_lsp.jsonls.setup { on_attach = lsp_on_attach }
nvim_lsp.gopls.setup { on_attach = lsp_on_attach }
nvim_lsp.bashls.setup { on_attach = lsp_on_attach }
nvim_lsp.elixirls.setup {
  on_attach = lsp_on_attach,
  cmd = { util.join_paths(butil.home_dir, '.local', 'share', 'nvim', 'lsp_servers', 'elixir', 'elixir-ls', 'language_server' .. butil.executable_ext) }
}
nvim_lsp.eslint.setup {
  on_attach = lsp_on_attach,
}
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
nvim_lsp.tsserver.setup {
  on_attach = lsp_on_attach,
  cmd = { "typescript-language-server", "--stdio" },
}

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.fixendofline = false

vim.wo.signcolumn = "yes"
vim.bo.fileformat = "unix"

vim.opt.wrap = false
vim.opt.relativenumber = true

vim.g.sessions_home_directory = os.getenv("NVIM_SESSIONS_HOME_DIRECTORY")

local wrapping_files = "*.md"

vim.api.nvim_create_autocmd(
  { "BufNewFile", "BufRead" },
  { pattern = "*.tsx", command = "runtime! ftplugin/typescriptreact.lua" }
)
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = "*.flat", command = "set filetype=cs" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = wrapping_files, command = "setlocal wrap" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = wrapping_files, command = "setlocal linebreak" })
vim.api.nvim_create_autocmd({ "BufWrite" }, { command = "GitGutter" })

require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
    },
  },
})

-- Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not auto-select, nvim-cmp plugin will handle this for us.
vim.o.completeopt = "menuone,noinsert,noselect"

local util = require("bsteffaniak.util")

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

local telescope = require("telescope")

telescope.setup({
  defaults = {
    path_display = { "smart" },
    vimgrep_arguments = {
      "rg",
      "--files",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
      "--glob",
      "!.git",
      "--ignore-file",
      util.join_paths(util.cwd, ".gitignore"),
    },
  },
})

require("goto-preview").setup({})

require("lsp_signature").setup({})

--require("nvim-treesitter.configs").setup({
--  ensure_installed = "all",
--  highlight = {
--    enable = true,
--  },
--  playground = {
--    enable = true,
--    disable = {},
--    updatetime = 25,
--    persist_queries = false,
--  },
--})

require("lualine").setup({})

require("illuminate").configure({})

local lsp = require("bsteffaniak.lsp")
local lsp_on_attach = lsp.lsp_on_attach

local servers = {
  gopls = {},
  html = {},
  jsonls = {},
  rust_analyzer = {},
  lua_ls = {
    filetypes = { "lua" },
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
      },
    },
  },
  tsserver = {
    cmd = { "typescript-language-server", "--stdio" },
  },
  svelte = {},
  bashls = {},
  clangd = {},
  elixirls = {
    cmd = {
      util.join_paths(
        util.home_dir,
        ".local",
        "share",
        "nvim",
        "lsp_servers",
        "elixir",
        "elixir-ls",
        "language_server" .. util.executable_ext
      ),
    },
  },
}

require("config.lsp.null-ls").setup(lsp_on_attach)
require("config.lsp.installer").setup(servers)

vim.g.rustfmt_autosave = 1

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  on_attach = function(bufnr)
    vim.keymap.del("n", "s", { buffer = bufnr })
  end,
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
  git = {
    ignore = false,
  },
})

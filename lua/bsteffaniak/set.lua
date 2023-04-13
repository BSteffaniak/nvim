vim.keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.termguicolors = true

vim.wo.signcolumn = "yes"

vim.opt.wrap = false
vim.o.setopt = "hidden"

-- Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not auto-select, nvim-cmp plugin will handle this for us.
vim.o.completeopt = "menuone,noinsert,noselect"

local function regex_escape(str)
  return str:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1")
end

string.replace = function (str, this, that)
  local pattern = regex_escape(this)
  local replacement = that:gsub("%%", "%%%%") -- only % needs to be escaped for 'that'

  return str:gsub(pattern, replacement)
end

local util = require 'packer.util'
local cwd = vim.fn.getcwd()
local executable_ext = ".sh"

if util.is_windows then
  executable_ext = ".bat"
end

local function get_home_directory()
  local home_dir = os.getenv("HOME")

  if home_dir == nil or home_dir == "" then
    home_dir = os.getenv("userprofile")
  end

  return home_dir
end

local home_dir = get_home_directory()

local function get_session_file()
  local sessions_directory = util.join_paths(home_dir, ".nvim_sessions")

  if util.is_windows then
    os.execute("if not exist " .. sessions_directory .. " mkdir " .. sessions_directory)
  else
    os.execute("mkdir -p " .. sessions_directory)
  end

  local fileName = cwd:gsub(":", "_"):gsub("/", "_"):gsub("\\", "_") .. "_session.vim"

  return util.join_paths(sessions_directory, fileName)
end

function Handle_save_session()
  vim.cmd("mksession! " .. get_session_file())
end

function Handle_load_session()
  vim.cmd("source " .. get_session_file())
end

function Handle_save_and_quit()
  local unsaved = ""

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_option(buf, 'modified') then
      if #unsaved > 0 then
        unsaved = unsaved .. ", "
      end

      local full_buf_name = vim.api.nvim_buf_get_name(buf)
      local buf_name = string.replace(full_buf_name, cwd .. util.get_separator(), "")

      unsaved = unsaved .. buf_name
    end
  end

  if #unsaved > 0 then
    print('Unsaved buffers: ' .. unsaved .. '. Save them before you quit!')

    return
  end

  Handle_save_session()
  vim.cmd("qa")
end

function Handle_force_save_and_quit()
  Handle_save_session()
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
vim.keymap.set("n", "<Leader>s", Handle_save_session, {noremap = true})
vim.keymap.set("n", "<Leader>S", ":mksession! ~/", {noremap = true})
vim.keymap.set("n", "<Leader>q", Handle_save_and_quit, {noremap = true})
vim.keymap.set("n", "<Leader>Q", Handle_force_save_and_quit, {noremap = true})
vim.keymap.set("n", "<Leader>l", Handle_load_session, {noremap = true})
vim.keymap.set("n", "<Leader>L", ":source ~/", {noremap = true})
vim.keymap.set("n", "<Leader>;", "@:", {noremap = true})

---@diagnostic disable-next-line: unused-local
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
      "--ignore-file",
      util.join_paths(cwd, ".gitignore"),
    }
	}
})

function get_range()
  local start_sel_row = vim.api.nvim_eval('getpos("v")[1]')
  local start_sel_col = vim.api.nvim_eval('getpos("v")[2]')
  local end_sel_row = vim.api.nvim_eval('getpos(".")[1]')
  local end_sel_col = vim.api.nvim_eval('getpos(".")[2]')

  return {
    start = { start_sel_row, start_sel_col },
    ["end"] = { end_sel_row, end_sel_col },
  }
end

local null_ls = require("null-ls")

null_ls.setup({
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.keymap.set("n", "af", function()
        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
      end, { buffer = bufnr, desc = "[lsp] format" })

      -- local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
      -- local event = "BufWritePre" -- or "BufWritePost"
      -- local async = event == "BufWritePost"
      -- 
      -- -- format on save
      -- vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
      -- vim.api.nvim_create_autocmd(event, {
      --   buffer = bufnr,
      --   group = group,
      --   callback = function()
      --     vim.lsp.buf.format({ bufnr = bufnr, async = async })
      --   end,
      --   desc = "[lsp] format on save",
      -- })
    end

    if client.supports_method("textDocument/rangeFormatting") then
      vim.keymap.set("x", "af", function()
        vim.lsp.buf.format({
          bufnr = vim.api.nvim_get_current_buf(),
          range = get_range(),
        })
      end, { buffer = bufnr, desc = "[lsp] format" })
    end
  end,
})

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
      return prettier.config_exists({
        -- if `false`, skips checking `package.json` for `"prettier"` key
        check_package_json = true,
      })
    end,
---@diagnostic disable-next-line: unused-local
    runtime_condition = function(params)
      -- return false to skip running prettier
      return true
    end,
    timeout = 5000,
  }
})

local status, nvim_lsp = pcall(require, "lspconfig")

if (not status) then return end

-- local protocol = require('vim.lsp.protocol')

---@diagnostic disable-next-line: unused-local
local lsp_on_attach = function(client, bufnr)
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

-- TypeScript
nvim_lsp.tsserver.setup {
  on_attach = lsp_on_attach,
  filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
  cmd = { "typescript-language-server", "--stdio" },
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

local function diag_on_attach(client)
  print('Attached to ' .. client.name)
end

local dlsconfig = require 'diagnosticls-configs'

dlsconfig.init {
  -- Your custom attach function
  on_attach = diag_on_attach,
  default_config = true,
  format = true,
}

local eslint_linter = require 'diagnosticls-configs.linters.eslint'
local standard_linter = require 'diagnosticls-configs.linters.standard'
local prettier_formatter = require 'diagnosticls-configs.formatters.prettier'
local prettier_standard_formatter = require 'diagnosticls-configs.formatters.prettier_standard'

dlsconfig.setup {
  ['javascript'] = {
    linter = eslint_linter,
    formatter = prettier_formatter,
  },
  ['javascriptreact'] = {
    -- Add multiple linters
    linter = { eslint_linter, standard_linter },
    -- Add multiple formatters
    formatter = { prettier_formatter, prettier_standard_formatter },
  },
}

-- vim.lsp.set_log_level("debug")

-- Java
nvim_lsp.jdtls.setup {
  on_attach = lsp_on_attach,
  filetypes = { "java" },
  cmd = { util.join_paths(home_dir, '.local', 'bin', 'jdtls') },
}

-- local jdtls_config = {
--   cmd = {util.join_paths(vim.fn.stdpath('data'), 'lsp_servers', 'jdtls', 'bin', 'jdtls')},
--   root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
--   on_attach = lsp_on_attach,
-- }
-- require('jdtls').start_or_attach(jdtls_config)

require "nvim-treesitter.configs".setup {
  ensure_installed = "all",
  highlight = {
    enable = true,
  },
}

require "nvim-treesitter.configs".setup {
  playground = {
    enable = true,
    disable = {},
    updatetime = 25,
    persist_queries = false,
  },
}

require "lualine".setup {}

require "illuminate".configure {}

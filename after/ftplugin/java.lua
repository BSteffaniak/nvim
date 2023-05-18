vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
local jdtls = require("jdtls")
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local util = require 'packer.util'

local function get_home_directory()
  local home_dir = os.getenv("HOME")

  if home_dir == nil or home_dir == "" then
    home_dir = os.getenv("userprofile")
  end

  return home_dir
end

local home_dir = get_home_directory()

local function get_range()
  local start_sel_row = vim.api.nvim_eval('getpos("v")[1]')
  local start_sel_col = vim.api.nvim_eval('getpos("v")[2]')
  local end_sel_row = vim.api.nvim_eval('getpos(".")[1]')
  local end_sel_col = vim.api.nvim_eval('getpos(".")[2]')

  return {
    start = { start_sel_row, start_sel_col },
    ["end"] = { end_sel_row, end_sel_col },
  }
end

local function on_attach(client, bufnr)
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
end

local jdtls_config = {
  on_attach = on_attach,
  cmd = { util.join_paths(home_dir, '.local', 'opt', 'jdtls-launcher', 'jdtls', 'bin', 'jdtls') },
  root_dir = root_dir,
  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = "interactive",
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      format = {
        enabled = true,
        settings = {
          url = vim.fn.stdpath "config" .. "/lang-servers/eclipse-java-google-style.xml",
          profile = "GoogleStyle",
        },
      },
    },
    signatureHelp = { enabled = true },
    completion = {
      favoriteStaticMembers = {
        "org.hamcrest.MatcherAssert.assertThat",
        "org.hamcrest.Matchers.*",
        "org.hamcrest.CoreMatchers.*",
        "org.junit.jupiter.api.Assertions.*",
        "java.util.Objects.requireNonNull",
        "java.util.Objects.requireNonNullElse",
        "org.mockito.Mockito.*",
      },
    },
    contentProvider = { preferred = "fernflower" },
    extendedClientCapabilities = extendedClientCapabilities,
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
      },
      useBlocks = true,
    },
  },
}

jdtls.start_or_attach(jdtls_config)

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.fixendofline = false
vim.opt.scrolloff = 6

vim.wo.signcolumn = "yes"
vim.bo.fileformat = "unix"

vim.opt.wrap = false
vim.opt.relativenumber = false
vim.opt.spelllang = "en_us"
vim.opt.spell = true

vim.g.sessions_home_directory = os.getenv("NVIM_SESSIONS_HOME_DIRECTORY")

local wrapping_files = "*.md"

vim.api.nvim_create_autocmd(
  { "BufNewFile", "BufRead" },
  { pattern = "*.tsx", command = "runtime! ftplugin/typescriptreact.lua" }
)
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = "*.flat", command = "set filetype=flat" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = "*", command = "set spelloptions=camel" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = wrapping_files, command = "setlocal wrap" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = wrapping_files, command = "setlocal linebreak" })
vim.api.nvim_create_autocmd({ "BufWrite" }, { command = "GitGutter" })

-- local register = require("nvim-treesitter.lanugage").register
vim.treesitter.language.register("astro", "tsx")

vim.filetype.add({
  extension = {
    astro = "astro",
  },
})

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

require("fzf-lua").setup({
  previewers = {
    builtin = {
      title_fnamemodify = function(t, width)
        local min_left_padding = 4
        local min_right_padding = 4
        local max_text_width = width - min_left_padding - min_right_padding
        if #t > max_text_width then
          return "..." .. t:sub(#t - max_text_width + 3 + 1, #t)
        end
        return t
      end,
    },
  },
  winopts = {
    fullscreen = true,
    preview = {
      title_pos = "left",
    },
  },
  grep = {
    fzf_opts = {
      ["--delimiter"] = ":",
      ["--nth"] = "4..",
    },
    -- for case sensitive globs use '--glob'
    glob_flag = "--iglob",
    -- query separator pattern (lua): ' --'
    glob_separator = "%s%-%-",
    -- these are defaults that will be used if you run
    -- functions like live_grep directly from require("fzf-lua")
    rg_opts = "--color=always --max-columns=4096 --glob='!.git/' "
        .. "--column --line-number --no-heading --no-ignore "
        .. "--smart-case --hidden "
        .. "--ignore-file "
        .. util.join_paths(util.cwd, ".gitignore"),
    exec_empty_query = true,
  },
}, true)

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

-- require("goto-preview").setup({})

require("lsp_signature").setup({})

require("lualine").setup({})

require("illuminate").configure({})

local lsp = require("bsteffaniak.lsp")
local lsp_on_attach = lsp.lsp_on_attach

local servers = {
  astro = {},
  gopls = {},
  html = {},
  jsonls = {},
  -- fsautocomplete = {},
  -- rust_analyzer = {},
  pyright = {},
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
  kotlin_language_server = {
    cmd = { "kotlin-language-server" },
    init_options = {
      storagePath = util.join_paths(util.home_dir, ".local", "share", "nvim-kotlin-language-server"),
    },
    on_attach = lsp_on_attach,
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
  taplo = {
    on_attach = lsp_on_attach,
  },
}

require("config.lsp.none-ls").setup(lsp_on_attach)
require("config.lsp.installer").setup(servers)

if vim.fn.has("wsl") == 1 then
  vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("Yank", { clear = true }),
    callback = function()
      if vim.v.event.regname == "*" then
        vim.fn.system("clip.exe", vim.fn.getreg('"'))
      end
    end,
  })
end

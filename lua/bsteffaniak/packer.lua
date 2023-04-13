-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use 'nathom/filetype.nvim'

  use 'folke/tokyonight.nvim'
  use 'morhetz/gruvbox'
  use 'olimorris/onedarkpro.nvim'
  use 'kyazdani42/blue-moon'
  use 'ayu-theme/ayu-vim'
  use 'sainnhe/sonokai'

  use("neovim/nvim-lspconfig")
  -- Visualize lsp progress
  use({
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup()
    end
  })
  use("jose-elias-alvarez/null-ls.nvim")
  use("MunifTanjim/prettier.nvim")

  -- Autocompletion framework
  use("hrsh7th/nvim-cmp")
  use({
    -- cmp LSP completion
    "hrsh7th/cmp-nvim-lsp",
    -- cmp Snippet completion
    "hrsh7th/cmp-vsnip",
    -- cmp Path completion
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    after = { "hrsh7th/nvim-cmp" },
    requires = { "hrsh7th/nvim-cmp" },
  })
  -- See hrsh7th other plugins for more great completion sources!
  -- Snippet engine
  use('hrsh7th/vim-vsnip')
  -- Adds extra functionality over rust analyzer
  use("simrat39/rust-tools.nvim")

  -- Optional
  use("nvim-lua/popup.nvim")
  use("nvim-lua/plenary.nvim")
  use("nvim-telescope/telescope.nvim")
  use("wincent/ferret")

  use("rust-lang/rust.vim")

  use { "junegunn/fzf", run = "./install --all" }
  use { "junegunn/fzf.vim" }

  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }

  use("airblade/vim-gitgutter")

  use({ "mhanberg/elixir.nvim", requires = { "nvim-lua/plenary.nvim" }})
  use("elixir-editors/vim-elixir")

  use "nvim-treesitter/nvim-treesitter"

  use({
    "glepnir/lspsaga.nvim",
    opt = true,
    branch = "main",
    event = "LspAttach",
    config = function()
        require("lspsaga").setup({
          lightbulb = {
            enable = false,
          },
          -- finder
          finder = {
            keys = {
              vsplit = "v",
              split = "x"
            }
          },
          -- peek definition
          definition = {
            keys = {
              edit = "gq"
            },
          --  edit = 'gq',
          --  vsplit = 'gv',
          --  split = 'gx',
          --  tabe = 'gt',
          --  quit = '<Esc>',
            close = '<Esc>',
          },
        })
    end,
    requires = {
        {"nvim-tree/nvim-web-devicons"},
        --Please make sure you install markdown and markdown_inline parser
        {"nvim-treesitter/nvim-treesitter"}
    }
  })

  use {
    "creativenull/diagnosticls-configs-nvim",
    tag = "v0.1.8",
    requires = "neovim/nvim-lspconfig",
  }

  use 'f-person/git-blame.nvim'

  use 'williamboman/nvim-lsp-installer'
  use 'mfussenegger/nvim-jdtls'

  use({
    "iamcco/markdown-preview.nvim",
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
    setup = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  })

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true },
  }

  use "rrethy/vim-illuminate"

  use "wesQ3/vim-windowswap"

  use "folke/zen-mode.nvim"
end)

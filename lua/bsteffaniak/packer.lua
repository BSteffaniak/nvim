-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
  -- Packer can manage itself
  use("wbthomason/packer.nvim")

  use("tweekmonster/startuptime.vim")

  use("williamboman/mason.nvim")
  use("williamboman/mason-lspconfig.nvim")
  use("neovim/nvim-lspconfig")

  use("lewis6991/gitsigns.nvim")

  use("folke/tokyonight.nvim")
  use("morhetz/gruvbox")
  use("olimorris/onedarkpro.nvim")
  use("kyazdani42/blue-moon")
  use("ayu-theme/ayu-vim")
  use("sainnhe/sonokai")
  use("srcery-colors/srcery-vim")
  use("fcpg/vim-fahrenheit")
  use("jdsimcoe/hyper.vim")
  use("yearofmoo/vim-darkmate")
  use("tomasiser/vim-code-dark")

  use({
    "folke/trouble.nvim",
    wants = "nvim-web-devicons",
    cmd = { "TroubleToggle", "Trouble" },
    config = function()
      require("trouble").setup({
        use_diagnostic_signs = true,
      })
    end,
  })

  -- Visualize lsp progress
  use({
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup()
    end,
    tag = "legacy",
  })
  use("jose-elias-alvarez/null-ls.nvim")

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
  use("hrsh7th/vim-vsnip")
  -- Adds extra functionality over rust analyzer
  use("simrat39/rust-tools.nvim")

  -- Optional
  use("nvim-lua/popup.nvim")
  use("nvim-lua/plenary.nvim")
  use("nvim-telescope/telescope.nvim")
  use("wincent/ferret")

  use("rust-lang/rust.vim")

  use({ "junegunn/fzf", run = "./install --all" })
  use({ "junegunn/fzf.vim" })

  use({
    "nvim-tree/nvim-tree.lua",
    requires = {
      "nvim-tree/nvim-web-devicons", -- optional, for file icons
    },
    tag = "nightly",              -- optional, updated every week. (see issue #1193)
  })

  use("airblade/vim-gitgutter")

  use({ "mhanberg/elixir.nvim", requires = { "nvim-lua/plenary.nvim" } })
  use("elixir-editors/vim-elixir")

  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

  use({
    "creativenull/diagnosticls-configs-nvim",
    tag = "v0.1.8",
    requires = "neovim/nvim-lspconfig",
  })

  use("f-person/git-blame.nvim")

  use("mfussenegger/nvim-jdtls")

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

  use({
    "nvim-lualine/lualine.nvim",
    requires = { "nvim-tree/nvim-web-devicons", opt = true },
  })

  use("rrethy/vim-illuminate")

  use("wesQ3/vim-windowswap")

  use("folke/zen-mode.nvim")
  use({
    "declancm/maximize.nvim",
    config = function()
      require("maximize").setup()
    end,
  })

  use({
    "rmagatti/goto-preview",
    config = function()
      require("goto-preview").setup({})
    end,
  })

  use({
    "ray-x/lsp_signature.nvim",
  })
end)

require("lazy").setup({
  "tweekmonster/startuptime.vim",

  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",

  "lewis6991/gitsigns.nvim",

  -- "folke/tokyonight.nvim",
  -- "morhetz/gruvbox",
  -- "olimorris/onedarkpro.nvim",
  -- "kyazdani42/blue-moon",
  -- "ayu-theme/ayu-vim",
  -- "sainnhe/sonokai",
  "srcery-colors/srcery-vim",
  -- "fcpg/vim-fahrenheit",
  -- "jdsimcoe/hyper.vim",
  -- "yearofmoo/vim-darkmate",
  -- "tomasiser/vim-code-dark",

  {
    "folke/trouble.nvim",
    wants = "nvim-web-devicons",
    cmd = { "TroubleToggle", "Trouble" },
    init = function()
      require("trouble").setup({
        use_diagnostic_signs = true,
      })
    end,
  },

  -- Visualize lsp progress
  {
    "j-hui/fidget.nvim",
    init = function()
      require("fidget").setup()
    end,
    tag = "legacy",
  },
  "jose-elias-alvarez/null-ls.nvim",

  -- Autocompletion framework
  "hrsh7th/nvim-cmp",
  {
    -- cmp LSP completion
    "hrsh7th/cmp-nvim-lsp",
    -- cmp Snippet completion
    "hrsh7th/cmp-vsnip",
    -- cmp Path completion
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    after = { "hrsh7th/nvim-cmp" },
    dependencies = { "hrsh7th/nvim-cmp" },
  },
  -- See hrsh7th other plugins for more great completion sources!
  -- Snippet engine
  "hrsh7th/vim-vsnip",
  -- Adds extra functionality over rust analyzer
  -- "simrat39/rust-tools.nvim",

  {
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    ft = { "rust" },
  },

  -- Optional
  -- "nvim-lua/popup.nvim",
  -- "nvim-lua/plenary.nvim",
  "nvim-telescope/telescope.nvim",
  "wincent/ferret",

  -- "rust-lang/rust.vim",

  { "junegunn/fzf",    build = "./install --all" },
  { "junegunn/fzf.vim" },

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- optional, for file icons
    },
    tag = "nightly",              -- optional, updated every week. (see issue #1193)
  },

  "airblade/vim-gitgutter",

  { "mhanberg/elixir.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  "elixir-editors/vim-elixir",

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "luckasRanarison/tree-sitter-hypr" },
      "nvim-treesitter/playground",
    },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        playground = {
          enable = true,
          disable = {},
          updatetime = 25,    -- Debounced time for highlighting nodes in the playground from source code
          persist_queries = false, -- Whether the query persists across vim sessions
          keybindings = {
            toggle_query_editor = "o",
            toggle_hl_groups = "i",
            toggle_injected_languages = "t",
            toggle_anonymous_nodes = "a",
            toggle_language_display = "I",
            focus_language = "f",
            unfocus_language = "F",
            update = "R",
            goto_node = "<cr>",
            show_help = "?",
          },
        },
      })
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.hypr = {
        install_info = {
          url = "https://github.com/luckasRanarison/tree-sitter-hypr",
          files = { "src/parser.c" },
          branch = "master",
        },
        filetype = "hypr",
      }
    end,
  },

  {
    "creativenull/diagnosticls-configs-nvim",
    tag = "v0.1.8",
    dependencies = "neovim/nvim-lspconfig",
  },

  "f-person/git-blame.nvim",

  "mfussenegger/nvim-jdtls",

  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
    init = function()
      require("lualine").setup({
        sections = {
          lualine_c = {
            {
              "filename",
              file_status = true, -- displays file status (readonly status, modified status)
              path = 1,    -- 0 = just filename, 1 = relative path, 2 = absolute path
            },
          },
        },
      })
    end,
  },

  "rrethy/vim-illuminate",

  "wesQ3/vim-windowswap",

  -- "folke/zen-mode.nvim",
  {
    "BSteffaniak/maximize.nvim",
    init = function()
      require("maximize").setup()
    end,
  },

  -- {
  --   "rmagatti/goto-preview",
  --   init = function()
  --     require("goto-preview").setup({})
  --   end,
  -- },

  {
    "ray-x/lsp_signature.nvim",
  },

  "tpope/vim-dadbod",
  "kristijanhusak/vim-dadbod-ui",

  "wuelnerdotexe/vim-astro",

  "HerringtonDarkholme/yats.vim",

  "ionide/Ionide-vim",
})

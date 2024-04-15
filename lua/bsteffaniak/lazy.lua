require("lazy").setup({
  "tweekmonster/startuptime.vim",

  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",

  "lewis6991/gitsigns.nvim",

  "srcery-colors/srcery-vim",

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
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
      "gbprod/none-ls-shellcheck.nvim",
    },
  },

  "jay-babu/mason-null-ls.nvim",

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

  {
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    ft = { "rust" },
  },

  -- Optional
  "nvim-telescope/telescope.nvim",
  "wincent/ferret",

  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- calling `setup` is optional for customization
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- optional, for file icons
    },
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

  {
    "BSteffaniak/maximize.nvim",
    init = function()
      require("maximize").setup()
    end,
  },

  {
    "ray-x/lsp_signature.nvim",
  },

  "tpope/vim-dadbod",
  "kristijanhusak/vim-dadbod-ui",

  "tpope/vim-fugitive",
  "tpope/vim-commentary",
  "tpope/vim-capslock",

  "wuelnerdotexe/vim-astro",

  "HerringtonDarkholme/yats.vim",

  "ionide/Ionide-vim",

  {
    "fabridamicelli/cronex.nvim",
    opts = {},
    config = function()
      -- Initialize module (important to create namespace)
      require("cronex").setup({})
      -- Grab the namespace that Cronex uses for the explanations
      local ns = vim.api.nvim_get_namespaces()["cronex"]
      -- Override the config only for that namespace
      vim.diagnostic.config({
        virtual_text = {
          prefix = "󰥔",
        },
      }, ns)
    end,
  },
})

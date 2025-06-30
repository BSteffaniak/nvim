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
    -- version = "^4", -- Recommended
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

  -- {
  --   "nvim-tree/nvim-tree.lua",
  --   dependencies = {
  --     "nvim-tree/nvim-web-devicons", -- optional, for file icons
  --   },
  -- },

  "airblade/vim-gitgutter",

  { "mhanberg/elixir.nvim",  dependencies = { "nvim-lua/plenary.nvim" } },
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

  {
    "stevearc/oil.nvim",
    opts = {},
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  -- { "github/copilot.vim" },

  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<A-Tab>",
          clear_suggestion = "<A-Enter>",
        },
      })
    end,
  },

  "stevearc/dressing.nvim",

  -- {
  --   "yetone/avante.nvim",
  --   event = "VeryLazy",
  --   version = false, -- Never set this value to "*"! Never!
  --   opts = {
  --     -- add any opts here
  --     -- for example
  --     provider = "openai",
  --     openai = {
  --       endpoint = "https://api.openai.com/v1",
  --       -- model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
  --       -- model = "o4-mini-high",
  --       model = "o3-mini",
  --       timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
  --       temperature = 0,
  --       max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
  --       --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
  --     },
  --     mappings = {
  --       submit = {
  --         -- keep the default Normal‑mode submit on <CR>…
  --         normal = "<CR>",
  --         -- …but switch Insert‑mode submit to <C‑e> instead of <C‑s>
  --         insert = "<C-e>",
  --       },
  --     },
  --   },
  --   -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  --   build = "make",
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --     "stevearc/dressing.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     --- The below dependencies are optional,
  --     "echasnovski/mini.pick", -- for file_selector provider mini.pick
  --     "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
  --     "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
  --     "ibhagwan/fzf-lua", -- for file_selector provider fzf
  --     "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
  --     "zbirenbaum/copilot.lua", -- for providers='copilot'
  --     {
  --       -- support for image pasting
  --       "HakonHarnes/img-clip.nvim",
  --       event = "VeryLazy",
  --       opts = {
  --         -- recommended settings
  --         default = {
  --           embed_image_as_base64 = false,
  --           prompt_for_file_name = false,
  --           drag_and_drop = {
  --             insert_mode = true,
  --           },
  --           -- required for Windows users
  --           -- use_absolute_path = true,
  --         },
  --       },
  --     },
  --     {
  --       -- Make sure to set this up properly if you have lazy=true
  --       'MeanderingProgrammer/render-markdown.nvim',
  --       opts = {
  --         file_types = { "markdown", "Avante" },
  --       },
  --       ft = { "markdown", "Avante" },
  --     },
  --   },
  -- }
})

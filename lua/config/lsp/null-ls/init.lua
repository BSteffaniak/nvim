local M = {}

local nls = require("null-ls")
local nls_utils = require("null-ls.utils")
local b = nls.builtins

local with_diagnostics_code = function(builtin)
  return builtin.with({
    diagnostics_format = "[SC#{c}] #{m}",
  })
end

local with_root_file = function(builtin, file)
  return builtin.with({
    condition = function(utils)
      return utils.root_has_file(file)
    end,
  })
end

local sources = {
  -- formatting
  b.formatting.prettierd,
  b.formatting.stylua,
  b.formatting.shfmt.with({ extra_args = { "-i", "4" } }),
  b.formatting.fixjson,
  b.formatting.black.with({ extra_args = { "--fast" } }),
  b.formatting.isort,
  b.formatting.taplo,
  -- b.formatting.dprint.with({ filetypes = { "toml" } }),

  -- diagnostics
  b.diagnostics.tidy,
  b.diagnostics.write_good,
  -- b.diagnostics.markdownlint,
  b.diagnostics.eslint_d,
  -- b.diagnostics.flake8,
  b.diagnostics.tsc,
  with_root_file(b.diagnostics.selene, "selene.toml"),
  with_diagnostics_code(b.diagnostics.shellcheck),

  -- code actions
  b.code_actions.gitsigns,
  b.code_actions.gitrebase,

  -- hover
  b.hover.dictionary,
}

function M.setup(on_attach)
  nls.setup({
    -- debug = true,
    debounce = 150,
    save_after_format = false,
    sources = sources,
    on_attach = on_attach,
    root_dir = nls_utils.root_pattern(".git"),
  })
end

return M

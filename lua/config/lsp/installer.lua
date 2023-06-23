local lspconfig = require("mason-lspconfig")

local M = {}

function M.setup(servers)
  local server_names = {}

  for server_name, _ in pairs(servers) do
    table.insert(server_names, server_name)
  end

  lspconfig.setup {
    ensure_installed = server_names,
    automatic_installation = true,
  }

  for server_name, _ in pairs(servers) do
    require("lspconfig")[server_name].setup(servers[server_name])
  end
end

return M

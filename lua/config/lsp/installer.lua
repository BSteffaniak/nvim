local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")

local M = {}

function M.setup(servers)
  local server_names = {}

  for server_name, _ in pairs(servers) do
    table.insert(server_names, server_name)
  end

  mason_lspconfig.setup({
    ensure_installed = server_names,
    automatic_installation = true,
  })

  for server_name, _ in pairs(servers) do
    local server = lspconfig[server_name]
    if server ~= nil then
      server.setup(servers[server_name])
    end
  end
end

return M

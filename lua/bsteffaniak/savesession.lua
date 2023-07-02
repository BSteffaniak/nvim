local util = require("packer/util")
local butil = require("bsteffaniak.util")

local function get_session_file()
  local sessions_directory = vim.g.sessions_home_directory

  if sessions_directory == nil then
    sessions_directory = util.join_paths(butil.home_dir, ".nvim_sessions")
  end

  if util.is_windows then
    os.execute("if not exist " .. sessions_directory .. " mkdir " .. sessions_directory)
  else
    os.execute("mkdir -p " .. sessions_directory)
  end

  local fileName = butil.sanitize_location(butil.cwd) .. "_session.vim"

  return util.join_paths(sessions_directory, fileName)
end

function Handle_save_session()
  vim.cmd("mksession! " .. get_session_file())
end

function Handle_load_session()
  local session_file = get_session_file()

  if butil.file_exists(session_file) ~= true then
    print("No session exists for " .. butil.cwd)

    return
  end

  vim.cmd("source " .. session_file)
end

function Handle_save_and_quit()
  local unsaved = ""

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_option(buf, "modified") then
      if #unsaved > 0 then
        unsaved = unsaved .. ", "
      end

      local full_buf_name = vim.api.nvim_buf_get_name(buf)
      local buf_name = string.replace(full_buf_name, butil.cwd .. util.get_separator(), "")

      unsaved = unsaved .. buf_name
    end
  end

  if #unsaved > 0 then
    print("Unsaved buffers: " .. unsaved .. ". Save them before you quit!")

    return
  end

  vim.cmd("NvimTreeClose")
  Handle_save_session()
  vim.cmd("qa")
end

function Handle_force_save_and_quit()
  vim.cmd("NvimTreeClose")
  Handle_save_session()
  vim.cmd("qa!")
end

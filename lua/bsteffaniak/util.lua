local M = {}

function M.get_range()
  local start_sel_row = vim.api.nvim_eval('getpos("v")[1]')
  local start_sel_col = vim.api.nvim_eval('getpos("v")[2]')
  local end_sel_row = vim.api.nvim_eval('getpos(".")[1]')
  local end_sel_col = vim.api.nvim_eval('getpos(".")[2]')

  return {
    start = { start_sel_row, start_sel_col },
    ["end"] = { end_sel_row, end_sel_col },
  }
end

function M.sanitize_location(location)
  return location:gsub(":", "_"):gsub("/", "_"):gsub("\\", "_")
end

function M.file_exists(name)
  local f = io.open(name, "r")

  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

M.separator = package.config:sub(1, 1)
M.is_windows = M.separator == "\\"

if M.is_windows and vim.o.shellslash then
  M.use_shellslash = true
else
  M.use_shallslash = false
end

M.get_separator = function()
  if M.is_windows and not M.use_shellslash then
    return "\\"
  end
  return "/"
end

M.strip_trailing_sep = function(path)
  local res, _ = string.gsub(path, M.get_separator() .. "$", "", 1)
  return res
end

M.join_paths = function(...)
  local separator = M.get_separator()
  return table.concat({ ... }, separator)
end

M.executable_ext = ".sh"

if M.is_windows then
  M.executable_ext = ".bat"
end

local function get_home_directory()
  local home_dir = os.getenv("HOME")

  if home_dir == nil or home_dir == "" then
    home_dir = os.getenv("userprofile")
  end

  return home_dir
end

M.home_dir = get_home_directory()
M.cwd = vim.fn.getcwd()

function M.regex_escape(str)
  return str:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1")
end

string.replace = function(str, this, that)
  local pattern = M.regex_escape(this)
  local replacement = that:gsub("%%", "%%%%") -- only % needs to be escaped for 'that'

  return str:gsub(pattern, replacement)
end

return M

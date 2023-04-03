# Installation

### Windows pre-configuration:

1. `[System.Environment]::SetEnvironmentVariable('XDG_CONFIG_HOME','%userprofile%\.config', 'User')`

--------------------------------

1. `git clone https://github.com/BSteffaniak/nvim.git ~/.config/nvim`
1. `nvim ~/.config/nvim/lua/bsteffaniak/packer.lua`
1. `:w`
1. `:luafile %`
1. `:PackerInstall`

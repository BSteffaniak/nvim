# Installation

### Windows pre-configuration:

1. ~~`[System.Environment]::SetEnvironmentVariable('XDG_CONFIG_HOME','%userprofile%\.config', 'User')`~~

Just use WSL and follow the instructions below:

--------------------------------

1. `npm i -g typescript-language-server @fsouza/prettierd diagnostic-languageserver`
1. `git clone https://github.com/BSteffaniak/nvim.git ~/.config/nvim`
1. `git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim`
1. `nvim ~/.config/nvim/lua/bsteffaniak/packer.lua`
1. `:luafile %`
1. `:PackerSync`
1. ubuntu: `sudo apt-get install openjdk-17-jdk openjdk-17-jre` mac: `brew install openjdk@17`
1. `curl https://raw.githubusercontent.com/eruizc-dev/jdtls-launcher/master/install.sh | bash`

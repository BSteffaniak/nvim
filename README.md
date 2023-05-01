# Installation

### Windows pre-configuration:

1. ~~`[System.Environment]::SetEnvironmentVariable('XDG_CONFIG_HOME','%userprofile%\.config', 'User')`~~

Just use WSL and follow the instructions below:

--------------------------------

1. `npm i -g typescript-language-server @fsouza/prettierd diagnostic-languageserver vscode-langservers-extracted bash-language-server`
1. ubuntu: `sudo apt-get install make cmake unzip gettext g++ ninja-build openjdk-17-jdk openjdk-17-jre bat ccls gopls` mac: `brew install ninja openjdk@17 bat gopls ccls`
1. `curl https://raw.githubusercontent.com/eruizc-dev/jdtls-launcher/master/install.sh | bash`
1. `git clone https://github.com/BSteffaniak/nvim.git ~/.config/nvim`
1. `~/.config/nvim/lls.sh`
1. `git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim`
1. `git clone --depth 1 https://github.com/neovim/neovim.git ~/.local/neovim-install`
1. `cd ~/.local/neovim-install`
1. `make CMAKE_BUILD_TYPE=RelWithDebInfo`
1. `sudo make install`
1. `nvim ~/.config/nvim/lua/bsteffaniak/packer.lua -c "luafile %" -c PackerSync`

References:

 * https://github.com/sharkdp/bat#installation

Todo:

 * https://www.erickpatrick.net/blog/adding-syntax-highlighting-to-fzf.vim-preview-window

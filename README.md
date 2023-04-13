# Installation

### Windows pre-configuration:

1. ~~`[System.Environment]::SetEnvironmentVariable('XDG_CONFIG_HOME','%userprofile%\.config', 'User')`~~

Just use WSL and follow the instructions below:

--------------------------------

1. `npm i -g typescript-language-server @fsouza/prettierd diagnostic-languageserver vscode-langservers-extracted`
1. ubuntu: `sudo apt-get install g++ ninja-build openjdk-17-jdk openjdk-17-jre rust-bat` mac: `brew install ninja openjdk@17 bat`
1. `curl https://raw.githubusercontent.com/eruizc-dev/jdtls-launcher/master/install.sh | bash`
1. `git clone https://github.com/BSteffaniak/nvim.git ~/.config/nvim`
1. `~/.config/nvim/lls.sh`
1. `git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim`
1. `nvim ~/.config/nvim/lua/bsteffaniak/packer.lua -c "luafile %" -c PackerSync`

References:

 * https://github.com/sharkdp/bat#installation

Todo:

 * https://www.erickpatrick.net/blog/adding-syntax-highlighting-to-fzf.vim-preview-window

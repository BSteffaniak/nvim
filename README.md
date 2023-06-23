# Installation

### Windows pre-configuration:

1. ~~`[System.Environment]::SetEnvironmentVariable('XDG_CONFIG_HOME','%userprofile%\.config', 'User')`~~

Just use WSL and follow the instructions below:

--------------------------------

1. `npm i -g typescript-language-server @fsouza/prettierd diagnostic-languageserver vscode-langservers-extracted bash-language-server write-good @johnnymorganz/stylua-bin`
1. ubuntu: `sudo apt-get install make cmake unzip gettext g++ ninja-build openjdk-17-jdk openjdk-17-jre bat ccls gopls python3-pylsp shellcheck` mac: `brew install ninja openjdk@17 bat gopls ccls python3-pylsp shellcheck`
1. `curl -sS https://webi.sh/shfmt | sh`
1. `curl https://raw.githubusercontent.com/eruizc-dev/jdtls-launcher/master/install.sh | bash`
1. Install jdtls:
    1. `git clone https://github.com/eclipse/eclipse.jdt.ls.git ~/.local/eclipse.jdt.ls`
    1. `mvn -f ~/.local/eclipse.jdt.ls clean verify -DskipTests=true`
1. `git clone https://github.com/BSteffaniak/nvim.git ~/.config/nvim`
1. `git clone git@github.com:dgileadi/vscode-java-decompiler.git ~/.local/share/vscode-java-decompiler`
1. `~/.config/nvim/lls.sh`
1. `git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim`
1. Build neovim from sources:
   ```
   git clone --depth 1 https://github.com/neovim/neovim.git ~/.local/neovim-install
   cd ~/.local/neovim-install
   make CMAKE_BUILD_TYPE=RelWithDebInfo
   sudo make install
   ```
1. `nvim ~/.config/nvim/lua/bsteffaniak/packer.lua -c "luafile %" -c PackerSync`

References:

 * https://github.com/sharkdp/bat#installation

Todo:

 * https://www.erickpatrick.net/blog/adding-syntax-highlighting-to-fzf.vim-preview-window

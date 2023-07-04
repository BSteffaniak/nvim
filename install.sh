#!/bin/bash

# dependencies
npm i -g typescript-language-server prettier @fsouza/prettierd diagnostic-languageserver vscode-langservers-extracted bash-language-server write-good @johnnymorganz/stylua-bin
curl -sS https://webi.sh/shfmt | sh

# jdtls
git clone https://github.com/eclipse/eclipse.jdt.ls.git ~/.local/eclipse.jdt.ls
mvn -f ~/.local/eclipse.jdt.ls clean verify -DskipTests=true
git clone https://github.com/BSteffaniak/nvim.git ~/.config/nvim
git clone https://github.com/dgileadi/vscode-java-decompiler.git ~/.local/share/vscode-java-decompiler

~/.config/nvim/lls.sh

# neovim
git clone --depth 1 https://github.com/neovim/neovim.git ~/.local/neovim-install
cd ~/.local/neovim-install || exit 1
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install

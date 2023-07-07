#!/bin/bash

command_exists() {
    command -v "$1"
}

[[ -z $(command_exists "typescript-language-server") ]] && npm i -g typescript-language-server
[[ -z $(command_exists "prettier") ]] && npm i -g prettier
[[ -z $(command_exists "prettierd") ]] && npm i -g @fsouza/prettierd
[[ -z $(command_exists "diagnostic-languageserver") ]] && npm i -g diagnostic-languageserver
[[ -z $(command_exists "vscode-json-language-server") ]] && npm i -g vscode-langservers-extracted
[[ -z $(command_exists "bash-language-server") ]] && npm i -g bash-language-server
[[ -z $(command_exists "write-good") ]] && npm i -g write-good
[[ -z $(command_exists "stylua") ]] && npm i -g @johnnymorganz/stylua-bin
[[ -z $(command_exists "fixjson") ]] && npm i -g fixjson
[[ -z $(command_exists "shfmt") ]] && curl -sS https://webi.sh/shfmt | sh

if [[ ! -d ~/.local/eclipse.jdt.ls ]]; then
    git clone https://github.com/eclipse/eclipse.jdt.ls.git ~/.local/eclipse.jdt.ls
    mvn -f ~/.local/eclipse.jdt.ls clean verify -DskipTests=true
fi

if [[ ! -d ~/.config/nvim ]]; then
    git clone https://github.com/BSteffaniak/nvim.git ~/.config/nvim
fi

if [[ ! -d ~/.local/share/vscode-java-decompiler ]]; then
    git clone https://github.com/dgileadi/vscode-java-decompiler.git ~/.local/share/vscode-java-decompiler
fi

if [[ ! -d ~/.local/share/lua-language-server ]]; then
    git clone --depth 1 https://github.com/LuaLS/lua-language-server ~/.local/share/lua-language-server
    cd ~/.local/share/lua-language-server || exit 1
    ./make.sh
    echo '#!/usr/bin/env bash

    ~/.local/share/lua-language-server/bin/lua-language-server' >~/.local/bin/lua-language-server
    chmod +x ~/.local/bin/lua-language-server
fi

if [[ ! -d ~/.local/neovim-install ]]; then
    git clone --depth 1 https://github.com/neovim/neovim.git ~/.local/neovim-install
    cd ~/.local/neovim-install || exit 1
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
fi

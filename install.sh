#!/bin/bash

command_exists() {
    command -v "$1"
}

dependency_required() {
    echo "Dependency '$1' is required. Please install before running ./install.sh"
    exit 1
}

[[ -z $(command_exists "mvn") ]] && dependency_required "mvn"
[[ -z $(command_exists "git") ]] && dependency_required "git"

if [[ "$(uname)" == "Darwin" ]]; then
    [[ -z $(command_exists "ninja") ]] && brew install ninja
    [[ -z $(command_exists "bat") ]] && brew install bat
    [[ -z $(command_exists "gopls") ]] && brew install gopls
    [[ -z $(command_exists "pylsp") ]] && brew install pylsp
    [[ -z $(command_exists "shellcheck") ]] && brew install shellcheck
    [[ -z $(command_exists "rg") ]] && brew install ripgrep
else
    sudo apt-get install \
        make \
        cmake \
        unzip \
        gettext \
        g++ \
        ninja-build \
        openjdk-17-jdk \
        openjdk-17-jre \
        bat \
        gopls \
        python3-pylsp \
        shellcheck \
        ripgrep \
        ;
fi

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

if [[ ! -d ~/.local/java-debug ]]; then
    git clone --depth 1 https://github.com/microsoft/java-debug.git ~/.local/java-debug
    cd ~/.local/java-debug || exit 1
    ./mvnw clean install
fi

if [[ ! -d ~/.local/vscode-java-test ]]; then
    git clone --depth 1 https://github.com/microsoft/vscode-java-test.git ~/.local/vscode-java-test
    cd ~/.local/vscode-java-test || exit 1
    npm install
    npm run build-plugin
fi

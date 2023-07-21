#!/bin/bash

[[ "$1" == "update" ]] && update=true

command_exists() {
    command -v "$1"
}

clone_repo() {
    local repo_url="$1"
    local directory="$2"

    if [[ ! -d "$directory" ]]; then
        git clone --depth 1 "$repo_url" "$directory"
    elif [[ $update ]]; then
        git -C "$directory" remote update
        local local_rev
        local_rev=$(git -C "$directory" rev-parse @)
        local remote_rev
        remote_rev=$(git -C "$directory" rev-parse '@{u}')
        local base_rev
        base_rev=$(git -C "$directory" merge-base @ '@{u}')

        if [[ "$local_rev" = "$remote_rev" ]]; then
            echo "Already up-to-date"
            false
        elif [[ "$local_rev" = "$base_rev" ]]; then
            echo "Updating repo at $directory"
            git -C "$directory" pull
        elif [[ "$remote_rev" = "$base_rev" ]]; then
            echo "Need to push"
            false
        else
            echo "Diverged"
            false
        fi
    else
        false
    fi
}

dependency_required() {
    echo "Dependency '$1' is required. Please install before running ./install.sh"
    exit 1
}

[[ -z $(command_exists "mvn") ]] && dependency_required "mvn"
[[ -z $(command_exists "git") ]] && dependency_required "git"
[[ -z $(command_exists "curl") ]] && dependency_required "curl"
[[ -z $(command_exists "npm") ]] && dependency_required "npm"

if [[ "$(uname)" == "Darwin" ]]; then
    [[ -z $(command_exists "brew") ]] && dependency_required "brew"

    [[ $update || -z $(command_exists "ninja") ]] && brew install ninja
    [[ $update || -z $(command_exists "bat") ]] && brew install bat
    [[ $update || -z $(command_exists "gopls") ]] && brew install gopls
    [[ $update || -z $(command_exists "pylsp") ]] && brew install pylsp
    [[ $update || -z $(command_exists "shellcheck") ]] && brew install shellcheck
    [[ $update || -z $(command_exists "rg") ]] && brew install ripgrep
else
    [[ $update || -z $(command_exists "make") ]] && sudo apt-get install make
    [[ $update || -z $(command_exists "cmake") ]] && sudo apt-get install cmake
    [[ $update || -z $(command_exists "unzip") ]] && sudo apt-get install unzip
    [[ $update || -z $(command_exists "gettext") ]] && sudo apt-get install gettext
    [[ $update || -z $(command_exists "g++") ]] && sudo apt-get install g++
    [[ $update || -z $(command_exists "ninja") ]] && sudo apt-get install ninja-build
    [[ $update || -z $(command_exists "batcat") ]] && sudo apt-get install bat
    [[ $update || -z $(command_exists "gopls") ]] && sudo apt-get install gopls
    [[ $update || -z $(command_exists "pylsp") ]] && sudo apt-get install python3-pylsp
    [[ $update || -z $(command_exists "shellcheck") ]] && sudo apt-get install shellcheck
    [[ $update || -z $(command_exists "rg") ]] && sudo apt-get install ripgrep
fi

[[ $update || -z $(command_exists "typescript-language-server") ]] && npm i -g typescript-language-server
[[ $update || -z $(command_exists "prettier") ]] && npm i -g prettier
[[ $update || -z $(command_exists "prettierd") ]] && npm i -g @fsouza/prettierd
[[ $update || -z $(command_exists "diagnostic-languageserver") ]] && npm i -g diagnostic-languageserver
[[ $update || -z $(command_exists "vscode-json-language-server") ]] && npm i -g vscode-langservers-extracted
[[ $update || -z $(command_exists "bash-language-server") ]] && npm i -g bash-language-server
[[ $update || -z $(command_exists "write-good") ]] && npm i -g write-good
[[ $update || -z $(command_exists "stylua") ]] && npm i -g @johnnymorganz/stylua-bin
[[ $update || -z $(command_exists "fixjson") ]] && npm i -g fixjson
[[ $update || -z $(command_exists "shfmt") ]] && curl -sS https://webi.sh/shfmt | sh

if (clone_repo https://github.com/eclipse/eclipse.jdt.ls.git ~/.local/eclipse.jdt.ls); then
    mvn -f ~/.local/eclipse.jdt.ls clean verify -DskipTests=true
fi

clone_repo https://github.com/dgileadi/vscode-java-decompiler.git ~/.local/share/vscode-java-decompiler

if (clone_repo https://github.com/LuaLS/lua-language-server ~/.local/share/lua-language-server); then
    cd ~/.local/share/lua-language-server || exit 1
    ./make.sh
    echo '#!/usr/bin/env bash

    ~/.local/share/lua-language-server/bin/lua-language-server' >~/.local/bin/lua-language-server
    chmod +x ~/.local/bin/lua-language-server
fi

if (clone_repo https://github.com/neovim/neovim.git ~/.local/neovim-install); then
    cd ~/.local/neovim-install || exit 1
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
fi

if (clone_repo https://github.com/microsoft/java-debug.git ~/.local/java-debug); then
    cd ~/.local/java-debug || exit 1
    ./mvnw clean install
fi

if (clone_repo https://github.com/microsoft/vscode-java-test.git ~/.local/vscode-java-test); then
    cd ~/.local/vscode-java-test || exit 1
    npm install
    npm run build-plugin
fi

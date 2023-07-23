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

parse_args() {
    declare -n local_args_map="$1"
    declare -n local_args_list="$2"
    local skipped=0
    local setting_key
    for var in "$@"; do
        [[ $skipped -lt 2 ]] && {
            ((skipped++))
            continue
        }
        if [[ $var == --* ]]; then
            setting_key=${var:2}
        elif [[ $var == -* ]]; then
            setting_key=${var:1}
        elif [[ -z "$setting_key" ]]; then
            local_args_list+=("$var")
        else
            # shellcheck disable=SC2034
            local_args_map["$setting_key"]="$var"
            unset setting_key
        fi
    done
}

install_package() {
    declare -A args_map
    declare args_list

    parse_args args_map args_list "$@"

    [[ ${#args_list[@]} -gt 1 ]] && echo "Too many unnamed args passed to install_package" && exit 1

    local default_pkg=${args_list[0]}
    local apt=$default_pkg
    local pacman=$default_pkg
    local snap=$default_pkg
    local yum=$default_pkg

    for key in "${!args_map[@]}"; do
        case $key in
        apt)
            apt="${args_map[$key]}"
            ;;
        pacman)
            pacman="${args_map[$key]}"
            ;;
        snap)
            snap="${args_map[$key]}"
            ;;
        yum)
            yum="${args_map[$key]}"
            ;;
        *)
            echo "Invalid argument '$key'"
            exit 1
            ;;
        esac
    done

    if [[ -n $(command_exists "apt-get") && -n $(command_exists "sudo") ]]; then
        sudo apt-get install "$apt"
    elif [[ -n $(command_exists "apt-get") && -z $(command_exists "sudo") ]]; then
        apt-get install "$apt"
    elif [[ -n $(command_exists "pacman") ]]; then
        pacman --noconfirm -S "$pacman"
    elif [[ -n $(command_exists "snap") && -n $(command_exists "sudo") ]]; then
        sudo snap install "$snap"
    elif [[ -n $(command_exists "snap") && -z $(command_exists "sudo") ]]; then
        snap install "$snap"
    elif [[ -n $(command_exists "yum") && -n $(command_exists "sudo") ]]; then
        sudo yum install "$yum"
    elif [[ -n $(command_exists "yum") && -z $(command_exists "sudo") ]]; then
        yum install "$yum"
    else
        echo "Could not find package manager to install package '$1'"
        exit 1
    fi
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
    [[ $update || -z $(command_exists "make") ]] && install_package make
    [[ $update || -z $(command_exists "cmake") ]] && install_package cmake
    [[ $update || -z $(command_exists "unzip") ]] && install_package unzip
    [[ $update || -z $(command_exists "gettext") ]] && install_package gettext
    # Fedora does not install the static g++ libs with this, so a prerequisite might
    # be to run something like `sudo yum install libstdc++-static.x86_64`
    # https://github.com/numenta/nupic/issues/1901#issuecomment-97048452
    [[ $update || -z $(command_exists "g++") ]] && install_package g++ --pacman gcc
    [[ $update || -z $(command_exists "ninja") ]] && install_package ninja-build --pacman ninja
    [[ $update || -z $(command_exists "bat") && -z $(command_exists "batcat") ]] && install_package bat
    [[ $update || -z $(command_exists "gopls") ]] && install_package gopls --yum golang-x-tools-gopls
    [[ $update || -z $(command_exists "pylsp") ]] && install_package python3-pylsp --pacman python-lsp-server --snap pylsp --yum python-lsp-server
    [[ $update || -z $(command_exists "shellcheck") ]] && install_package shellcheck
    [[ $update || -z $(command_exists "rg") ]] && install_package ripgrep
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
    echo "Installing jdtls"
    mvn -f ~/.local/eclipse.jdt.ls clean verify -DskipTests=true
fi

clone_repo https://github.com/dgileadi/vscode-java-decompiler.git ~/.local/share/vscode-java-decompiler

if (clone_repo https://github.com/LuaLS/lua-language-server ~/.local/share/lua-language-server); then
    echo "Installing lua-language-server"
    cd ~/.local/share/lua-language-server || exit 1
    ./make.sh
    echo '#!/usr/bin/env bash

    ~/.local/share/lua-language-server/bin/lua-language-server' >~/.local/bin/lua-language-server
    chmod +x ~/.local/bin/lua-language-server
fi

if (clone_repo https://github.com/neovim/neovim.git ~/.local/neovim-install); then
    echo "Installing neovim"
    cd ~/.local/neovim-install || exit 1
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
fi

if (clone_repo https://github.com/microsoft/java-debug.git ~/.local/java-debug); then
    echo "Installing java-debug"
    cd ~/.local/java-debug || exit 1
    ./mvnw clean install
fi

if (clone_repo https://github.com/microsoft/vscode-java-test.git ~/.local/vscode-java-test); then
    echo "Installing vscode-java-test"
    cd ~/.local/vscode-java-test || exit 1
    npm install
    npm run build-plugin
fi

clone_repo https://github.com/FlatLang/vim-flat.git ~/.local/vim-flat

if [[ ! -f ~/.config/nvim/syntax/flat.vim ]]; then
    mkdir -p ~/.config/nvim/syntax/
    ln -s ~/.local/vim-flat/flat.vim ~/.config/nvim/syntax/flat.vim
fi

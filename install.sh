#!/usr/bin/env bash

command_exists() {
    command -v "$1"
}

SUDO=""

[[ -n $(command_exists "sudo") ]] && SUDO="sudo"

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
            echo "Already up-to-date at $directory"
            false
        elif [[ "$local_rev" = "$base_rev" ]]; then
            echo "Updating repo at $directory"
            git -C "$directory" pull
        elif [[ "$remote_rev" = "$base_rev" ]]; then
            echo "Need to push at $directory"
            false
        else
            echo "Diverged at $directory"
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
    declare -n local_args_keys="$1"
    declare -n local_args_values="$2"
    declare -n local_args_list="$3"
    local skipped=0
    local setting_key
    for var in "$@"; do
        [[ $skipped -lt 3 ]] && {
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
            local_args_keys+=("$setting_key")
            local_args_values+=("$var")
            unset setting_key
        fi
    done
}

install_package_internal() {
    local key=$1
    local value=$2

    case $key in
    npm)
        if [[ -n $(command_exists "npm") ]]; then
            npm i -g "$value"
            return
        fi
        ;;
    brew)
        if [[ -n $(command_exists "brew") ]]; then
            brew install "$value"
            return
        fi
        ;;
    apt)
        if [[ -n $(command_exists "apt-get") ]]; then
            $SUDO apt-get install "$value"
            return
        fi
        ;;
    pacman)
        if [[ -n $(command_exists "pacman") ]]; then
            pacman -S "$value"
            return
        fi
        ;;
    snap)
        if [[ -n $(command_exists "snap") ]]; then
            $SUDO snap install "$value"
            return
        fi
        ;;
    yum)
        if [[ -n $(command_exists "yum") ]]; then
            $SUDO yum install "$value"
            return
        fi
        ;;
    scoop)
        if [[ -n $(command_exists "scoop") ]]; then
            scoop install "$value"
            return
        fi
        ;;
    go)
        if [[ -n $(command_exists "go") ]]; then
            go install "$value"
            return
        fi
        ;;
    pip)
        if [[ -n $(command_exists "pip") ]]; then
            pip install "$value"
            return
        fi
        ;;
    winget)
        if [[ -n $(command_exists "winget") ]]; then
            winget install -e --id "$value"
            return
        fi
        ;;
    choco)
        if [[ -n $(command_exists "choco") ]]; then
            choco install "$value"
            return
        fi
        ;;
    *)
        echo "Invalid argument '$key'"
        exit 1
        ;;
    esac

    false
}

install_package() {
    declare pkg_args_keys
    declare pkg_args_values
    declare pkg_args_list

    parse_args pkg_args_keys pkg_args_values pkg_args_list "$@"

    [[ ${#pkg_args_list[@]} -gt 1 ]] && echo "Too many unnamed args passed to install_package" && exit 1

    for index in "${!pkg_args_keys[@]}"; do
        (install_package_internal "${pkg_args_keys[$index]}" "${pkg_args_values[$index]}") && return
    done

    if [[ ${#pkg_args_list[@]} -gt 0 ]]; then
        local default_pkg=${pkg_args_list[0]}

        (install_package_internal "npm" "$default_pkg") && return
        (install_package_internal "brew" "$default_pkg") && return
        (install_package_internal "apt" "$default_pkg") && return
        (install_package_internal "pacman" "$default_pkg") && return
        (install_package_internal "snap" "$default_pkg") && return
        (install_package_internal "yum" "$default_pkg") && return
        (install_package_internal "scoop" "$default_pkg") && return
        (install_package_internal "go" "$default_pkg") && return
        (install_package_internal "pip" "$default_pkg") && return
        (install_package_internal "winget" "$default_pkg") && return
        (install_package_internal "choco" "$default_pkg") && return
    fi
    echo "Could not find package manager to install package '$1'"
    exit 1
}

update_vscode_java_decompiler() {
    clone_repo https://github.com/dgileadi/vscode-java-decompiler.git ~/.local/share/vscode-java-decompiler
}

update_lls() {
    clone_repo https://github.com/LuaLS/lua-language-server ~/.local/share/lua-language-server
}

build_lls() {
    echo "Installing lua-language-server"
    cd ~/.local/share/lua-language-server || exit 1
    ./make.sh || exit 1
    echo '#!/usr/bin/env bash

    ~/.local/share/lua-language-server/bin/lua-language-server' >~/.local/bin/lua-language-server
    chmod +x ~/.local/bin/lua-language-server || exit 1
}

update_neovim() {
    clone_repo https://github.com/neovim/neovim.git ~/.local/neovim-install
}

clean_neovim() {
    echo "Cleaning neovim"
    cd ~/.local/neovim-install || exit 1
    $SUDO make clean || exit 1
}

build_neovim() {
    echo "Installing neovim"
    cd ~/.local/neovim-install || exit 1
    make CMAKE_BUILD_TYPE=RelWithDebInfo || exit 1
    $SUDO make install || exit 1
}

update_jdtls() {
    clone_repo https://github.com/eclipse/eclipse.jdt.ls.git ~/.local/eclipse.jdt.ls
}

build_jdtls() {
    echo "Installing jdtls"
    mvn -f ~/.local/eclipse.jdt.ls clean verify -DskipTests=true || exit 1
}

update_java_debug() {
    clone_repo https://github.com/microsoft/java-debug.git ~/.local/java-debug
}

build_java_debug() {
    echo "Installing java-debug"
    cd ~/.local/java-debug || exit 1
    ./mvnw clean install || exit 1
}

update_vscode_java_test() {
    clone_repo https://github.com/microsoft/vscode-java-test.git ~/.local/vscode-java-test
}

build_vscode_java_test() {
    echo "Installing vscode-java-test"
    cd ~/.local/vscode-java-test || exit 1
    npm install || exit 1
    npm run build-plugin || exit 1
}

update_vim_flat() {
    clone_repo https://github.com/FlatLang/vim-flat.git ~/.local/vim-flat
}

declare args_keys
declare args_values
declare args_list

parse_args args_keys args_values args_list "$@"

init() {
    local updated=false

    for arg in "${args_list[@]}"; do
        if [[ "$arg" == "update" ]]; then
            update=true
        elif $update; then
            case $arg in
            lls | lua-language-server)
                update_lls && build_lls
                ;;
            nvim | neovim)
                update_neovim && build_neovim
                ;;
            jdtls)
                update_jdtls && build_jdtls
                ;;
            java-debug)
                update_java_debug && build_java_debug
                ;;
            vscode-java-test)
                update_vscode_java_test && build_vscode_java_test
                ;;
            *)
                echo "Invalid argument '$arg'"
                exit 1
                ;;
            esac
            updated=true
        else
            echo "Invalid argument '$arg'"
            exit 1
        fi
    done

    $updated && exit 0

    for index in "${!args_keys[@]}"; do
        local key="${args_keys[$index]}"
        local value="${args_values[$index]}"
        case $key in
        clean)
            case $value in
            nvim | neovim)
                clean_neovim
                ;;
            *)
                echo "Invalid argument '$value'"
                exit 1
                ;;
            esac
            exit 0
            ;;
        build)
            case $value in
            lls | lua-language-server)
                build_lls
                ;;
            nvim | neovim)
                build_neovim
                ;;
            jdtls)
                build_jdtls
                ;;
            java-debug)
                build_java_debug
                ;;
            vscode-java-test)
                build_vscode_java_test
                ;;
            *)
                echo "Invalid argument '$value'"
                exit 1
                ;;
            esac
            exit 0
            ;;
        *)
            echo "Invalid argument '$key'"
            exit 1
            ;;
        esac
    done
}

init "$@"

[[ -z $(command_exists "mvn") ]] && dependency_required "mvn"
[[ -z $(command_exists "git") ]] && dependency_required "git"
[[ -z $(command_exists "curl") ]] && dependency_required "curl"
[[ -z $(command_exists "npm") ]] && dependency_required "npm"

[[ $update || -z $(command_exists "make") ]] && install_package make --apt make --scoop make --winget GnuWin32.Make
[[ $update || -z $(command_exists "gettext") ]] && install_package gettext
[[ $update || -z $(command_exists "cmake") ]] && install_package cmake --apt cmake --scoop cmake --pip cmake --winget Kitware.CMake
[[ $update || -z $(command_exists "unzip") ]] && install_package unzip
[[ $update || -z $(command_exists "gettext") ]] && install_package gettext
# Fedora does not install the static g++ libs with this, so a prerequisite might
# be to run something like `sudo yum install libstdc++-static.x86_64`
# https://github.com/numenta/nupic/issues/1901#issuecomment-97048452
[[ $update || -z $(command_exists "g++") && -z $(command_exists "gcc") ]] && install_package g++ --apt g++ --pacman gcc --scoop gcc
[[ $update || -z $(command_exists "ninja") ]] && install_package ninja-build --brew ninja --apt ninja-build --pacman ninja --scoop ninja --winget Ninja-build.Ninja
[[ $update || -z $(command_exists "bat") && -z $(command_exists "batcat") ]] && install_package bat --brew bat
[[ $update || -z $(command_exists "gopls") ]] && install_package gopls --brew gopls --apt gopls --yum golang-x-tools-gopls --go "golang.org/x/tools/gopls@latest"
[[ $update || -z $(command_exists "pylsp") ]] && install_package python3-pylsp --brew pylsp --apt python3-pylsp --pacman python-lsp-server --snap pylsp --yum python-lsp-server --pip python-lsp-server
[[ $update || -z $(command_exists "shellcheck") ]] && install_package shellcheck --brew shellcheck
[[ $update || -z $(command_exists "rg") ]] && install_package ripgrep --brew ripgrep
[[ $update || -z $(command_exists "tsc") ]] && install_package --npm typescript
[[ $update || -z $(command_exists "typescript-language-server") ]] && install_package --npm typescript-language-server
[[ $update || -z $(command_exists "prettier") ]] && install_package --npm prettier
[[ $update || -z $(command_exists "prettierd") ]] && install_package --npm @fsouza/prettierd
[[ $update || -z $(command_exists "diagnostic-languageserver") ]] && install_package --npm diagnostic-languageserver
[[ $update || -z $(command_exists "vscode-json-language-server") ]] && install_package --npm vscode-langservers-extracted
[[ $update || -z $(command_exists "bash-language-server") ]] && install_package --npm bash-language-server
[[ $update || -z $(command_exists "write-good") ]] && install_package --npm write-good
[[ $update || -z $(command_exists "stylua") ]] && install_package --npm @johnnymorganz/stylua-bin
[[ $update || -z $(command_exists "fixjson") ]] && install_package --npm fixjson
[[ $update || -z $(command_exists "shfmt") ]] && curl -sS https://webi.sh/shfmt | sh
[[ $update || -z $(command_exists "eslint_d") ]] && install_package --npm eslint_d
[[ $update || -z $(command_exists "isort") ]] && install_package --pip isort
[[ $update || -z $(command_exists "black") ]] && install_package --pip black
[[ $update || -z $(command_exists "pyright") ]] && install_package --pip pyright

if (update_jdtls); then
    build_jdtls
fi

update_vscode_java_decompiler

if (update_lls); then
    build_lls
fi

if (update_neovim); then
    build_neovim
fi

if (update_java_debug); then
    build_java_debug
fi

if (update_vscode_java_test); then
    build_vscode_java_test
fi

update_vim_flat

if [[ ! -f ~/.config/nvim/syntax/flat.vim ]]; then
    mkdir -p ~/.config/nvim/syntax/
    ln -s ~/.local/vim-flat/flat.vim ~/.config/nvim/syntax/flat.vim
fi

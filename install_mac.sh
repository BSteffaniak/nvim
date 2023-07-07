#!/bin/bash

command_exists() {
    command -v "$1"
}

[[ -z $(command_exists "ninja") ]] && brew install ninja
[[ -z $(command_exists "bat") ]] && brew install bat
[[ -z $(command_exists "gopls") ]] && brew install gopls
[[ -z $(command_exists "pylsp") ]] && brew install pylsp
[[ -z $(command_exists "spellcheck") ]] && brew install spellcheck
[[ -z $(command_exists "rg") ]] && brew install ripgrep

./install.sh

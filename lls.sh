git clone --depth 1 https://github.com/LuaLS/lua-language-server ~/.local/share/lua-language-server
cd ~/.local/share/lua-language-server || exit 1
./make.sh
echo '#!/usr/bin/env bash

~/.local/share/lua-language-server/bin/lua-language-server' >~/.local/bin/lua-language-server
chmod +x ~/.local/bin/lua-language-server

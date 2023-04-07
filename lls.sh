git clone --depth 1 https://github.com/LuaLS/lua-language-server ~/.local/share/lua-language-server
cd ~/.local/share/lua-language-server
./make.sh
ln -s $HOME/.local/share/lua-language-server/bin/lua-language-server $HOME/.local/bin/lua-language-server
chmod +x ~/.local/bin/lua-language-server

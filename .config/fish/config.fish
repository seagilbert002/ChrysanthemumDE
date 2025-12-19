# ~/.config/fish/config.fish

set -gx EDITOR nvim
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state

fish_add_path ~/bin ~/scripts ~/.local/bin ~/go/bin

hyfetch

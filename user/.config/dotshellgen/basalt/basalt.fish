for dir in "$HOME/.dotfiles/.usr/bin"
    if --exists "$dir/basalt"
    basalt global init fish | source
    # set path=("$XDG_DATA_HOME/basalt/source/pkg/bin" $path)
    break
end

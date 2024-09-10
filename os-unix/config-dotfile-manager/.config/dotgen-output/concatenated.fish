# basalt.fish
for dir in "$HOME/.dotfiles/.data/bin"
    if --exists "$dir/basalt"
    basalt global init fish | source
    # set path=("$XDG_DATA_HOME/basalt/source/pkg/bin" $path)
    break
end

# direnv.fish
if type -p direnv
	direnv hook fish | source
end

# concatenated.fish
# basalt.fish
for dir in "$HOME/.dotfiles/.data/bin"
    if --exists "$dir/basalt"
    basalt global init fish | source
    # set path=("$XDG_DATA_HOME/basalt/source/pkg/bin" $path)
    break
end

# direnv.fish
if type -p direnv
	direnv hook fish | source
end


# zoxide.fish
if type -p zoxide
	zoxide init fish | source
end


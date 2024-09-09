# shellcheck shell=bash

install() {
	printf '%s\n' 'NOT IMPLEMENTED' # TODO
}

uninstall() {
	printf '%s\n' 'NOT IMPLEMENTED' # TODO
}

test() {
	command -v alacritty >/dev/null 2>&1
}

switch() {
	printf '%s' "[Desktop Entry]
Type = Application
Name = TERMINAL: Alacritty
GenericName=Terminal emulator
Comment = Use a terminal emulator
TryExec = alacritty
Exec = alacritty
Icon = choose-fox
Categories = System;TerminalEmulator;
" > ~/.dotfiles/.home/xdg_data_dir/applications/choose-terminal-emulator.desktop
}

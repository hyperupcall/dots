# shellcheck shell=bash

install() {
	printf '%s\n' 'NOT IMPLEMENTED' # TODO
}

uninstall() {
	printf '%s\n' 'NOT IMPLEMENTED' # TODO
}

test() {
	command -v tilix >/dev/null 2>&1
}

switch() {
	printf '%s' "[Desktop Entry]
Type = Application
Name = TERMINAL: Tilix
GenericName=Terminal emulator
Comment = Use a terminal emulator
TryExec = tilix
Exec = tilix
Icon = choose-fox
Categories = System;TerminalEmulator;
" > ~/.dotfiles/.home/xdg_data_dir/applications/choose-terminal-emulator.desktop
}

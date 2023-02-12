# shellcheck shell=bash

install() {
	printf '%s\n' 'NOT IMPLEMENTED' # TODO
}

uninstall() {
	printf '%s\n' 'NOT IMPLEMENTED' # TODO
}

test() {
	command -v terminator >/dev/null 2>&1
}

switch() {
	printf '%s' "[Desktop Entry]
Type = Application
Name = TERMINAL: Terminator
GenericName=Terminal emulator
Comment = Use a terminal emulator
TryExec = terminator
Exec = terminator
Icon = choose-fox
Categories = System;TerminalEmulator;
" > ~/.dotfiles/.home/xdg_data_dir/applications/choose-terminal-emulator.desktop
}

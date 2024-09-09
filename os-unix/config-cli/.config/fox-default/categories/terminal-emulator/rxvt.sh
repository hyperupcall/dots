# shellcheck shell=bash

install() {
	printf '%s\n' 'NOT IMPLEMENTED' # TODO
}

uninstall() {
	printf '%s\n' 'NOT IMPLEMENTED' # TODO
}

test() {
	command -v rxvt >/dev/null 2>&1
}

switch() {
	printf '%s' "[Desktop Entry]
Type = Application
Name = TERMINAL: rxvt
GenericName=Terminal emulator
Comment = Use a terminal emulator
TryExec = rxvt
Exec = rxvt
Icon = choose-fox
Categories = System;TerminalEmulator;
" > ~/.dotfiles/.home/xdg_data_dir/applications/choose-terminal-emulator.desktop
}

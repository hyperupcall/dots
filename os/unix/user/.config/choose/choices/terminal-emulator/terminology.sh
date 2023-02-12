# shellcheck shell=bash

install() {
	printf '%s\n' 'NOT IMPLEMENTED' # TODO
}

uninstall() {
	printf '%s\n' 'NOT IMPLEMENTED' # TODO
}

test() {
	command -v terminology >/dev/null 2>&1
}

switch() {
	printf '%s' "[Desktop Entry]
Type = Application
Name = TERMINAL: Terminology
GenericName=Terminal emulator
Comment = Use a terminal emulator
TryExec = terminology
Exec = terminology
Icon = choose-fox
Categories = System;TerminalEmulator;
" > ~/.dotfiles/.home/xdg_data_dir/applications/choose-terminal-emulator.desktop
}

#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'Perl' "$@"
}

install.any() {
	# https://github.com/regnarg/urxvt-config-reload
	cpan -i App::cpanminus

	# cpan Loading internal logger. Log::Log4perl recommended for better logging
	cpanm Log::Log4perl

	pkgs=(AnyEvent Linux::FD common::sense)
	cpanm "${pkgs[@]}"
}

util.is_executing_as_script && main "$@"

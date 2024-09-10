#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	helper.setup 'LaTeX (Tex Live)' "$@"
}

install.debian() {
	util.update_system
	sudo apt-get -y install texlive texlive-latex-base texlive-latex-recommended texlive-latex-extra texlive-extra-utils texlive-fonts-recommended texlive-fonts-extra texlive-bibtex-extra texlive-lang-english texlive-xetex latexmk
}

main "$@"

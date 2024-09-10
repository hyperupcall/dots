#!/usr/bin/env bash

source ~/.dotfiles/os-unix/data/source.sh

main() {
	borg create --show-version --show-rc --verbose --stats --progress /storage/vault/rodinia/Backups/dropbox_dir::'backup-{now}' ~/Dropbox/KnowledgeQuasipanacea/
}

main "$@"

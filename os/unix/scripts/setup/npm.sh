#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	helper.setup 'npm dependencies' "$@"
}

install.any() {
	npm i -g yarn pnpm
	yarn global add pnpm
	yarn global add diff-so-fancy
	yarn global add npm-check-updates
	yarn global add graphqurl
	yarn global add http-server
}

main "$@"

#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install Firefox Extensions?'; then
		helper.setup "$@"
	fi
}

install.any() {
	(
		local temp_dir=
		temp_dir=$(mktemp -d)
		cd "$temp_dir"

		util.get_latest_github_tag 'gorhill/uBlock'
		local latest_tag="$REPLY"
		util.install "https://github.com/gorhill/uBlock/releases/download/$latest_tag/uBlock0_$latest_tag.firefox.signed.xpi"
		read -rp 'Press ENTER to continue...'

		util.get_latest_github_tag 'ajayyy/SponsorBlock'
		local latest_tag="$REPLY"
		util.install "https://github.com/ajayyy/SponsorBlock/releases/download/$latest_tag/FirefoxSignedInstaller.xpi"
		read -rp 'Press ENTER to continue...'

		util.get_latest_github_tag 'violentmonkey/violentmonkey'
		local latest_tag="$REPLY"
		util.install "https://github.com/violentmonkey/violentmonkey/releases/download/$latest_tag/violentmonkey-${latest_tag#v}.xpi"
		read -rp 'Press ENTER to continue...'
	)
}

util.install() {
	local url="$1"

	rm -f './extension.xpi'
	util.req -o './extension.xpi' "$url"
	firefox -install -extension ./extension.xpi
}

main "$@"

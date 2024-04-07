#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	if util.confirm 'Install Browserpass?'; then
		helper.setup "$@"
	fi
}

install.any() {
	util.get_latest_github_tag 'browserpass/browserpass-native'
	local version="$REPLY"
	local system='linux64'
	local install_dir='/usr/local'
	local app_id='com.github.browserpass.native.json'

	core.print_info "Installing browserpass-native version '$version'"

	local url="https://github.com/browserpass/browserpass-native/releases/download/$version/browserpass-$system-$version.tar.gz"

	util.cd_temp

	util.req -o ./browserpass.tar.gz "$url"
	tar xf ./browserpass.tar.gz
	cd "./browserpass-linux64-$version"

	util.run make BIN="browserpass-$system" PREFIX="$install_dir" configure
	util.run sudo make BIN="browserpass-$system" PREFIX="$install_dir" install

	# Symlink messaging host definition
	local dir=
	for dir in \
		"$XDG_CONFIG_HOME"/{BraveSoftware/Brave-Browser{,-Beta,-Nightly},vivaldi{,-snapshot},microsoft-edge{,-beta,-dev},google-chrome{,-beta,-unstable},opera{,-beta,-developer},sidekick,wavebox}/
	do
		# local browser_dir="${f%/*}"
		# browser_dir=${browser_dir%/*}

		if [ -d "$dir" ]; then
			mkdir -p "$dir/NativeMessagingHosts"
			ln -sfv  "$install_dir/lib/browserpass/hosts/chromium/$app_id" "$dir/NativeMessagingHosts/$app_id"
			
			mkdir -p "$dir/policies/managed"
			ln -sfv "$install_dir/lib/browserpass/policies/chromium/$app_id" "$dir/policies/managed/$app_id"
		fi
	done

	# # Firefox
	mkdir -p "${HOME}/.mozilla/native-messaging-hosts"
	ln -sfv "$install_dir/lib/browserpass/hosts/firefox/$app_id" "${HOME}/.mozilla/native-messaging-hosts/$app_id"

	# browserpass-extension
	core.print_warn "Not installing browserpass-extension, only the native client"
}

main "$@"

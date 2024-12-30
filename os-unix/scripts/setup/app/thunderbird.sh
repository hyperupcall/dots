#!/usr/bin/env zsh

source ~/.dotfiles/os-unix/data/source.sh

main() {
	cd ~/.dotfiles/.data
	if [ ! -d './thunderbird' ]; then
		core.print_info 'Downloading Thunderbird...'
		local download_url=
		download_url=$(
			curl -sK "$CURL_CONFIG" 'https://www.thunderbird.net' \
				| sed -nE 's|.*(https://download\.mozilla\.org/\?product=thunderbird-[-.0-9]+-SSL&os=linux64&lang=[[:alpha:]-]+).*|\1|p' \
				| head -1
		)
		curl -K "$CURL_CONFIG" -# -o ./thunderbird.tar.bz "$download_url"
		rm -f ./thunderbird
		core.print_info 'Extracting Thunderbird...'
		tar xf ./thunderbird.tar.bz
		rm -f ./thunderbird.tar.bz
	fi
	ln -sf ~/.dotfiles/.data/thunderbird/thunderbird ~/.local/bin/thunderbird
	ln -sf ~/.dotfiles/.data/thunderbird/chrome/icons/default/default128.png ~/.local/share/icons/hicolor/128x128/apps/thunderbird.png
	ln -sf ~/.dotfiles/.data/thunderbird/chrome/icons/default/default64.png ~/.local/share/icons/hicolor/64x64/apps/thunderbird.png
	ln -sf ~/.dotfiles/.data/thunderbird/chrome/icons/default/default46.png ~/.local/share/icons/hicolor/48x48/apps/thunderbird.png
	xdg-desktop-menu forceupdate

cat <<EOF > ~/.local/share/applications/thunderbird.desktop
[Desktop Entry]
Encoding=UTF-8
Name=Thunderbird Mail
Comment=Send and receive mail with Thunderbird
GenericName=Mail Client
Keywords=Email;E-mail;Newsgroup;Feed;RSS
Exec=thunderbird %u
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=thunderbird
Categories=Application;Network;Email;
MimeType=x-scheme-handler/mailto;application/x-xpinstall;x-scheme-handler/webcal;x-scheme-handler/mid;message/rfc822;
StartupNotify=true
Actions=Compose;Contacts

[Desktop Action Compose]
Name=Compose New Message
Exec=thunderbird -compose
OnlyShowIn=Messaging Menu;Unity;

[Desktop Action Contacts]
Name=Contacts
Exec=thunderbird -addressbook
OnlyShowIn=Messaging Menu;Unity;
EOF

}

util.is_executing_as_script && main "$@"

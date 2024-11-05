#!/usr/bin/env zsh

source ~/.dotfiles/os-unix/data/source.sh

main() {
	local download_url=
	download_url=$(
		curl -K "$CURL_CONFIG" 'https://www.thunderbird.net' \
			| sed -nE 's|.*(https://download\.mozilla\.org/\?product=thunderbird-[-.0-9]+-SSL&os=linux64&lang=[[:alpha:]-]+).*|\1|p' \
			| head -1
	)
	rm -f ./thunderbird.tar.bz
	curl -K "$CURL_CONFIG" --create-dirs --output-dir ~/.dotfiles/.data/tarballs -o ./thunderbird.tar.bz "$download_url"
	rm -rf ./thunderbird
	tar xf ./thunderbird.tar.bz
	rm -f ./thunderbird.tar.bz

cat <<EOF
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

main "$@"

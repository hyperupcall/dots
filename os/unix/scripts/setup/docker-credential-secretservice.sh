#!/usr/bin/env bash

source "${0%/*}/../source.sh"

main() {
	helper.setup 'docker secretservice credential store version v0.6.4' "$@"
}

install.any() {
	local version='v0.6.4'

	(
		local temp_dir=
		temp_dir=$(mktemp -d)
		cd "$temp_dir"

		curl -o 'docker-credential-secretservice.tar.gz' "https://github.com/docker/docker-credential-helpers/releases/download/$version/docker-credential-secretservice-$version-amd64.tar.gz"
		tar xf 'docker-credential-secretservice.tar.gz'
		mv './docker-credential-secretservice' "$HOME/bin"
	)

	python -c "import json
import os
from io import StringIO
from pathlib import Path

file = Path(os.environ['XDG_CONFIG_HOME']) / 'docker' / 'config.json'
obj = json.load(StringIO(file.read_text()))
obj['credsStore'] = 'secretservice'
file.write_text(json.dumps(obj, indent='\t'))"
}

main "$@"

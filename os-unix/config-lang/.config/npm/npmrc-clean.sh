#!/usr/bin/env sh

# shellcheck disable=SC2164
dir=$(dirname "$(cd -- "$(dirname "$0")"; pwd -P)/$(basename "$0")")
grep -v "authToken" "$dir/npmrc"

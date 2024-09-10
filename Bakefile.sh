# shellcheck shell=bash

# config: big-print=off
task.init() {
	git config --local filter.npmrc-clean.clean './os-unix/config-lang/.config/npm/npmrc-clean.sh'
	git config --local filter.slack-term-config-clean.clean './os-unix/config-application/.config/slack-term/slack-term-config-clean.sh'
	git config --local filter.oscrc-clean.clean './os-unix/config-tools/.config/osc/oscrc-clean.sh'
}

task.build() {
	cd "./os-unix/config-shell/.config/X11/resources" || exit
	printf '%s\n' "! GENERATERD BY 'bake build'" > uxterm.Xresources
	sed 's/XTerm/UXTerm/g' xterm.Xresources >> uxterm.Xresources
}

task.lint() {
	yamllint -c ./.yamllint.yaml .
}

task.test() {
	(cd "./os-unix/config-shell/.config/shell/modules/common" && bats -p .)
	~/scripts/lint/lint-scripts.sh
}

task.commit() {
	git commit -m "update: $(date '+%B %d, %Y (%H:%M)')" "$@"
}

#!/usr/bin/env python3
import re
import os
import argparse
from pathlib import Path
from typing import Callable

# This file checks Bash and Shell scripts for violations not found with
# shellcheck or existing methods. You can use it in several ways:
#
# Lint all .bash, .sh, .bats files along with 'bin/asdf' and print out violations:
# $ lint-scripts.py
#
# The former, but also fix all violations. This must be ran until there
# are zero violations since any line can have more than one violation:
# $ lint-scripts.py --fix
#
# Lint a particular file:
# $ lint-scripts.py ./lib/functions/installs.bash
#
# Check to ensure all regular expressions are working as intended:
# $ lint-scripts.py --internal-test-regex

# TODO: there needs to be a main/install."" for every single setup/* script

Rule = dict[str, any]

class c:
	RED = '\033[91m'
	GREEN = '\033[92m'
	YELLOW = '\033[93m'
	BLUE = '\033[94m'
	MAGENTA = '\033[95m'
	CYAN = '\033[96m'
	RESET = '\033[0m'
	BOLD = '\033[1m'
	UNDERLINE = '\033[4m'
	LINK: Callable[[str, str], str] = lambda href, text: f'\033]8;;{href}\a{text}\033]8;;\a'

def utilGetStrs(line: any, m: any):
	return (
		line[0:m.start('match')],
		line[m.start('match'):m.end('match')],
		line[m.end('match'):]
	)

def lintfile(file: Path, rules: list[Rule], options: dict[str, any]):
	content_arr = file.read_text().split('\n')

	for line_i, line in enumerate(content_arr):
		if 'lint-ignore' in line:
			m = re.search('lint-ignore:([\\w-]+)', line)
			if m is None:
				continue

			rule_id = m.group(1)
			found_rule = False
			for rule in rules:
				if rule['name'] == rule_id:
					found_rule = True

			if found_rule:
				continue
			else:
				print(f'{c.YELLOW}Warning:{c.RESET} Rule "{rule_id}" referenced in lint-ignore, but was not found')

		if re.search('^\\s*#', line):
			continue

		for rule in rules:
			should_run = False
			if 'sh' in rule['fileTypes']:
				if file.name.endswith('.sh') or str(file.absolute()).endswith('bin/asdf'):
					should_run = True
			if 'bash' in rule['fileTypes']:
				if file.name.endswith('.bash') or file.name.endswith('.bats'):
					should_run = True

			if options['verbose']:
				print(f'{str(file)}: {should_run}')

			if not should_run:
				continue

			m = re.search(rule['regex'], line)
			if m is not None and m.group('match') is not None:
				dir = os.path.relpath(file.resolve(), Path.cwd())
				prestr = line[0:m.start('match')]
				midstr = line[m.start('match'):m.end('match')]
				poststr = line[m.end('match'):]

				if options['fix'] and rule['fixerFn'] is not None:
					fixed_line = rule['fixerFn'](line, m)
					newmidstr = fixed_line[:-len(poststr)][len(prestr):]
					content_arr[line_i] = fixed_line

				print(f'{c.CYAN}{dir}{c.RESET}:{line_i + 1}')
				print(f'{c.MAGENTA}{rule["name"]}{c.RESET}: {rule["reason"]}')
				print(f'{prestr}{c.RED}{midstr}{c.RESET}{poststr}')
				if options['fix'] and rule['fixerFn'] is not None:
					print(f'{prestr}{c.GREEN}{newmidstr}{c.RESET}{poststr}')
				print()

				rule['found'] += 1

	if options['fix']:
		file.write_text('\n'.join(content_arr))

def main():
	rules: list[Rule] = []

	# Before: apt install
	# After: apt-get install
	def aptUseAptGet(line: str, m: any) -> str:
		prestr, _, poststr = utilGetStrs(line, m)

		return f'{prestr}apt-get {poststr}'

	rules.append({
		'name': 'apt-use-apt-get',
		'regex': '(?P<match>apt )',
		'reason': 'Use apt-get',
		'fileTypes': ['bash', 'sh'],
		'fixerFn': aptUseAptGet,
		'testPositiveMatches': [
			'apt install',
			'apt update'
		],
		'testNegativeMatches': [
			'apt-get install'
		],
	})

	# Before: apt-get install
	# After: apt-get -y install
	def aptMustHaveY(line: str, m: any) -> str:
		prestr, _, poststr = utilGetStrs(line, m)

		subcmd = m.group('subcommand')
		return f'{prestr}apt-get {subcmd} -y {poststr}'

	rules.append({
		'name': 'apt-must-have-y',
		'regex': '(?P<match>apt-get (?P<subcommand>install|update|upgrade|remove)(?! -y))',
		'reason': 'To make sure it is automated',
		'fileTypes': ['bash', 'sh'],
		'fixerFn': aptMustHaveY,
		'testPositiveMatches': [
			'apt-get install'
		],
		'testNegativeMatches': [
			'apt-get install -y'
		],
	})

	# Before: add-apt-repository install
	# After: add-apt-repository -y install
	def addAptRepositoryMustHaveY(line: str, m: any) -> str:
		prestr, _, poststr = utilGetStrs(line, m)

		subcmd = m.group('subcommand')
		return f'{prestr}add-apt-repository -y {poststr}'

	rules.append({
		'name': 'apt-must-have-y',
		'regex': '(?P<match>add-apt-repository(?! -y))',
		'reason': 'To make sure it is automated',
		'fileTypes': ['bash', 'sh'],
		'fixerFn': addAptRepositoryMustHaveY,
		'testPositiveMatches': [
			'add-apt-repository'
		],
		'testNegativeMatches': [
			'add-apt-repository -y'
		],
	})

	# Before: dnf install
	# After: dnf install -y
	def dnfMustHaveY(line: str, m: any) -> str:
		prestr, _, poststr = utilGetStrs(line, m)

		subcmd = m.group('subcommand')
		return f'{prestr}dnf {subcmd} -y {poststr}'

	rules.append({
		'name': 'dnf-must-have-y',
		'regex': '(?P<match>dnf (?P<subcommand>install|update|upgrade|remove)(?! -y))',
		'reason': 'To make sure it is automated',
		'fileTypes': ['bash', 'sh'],
		'fixerFn': dnfMustHaveY,
		'testPositiveMatches': [
			'dnf install'
		],
		'testNegativeMatches': [
			'dnf install -y'
		],
	})

	# Before: zypper install
	# After: zypper install -y
	def zypperMustHaveY(line: str, m: any) -> str:
		prestr, _, poststr = utilGetStrs(line, m)

		subcmd = m.group('subcommand')
		return f'{prestr}zypper {subcmd} -y {poststr}'

	rules.append({
		'name': 'zypper-must-have-y',
		'regex': '(?P<match>zypper (?P<subcommand>install|update|upgrade|remove)(?! -y))',
		'reason': 'To make sure it is automated',
		'fileTypes': ['bash', 'sh'],
		'fixerFn': zypperMustHaveY,
		'testPositiveMatches': [
			'zypper install'
		],
		'testNegativeMatches': [
			'zypper install -y'
		],
	})

	# Before: flatpak install
	# After: flatpak install -y
	def flatpakMustHaveY(line: str, m: any) -> str:
		prestr, _, poststr = utilGetStrs(line, m)

		subcmd = m.group('subcommand')
		return f'{prestr}flatpak {subcmd} -y {poststr}'

	rules.append({
		'name': 'flatpak-must-have-y',
		'regex': '(?P<match>flatpak (?P<subcommand>install|update|uninstall)(?! -y))',
		'reason': 'To make sure it is automated',
		'fileTypes': ['bash', 'sh'],
		'fixerFn': flatpakMustHaveY,
		'testPositiveMatches': [
			'flatpak install'
		],
		'testNegativeMatches': [
			'flatpak install -y'
		],
	})

	# Before: pacman -S
	# After: pacman -Syu --noconfirm
	def pacmanMustNoConfirm(line: str, m: any) -> str:
		prestr, _, poststr = utilGetStrs(line, m)

		return f'{prestr}pacman -Syu --noconfirm{poststr}'

	rules.append({
		'name': 'pacman-must-noconfirm',
		'regex': '(?P<match>pacman -S(?!yy)(?!yu --noconfirm)(?: --noconfirm)?)',
		'reason': 'To make sure it is automated',
		'fileTypes': ['bash', 'sh'],
		'fixerFn': pacmanMustNoConfirm,
		'testPositiveMatches': [
			'pacman -S pkg',
			'sudo pacman -S pkg'
		],
		'testNegativeMatches': [
			'pacman -Q'
		],
	})

	# Before: pkcon
	# After: pkcon -y
	def pkconMustYes(line: str, m: any) -> str:
		prestr, _, poststr = utilGetStrs(line, m)

		return f'{prestr}pkcon -y {poststr}'

	rules.append({
		'name': 'pkcon-must-yes',
		'regex': '(?P<match>pkcon (?!-y))',
		'reason': 'To make sure it is automated',
		'fileTypes': ['bash', 'sh'],
		'fixerFn': pkconMustYes,
		'testPositiveMatches': [
			'pkcon install git',
			'sudo pkcon install git'
		],
		'testNegativeMatches': [
			'pkcon -y'
		],
	})

	# Before: sudo yay -S
	# After: yay -S
	def yayNoSudo(line: str, m: any) -> str:
		prestr, _, poststr = utilGetStrs(line, m)

		return f'{prestr}yay {poststr}'

	rules.append({
		'name': 'yay-no-sudo',
		'regex': '(?P<match>(?<=sudo )yay )',
		'reason': 'yay should not be ran with sudo',
		'fileTypes': ['bash', 'sh'],
		'fixerFn': yayNoSudo,
		'testPositiveMatches': [
			'sudo yay -S pkg'
		],
		'testNegativeMatches': [
			'yay -S pkg'
		],
	})

	# Before: helper.setup
	# After: N/A
	# rules.append({
	# 	'name': 'helper-setup-assert-arguments',
	# 	'regex': '(?P<match>helper\\.setup(?! \'.+?\' "\\$@")(?!\\(\\)))',
	# 	'reason': 'Add required arguments',
	# 	'fileTypes': ['bash', 'sh'],
	# 	'fixerFn': None,
	# 	'testPositiveMatches': [
	# 		'helper.setup',
	# 		'helper.setup "value" "$@"'
	# 	],
	# 	'testNegativeMatches': [
	# 		'helper.setup \'param\' "$@"'
	# 	],
	# })

	# Before: No banned commands
	# After: N/A
	rules.append({
		'name': 'no-banned-commands',
		'regex': '(?P<match>yum|snap) ',
		'reason': 'Function must exist',
		'fileTypes': ['bash', 'sh'],
		'fixerFn': None,
		'testPositiveMatches': [
			'yum install libtool',
		],
		'testNegativeMatches': [
			'apt-get install libtool',
		],
	})

	# Before: No git clone
	# After: N/A
	rules.append({
		'name': 'no-git-clone',
		'regex': '(?P<match>git .*?clone) ',
		'reason': 'Use util.clone instead exist',
		'fileTypes': ['bash', 'sh'],
		'fixerFn': None,
		'testPositiveMatches': [
			'git clone https://',
			'git -c key=value clone https://'
		],
		'testNegativeMatches': [
			'util.clone ~/ https://',
		],
	})

	# Before: curl
	# After: curl
	def curlMustHaveArgs(line: str, m: any) -> str:
		prestr, _, poststr = utilGetStrs(line, m)

		subcmd = m.group('subcommand')
		return f'{prestr}curl {subcmd} -K "$CURL_CONFIG" {poststr}'

	rules.append({
		'name': 'curl-must-have-args',
		'regex': '(?P<match>curl (?!-K "\\$CURL_CONFIG"))',
		'reason': 'To ensure curl has the best arguments',
		'fileTypes': ['bash', 'sh'],
		'fixerFn': curlMustHaveArgs,
		'testPositiveMatches': [
			'curl | sh'
		],
		'testNegativeMatches': [
			'curl -K "$CURL_CONFIG" | sh'
		],
	})

	# Before: install.random
	# After: N/A
	rules.append({
		'name': 'install-check-function-exists',
		'regex': '(?P<match>install\\.(?!arch|debian|any|cachyos|ubuntu|opensuse|fedora|pop|manjaro|neon))(.*?)\\(\\)',
		'reason': 'Function must exist',
		'fileTypes': ['bash', 'sh'],
		'fixerFn': None,
		'testPositiveMatches': [
			'install.not_exist()'
		],
		'testNegativeMatches': [
			'install.fedora()',
			'curl https://mise.jdx.dev/install.sh | sh'
		],
	})

	[rule.update({ 'found': 0 }) for rule in rules]

	parser = argparse.ArgumentParser()
	parser.add_argument('files', metavar='FILES', nargs='*')
	parser.add_argument('--fix', action='store_true')
	parser.add_argument('--verbose', action='store_true')
	parser.add_argument('--internal-test-regex', action='store_true')
	args = parser.parse_args()

	if args.internal_test_regex:
		for rule in rules:
			for positiveMatch in rule['testPositiveMatches']:
				m: any = re.search(rule['regex'], positiveMatch)
				if m is None or m.group('match') is None:
					print(f'{c.MAGENTA}{rule["name"]}{c.RESET}: Failed {c.CYAN}positive{c.RESET} test:')
					print(f'=> {positiveMatch}')
					print()

			for negativeMatch in rule['testNegativeMatches']:
				m: any = re.search(rule['regex'], negativeMatch)
				if m is not None and m.group('match') is not None:
					print(f'{c.MAGENTA}{rule["name"]}{c.RESET}: Failed {c.YELLOW}negative{c.RESET} test:')
					print(f'=> {negativeMatch}')
					print()
		print('Done.')
		return

	options = {
		'fix': args.fix,
		'verbose': args.verbose,
	}

	# Parse files and print matched lints.
	if len(args.files) > 0:
		for file in args.files:
			p = Path(file)
			if p.is_file():
				lintfile(p, rules, options)
	else:
		for file in Path(os.path.expanduser('~/scripts')).rglob('*'):
			if '.git' in str(file.absolute()):
				continue

			if file.is_file():
				lintfile(file, rules, options)

	# Print final results.
	print(f'{c.UNDERLINE}TOTAL ISSUES{c.RESET}')
	for rule in rules:
		print(f'{c.MAGENTA}{rule["name"]}{c.RESET}: {rule["found"]}')

	grand_total = sum([rule['found'] for rule in rules])
	print(f'GRAND TOTAL: {grand_total}')

	# Exit.
	if grand_total == 0:
		exit(0)
	else:
		exit(2)

main()

#!/usr/bin/env python3
import re
import os
import argparse
from pathlib import Path
from typing import Callable, List, Dict, Any # compat

# This file checks Bash and Shell scripts for violations not found with
# shellcheck or existing methods. You can use it in several ways:
#
# Lint all .bash, .sh, .bats files along with 'bin/asdf' and print out violations:
# $ ./scripts/checkstyle.py
#
# The former, but also fix all violations. This must be ran until there
# are zero violations since any line can have more than one violation:
# $ ./scripts/checkstyle.py --fix
#
# Lint a particular file:
# $ ./scripts/checkstyle.py ./lib/functions/installs.bash
#
# Check to ensure all regular expressions are working as intended:
# $ ./scripts/checkstyle.py --internal-test-regex

# TODO:
# DEBIAN_FRONTEND=noninteractive
# pacman -Syuu --noconfirm
# no sudo yay
# TODO: helper.setup then "$@"
# TODO: test install. regex positive lookahead

Rule = Dict[str, Any]

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

def utilGetStrs(line: Any, m: Any):
	return (
		line[0:m.start('match')],
		line[m.start('match'):m.end('match')],
		line[m.end('match'):]
	)

# Before: apt install
# After: apt-get install
def noAptCommand(line: str, m: Any) -> str:
	prestr, _, poststr = utilGetStrs(line, m)

	return f'{prestr}apt-get {poststr}'

# Before: apt-get install
# After: apt-get -y install
def noAptCommand2(line: str, m: Any) -> str:
	prestr, _, poststr = utilGetStrs(line, m)

	subcmd = m.group('subcommand')
	return f'{prestr}apt-get {subcmd} -y {poststr}'

# Before: sudo yay -S
# After: yay -S
def noAptCommand3(line: str, m: Any) -> str:
	prestr, _, poststr = utilGetStrs(line, m)

	return f'{prestr}yay {poststr}'


# Before: printf '%s\\n' '^w^'
# After: printf '%s\n' '^w^'
def noDoubleBackslashFixer(line: str, m: Any) -> str:
	prestr, midstr, poststr = utilGetStrs(line, m)

	return f'{prestr}{midstr[1:]}{poststr}'

# Before: $(pwd)
# After: $PWD
def noPwdCaptureFixer(line: str, m: Any) -> str:
	prestr, _, poststr = utilGetStrs(line, m)

	return f'{prestr}$PWD{poststr}'

# Before: [ a == b ]
# After: [ a = b ]
def noTestDoubleEqualsFixer(line: str, m: Any) -> str:
	prestr, _, poststr = utilGetStrs(line, m)

	return f'{prestr}={poststr}'

# Before: function fn() { ...
# After: fn() { ...
# ---
# Before: function fn { ...
# After fn() { ...
def noFunctionKeywordFixer(line: str, m: Any) -> str:
	prestr, midstr, poststr = utilGetStrs(line, m)

	midstr = midstr.strip()
	midstr = midstr[len('function'):]
	midstr = midstr.strip()

	parenIdx = midstr.find('(')
	if parenIdx != -1: midstr = midstr[:parenIdx]

	return f'{prestr}{midstr}() {poststr}'

# Before: >/dev/null 2>&1
# After: &>/dev/null
# ---
# Before: 2>/dev/null 1>&2
# After: &>/dev/null
def noVerboseRedirectionFixer(line: str, m: Any) -> str:
	prestr, _, poststr = utilGetStrs(line, m)

	return f'{prestr}&>/dev/null{poststr}'

def lintfile(file: Path, rules: List[Rule], options: Dict[str, Any]):
	content_arr = file.read_text().split('\n')

	for line_i, line in enumerate(content_arr):
		if 'checkstyle-ignore' in line:
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

				print(f'{c.CYAN}{dir}{c.RESET}:{line_i + 1}')
				print(f'{c.MAGENTA}{rule["name"]}{c.RESET}: {rule["reason"]}')
				print(f'{prestr}{c.RED}{midstr}{c.RESET}{poststr}')
				print()

				if options['fix']:
					content_arr[line_i] = rule['fixerFn'](line, m)

				rule['found'] += 1

	if options['fix']:
		file.write_text('\n'.join(content_arr))

def main():
	rules: List[Rule] = [
		{
			'name': 'no-apt-command',
			'regex': '(?P<match>apt )',
			'reason': 'Use apt-get',
			'fileTypes': ['bash', 'sh'],
			'fixerFn': noAptCommand,
			'testPositiveMatches': [
				'apt install',
				'apt update'
			],
			'testNegativeMatches': [
				'apt-get install'
			],
		},
		{
			'name': 'apt-must-have-y',
			'regex': '(?P<match>apt-get (?P<subcommand>install|update|upgrade) (?!-y))',
			'reason': 'To make sure it is automated',
			'fileTypes': ['bash', 'sh'],
			'fixerFn': noAptCommand2,
			'testPositiveMatches': [
				'apt-get install'
			],
			'testNegativeMatches': [
				'apt-get -y install'
			],
		},
		{
			'name': 'no-sudo-yay',
			'regex': '(?P<match>(?<=sudo )yay )',
			'reason': 'yay should not be ran with sudo',
			'fileTypes': ['bash', 'sh'],
			'fixerFn': noAptCommand3,
			'testPositiveMatches': [
				'apt-get install'
			],
			'testNegativeMatches': [
				'apt-get -y install'
			],
		},
		# TODO: curl
		# {
		# 	'name': 'no-',
		# 	'regex': '(?P<match>(>/dev/null 2>&1|2>/dev/null 1>&2))',
		# 	'reason': 'Use `&>/dev/null` instead of `>/dev/null 2>&1` or `2>/dev/null 1>&2` for consistency',
		# 	'fileTypes': ['bash'],
		# 	'fixerFn': noVerboseRedirectionFixer,
		# 	'testPositiveMatches': [
		# 		'echo woof >/dev/null 2>&1',
		# 		'echo woof 2>/dev/null 1>&2',
		# 	],
		# 	'testNegativeMatches': [
		# 		'echo woof &>/dev/null',
		# 		'echo woof >&/dev/null',
		# 	],
		# },
	]
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
				m: Any = re.search(rule['regex'], positiveMatch)
				if m is None or m.group('match') is None:
					print(f'{c.MAGENTA}{rule["name"]}{c.RESET}: Failed {c.CYAN}positive{c.RESET} test:')
					print(f'=> {positiveMatch}')
					print()

			for negativeMatch in rule['testNegativeMatches']:
				m: Any = re.search(rule['regex'], negativeMatch)
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

	# parse files and print matched lints
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

	# print final results
	print(f'{c.UNDERLINE}TOTAL ISSUES{c.RESET}')
	for rule in rules:
		print(f'{c.MAGENTA}{rule["name"]}{c.RESET}: {rule["found"]}')

	grand_total = sum([rule['found'] for rule in rules])
	print(f'GRAND TOTAL: {grand_total}')

	# exit
	if grand_total == 0:
		exit(0)
	else:
		exit(2)

main()

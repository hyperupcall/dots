#!/usr/bin/env python
import os
from pathlib import Path
import subprocess

print('FILES WITH ASCII TEXT:')
dir = os.getenv('PASSWORD_STORE_DIR') if os.getenv('PASSWORD_STORE_DIR') is not None else os.path.expanduser('~/.password-store')
for file in Path(dir).rglob('*.gpg'):
	result = subprocess.run(['file', file], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	if 'ASCII text' in result.stdout.decode('utf-8'):
		content = file.read_text()
		target = None
		if content.startswith('/'):
			target = Path(content).relative_to(dir)
		else:
			target = content

		print('removing', file)
		val = input(f'Remove {file} for symlink to {target}? [y/n]? ')
		if val == 'y':
			os.remove(file)
			os.symlink(target, file)
			print(f'Symlink created at {file}, to {target}')

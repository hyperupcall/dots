# type: ignore
# ruff: noqa
import fnmatch
import os
from albert import *
from pathlib import Path

md_iid = "2.1"
md_version = "1.0"
md_name = "Edwin's Coding Start"
md_description = "Start an IDE session for a coding project."
md_bin_dependencies = ["code"]
md_maintainers = ["@hyperupcall"]
md_license = "MPL-2.0"

class Plugin(PluginInstance, TriggerQueryHandler):
	def __init__(self):
		TriggerQueryHandler.__init__(
			self,
			id=md_id,
			name=md_name,
			description=md_description,
			synopsis="<project-name>",
			defaultTrigger="code ",
		)
		PluginInstance.__init__(self, extensions=[self])
		self.iconUrls = ["xdg:dialog-password"]
		self._editor = self.readConfig("editor", str) or 'code'

	@property
	def editor(self):
		return self._editor

	@editor.setter
	def editor(self, value):
		print(f"Setting _use_otp to {value}")
		self._editor = value
		self.writeConfig("use_otp", value)

	def configWidget(self):
		return [
			{
				"type": "lineedit",
				"property": "editor",
				"label": "Editor to execute.",
				"widget_properties": {"placeholderText": "code"},
			},
		]

	def handleTriggerQuery(self, query):
		org_dir = os.path.expanduser("~/.dotfiles/.home/Documents/Projects/Programming/Organizations")

		paths = []
		if query.string.strip():
			for path in Path(org_dir).glob("*/*/"):
				owner = path.parts[-2]
				project = path.parts[-1]
				if (query.string in owner) or (query.string in project):
					paths.append(f'{owner}/{project}')
		else:
			for path in Path(org_dir).glob("*/*/"):
				owner = path.parts[-2]
				project = path.parts[-1]
				paths.append(f'{owner}/{project}')
		sorted(paths, key=lambda s: s.lower())

		results = []
		for path in paths:
			print(path)
			owner, project = path.split('/')
			dir = str(path)

			full_dir = os.path.join(org_dir, dir)
			results.append(
				StandardItem(
					id=f"{owner}_{project}",
					iconUrls=self.iconUrls,
					text=f"{owner}/{project}",
					inputActionText=f"{owner}/{project}",
					actions=[
						Action(
							'Launch',
							'Do in launch',
							lambda full_dir=str(full_dir): runDetachedProcess([self.editor, full_dir]),
						)
					],
				)
				# StandardItem(
				# 	id='launch_code',
				# 	text=project,
				# 	subtext=project,
				# 	iconUrls=self.iconUrls,
				# 	inputActionText="code %s" % project,
				# 	actions=[
				# 		Action(
				# 			"copy",
				# 			"Copy",
				# 			lambda d=dir: runDetachedProcess([self.editor, d]),
				# 		),
				# 	],
				# ),
			)

		query.add(results)

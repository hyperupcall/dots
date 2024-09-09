# type: ignore
# flake8: noqa
import fnmatch
import os
from albert import *

md_iid = "2.1"
md_version = "1.0"
md_name = "Edwin's Binaries"
md_description = "Launch Edwin's binaries"
# md_bin_dependencies = ["pass"]
md_maintainers = ["@hyperupcall"]
md_license = "MPL-2.0"

HOME_DIR = os.environ["HOME"]
PASS_DIR = os.environ.get("PASSWORD_STORE_DIR", os.path.join(HOME_DIR, ".password-store/"))


class Plugin(PluginInstance, TriggerQueryHandler):
	def __init__(self):
		TriggerQueryHandler.__init__(
			self,
			id=md_id,
			name=md_name,
			description=md_description,
			synopsis="<pass-name>",
			defaultTrigger="run ",
		)
		PluginInstance.__init__(self, extensions=[self])
		self.iconUrls = ["xdg:dialog-password"]
		self._some_path = ''

	@property
	def some_path(self):
		return self._some_path

	@some_path.setter
	def some_path(self, value):
		print(f"Setting _some_path to {value}")
		self._some_path = value
		self.writeConfig("some_path", value)

	def configWidget(self):
		return [
			{
				"type": "lineedit",
				"property": "some_path",
				"label": "Some path for testing",
				"widget_properties": {"placeholderText": "this is epic"},
			},
		]

	def handleTriggerQuery(self, query):
		apps = {
			'default': ''
		}
		query.add(
			StandardItem(
				id="launch_hub",
				iconUrls=self.iconUrls,
				text="Launch hub.woof",
				subtext="Launch hub.woof site in a browser",
				inputActionText="e hub",
				actions=[
					Action(
						"hub",
						"hub.woof",
						lambda: runDetachedProcess(["xdg-open", "http://localhost:49501"]),
					)
				],
			)
		)

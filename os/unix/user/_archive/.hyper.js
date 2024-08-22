module.exports = {
	config: {
		updateChannel: 'stable',

		fontSize: 12,
		fontFamily:
			'Menlo, "DejaVu Sans Mono", Consolas, "Lucida Console", monospace',
		fontWeight: 'normal',
		fontWeightBold: 'bold',
		lineHeight: 1,
		letterSpacing: 0,

		cursorColor: 'rgba(248,28,229,0.8)',
		cursorAccentColor: '#000',
		// `'BEAM'` for |, `'UNDERLINE'` for _, `'BLOCK'` for █
		cursorShape: 'BLOCK',
		cursorBlink: false,

		foregroundColor: '#fff',
		backgroundColor: '#000',
		selectionColor: 'rgba(248,28,229,0.3)',
		borderColor: '#333',
		css: '',
		termCSS: '',

		// if you're using a Linux setup which show native menus, set to false
		// default: `true` on Linux, `true` on Windows, ignored on macOS
		showHamburgerMenu: '',

		// set to `false` (without backticks and without quotes) if you want to hide the minimize, maximize and close buttons
		// additionally, set to `'left'` if you want them on the left, like in Ubuntu
		// default: `true` (without backticks and without quotes) on Windows and Linux, ignored on macOS
		showWindowControls: '',

		padding: '12px 14px',

		// the full list. if you're going to provide the full color palette,
		// including the 6 x 6 color cubes and the grayscale map, just provide
		// an array here instead of a color map object
		colors: {
			black: '#000000',
			red: '#C51E14',
			green: '#1DC121',
			yellow: '#C7C329',
			blue: '#0A2FC4',
			magenta: '#C839C5',
			cyan: '#20C5C6',
			white: '#C7C7C7',
			lightBlack: '#686868',
			lightRed: '#FD6F6B',
			lightGreen: '#67F86F',
			lightYellow: '#FFFA72',
			lightBlue: '#6A76FB',
			lightMagenta: '#FD7CFC',
			lightCyan: '#68FDFE',
			lightWhite: '#FFFFFF',
		},

		shell: '',
		shellArgs: [],
		env: {},
		bell: 'SOUND',

		copyOnSelect: false,
		defaultSSHApp: false,
		quickEdit: false,
		macOptionSelectionMode: 'vertical',

		// bellSoundURL: 'http://example.com/bell.mp3',
		webGLRenderer: true,
	},

	// a list of plugins to fetch and install from npm
	// format: [@org/]project[#version]
	// examples:
	//   `hyperpower`
	//   `@company/project`
	//   `project#1.0.1`
	plugins: [
		'hypercwd',
		'hyper-search',
		'hyper-pane',
		'hyperline',
		'hyper-tabs-enhanced',
		'hyper-statusline'
		'hyperpower',
		'hyper-solarized-dark',
		// 'hyperterm-base-16-ocean',
		// 'hyperterm-monokai',
		// 'hyper-material-theme',
		// 'hyper-solarized-light',
		// 'hyper-dracula',
	],

	// in development, you can create a directory under
	// `~/.hyper_plugins/local/` and include it here
	// to load it and avoid it being `npm install`ed
	localPlugins: [],

	keymaps: {
		// 'window:devtools': 'cmd+alt+o',
	},
};

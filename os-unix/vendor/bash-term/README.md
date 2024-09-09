# bash-term

Bash library for terminal escape sequences

## Summary

Includes functions to print standard ANSI escape sequences

## Installation

Use [Basalt](https://github.com/hyperupcall/basalt), a Bash package manager, to add this project as a dependency

```sh
basalt add hyperupcall/bash-term
```

## Usage

See [Tweet](https://twitter.com/hyperupcall/status/1553612233388670976)

```sh
# -d means 'done'; that is, reset the style at the end of the string (same as `term.style_reset`)
# -p means 'print'; that is, print the value of "$REPLY" that it sets
# -P is similar to -p, but print with an appended newline
term.color_light_purple 'four'
term.style_strikethrough "$REPLY"
term.style_inverse "$REPLY"
term.style_underline -dp "$REPLY"
```

## References

- [vtasni.html](https://www2.ccs.neu.edu/research/gpc/VonaUtils/vona/terminal/vtansi.htm)
- [ansi-escapes](https://github.com/sindresorhus/ansi-escapes/blob/main/index.js)
- [ANSIcode.html](https://www.real-world-systems.com/docs/ANSIcode.html)
- [terminalcodes](https://wiki.bash-hackers.org/scripting/terminalcodes)
- [StackOverflow/20983251](https://stackoverflow.com/a/20983251)
- [dylanaraps/writing-a-tui-in-bash](https://github.com/dylanaraps/writing-a-tui-in-bash)

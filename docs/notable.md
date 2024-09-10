# Notables

The following scripts are notable and may be of use:

## [`generate-aliases`](/os-unix/scripts/utility/generate-aliases)

Script that automatically generates bash startup scripts
for remote servers and the root user based on annotations of functions, aliases, and readline declarations
of the current dotfiles

## [`readline.sh`](/os-unix/config-shell/.config/bash/modules)

Special Bash readline bindings that includes many convenient functionality that include:

- Alt+M to bring up man page (of command/alias currently being edited)s
  - extremely useful, as you can view a man page without having to switch readline editing buffers
- Alt+H to print help menu (of command/alias currently being edited)
  - extremely useful, as you can view arguments and flags quickly
- Alt+S to toggle sudo
- Alt+/ to toggle comment
- Alt+\ to toggle backslash

It calls more general functions that can be found at [`line-editing.sh`](/os-unix/config-shell/.config/shell/modules/common/line-editing.sh)

## [`mkt.sh`](/os-unix/config-shell/.config/shell/modules/functions/mkt.sh)

Quick command to automatically do something in a temporary space. Based on the first argument, it will

- (blank) => cd to new random directory in tempfs (`cd "$(mktemp -d)"`)
- (file/folder) => copy file/folder to new random directory in tempfs, and cd/ls to it
- (git repository) => clone (optionally sparse) repo to new random directroy in tempfs, and cd/ls to it
- (internet file) => curl file to new random directory in tempfs, and cd/ls to it

It will create a history of invocations at `$XDG_STATE_HOME/history/mkt_history`

## [`xdg.sh`](/os-unix/config-shell/.config/shell/modules/xdg.sh)

Contains environment variables and alises that make programs more XDG-compliant. At around ~500 lines, it will reduce the chances that files and folders such as `.go`, `.z`, `.wine`, `.rvm` will be created in your home directory. It places them in `$XDG_CONFIG_HOME`, `$XDG_STATE_HOME`, `$XDG_DATA_HOME`, `$XDG_RUNTIME_DIR`, etc. instead

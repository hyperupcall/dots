# Installation (Windows)

## Bootstrapping

Download and execute `bootstrap.ps1` to begin the bootstrap process:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
New-Item -Type Directory -Force ~/.bootstrap >$null
Invoke-WebRequest -UseBasicParsing -Uri 'https://raw.githubusercontent.com/hyperupcall/dotfiles/main/os/windows/bootstrap.ps1' -OutFile ~/.bootstrap/bootstrap.ps1
~/.bootstrap/bootstrap.ps1
```

The `bootstrap.ps1` script performs the following steps:

- Installs [Scoop](https://scoop.sh)
- Installs sudo, Git, and Neovim
- Installs Cargo and Rust
- Clones `hyperupcall/dotfiles` to `~/.dotfiles`
- Creates a `~/.bootstrap/bootstrap-out.ps1`; sourcing it does the following:
  - Sets `NAME`, `EMAIL`, `EDITOR`, `VISUAL`
  - Appends `$HOME/.dotfiles/.data/bin` to `PATH`

Then, run the following:

```powershell
. ~/.bootstrap/bootstrap-out.ps1
```

Now, execute:

```powershell
~/scripts/doctor.ps1
~/scripts/bootstrap.ps1
~/scripts/idempotent.ps1
```

# dotfiles

Shell and tool configuration for my Linux machines.

`home/` mirrors `$HOME`. Each tracked file is a symlink from `$HOME` into this
clone, created with [GNU Stow](https://www.gnu.org/software/stow/). Editing a
file in place edits the clone, so `git status` shows every change.

## Layout

| Path       | Content                                                        |
| ---------- | -------------------------------------------------------------- |
| `home/`    | Live files, at the same relative path they have under `$HOME`. |
| `.stowrc`  | Stow options: target `~`, one symlink per file.                |
| `legacy/`  | macOS setup from 2016 to 2020 (tmux, Neovim, iTerm). Unlinked. |

## Commands

Run them from the root of the clone, with no `-d` or `-t` option: `.stowrc` is
read from the current directory.

| Goal                              | Command              |
| --------------------------------- | -------------------- |
| Check the links without changing  | `stow -n -v home`    |
| Create missing links              | `stow home`          |
| Take over a file that has content | `stow --adopt home`  |
| Remove the links                  | `stow -D home`       |

`stow -n -v home` exits 0 and prints only `WARNING: in simulation mode so not
modifying filesystem.` when every link is in place. A `LINK:` line, still with
exit 0, means a link is missing; `stow home` creates it. Exit 1 with a conflict
report means a tool replaced a symlink with a regular file.
`stow --adopt home` moves that file into the clone, over the tracked version,
and links it again; review the result with `git diff` and discard unwanted
content with `git restore home`.

## New machine

```sh
sudo pacman -S --needed stow
git clone git@github.com:ferhtgoldaraz/dotfiles.git ~/code/dotfiles
cd ~/code/dotfiles
stow -n -v home
stow home
```

Stow exits 1 and creates no link when a target already exists as a regular
file. A new CachyOS user has three: `.bash_profile`, `.bashrc` and
`.config/fish/config.fish`. Move them away, or run `stow --adopt home` and then
`git restore home`: adopt replaces the tracked version with the file from the
machine, and the restore brings the tracked version back.

The files expect mise at `~/.local/bin/mise`, the Vite+ `env` file at
`~/.config/vite-plus/env`, and a clone of
`git@github.com:ferhtgoldaraz/zsh-shims.git` at `/home/fer/code/zsh-shims`.
Until they exist, shells print errors at startup, Zim loads no module, and a
POSIX `sh` that reads `~/.profile` exits.

## PATH

`home/.config/shell/env.sh` is the one file that adds user directories to
`PATH` for bash, zsh and POSIX `sh`. It exports the variables of
`.config/environment.d/10-shared.conf`, then puts each directory of its list in
front of `PATH` unless `PATH` already holds it, so a second run changes
nothing. `.profile`, `.bashrc` and `.config/zsh/.zshenv` source it. Add a
directory to its list, not to those files.

Four cases stay outside it:

- `bash -c` and `sh -c` normally read no startup file and keep the `PATH` they
  inherit.
- fish keeps its own setup in `.config/fish/config.fish`.
- The Vite+ `env` file, which `.profile`, `.bashrc`, `.zshenv` and `.zshrc`
  source after it, moves `~/.local/share/vite-plus/bin` to the front and
  appends `~/.local/share/vite-plus/fallback-bin`.
- An interactive bash or zsh then runs `mise activate`, which replaces the
  shims directory with the directories of the installed tools.

A graphical session takes the new order at the next login.

## Checks

Run them from `~`, through the links. Each one exits 0 and prints nothing.

```sh
cd ~
shellcheck -s bash -x -o all .bashrc .bash_profile
shfmt -d -s .bashrc .bash_profile
shellcheck -s sh -x -o all .config/shell/env.sh
shfmt -d -s .config/shell/env.sh
```

## Rules

- The clone is live. Keep it on `master`; use `git worktree add` for other
  branches, because switching branch changes the files that shells read.
- This repository is public. Secrets, tokens, and private identifiers stay out.
- Files that a tool regenerates on its own stay out, such as the `env` files
  written by the rustup and Vite+ installers. Three tracked files are written
  by a tool on request, through the symlink: mise edits
  `.config/mise/config.toml`, `p10k configure` regenerates
  `.config/zsh/.p10k.zsh`, and the DMS installer overwrites
  `.config/environment.d/90-dms.conf`. Review `git diff` after running them.

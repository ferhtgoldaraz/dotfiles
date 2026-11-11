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

Run them from the root of the clone.

| Goal                              | Command              |
| --------------------------------- | -------------------- |
| Check the links without changing  | `stow -n -v home`    |
| Create missing links              | `stow home`          |
| Take over a file that has content | `stow --adopt home`  |
| Remove the links                  | `stow -D home`       |

`stow -n -v home` prints nothing and exits 0 when every link is in place. It
reports a conflict when a tool replaced a symlink with a regular file.
`stow --adopt home` moves that file into the clone and links it again; review
the result with `git diff`.

## New machine

```sh
sudo pacman -S --needed stow
git clone git@github.com:ferhtgoldaraz/dotfiles.git ~/code/dotfiles
cd ~/code/dotfiles
stow -n -v home
stow home
```

Stow stops when a target already exists as a regular file. Move that file away
or take it over with `stow --adopt home`.

## Rules

- The clone is live. Keep it on `master`; use `git worktree add` for other
  branches, because switching branch changes the files that shells read.
- This repository is public. Secrets, tokens, and private identifiers stay out.
- Files that a tool owns and rewrites stay out, such as the `env` files
  written by the rustup and Vite+ installers.

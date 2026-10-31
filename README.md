# dotfiles

Config for bash, vim, tmux, ghci and stack.

Plugins are **not** stored in this repo. The configs list which plugins to use,
and the plugin managers download them:

- **vim** uses [vim-plug](https://github.com/junegunn/vim-plug). Plugins are the
  `Plug '...'` lines near the bottom of `.vimrc`, installed to `~/.vim/plugged`.
- **tmux** uses [tpm](https://github.com/tmux-plugins/tpm). Plugins are the
  `set -g @plugin '...'` lines in `.tmux.conf`, installed to `~/.tmux/plugins`.

## Setting up a new machine

```bash
# 1. Get the repo (any location works; the links point wherever it is)
git clone git@github.com:lunky/dotfiles.git ~/dotfiles

# 2. Link everything into ~, create ~/.tmp, and install vim plugins
~/dotfiles/install.sh

# 3. Start tmux. It installs tpm and its plugins itself
tmux

# 4. Haskell tools used by vim (hlint-refactor-vim), ghci (:hlint) and the
#    stacktest bash function (after ghcup is installed, see below)
stack install hlint apply-refact ghcid
```

`install.sh` links each file in the repo to the same path under `~`, e.g.
`~/.vimrc -> ~/dotfiles/.vimrc`. It never overwrites a real file; it reports it
as `SKIP` instead. Options:

- `./install.sh -n` is a dry run that only shows what it would do.
- `./install.sh -b` moves existing files to `<name>.bak` first, then links.

It's safe to run again any time, e.g. after adding a new dotfile to the repo.

### Things these configs expect to be installed

- **[fancy-git](https://github.com/diogocavilha/fancy-git)**, for the bash
  prompt. Without it you get the plain Ubuntu prompt.
- **[fnm](https://github.com/Schniz/fnm)**, the Node version manager. coc.nvim in
  vim also needs Node, or vim will show an error at startup.
- **[ghcup](https://www.haskell.org/ghcup/)**, for the Haskell toolchain (ghc,
  cabal, stack).
- **hlint** and **refactor** (from `apply-refact`), installed by step 6 into
  `~/.local/bin`. hlint-refactor-vim (`<leader>to` / `<leader>ta`) and ghci's
  `:hlint` command use them.
- **ghcid**, also installed by step 6. The `stacktest` function in `.bashrc`
  uses it to re-run a project's tests every time you save.

`.bashrc` skips fancy-git, fnm and ghcup when they're missing.

The vim clipboard mappings (`Ctrl-Insert`, `Ctrl-y`, `<leader>tc` inside tmux)
use `clip.exe`, so they only work under WSL. On other systems they're skipped.

Login shells use Ubuntu's default `~/.profile`, which loads `~/.bashrc`.

## Machine-specific settings

Put anything that only applies to one machine (work settings, secrets, one-off
`PATH` entries) in `~/.bashrc.local`. `.bashrc` loads it at the end if it exists,
and it's not part of this repo, so it doesn't leak into other machines.

## Adding or removing plugins

- **vim:** add or delete a `Plug 'owner/repo'` line in `.vimrc`, then run
  `:PlugInstall` (to add) or `:PlugClean` (to remove). `:PlugUpdate` updates
  everything.
- **tmux:** add or delete a `set -g @plugin 'owner/repo'` line in `.tmux.conf`,
  then press `prefix + I` to install, `prefix + alt + u` to remove, or
  `prefix + U` to update.

## Editing dotfiles

Because `~/.vimrc` and the rest are symlinks, editing either `~/.vimrc` or the
repo copy edits the same file. Commit from the repo as usual. To add a new
dotfile, move it into the repo at the same relative path and run `install.sh`.

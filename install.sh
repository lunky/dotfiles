#!/usr/bin/env bash
# Link every file in this repo (except git-ignored ones) into $HOME, then install vim plugins.
#
#   ./install.sh        link files; skip any that already exist in ~
#   ./install.sh -n     dry run: only show what would happen
#   ./install.sh -b     move existing files in ~ to <name>.bak, then link
#
# Safe to run again: files that are already linked are left alone.

set -euo pipefail

repo=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
dry_run=0
backup=0
case "${1:-}" in
    -n) dry_run=1 ;;
    -b) backup=1 ;;
    "") ;;
    *) echo "usage: $0 [-n | -b]" >&2; exit 2 ;;
esac

# Repo files that are not dotfiles
skip='^(README\.md|install\.sh|\.gitignore)$'

conflicts=0
while IFS= read -r file; do
    [[ $file =~ $skip ]] && continue
    src="$repo/$file"
    dst="$HOME/$file"

    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        continue  # already linked
    fi

    if [ -e "$dst" ] || [ -L "$dst" ]; then
        if [ $backup = 1 ]; then
            echo "backup  $dst -> $dst.bak"
            [ $dry_run = 0 ] && mv "$dst" "$dst.bak"
        else
            echo "SKIP    $dst already exists (move it aside, or re-run with -b)"
            conflicts=1
            continue
        fi
    fi

    echo "link    $dst"
    if [ $dry_run = 0 ]; then
        mkdir -p "$(dirname "$dst")"
        ln -s "$src" "$dst"
    fi
done < <(git -C "$repo" ls-files --cached --others --exclude-standard)

[ $dry_run = 1 ] && exit $conflicts

# vimrc keeps backup and swap files here
mkdir -p "$HOME/.tmp"

if command -v vim >/dev/null; then
    echo "Installing vim plugins..."
    vim -Es -u "$HOME/.vimrc" -c 'PlugInstall --sync' -c 'qa' || true
fi

echo
echo "Done. tmux installs its own plugins the first time it starts."
echo "Tools to install yourself are listed in README.md."
[ $conflicts = 0 ] || { echo "Some files were skipped, see SKIP lines above."; exit 1; }

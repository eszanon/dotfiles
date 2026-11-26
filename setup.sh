#!/bin/bash
set -e

# Stow dotfiles (adopt existing files into the dotfiles directory)
# stow --adopt .

# Private submodules (work/personal); non-fatal on machines without access
git -C "$(dirname "$0")" submodule update --init || echo "warn: could not init submodules"

stow .

# Agent skills -> ~/.claude/skills and ~/.agents/skills
"$(dirname "$0")/agents/link-skills.sh"

# Create zsh symlinks
ln -sf $HOME/.config/zshrc/.zshrc $HOME/.zshrc
ln -sf $HOME/.config/zshrc/.zsh_profile $HOME/.zsh_profile

echo "Setup completed successfully!"

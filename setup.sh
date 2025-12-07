#!/bin/bash
set -e

# Stow dotfiles (adopt existing files into the dotfiles directory)
# stow --adopt .

stow .

# Create zsh symlinks
ln -sf $HOME/.config/zshrc/.zshrc $HOME/.zshrc
ln -sf $HOME/.config/zshrc/.zsh_profile $HOME/.zsh_profile

echo "Setup completed successfully!"
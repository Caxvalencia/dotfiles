if ! command_exists zsh; then
  echo_info "zsh not installed, trying to install"
  brew install zsh
  echo_success "zsh installed"
fi

if ! command_exists p10k; then
  echo_info "Powerlevel10k is a theme for Zsh not installed, trying to install"
  
  brew install romkatv/powerlevel10k/powerlevel10k
  echo "source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc

  brew install zsh-syntax-highlighting
  echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >>~/.zshrc

  echo_success "Powerlevel10k installed!"
fi

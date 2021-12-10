if ! command_exists zsh; then
  echo_info "zsh not installed, trying to install"
  brew install zsh
  echo_success "zsh installed"
fi

# INSTALL OH-MY-ZSH
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

if ! command_exists p10k; then
  echo_info "Powerlevel10k is a theme for Zsh not installed, trying to install"

  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

  brew install zsh-syntax-highlighting
  echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >>~/.zshrc

  echo_success "Powerlevel10k installed!"
fi
